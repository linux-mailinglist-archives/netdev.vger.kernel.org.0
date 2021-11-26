Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3969A45F6BD
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 23:06:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244769AbhKZWJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 17:09:31 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38162 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S244962AbhKZWHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 17:07:30 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AQLnCsW015138;
        Fri, 26 Nov 2021 14:04:07 -0800
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3cjv2xabhd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 26 Nov 2021 14:04:06 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OgTEu4UJNiqFosomELxZscszQeUxuB09IQr1TdUS3BXB9lfw7zHgIr97z52i2JKiHYJab3TycX65k2683moXZlOs5GbDHkrMDiT04H/IuU9vcQxIkAtPvhHXTf8Ejnwq2wFQdnDvzMYxJLBNaXx2jMiP8kmYal9A+Nblc/ImjWaBlGNvffPseuR3UrpIaw0Lvh5PNvqcjAVZom4rwUv9qAPZN/gwSRpILyl3CMc+bUlp95VQo+AvXmjeLtW25PRgkQxcHR5x88tWiuS5PffRjIWDmGOzAT1JPxtfqhWaXi4ug5/lpXbPZZVv9Bar1CqVFUmHFUqlfT5xDv6/m27zZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D8b0476foVRQwlZQhUr9NZVqjDebLTkITUWRJU5xr8o=;
 b=MiSB+qPY9iUr4ArKDzGA1X4xqmeOgT/x5kxVrmBDYmgdpCwY021h9BYfIZTRwPbrynVjZBDv1Xt0es0kNS9CBrclFCPgsVSGBVvBlJ9tpYLZEgvVpFA2RczJY7shWadhWbVhIKtgxnaWBZghI+Hyy1sCI81QhkjxKXidI9Qx4FTIi9hIfbj5tNmH0hjM7V30vdIbZt4eC3YZs0m1VbnOEtmPW4JXQPBwTDtjA8ukXa4vH6spakLcrNkhf1lmA+Zqxr3urFgLzNKdHfQCstL/fH1xFLzTonh9/C2EwDUFQ5RaHnGgP6WiE+VFrFkaf24QC9dimlMzxT0NM6A4ZOtW8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D8b0476foVRQwlZQhUr9NZVqjDebLTkITUWRJU5xr8o=;
 b=t6yRIJn0NE6K2FRTErg/a+2uFI4xdKgyPrA0+iI2FJO39EVKquHM4dO+CyOjxASqQP9BolehxOUziFH+W7nSYGyf6j0tXAMCv48EnGeBhgyj2rPt0ClBcgZrW9WI+4Kzgp2vlhyu3fmzitWOIzlFOqCF0xv/Osx5BiJQ/GyQ1HQ=
Received: from BY3PR18MB4612.namprd18.prod.outlook.com (2603:10b6:a03:3c3::8)
 by SJ0PR18MB4394.namprd18.prod.outlook.com (2603:10b6:a03:2e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22; Fri, 26 Nov
 2021 22:04:03 +0000
Received: from BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::dcd3:e438:9904:88ab]) by BY3PR18MB4612.namprd18.prod.outlook.com
 ([fe80::dcd3:e438:9904:88ab%5]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 22:04:03 +0000
From:   Manish Chopra <manishc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Alok Prasad <palok@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: RE: [EXT] Re: [PATCH net-next 1/2] qed*: enhance tx timeout debug
 info
Thread-Topic: [EXT] Re: [PATCH net-next 1/2] qed*: enhance tx timeout debug
 info
Thread-Index: AQHX4RfGveHSdOnMLUG5Y4T3rAh3U6wTjIOAgALAJJA=
Date:   Fri, 26 Nov 2021 22:04:03 +0000
Message-ID: <BY3PR18MB46121917AA9B79B570F58637AB639@BY3PR18MB4612.namprd18.prod.outlook.com>
References: <20211124094303.29390-1-manishc@marvell.com>
        <20211124094303.29390-2-manishc@marvell.com>
 <20211124185131.2cd860d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124185131.2cd860d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 072fec3b-45a1-4509-bee3-08d9b128a873
x-ms-traffictypediagnostic: SJ0PR18MB4394:
x-microsoft-antispam-prvs: <SJ0PR18MB439467E085AAF8EE27E8EF2EAB639@SJ0PR18MB4394.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SsWfLwl69By6jexZeseB66rmF23hB8c29YyDTcI689WPLfHQvk4vrxuENj+Qo1VXKPRDUa2ClY+Z320CfzrvdDhcih8AP1E9DK5ITMFXaRBo37t7mivZjp90PGSxmcPtDHOXWaOKQFhDQfd7aGtYTHuCD7Vn30YxRGizT4YkDTIzZw/GBrBeQ/KaLL1+hvVQotGQTzNmHd9yt9itGu8HRvURVRZjGDJEifIVnDoXcCWWfEqqeplL0DdYd6z1Qjf8JtAK4/+V5yVWJKKjOZonT+6nvFqmyLV40anqfVUfFWGX+mOY62m9axBtAkEbf3jOlj44Ser15UnHP5zuG2Wzq8OUt46cAsziZAsIrj5X4AkGzAgFFCkso3wn2K7JQVjShqyLL6C0XNO3QQpqg1aNmQVqbv5Bok35VfuL9fRTIAoSuV1kqurPX5a5ApDVZe5l2BOJXZfrzQyhWML69RATWRvFyicIEjv1tLTJHnnrPswZj56HZxPX6vj0JSd3RKtKLmdSAubukiYuwCFDzWjfkFFEinId51Sql3gZSJozIFkRQeExu4Kr1TE5LXnm+X19GvKjLQqeCZO5OaLADB1R26r7RUuELTritBQNQcdmHHioJtfUTVB9aszQ+V2/D6tEKMZZNSiBfR1h3Glky4kP7Uy00LrNtEINu04VhaqSJ54XKNnPp6pPwSKl/xSPJEeAgSPKhHspgrviI0pcPQ2s3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4612.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(107886003)(9686003)(8936002)(8676002)(53546011)(7696005)(55016003)(6506007)(316002)(5660300002)(4326008)(508600001)(52536014)(54906003)(122000001)(2906002)(38100700002)(76116006)(86362001)(64756008)(66946007)(66446008)(38070700005)(30864003)(33656002)(186003)(6916009)(71200400001)(66476007)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vchUPENocIXyRFPCBqaId8186G9HbUfvjFlEpB22McIlH4MyypkgZOPy3Kuo?=
 =?us-ascii?Q?nxFsA33jmFfTzu22ZzYtl7doLcPPOYNmuFwLY3TA8zJol79nHCRfbyMhIZ0W?=
 =?us-ascii?Q?EO2XIzMDI8bN9w9EMCvdkSq554cfVNpzC15GjIgaimhpUqqcdfJ3zK2s4f98?=
 =?us-ascii?Q?01Hy3puJMrgryaKaC0LmrLEnRbisOSG5BwEKGNh4vlhIYAEcXJy7fI52MEWy?=
 =?us-ascii?Q?Y6yV4tiUk5ott1SO+jlXU1caWn0JksXeJx7I5pD9o9Vnxp1Mil/S3K/tirAd?=
 =?us-ascii?Q?K99OzBb2GxprsGxcr1arzIze32qUgSM3EOQtqqBSCzOOOh2r7l6OJj27srkU?=
 =?us-ascii?Q?JO7WAlxpTNQJQ5ieqecdFzfRcYJLEviiCNINajjKBW6cvLmMp52pO2jY6fgR?=
 =?us-ascii?Q?mtljHMRy0uVAOAUvUz4PUQb31hkXG+3i2NaDWqYSsSOw4fJUAwxSYxUKe/X+?=
 =?us-ascii?Q?DdgmtB+oEXLK7E6KhBU+BcbSvwOaYuYauZ88+IhefRmurWU6kBCg/JrExd8Y?=
 =?us-ascii?Q?Jnn5HqyxqfeDkxrSVUdWdf/IuYFlf5uiBWBna3EnCJMdHf8KGgZAblA5/FIL?=
 =?us-ascii?Q?lYTOJlcPXrVe55b2g0vNiWH7oHCzToAx2+I7wQnj654l7UrrvW4Msh4AFqpx?=
 =?us-ascii?Q?39AWrcZEV8o00FeScoSnWExsz7TJicDLa4CUT1NOoGUfWt2ogLlbjgxhfQ+h?=
 =?us-ascii?Q?r7GPQbsghMCCVh84nR+UWh3C9aok47pmZv21ijvGJm9VLMNHQe2VGNLEt6nQ?=
 =?us-ascii?Q?k8e/QPtU/Rz1sBWC7/mIvjuoVovIhO/LBE4tsLwcucA18HusxhGbkWoO3MnN?=
 =?us-ascii?Q?doNd1rcTGiNEs1HjStYIovbauiTtOyCqnofOm3fwgXew6LNmbDU7xjSJJwTv?=
 =?us-ascii?Q?rwJgCtW28fmD7l1LckNdP/2qSKad2iJKJoyqjOaG25mi0CL4LkWlVhygb5Yk?=
 =?us-ascii?Q?IeKERqyh1aspLcA1rlj8Y9L4i0mkGTSSHsE8PGnVU8jSQ4XW8dqwARKYGT3H?=
 =?us-ascii?Q?FBW1XFIX5OLFc0bri18LLqvgxCd2rP6UTSF8/7nAbM1ZBOkRq+q0T70E+26D?=
 =?us-ascii?Q?zbihGxwrOkzCBtDhJEmG231KcOhn6cBg3dDVaO6fALwhJA/1yltVAPRD0tNi?=
 =?us-ascii?Q?E/0oxzdzZIp0szfYsTAEqT10APKVi74O5DNAr9L9BvASketpXwmYPNzBRlbH?=
 =?us-ascii?Q?cgCfwurUcHX0BSxD0bKg2FI4mzXX5rbW7KwlqFGJPYnZEnGqyrBpWmfYtioW?=
 =?us-ascii?Q?OX1nbBH2+YJCwm3ZDp854KzriQLfNiAR4yra6mwxhKZedqftrGkbgiZedwtK?=
 =?us-ascii?Q?tGOTQjxouzyRz22nkmDle6V//py+ZxGqUlIuGmKsyaXQJr2TMawPKIiiiuQ6?=
 =?us-ascii?Q?hCY7EvFBq4H+FQkKT2GccMxN5B1crwgbBOHn5JPBxAqz5rfS+Y4VpWgmRAYd?=
 =?us-ascii?Q?l4HrCEi7QNajSgxA0DpBDekZ8Ygb6kDfyjlhOUDCSoG+KKMfWwZ4bXUpGHJd?=
 =?us-ascii?Q?Gjgr/vjDZ7dDsia+9Rd/nTpIWZPRsjdiCxk5vkbkVoqu+SZzBl1BXqVPIijh?=
 =?us-ascii?Q?OMSQXJfgOCFcarEmq5ZDRcwYjRLS0WOVRshpe1z0dfXgKOOM6kvS9KwS7SzW?=
 =?us-ascii?Q?EvbFZC7x+Fnrc73R0LBwSdItcRxfakA3QVzToECyara8Dzc5kRiohXEINMPI?=
 =?us-ascii?Q?wTxZIGWu7nvmsYQtAonvg8e1kBw=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4612.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 072fec3b-45a1-4509-bee3-08d9b128a873
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2021 22:04:03.0769
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ESdmg5WRASAzUn3bCoQSjiI/9IBTbNm0DTsOvdnF1y6CrGw4ew7PGkgfbqPNiv+oSJN/ZzeV7UuE+9r3nzefPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR18MB4394
X-Proofpoint-GUID: aZrs7Sr9Beo16b9ctS9VHgF-w6XtSEU9
X-Proofpoint-ORIG-GUID: aZrs7Sr9Beo16b9ctS9VHgF-w6XtSEU9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-26_07,2021-11-25_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, November 25, 2021 8:22 AM
> To: Manish Chopra <manishc@marvell.com>
> Cc: netdev@vger.kernel.org; Ariel Elior <aelior@marvell.com>; Alok Prasad
> <palok@marvell.com>; Prabhakar Kushwaha <pkushwaha@marvell.com>
> Subject: [EXT] Re: [PATCH net-next 1/2] qed*: enhance tx timeout debug in=
fo
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Wed, 24 Nov 2021 01:43:02 -0800 Manish Chopra wrote:
> > This patch add some new qed APIs to query status block info and report
> > various data to MFW on tx timeout event
> >
> > Along with that it enhances qede to dump more debug logs (not just
> > specific to the queue which was reported by stack) on tx timeout which
> > includes various other basic metadata about all tx queues and other
> > info (like status block etc.)
> >
> > Signed-off-by: Manish Chopra <manishc@marvell.com>
> > Signed-off-by: Prabhakar Kushwaha <pkushwaha@marvell.com>
> > Signed-off-by: Alok Prasad <palok@marvell.com>
> > Signed-off-by: Ariel Elior <aelior@marvell.com>
>=20
> Please consider using devlink health if you want to communicate more data=
 to
> the user

It's not really that huge logs/data, these are just very basic metadata (fe=
w prints) about the TX queues logged to system logs.
Those can be looked easily from dmesg/var-log-messages files which can be m=
ade available conveniently.
Rest are the mailbox commands posted to management firmware with those basi=
c information about the queues.

>=20
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.c
> > b/drivers/net/ethernet/qlogic/qed/qed_int.c
> > index a97f691839e0..f9744c089f1f 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_int.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_int.c
> > @@ -2399,3 +2399,26 @@ int qed_int_set_timer_res(struct qed_hwfn
> > *p_hwfn, struct qed_ptt *p_ptt,
> >
> >  	return rc;
> >  }
> > +
> > +int qed_int_get_sb_dbg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
> > +		       struct qed_sb_info *p_sb, struct qed_sb_info_dbg *p_info) {
> > +	u16 sbid =3D p_sb->igu_sb_id;
> > +	u32 i;
> > +
> > +	if (IS_VF(p_hwfn->cdev))
> > +		return -EINVAL;
> > +
> > +	if (sbid >=3D NUM_OF_SBS(p_hwfn->cdev))
> > +		return -EINVAL;
> > +
> > +	p_info->igu_prod =3D qed_rd(p_hwfn, p_ptt,
> IGU_REG_PRODUCER_MEMORY + sbid * 4);
> > +	p_info->igu_cons =3D qed_rd(p_hwfn, p_ptt, IGU_REG_CONSUMER_MEM
> + sbid
> > +* 4);
> > +
> > +	for (i =3D 0; i < PIS_PER_SB; i++) {
> > +		p_info->pi[i] =3D (u16)qed_rd(p_hwfn, p_ptt,
> > +					    CAU_REG_PI_MEMORY + sbid * 4 *
> PIS_PER_SB + i * 4);
> > +	}
>=20
> bracket unnecessary, there's a lot of those, please fix all of them.
>=20
> > +
> > +	return 0;
> > +}
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_int.h
> > b/drivers/net/ethernet/qlogic/qed/qed_int.h
> > index 84c17e97f569..49ebb5d9f767 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_int.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_int.h
> > @@ -185,6 +185,19 @@ void qed_int_disable_post_isr_release(struct
> qed_dev *cdev);
> >   */
> >  void qed_int_attn_clr_enable(struct qed_dev *cdev, bool clr_enable);
> >
> > +/**
> > + * qed_int_get_sb_dbg: Read debug information regarding a given SB
> > + *
> > + * @p_hwfn: hw function pointer
> > + * @p_ptt: ptt resource
> > + * @p_sb: pointer to status block for which we want to get info
> > + * @p_info: pointer to struct to fill with information regarding SB
> > + *
> > + * Return: Int
>=20
> What's the point of documenting the return type?

For ./scripts/kernel-doc, I will put some suitable description.=20

>=20
> > + */
> > +int qed_int_get_sb_dbg(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt,
> > +		       struct qed_sb_info *p_sb, struct qed_sb_info_dbg *p_info);
> > +
> >  /**
> >   * qed_db_rec_handler(): Doorbell Recovery handler.
> >   *          Run doorbell recovery in case of PF overflow (and flush DO=
RQ if
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > index 7673b3e07736..a18d2ea96b26 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> > @@ -2936,6 +2936,30 @@ static int qed_update_mtu(struct qed_dev *cdev,
> u16 mtu)
> >  	return status;
> >  }
> >
> > +static int
> > +qed_get_sb_info(struct qed_dev *cdev, struct qed_sb_info *sb,
> > +		u16 qid, struct qed_sb_info_dbg *sb_dbg) {
> > +	struct qed_hwfn *hwfn =3D &cdev->hwfns[qid % cdev->num_hwfns];
> > +	struct qed_ptt *ptt;
> > +	int rc;
> > +
> > +	if (IS_VF(cdev))
> > +		return -EINVAL;
> > +
> > +	ptt =3D qed_ptt_acquire(hwfn);
> > +	if (!ptt) {
> > +		DP_NOTICE(hwfn, "Can't acquire PTT\n");
> > +		return -EAGAIN;
> > +	}
> > +
> > +	memset(sb_dbg, 0, sizeof(*sb_dbg));
> > +	rc =3D qed_int_get_sb_dbg(hwfn, ptt, sb, sb_dbg);
> > +
> > +	qed_ptt_release(hwfn, ptt);
> > +	return rc;
> > +}
> > +
> >  static int qed_read_module_eeprom(struct qed_dev *cdev, char *buf,
> >  				  u8 dev_addr, u32 offset, u32 len)  { @@ -
> 2978,6 +3002,27 @@
> > static int qed_set_grc_config(struct qed_dev *cdev, u32 cfg_id, u32 val=
)
> >  	return rc;
> >  }
> >
> > +static __printf(2, 3) void qed_mfw_report(struct qed_dev *cdev, char
> > +*fmt, ...) {
> > +	char buf[QED_MFW_REPORT_STR_SIZE];
> > +	struct qed_hwfn *p_hwfn;
> > +	struct qed_ptt *p_ptt;
> > +	va_list vl;
> > +
> > +	va_start(vl, fmt);
> > +	vsnprintf(buf, QED_MFW_REPORT_STR_SIZE, fmt, vl);
> > +	va_end(vl);
> > +
> > +	if (IS_PF(cdev)) {
> > +		p_hwfn =3D QED_LEADING_HWFN(cdev);
> > +		p_ptt =3D qed_ptt_acquire(p_hwfn);
> > +		if (p_ptt) {
> > +			qed_mcp_send_raw_debug_data(p_hwfn, p_ptt, buf,
> strlen(buf));
> > +			qed_ptt_release(p_hwfn, p_ptt);
> > +		}
> > +	}
> > +}
> > +
> >  static u8 qed_get_affin_hwfn_idx(struct qed_dev *cdev)  {
> >  	return QED_AFFIN_HWFN_IDX(cdev);
> > @@ -3038,6 +3083,8 @@ const struct qed_common_ops
> qed_common_ops_pass =3D {
> >  	.read_nvm_cfg =3D &qed_nvm_flash_cfg_read,
> >  	.read_nvm_cfg_len =3D &qed_nvm_flash_cfg_len,
> >  	.set_grc_config =3D &qed_set_grc_config,
> > +	.mfw_report =3D &qed_mfw_report,
> > +	.get_sb_info =3D &qed_get_sb_info,
> >  };
> >
> >  void qed_get_protocol_stats(struct qed_dev *cdev, diff --git
> > a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
> > b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
> > index 564723800d15..2c28d5f86497 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.h
> > @@ -15,6 +15,8 @@
> >  #include "qed_hsi.h"
> >  #include "qed_dev_api.h"
> >
> > +#define QED_MFW_REPORT_STR_SIZE	256
> > +
> >  struct qed_mcp_link_speed_params {
> >  	bool					autoneg;
> >
> > diff --git a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
> > b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
> > index 6f1a52e6beb2..b5e35f433a20 100644
> > --- a/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
> > +++ b/drivers/net/ethernet/qlogic/qed/qed_reg_addr.h
> > @@ -550,6 +550,8 @@
> >  		0x1 << 1)
> >  #define  IGU_REG_BLOCK_CONFIGURATION_PXP_TPH_INTERFACE_EN	( \
> >  		0x1 << 0)
> > +#define IGU_REG_PRODUCER_MEMORY 0x182000UL #define
> > +IGU_REG_CONSUMER_MEM 0x183000UL
> >  #define  IGU_REG_MAPPING_MEMORY \
> >  	0x184000UL
> >  #define IGU_REG_STATISTIC_NUM_VF_MSG_SENT \ diff --git
> > a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > index 06c6a5813606..f37604da79e9 100644
> > --- a/drivers/net/ethernet/qlogic/qede/qede_main.c
> > +++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
> > @@ -509,34 +509,98 @@ static int qede_ioctl(struct net_device *dev, str=
uct
> ifreq *ifr, int cmd)
> >  	return 0;
> >  }
> >
> > -static void qede_tx_log_print(struct qede_dev *edev, struct
> > qede_tx_queue *txq)
> > +static void qede_fp_sb_dump(struct qede_dev *edev, struct
> > +qede_fastpath *fp)
> >  {
> > +	char *p_sb =3D (char *)fp->sb_info->sb_virt;
> > +	u32 sb_size, i;
> > +
> > +	sb_size =3D sizeof(struct status_block);
> > +
> > +	for (i =3D 0; i < sb_size; i +=3D 8) {
> > +		DP_NOTICE(edev,
> > +			  "%02hhX %02hhX %02hhX %02hhX  %02hhX %02hhX
> %02hhX %02hhX\n",
> > +			  p_sb[i], p_sb[i + 1], p_sb[i + 2], p_sb[i + 3],
> > +			  p_sb[i + 4], p_sb[i + 5], p_sb[i + 6], p_sb[i + 7]);
> > +	}
> > +}
> > +
> > +static void
> > +qede_txq_fp_log_metadata(struct qede_dev *edev,
> > +			 struct qede_fastpath *fp, struct qede_tx_queue *txq) {
> > +	struct qed_chain *p_chain =3D &txq->tx_pbl;
> > +
> > +	/* Dump txq/fp/sb ids etc. other metadata */
> >  	DP_NOTICE(edev,
> > -		  "Txq[%d]: FW cons [host] %04x, SW cons %04x, SW prod %04x
> [Jiffies %lu]\n",
> > -		  txq->index, le16_to_cpu(*txq->hw_cons_ptr),
> > -		  qed_chain_get_cons_idx(&txq->tx_pbl),
> > -		  qed_chain_get_prod_idx(&txq->tx_pbl),
> > -		  jiffies);
> > +		  "fpid 0x%x sbid 0x%x txqid [0x%x] ndev_qid [0x%x] cos [0x%x]
> p_chain %p cap %d size %d jiffies %lu HZ 0x%x\n",
> > +		  fp->id, fp->sb_info->igu_sb_id, txq->index, txq->ndev_txq_id,
> txq->cos,
> > +		  p_chain, p_chain->capacity, p_chain->size, jiffies, HZ);
> > +
> > +	/* Dump all the relevant prod/cons indexes */
> > +	DP_NOTICE(edev,
> > +		  "hw cons %04x sw_tx_prod=3D0x%x, sw_tx_cons=3D0x%x, bd_prod
> 0x%x bd_cons 0x%x\n",
> > +		  le16_to_cpu(*txq->hw_cons_ptr), txq->sw_tx_prod, txq-
> >sw_tx_cons,
> > +		  qed_chain_get_prod_idx(p_chain),
> > +qed_chain_get_cons_idx(p_chain)); }
> > +
> > +static void
> > +qede_tx_log_print(struct qede_dev *edev, struct qede_fastpath *fp,
> > +struct qede_tx_queue *txq) {
> > +	struct qed_sb_info_dbg sb_dbg;
> > +	int rc;
> > +
> > +	/* sb info */
> > +	qede_fp_sb_dump(edev, fp);
> > +
> > +	memset(&sb_dbg, 0, sizeof(sb_dbg));
> > +	rc =3D edev->ops->common->get_sb_info(edev->cdev, fp->sb_info,
> > +(u16)fp->id, &sb_dbg);
> > +
> > +	DP_NOTICE(edev, "IGU: prod %08x cons %08x CAU Tx %04x\n",
> > +		  sb_dbg.igu_prod, sb_dbg.igu_cons, sb_dbg.pi[TX_PI(txq-
> >cos)]);
> > +
> > +	/* report to mfw */
> > +	edev->ops->common->mfw_report(edev->cdev,
> > +				      "Txq[%d]: FW cons [host] %04x, SW cons
> %04x, SW prod %04x [Jiffies %lu]\n",
> > +				      txq->index, le16_to_cpu(*txq-
> >hw_cons_ptr),
> > +				      qed_chain_get_cons_idx(&txq->tx_pbl),
> > +				      qed_chain_get_prod_idx(&txq->tx_pbl),
> jiffies);
> > +	if (!rc) {
> > +		edev->ops->common->mfw_report(edev->cdev,
> > +					      "Txq[%d]: SB[0x%04x] - IGU: prod
> %08x cons %08x CAU Tx %04x\n",
> > +					      txq->index, fp->sb_info->igu_sb_id,
> > +					      sb_dbg.igu_prod, sb_dbg.igu_cons,
> > +					      sb_dbg.pi[TX_PI(txq->cos)]);
> > +	}
> >  }
> >
> >  static void qede_tx_timeout(struct net_device *dev, unsigned int
> > txqueue)  {
> >  	struct qede_dev *edev =3D netdev_priv(dev);
> > -	struct qede_tx_queue *txq;
> > -	int cos;
> > +	int i;
> >
> >  	netif_carrier_off(dev);
> >  	DP_NOTICE(edev, "TX timeout on queue %u!\n", txqueue);
> >
> > -	if (!(edev->fp_array[txqueue].type & QEDE_FASTPATH_TX))
> > -		return;
> > +	for_each_queue(i) {
>=20
> Please only dump state for the queue that timed out.

Generally, for debugging purpose getting at least basic metadata info (prod=
/cons indexes etc.) for all queues is good
on such tx timeout event. Down the flow driver only dump more info (status =
block etc.) and report to firmware
for the queue which is stuck (prod !=3D cons).

>=20
> > +		struct qede_tx_queue *txq;
> > +		struct qede_fastpath *fp;
> > +		int cos;
> >
> > -	for_each_cos_in_txq(edev, cos) {
> > -		txq =3D &edev->fp_array[txqueue].txq[cos];
> > +		fp =3D &edev->fp_array[i];
> > +		if (!(fp->type & QEDE_FASTPATH_TX))
> > +			continue;
> > +
> > +		for_each_cos_in_txq(edev, cos) {
> > +			txq =3D &fp->txq[cos];
> >
> > -		if (qed_chain_get_cons_idx(&txq->tx_pbl) !=3D
> > -		    qed_chain_get_prod_idx(&txq->tx_pbl))
> > -			qede_tx_log_print(edev, txq);
> > +			/* Dump basic metadata for all queues */
> > +			qede_txq_fp_log_metadata(edev, fp, txq);
> > +
> > +			if (qed_chain_get_cons_idx(&txq->tx_pbl) !=3D
> > +			    qed_chain_get_prod_idx(&txq->tx_pbl)) {
> > +				qede_tx_log_print(edev, fp, txq);
> > +			}
> > +		}
> >  	}
> >
> >  	if (IS_VF(edev))
> > diff --git a/include/linux/qed/qed_if.h b/include/linux/qed/qed_if.h
> > index 0dae7fcc5ef2..9f4bfa2a4829 100644
> > --- a/include/linux/qed/qed_if.h
> > +++ b/include/linux/qed/qed_if.h
> > @@ -807,6 +807,12 @@ struct qed_devlink {
> >  	struct devlink_health_reporter *fw_reporter;  };
> >
> > +struct qed_sb_info_dbg {
> > +	u32 igu_prod;
> > +	u32 igu_cons;
>=20
> This info gets populated by the device, right? It should probably use the=
 correct
> endian types.

These are the values read from BAR address (readl). I think this should be =
fine.
=20
> > +	u16 pi[PIS_PER_SB];
> > +};
> > +
> >  struct qed_common_cb_ops {
> >  	void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);
> >  	void (*link_update)(void *dev, struct qed_link_output *link);

