Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1575A4066
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 02:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiH2Aix (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 20:38:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiH2Aiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 20:38:52 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7906730F7A
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 17:38:51 -0700 (PDT)
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com [209.85.219.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id AA29B3F11B
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 00:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661733527;
        bh=4PvcaSn9SR/N2+L+4sbnNGR1gZv1OGDCz0dIwBtUT4M=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=DLRRa8u7L0ZNOzghawbr36hyRvwKSspfDPfYZRiDnku6SrSDVeNmYBv0syZ9ptxD1
         XXdDEU4I6lt+AmEl3xCkNJlZ0YG5tQx1ZPzUDWcb2THbQDC0zRN/8Z2Ft7okIU50Ms
         SGD3SSrqNXANMHrp+t3P9bakmmbX1tOF0yMLQWpD4HzDt/3k8QmJg4pL8xNhUJsR1e
         pY7athD+t89T6QNCQiyT6cOzntVpiriDjr8KRQkuiL4/xaopQ050qcC85j6KKHyinZ
         FvN2bJF5sz4X1/C6DOA8UXvgcI/I01+Rf7bAXUIVQxm/KMKQgDII/klJ53D4vGP+W/
         quWHRLzl60fQA==
Received: by mail-qv1-f69.google.com with SMTP id e17-20020ad44431000000b00498f6fa689eso2035098qvt.9
        for <netdev@vger.kernel.org>; Sun, 28 Aug 2022 17:38:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=4PvcaSn9SR/N2+L+4sbnNGR1gZv1OGDCz0dIwBtUT4M=;
        b=5FxcssEBtpDTRkR7t6uTcV6ztgucBPBISMRCeZbjcR5aPxwPkxiA6rEP83ntN37C1v
         a3oOJkO1iTP7vAURbL45NXnBu2kjAaWpYwdkssPxjV/DVcooGcCKwKqp3MqH8R5zw8Az
         kq5Y8WuxFgiS+XOum/XWSbo9Lot5l0tBd4shagG7i2KGnNCDTjTDykeK8gf7ZKINsVdH
         RKWsVRyBLLfZJc9l1SD/9bVjMPiMtAbyux8uqkIOkI8V3zJtlQIN99vDGz0sZcbx5YNS
         mGF37FK41a6P2QPlVSHks6j2Dei1N+wrnvukGi81NS+Bw+9Dd5r9T8MNGBWbrkDQUBcH
         3hWw==
X-Gm-Message-State: ACgBeo2wbM/3nF3T2tfpS2fsX3szMlLMKOtviuqAZBnFEmPRW5lWo2+Y
        S0HKtKV7gAxg9+i0piZpEDrX1CscvCPtSUiNQWdU6CfzzGVS0h5mELAG+h8NQeWH17udG+5AbdS
        chK0seL9pSa5GUTGxkdPq0MnfuU8U4tWuog==
X-Received: by 2002:a05:622a:103:b0:343:3ce4:c383 with SMTP id u3-20020a05622a010300b003433ce4c383mr8506780qtw.388.1661733526609;
        Sun, 28 Aug 2022 17:38:46 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5N/GOlvVyfCJNqu4InPuCkSG75lRXx6dDgVegmmEFZx2FWayJk7nXeOZd9IEelrnujtVffbA==
X-Received: by 2002:a05:622a:103:b0:343:3ce4:c383 with SMTP id u3-20020a05622a010300b003433ce4c383mr8506776qtw.388.1661733526431;
        Sun, 28 Aug 2022 17:38:46 -0700 (PDT)
Received: from nyx.localdomain (097-085-172-131.biz.spectrum.com. [97.85.172.131])
        by smtp.gmail.com with ESMTPSA id ge17-20020a05622a5c9100b003430589dd34sm4279395qtb.57.2022.08.28.17.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Aug 2022 17:38:46 -0700 (PDT)
Received: by nyx.localdomain (Postfix, from userid 1000)
        id 231E72410F8; Sun, 28 Aug 2022 17:38:45 -0700 (PDT)
Received: from nyx (localhost [127.0.0.1])
        by nyx.localdomain (Postfix) with ESMTP id 150A528011F;
        Sun, 28 Aug 2022 17:38:45 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] Documentation: bonding: clarify supported modes for tlb_dynamic_lb
In-reply-to: <20220826154738.4039-1-ffmancera@riseup.net>
References: <20220826154738.4039-1-ffmancera@riseup.net>
Comments: In-reply-to Fernando Fernandez Mancera <ffmancera@riseup.net>
   message dated "Fri, 26 Aug 2022 17:47:38 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.7.1; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <192002.1661733525.1@nyx>
Content-Transfer-Encoding: quoted-printable
Date:   Sun, 28 Aug 2022 17:38:45 -0700
Message-ID: <192003.1661733525@nyx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fernando Fernandez Mancera <ffmancera@riseup.net> wrote:

>tlb_dynamic_lb bonding option is compatible with balance-tlb and balance-=
alb
>modes. In order to be consistent with other option documentation, it shou=
ld
>mention both modes not only balance-tlb.
>
>Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>


>---
> Documentation/networking/bonding.rst | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/Documentation/networking/bonding.rst b/Documentation/network=
ing/bonding.rst
>index 7823a069a903..96cd7a26f3d9 100644
>--- a/Documentation/networking/bonding.rst
>+++ b/Documentation/networking/bonding.rst
>@@ -846,7 +846,7 @@ primary_reselect
> tlb_dynamic_lb
> =

> 	Specifies if dynamic shuffling of flows is enabled in tlb
>-	mode. The value has no effect on any other modes.
>+	or alb mode. The value has no effect on any other modes.
> =

> 	The default behavior of tlb mode is to shuffle active flows across
> 	slaves based on the load in that interval. This gives nice lb
>-- =

>2.30.2
>
