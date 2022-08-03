Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3898C588F50
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 17:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbiHCP0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 11:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234349AbiHCP0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 11:26:00 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA9D31231
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 08:25:59 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id d65-20020a17090a6f4700b001f303a97b14so2458088pjk.1
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 08:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P3MwT8RxWlfV3wpA9WW8i5Tj4HpW55bnnVr/PdyMB4I=;
        b=VfANRgJeiS4RAYWJ+lx4c3oof8oa8aGnYXPW1Z8Y+25df8rCIn0PKntj1Oat2tn9G7
         zr3IkkLV7vL0lMaBCvXmpIeaeHwqpBiciwsE4hgV109fO6E3lintyLCbEHLufMC3Om27
         mD077fzLXIWeDmBnZSFsfWiLlJAlev22CzckAoetfWvqBy+4HivRSDn/vSi+xV4jq0E1
         NiHLeeVuCa7PUf6fdd/KNQA85SHpNuS85a6WpgYifb175Fs9TKQ45Wzk8V9dzzq2oC4L
         Dz3CerVpssamcrxJ7VVDuU8kKkOJTdofvXjtTELj9SZCv2Txq3MjtiYNb5x/ofm7pXwU
         Z7sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P3MwT8RxWlfV3wpA9WW8i5Tj4HpW55bnnVr/PdyMB4I=;
        b=VMoGwlz/Y2TsnybNSMRzoMqfXZ6ZbzpSxuWwNBE2BYNE/gwtSyjqlV0NwjOmFTp6DJ
         tdKFxDmBjMzRAYvx5LwuqDbcc5L0fx+w4OPzXsEHhbzPnb2AZcVROC+FXKvOoH4VUPio
         dRTDGdJrKarly2nnd163XpS8WS/TRpRGFQnUwW2NUPSnI2SGghdtjFhcsMIW4oFC07HV
         xioKAGJRb0EJuizFGIcOpR/ntef+Bxzg9yzHTfPb8gua8LUAchy1FGLmWqto215j+B3y
         TWLWeuxQTjkvierFlA9BY6g/bIoP55cJi1NU1rxLVFk5MdhOEJ1rZBCqPX+cdO9TkRaE
         jmtQ==
X-Gm-Message-State: ACgBeo3PJW1LT2P477QJ6OslipYfPuz7afSkxUpFL8YeTN+LBlRfYrih
        HMTKH4Eyz0VJSn+nWcP2lt/EBA==
X-Google-Smtp-Source: AA6agR5TVipAI8STdCnpVHaOetmvjzFSR3fSK0E0sbLZw5BPy21agJNc8/qVGGuqfSC/C3kIuYwD1w==
X-Received: by 2002:a17:90b:3ec1:b0:1f5:15a6:aaf5 with SMTP id rm1-20020a17090b3ec100b001f515a6aaf5mr5468741pjb.123.1659540359337;
        Wed, 03 Aug 2022 08:25:59 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id mn19-20020a17090b189300b001f4f40763b1sm1766641pjb.29.2022.08.03.08.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 08:25:59 -0700 (PDT)
Date:   Wed, 3 Aug 2022 08:25:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     sunsuwan <sunsuwan3@huawei.com>
Cc:     <netdev@vger.kernel.org>, <chenzhen126@huawei.com>,
        <liaichun@huawei.com>, <yanan@huawei.com>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: Re: [PATCH] bridge-utils:close socket before exit
Message-ID: <20220803082557.451637d4@hermes.local>
In-Reply-To: <20220803082051.1704227-1-sunsuwan3@huawei.com>
References: <20220803082051.1704227-1-sunsuwan3@huawei.com>
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

On Wed, 3 Aug 2022 16:20:51 +0800
sunsuwan <sunsuwan3@huawei.com> wrote:

> brctl should close socket before exit.
> 
> Signed-off-by: sunsuwan <sunsuwan3@huawei.com>

Why bother? The file descriptor is closed automatically on process exit.

At this point bridge-utils is in long term hibernation mode.
It has been replaced by bridge command in iproute2.

Don't want to do any changes or releases unless there is a very high priority
bug that must be fixed.
