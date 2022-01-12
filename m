Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC44348C0B9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351922AbiALJIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238120AbiALJIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 04:08:47 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F67CC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 01:08:47 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso3002198wmj.2
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 01:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xYu+KXsTWqvZi1o/EipNiosV2ICuRCbgX6r0trhgiTo=;
        b=gjsN0ngobbMfoLQfWvvHbufjkjj1g+aCpUIiAZ/eyL2pYF4rwKf/goR9fu/OUufbdY
         2EBVH7HhQFQEVMtGlM9ofHAneVQZhh8+S83WnI2TPmTjXoOoW2lTdpgaOBeTzGbdxi0d
         T9A/nF+9xkRd2m0UoqdFc+2dnv766An+2quZIL5LPHrCnDizTJ/UkMHfH/x5ycnEJzLK
         F+Vfw4RSw2O/F/9x6OvzX6S5Y1dQEk8aO2ofTVpfF2YOxKxId4OXYwce9UhMp622is2Q
         0aauN9PiuZXfzYZvr36DCjVoql+ayqts20lSmxcUehuxhCBqLMZJKQNCK4FicPWU70J0
         B0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=xYu+KXsTWqvZi1o/EipNiosV2ICuRCbgX6r0trhgiTo=;
        b=jSXnnc+qjo1NofDWZqj59n3SzQ05OCuEMblLBF0MzmdDOdziznDdHvUEw6DsEJ+Ag5
         PMfWvl73bsx2KKwbuO+QSz4sB9piE2Ro7Quem9qQnxBbXdHlTlmycORg0XsDzZGMEOXM
         0cS82CK+/GpDWwsioZdOVUjacBJy0LFDPMN0q1AbnbbqZroCFj9HNhSdcLSAsaLo/2aL
         tFvpF7tGH8zQnhH8DRoHZKTjLydWA6H0/YUT79uRFrNJTH37WAbMstsRUKJl3oCDZm25
         bWAkQC+hlMrwm7M+cIxNlKBLSIdABnnHkgUutlIuHCCG8wxBCOnsOUsdQHuxLj7UyaEa
         mOBA==
X-Gm-Message-State: AOAM530HUcJTrnk8rLNtI3hkvxhjEpIi7Rag3nfHUtOcWAbXUfUnIOE6
        sIOYLBYhU0pxOrjHwTpiH4+LZFLwDfg=
X-Google-Smtp-Source: ABdhPJwuZFOrJSS6oXU6xuic4nX576n26cOcbIf2M/x3mWQLiMvMAWLqm1DmaTsCUKcppla0qUT2kA==
X-Received: by 2002:a05:600c:4a22:: with SMTP id c34mr3549992wmp.150.1641978525966;
        Wed, 12 Jan 2022 01:08:45 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h10sm581211wmh.0.2022.01.12.01.08.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 12 Jan 2022 01:08:45 -0800 (PST)
Date:   Wed, 12 Jan 2022 09:08:43 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, ecree.xilinx@gmail.com,
        netdev@vger.kernel.org, dinang@xilinx.com
Subject: Re: [PATCH net-next] sfc: The size of the RX recycle ring should be
 more flexible
Message-ID: <20220112090843.qm27ofgtdz7ouuxw@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        davem@davemloft.net, ecree.xilinx@gmail.com, netdev@vger.kernel.org,
        dinang@xilinx.com
References: <CACT4oudChHDKecLfDdA7R8jpQv2Nmz5xBS3hH_jFWeS37CnQGg@mail.gmail.com>
 <20211120083107.z2cm7tkl2rsri2v7@gmail.com>
 <CACT4oufpvQ1Qzg3eC6wDu33_xBo5tVghr9G7Q=d-7F=bZbW4Vg@mail.gmail.com>
 <CACT4ouc=LNnrTdz37YEOAkm3G+02vrmJ5Sxk0JwKSMoCGnLs-w@mail.gmail.com>
 <20220102092207.rxz7kpjii4ermnfo@gmail.com>
 <20220110085820.zi73go4etyyrkixr@gmail.com>
 <20220110092224.5a8ecddf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110092224.5a8ecddf@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 10, 2022 at 09:22:24AM -0800, Jakub Kicinski wrote:
> On Mon, 10 Jan 2022 08:58:21 +0000 Martin Habets wrote:
> > +static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
> > +{
> > +	unsigned int ret;
> > +
> > +	/* There is no difference between PFs and VFs. The side is based on
> > +	 * the maximum link speed of a given NIC.
> > +	 */
> > +	switch (efx->pci_dev->device & 0xfff) {
> > +	case 0x0903:	/* Farmingdale can do up to 10G */
> > +#ifdef CONFIG_PPC64
> > +		ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> > +#else
> > +		ret = EFX_RECYCLE_RING_SIZE_10G;
> > +#endif
> > +		break;
> > +	case 0x0923:	/* Greenport can do up to 40G */
> > +	case 0x0a03:	/* Medford can do up to 40G */
> > +#ifdef CONFIG_PPC64
> > +		ret = 16 * EFX_RECYCLE_RING_SIZE_10G;
> > +#else
> > +		ret = 4 * EFX_RECYCLE_RING_SIZE_10G;
> > +#endif
> > +		break;
> > +	default:	/* Medford2 can do up to 100G */
> > +		ret = 10 * EFX_RECYCLE_RING_SIZE_10G;
> > +	}
> > +	return ret;
> > +}
> 
> Why not factor out the 4x scaling for powerpc outside of the switch?
> 
> The callback could return the scaling factor but failing that:
> 
> static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
> {
> 	unsigned int ret = EFX_RECYCLE_RING_SIZE_10G;;
> 
> 	/* There is no difference between PFs and VFs. The side is based on
> 	 * the maximum link speed of a given NIC.
> 	 */
> 	switch (efx->pci_dev->device & 0xfff) {
> 	case 0x0903:	/* Farmingdale can do up to 10G */
> 		break;
> 	case 0x0923:	/* Greenport can do up to 40G */
> 	case 0x0a03:	/* Medford can do up to 40G */
> 		ret *= 4;
> 		break;
> 	default:	/* Medford2 can do up to 100G */
> 		ret *= 10;
> 	}
> 
> 	if (IS_ENABLED(CONFIG_PPC64))
> 		ret *= 4;
> 
> 	return ret;
> }

Thanks, will do.

> Other than that - net-next is closed, please switch to RFC postings
> until it opens back up once 5.17-rc1 is cut. Thanks!

I knew it had to be near closing, I even checked the weblink. ;)
Will repost when net-next is open again.

Martin
