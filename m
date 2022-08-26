Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAD85A214B
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 08:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiHZG6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 02:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbiHZG6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 02:58:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D183D21E8
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661497124;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lhDjsBNvG6YX3uYZc5SWnjBUuk9KrOIEcreK3q1L2fc=;
        b=it3+OzKDR5k8/dUuEbCzf7o898xNit+dsnNCU5+s8/Xzt5oqcOEWdjtW21FmkOAzWZ9A69
        YGxrDMLywJGCQJHJE4XeXYBgdse1iSGMZzk62D4PsqWCOQDXhcyJniBYYMHeX3kSnkKZcp
        xnSCuZuovb9t4/1qCqsZ+w4WBueaxxY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-154-d-iBx0Z2Nfq5_DKEZ6Pwog-1; Fri, 26 Aug 2022 02:58:42 -0400
X-MC-Unique: d-iBx0Z2Nfq5_DKEZ6Pwog-1
Received: by mail-qk1-f200.google.com with SMTP id h20-20020a05620a245400b006bb0c6074baso619642qkn.6
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 23:58:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=lhDjsBNvG6YX3uYZc5SWnjBUuk9KrOIEcreK3q1L2fc=;
        b=cHatQQr4u0L9iwQ41sYpOTkftClmK9Pox8ijkhAA5JHLaT87IBCvHPAsqWkjdLV7Ml
         4qNvuXmUFo5Z6OmPl1tIi9Xnm4vwW7SccXAWDmfAhKlGhjoHkWaxNfZtwg1d/JLCkcfl
         RWpjNsUCaJMrIKWSrvyENADb7cg8MtcOCIhUH36wuHqgLavaiw+rDxjR1b9R7YQC60U0
         DeAM+nis6xxQjw2rnLLhbt55cLA8AlF5z5oKxdEjk+jEs7Xh1pf/cuCvqj7jgW9V+cJI
         Zp1fggUoh+4h8hX7nHrmUlqX1QxqLNLQgE8qzZxRGM16/mF3UQRjey2e2RDT1AzFTfJZ
         Grhw==
X-Gm-Message-State: ACgBeo3+oOXG4EZ2Jk22y8AkZe3C5qSelnXLk2cdBNLWRTBgd3McL2H6
        fQTmWZxx11kLhf5jhRl+F1A9HJi4iHOzv6JjCesGkEXS1G17fIP6awQtcZnJxD1fNDC+iHx/Pfg
        KudbRE4rBUk/X9ifWd1OgmdZUCIEKoUYC
X-Received: by 2002:a05:622a:18e:b0:342:f7a9:a133 with SMTP id s14-20020a05622a018e00b00342f7a9a133mr6787140qtw.402.1661497122352;
        Thu, 25 Aug 2022 23:58:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7hSSB6B1kHe3/zMn4UWOwBOE3zZbpUNoBAiA6kYJSntG5l5c6MmJJPrl1IrCSNuxoCorDF1fimKqJ08l2Xhd8=
X-Received: by 2002:a05:622a:18e:b0:342:f7a9:a133 with SMTP id
 s14-20020a05622a018e00b00342f7a9a133mr6787128qtw.402.1661497122105; Thu, 25
 Aug 2022 23:58:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220819082001.15439-1-ihuguet@redhat.com> <20220825090242.12848-1-ihuguet@redhat.com>
 <YwegaWH6yL2RHW+6@lunn.ch>
In-Reply-To: <YwegaWH6yL2RHW+6@lunn.ch>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Fri, 26 Aug 2022 08:58:31 +0200
Message-ID: <CACT4oufGh++TyEY-FdfUjZpXSxmbC0W2O-y4uprQdYFTevv2pw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 0/3] sfc: add support for PTP over IPv6 and 802.3
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 6:17 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Thu, Aug 25, 2022 at 11:02:39AM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > Most recent cards (8000 series and newer) had enough hardware support
> > for this, but it was not enabled in the driver. The transmission of PTP
> > packets over these protocols was already added in commit bd4a2697e5e2
> > ("sfc: use hardware tx timestamps for more than PTP"), but receiving
> > them was already unsupported so synchronization didn't happen.
>
> You don't appear to Cc: the PTP maintainer.
>
>     Andrew
>

I didn't think about that, but looking at MAINTAINERS, there doesn't
seem to be any. There are 2 maintainers for the drivers of the clock
devices, but none for anything related to the network protocol...

--=20
=C3=8D=C3=B1igo Huguet

