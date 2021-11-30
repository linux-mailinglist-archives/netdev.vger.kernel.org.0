Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010CC462B97
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbhK3EVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:21:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:1742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232110AbhK3EVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:21:50 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AU0FT7C026026;
        Mon, 29 Nov 2021 20:18:27 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cn23wtsvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 29 Nov 2021 20:18:27 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5eagrRIEw6Oky0TrQxjWz5OveSQ+MEoOYwGVzEU+2k4EnRsj15cQQX4NYi+/ZRWIGrAucK8b9VOsS/1opBZe1oDwVYd8ZGbaTv7ptjfwrS6/QWbYe+/JW12DHX/Bq7P3+4jXeFWAHZ9m/T6I41sCZrEKmMhMKeTz0LpQURXY8IXMAW71pPmgNPuRkV1iHjpG8ft/gf+icRh/qWs+4+6tYgLxYzdGOzKONnYlmIW8QwJ2jss0TPiRJognuPEmVqDCE6PMTlNYZMJqX4l5TRf7470mowrc81xLtRdpPtUj5At+JNLlaIR6w8SbAS2aZ1rPDKTGG0xKIgP0fufFhi/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jcHiaT+LzDEIQSioQJGjJxQ1dIukEtTWRahklAPQTUI=;
 b=eyvlldasDYnfzuukAwDkV6+0aSmdq5Zsg5GbalvKIIzyJPdhF7z+Ht56ruvFkLOLVPeFsPJZDzWxzCChberumOVs4eMZ3J6s+fGk4wkEc/aGkLiP7a8TH7nA0jrX+VLPMTTsRviu6VVxDGYaVub64qMhw2heplEp9S9QeTU7DCfydENVRfOQMshJF/vl45DaFZrP4VJekZJFKD41UAYkx8/caEMgGR9o1sWmeh2KBAjpv6KU5FRljrNQui14ohC2921noMwn1o2CRpwtvmwNxGT9oXDGytqcQm2xlzXeo//IB7V9bL27rKbk9fzPRPYdgBX5JUMKZ9aqhsSuI/+xSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jcHiaT+LzDEIQSioQJGjJxQ1dIukEtTWRahklAPQTUI=;
 b=OQlRYNpkt11iX2sMSbuaJCPRcO4QiHh9Z5Szo+ql7dnX/kkrPTI9HBpNE7T3R8e+ngOP+MAaAfAUQ22Um2IDc+6wI02Qff1nu1+CbNPFvOzz8FtE6qe1spnV4sfZrf9xm77phlKODTCUmD3ReN6grLwHEqWCi7uZBoarynqVDHw=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:2d::6)
 by PH0PR18MB4088.namprd18.prod.outlook.com (2603:10b6:510:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 04:18:23 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::e07c:9beb:5ca2:66a6]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::e07c:9beb:5ca2:66a6%8]) with mapi id 15.20.4734.023; Tue, 30 Nov 2021
 04:18:23 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Igor Russkikh <irusskikh@marvell.com>,
        Dmitrii Bezrukov <dbezrukov@marvell.com>
Subject: RE: [PATCH net 1/7] atlantic: Increase delay for fw transactions
Thread-Topic: [PATCH net 1/7] atlantic: Increase delay for fw transactions
Thread-Index: AQHX5SWEoT51uvBhykejN+QmkGpO66wbXyAAgAAWolA=
Date:   Tue, 30 Nov 2021 04:18:23 +0000
Message-ID: <PH0PR18MB403945808B0BC23ADF537147D3679@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <20211129132829.16038-1-skalluru@marvell.com>
 <20211129132829.16038-2-skalluru@marvell.com> <YaWQ6gib3t5zu8pE@lunn.ch>
In-Reply-To: <YaWQ6gib3t5zu8pE@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bc0f938f-9981-4cdc-c2cb-08d9b3b8733d
x-ms-traffictypediagnostic: PH0PR18MB4088:
x-microsoft-antispam-prvs: <PH0PR18MB40885FD2090C20C3C4132FA3D3679@PH0PR18MB4088.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jD0hvL4STqFOjZol1EE8PJ2frEwHhNsj2Nb2BzHlkvkkg6woMPBr+SnEVsrFvh3orjVy8/o1bBAYTHEs96wrVrgiOf1QMcxlIZXaba5fc3FlX8Xamo/W5MfEJM71v5J9PxVmGJwqB/DLBzX4LlaAxm3+MBexCu8gM3SKln3UVLSFBRSVuL72Zkvk5PXTLXKj2y2DMjMw/w/L4frD3Ytz1cMHNrSZNttsRlfAE5MTbwtJBb6KKGsvvs0iu9WRXBXeXnR8oDeHjpxROw5YNktwe5JX6+7QvPv9CkGcfxWpLe1cT33iZd96igh/5oBBeO6XQfMdNGU2urr72gDbWY4XVHdiehxk+hcsRYQNYuG75sJSWtL+QKmTGYd/QSGVL5lrGX6p/9VyK9JsSQuMyAj+Ku6EsFnFfRMwGGAXSiVn1MGrrHjYjmOpX20G9T/3/xOF3UlDimtkdG9DZbx09EpMtCzs4tMzfh1VAcoX0fTFT/Aj8SvO7ji/9Jkl22cLjSXFCoafuq11yVnvEzDRcSjHUvX+bru7AuV4yiqC4VKHls9D5kqmBKYUkPWMhkTcpTlHeo8Wi2waK65rCVqI9IiBI5YPCiWSFIWj9oSgVAoQ17jffQd6KNC7AHo9RyypJmzckfj8IIp88YUp3yonCDZqMxzuELiWZzc+wXAjQoVYCGqJHgzyIf3V897CQBZd2MI+2xJfCu0s9zi4q9lmo66bcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016003)(4326008)(2906002)(33656002)(26005)(9686003)(8936002)(7696005)(122000001)(38100700002)(71200400001)(8676002)(6506007)(53546011)(5660300002)(6916009)(508600001)(52536014)(316002)(38070700005)(54906003)(66446008)(64756008)(107886003)(66476007)(66556008)(66946007)(83380400001)(186003)(86362001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QIda48DgruTEmv7NdSWxMacw7gCA2MrFdXuIQcSo//FyKA5ayNJg1JM256IL?=
 =?us-ascii?Q?nAACOaNHxejViLVA9ZOHsq+PUm45N5QCeqUyGyYOk+sey4pWmRuAWnHPyoLL?=
 =?us-ascii?Q?4NbJ+a1vax+pWNxGXYDi/lOKXRxVO1Jz0aWyPAtFhwFB4DM7HD4nkETix/Wq?=
 =?us-ascii?Q?LDvNTLpIlf1w4OTk/RlrH1SO0yXjfJk1O/d3u92fQJQYO2sZY97FV4mLh7jx?=
 =?us-ascii?Q?t/tAK1Apq4s1Tq/i0YRyJIOSG31IKUTJKXPle9cqlbYU9p0J9XlbOI+t3rRe?=
 =?us-ascii?Q?dO1eK6twoWC/tzIyLMpzYMVKcUZPJVSzhLsNwjQsEnlXk2ueQondVKxZ4mjM?=
 =?us-ascii?Q?GTszpBwdDifT9CiAtyaBh5OT4HJp9/2A4zD9GBOo6JdA/14Z0bArpyaost08?=
 =?us-ascii?Q?Z8RaEKJTddkvJgHrdo6sc6d36/BtsNOiJ/ql6RYPkhplzvc0xjJ2HvUx/kC9?=
 =?us-ascii?Q?FZ+f5JeC0SJX2x5ucgnOnIQmvuuf8U/vNSSgX1O1cQBUbFLLQ2ODOvJER0LL?=
 =?us-ascii?Q?p6Henw96kpV2YPKfv95LhesQQpGzj0Z6tV8m8EmNqjvZMZPIylf6TH3B73b+?=
 =?us-ascii?Q?cYJOxh+yUCnRRuzTOoLWX8DJ8sBCqKRREUvkgACasIJsjqop14gCE75DbXlz?=
 =?us-ascii?Q?Ylpy3mcrXtTER8zrHmeFNAnhO13AXG76SMCQRAITfAlbZQsHY8D4MIo+8DLv?=
 =?us-ascii?Q?+Xaic/Kgn84lvUjOKDWD5ZDFVOs4Psaica7DXHcNLJdHmtm2zAj2SgI9f8rU?=
 =?us-ascii?Q?VGvSPM0WgJNKCSmfvrFBszXyNGZOucoDve6aNKi8CVhhi92MfGgj8PjdoYO6?=
 =?us-ascii?Q?uWDFHJPq/5dRqN40xSBNjqVIlAqtaaY+prZ2iPE1SIMRj8faGqvCdCNaoc5y?=
 =?us-ascii?Q?/rCC2JS5uwGxsOdgaBS9U6B2UiRhd35UV9BjtVz9i6JdmgdYH5FLF6oVc6ij?=
 =?us-ascii?Q?jgFrQJ8otIoafDS4Bffp2LNYr7GSZ8p3JQ9wU/YVpjLQnQMk3dDLLerfBnSe?=
 =?us-ascii?Q?yoMoGnztX18BrDH4vNx8yIzfmZt6VJ9O9W1laAsWuQ84u4OwXCSMb0vEJuYN?=
 =?us-ascii?Q?aNlGOv2G8HGXn4MlM+01zuJTEnWtlFemRkPBqqKlFzxmxXLDU8h5QTOpZ32f?=
 =?us-ascii?Q?AGPrZhlwrkxtzIVPsfEbgcUbCt+L0qpZCLUuSuWYKlZ4eI/nF9rSM/zU3v9a?=
 =?us-ascii?Q?IZRJw+hB4TmnmWKrAbAXFdoVnrc0N9Q0Fpi65rh5G+jeEHlF8V3ntIAXTn+D?=
 =?us-ascii?Q?i66UPhGeVyd5MOjdIsqc+J2tgZI2FdkQ9LwWYChOCM8/2ZBBXIJ4skQc0noO?=
 =?us-ascii?Q?wx+/OCsWFNimNmdY5I7AG7f1y2QV+dvz0ZIzCpAWLVEyGn1rBGvVwTEWwUdg?=
 =?us-ascii?Q?DOa40yoeApFJZ1lfqjQCIZb/RmfXvEveZtgDegG9nvyw3u8CdqZWeibWmYMB?=
 =?us-ascii?Q?gg+8ZrCSw0jq16yIVq7NrN4F3COQKXmER5py9+Wmox89gA1zIgESSOmyDPaN?=
 =?us-ascii?Q?8LH6eJJKFoRrEJrKuEvxhrWtCVuGUryB/+PQH83TsVlN5llhfpLv/jfSLxUI?=
 =?us-ascii?Q?btYZOXepfTSAibfucdqtqGTQwShKXYz6BgetD/dKMMGVYb60H9kEeyxoG6lG?=
 =?us-ascii?Q?YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc0f938f-9981-4cdc-c2cb-08d9b3b8733d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 04:18:23.6506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: k4RBJlj63t+Nz1FToMgCcyNJo7O4flCYO065GEhPTul2Klw6MO7QAnV3fIjYI1lr5hcxFAzJ6k3LpKXxfJ9RLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB4088
X-Proofpoint-ORIG-GUID: T39rFErayYoTATSj80loDKEkrnDfkkvC
X-Proofpoint-GUID: T39rFErayYoTATSj80loDKEkrnDfkkvC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_04,2021-11-28_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, November 30, 2021 8:18 AM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Igor Russkikh
> <irusskikh@marvell.com>; Dmitrii Bezrukov <dbezrukov@marvell.com>
> Subject: Re: [PATCH net 1/7] atlantic: Increase delay for fw transactions
>=20
> On Mon, Nov 29, 2021 at 05:28:23AM -0800, Sudarsana Reddy Kalluru wrote:
> > From: Dmitry Bogdanov <dbezrukov@marvell.com>
> >
> > The max waiting period (of 1 ms) while reading the data from FW shared
> > buffer is too small for certain types of data (e.g., stats). There's a
> > chance that FW could be updating buffer at the same time and driver
> > would be unsuccessful in reading data. Firmware manual recommends to
> > have 1 sec timeout to fix this issue.
> >
> > Fixes: 5cfd54d7dc186 ("net: atlantic: minimal A2 fw_ops")
> > Signed-off-by: Dmitry Bogdanov <dbezrukov@marvell.com>
> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
> > ---
> >  .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c  | 7
> > +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> >
> > diff --git
> > a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> > b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> > index dd259c8f2f4f..b0e4119b9883 100644
> > ---
> > a/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c
> > +++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.
> > +++ c
> > @@ -84,7 +84,7 @@ static int hw_atl2_shared_buffer_read_block(struct
> aq_hw_s *self,
> >  			if (cnt > AQ_A2_FW_READ_TRY_MAX)
> >  				return -ETIME;
> >  			if (tid1.transaction_cnt_a !=3D tid1.transaction_cnt_b)
> > -				udelay(1);
> > +				mdelay(1);
> >  		} while (tid1.transaction_cnt_a !=3D tid1.transaction_cnt_b);
>=20
> This change is the 1 second timeout.
Yes,  FW manual suggests 1 sec timeout value. Hence the timeout period is u=
pdated from 1ms to 1sec.

>=20
> >
> >  		hw_atl2_mif_shared_buf_read(self, offset, (u32 *)data,
> dwords); @@
> > -339,8 +339,11 @@ static int aq_a2_fw_update_stats(struct aq_hw_s
> > *self)  {
> >  	struct hw_atl2_priv *priv =3D (struct hw_atl2_priv *)self->priv;
> >  	struct statistics_s stats;
> > +	int err;
> >
> > -	hw_atl2_shared_buffer_read_safe(self, stats, &stats);
> > +	err =3D hw_atl2_shared_buffer_read_safe(self, stats, &stats);
> > +	if (err)
> > +		return err;
>=20
> This change however does not seem to be explained in the commit message.
> Not discarding an error is a good change, but it needs commenting on.
>=20
> Also, looking at hw_atl2_shared_buffer_read_block() i notice it returns -
> ETIME. It should be -ETIMEDOUT.
Thanks for your inputs. Will discuss about this internally and send the pat=
ch to handle all such error paths.

>=20
> 	Andrew
