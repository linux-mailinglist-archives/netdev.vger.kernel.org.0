Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452EB538795
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238918AbiE3Sze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243100AbiE3SzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:55:18 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED9D4F9FD;
        Mon, 30 May 2022 11:55:16 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id e25so5182088wra.11;
        Mon, 30 May 2022 11:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Sjq+zhjt3oCdhRwlc6XHlvBFai3CbF2klJFSbntyk2Q=;
        b=WHV5Zhuoyb9Bcn7c6kyXJ12eTWIWcl5yQzbJVizjDEYh3hNyUIMD7ZsUusanfVifAw
         GkQngBgaV1SBlq18DyGsvYINh+hb9o8no3RCWnYEX7jaFpQWeK9Vix8rirOsZXnXsq89
         X68gciCor65mJEZ4zUC/hni51CxeJ0CPk10fA3Xh0o0UbMYtIcTY8i7IBxX2CXXs36LH
         tJoBZCw7xalbTfYuEs7dOpGLURPdwT3JSmsXbnz0VG8KC4eBTaXp3+8kz4nmiumCjArP
         nYqZzDYCFe3nh9ECiOMMefv5sY6Q76flRaRuv7CwHy0Y4+0arOQD41qorUgACg6dsm5l
         bZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Sjq+zhjt3oCdhRwlc6XHlvBFai3CbF2klJFSbntyk2Q=;
        b=RbW1EabzfWJ3L31PO+kwoeiqfQrxnl7nMc80XpVDyvu1trrUU2d3OSJatY/JmasoLA
         A3x6QdwhGIGDpFeRwt9zod3I9GuuCmG1icxfVuaQV+1BISXDke11aqFzpoyiVUT9j7XU
         I5woKMITeu9q2aNmAOtyC6dohZDRgQdHbgFo8otmotWQMVynSMVNT5ez8o1QJa+iUmkC
         zaC3aokwItUxdGz9H9mCsRMsRRTB+TL3CjipUtqRuerUDHhrISgDJdOE+r40Jew2ke/x
         VXUkqGzFzCjdTabMjGnfooeFEg94/rvg1hcErWpLTXxNFdZ8RWrjgqLG3qpkLOk5DsIm
         sbNA==
X-Gm-Message-State: AOAM533TKWwHkkSBIILlhrrW8aIAY0R2tOtAkRklf9sdYhNo8lTAdk1Z
        jYr39yKqXiVlngkdpsEsYgM=
X-Google-Smtp-Source: ABdhPJxfvmZOPCqBf8PcUvO3+JEJvHPcWNIXf08IbPhQaa9PBU+9Vxygwrc/dLXfR1bv1BJJVTWtiw==
X-Received: by 2002:a5d:6d84:0:b0:20e:7376:e13b with SMTP id l4-20020a5d6d84000000b0020e7376e13bmr45805753wrs.32.1653936915505;
        Mon, 30 May 2022 11:55:15 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id u2-20020adfdb82000000b002102e6b757csm6032139wri.90.2022.05.30.11.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 11:55:15 -0700 (PDT)
Date:   Mon, 30 May 2022 20:55:13 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     None <conleylee@foxmail.com>, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] sun4i-emac.c: add dma support
Message-ID: <YpUTETTNhRwooOMA@Red>
References: <tencent_DE05ADA53D5B084D4605BE6CB11E49EF7408@qq.com>
 <164082961168.30206.13406661054070190413.git-patchwork-notify@kernel.org>
 <YpRNQlPHiuNoLu3J@Red>
 <20220530114819.551f3d2f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220530114819.551f3d2f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le Mon, May 30, 2022 at 11:48:19AM -0700, Jakub Kicinski a écrit :
> On Mon, 30 May 2022 06:51:14 +0200 Corentin Labbe wrote:
> > Any news on patch which enable sun4i-emac DMA in DT ?
> 
> Who are you directing this question to and where's that patch posted?

I am sorry, I fail to set the right "to:"
My question was for Conley Lee.

This serie was applied but the DT part was never posted.
So sun4i-emac can handle DMA but is not enabled at all.

The DT patch is easy, so without answer, I will send it.

Regards
