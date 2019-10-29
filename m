Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0387E8FCC
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729830AbfJ2TRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:17:33 -0400
Received: from mail-eopbgr800092.outbound.protection.outlook.com ([40.107.80.92]:31520
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725840AbfJ2TRd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 15:17:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0ahGNAtDXMAbajzxckTOvDDMZJ7W9peMOM+c6GjON9Wyj6LRIo/rCpuyNcXBIWVW2lErXqbNr6lbboh/NWaXymELHj1I5mfqBxdhXxzRj2jXJoctDwhExQYINNhw8Zsywa+IKJEb+BCswge1f0l3zkfgM6W2QY9HujxBzGWe+U5m4OxiEUvEITeHUojrMdETJUO+ZKfKmRKlojWGeOAPKKqTbvjF37VrcDzUNEb21G14IvZmDqEUBmdV60Xoq5/5leykKNQvd9p/GbA7jF7hqFrHZ78AeNd63AGh0OSjzp015+ghpYGTlmg3yawmEuEGfyRocL29MOjksHBuq7weA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIDaTk7OglmCEEdacqYI9Y1ySmTHm6uSiE9n55hvb14=;
 b=Giq62d70y2uF2Ewq6lXao2IPOkZzo4+FpzgdIj9p+bVyqzjtlKesZYebc263CakK3pIrYtgKwNSk/CeXMvvGuFQYjEulvFzbfM+tnxLOLEmjV81UZv4ZybrxKjTTDWDWeBx/W1sJWGGHqsTeSLw5E0mvSjNaNLMynL02u1xw0xZiSlB7VIiDn4+9puCr0xO1Q8qMaVXPf1S8L9YUffd5kjg4tUOvP/gB6QqycApZIcEvI11nOM6IiUGE5Aac97/cfOe3Ruh5E6YUNHkZX24MYuePrbq7hx4YWrRu3Z0k2ML0C/vg5R05IPb6Q8XL/UL4cJUdRduushfU7oqi+RC8eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rIDaTk7OglmCEEdacqYI9Y1ySmTHm6uSiE9n55hvb14=;
 b=en1p+yFiRhrqMaokIYhrCnWnl9NXoBkReiyDA7sh3kIsYqhkiv881fmduBThEcwg53vUjDs3Cr5pRAXthRgXdYhDNQCRUGLi03eeMtExWmeUUBtuSR574rWjrCKx2u60EYwKcAico4tO8yAUrHM60MSsJc8k7Zaco/WkVQ+vj5Y=
Received: from DM6PR21MB1337.namprd21.prod.outlook.com (20.179.53.80) by
 DM6PR21MB1243.namprd21.prod.outlook.com (20.179.50.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.6; Tue, 29 Oct 2019 19:17:25 +0000
Received: from DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8]) by DM6PR21MB1337.namprd21.prod.outlook.com
 ([fe80::5ce7:b21d:15d7:cff8%9]) with mapi id 15.20.2408.019; Tue, 29 Oct 2019
 19:17:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Topic: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
Thread-Index: AQHVjdOmZZw8T6TbMU+gJli1k9ewVadwkv0AgAFiizA=
Date:   Tue, 29 Oct 2019 19:17:25 +0000
Message-ID: <DM6PR21MB1337547067BE5E52DFE05E20CA610@DM6PR21MB1337.namprd21.prod.outlook.com>
References: <1572296801-4789-1-git-send-email-haiyangz@microsoft.com>
        <1572296801-4789-4-git-send-email-haiyangz@microsoft.com>
 <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191028143322.45d81da4@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2019-10-29T19:17:23.5149282Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=d52fc36f-928d-40be-b16b-0c6ff11b0049;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 1a23617a-b30c-4bcc-fbcd-08d75ca4a1e7
x-ms-traffictypediagnostic: DM6PR21MB1243:|DM6PR21MB1243:|DM6PR21MB1243:
x-ms-exchange-transport-forked: True
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <DM6PR21MB1243BC05C347D5C0BEC39F35CA610@DM6PR21MB1243.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(376002)(136003)(39860400002)(199004)(189003)(13464003)(51914003)(10290500003)(76176011)(478600001)(66556008)(25786009)(229853002)(7696005)(66476007)(486006)(6916009)(99286004)(66446008)(64756008)(102836004)(26005)(52536014)(8990500004)(66066001)(316002)(5660300002)(33656002)(53546011)(186003)(4326008)(6246003)(6506007)(54906003)(86362001)(74316002)(10090500001)(22452003)(305945005)(6116002)(256004)(3846002)(14444005)(14454004)(9686003)(55016002)(6436002)(11346002)(446003)(76116006)(66946007)(476003)(81156014)(7736002)(71190400001)(71200400001)(8936002)(81166006)(8676002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR21MB1243;H:DM6PR21MB1337.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3/8oCGx5QHZ3HBXcCjeB4LDkroYxZ2b8ma1VJVFJTB0FkuHdukDjUqD7KFpMSpqTRH2hL6umJ3mEzC9eE6juuDFsvVaH0gAPiWWN27WxVOSu8I40YBWGcZi6EqDvM6WD/Rr6riHN4Xw4V05H/dlPvBODU5pb6Hu7UDWUgm454finljGO6h1Smac1cX1xi8376M3aA5jwmcfJI4hXh+cZyBHJUoLe9A4Usul8fJYr7YidL91Kh9oD9+ADoa1Ga4MPKN30VclZWcnvHEk1vhZ0YXqLPDUD64wNUWwD4aD0UJwtvcqUY0+iNVuEey2/1SeNNAWLZh7Lxk9lFgN0jvbm9cWb+Y/4WCk53oBviMlFxQOufM7SESxBYYXfOj4ekpavBGI5f+xZVk855vPBl1tLvBO50HykvdQxiYdjchgOGxfyn+TGGy7o67KydNr3GEQV
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a23617a-b30c-4bcc-fbcd-08d75ca4a1e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 19:17:25.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o6NaCVmXgwBpLEEwxutOSf3RFH4lElYeFUe7Fp1oBubLAGh0X3vNp/zvCGXoQ3FVaBUIuzff51Qqdm+SQMfcEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1243
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Sent: Monday, October 28, 2019 5:33 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>
> Cc: sashal@kernel.org; linux-hyperv@vger.kernel.org;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; olaf@aepfle.de; vkuznets
> <vkuznets@redhat.com>; davem@davemloft.net; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH net-next, 3/4] hv_netvsc: Add XDP support
>=20
> On Mon, 28 Oct 2019 21:07:04 +0000, Haiyang Zhang wrote:
> > This patch adds support of XDP in native mode for hv_netvsc driver, and
> > transparently sets the XDP program on the associated VF NIC as well.
> >
> > XDP program cannot run with LRO (RSC) enabled, so you need to disable
> LRO
> > before running XDP:
> >         ethtool -K eth0 lro off
> >
> > XDP actions not yet supported:
> >         XDP_TX, XDP_REDIRECT
>=20
> I don't think we want to merge support without at least XDP_TX these
> days..
Thanks for your detailed comments --
I'm working on the XDP_TX...

>=20
> And without the ability to prepend headers this may be the least
> complete initial XDP implementation we've seen :(
The RNDIS packet buffer received by netvsc doesn't have a head room, but I'=
m
considering copy the packets to the page buffer, with a head room space=20
reserved for XDP.

>=20
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
>=20
> > diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
> > index d22a36f..688487b 100644
> > --- a/drivers/net/hyperv/netvsc.c
> > +++ b/drivers/net/hyperv/netvsc.c
> > @@ -122,8 +122,10 @@ static void free_netvsc_device(struct rcu_head
> *head)
> >  	vfree(nvdev->send_buf);
> >  	kfree(nvdev->send_section_map);
> >
> > -	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++)
> > +	for (i =3D 0; i < VRSS_CHANNEL_MAX; i++) {
> > +		xdp_rxq_info_unreg(&nvdev->chan_table[i].xdp_rxq);
> >  		vfree(nvdev->chan_table[i].mrc.slots);
> > +	}
> >
> >  	kfree(nvdev);
> >  }
> > @@ -1370,6 +1372,10 @@ struct netvsc_device *netvsc_device_add(struct
> hv_device *device,
> >  		nvchan->net_device =3D net_device;
> >  		u64_stats_init(&nvchan->tx_stats.syncp);
> >  		u64_stats_init(&nvchan->rx_stats.syncp);
> > +
> > +		xdp_rxq_info_reg(&nvchan->xdp_rxq, ndev, i);
> > +		xdp_rxq_info_reg_mem_model(&nvchan->xdp_rxq,
> > +					   MEM_TYPE_PAGE_SHARED, NULL);
>=20
> These can fail.
I will add error handling.

>=20
> >  	}
> >
> >  	/* Enable NAPI handler before init callbacks */
> > diff --git a/drivers/net/hyperv/netvsc_bpf.c
> b/drivers/net/hyperv/netvsc_bpf.c
> > new file mode 100644
> > index 0000000..4d235ac
> > --- /dev/null
> > +++ b/drivers/net/hyperv/netvsc_bpf.c
> > @@ -0,0 +1,211 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (c) 2019, Microsoft Corporation.
> > + *
> > + * Author:
> > + *   Haiyang Zhang <haiyangz@microsoft.com>
> > + */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include <linux/netdevice.h>
> > +#include <linux/etherdevice.h>
> > +#include <linux/ethtool.h>
> > +#include <linux/bpf.h>
> > +#include <linux/bpf_trace.h>
> > +#include <linux/kernel.h>
> > +#include <net/xdp.h>
> > +
> > +#include <linux/mutex.h>
> > +#include <linux/rtnetlink.h>
> > +
> > +#include "hyperv_net.h"
> > +
> > +u32 netvsc_run_xdp(struct net_device *ndev, struct netvsc_channel
> *nvchan,
> > +		   void **p_pbuf)
> > +{
> > +	struct page *page =3D NULL;
> > +	void *data =3D nvchan->rsc.data[0];
> > +	u32 len =3D nvchan->rsc.len[0];
> > +	void *pbuf =3D data;
> > +	struct bpf_prog *prog;
> > +	struct xdp_buff xdp;
> > +	u32 act =3D XDP_PASS;
> > +
> > +	*p_pbuf =3D NULL;
> > +
> > +	rcu_read_lock();
> > +	prog =3D rcu_dereference(nvchan->bpf_prog);
> > +
> > +	if (!prog || nvchan->rsc.cnt > 1)
>=20
> Can rsc.cnt =3D=3D 1 not be ensured at setup time? This looks quite
> limiting if random frames could be forced to bypass the filter.
Yes, the setup code already check/ensure LRO is disabled. So rsc.cnt > 1
is NOT expected here. Just an error check. I will change the return value
to XDP_ABORTED for this.

>=20
> > +		goto out;
> > +
> > +	/* copy to a new page buffer if data are not within a page */
> > +	if (virt_to_page(data) !=3D virt_to_page(data + len - 1)) {
> > +		page =3D alloc_page(GFP_ATOMIC);
> > +		if (!page)
> > +			goto out;
>=20
> Returning XDP_PASS on allocation failure seems highly questionable.
I will change the return value to XDP_ABORTED for this too.

>=20
> > +		pbuf =3D page_address(page);
> > +		memcpy(pbuf, nvchan->rsc.data[0], len);
> > +
> > +		*p_pbuf =3D pbuf;
> > +	}
> > +
> > +	xdp.data_hard_start =3D pbuf;
> > +	xdp.data =3D xdp.data_hard_start;
>=20
> This patch also doesn't add any headroom for XDP to prepend data :(
I'm considering to add the headroom to the start of the page.

>=20
> > +	xdp_set_data_meta_invalid(&xdp);
> > +	xdp.data_end =3D xdp.data + len;
> > +	xdp.rxq =3D &nvchan->xdp_rxq;
> > +	xdp.handle =3D 0;
> > +
> > +	act =3D bpf_prog_run_xdp(prog, &xdp);
> > +
> > +	switch (act) {
> > +	case XDP_PASS:
> > +		/* Pass to upper layers */
> > +		break;
> > +
> > +	case XDP_ABORTED:
> > +		trace_xdp_exception(ndev, prog, act);
> > +		break;
> > +
> > +	case XDP_DROP:
> > +		break;
> > +
> > +	default:
> > +		bpf_warn_invalid_xdp_action(act);
> > +	}
> > +
> > +out:
> > +	rcu_read_unlock();
> > +
> > +	if (page && act !=3D XDP_PASS) {
> > +		*p_pbuf =3D NULL;
> > +		__free_page(page);
> > +	}
> > +
> > +	return act;
> > +}
> > +
> > +unsigned int netvsc_xdp_fraglen(unsigned int len)
> > +{
> > +	return SKB_DATA_ALIGN(len) +
> > +	       SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> > +}
> > +
> > +struct bpf_prog *netvsc_xdp_get(struct netvsc_device *nvdev)
> > +{
> > +	return rtnl_dereference(nvdev->chan_table[0].bpf_prog);
> > +}
> > +
> > +int netvsc_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> > +		   struct netvsc_device *nvdev)
> > +{
> > +	struct bpf_prog *old_prog;
> > +	int frag_max, i;
> > +
> > +	old_prog =3D netvsc_xdp_get(nvdev);
> > +
> > +	if (!old_prog && !prog)
> > +		return 0;
>=20
> I think this case is now handled by the core.
Thanks for the reminder. I saw the code in dev_change_xdp_fd(), so the uppe=
r layer
doesn't call XDP_SETUP_PROG with old/new prog both NULL.
But this function is also called by other functions in our driver, like net=
vsc_detach(),
netvsc_remove(), etc. Instead of checking for NULL in each place, I still k=
eep the check inside
netvsc_xdp_set().

>=20
> > +	frag_max =3D netvsc_xdp_fraglen(dev->mtu + ETH_HLEN);
> > +	if (prog && frag_max > PAGE_SIZE) {
> > +		netdev_err(dev, "XDP: mtu:%u too large, frag:%u\n",
> > +			   dev->mtu, frag_max);
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (prog && (dev->features & NETIF_F_LRO)) {
> > +		netdev_err(dev, "XDP: not support LRO\n");
>=20
> Please report this via extack, that way users will see it in the console
> in which they're installing the program.
I will.

>=20
> > +		return -EOPNOTSUPP;
> > +	}
> > +
> > +	if (prog) {
> > +		prog =3D bpf_prog_add(prog, nvdev->num_chn);
> > +		if (IS_ERR(prog))
> > +			return PTR_ERR(prog);
> > +	}
> > +
> > +	for (i =3D 0; i < nvdev->num_chn; i++)
> > +		rcu_assign_pointer(nvdev->chan_table[i].bpf_prog, prog);
> > +
> > +	if (old_prog)
> > +		for (i =3D 0; i < nvdev->num_chn; i++)
> > +			bpf_prog_put(old_prog);
> > +
> > +	return 0;
> > +}
> > +
> > +int netvsc_vf_setxdp(struct net_device *vf_netdev, struct bpf_prog
> *prog)
> > +{
> > +	struct netdev_bpf xdp;
> > +	bpf_op_t ndo_bpf;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	if (!vf_netdev)
> > +		return 0;
> > +
> > +	ndo_bpf =3D vf_netdev->netdev_ops->ndo_bpf;
> > +	if (!ndo_bpf)
> > +		return 0;
> > +
> > +	memset(&xdp, 0, sizeof(xdp));
> > +
> > +	xdp.command =3D XDP_SETUP_PROG;
> > +	xdp.prog =3D prog;
> > +
> > +	return ndo_bpf(vf_netdev, &xdp);
>=20
> IMHO the automatic propagation is not a good idea. Especially if the
> propagation doesn't make the entire installation fail if VF doesn't
> have ndo_bpf.

On Hyperv and Azure hosts, VF is always acting as a slave below netvsc.
And they are both active -- most data packets go to VF, but broadcast,
multicast, and TCP SYN packets go to netvsc synthetic data path. The synthe=
tic=20
NIC (netvsc) is also a failover NIC when VF is not available.
We ask customers to only use the synthetic NIC directly. So propagation
of XDP setting to VF NIC is desired.=20
But, I will change the return code to error, so the entire installation fai=
ls if VF is=20
present but unable to set XDP prog.

Thanks,
- Haiyang

