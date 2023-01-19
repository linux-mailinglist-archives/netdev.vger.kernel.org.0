Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633FD673978
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjASNI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:08:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbjASNHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:07:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D737A53D
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:06:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674133593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NllK0azs34zQlNRKoqTNyUNwLOsJ8tnB4tNC7+7ktic=;
        b=S3nOzNTJNAcodigvZEXCaUJaQGVy5857qjZpV82RaI1zaupYkDRKt1z7HamE7Gua3xw0oY
        mUhdVG7zbicCvBJSz+3azmSeb+deENcxQAZYVzW5HwxU9h9W7VyGC1HqsucbxaUPnRyIAh
        Ab0cbyQ4ws/vV45ylc5ae76Rw0MYXaw=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-Fk4vS_W9OSOxGCBCRxBAZQ-1; Thu, 19 Jan 2023 08:06:31 -0500
X-MC-Unique: Fk4vS_W9OSOxGCBCRxBAZQ-1
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-4fb212e68b7so12044417b3.0
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 05:06:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NllK0azs34zQlNRKoqTNyUNwLOsJ8tnB4tNC7+7ktic=;
        b=UnRH0dw9Op761khEZvhDqlpxANa+Rr3JqHqkp2jGJfod6OBsesXTQaySq/y9o+2XH+
         dSbMifBbQVKw9jDMzYCRNY9venKhyXTHJR3yUmjsHYyAK/8phF9r1GT/uYjL+BqpSXMS
         om8aQNac1PJ5U0BTh/jVvWErdMEwRA4BYM6eRphjctXje2M5/vv57bEOz3UvHaZVFaYT
         1mdlMPCrCA6EpTuyLqZDYkPTGIa5ZxYzEFJGo1KmpHz9xLfiIhfMKBjXq2a4911G3ceo
         THGOcfBeQ+n6Hthi1MoR/bvlDh5OsHmE9wzMocPMUQ0Fvtq8bv6tBC0t20Wlz1rMiacp
         Y6ww==
X-Gm-Message-State: AFqh2kq76j9Icv3OSfuAdcOSeFh6YgmrEbUf2qklLorrZmFSnfu46lwB
        bgx2lihYtzw6liT4EGhNiKippoc/NTPFcWePWwqykgAhk007wwM0MvA9puMMSOP2EyZpsFFtXjA
        oOEQe8BPF/Vm6kaYp
X-Received: by 2002:a05:7500:631c:b0:f1:e53f:ed8f with SMTP id ib28-20020a057500631c00b000f1e53fed8fmr942647gab.6.1674133591288;
        Thu, 19 Jan 2023 05:06:31 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtqVdyMFGGKllOmHx/VXgChvv179iGQmaX6P7Z+RaxG6XipFX0sosGMobhJcbX7oss70Pr0IA==
X-Received: by 2002:a05:7500:631c:b0:f1:e53f:ed8f with SMTP id ib28-20020a057500631c00b000f1e53fed8fmr942613gab.6.1674133590893;
        Thu, 19 Jan 2023 05:06:30 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-124-97.dyn.eolo.it. [146.241.124.97])
        by smtp.gmail.com with ESMTPSA id m3-20020a05620a24c300b007055dce4cecsm265017qkn.97.2023.01.19.05.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 05:06:30 -0800 (PST)
Message-ID: <54ebe3efac89c68db30658e82b1ba1a7355d4456.camel@redhat.com>
Subject: Re: [PATCH net-next v3 2/2] net: ethernet: ti: am65-cpsw/cpts: Fix
 CPTS release action
From:   Paolo Abeni <pabeni@redhat.com>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        rogerq@kernel.org, leon@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, vigneshr@ti.com, srk@ti.com
Date:   Thu, 19 Jan 2023 14:06:26 +0100
In-Reply-To: <20230118095439.114222-3-s-vadapalli@ti.com>
References: <20230118095439.114222-1-s-vadapalli@ti.com>
         <20230118095439.114222-3-s-vadapalli@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 2023-01-18 at 15:24 +0530, Siddharth Vadapalli wrote:
> @@ -1014,18 +1013,12 @@ struct am65_cpts *am65_cpts_create(struct device =
*dev, void __iomem *regs,
>  	}
>  	cpts->phc_index =3D ptp_clock_index(cpts->ptp_clock);
> =20
> -	ret =3D devm_add_action_or_reset(dev, am65_cpts_release, cpts);
> -	if (ret) {
> -		dev_err(dev, "failed to add ptpclk reset action %d", ret);
> -		return ERR_PTR(ret);
> -	}
> -
>  	ret =3D devm_request_threaded_irq(dev, cpts->irq, NULL,
>  					am65_cpts_interrupt,
>  					IRQF_ONESHOT, dev_name(dev), cpts);
>  	if (ret < 0) {
>  		dev_err(cpts->dev, "error attaching irq %d\n", ret);
> -		return ERR_PTR(ret);
> +		goto reset_ptpclk;
>  	}
> =20
>  	dev_info(dev, "CPTS ver 0x%08x, freq:%u, add_val:%u\n",

This chunk does not apply cleanly to current net-next (context is
changed). Please rebase and re-spin (you can preserve/keep the already
acquire reviewed-by tags)

Thanks!

Paolo

