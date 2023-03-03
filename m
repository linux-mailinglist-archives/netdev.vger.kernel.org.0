Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305C76A9E17
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 19:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231360AbjCCSBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 13:01:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbjCCSBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 13:01:53 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9505CC12
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 10:01:51 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id g3so3115762wri.6
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 10:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677866510;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEHt2nqbh8iSr8N+DHlVLwrkMHgGpGHvyGaNrMsaTek=;
        b=K/fh8E76hHdCMDt7xTSKSd/lIyTQD3rivncuKODPEHLpFaQ3GnQYErje8gOQ4Ovt9v
         RwP4MwqXkuzrWCphhWnpJYdM3XStcPPnvuG8XuZXnuMsRYw6mOVVBtGK0/8C2q9J1WKK
         Z9A+xDkocZ9cZ6uLjYN82skBAA7T3nYc2Ynl8p/7GHrQHU1edhuKoL2CYY4PPaCXHZr1
         oY+qi7/cmIba2UJwuPAs7z3Bywj3K24/5ZLGLviPNdeyHa+gvbHQamzSrOvmxDKIM20J
         BcUz50Sg5nKnyNXg3Qo8rr6nB+6vw/t5bBKhKV2xum3RJHMsaL9KyOUI0sJTKEVhMLyz
         bBmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677866510;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BEHt2nqbh8iSr8N+DHlVLwrkMHgGpGHvyGaNrMsaTek=;
        b=59ooS5X7I8IYFNRohPERPbQ4TOUU9nUNnAyZ7IsfVSnJ7ClK/SFqkzCeOSQAzSH3Qh
         TrQHIgMoRQdkflhZ1hPGyZT/vGHKX3BSummL6+2Zqpo4hFXSqhHy57EKL+6lIVPK4ivO
         nRRRGnQpTyBVYepUvqtnIo1AXucLupxWpWF+6ZW76TN7KFiMFDFs7y4ksqgHSwmZD/Ju
         /8U1teK8i9IbDlWFVyFzQ/JVtQR9qsNn1NTuwyhVLFJFCd359++pIfkNDLzr7G3yrycE
         SLGjO55vIhsbUIqqutHp5rwcnbUEVMAJ/QShtipeIUR10IX9jUzKe6GncaEZElkGEJYk
         lM6g==
X-Gm-Message-State: AO0yUKX8yqtYI1lfr4LJ3GZcrBq3IzrMFyC5eXU/SimUb/6HCuQTGTuN
        4DMRs2VVbK4de5TH+nnBmN8=
X-Google-Smtp-Source: AK7set8H6vRsK8VR8aFhQ06k8RjPQuWBqUGuXiqsKp34zmquuUsytzOFw9Gd4+AfjI6DVapHQXGIKQ==
X-Received: by 2002:adf:df04:0:b0:2c7:169b:c56d with SMTP id y4-20020adfdf04000000b002c7169bc56dmr2066766wrl.17.1677866509977;
        Fri, 03 Mar 2023 10:01:49 -0800 (PST)
Received: from localhost ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id m14-20020adffe4e000000b002c54c8e70b1sm2883865wrs.9.2023.03.03.10.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 10:01:49 -0800 (PST)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 03 Mar 2023 19:01:48 +0100
Message-Id: <CQWY1CVZCN1L.12KQJHY2ALZN8@vincent-arch>
Subject: Re: [Intel-wired-lan] [PATCH v1] netdevice: use ifmap isteand of
 plain fields
From:   "Vincenzo Palazzo" <vincenzopalazzodev@gmail.com>
To:     "Paul Menzel" <pmenzel@molgen.mpg.de>
Cc:     "Linus Torvalds" <torvalds@linux-foundation.org>,
        <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <davem@davemloft.net>, <jesse.brandeburg@intel.com>
X-Mailer: aerc 0.14.0
References: <20230303150818.132386-1-vincenzopalazzodev@gmail.com>
 <bd0a8066-9360-7440-9705-68118eb5e0ff@molgen.mpg.de>
In-Reply-To: <bd0a8066-9360-7440-9705-68118eb5e0ff@molgen.mpg.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Mar 3, 2023 at 5:48 PM CET, Paul Menzel wrote:
> Dear Vincenzo,
>
>
> Thank you for your patch. There is a small typo in the commit message=20
> summary in *instead*.
>
Ah, I also tried to pay attention to avoid typo! Sorry, I will made a v2.

> Am 03.03.23 um 16:08 schrieb Vincenzo Palazzo:
> > clean the code by using the ifmap instead of plain fields,
> > and avoid code duplication.
> >=20
> > P.S: I'm giving credit to the author of the FIXME commit.
>
> No idea, what you mean exactly, but you can do that by adding From: in=20
> the first line of the commit message body.
>

I ran git blame to find the comment author because the=20
refactoring was suggested by the FIXME, but it turn out that was a very
historical one (before git) as Linus point out git blame is wrong in
this case. I will also fix this in the v2

Cheers!

Vincent.


>
> > Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
> > ---
> >   drivers/net/ethernet/intel/e1000e/netdev.c |  4 ++--
> >   include/linux/netdevice.h                  |  8 +-------
> >   net/core/dev_ioctl.c                       | 12 ++++++------
> >   net/core/rtnetlink.c                       |  6 +++---
> >   4 files changed, 12 insertions(+), 18 deletions(-)
> >=20
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/e=
thernet/intel/e1000e/netdev.c
> > index e1eb1de88bf9..059ff8bcdbbc 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -7476,8 +7476,8 @@ static int e1000_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *ent)
> >   	netif_napi_add(netdev, &adapter->napi, e1000e_poll);
> >   	strscpy(netdev->name, pci_name(pdev), sizeof(netdev->name));
> >  =20
> > -	netdev->mem_start =3D mmio_start;
> > -	netdev->mem_end =3D mmio_start + mmio_len;
> > +	netdev->dev_mapping.mem_start =3D mmio_start;
> > +	netdev->dev_mapping.mem_end =3D mmio_start + mmio_len;
> >  =20
> >   	adapter->bd_number =3D cards_found++;
> >  =20
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 6a14b7b11766..c5987e90a078 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -2031,13 +2031,7 @@ struct net_device {
> >   	char			name[IFNAMSIZ];
> >   	struct netdev_name_node	*name_node;
> >   	struct dev_ifalias	__rcu *ifalias;
> > -	/*
> > -	 *	I/O specific fields
> > -	 *	FIXME: Merge these and struct ifmap into one
> > -	 */
> > -	unsigned long		mem_end;
> > -	unsigned long		mem_start;
> > -	unsigned long		base_addr;
> > +	struct ifmap dev_mapping;
> >  =20
> >   	/*
> >   	 *	Some hardware also needs these fields (state,dev_list,
> > diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
> > index 5cdbfbf9a7dc..89469cb97e35 100644
> > --- a/net/core/dev_ioctl.c
> > +++ b/net/core/dev_ioctl.c
> > @@ -88,9 +88,9 @@ static int dev_getifmap(struct net_device *dev, struc=
t ifreq *ifr)
> >   	if (in_compat_syscall()) {
> >   		struct compat_ifmap *cifmap =3D (struct compat_ifmap *)ifmap;
> >  =20
> > -		cifmap->mem_start =3D dev->mem_start;
> > -		cifmap->mem_end   =3D dev->mem_end;
> > -		cifmap->base_addr =3D dev->base_addr;
> > +		cifmap->mem_start =3D dev->dev_mapping.mem_start;
> > +		cifmap->mem_end   =3D dev->dev_mapping.mem_end;
> > +		cifmap->base_addr =3D dev->dev_mapping.base_addr;
> >   		cifmap->irq       =3D dev->irq;
> >   		cifmap->dma       =3D dev->dma;
> >   		cifmap->port      =3D dev->if_port;
> > @@ -98,9 +98,9 @@ static int dev_getifmap(struct net_device *dev, struc=
t ifreq *ifr)
> >   		return 0;
> >   	}
> >  =20
> > -	ifmap->mem_start  =3D dev->mem_start;
> > -	ifmap->mem_end    =3D dev->mem_end;
> > -	ifmap->base_addr  =3D dev->base_addr;
> > +	ifmap->mem_start  =3D dev->dev_mapping.mem_start;
> > +	ifmap->mem_end    =3D dev->dev_mapping.mem_end;
> > +	ifmap->base_addr  =3D dev->dev_mapping.base_addr;
> >   	ifmap->irq        =3D dev->irq;
> >   	ifmap->dma        =3D dev->dma;
> >   	ifmap->port       =3D dev->if_port;
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> > index 5d8eb57867a9..ff8fc1bbda31 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1445,9 +1445,9 @@ static int rtnl_fill_link_ifmap(struct sk_buff *s=
kb, struct net_device *dev)
> >   	struct rtnl_link_ifmap map;
> >  =20
> >   	memset(&map, 0, sizeof(map));
> > -	map.mem_start   =3D dev->mem_start;
> > -	map.mem_end     =3D dev->mem_end;
> > -	map.base_addr   =3D dev->base_addr;
> > +	map.mem_start   =3D dev->dev_mapping.mem_start;
> > +	map.mem_end     =3D dev->dev_mapping.mem_end;
> > +	map.base_addr   =3D dev->dev_mapping.base_addr;
> >   	map.irq         =3D dev->irq;
> >   	map.dma         =3D dev->dma;
> >   	map.port        =3D dev->if_port;

