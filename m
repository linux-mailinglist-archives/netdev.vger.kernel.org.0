Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3A46161D55
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 23:31:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726237AbgBQWbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 17:31:25 -0500
Received: from mail-mw2nam10on2129.outbound.protection.outlook.com ([40.107.94.129]:18945
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725829AbgBQWbZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 17:31:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MtjVjMX0OUAkvndOi5Dto4aMiDbTgFro/v3G8YjbtD4lftMQtkAXpcEzTBc4rZY1RK8mrxpkxyVNsKyZZqcuXhl9bsoyNxnYGPOjAGDA6RI/M1a9qObu7dxfWDHFHtFrs4+5nhP756fiDHslK4MaCVQhbgoGGfQGuBjF+aWhAsVf+GEIJevAyoQRgqmepkKllGngG7bCbfY7KBWK/meZ8fWOS7fc5KpKZLalY+UmzkNMK8yWv386UOgSagsM+Kvk+HsTtOFmJUDBFNrX6JZJRxhr3XLewxFMAjox26SEVos3IuedFn4lNnlRSw8OvYH916raDhGw5OM4Ystj3QAARA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrSiUp0q3Hm1At9R1xXISgkZ2GstcU3PTWII162fsv4=;
 b=CwgD2/tnj+hpu3n+AGLW9zbocD9uUl0DWR15emV8EFpBrOxooXcWlEy6hcEd3dLoYlAUjbWC+zGi8fkhlM78nY3bozsHM2IyKx80BRhOm7kMr2kPTfGG6yQLFdkXnpoYociUGVGHAYdSdNm6vW/SLqF4Wwq+/jICw52H7sQb5GHAfbspaOPextq+AMFfKwZ+SYxqP+sbdBxiuHQXIuRDHGeZr9rdAu21q+TSWmFT2VGSlRrQUFD9u7hy4x6d807YhFLoYb1YMK3Cpx9NfZx5QGYA3NZZtc6eJ6h3Vu3IC37zSYocfU/08Uqbb4/vw4c9fDvNPSVqSi6OrXWiqPcprg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QrSiUp0q3Hm1At9R1xXISgkZ2GstcU3PTWII162fsv4=;
 b=I0CMygaVfuN9KrBiCQBf8IQLxQQDFC1wfLMAJq2MIsyNwuhwMir6eEjAYr4/UyTa2dna5/zCq3FGENlkPHScoomr46J+uJhwGPSc01/QWq4EtbpDmPY1+kCHu65dlSfVsVBCSGfTHIzGEaLHKJrO5atunqr7ydCvLMPpaFmrVwI=
Received: from CH2PR21MB1432.namprd21.prod.outlook.com (20.180.9.144) by
 CH2PR21MB1461.namprd21.prod.outlook.com (20.180.9.71) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.5; Mon, 17 Feb 2020 22:31:18 +0000
Received: from CH2PR21MB1432.namprd21.prod.outlook.com
 ([fe80::357a:f49e:2bb4:dc2]) by CH2PR21MB1432.namprd21.prod.outlook.com
 ([fe80::357a:f49e:2bb4:dc2%8]) with mapi id 15.20.2772.004; Mon, 17 Feb 2020
 22:31:18 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Topic: Is it safe for a NIC driver to use all the 48 bytes of skb->cb?
Thread-Index: AdXjukH6tGicVKR8QjWZ+wsQCSffGwAV8b7gAAVVXhAAbm03kA==
Date:   Mon, 17 Feb 2020 22:31:18 +0000
Message-ID: <CH2PR21MB143285AC27B2DB22C213C5B9CA160@CH2PR21MB1432.namprd21.prod.outlook.com>
References: <HK0P153MB0148311C48144413792A0FBEBF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
 <MN2PR21MB1437345219FA1CC3A75B9875CA140@MN2PR21MB1437.namprd21.prod.outlook.com>
 <HK0P153MB0148861FD9AAB88A98084206BF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <HK0P153MB0148861FD9AAB88A98084206BF140@HK0P153MB0148.APCP153.PROD.OUTLOOK.COM>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-02-15T05:23:53.1818868Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=0bdb99fb-ade9-4625-91de-e48aae6b21ec;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=haiyangz@microsoft.com; 
x-originating-ip: [96.61.92.94]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 95faa197-8d98-4f9e-866d-08d7b3f91bac
x-ms-traffictypediagnostic: CH2PR21MB1461:|CH2PR21MB1461:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR21MB14610E7CD67E97DB8899EC72CA160@CH2PR21MB1461.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0316567485
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(189003)(199004)(5660300002)(66476007)(6506007)(53546011)(55016002)(76116006)(10290500003)(7696005)(110136005)(66946007)(2906002)(71200400001)(33656002)(8990500004)(64756008)(66556008)(498600001)(4326008)(8936002)(186003)(26005)(86362001)(8676002)(66446008)(9686003)(81156014)(81166006)(52536014);DIR:OUT;SFP:1102;SCL:1;SRVR:CH2PR21MB1461;H:CH2PR21MB1432.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mPes86ldqSp0zRVGOc1yS2PsRg39cGx+YZBQlC/RCvazefG9LetWxqhdU48x5lUInEWd64IGu64FAY07VsT+3etVmzxlsrhql39mGQVmJpktSgG/zzkaYIVsjaBFxTccI105GO0oRyTOimBYf0A6lgYAp1DCU0aSr3OGQNaFU7iMptu3CS/w1Z6tQ3YWxxOoItsbKbJ4oEB9QWKd2ERon+bKyep82Szl7RfHX0xvZscCQfEm5rk+rE6EpiCY9Seq+wHbuIcjQa3KjWbDWsO1OKng2kFUNJ+LBrHBBOwQbl1kYToT5k/w4X1ntxvU+AGsaOE7vJsD2W+JcRa2/I0jsj+RHAc0e302o15TYHbnIztQmRyt52OneO5DXtROmNcPJcZ3mYA5mcsQGH8d3cVrhOFdp0aS7FHdONrDwAfeo0vjiXuRD/m+XOhN1SDWOpZg
x-ms-exchange-antispam-messagedata: pXw+6CUVHHZFTbhNKI4uMNynX5dRIdbNISW0hxiITyo7pndI3ocyUsIFEMSAGXB4V7AbwTAS9pUXhtNNRdRH6pF42VkkP839L05wwfJb6X8rHgFNnkxwN+LjePijI3U3hEngBGHnbjJx7nEyxnoL+g==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95faa197-8d98-4f9e-866d-08d7b3f91bac
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2020 22:31:18.7858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /CrFaV/BpLP0EsD6wX9lR00pScLpnJ33PnkiaaatqF8+kckkJKWFciXohVLBxttsozOplvgERyyHP33LzUeUXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR21MB1461
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Dexuan Cui <decui@microsoft.com>
> Sent: Saturday, February 15, 2020 1:04 PM
> To: Haiyang Zhang <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; David S. Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; KY Srinivasan <kys@microsoft.com>; linux-
> kernel@vger.kernel.org
> Cc: linux-hyperv@vger.kernel.org
> Subject: RE: Is it safe for a NIC driver to use all the 48 bytes of skb->=
cb?
>=20
> > From: Haiyang Zhang <haiyangz@microsoft.com>
> > Sent: Saturday, February 15, 2020 7:20 AM
> > To: Dexuan Cui <decui@microsoft.com>; Stephen Hemminger
> >
> > According to the comments in skbuff.h below, it is the responsibility o=
f the
> > owning layer to make a SKB clone, if it wants to keep the data across l=
ayers.
> > So, every layer can still use all of the 48 bytes.
> >
> >         /*
> >          * This is the control buffer. It is free to use for every
> >          * layer. Please put your private variables there. If you
> >          * want to keep them across layers you have to do a skb_clone()
> >          * first. This is owned by whoever has the skb queued ATM.
> >          */
> >         char                    cb[48] __aligned(8);
> >
> > > Now hv_netvsc assumes it can use all of the 48-bytes, though it uses =
only
> > > 20 bytes, but just in case the struct hv_netvsc_packet grows to >32 b=
ytes in
> > the
> > > future, should we change the BUILD_BUG_ON() in netvsc_start_xmit() to
> > > BUILD_BUG_ON(sizeof(struct hv_netvsc_packet) > SKB_SGO_CB_OFFSET); ?
> >
> > Based on the explanation above, the existing hv_netvsc code is correct.
> >
> > Thanks,
> > - Haiyang
>=20
> Got it. So if the upper layer saves something in the cb, it must do a skb=
_clone()
> and pass the new skb to hv_netvsc. hv_netvsc is the lowest layer in the n=
etwork
> stack, so it can use all the 48 bytes without calling skb_clone().
>=20
> BTW, now I happen to have a different question: in netvsc_probe() we have
> net->needed_headroom =3D RNDIS_AND_PPI_SIZE;
> I think this means when the network stack (ARP, IP, ICMP, TCP, UDP,etc) p=
asses
> a
> skb to hv_netvsc, the skb's headroom is increased by an extra size of
> net->needed_headroom, right? Then in netvsc_xmit(), why do we still need =
to
> call skb_cow_head(skb, RNDIS_AND_PPI_SIZE)? -- this looks unnecessary to =
me?

skb_cow_head() only expands the headroom if it is not enough, in case some=
=20
upper layer path didn't reserve enough.

> PS, what does the "cow" here mean? Copy On Write? It looks skb_cow_head()
> just copies the data (if necessary) and it has nothing to do with the
> write-protection in the MMU code.

Unrelated to MMU. It just copies some data to make room for writing.

Thanks,
- Haiyang
