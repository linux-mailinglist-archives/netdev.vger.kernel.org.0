Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33D162FEF5
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiKRUp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:45:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiKRUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:45:53 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036475CD18
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:45:52 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id i12so7241372wrb.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAf352wdSqOpW5AzJIAhyU8udiRoXrlpFYzTDddMfHs=;
        b=S438lcvERjqClwtVzY2QS9BN7N5E780jOgt+CL9jQaCjx4zzrwJiEGr5GiT0bUuDxW
         a9CLQxbRgiDwPr03LAkqmBf0yOZPxda3A8/uQ4s6nY0kGhcbQ92W3yfkSIgnmYkFqTSK
         ntBswz0drpJn/UApzRC6lZ0+xBhX3nCmOakuidHSoLYQja95vdbMNkCjW6eFUZ/jg2bu
         EGwgdLZGLpo5pU+tZguPn2+apQaiq6bX5u31Mm8ocMAC6s7JUXVYFsZ8ysyASVNEvIOP
         rM7nkdtTl04gP8dZbAVYqOs3iJ1lddcE4tql3GHkjwG1qdf8lpBFrhQpwytybeNvI5Yk
         9lTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAf352wdSqOpW5AzJIAhyU8udiRoXrlpFYzTDddMfHs=;
        b=NFNSAbnATTT0oK/vumfWC/KhWc9ZwXWGwkecHlBXQq9nwPJefweC7NQUPOpme5+vGs
         Wm+jhcngBXV1YodrwtepkoSAfLNEBEQlCWkwqxc9KGGdn33oyv4Y5Ku4Jt/WrOeRZtuq
         P+P6jh9PjPLq/ZbevpTUecdXfELwh/LbHxy3mb4U+Mrtx+F3p585GqXxujlyUEO0TcJ3
         e5vZn9Tc9vPWxig0TDkbd5bM8FVn2v7A5Jt2tOnk5jTSCTZ+nxaNpWWHtZ3uNGCEWFZf
         FcBZ618iX2ALQ9eMG6eel6ktlTgM0oKRFUj6GcSIHs4BrRdITk/Z9pKYM8OB7D1CFu9V
         tYuw==
X-Gm-Message-State: ANoB5pljWFq6gxKKaLofRTEMqa4aPZ5Wdn82Kxi36NiGiEDtQilr5vM2
        4EvK9VvVRyctm92lTDksomvB3SvlnUs=
X-Google-Smtp-Source: AA0mqf6f1Zssjgjxn3jTVgKGODbnYpoodvIXxLZ43j0M+MH+Bd/tx5u8pd9VRWZaqep1O8mcyX+XGQ==
X-Received: by 2002:adf:f011:0:b0:241:c78c:3671 with SMTP id j17-20020adff011000000b00241c78c3671mr840601wro.129.1668804350155;
        Fri, 18 Nov 2022 12:45:50 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id e9-20020a5d5949000000b0022e344a63c7sm4301510wri.92.2022.11.18.12.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:45:49 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Subject: Re: [PATCH net-next 5/5] sunvnet: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 21:45:48 +0100
Message-ID: <2784595.88bMQJbFj6@suse>
In-Reply-To: <2373606.NG923GbCHz@suse>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <20221117222557.2196195-6-anirudh.venkataramanan@intel.com> <2373606.NG923GbCHz@suse>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On venerd=EC 18 novembre 2022 10:11:12 CET Fabio M. De Francesco wrote:
> On gioved=EC 17 novembre 2022 23:25:57 CET Anirudh Venkataramanan wrote:
> > kmap_atomic() is being deprecated in favor of kmap_local_page().
> > Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> > and kunmap_local() respectively.
> >=20
> > Note that kmap_atomic() disables preemption and page-fault processing,
> > but kmap_local_page() doesn't. Converting the former to the latter is s=
afe
> > only if there isn't an implicit dependency on preemption and page-fault
> > handling being disabled, which does appear to be the case here.
> >=20
> > Also note that the page being mapped is not allocated by the driver, an=
d=20
so
> > the driver doesn't know if the page is in normal memory. This is the=20
reason
> > kmap_local_page() is used as opposed to page_address().
> >=20
> > I don't have hardware, so this change has only been compile tested.
> >=20
> > Cc: Ira Weiny <ira.weiny@intel.com>
> > Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> > Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> > ---
> >=20
> >  drivers/net/ethernet/sun/sunvnet_common.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/sun/sunvnet_common.c
> > b/drivers/net/ethernet/sun/sunvnet_common.c index 80fde5f..a6211b9 1006=
44
> > --- a/drivers/net/ethernet/sun/sunvnet_common.c
> > +++ b/drivers/net/ethernet/sun/sunvnet_common.c
> > @@ -1085,13 +1085,13 @@ static inline int vnet_skb_map(struct ldc_chann=
el
>=20
> *lp,
>=20
> > struct sk_buff *skb, u8 *vaddr;
> >=20
> >  		if (nc < ncookies) {
> >=20
> > -			vaddr =3D kmap_atomic(skb_frag_page(f));
> > +			vaddr =3D kmap_local_page(skb_frag_page(f));
> >=20
> >  			blen =3D skb_frag_size(f);
> >  			blen +=3D 8 - (blen & 7);
> >  			err =3D ldc_map_single(lp, vaddr +
>=20
> skb_frag_off(f),
>=20
> >  					     blen, cookies + nc,
>=20
> ncookies - nc,
>=20
> >  					     map_perm);
> >=20
> > -			kunmap_atomic(vaddr);
> > +			kunmap_local(vaddr);
> >=20
> >  		} else {
> >  	=09
> >  			err =3D -EMSGSIZE;
> >  	=09
> >  		}
> >=20
> > --
> > 2.37.2
>=20
> Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
>=20
> Thanks,
>=20
> Fabio

Now that we are at 5/5 again. I'd like to point again to what worries me:

"Converting the former to the latter is safe only if there isn't an implici=
t=20
dependency on preemption and page-fault handling being disabled, ...".

If I was able to convey my thoughts this is what you should get from my lon=
g=20
email:=20

"Converting the former to the latter is _always_ safe if there isn't an=20
implicit dependency on preemption and page-fault handling being disabled an=
d=20
also when the above-mentioned implicit dependency is present, but in the=20
latter case only if calling pagefault_disable() and/or preempt_disable() wi=
th=20
kmap_local_page(). These disables are not required here because...".

As you demonstrated none of your nine patches need any explicit disable alo=
ng=20
with kmap_local_page().

Do my two emails make any sense to you?
However, your patches are good. If you decide to make them perfect use thos=
e=20
helpers we've been talking about.

Again thanks,

=46abio


=46abio



