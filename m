Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6D96AB16A
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 17:49:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbjCEQrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 11:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCEQrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 11:47:18 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FC21026D
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 08:47:16 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i5so7723285pla.2
        for <netdev@vger.kernel.org>; Sun, 05 Mar 2023 08:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112; t=1678034836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8CGQ0+gwdQ3evaNuyAGcInX2XmXpACBAvytALAzo3o=;
        b=TdtFnYme1tZgNNo/JeLiyK1SSuV6jUDfVy6FCqg8WGde0F3s+gqJCfuC1YUDFOANHk
         2ejrjprYYf82F4XL1ZGsPwfkKsD4vWF6S6G21GDBzoHh/VP0tXxP8OkMP3TQttvoEWFn
         t6Uc4OoVgw5OLhNdlUgzh3fEy7MqfpmxbcDJuUi65ZhCpLO8Bz17GoB+eK2VuShikwLs
         U3s54jIUaRkUiL+kqLs2khgELHpUpAxWt5DBBTjQB2mO+bYquMc8ozzNtnziTNrBVtcu
         9VMxDNwRZ4XDf5g3eEQqedmW4Vo9klJ+h+icYLHvX6a9hJ/NiEF6k1TZMRgbt0GIR/zR
         BfnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678034836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8CGQ0+gwdQ3evaNuyAGcInX2XmXpACBAvytALAzo3o=;
        b=ZvzfyQPuTUNB93/kdaHgS2/16Q0I3iAPQj+dMK+2lglPFwarrsmqqdjtYEp7r7AyBl
         wgM7tcF1AtZOL8LVzBL8ePJMBc6Xy0D3FyXKziAZiynQwv/S2bFCCzuifW7qJ1yt/rOz
         CKJbmUtpXYvkzYYjeES/C8m4zsOdyFtx0+GBNN9Z8KUSr65nc4tI31DQzNKiDMr1wOdZ
         fvQWXiJJPXvZ7pyeDeYQSmpTG+NJxl2Rg0e90MVCkaUrLUbQoO2CTCnMb4nPyJL7veQI
         EAPnbJmsHGPFbvqI48eF9SqUnifN5yghAQ1fbqClCJDNm71c9iGfKNIxYR1irC1vRQ09
         ou1Q==
X-Gm-Message-State: AO0yUKXA8m9i1jrAoZXtMl2X1zv1UPWbnloutD1bQP1CH5yaC2Yu3JOu
        qjOj30aTk/SskCt8p9Svzhq3XroGQ91iAefgtT06wg==
X-Google-Smtp-Source: AK7set8r3P+K9bLpK7IaCLOTKW25unYlSToOKjf/HQnef3pk3VkeLgEUqKGc/98YyJ3r6ustmK4OIQ==
X-Received: by 2002:a17:903:24d:b0:19e:76b7:c7d2 with SMTP id j13-20020a170903024d00b0019e76b7c7d2mr10558673plh.26.1678034836201;
        Sun, 05 Mar 2023 08:47:16 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u5-20020a170902e80500b0019a8468cbe7sm4905366plg.224.2023.03.05.08.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Mar 2023 08:47:16 -0800 (PST)
Date:   Sun, 5 Mar 2023 08:47:14 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com
Subject: Re: [PATCH iproute2 v2 3/3] tc: m_nat: parse index argument
 correctly
Message-ID: <20230305084714.1bf8fb11@hermes.local>
In-Reply-To: <20230227184510.277561-4-pctammela@mojatatu.com>
References: <20230227184510.277561-1-pctammela@mojatatu.com>
        <20230227184510.277561-4-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Feb 2023 15:45:10 -0300
Pedro Tammela <pctammela@mojatatu.com> wrote:

> Fixes: fc2d0206 ("Add NAT action")
In future use more characters for fixes line. Current checkpatch
complains:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: fc2d02069b52 ("Add NAT action")'
#426: 
Fixes: fc2d0206 ("Add NAT action")
