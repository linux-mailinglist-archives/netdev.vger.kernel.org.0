Return-Path: <netdev+bounces-1818-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD2D6FF35B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 390081C20F57
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3550419E64;
	Thu, 11 May 2023 13:47:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28FD0369
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:47:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510C930F7
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683812838;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vHAerslMC1+Ahe++SmAf7s6lSS40IbEA5klYEdr1kEI=;
	b=FGdHbr7iKcac/PsiutXqCEmy1s01z8ObgzxlJP8EjlqIFsFXCw3L0aBTF3CnAH3EaAU34f
	9v9s0eMMt7cxIC2fec9aUDjVsnOk8i3u4tyAkMD6viymLt9QV7e/LlSKklJLZ+HH5uPlqF
	8xujWxigGnpicZDgl0cOXCgIsdidX68=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-OUE2zpuoMWChs-OMJbRSyg-1; Thu, 11 May 2023 09:47:17 -0400
X-MC-Unique: OUE2zpuoMWChs-OMJbRSyg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-3f17352d605so7916625e9.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 06:47:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683812836; x=1686404836;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vHAerslMC1+Ahe++SmAf7s6lSS40IbEA5klYEdr1kEI=;
        b=Jcn0z9YkxO6N9nE953eD96WUtHIpIJPAGT5+t8t4zXX5qekJlJE0IZXy9jW9qlwLCX
         HY9JS64xzsJUusrsaTwhaULjO8KupVSYixgMoIXt3BRQhUy8eZHL93imamzLatJKGPD1
         cR2S2raFlJaYUNm+tiYEBnaUOYnUgLr/pESOms0D+hOhu5J4ZQRgyOLF4ZF8GEywKeFU
         1ml/rDFMZKSh12VKV2wD1F3EyRsaCpYMfIAGNiw589KRsZxRC3Bot9IJnwT4T3AIds7X
         RjOJkRAfe2iGMnvbA31gaMSwln1AP97UqFtktWSD6cli5/tU2X8up26LrU2ONVAsauSZ
         RCeA==
X-Gm-Message-State: AC+VfDyiahxvS4+hrAzNSJFrGdAslccXiwg90iwJKNQXmjndIwc45OW1
	QG57Oz0JfEJx7/3fwbWTQ/q2OzjB8/auWZpDhljVFcDX7BN5KO3h5Pp2PQifJ7GrMhiQOqZJnL3
	it5Sv4sKY9lnK7Szf
X-Received: by 2002:a05:600c:3ca1:b0:3f4:e426:e0b7 with SMTP id bg33-20020a05600c3ca100b003f4e426e0b7mr3634751wmb.3.1683812835833;
        Thu, 11 May 2023 06:47:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ47GMhuDiRflp7hHdGnP0uVDgaiaBECfI7Xiw8eUZ9x6nrsqAOAMWHoW7tOCYaQPlbRRci2Cg==
X-Received: by 2002:a05:600c:3ca1:b0:3f4:e426:e0b7 with SMTP id bg33-20020a05600c3ca100b003f4e426e0b7mr3634722wmb.3.1683812835383;
        Thu, 11 May 2023 06:47:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-243-149.dyn.eolo.it. [146.241.243.149])
        by smtp.gmail.com with ESMTPSA id a6-20020a1cf006000000b003f0aefcc457sm25743320wmb.45.2023.05.11.06.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 06:47:14 -0700 (PDT)
Message-ID: <be53eff275623c55263a2e9b123cd77d453e8778.camel@redhat.com>
Subject: Re: [PATCH net-next] net: phylink: constify fwnode arguments
From: Paolo Abeni <pabeni@redhat.com>
To: "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc: Andrew Lunn <andrew@lunn.ch>, Heiner Kallweit <hkallweit1@gmail.com>, 
 Andy Shevchenko <andy.shevchenko@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org
Date: Thu, 11 May 2023 15:47:13 +0200
In-Reply-To: <ZFzSVciEsAU/pKLB@shell.armlinux.org.uk>
References: <E1pwhbd-001XUm-Km@rmk-PC.armlinux.org.uk>
	 <75dd5f74abe1d168e9bb679d1e47947f4900a1f9.camel@redhat.com>
	 <ZFzSVciEsAU/pKLB@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-11 at 12:32 +0100, Russell King (Oracle) wrote:
> On Thu, May 11, 2023 at 01:29:50PM +0200, Paolo Abeni wrote:
> > On Wed, 2023-05-10 at 12:03 +0100, Russell King (Oracle) wrote:
> > > diff --git a/include/linux/phylink.h b/include/linux/phylink.h
> > > index 71755c66c162..02c777ad18f2 100644
> > > --- a/include/linux/phylink.h
> > > +++ b/include/linux/phylink.h
> > > @@ -568,7 +568,8 @@ void phylink_generic_validate(struct phylink_conf=
ig *config,
> > >  			      unsigned long *supported,
> > >  			      struct phylink_link_state *state);
> > > =20
> > > -struct phylink *phylink_create(struct phylink_config *, struct fwnod=
e_handle *,
> > > +struct phylink *phylink_create(struct phylink_config *,
> > > +			       const struct fwnode_handle *,
> >=20
> > While touching the above, could you please also add the missing params
> > name, to keep checkpatch happy and be consistent with the others
> > arguments?
>=20
> For interest, when did naming parameters in a prototype become a
> requirement?

I would not call it a general requirement, but in this specific case we
have 2 named params and 2 unnamed ones for the same function, which
looks not good to me. Since you are touching that function definition
and checkpatch is complaining about the above, I think it would be
better to make the function declaration self-consistent.

Looking again at the checkpatch warning, that is possibly a false
positive - git history hints such check should apply only to function
definition, not declaration.=C2=A0

I still think it would be better removing the mixed unnamed/named
params usage.

Thanks,

Paolo


