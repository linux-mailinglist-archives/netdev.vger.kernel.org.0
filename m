Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27FA33E9CA
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 07:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhCQGeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 02:34:13 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7578 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229847AbhCQGdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 02:33:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12H6KWWx023069;
        Tue, 16 Mar 2021 23:33:39 -0700
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by mx0a-0016f401.pphosted.com with ESMTP id 37b5vdh3xc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Mar 2021 23:33:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zl0ZtVpmsMjUkT8/T0DrDra+edbaQ59ANLk/bKgB8TGFhP+DPJZ1exQk/lSWMWT67j7eSsopSgYSiNxXUKzzlGChB7n6/gigg52q/rW5DwpqMc32syXUcXx1RpUkq1eNWwYdDklwVuS/dcAEQ0O0JXK/7B2ZB3Z+dhx/sAjh27uxbaorQAI3P12XZwfC1cdHqlW7U1YlZAZSKA2gjoKObUossInYaHonPIIPSA+rdjOn57+7/6XHy1fEcqHWmTik5CJlR+hyg7F6Q3yCa9jxeH2uYcbBAYu5XJYtHLglADHmm7qXcYQ+Rub6zZs9XrftV7K+9Ezx8hHcvgKsqbGCGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qNuutu/Y69+68lSQJZHYouPx0XCSB4xhThnlomrMxg=;
 b=F6QXoLrTdVHwq0fivxnG1bZSUDX47rm25i3k9uPNDiUy0t6ve3VJQzLzeBpFCh+hcPzFfA0XVy+5aSqdqxf5xyCoQwy7pvnVmCxS6prmEC9uonprwc+Mda83SSDcHe9iK+Co9RJfSGs0DMwAK/Pj8p3557KtCau0VXOIbFXlSzPcR1s5DJSEIFSg8H+YVNqBC/d2T78i72EPpxAa+T+aoPHzjTB7+QUfEJi61PRox3/9nUf7Fwvg6z72EkO2Kad8nBBLVGfjI4OI43ty2OSEmZyuPGnLfY/k286Opnk1OUCamtuSTNoc6F6ticzPxXsRF5oAgk4mBxWz6nZcCFqa6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qNuutu/Y69+68lSQJZHYouPx0XCSB4xhThnlomrMxg=;
 b=qisvrh3bTHF3hxKPPC2TIp7OQe0vfTa7DN/HayR9cObHvWLZLf/K1oy03tpT6jgv1eFn925OA9ivzk/TlNo61h6x3LKyqc4FX86grpvuI6firtvWJGtK45+FLhmA7nCpWPSIsnpYggtdfUoiV6BZrgPB51J24OqZJDYbq9fsJ78=
Received: from DM5PR18MB2152.namprd18.prod.outlook.com (2603:10b6:4:b5::32) by
 DM6PR18MB3130.namprd18.prod.outlook.com (2603:10b6:5:1c6::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3933.31; Wed, 17 Mar 2021 06:33:37 +0000
Received: from DM5PR18MB2152.namprd18.prod.outlook.com
 ([fe80::513b:e492:8937:9e5c]) by DM5PR18MB2152.namprd18.prod.outlook.com
 ([fe80::513b:e492:8937:9e5c%3]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 06:33:37 +0000
From:   Bhaskar Upadhaya <bupadhaya@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH net 1/2] qede: fix to disable start_xmit
 functionality during self adapter test
Thread-Topic: [EXT] Re: [PATCH net 1/2] qede: fix to disable start_xmit
 functionality during self adapter test
Thread-Index: AQHXGpOFh4UaGbfuMkmePnEt4RJkE6qHKiaAgACNbkA=
Date:   Wed, 17 Mar 2021 06:33:37 +0000
Message-ID: <DM5PR18MB21529A16BF342B1DBC344403AB6A9@DM5PR18MB2152.namprd18.prod.outlook.com>
References: <1615919650-4262-1-git-send-email-bupadhaya@marvell.com>
        <1615919650-4262-2-git-send-email-bupadhaya@marvell.com>
 <20210316145935.6544c29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316145935.6544c29b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [122.181.203.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e5c4034-553b-4728-1772-08d8e90e98f9
x-ms-traffictypediagnostic: DM6PR18MB3130:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR18MB313059FFDC5105087021102BAB6A9@DM6PR18MB3130.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvHNBbG4OBwr//pmZp/NXe7KtAImHv+HrVhaxWdJ6Sh5H/g5BAOoPgja72yH2v7bfm6brQ9/qY8Jpb0NUi8Le8PZ6YEveRmDVyvfi+6f6sABVG2w8ZIGAY41A1JXO+Ks7Az934uLsYn/iK0ZSLdlGVXurTxGDjhWyiiWQcb7c5F7BMtb4aAuomVejIon4sw+TW9+rKEcBgmQXVkXGHX/gPcmkbViiQ/AeEryrE0NJW1ClRNMyx8hDwMGc0o13rRphgQbdsJ1jMCFVgmg12CcMUF/FwdFzvhsfFnBLYLvHFrgUalH7BP59mfk4U44cPkiPKm545xQItTtnxkr9cig+dM/Z/1XSgZE1JFGOlxwb5b44DszCFGAR2W2tkTPRVzg1V9ixxupPOIh0eaJUanEa59j0jeFuNEE+zUn5gRONpEcVLVHyui+7ySp1xv4mpJdz+sXSg09K3qrptpLQxTmanUvuEgnFDTysbrO47swu5iQ7VupTDiujlExG/yKkI+rSw5QpkIlyxvsmZbevnZy3TEpVd4lNBvFw7XCLWNekfim5aYCOC0Tie5zHLhNoxS1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR18MB2152.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(346002)(39860400002)(376002)(396003)(8936002)(9686003)(66946007)(83380400001)(8676002)(33656002)(7696005)(316002)(54906003)(64756008)(478600001)(86362001)(71200400001)(66476007)(53546011)(66446008)(4326008)(52536014)(186003)(55016002)(26005)(2906002)(6916009)(66556008)(76116006)(5660300002)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?HxwWD2JN5SlZiC8jAPd9YgEzOw3UYuUXpcw6hq1cuS+0ohrUbwMc2omjXdzU?=
 =?us-ascii?Q?TPBGOedzyZqK1GWkApi9FvLKyOxFmhrrwQVzsMT63GSeOXkAVqFBd9xKPnTT?=
 =?us-ascii?Q?SH+mV72o4LF/U/ou1zKqrQkWzQVlyu0FDwcklGZk1jvg6AJmYTwOPUZLbWTQ?=
 =?us-ascii?Q?X0F7ocqcGAIyjJ5vio/6soO+06iKO1OZJhp6b0nLQqR5Obait7DxQZP6yn+6?=
 =?us-ascii?Q?Plm9EQMEroAURXUQl5ButRuD1UG4mzj893wZLQj0LOo7qgyxgE8XiP0ph8k/?=
 =?us-ascii?Q?L5yUCDSzbVBbQlpzpW6uOlrVJinVraQbjgk1neZc4Nuzwx4jYAB9eIOtB6+p?=
 =?us-ascii?Q?ZhT6upHz1nseSorkZaTlVGeRelx/io7vjEluPWplB5EG9x31SpJhN6GtgrUP?=
 =?us-ascii?Q?3AVbw52xEJAixXOfn6MOfz+qvQ5wqo4b7fN25XYtU2f5B3nkSs6NLx+31Ouj?=
 =?us-ascii?Q?0oLfBJWxRzvOGxcnQdvsgpvsQ2h9yQZnHjt19BPIE1rUuoH96CEs4fm5BPkl?=
 =?us-ascii?Q?X48+ZHyGl7Lgy5sBBEYsgGZ4FUILIx4GMTMrJONbQfZ44wPa+1Xw7m7hmzAr?=
 =?us-ascii?Q?Gc4FypJW46TvWClAk8/RtxVX/YwqYHnjXEdFPoKaqooW8sqroMp/h4GQgTMa?=
 =?us-ascii?Q?mDkstq07LWnP/pGQl+A5nfkNvW8FvIjG3PfJ9YkGLlkeny0lUhJjr1acAniC?=
 =?us-ascii?Q?PfaWV+1tXxEc0ZWiGf1YQO9om98M9gQoAcZl92qXOlIRLpdrQhGEsbJq6G7a?=
 =?us-ascii?Q?rjpGdHwxwX6Iigx2wq26yeNUvHohQcGzuG0sGgkRIUDpkc4CHnFQomwcpbcR?=
 =?us-ascii?Q?ra+bPJtuCpurMr48u/kHTvzvpP5N9s9woFYqFc/BLC3T8ErKYkt2Rt2H9QRB?=
 =?us-ascii?Q?3ZqDqPHscBx80Q3FEe9JIsy3hHt8HwB9INnsvF8CFUnc92Hw9gtJdoqGfGDf?=
 =?us-ascii?Q?j6Bcv8FXgTyHmBnI9qbItF5+40oRCWWOlx7+RKPBpj/9wO5gAXoZHYfP8WDS?=
 =?us-ascii?Q?iuQGrogad7yv4qOaN/9kBCAxCI1y9QT/1ukWrEMakUPmA6cGm4Jhb2KckUTm?=
 =?us-ascii?Q?ZvZsZLiKJgekjvHDb8DEfH4gBDpFBbKg3lEFftRJmbWZ80v8jyw+s4fCncMA?=
 =?us-ascii?Q?OCNlVkUQt+xl7fG6qc0oKNdQMvNOPzrm451dpiEHrNqnVgPFwvyZAqRJ+6Fx?=
 =?us-ascii?Q?Dm9PZO7LyLayUvROS52M4si8GA213oy5KnU+xAbAMe+yINh4VifoL33ExNsB?=
 =?us-ascii?Q?1loYlGfqogAaVKCBAuGveRxqebVn4ln6eXkuoHKQ16s3ceWdJ90Jq+txKKbm?=
 =?us-ascii?Q?QlIKppBoLXY0PVEhEqZ2s4yt?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR18MB2152.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e5c4034-553b-4728-1772-08d8e90e98f9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2021 06:33:37.6491
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mKFkRoOPNRKcbnVi1X4Eoohu3FIyfRl5BZs08+BmK8Il2/Mwu9Nsz4vb/25RLzjq7IHaOHtA1hJjlZpW3Pw0og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR18MB3130
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-17_01:2021-03-17,2021-03-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, March 17, 2021 3:30 AM
> To: Bhaskar Upadhaya <bupadhaya@marvell.com>
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Igor Russki=
kh
> <irusskikh@marvell.com>; davem@davemloft.net
> Subject: [EXT] Re: [PATCH net 1/2] qede: fix to disable start_xmit functi=
onality
> during self adapter test
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Tue, 16 Mar 2021 11:34:09 -0700 Bhaskar Upadhaya wrote:
> > start_xmit function should not be called during the execution of self
> > adapter test, netif_tx_disable() gives this guarantee, since it takes
> > the transmit queue lock while marking the queue stopped.  This will
> > wait for the transmit function to complete before returning.
> >
> > Fixes: 16f46bf054f8 ("qede: add implementation for internal loopback
> > test.")
> > Signed-off-by: Bhaskar Upadhaya <bupadhaya@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
> > ---
> >  drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > index 1560ad3d9290..f9702cc7bc55 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
> > @@ -1611,7 +1611,7 @@ static int qede_selftest_run_loopback(struct
> qede_dev *edev, u32 loopback_mode)
> >  		return -EINVAL;
> >  	}
> >
> > -	qede_netif_stop(edev);
> > +	netif_tx_disable(edev->ndev);
>=20
> But an interrupt can come in after and enable Tx again.
> I think you should keep the qede_netif_stop() here instead of moving it
> down, no?

Hi Jakub,
Normal Traffic flow is enabled by qede_netif_start(edev) and which is place=
d at the end of this qede_selftest_run_loopback()
qede_netif_stop(edev) is called prior to the call to qede_netif_start(edev)=
, so unless qede_netif_start(edev)  is called Normal traffic flow will not
be operational.=20
>=20
> >  	/* Bring up the link in Loopback mode */
> >  	memset(&link_params, 0, sizeof(link_params)); @@ -1623,6 +1623,8
> @@
> > static int qede_selftest_run_loopback(struct qede_dev *edev, u32
> loopback_mode)
> >  	/* Wait for loopback configuration to apply */
> >  	msleep_interruptible(500);
> >
> > +	qede_netif_stop(edev);
> > +
> >  	/* Setting max packet size to 1.5K to avoid data being split over
> >  	 * multiple BDs in cases where MTU > PAGE_SIZE.
> >  	 */

