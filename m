Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF1762FEDA
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 21:31:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiKRUbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 15:31:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbiKRUbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 15:31:00 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D7BA46D
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:30:58 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id h188-20020a1c21c5000000b003d0110eaadcso143559wmh.3
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:30:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zTxXqi8zlj+66Ot4h3bkgTcxGQqJkhVXTBtOVlN+xP8=;
        b=e83LYRhnEvokFz/E7pGpYn7ApHR4jvfpEqtA3dsM5aXYEC+kxR7q1kcKJhSJaoAtl0
         BXYLd7P3UT35COv0AbGxVAIF2UJpNfNJccSwHmrxQoldtAWpvXIXNXuNKBmNhTAXzdzV
         b6AQB7oZ5v78FLskDhIX6E2Bc/vgO+1fmuiHk77pZP6/5WhJSMmoITMZw8fMJBGlO1/h
         ljLU0jOlCnu+hRwMQluiZMuUzQL27v91Mt5U/P/Az0QHn5/SiEAXCBadkiyNaK6e+PIv
         bVsYJe/NjvuFpPDEnCt8chdbqmmdN57i5fuHYfT8/Mj7LXMQNQkWLWkL3iB2GEB5VsI7
         n/FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zTxXqi8zlj+66Ot4h3bkgTcxGQqJkhVXTBtOVlN+xP8=;
        b=shI87F20r8MKh+CVbQRZA1zvLba0sBfgQ+41IKiM4V6tj9Jadrwx7QkS1oIM4fwXt6
         KBIqAKXgjg0ZFBj19jfaFRUALG6XXF19F6I0TTlAtE3CNUjw/LoL0sFUXWTYhJqFchFd
         TeFrds96kYr6muXc2GymJMZghN1ALT4U2a//ckhh+Buj8a1vUd78/oq7Rf6bQFkcRTNe
         JGFtOz7OVIBEJsPM2KEPp7ZFYFGMjenpEqQq+ot9ivDDo6Farh8A6fWTGZgf1U75/X30
         eYNmIPP5QNbCA06kzwjm8kIXydeVUBqUOyQc6PILv5V865e0wC57bi2n2y8afBwlFv6Y
         s/7A==
X-Gm-Message-State: ANoB5pngEIWpk4GoiRzhMjl4mr14L9NGX8qX0qraXFof8wyjRbGM/Bjg
        7GODA+6tkxMtGzQfxr8Ra07DsqXDEng=
X-Google-Smtp-Source: AA0mqf41j6irPXcFoV7d0L2PVsiC9XF3dXa85NpiLRBJe/QxKW5SQexoXNXQ+N7Cd3tx//OTyp7OlA==
X-Received: by 2002:a05:600c:3b9f:b0:3cf:75e0:1e4d with SMTP id n31-20020a05600c3b9f00b003cf75e01e4dmr9783464wms.71.1668803456196;
        Fri, 18 Nov 2022 12:30:56 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id a8-20020adffb88000000b002383fc96509sm4333185wrr.47.2022.11.18.12.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 12:30:55 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH net-next 3/5] cassini: Remove unnecessary use of kmap_atomic()
Date:   Fri, 18 Nov 2022 21:30:54 +0100
Message-ID: <1767317.3VsfAaAtOV@suse>
In-Reply-To: <d9a3d57b-e72c-8f8f-b4ae-979836d87d32@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <3752791.kQq0lBPeGt@suse> <d9a3d57b-e72c-8f8f-b4ae-979836d87d32@intel.com>
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

On venerd=EC 18 novembre 2022 18:55:36 CET Anirudh Venkataramanan wrote:
> On 11/18/2022 12:35 AM, Fabio M. De Francesco wrote:
> > On gioved=EC 17 novembre 2022 23:25:55 CET Anirudh Venkataramanan wrote:
> >> Pages for Rx buffers are allocated in cas_page_alloc() using either
> >> GFP_ATOMIC or GFP_KERNEL. Memory allocated with GFP_KERNEL/GFP_ATOMIC
> >> can't come from highmem and so there's no need to kmap() them. Just use
> >> page_address() instead.
> >>=20
> >> I don't have hardware, so this change has only been compile tested.
> >>=20
> >> Cc: Ira Weiny <ira.weiny@intel.com>
> >> Cc: Fabio M. De Francesco <fmdefrancesco@gmail.com>
> >> Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.co=
m>
> >> ---
> >>=20
> >>   drivers/net/ethernet/sun/cassini.c | 34 ++++++++++------------------=
=2D-
> >>   1 file changed, 11 insertions(+), 23 deletions(-)
> >>=20
> >> diff --git a/drivers/net/ethernet/sun/cassini.c
> >> b/drivers/net/ethernet/sun/cassini.c index 0aca193..2f66cfc 100644
> >> --- a/drivers/net/ethernet/sun/cassini.c
> >> +++ b/drivers/net/ethernet/sun/cassini.c
> >> @@ -1915,7 +1915,7 @@ static int cas_rx_process_pkt(struct cas *cp,=20
struct
> >> cas_rx_comp *rxc, int off, swivel =3D RX_SWIVEL_OFF_VAL;
> >>=20
> >>   	struct cas_page *page;
> >>   	struct sk_buff *skb;
> >>=20
> >> -	void *addr, *crcaddr;
> >> +	void *crcaddr;
> >>=20
> >>   	__sum16 csum;
> >>   	char *p;
> >>=20
> >> @@ -1936,7 +1936,7 @@ static int cas_rx_process_pkt(struct cas *cp,=20
struct
> >> cas_rx_comp *rxc, skb_reserve(skb, swivel);
> >>=20
> >>   	p =3D skb->data;
> >>=20
> >> -	addr =3D crcaddr =3D NULL;
> >> +	crcaddr =3D NULL;
> >>=20
> >>   	if (hlen) { /* always copy header pages */
> >>   =09
> >>   		i =3D CAS_VAL(RX_COMP2_HDR_INDEX, words[1]);
> >>   		page =3D cp->rx_pages[CAS_VAL(RX_INDEX_RING, i)]
> >=20
> > [CAS_VAL(RX_INDEX_NUM, i)];
> >=20
> >> @@ -1948,12 +1948,10 @@ static int cas_rx_process_pkt(struct cas *cp,
> >> struct
> >> cas_rx_comp *rxc, i +=3D cp->crc_size;
> >>=20
> >>   		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +
> >=20
> > off,
> >=20
> >>   					i, DMA_FROM_DEVICE);
> >>=20
> >> -		addr =3D cas_page_map(page->buffer);
> >> -		memcpy(p, addr + off, i);
> >> +		memcpy(p, page_address(page->buffer) + off, i);
> >>=20
> >>   		dma_sync_single_for_device(&cp->pdev->dev,
> >>   	=09
> >>   					   page->dma_addr + off, i,
> >>   					   DMA_FROM_DEVICE);
> >>=20
> >> -		cas_page_unmap(addr);
> >>=20
> >>   		RX_USED_ADD(page, 0x100);
> >>   		p +=3D hlen;
> >>   		swivel =3D 0;
> >>=20
> >> @@ -1984,12 +1982,11 @@ static int cas_rx_process_pkt(struct cas *cp,
> >> struct
> >> cas_rx_comp *rxc, /* make sure we always copy a header */
> >>=20
> >>   		swivel =3D 0;
> >>   		if (p =3D=3D (char *) skb->data) { /* not split */
> >>=20
> >> -			addr =3D cas_page_map(page->buffer);
> >> -			memcpy(p, addr + off, RX_COPY_MIN);
> >> +			memcpy(p, page_address(page->buffer) + off,
> >> +			       RX_COPY_MIN);
> >>=20
> >>   			dma_sync_single_for_device(&cp->pdev->dev,
> >>   		=09
> >>   						   page->dma_addr
> >=20
> > + off, i,
> >=20
> > DMA_FROM_DEVICE);
> >=20
> >> -			cas_page_unmap(addr);
> >>=20
> >>   			off +=3D RX_COPY_MIN;
> >>   			swivel =3D RX_COPY_MIN;
> >>   			RX_USED_ADD(page, cp->mtu_stride);
> >>=20
> >> @@ -2036,10 +2033,8 @@ static int cas_rx_process_pkt(struct cas *cp,=20
struct
> >> cas_rx_comp *rxc, RX_USED_ADD(page, hlen + cp->crc_size);
> >>=20
> >>   		}
> >>=20
> >> -		if (cp->crc_size) {
> >> -			addr =3D cas_page_map(page->buffer);
> >> -			crcaddr  =3D addr + off + hlen;
> >> -		}
> >> +		if (cp->crc_size)
> >> +			crcaddr =3D page_address(page->buffer) + off +
> >=20
> > hlen;
> >=20
> >>   	} else {
> >>   =09
> >>   		/* copying packet */
> >>=20
> >> @@ -2061,12 +2056,10 @@ static int cas_rx_process_pkt(struct cas *cp,
> >> struct
> >> cas_rx_comp *rxc, i +=3D cp->crc_size;
> >>=20
> >>   		dma_sync_single_for_cpu(&cp->pdev->dev, page->dma_addr +
> >=20
> > off,
> >=20
> >>   					i, DMA_FROM_DEVICE);
> >>=20
> >> -		addr =3D cas_page_map(page->buffer);
> >> -		memcpy(p, addr + off, i);
> >> +		memcpy(p, page_address(page->buffer) + off, i);
> >>=20
> >>   		dma_sync_single_for_device(&cp->pdev->dev,
> >>   	=09
> >>   					   page->dma_addr + off, i,
> >>   					   DMA_FROM_DEVICE);
> >>=20
> >> -		cas_page_unmap(addr);
> >>=20
> >>   		if (p =3D=3D (char *) skb->data) /* not split */
> >>   	=09
> >>   			RX_USED_ADD(page, cp->mtu_stride);
> >>   	=09
> >>   		else
> >>=20
> >> @@ -2081,20 +2074,17 @@ static int cas_rx_process_pkt(struct cas *cp,
> >> struct
> >> cas_rx_comp *rxc, page->dma_addr,
> >>=20
> >>   						dlen + cp-
> >>=20
> >> crc_size,
> >>=20
> >>   						DMA_FROM_DEVICE);
> >>=20
> >> -			addr =3D cas_page_map(page->buffer);
> >> -			memcpy(p, addr, dlen + cp->crc_size);
> >> +			memcpy(p, page_address(page->buffer), dlen + cp-
> >> crc_size);
> >>=20
> >>   			dma_sync_single_for_device(&cp->pdev->dev,
> >>   		=09
> >>   						   page->dma_addr,
> >>   						   dlen + cp-
> >>=20
> >> crc_size,
> >=20
> > DMA_FROM_DEVICE);
> >=20
> >> -			cas_page_unmap(addr);
> >>=20
> >>   			RX_USED_ADD(page, dlen + cp->crc_size);
> >>   	=09
> >>   		}
> >>  =20
> >>   end_copy_pkt:
> >> -		if (cp->crc_size) {
> >> -			addr    =3D NULL;
> >> +		if (cp->crc_size)
> >>=20
> >>   			crcaddr =3D skb->data + alloclen;
> >>=20
> >> -		}
> >> +
> >=20
> > This is a different logical change. Some maintainers I met would have=20
asked
> > for a separate patch, but I'm OK with it being here.
>=20
> cas_page_map()/cap_page_unmap() were using addr. Once these went away
> addr became unnecessary. It would be weird to leave the declaration,
> init and reinit for a variable that's not of any use, and so it was
> removed as well. It's cleaner this way.
>=20
> Ani

Oh, sorry. You are right here. I didn't notice this connection. I probably=
=20
took too little time to read your code carefully and interpreted those two=
=20
lines another way :-(

Thanks,

=46abio




