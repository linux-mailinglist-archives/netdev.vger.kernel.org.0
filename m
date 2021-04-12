Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E354835C8C1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242133AbhDLOaJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:30:09 -0400
Received: from mail-dm6nam10on2098.outbound.protection.outlook.com ([40.107.93.98]:2828
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241820AbhDLOaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:30:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klKrD5Ie98Xlmg2wbWb/zqjUAffcyMqzyWfHvEdSY8il8AM1O05Jhmj4cji97AtoOwW6py2jEAHAVWV7yDbEsnKhua5/frbKLeIE+wlgSPSY6uMXwrtUwO7BHrES33p9QIrQROUfGJgTgRz0QXFtoDHn9vaE141g/4yz7a3HiSZXqKBqsatTno9idgC/EKETRWSr1yrSchHbZluV33tYQmVv6rB5nM9RX+E31z4qXV2ajE+kOtfwqkPI6JMvVNYSiod3wjplvdm868wKXhBxhMrBjIq+GFaAzsnp8nNOvEAGIlyRoMznVyNHTwh74X7PyGGykuB9Z3bgAOhuJn3ZfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOm1bn8SlZ5EYOVbNu4DoPdjS43V1oXmQp6oSuqBldc=;
 b=KUQlQ92v6ER1gpRdmwsMdiQWL6IsfNlH04VspaxTHLAuJpk0VMewfJ82B2YvJEO2RCmvi5PazdEBlEUq1b8GYAQMhY3FJjHN8SgIwUZ1czt/s1p3zkX5+GuTdpwTARG0yVLuKR9qX+3aW21qx470DNsET6Ezxm6KsMdV1CKNUr5Hkvqir9+dHI8WTWWUbQoL0uPHYy1k8J3mq+PQeQn3IP9RwHMW03qlN5x+/8RHGK9IP8ahzTgH6PpjnUcnQtMM8H0BmB5r+Avic1HrPiqzRpSZELhw6lg4meyknRiz+bAXDX1LO4+jaN9okF7lrzVmCpj+WqCA6G7jdfh9dDdtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dOm1bn8SlZ5EYOVbNu4DoPdjS43V1oXmQp6oSuqBldc=;
 b=Nym3AtN5r8J+skLyOUZsu/gMmOxIzMiWs6tSJEzm4qQBIg8lxXgY60YisGuaOemsaKAMF/TpYaM+G8/oEJjrLYYTniIf0onwc1eLaAVpB1THUlLj4MpVVIIAm0FcUuMrR5jmViIV0QNy2thi7GEkMb/FH4WQvy5kwKS17twW+Mc=
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 (2603:10b6:207:30::18) by BL0PR2101MB0882.namprd21.prod.outlook.com
 (2603:10b6:207:36::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.4; Mon, 12 Apr
 2021 14:29:48 +0000
Received: from BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785]) by BL0PR2101MB0930.namprd21.prod.outlook.com
 ([fe80::e015:f9cd:dece:f785%3]) with mapi id 15.20.4042.006; Mon, 12 Apr 2021
 14:29:48 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Andrew Lunn <andrew@lunn.ch>, Dexuan Cui <decui@microsoft.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
Subject: RE: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Topic: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Azure
 Network Adapter (MANA)
Thread-Index: AQHXL0SFh9wLy4oIlkiyQnUE9FecFaqwzKaAgAAkvYA=
Date:   Mon, 12 Apr 2021 14:29:48 +0000
Message-ID: <BL0PR2101MB093074F2F36A1C7471A40325CA709@BL0PR2101MB0930.namprd21.prod.outlook.com>
References: <20210412023455.45594-1-decui@microsoft.com>
 <YHQ5/fJyvkTHzBqA@lunn.ch>
In-Reply-To: <YHQ5/fJyvkTHzBqA@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=6032532e-a9ad-4c2a-aba7-c5a371aaf835;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-12T14:27:27Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [75.100.88.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebc58aaf-35f0-4977-2ef7-08d8fdbf6d64
x-ms-traffictypediagnostic: BL0PR2101MB0882:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR2101MB0882BA8B92344F1F273EDEB8CA709@BL0PR2101MB0882.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 82Omd+IKxwInP9tR5U//JrcCMjR5KuXtFvjTtArHZ5SiWSHVuapcoY8jkkCEbxaxFSmkmw+ugD7DIZXcOSwlPsFceIHN9pdrRfsZi8MpiupoBpxzzj4bZ7s3DF1DduOzqr4QILnRm/HU/TX7COoYwNvN+wBZfLfXWffgcUXjlbdedEZS7NKrvqN9ZWbBl3AAIpjkxSJjggTiSz+rzrHsCbd6JOKvvGzwwizocfyC//y18/ZK1PxzsKUGMp1yQPnQB+fxQonzrzkRsltKnnFXcJIg62ruW8ccfwCSicq1rkuA5TJq2hTnih/Zn9kX0k4CnlpkxyC4jDoq60hK18pIX4ix0vJhutxXzp5p+KEigzIdnueJP1DiLQt5IbiEzA59VM0fXYejYFfeXMfzgPNVDk04xt/3gyJXVvEy850iYUDyCqLTj5H77dsMlyuc+Wf1038pT7raO2kSjpZKt14bFHRis78ebekrJ3sS0RyCD6QRXNPi9H0IXXFUuVCtO+SQ1AIPgc988FKkAB3awtqZFZrayK6ZVpVH8CZiRYBotzhd1/MFDlKaqtAN6t+DGLWRtxR3Wvw36kaOXNJIVuoWDG2ZX+2V/tjtUSvUwdDLRPo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR2101MB0930.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(396003)(39860400002)(366004)(346002)(47530400004)(33656002)(38100700002)(7696005)(82950400001)(8936002)(55016002)(52536014)(6506007)(53546011)(86362001)(6636002)(110136005)(10290500003)(66476007)(9686003)(316002)(4326008)(186003)(83380400001)(66946007)(76116006)(2906002)(5660300002)(54906003)(66446008)(8676002)(8990500004)(26005)(71200400001)(64756008)(82960400001)(7416002)(66556008)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rkOHNQhjVTIx31IY4lQRMbVy++z/q/S8hjmTwEetAD6OnaCeMzHgPBq6EeqM?=
 =?us-ascii?Q?0dGm6VxjhI99lsw9EqH8juezrKj/9msoAq2QpjKeGI77S4JiWtMh6d3Xg6qu?=
 =?us-ascii?Q?noVSuo0/pvltEu/8920xbZ91ORYHyKxaRAv+65ASt4OmSgwKrdVSlCO41LUV?=
 =?us-ascii?Q?jaNQ5wGadcpEq7Khg6ePErQCbIyvgdLc/5/iTXelifOw+zwJCwMvHOcJI5YC?=
 =?us-ascii?Q?xWyxelm4pZpHKKz+jo8/BhJDj0c97zoO4FJ0FBWrRw666QBXyMrwZaTldD46?=
 =?us-ascii?Q?8SerxBUUtL1phB4PUxuyb2apitqgjAG5CZzH24jw8f0mKo04wNm6UfRDLaRy?=
 =?us-ascii?Q?FjlG4Udg4//bhxAc/L9BPpN7YhzcYHa992rzoniSatnsF0OlwkuSA1CdfKJo?=
 =?us-ascii?Q?gVenXpcdTu3nP7kD/Um9+1VDMBQ3OYVuVN5HDRFOpN9TE8i+LyDrPugIi4hO?=
 =?us-ascii?Q?McCSavzqceYOzmOms1jqxxbE1RQodTivqdkP4lurNEKI9kht35DXr6AN7T/a?=
 =?us-ascii?Q?cdNlNoeNAI+JfrpEQCWW2bhvj3hxjq9SplsR6MUz853vu0ltQLxzGLA+ikZr?=
 =?us-ascii?Q?O5XWwHX7v8AQgVY7O+KQkuBS9yEqQAZkeErKLiP4S4/G9bkesi5EF9rT3ywR?=
 =?us-ascii?Q?oAjM6+H2nyRyMMluEOXfZ+DV/5LCdM3hGxvU9AJcTMosWiUQ2VhcJrkVTl84?=
 =?us-ascii?Q?VPgPq7Etus8IXXbC+GDbV/KuC+YP439Rb2HxKVSoXEpXlp2batO1qzmeueue?=
 =?us-ascii?Q?YbcxwemnXY+FxYeTprhfrss7T8tbR4ApxKet1WUCGyEOLOF0r3SRFDrysjQB?=
 =?us-ascii?Q?OHEO+N8jgIMI6ULJcA1ywFkc0k142CIxjQHO+0ir0OcuvNSeb5UyFJpDfiYI?=
 =?us-ascii?Q?m9V2oBVpg88/koMD9flJucBnoRZ0EistSiGJ7V4Rq22tIQJuzK2slIrnjrFY?=
 =?us-ascii?Q?zNxMcCyHzpxJPFH1xtvJcF6p6E0j794OFQatvxI7gyJgxEpa8mlnRd6skTRi?=
 =?us-ascii?Q?jISQt6IbyKFem35lWEK1lWBXtvIeSeDDGMA1zmuN5FBN5FwPFJcOCI4vpNOG?=
 =?us-ascii?Q?tvJ+RRDDYRorNkxKSRK32I39XXjCVYJcbzMqSzDdWOeYozUqjTOY4jmY/1Oh?=
 =?us-ascii?Q?iF8XwXqUda774l8XPjoLZXU4bmwFw0N6S2Ur8hruoE66iupBEhwhskvtGT5P?=
 =?us-ascii?Q?qLnLadpVin7/o82KjSExVWiw0lnTM6G+Lz8UCsB7QS+Qwxarw2vkrKPcgxC4?=
 =?us-ascii?Q?AbV5xqYVSb6Lctc24NL/rtqo1MY21ay9NCM1qbHr0DzXibb2zmfJcMmPsRKf?=
 =?us-ascii?Q?OVgsbG4fXWGnqbrHRIyDnSQ/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR2101MB0930.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebc58aaf-35f0-4977-2ef7-08d8fdbf6d64
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2021 14:29:48.6379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4e0eq5AU2WNRB9el5nm4MKPhr6Z1MXK97jRRPRvfEVpv9XHs6ujReufScllIc+Zsxxi7a5rwbcrVdqkve8m3Dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR2101MB0882
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Monday, April 12, 2021 8:16 AM
> To: Dexuan Cui <decui@microsoft.com>
> Cc: davem@davemloft.net; kuba@kernel.org; KY Srinivasan
> <kys@microsoft.com>; Haiyang Zhang <haiyangz@microsoft.com>; Stephen
> Hemminger <sthemmin@microsoft.com>; wei.liu@kernel.org; Wei Liu
> <liuwe@microsoft.com>; netdev@vger.kernel.org; leon@kernel.org;
> bernd@petrovitsch.priv.at; rdunlap@infradead.org; Shachar Raindel
> <shacharr@microsoft.com>; linux-kernel@vger.kernel.org; linux-
> hyperv@vger.kernel.org
> Subject: Re: [PATCH v4 net-next] net: mana: Add a driver for Microsoft Az=
ure
> Network Adapter (MANA)
>=20
> > +static inline bool is_gdma_msg(const void *req) {
> > +	struct gdma_req_hdr *hdr =3D (struct gdma_req_hdr *)req;
> > +
> > +	if (hdr->req.hdr_type =3D=3D GDMA_STANDARD_HEADER_TYPE &&
> > +	    hdr->resp.hdr_type =3D=3D GDMA_STANDARD_HEADER_TYPE &&
> > +	    hdr->req.msg_size >=3D sizeof(struct gdma_req_hdr) &&
> > +	    hdr->resp.msg_size >=3D sizeof(struct gdma_resp_hdr) &&
> > +	    hdr->req.msg_type !=3D 0 && hdr->resp.msg_type !=3D 0)
> > +		return true;
> > +
> > +	return false;
> > +}
> > +
> > +static inline bool is_gdma_msg_len(const u32 req_len, const u32 resp_l=
en,
> > +				   const void *req)
> > +{
> > +	struct gdma_req_hdr *hdr =3D (struct gdma_req_hdr *)req;
> > +
> > +	if (req_len >=3D sizeof(struct gdma_req_hdr) &&
> > +	    resp_len >=3D sizeof(struct gdma_resp_hdr) &&
> > +	    req_len >=3D hdr->req.msg_size && resp_len >=3D hdr->resp.msg_siz=
e
> &&
> > +	    is_gdma_msg(req)) {
> > +		return true;
> > +	}
> > +
> > +	return false;
> > +}
>=20
> You missed adding the mana_ prefix here. There might be others.
>=20
> > +#define CQE_POLLING_BUFFER 512
> > +struct ana_eq {
> > +	struct gdma_queue *eq;
> > +	struct gdma_comp cqe_poll[CQE_POLLING_BUFFER]; };
>=20
> > +static int ana_poll(struct napi_struct *napi, int budget) {
>=20
> You also have a few cases of ana_, not mana_. There might be others.

We will rename the remaining ana_ to mana_.
Also the driver version to protocol version in your previous comments.

Thanks,
- Haiyang
