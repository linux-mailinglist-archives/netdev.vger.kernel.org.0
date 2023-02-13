Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061C86947FB
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 15:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjBMO1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 09:27:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjBMO1t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 09:27:49 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7071E18F;
        Mon, 13 Feb 2023 06:27:48 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id r8so13688596pls.2;
        Mon, 13 Feb 2023 06:27:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gUMVK42K/OfaydLM3bdATc+ebs3LStXBNbFNwliwCvM=;
        b=ZihY2G98T5Haaa5CEudxBlJKul8ap621t9LZItPEP+2HdoburrtT7y6xyHuhsmcrS0
         d+CfEF+o80qcu53nE0DdL+buQPUtQEGMHk4qqVg0CFnqvyNSdbYw5ufjUsTMdtQ9Zgv9
         ZkCMMA7JClO2den15bbo7p6369Dho7ZFATNRNqxPUp8NdjRLE9UUHqwLECRGfs62MuVD
         rkZnD2tNdEWl34bpV6b91j3Dl+HCN1rJZ5obsEiP80186Q6IVRjVCDxGxxtBrOO3RQmD
         uWlIPA6ZuwYyFt1zDzIIouRt1rOOnoqk6NP5ZLh96mYfF5Gx3/+dXOTievhlBHwjvW12
         DsWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gUMVK42K/OfaydLM3bdATc+ebs3LStXBNbFNwliwCvM=;
        b=HROQwN3aJbizU1DGGoQQJjc3fLiqGGoGLMw8o5N6IgPsP/gPFu0hnzr4mh0YYE3swZ
         ZEekAN0DBxnpstW/hotpxm28CB0Fi0GPOmzCHn/eT3XziwOz7ARIk+D0xSCg1xxW6HLp
         +pm1O+2P9ai4E7fNTKOTACatHiZAY14To5hhFsngjEYjcAWSD6h1ai1lR4ovS1EPmcrz
         jI998Hys87TiXPqK303JnGAvvMfvN/1x+IrnpgRAMJ7h5ILgMXqqZntKZttg+xHbbrQB
         R0G4eQzKusHJ/+Y67lV9c0XS+pHx8ZUMfkRWZ+GKC/6naKhZB58tk5KjPhzypQu5rNRt
         d1uQ==
X-Gm-Message-State: AO0yUKWOv/cxHuwBN39OHbkCiiThXovZDUCP/xgnIyI/2Y/spDynx3Tw
        50tjM+cGJ1pBCEAxw5OlVApSyjTudktO
X-Google-Smtp-Source: AK7set+Y7hnjlgqAoZusa+ZFytb0Seciij331Zv8j10Ih/IV8l6795vnIG2Q2XiSd+ViwqC1IzhfoQ==
X-Received: by 2002:a05:6a21:3815:b0:bd:f7a:ef06 with SMTP id yi21-20020a056a21381500b000bd0f7aef06mr19687906pzb.47.1676298467909;
        Mon, 13 Feb 2023 06:27:47 -0800 (PST)
Received: from 8888.icu ([165.154.226.86])
        by smtp.googlemail.com with ESMTPSA id i20-20020aa78b54000000b00580e3917af7sm8029756pfd.117.2023.02.13.06.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 06:27:47 -0800 (PST)
From:   Lu jicong <jiconglu58@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8192ce: fix dealing empty eeprom values
Date:   Mon, 13 Feb 2023 14:27:35 +0000
Message-Id: <20230213142735.2169400-1-jiconglu58@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <pkshih@realtek.com>
References: <pkshih@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This looks weird to me. Why does hardware could be programmed improper eeprom?> Where do you get the hardware? Can I have a picture of this module privately?
> I think we only need to support MP hardware.

This is a wireless router with soldered rtl8192ce chip. 
It's an MP hardware too, with empty eeprom.
I don't know why they didn't write anything to the eeprom.
As far as I know, another person also reported this problem on an embedded
system.
I think add support for these devices have no disadvantage.
