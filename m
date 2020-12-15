Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03B112DAF95
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 16:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgLOO4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 09:56:55 -0500
Received: from mx0a-00154904.pphosted.com ([148.163.133.20]:16246 "EHLO
        mx0a-00154904.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729916AbgLOOr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Dec 2020 09:47:57 -0500
Received: from pps.filterd (m0170389.ppops.net [127.0.0.1])
        by mx0a-00154904.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEahgY026156;
        Tue, 15 Dec 2020 09:47:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=smtpout1;
 bh=s6chytUEXPK/xrdsvrk/OTvcJEb2w1Kmjie29ftgM0M=;
 b=s4DnPMftmrzgMuSg7YuoBeKkd3VNDMfgLoYPSq0njOtmn11T2WSM882E8CTvU6MJs4uJ
 gi+le+CCroL8sdQ7UFLkZrPbAf1YGrVz988nT2pxs+PLyEAHYvS22s39viPC3YUvYf39
 HxDc+T6JyJ94nxueGb8rMpPRdEDri3NqzUYVXAMSgt6s2L0UnDwtFZJtWpDGlM2ztuf8
 Zgwk68r68UeVjC7FoW7oBTQK+oF20cT2OpTegvx5r+SKkH3gKv17TH4bwoGXajSq1tuz
 nR0Wb0Q4LZwMRS7uyasX39WtTox4uXtM1hAuOoSGQOBwafpouXAjdIarROsvieneMGvL 1Q== 
Received: from mx0a-00154901.pphosted.com (mx0a-00154901.pphosted.com [67.231.149.39])
        by mx0a-00154904.pphosted.com with ESMTP id 35ctrr264b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Dec 2020 09:47:01 -0500
Received: from pps.filterd (m0142693.ppops.net [127.0.0.1])
        by mx0a-00154901.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BFEg1U0111154;
        Tue, 15 Dec 2020 09:47:01 -0500
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by mx0a-00154901.pphosted.com with ESMTP id 35ey4kr3wg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Dec 2020 09:47:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldvEuaffwrd3EuRe03KHExnZyW4a5WyWP4nEUE5vbGqQ4XK9k5zKyB5xpzOpdkZwqSUG4/b428W+oqXqgN/h7NFRk81xMisEeRIdOp/KHM7UFlaAQS9tpMeMY1mggQGnsE62600jJT0n4Hfu1I908JzAYNUSsXsXoOo+C71z2I5ouAIu5E5Z6eGCLUuP70TMyo27pDpAElsJMaAa2rP+zNq2quWPFBiQleRQAc5W8X5R2zP4bz4qQLQbQTulcLPO+M9NsYRov5IdHeMvkHLoSvYUM6hFw+8hXYMat2u+2VsZw1hKYkouwXS+6+WirmX3G9XgT/g3f1KFJ/6MkxkDmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6chytUEXPK/xrdsvrk/OTvcJEb2w1Kmjie29ftgM0M=;
 b=HP6oW/C5KuaGQQzQqT4iwrtvYagpU6IM3fe7NcuMIpm+WBvuEnz9PdzicAr91CJQNri9b7XbvG1FuFxHsWwXzyzLH3FtRCPH1x/Wnb8o5TVkOtq4W0jIEbsbAFt0qwhPSqwmWVG80f0URBNWB59TDPfqqOI/vQgOEubdwMabW25FVVnsSrybIJz3wobCIbltmMfE+b3cGl2fRNiSVbF9FOb2yqqYlq706dNcqSVCq3SP6+N76TKerfvnaf/cxy0Z63n/sHSkyULYXUHkeR4sw/Ql9oKWoDQkH015aTwtm0wiz7HcgRNP1DzqYxBcTkX4RoW8yz5Q6Uzn+iolpnDpTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dell.com; dmarc=pass action=none header.from=dell.com;
 dkim=pass header.d=dell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Dell.onmicrosoft.com;
 s=selector1-Dell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s6chytUEXPK/xrdsvrk/OTvcJEb2w1Kmjie29ftgM0M=;
 b=duC4GRHc5CufutSgYNrIvNg2ItmYjNZZ55bbgbMjBBUALb7MuL1xX2Ick1Hsbn6JqUFJdYBYuvKRPPtrl7CBwMYPazgQVDP13UgPaJSO3T9uMdgfg6XO/AFg3cF/S1kUrW8+GGzeD5uL+HsvctLfnKjBtLpqeNi/YWW9+h0RQa0=
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com (2603:10b6:a03:282::9)
 by BY5PR19MB3953.namprd19.prod.outlook.com (2603:10b6:a03:219::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Tue, 15 Dec
 2020 14:46:59 +0000
Received: from SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef]) by SJ0PR19MB4463.namprd19.prod.outlook.com
 ([fe80::6d3e:acc:b93c:11ef%9]) with mapi id 15.20.3654.025; Tue, 15 Dec 2020
 14:46:59 +0000
From:   "Shen, Yijun" <Yijun.Shen@dell.com>
To:     "Limonciello, Mario" <Mario.Limonciello@dell.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>,
        David Miller <davem@davemloft.net>,
        "darcari@redhat.com" <darcari@redhat.com>,
        "Yuan, Perry" <Perry.Yuan@dell.com>,
        "anthony.wong@canonical.com" <anthony.wong@canonical.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: RE: [PATCH v5 1/4] e1000e: Only run S0ix flows if shutdown succeeded
Thread-Topic: [PATCH v5 1/4] e1000e: Only run S0ix flows if shutdown succeeded
Thread-Index: AQHW0k98e37NgbHGFUWW9Vd8GfaMYKn4PFgQ
Date:   Tue, 15 Dec 2020 14:46:59 +0000
Message-ID: <SJ0PR19MB4463871A880C165310ED8ABA9AC60@SJ0PR19MB4463.namprd19.prod.outlook.com>
References: <20201214192935.895174-1-mario.limonciello@dell.com>
 <20201214192935.895174-2-mario.limonciello@dell.com>
In-Reply-To: <20201214192935.895174-2-mario.limonciello@dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: Dell.com; dkim=none (message not signed)
 header.d=none;Dell.com; dmarc=none action=none header.from=Dell.com;
x-originating-ip: [101.86.22.85]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3da8675-4240-4881-54ea-08d8a10846df
x-ms-traffictypediagnostic: BY5PR19MB3953:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR19MB3953C4FF45D739A30FC396169AC60@BY5PR19MB3953.namprd19.prod.outlook.com>
x-exotenant: 2khUwGVqB6N9v58KS13ncyUmMJd8q4
x-ms-oob-tlc-oobclassifiers: OLM:483;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d6J/tvV8vGZZ2FanYOcKV+afh5PLh4dFFMonM/kYBBqfAJFUFaz2mtTz6OHZsPcdyZdUM1gNSqorPCUKMOuuAfRgscvIOyMvr/aRJbnaLvzxE4nreC+VdEg8Xutx5pYjeuFCXBr+2SX0QPKBISuopbX36yqbBKbJncJI6uzL65/Qr1rJaxEqX8M0N+wUk4gUQbm2OAfunFIGPfUb+EcH2BQsJ8AjTvN3C2s4XINK3bsuUG9CYTaNlzCGqcZtHtjxmsNRkGpXU74NTMgJFGzT9eeh6UP38FJS61sM9CBAktUQHirwjrMkNr647/s7p0zB0mpMu3XndTPn5b40X76mRsrMQJ/EhRocUCS7mcufroG0gdaDdgdM77fxlYTh8Ab1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR19MB4463.namprd19.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(346002)(366004)(66556008)(186003)(86362001)(66446008)(83380400001)(64756008)(66946007)(66476007)(53546011)(71200400001)(2906002)(7696005)(5660300002)(508600001)(33656002)(6506007)(786003)(8936002)(8676002)(7416002)(54906003)(52536014)(110136005)(55016002)(9686003)(76116006)(4326008)(26005)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?MCJDUYpYL1GVzicQcqAPywnmtumhk1qZErwoCbWUJsFff9vBg3CZCvpiRGDj?=
 =?us-ascii?Q?EiVgiwjrl7Bds6jx6V77/J4WFXYxe4kT+qyMWjtC1ipGk4JPuil8BJq/phCG?=
 =?us-ascii?Q?oBfYBl1tjIDOVVKvhODZSTVeMAQKRjmdT51B1TwVt9hpVpBj6cN3j3CUddyg?=
 =?us-ascii?Q?3CdSpMX6cfEdLxnOL4D+Zm6xBpdH0T0I0J8pHRymBwu9BaM07XfatZH+tg7s?=
 =?us-ascii?Q?unp3rrd2M+qsOYhMv81AoBFELONfoopTp32u0iSP1MfijrJASYiFcaT08WJ4?=
 =?us-ascii?Q?elok4Y86m9NZyLCRIO9Bop9MwW41gH7FdAKM5C/YmvDH/+rygvvJWMYikqAP?=
 =?us-ascii?Q?kihQouIQBEiaAvm0vQ4fbQgBIRLfzzrV6y529zoylmIkWnSaZgb4YAVupiky?=
 =?us-ascii?Q?/CohTtAJWmDEGfMCCaxzPRUv+XXS2827YoAqQGBt0MXRZNIR5VAIWsdggcdK?=
 =?us-ascii?Q?F1YMdBJQjbV079xI6b11mdQsJXWIQW0o2Ya0IdV2gW57GWWqm1xSs883QX4l?=
 =?us-ascii?Q?Oh4RoKS6Z27wVMQ12/9/36LLZjP4Ig63oBxNc9qBMz389t7xeIx/JYJEggy3?=
 =?us-ascii?Q?BxBBIbaskmdr45jJGhHs53WyZxEDeNKPjd/MrnwBp8DbPcLucaloqEUn3zAv?=
 =?us-ascii?Q?fkqBVkPjUMIbFfa1dgkDHLkpCfX6mefkNlxFFwRWk1ywQbCkSQK920K3rGVA?=
 =?us-ascii?Q?oTXy2DDbk9fcPEGpyA7ia9cD5xOOueVdLRggYxaMD4cnBMF9+fwxUidCPFo6?=
 =?us-ascii?Q?kGlv+jp7T875aUTxp/VfdsOfgWavykApOx+1MIZUGuc8f1h0wpCCQDYZoAeC?=
 =?us-ascii?Q?aLPIjI0eqFMM8p58k4MI/xy79zaF31wLt54gz+l348lwbw2lxYPSwi1Pw5if?=
 =?us-ascii?Q?UXs9a11F5gxMP0VsifbSc5B8XUdZJgq+maLhYanqXcw7m7REhohPfO7nbbxT?=
 =?us-ascii?Q?povwRmpihs7awzudOEzqV5CytpcWd0K2ULScU6512iE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Dell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR19MB4463.namprd19.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3da8675-4240-4881-54ea-08d8a10846df
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Dec 2020 14:46:59.2263
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 945c199a-83a2-4e80-9f8c-5a91be5752dd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Acvqk++DhOb/z2VuaIEKMah34f7Q2FmEFZKDj6qUsDbO+ErPiyMA7wmjMyYcmrTur1JIhNJpijf5qEv87RsQ7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR19MB3953
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-15_12:2020-12-15,2020-12-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 spamscore=0
 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150105
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012150105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Limonciello, Mario <Mario_Limonciello@Dell.com>
> Sent: Tuesday, December 15, 2020 3:30 AM
> To: Jeff Kirsher; Tony Nguyen; intel-wired-lan@lists.osuosl.org
> Cc: linux-kernel@vger.kernel.org; Netdev; Alexander Duyck; Jakub Kicinski=
;
> Sasha Netfin; Aaron Brown; Stefan Assmann; David Miller;
> darcari@redhat.com; Shen, Yijun; Yuan, Perry;
> anthony.wong@canonical.com; Hans de Goede; Limonciello, Mario
> Subject: [PATCH v5 1/4] e1000e: Only run S0ix flows if shutdown succeeded
>=20
> If the shutdown failed, the part will be thawed and running S0ix flows wi=
ll
> put it into an undefined state.
>=20
> Reported-by: Alexander Duyck <alexander.duyck@gmail.com>
> Reviewed-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Mario Limonciello <mario.limonciello@dell.com>

Verified this series patch on Dell Systems.

Tested-By: Yijun Shen <Yijun.shen@dell.com>

> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c
> b/drivers/net/ethernet/intel/e1000e/netdev.c
> index 128ab6898070..6588f5d4a2be 100644
> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> @@ -6970,13 +6970,14 @@ static __maybe_unused int
> e1000e_pm_suspend(struct device *dev)
>  	e1000e_pm_freeze(dev);
>=20
>  	rc =3D __e1000_shutdown(pdev, false);
> -	if (rc)
> +	if (rc) {
>  		e1000e_pm_thaw(dev);
> -
> -	/* Introduce S0ix implementation */
> -	if (hw->mac.type >=3D e1000_pch_cnp &&
> -	    !e1000e_check_me(hw->adapter->pdev->device))
> -		e1000e_s0ix_entry_flow(adapter);
> +	} else {
> +		/* Introduce S0ix implementation */
> +		if (hw->mac.type >=3D e1000_pch_cnp &&
> +		    !e1000e_check_me(hw->adapter->pdev->device))
> +			e1000e_s0ix_entry_flow(adapter);
> +	}
>=20
>  	return rc;
>  }
> --
> 2.25.1

