Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3556D31A288
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 17:21:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhBLQUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 11:20:14 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35288 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230356AbhBLQTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 11:19:54 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11CG6Dkq008291;
        Fri, 12 Feb 2021 08:19:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=6ZuoWtowtyJliDe5NlLmT8kGk3WMsd/L2HVQPdOOzmI=;
 b=CfW6i7mx/zTxzvhw5vGPwKy4Vyr0iOJEKVczBJC11BebjE7gCCxfhxRPxn/cOJ59XFbh
 jmRQmb9daXeYt6BnKNx67xKTDAr3op6HAmwjsQgi46+SrziTFed8c6kHc5SOr/zR8h0j
 8HdTPYQXdmYT+9FGVjQWGt/xVrhP/2eEHSgUYgu+pjVkmzGZYlYcQKxThu1s/YLOdewy
 zaGd+og2AKwR5vg8upaPbRdul3G8B3GSBp3nA7ntxFdlbTJUHZbLyTYL5/UkuQOTcXEo
 B9DrDF8tr1YfjdDUyZspeAXyPtto/M7mweDztXx6Rx8/TwiqzaM53F9U/+xWR/Yttc8E HA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqjw73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 12 Feb 2021 08:19:01 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 08:18:59 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 12 Feb
 2021 08:18:58 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Fri, 12 Feb 2021 08:18:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JV6Yxk5VvjAfAMnCK9Uo+fLEpr5L87ySE9DEgQQRGSZsKFYzEjgwFh1t3cPFoOojufoRpS4VpaZY7Z+3K/0iZzZ27zGVHMDdHkriwkIQsTXzlo+ngoxJvgIp6qx8sus+1Zh6ByZllVvro+JLm9sHXFWmJvO+mIZnPOwADM5dhBTD9M4ya+4jH1kN41k9OLqnEOdsskrm0cVkBwH8W7ttXF5XYb6YqlgnwolnHLC2UIxwTKzX0zva+IDMnx1HWlt0rSBxozmfHZ1IlRWygTejgSmuF9ENjx6TqimVwDbEqdYFqJ3AlBJhgtk+Njuo8FdvgGWhxjZAj+O9mFoSl2Bl3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZuoWtowtyJliDe5NlLmT8kGk3WMsd/L2HVQPdOOzmI=;
 b=UaqkSxXXBYCQwGR0avdabMhkzsagUKJIpFnPkH8D0H5Gu4l2BvpojfwOf6qW4lf/5jS4XWP3Xph9lAV9KPaqQLMM6Mpct/HGOXCNEgAP+Flwk9Wvm53TdrYuMOq0RY520ueAhue9JtYQ11tZB/WSQxkLQuiqHuux38xXASzltn/rVwpPTz/Tww6TXGrPkgEU1+Hx7Wjh3uGKAKoyXUKYDQlXKTj9akiE3o6ysXwnQ+RJcguGqkE9WnFtZ1OM4tKMmwy5ek7oz1rPfTD2dsP1pcI8Mn4yHjf0UcZKVVhDvUfpDbvqYaQh7Dv8jknBzED78I0nNq6mgd1np+ySwFlgjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ZuoWtowtyJliDe5NlLmT8kGk3WMsd/L2HVQPdOOzmI=;
 b=qQVsXy4Ftii4h2cecPuNhOM47O4vVp676Bc7QQjzHo9yNxLEyrGGygZy/7WsaepOdnbl2jcE2XlcQtv9SEXKiXo5h1KnZAN5ETvBjBB4g5rM4gI8tX/CijAEUaGj2qkGkfbhOyz041vO2Sv2uxbNlqlErR2IV26ai/x/g9kPZik=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by MW3PR18MB3578.namprd18.prod.outlook.com (2603:10b6:303:57::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Fri, 12 Feb
 2021 16:18:57 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3846.030; Fri, 12 Feb 2021
 16:18:57 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        "Subbaraya Sundeep Bhatta" <sbhatta@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Christina Jacob <cjacob@marvell.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2][next] octeontx2-pf: Fix out-of-bounds read warning in
 otx2_get_fecparam()
Thread-Topic: [PATCH v2][next] octeontx2-pf: Fix out-of-bounds read warning in
 otx2_get_fecparam()
Thread-Index: AdcBWpizA8tPtyg1S/ms+brrBU7g+Q==
Date:   Fri, 12 Feb 2021 16:18:57 +0000
Message-ID: <MWHPR18MB1421B120E36C81B54331B032DE8B9@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.206.226.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e64973b0-fce9-49be-129d-08d8cf71e67d
x-ms-traffictypediagnostic: MW3PR18MB3578:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR18MB357810F854301E3272AADD35DE8B9@MW3PR18MB3578.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SQzbGHlU9QzxzbHyqU2msjySqfF8dGnbYA0qOrBqLkkUmGqNR1JVvms1hakHzMRQy7twqRIgmN5ZQN6JMt4fP9GsC3pHRbk8n8C0sd6y/pYlKwi7oYEG8TtDzeL4/JEyD/aOlrKgPVeNkREoExu4X43lN/VhKANr58M28G27BwLMW8tdEyjN9YiU+cSM6eV/7MXrxapuI179DF9zx84iMFpjypOd8d2nHMsj+JzBpq0+Hz/DfqIsEJzUhXvKLWKoGhF1whoR8ei/ui8tNMyLfmCLndmdzno1n2B4udc1MISx2qU7xG7gKr1vT5ra/2N3amdWk1Md4dxnFVPAHB6X/dGMuGtLLueQZ3FyXvdchUnmc/w/ny4dF070QnVu21zmgsE2gwVl2FmEJMpCWnRTuQlrxp8pdgSBIuhKPXBeo/pUE5nTcAWCv99ltSyiLNrsxURhbQu3okHpvfi09rRCrav+Pmfq6EcXNnwl2Og1TFNbejqdFZmoFyjKTjwgzThDo/P4+C1PEIcjQBxm2qST1V4YN05preKoo3k1xVl2s7Cq7uEt2y2O2XD2VIwiP+SWY4YbJ7JLPUslkRD9v0KVBARTMSIt8Sb0RmkK60ro+A4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39850400004)(66556008)(66946007)(76116006)(55016002)(86362001)(83380400001)(66476007)(64756008)(66446008)(6636002)(966005)(5660300002)(9686003)(2906002)(316002)(110136005)(54906003)(7696005)(45080400002)(4326008)(19627235002)(186003)(52536014)(33656002)(26005)(8936002)(53546011)(8676002)(71200400001)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?SgTAuljMRYbOrDNqZvFe944R13QVyClpoXYEc2l7TtiKM5Tt6V42x6PMCz/u?=
 =?us-ascii?Q?gSBNqzdqYnL26mSP7tbN7BZEPUGFY5d+iUEXD04eo47cvYAaqXRS5tyRqNKW?=
 =?us-ascii?Q?7KJAawXlnxdNJpDAglFTKnE9q3ckQA4X0l6VWl30hkd3CJjgsf3DHHR29i8M?=
 =?us-ascii?Q?0jrBhSyvBqiQo4GtQuj3H0P4bJncalLc0FZG8RDlhi07rgg6b+GLhn+Vz9TQ?=
 =?us-ascii?Q?wdQV+1GwTN8/Va5s9e3jYr9MddRxs+IRgZ+v1Xxv9iIIpxUNe1VP1ZoaP2V/?=
 =?us-ascii?Q?Fje9lSM2olA7kXI+Gv3BtGvoAy4dOpA8toEArCHC2DwXK5dvXxH8AZ7UiSiz?=
 =?us-ascii?Q?VwsJ8NCu/nK93fYFT/B6kpRqlcMQXSONhK8UuOXc3/KNgh+zcPLjHOlZlhcI?=
 =?us-ascii?Q?kjPeEWFcmDA1n4cG7tCqMJC6ba/ds+267uFvCu2H+pB+Z+IAjAelQQy7VBoV?=
 =?us-ascii?Q?7YIjzPP++t9vVymVUghJoVJ7LsYn6VnUlHZRfInc+Pm20vhK0iUg6bMoD1yg?=
 =?us-ascii?Q?ljaoJwqDEb6l7DWIRJLhYV45stUZ+ljoMJe6rA7vFcFpa++ml1y1oej/QVrL?=
 =?us-ascii?Q?/vzw1eCJjOpYCXicJOyY5ZE1gHjLrayKA7kKnLR1qhHNCEiJHj/fgbTK3rTX?=
 =?us-ascii?Q?5fajor+tmgIlMzERSBgb2oH5vXJYIdJ+SAZKJpQDJzxb9u0Wp14kA/f/mMV7?=
 =?us-ascii?Q?j+L7fMJkznY7H5GMCLkcyt7kJki1Mm7E9TeaqY+C3oGbx0MxvpVOD8yLagXD?=
 =?us-ascii?Q?K5fIJzOYm5nwPdOFVAS2O6JqQMPagFM842chXLkdKzwXfdPp4VMLY9HW3zNg?=
 =?us-ascii?Q?x06ie39Cq0F9pwFato/7UA/+QjwMyfx5tjWxmHDtUe1+9/EyZ7D/pZE4RggB?=
 =?us-ascii?Q?Rmxn3BnuPERDfnnzIkerxiv3qvPm/cXm3fftFte2kWDhFFhDuOTILRs7WGYJ?=
 =?us-ascii?Q?/Da5adpqjCRZ5J1Nq/W5Smjsneq8BB8yHOxZvsmlgQI2w8exF9NaApSvIq/C?=
 =?us-ascii?Q?w/spALeqAZXyrGUKOc8bfPC3Bq0DCP9QRrPscK8neu6hZfCqSpx7SiLMYfS4?=
 =?us-ascii?Q?2p2XNKS4EAl9z5FMi/gAzBV/fGHSh+xSbsYkIFe7+ckP4k9Gi0vS3QDOeIpR?=
 =?us-ascii?Q?QYIO1Pb36Hz0jtxiR7CJgriQEqwkyAKghfI8IWui0dcUNfdvArYMFwVLPHGr?=
 =?us-ascii?Q?y0RerJRziATKZlk8ycvQe/6iphTyU/HxY+tuXYsgJYS2eLxOdWhTZtKYF6N8?=
 =?us-ascii?Q?2CtUMrGUzY33K+A2fXibFp/yMRHrSkVe3Ueqvrur1DEWVu745dk1tiZUkOSc?=
 =?us-ascii?Q?gqMRaOa0PFkCPF2OkcCJ0f6S?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e64973b0-fce9-49be-129d-08d8cf71e67d
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2021 16:18:57.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TaojLU8UXRLwdMTeEWWQLSsMdPaGwIKeDw+vsBcFz9SJhtizf1BGmwVA8DRlrsVEnYBsV/lLVTseypS+jApqsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR18MB3578
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-12_05:2021-02-12,2021-02-12 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Looks good to me.

Thanks,
Hariprasad k

> -----Original Message-----
> From: Gustavo A. R. Silva <gustavoars@kernel.org>
> Sent: Friday, February 12, 2021 8:36 PM
> To: Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya
> Akula <gakula@marvell.com>; Subbaraya Sundeep Bhatta
> <sbhatta@marvell.com>; Hariprasad Kelam <hkelam@marvell.com>; David
> S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>; Jesse
> Brandeburg <jesse.brandeburg@intel.com>; Christina Jacob
> <cjacob@marvell.com>
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Gustavo A. R.
> Silva <gustavoars@kernel.org>
> Subject: [EXT] [PATCH v2][next] octeontx2-pf: Fix out-of-bounds read
> warning in otx2_get_fecparam()
>=20
> Line at 967 implies that rsp->fwdata.supported_fec may be up to 4:
>=20
> if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX)
>=20
> which would cause an out-of-bounds read at line 971:
>=20
> fecparam->fec =3D fec[rsp->fwdata.supported_fec];
>=20
> However, the range of values for rsp->fwdata.supported_fec is
> 0 to 3. Fix the if condition at line 967, accordingly.
>=20
> Link: https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> 3A__lore.kernel.org_lkml_MWHPR18MB142173B5F0541ABD3D59860CDE8B9
> -
> 40MWHPR18MB1421.namprd18.prod.outlook.com_&d=3DDwIBAg&c=3DnKjWec2
> b6R0mOyPaz7xtfQ&r=3D2bd4kP44ECYFgf-
> KoNSJWqEipEtpxXnNBKy0vyoJJ8A&m=3DS9J3c0FowK6hmviWeihiqhoU9VJSXsvD
> OP4d3JS7Y2g&s=3DEUu3u67l555Q6zXvfGl9niuUM-ulJm4Ipe8KLWvNioQ&e=3D
> Fixes: d0cf9503e908 ("octeontx2-pf: ethtool fec mode support")
> Addresses-Coverity-ID: 1501722 ("Out-of-bounds read")
> Suggested-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v2:
>  - Fix if condition.
>=20
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> index 237e5d3321d4..f4962a97a075 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> @@ -964,7 +964,7 @@ static int otx2_get_fecparam(struct net_device
> *netdev,
>  	if (IS_ERR(rsp))
>  		return PTR_ERR(rsp);
>=20
> -	if (rsp->fwdata.supported_fec <=3D FEC_MAX_INDEX) {
> +	if (rsp->fwdata.supported_fec < FEC_MAX_INDEX) {
>  		if (!rsp->fwdata.supported_fec)
>  			fecparam->fec =3D ETHTOOL_FEC_NONE;
>  		else
> --
> 2.27.0

