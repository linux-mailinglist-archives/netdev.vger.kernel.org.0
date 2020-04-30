Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6231C00A5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 17:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727981AbgD3PnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 11:43:00 -0400
Received: from mail-co1nam11on2133.outbound.protection.outlook.com ([40.107.220.133]:45551
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbgD3Pm7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 11:42:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CWgBHvDcnX8UnFL4WySAclcNuRivpsd/4QHzus7Rr0tv0SOx+GjpnNE6/SaFZHwzyLkZsOCYkHeGWkHkOAJ8Gxx1XFQfWjmkl4y1V7gRI/7CyZt4Td1cW8ZdbySqrIihbioVQOA5GHnEL/qMqLLdL4jQuro4kmM4wQWk7U3yL7xvxYpAdpca03oR5GglpygrjZzb5QGo59+HnTPWbADikcgfDVGbI1VB+2UVTEXcd05i+5JJ0cPAh7sN4zSWsKdh3Oh6ZCI6hj8SJlGSfvitj5ilNelYZCbd9OxgJ85xim1TUOKpgmU/ga8Mgt9ONvK/EAjSOEySLADkTjnDPUNg2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQBdZ/fGcozTanySAideIcVdPprG4AIT8zF/vq9KAuY=;
 b=hr6Bav5y8VcQp3uHpC6knN7LF9LMm5fsMipzvzlge2yKs5fa4qHf/4MVS2sJpG0iIHwj2WpPcWb+ORBnYlSAK8sZYKMEDQS2vM5A6/wqL0rlOppSgM9xKPrDK+BI+4fBvzUENaobEJXeCzbr3TGgYsovEGkUTNB1xV7i5yVgx0G0KO7n9q/hI2FtWl+LnGsGr/y2+HJxQYVEcBnCZjFr62E4Xp7VKpSE56bNp735kaM2ReXQ+M5bP2ZDYJG4CVRkjNZCx96Xg50+mIxzkKZs6uO4/7TbUbpcW3x2UMwvPG/+YTMlujlK4K3F1wN7KTXOfxxq9NmkPPXVI98Qb23eGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oQBdZ/fGcozTanySAideIcVdPprG4AIT8zF/vq9KAuY=;
 b=ASlBt2v5SgCKWnOVShqXs61x1bSYWP1gXMwb694wc8m9YUJODy6CSp4Xtap9lDO7B6a7ax/S3btnctFp0EPwKczpRQ/Zxzu7Qk35hN29lAGK420astjlg6UQCUYz1apShl22VLY4fDkNWsL/iQdRLp8SLvgCo/i26sKTRg6VjFw=
Received: from MN2PR21MB1437.namprd21.prod.outlook.com (2603:10b6:208:208::10)
 by MN2PR21MB1149.namprd21.prod.outlook.com (2603:10b6:208:fd::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.6; Thu, 30 Apr
 2020 15:42:55 +0000
Received: from MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa]) by MN2PR21MB1437.namprd21.prod.outlook.com
 ([fe80::453:5eca:93bd:5afa%6]) with mapi id 15.20.2979.005; Thu, 30 Apr 2020
 15:42:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Michael Kelley <mikelley@microsoft.com>
CC:     KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>,
        Sami Tolvanen <samitolvanen@google.com>
Subject: RE: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Thread-Topic: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
Thread-Index: AQHWHYZGNBVu4gM0F0qaHyJdA0wqmKiQy0CAgABjYoCAAJnwsA==
Date:   Thu, 30 Apr 2020 15:42:55 +0000
Message-ID: <MN2PR21MB14373FE40A4D3AD012FAEC49CAAA0@MN2PR21MB1437.namprd21.prod.outlook.com>
References: <20200428100828.aslw3pn5nhwtlsnt@liuwe-devbox-debian-v2.j3c5onc20sse1dnehy4noqpfcg.zx.internal.cloudapp.net>
 <20200428175455.2109973-1-natechancellor@gmail.com>
 <MW2PR2101MB10522D4D5EBAB469FE5B4D8BD7AA0@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200430060151.GA3548130@ubuntu-s3-xlarge-x86>
In-Reply-To: <20200430060151.GA3548130@ubuntu-s3-xlarge-x86>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=haiyangz@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-04-30T15:42:54.3419050Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5a6f0a0d-2bde-46e2-8635-0d6d252653b2;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [96.61.83.132]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 25283589-86b4-4f36-ae3c-08d7ed1d26ce
x-ms-traffictypediagnostic: MN2PR21MB1149:|MN2PR21MB1149:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR21MB11498AAB5E6A5D80C98A6F4ACAAA0@MN2PR21MB1149.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0389EDA07F
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sJQ02fUP6ojI9CpTn9va7j/XLLt46HY4MUvQmbadjIlVV7fnMJthnWGLy+Dg+bZsWAptnzKC1Yfq4Pd28TcTGRGkugZtAJBA4TDiBYXSmeBPRv0q3cqIoNnvhQb3nC3fulXULFRumnOMbnbbLFn9qDqPYbvl+SFEIWgT6RnDjyGmMNpU0XrGZszNi3lD9QL4ZS8RCXVyMaHbmfe9ik72qb+EnYPjc4a4/VbT1f4l+J5Ti5WSdm6+xDNS+XpHOh0GFpHg6eLwPbihGufzPJ46vKmyVBd4kF98LuZNk2U7NT3GfnfYwNWhOCjOQ5o+UKvUPevGyfqGItSAae12gZGOKHlywmgwoVCNAvxonDxytEsyPMNhCuZjyMzCBTN4Mp5V2L9Xn+Seq6PRuK9Trz+cQ3ysCocOOjjp32xTIih56A8Z1xoGC/Iz6YqnOvLYn1h/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1437.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(136003)(39860400002)(376002)(366004)(346002)(186003)(52536014)(478600001)(4326008)(5660300002)(71200400001)(66556008)(66946007)(10290500003)(76116006)(66446008)(82950400001)(82960400001)(64756008)(6636002)(66476007)(54906003)(6506007)(55016002)(316002)(26005)(86362001)(7696005)(110136005)(33656002)(8990500004)(53546011)(8676002)(8936002)(2906002)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: WWSgXzDaGSjwNjBl+fz44967biH3cM+w6FvwqsuvsGPGm8+gGnh8ZgpU+DjA4DfAWGIQCF8aV/qdyOL2j3MLeq6ayCfBAuaBPdnRsymXG5Khc/HgpCjDXf8cUzqig6s9QZr4UvqKxNCP5fL/5VP1eJZ1JFVUCfT5bPmToca4+Cctr2cxahMEbw31I1Gh4hVNwuHwdV07+MF4OxMGL9dX08k7WZFpzyB6QSTPQqZFiT2dM4WXomDUlxN7NiRPdAdVZXSfWTPuQWi/+gPXEwan6ON3owApqGOfjy6b0PCHGKeEMxoi7yjlgoxhoehG9N1tT0xDbNaLuPivKZeW51WbyA2+RT0t6RiucWFQ+NZMNYC33o0URquQ7JumWAeUakZyTOpVSdkFkDvwG1aNgmba9RAlcVLpAGrwaYXvynRn+ccfeek7X11+ifw2EzqMa3FfO2LYMPTswKYIaoYLpYIz3+XsArbpKf4eSKwhjTN2Nyr2P+zIIj/bR9UaJ3Rve8sPqFgatoWJGkovVSL6pHVj5woQkiSR3RcwVGaD9LnTVD75Nt498u7ue93THZOYiZQwu7sR1XAGYtiFJLiYJxHKuAqienKy8+Ph4JUgfn3sdbjIEOJyqXaPN9qUweGj48MYrZGCddMjOkBvRAxAGvWVVKX3miNBRa8qhSm39crOMuVmUm3bXcA9XuL6HVUfg0rdySnHfrDtGDwN2bJa4LDWJpJ6UoVmNDNexS3X1koWjH01KOqNgP7TV8GnUSpuO5AgfsbeWtzUWx6EPd1Qvp+I436NVQHKhGKAeZC38CaRQmw=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25283589-86b4-4f36-ae3c-08d7ed1d26ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2020 15:42:55.5853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KpHitXjOyFdQ0WNo7QBJl4d1NER1pG4tBidWhGLHP+tRuTnYxcRFxNFORpUCwHkSuYGKcJF8yjKz7T1ocKjWIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR21MB1149
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Nathan Chancellor <natechancellor@gmail.com>
> Sent: Thursday, April 30, 2020 2:02 AM
> To: Michael Kelley <mikelley@microsoft.com>
> Cc: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; linux-
> hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; clang-built-linux@googlegroups.com; Sami
> Tolvanen <samitolvanen@google.com>
> Subject: Re: [PATCH v2] hv_netvsc: Fix netvsc_start_xmit's return type
>=20
> Hi Michael,
>=20
> On Thu, Apr 30, 2020 at 12:06:09AM +0000, Michael Kelley wrote:
> > From: Nathan Chancellor <natechancellor@gmail.com> Sent: Tuesday,
> > April 28, 2020 10:55 AM
> > >
> > > Do note that netvsc_xmit still returns int because netvsc_xmit has a
> > > potential return from netvsc_vf_xmit, which does not return
> > > netdev_tx_t because of the call to dev_queue_xmit.
> > >
> > > I am not sure if that is an oversight that was introduced by commit
> > > 0c195567a8f6e ("netvsc: transparent VF management") or if everything
> > > works properly as it is now.
> > >
> > > My patch is purely concerned with making the definition match the
> > > prototype so it should be NFC aside from avoiding the CFI panic.
> > >
> >
> > While it probably works correctly now, I'm not too keen on just
> > changing the return type for netvsc_start_xmit() and assuming the
> > 'int' that is returned from netvsc_xmit() will be correctly mapped to
> > the netdev_tx_t enum type.  While that mapping probably happens
> > correctly at the moment, this really should have a more holistic fix.
>=20
> While it might work correctly, I am not sure that the mapping is correct,
> hence that comment.
>=20
> netdev_tx_t is an enum with two acceptable types, 0x00 and 0x10. Up until
> commit 0c195567a8f6e ("netvsc: transparent VF management"), netvsc_xmit
> was guaranteed to return something of type netdev_tx_t.
>=20
> However, after said commit, we could return anything from netvsc_vf_xmit,
> which in turn calls dev_queue_xmit then __dev_queue_xmit which will
> return either an error code (-ENOMEM or
> -ENETDOWN) or something from __dev_xmit_skb, which appears to be
> NET_XMIT_SUCCESS, NET_XMIT_DROP, or NET_XMIT_CN.
>=20
> It does not look like netvsc_xmit or netvsc_vf_xmit try to convert those
> returns to netdev_tx_t in some way; netvsc_vf_xmit just passes the return
> value up to netvsc_xmit, which is the part that I am unsure about...
>=20
> > Nathan -- are you willing to look at doing the more holistic fix?  Or
> > should we see about asking Haiyang Zhang to do it?
>=20
> I would be fine trying to look at a more holistic fix but I know basicall=
y nothing
> about this subsystem. I am unsure if something like this would be accepta=
ble
> or if something else needs to happen.
> Otherwise, I'd be fine with you guys taking a look and just giving me
> reported-by credit.

Here is more info regarding Linux network subsystem:

As said in "include/linux/netdevice.h", drivers are allowed to return any c=
odes=20
from the three different namespaces.
And hv_netvsc needs to support "transparent VF", and calls netvsc_vf_xmit >=
>=20
dev_queue_xmit which returns qdisc return codes, and errnos like -ENOMEM,=20
etc. These are compliant with the guideline below:

  79 /*
  80  * Transmit return codes: transmit return codes originate from three d=
ifferent
  81  * namespaces:
  82  *
  83  * - qdisc return codes
  84  * - driver transmit return codes
  85  * - errno values
  86  *
  87  * Drivers are allowed to return any one of those in their hard_start_=
xmit()

Also, ndo_start_xmit function pointer is used by upper layer functions whic=
h can=20
handles three types of the return codes.=20
For example, in the calling stack: ndo_start_xmit << netdev_start_xmit <<=20
xmit_one << dev_hard_start_xmit():
The function dev_hard_start_xmit() uses dev_xmit_complete() to handle the=20
return codes. It handles three types of the return codes correctly.

 3483 struct sk_buff *dev_hard_start_xmit(struct sk_buff *first, struct net=
_device *dev,
 3484                                     struct netdev_queue *txq, int *re=
t)
 3485 {
 3486         struct sk_buff *skb =3D first;
 3487         int rc =3D NETDEV_TX_OK;
 3488
 3489         while (skb) {
 3490                 struct sk_buff *next =3D skb->next;
 3491
 3492                 skb_mark_not_on_list(skb);
 3493                 rc =3D xmit_one(skb, dev, txq, next !=3D NULL);
 3494                 if (unlikely(!dev_xmit_complete(rc))) {
 3495                         skb->next =3D next;
 3496                         goto out;
 3497                 }
 3498
 3499                 skb =3D next;
 3500                 if (netif_tx_queue_stopped(txq) && skb) {
 3501                         rc =3D NETDEV_TX_BUSY;
 3502                         break;
 3503                 }
 3504         }
 3505
 3506 out:
 3507         *ret =3D rc;
 3508         return skb;
 3509 }


 118 /*
 119  * Current order: NETDEV_TX_MASK > NET_XMIT_MASK >=3D 0 is significant=
;
 120  * hard_start_xmit() return < NET_XMIT_MASK means skb was consumed.
 121  */
 122 static inline bool dev_xmit_complete(int rc)
 123 {
 124         /*
 125          * Positive cases with an skb consumed by a driver:
 126          * - successful transmission (rc =3D=3D NETDEV_TX_OK)
 127          * - error while transmitting (rc < 0)
 128          * - error while queueing to a different device (rc & NET_XMIT=
_MASK)
 129          */
 130         if (likely(rc < NET_XMIT_MASK))
 131                 return true;
 132
 133         return false;
 134 }

Regarding "a more holistic fix", I believe the return type of ndo_start_xmi=
t should be=20
int, because of three namespaces of the return codes. This means to change =
all network=20
drivers. I'm not proposing to do this big change right now.

So I have no objection of your patch.

Thanks,
- Haiyang

Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

