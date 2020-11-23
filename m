Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101D62C0F2E
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:47:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387636AbgKWPoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:44:30 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1386 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731499AbgKWPo3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:44:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0ANFZjDf017424;
        Mon, 23 Nov 2020 07:44:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=GXOcJTKQ2B7ePM6n6IJesXfV3z03clOQ+7qGs8Fl4LY=;
 b=h7yByN8yvLAFxkA0v4E6uHEs2gk8Xf4TnQeW5YitQikpI8Jhj0ooGs84bA6kz9FH26M9
 P7OSOKrvv3d8dKNpPtQX3OWSmpmIZ8fvjlf1UsoCLDFsBLgxysAzOl7qq3ivfdyVE82W
 NAoRpdxBL8ADY/QNv0eXs9HQGH0p4sXBbI0YH6f/WOUv5ctDuX1Hv0NoW4wCDKofcHn2
 q4zkWjZZgeTu40wLGslCqSwMd2v3tH99cxRM0slzruxJYrk436xNbarKo2hc8yPuu1N7
 HRt8xFFQjKrpfJkDUdyn8AhFloZBoCfy6cjLQjchE+V5aXMEa9Z6qfnzLNIbxGsbDFSG 9g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 34y14u69am-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Nov 2020 07:44:08 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 07:44:08 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Nov
 2020 07:44:06 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.36.51) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 23 Nov 2020 07:44:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq9f5bZ5UYHAdFM5Volw1sk6hZ9lsZBvmebaWYr4m/1y+Y89HnvLYdxZFTIl7i8zitMUdO7ex9UUjlrcBZI13mjUi19daFMNGDqegEyQox3eI4Z9DjdiRhXJzLP/X0VVy7a3TKdaPEoZRL1Vxev9jn2ycP74KEpNzZKk3FupINFIq52rnTy09m+LUCC/3QoUVMAhRwuefEJsGUxN7Fm5luOW5GKt2Eg7jKp2T7FE8/8QHj2+IItOMFrv03iBuRpysMady2RG7C+yVoVXuIXlwtahYWKDLgpbw6XzewsD78qacLWOTNhEK/Mh/Do+zaG9yOvnHvB7rF0CoRhs6q1RlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXOcJTKQ2B7ePM6n6IJesXfV3z03clOQ+7qGs8Fl4LY=;
 b=cE35lL/UE0o2Nb6LbowCSSrvDqZf+IcqsROGVdKteyDzntRsvnicthUrF052smesw1a9iOpske6jiWnBb8AiLrsenVEJsCyp9LS4kC3H24JLJRWq2m2IDXsQDGhVWUpWL22hirxkCdiudVvwRy3L1uYIvZZQLrm3nhfl9z0PPWFG52d1TiTlBGkh1KFBI0MsNShQwUUr2RmGYkw+xUGzSKw0Ofskl+4gK0ffTy0t5Oe4TabDtmi9qgrInil2yBjffoXOZbqLDkbi2Jrae5LHvxJhgHzsVpepL4Rv51G0coeOyRAN58many5mrqLKTqdElelOtM1mDQumCblmSxMBJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GXOcJTKQ2B7ePM6n6IJesXfV3z03clOQ+7qGs8Fl4LY=;
 b=IArxALdSL3sXmd6KIPiHx6ldfXPNz1pPXOEm2pq+xgdR6Vec1EwSvNKGeXZhIXrEv9nolB9YDgECzjijPvxKldWcdwHP4U77ZokGLUDznZRsk67+VOAF3oXZh+V+cZRyr3bIXRjceCbrBdOaAikZ3Ia+WuOfXZ31fqj4DYOg7hs=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1087.namprd18.prod.outlook.com (2603:10b6:300:a2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Mon, 23 Nov
 2020 15:44:05 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%6]) with mapi id 15.20.3589.022; Mon, 23 Nov 2020
 15:44:05 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active ports
 only
Thread-Topic: [EXT] Re: [PATCH v1] net: mvpp2: divide fifo for dts-active
 ports only
Thread-Index: AQHWwahlp9Sv9guVI0awfVNHHhZxM6nV0laAgAAAoWCAAAW3AIAAALag
Date:   Mon, 23 Nov 2020 15:44:05 +0000
Message-ID: <CO6PR18MB3873B4205ECAF2383F9539CCB0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1606143160-25589-1-git-send-email-stefanc@marvell.com>
 <20201123151049.GV1551@shell.armlinux.org.uk>
 <CO6PR18MB3873522226E3F9A608371289B0FC0@CO6PR18MB3873.namprd18.prod.outlook.com>
 <20201123153332.GW1551@shell.armlinux.org.uk>
In-Reply-To: <20201123153332.GW1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.66.81]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8010a714-52cd-4258-4e3b-08d88fc69bea
x-ms-traffictypediagnostic: MWHPR18MB1087:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB1087242D7793D169B71B0DC7B0FC0@MWHPR18MB1087.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RE5JA/ACgSUSplf7Ip3v1Zmcg7vP5QdBn+1MppdF9tKyY0FIQTyEUc2fwL35oQU/RONOiEEVIxXLYyPgm20EipQpqJwroiaIMo/w6TDWTObjzQynm5Ky2NKW8KpBRyYfmS3pgOd6CIHQlUWZSu3BMyKK0hSblmrrWjHdscA5UL8/1hgzHk/eynmxTApyrFLQNVl9MmXimoJo1y0fNQuTR5hKcviwvusjZ4wKnHYhInGpaWTHy0gTCaRZAM6Be8vY0fjAXcepPeUv+IUDu3n8UyOUcfhfkDCjuRlr46Y04F+RnGpEnWlJGzLaBQgScfSG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(376002)(136003)(316002)(9686003)(6916009)(54906003)(2906002)(52536014)(83380400001)(478600001)(33656002)(186003)(6506007)(26005)(8936002)(66556008)(66446008)(7696005)(71200400001)(64756008)(8676002)(76116006)(66476007)(66946007)(86362001)(5660300002)(55016002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?cYXDRnEm5hDC1y7ptxZbR3+oFGWmHmq2fmfoAXJVNymR+EsaCRWJZAQcb3va?=
 =?us-ascii?Q?pJmAGWDikSTdxb+TA/9Rg2qDwYC7t9meU4ymyuA8t2mwBWodlj1HrosKGEmt?=
 =?us-ascii?Q?9uKhFXRUYwZXnhDO4RMq+JQU/jOsZonHXqaUj/+6AMWl4B2bHJYw3ANS+PCh?=
 =?us-ascii?Q?/tWID3p8koVvWPs2bE73EEQ/8M3PwavxdoQNJsluBE++BUADa252jotP7iJF?=
 =?us-ascii?Q?LYW+tp5q/TmyOpJxp9tOp3M0nuzQuVpdjPEzF+2yIl0wsCxSv+xdSb6BvK/g?=
 =?us-ascii?Q?bLxW3GrWZZic3znY+/U/K86XNn9g1tq3zbo3B7lwIUoKmd/l5EVyZBPS5rWe?=
 =?us-ascii?Q?F6O2065J3dbyzCYxChnLBxTOLGp7MTcXRvHVWX9tSbmtNXVpZg884SALvVfC?=
 =?us-ascii?Q?cpPG7qwDCcn9udQ9gyLJ9JUgEurTbUiV6zPGvtJLTZkq4BfX/Fr3x+LUml8u?=
 =?us-ascii?Q?ziQJBenMuAWGf50uj9UDtU1kYmFc1zqzqrR58pHWHfMeNQTa+MeE5TpjH+bR?=
 =?us-ascii?Q?T9JlAb90f0fzYqVjgmQkbxmMVUWBholfrhVxeut9XY1ElIYgbVZkkVlbeVpX?=
 =?us-ascii?Q?TkKjgfvn/frcYNUQidTbxwXK5WueK5KpBuw1vNTrSPDtkMSbWJgB95KJkg9m?=
 =?us-ascii?Q?IVfT7FMS1GamOuD/hbQhJTnn5c3HdFwEqAK3K4NcqUpkewMdV36iu4jSwz9/?=
 =?us-ascii?Q?iIsyFSH++jtSaO4sS0WJphzuk9+W8u9BI2gBcfWdcSNe0NEjCvIa/pBhn6p/?=
 =?us-ascii?Q?BvxUXLe50c+Q/R9OaNwOJ7mXS3on99XLgXc+7+clNYu7GXkWIa4gX9vmb6I6?=
 =?us-ascii?Q?wqQ0P2dnAI1cHWlF75e6aH/S3Z5ladA+GzzXmgq1V4RxcVdSU6anmlGRbjpX?=
 =?us-ascii?Q?pzML8pkz47F4ZkEKURTqZoq2SPqKLhcFP1x2SJunC4qw9Ly7Q4aDUVNxWfiU?=
 =?us-ascii?Q?NjrpQabitueIIrN71Y1M58b2jl9xo44HEk4UJ1FE9Es=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8010a714-52cd-4258-4e3b-08d88fc69bea
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 15:44:05.3821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g/h0yOrvkP2DwjO1wjnhNvYf+2alp5WOM+1PJV4QkCetScWvsxiwbQmBTzveO6rPQgZ5XD8p+1jXC07pT+AA9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1087
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-23_11:2020-11-23,2020-11-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > On Mon, Nov 23, 2020 at 04:52:40PM +0200, stefanc@marvell.com wrote:
> > > > From: Stefan Chulski <stefanc@marvell.com>
> > > >
> > > > Tx/Rx FIFO is a HW resource limited by total size, but shared by
> > > > all ports of same CP110 and impacting port-performance.
> > > > Do not divide the FIFO for ports which are not enabled in DTS, so
> > > > active ports could have more FIFO.
> > > >
> > > > The active port mapping should be done in probe before FIFO-init.
> > >
> > > It would be nice to know what the effect is from this - is it a
> > > small or large boost in performance?
> >
> > I didn't saw any significant improvement with LINUX bridge or
> > forwarding, but this reduced PPv2 overruns drops, reduced CRC sent erro=
rs
> with DPDK user space application.
> > So this improved zero loss throughput. Probably with XDP we would see a
> similar effect.
> >
> > > What is the effect when the ports on a CP110 are configured for 10G,
> > > 1G, and 2.5G in that order, as is the case on the Macchiatobin board?
> >
> > Macchiatobin has two CP's.  CP1 has 3 ports, so the distribution of FIF=
O would
> be the same as before.
> > On CP0 which has a single port, all FIFO would be allocated for 10G por=
t.
>=20
> Your code allocates for CP1:
>=20
> 32K to port 0 (the 10G port on Macchiatobin) 8K to port 1 (the 1G dedicat=
ed
> ethernet port on Macchiatobin) 4K to port 2 (the 1G/2.5G SFP port on
> Macchiatobin)
>=20
> I'm questioning that allocation for port 1 and 2.

Yes, but this allocation exists also in current code.
From HW point of view(MAC and PPv2) maximum supported speed
in CP110: port 0 - 10G, port 1 - 2.5G, port 2 - 2.5G.
in CP115: port 0 - 10G, port 1 - 5G, port 2 - 2.5G.

So this allocation looks correct at least for CP115.
Problem that we cannot reallocate FIFO during runtime, after specific speed=
 negotiation.

Regards.



=20

