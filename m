Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE4D43AF55
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234985AbhJZJqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:46:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:41562 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233931AbhJZJqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:46:47 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19Q5tmdo012639;
        Tue, 26 Oct 2021 02:44:20 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3bx4dx2bru-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Oct 2021 02:44:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXM1qcwXoeh57TpJidQ8Aeu45Ofa9020BO3bxUe6g5fbwP4qBvxq3HrmloFUpo2c5nRV5kqcX4A2C0jBI+CO0Lbilx/xzJHdHanTSXQhK3UxToXGd6wut++P79yEOQoOQFP2kf4Y1eDyECH19ZDHo/vmgwpdO5kz9ODwaUCFlsdx52A3P/d6Pn/tyAnXfYW0E0SuskpLOi7QG1uVex6Xu4SNvS8rLwLoumBz+x6dShf+GrpdZ7RTvhpzzPyWejZbPvMxd7pYdphpnDuFcaRYE99FM+zoyPpP3GiNqzQzW2dzua1d7sWHFk9Ift0zWveJYnG+75sYAhKBduuWVPn9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoQgefdM7gSCDu6+AaWIe0FIsqowOeHPp7ADsd3r/MQ=;
 b=dUyDtGNJneKR0Qb0GX2+uKvR5mYCVQFdanHvFnAUK4datkOeoO29HvUy0pHurWWn46NpfRIFLx3xjLyMZnIi1xLr9CSUAfu7t84n+HfmljmptGKm89bjS8H5+BMPRFBgbfSw0X04MvQG3bep+ZI47gTRh9++f56VAd8sBjpC3wlv9ewSknfvVAHjwMIULPR6hMNV8rY4dkLNBOJFFq0KBGFWBlxWsNp2o2sJ4kZdBmvYVHS+4tJsXxPfUehU8N6++q1OHO07K4rUqdYE/dXLIS1HhDTj8OL3bzG42Gh2Cz4dN5hFYDkXqDHTZGbKHTq1K5AuG3YJntmERMqaZpQOXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoQgefdM7gSCDu6+AaWIe0FIsqowOeHPp7ADsd3r/MQ=;
 b=i60Wsw4O9ZjqezEQkDz8RVkeHgXCQEGz9aqWgwy0kdFQQ6bDkMNJzOcsNIOqE76NOshHcbmaxeIrAtc6dQjBOkwj7qv6rQQ0wc72fJuk1o/zzVpyUtuIuRoXjRn98ZGey1EafsGHbHPep0aCW8XubDnHD0YL5rjq8FknSkvqzlk=
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 (2603:10b6:910:7a::19) by CY4PR18MB1111.namprd18.prod.outlook.com
 (2603:10b6:903:ab::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Tue, 26 Oct
 2021 09:44:19 +0000
Received: from CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c]) by CY4PR1801MB1880.namprd18.prod.outlook.com
 ([fe80::b4d9:80d0:2699:91c%5]) with mapi id 15.20.4628.023; Tue, 26 Oct 2021
 09:44:18 +0000
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Hariprasad Kelam <hkelam@marvell.com>
Subject: RE: [EXT] Re: [net-next PATCH 1/3] octeontx2-af: debugfs: Minor
 changes.
Thread-Topic: [EXT] Re: [net-next PATCH 1/3] octeontx2-af: debugfs: Minor
 changes.
Thread-Index: AQHXydSgFT9IM4AXDk6m4Hnsb+1i16vkeX8AgACOLMA=
Date:   Tue, 26 Oct 2021 09:44:18 +0000
Message-ID: <CY4PR1801MB18800DDB8461FA1B5F53DD828A849@CY4PR1801MB1880.namprd18.prod.outlook.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
        <20211025191442.10084-2-rsaladi2@marvell.com>
 <20211025181244.13acd58b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025181244.13acd58b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec4df463-492f-4882-1e13-08d998652e6d
x-ms-traffictypediagnostic: CY4PR18MB1111:
x-microsoft-antispam-prvs: <CY4PR18MB11114E96CCDEE660DE9917EF8A849@CY4PR18MB1111.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:486;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lJA8441DfdEMtcpMqT1VzjGCOwMMX8oEUCsDNOetAndX2rY3QR9vD74DvmnJ5tJeX/9OmdXQFRYIbA2V7u3drtMiqpZ1K3nMawy40fqLyW/GouAIj20yyHKB2UVzZWaaNdwPw4VJ/ql4fIoZC5y5GKQX53eCbpWbVo8G+q/QwF4s6GCzHI6gm3Ns5804lvTgfPQa6MsUMzBNbSMz14qIzSiJ0KpMube/BhMWcClsMyivzL8tf+2hgonlRIeA9z2K1m8lAKGFBIhywfmt4jIF21MOzyrOpHEx/9CgLsMlAMIDBNdSa6r6jOS8gAsqpwMad/EsoX1fEZulCrFJihoKUio1yxxwIEPQZm+OCecXFylqXQH1sKKRMUJgIcG6LO7k0wvaVYHwMDbUEt1v83Xe2BW5Pm52cd9T0m/awdbDRqU4widbhtijpo6Bdnx31bqBhNxbT5zmY2memoJSqQjL7hqHTSRX7eKv191RFI8trxwiNTWgFkqvLWkhsRyp4MFrCoKwZvEFCWfFaWRLBpSF2kM4RXiCHfH4qZUF9O4jW8Fp1QVOddFnerLT9hqDbcXhrXCmepRzBIH39RyokICpJ5JcP2/zDnpDR2Ut0M6/V6jk5x74M/FsyNeC82WLK2giX7uQJ2iMAPmhW0UDH268RRbvsIG68mlDhXF/g+bMhDWaRQmX1Qv209w2MN/nKgO1naL3ioMSGTj9UTT2ukgWkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1880.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(66556008)(6916009)(66446008)(71200400001)(26005)(33656002)(7696005)(2906002)(5660300002)(76116006)(66946007)(64756008)(86362001)(66476007)(38070700005)(107886003)(52536014)(4326008)(186003)(122000001)(508600001)(83380400001)(9686003)(6506007)(8936002)(53546011)(8676002)(55016002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bCwnijBK3g43o3UmX/Jl+TotZXZkYrtww0yxbhfCvujjFVjN78F12Y4hEjtT?=
 =?us-ascii?Q?hXMWgHPM25nLdCQsE6dy9M46qxSykTuE07AuC0knVwskwSu2XMyMxThU7LMn?=
 =?us-ascii?Q?85K4Ms1eB9V3vmQATCzJKw6H4x1ivaWdbvJrQ8PEuFXDkAt8JhOmE2EJLMA0?=
 =?us-ascii?Q?jU1ldDhYGv1YHzGBH2VyEptEtYHDROiADOnc91dDM7ND4yFqM1rRGEUjYfYG?=
 =?us-ascii?Q?ujfcDmamRHKzDRQ6bTWMoBxcJqoQMFJdVLgdTesu85l9jyjxQ8WJgh7eSrQ7?=
 =?us-ascii?Q?uzTof6A1r/VuaUMmMKYIFp20S2svwsY01QEYNtJi0mmednM35L+lii4elRKg?=
 =?us-ascii?Q?5WcVeKJh2QN3/GO+zZuUcON9/qhEqRxrY57Yu52nKVgi8Cma+pcH8dHA1lZE?=
 =?us-ascii?Q?mH+vc33jwR8kmmvsyWN63YaGY8+dxS7zU8RnXggQzeWPSf7P+T0SlTi0br7R?=
 =?us-ascii?Q?EnlbvEHNcxnmjx/0B9PA0z/iRqmmUaCk71/dAhJSk6cHfAC1V3s6uI6BFIRU?=
 =?us-ascii?Q?+GBpQD796JSzZz2e+cF0T2r84vmIBLwvm5JArRS/f3c9xxwheBQsV3RNgPU5?=
 =?us-ascii?Q?AdSv7b0YY5d+msDwWIpMWUZsh4bXa+gJWAUiCI9Ez9i5ez3BURKhsD4xr2g+?=
 =?us-ascii?Q?sg0dL9m99lAfpQQqV6xspjt09w6UqZ9O3I68q5Qcs5ZtK+2hB9AjInhj96Dn?=
 =?us-ascii?Q?BK4WzG5LntWWX+Ji1u+T9Zoh8ReUV27c6Hgg1qOKVmqF5WMsA7TZIc1DWiqM?=
 =?us-ascii?Q?3x8ji35c2kk5CVCiWvNQD/vOeCSeOBghqMePW9dkLXA/AC7r3GzNEAsYmCz7?=
 =?us-ascii?Q?GjHqoc7LfaJzMgSAnonhYgU/6fRamfMJDnQqBmjPHmQBG1uDDQeYC5qYx2Ok?=
 =?us-ascii?Q?GvnrfxLynCa4TeX82YMQ+tcx5r0KZvHODSFPOZT7SLOgUjnImHLfIxmMWwQo?=
 =?us-ascii?Q?2ttXWyMU5MSnJD4zzH/X3lQZlXvmBv7DGggxwZWu52rjj088v2KjtV+zvgIe?=
 =?us-ascii?Q?FOG8uHQRQIIDESJ/9PAq6O3TUSzK6ROdx5BEYK4frvt20imc7K4IBScC6oEk?=
 =?us-ascii?Q?pVMRMWe9Xu841RPy31YyXGAKZccUaaw6mvajXemDWRM6jg42IO6JXZGcMaaM?=
 =?us-ascii?Q?fgNy9TEjl/+oh5SB4kc80Tme14gGKkc/eYGTZQsmsNgMwiRxoGl6niKIemCs?=
 =?us-ascii?Q?hFJ88Azl0tEjPLto/IhEI79vxc3gajT7cNcFOT2ao4kUrrCPgm298j0avYd7?=
 =?us-ascii?Q?qvrFVgNPFAM6tor+jId94TfkXlmBcgKlq6fQFNyTC0FPORBWezcQN3iLID82?=
 =?us-ascii?Q?ThWudRvEZPDw0IX3HADRwBiBuFSIzPkQ3C3fpSSTWbFToq14QKa6I9tj3bEb?=
 =?us-ascii?Q?SfRMqOGcntEaR6IY25w9OHsltSJrZ7gDJlZBjIvHbLI/Q/nNEemJLhkMDYxP?=
 =?us-ascii?Q?ZBk8f3rgCfKK2T6tDI8V//yKsi+j4ECpSRim4ZnxPYWHqHvctyxMHIwCIumz?=
 =?us-ascii?Q?EtyLmF+Kht8lqbArsSq0ki/Uws9SFGQQTt+XDbP3708LVmNdtm+fT48aQyqs?=
 =?us-ascii?Q?CdmJX9ckqElImExo8D+BaLR0+fJorTCUjx+ATWGNI9A48ctXhznJzRGRw6LN?=
 =?us-ascii?Q?sQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1880.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4df463-492f-4882-1e13-08d998652e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2021 09:44:18.5678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LhEEET9fImHYvTVegmzkylocP+j15b9Z5AX0efTbqpNKXnOJcCJEiz4XVWXxmx4Bk0sXPUKZXa/f55VJOp+L6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1111
X-Proofpoint-GUID: RTe6v9JgvEtLTICGKUPNpFTHeAZvCgxF
X-Proofpoint-ORIG-GUID: RTe6v9JgvEtLTICGKUPNpFTHeAZvCgxF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-26_02,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

Please see inline.

Thanks,
Rakesh.

-----Original Message-----
From: Jakub Kicinski <kuba@kernel.org>=20
Sent: Tuesday, October 26, 2021 6:43 AM
To: Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc: davem@davemloft.net; netdev@vger.kernel.org; linux-kernel@vger.kernel.o=
rg; Sunil Kovvuri Goutham <sgoutham@marvell.com>; Geethasowjanya Akula <gak=
ula@marvell.com>; Subbaraya Sundeep Bhatta <sbhatta@marvell.com>; Hariprasa=
d Kelam <hkelam@marvell.com>
Subject: [EXT] Re: [net-next PATCH 1/3] octeontx2-af: debugfs: Minor change=
s.

External Email

----------------------------------------------------------------------
On Tue, 26 Oct 2021 00:44:40 +0530 Rakesh Babu wrote:
>  	cmd_buf =3D memdup_user(buffer, count + 1);
> -	if (IS_ERR(cmd_buf))
> +	if (IS_ERR_OR_NULL(cmd_buf))
>  		return -ENOMEM;

memdup_user() returns NULL now?

Rakesh > I checked now. It is not returning NULL. I'll revert this change.

>  	cmd_buf[count] =3D '\0';
> @@ -504,7 +504,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
>  	if (cmd_buf)
>  		ret =3D -EINVAL;
> =20
> -	if (!strncmp(subtoken, "help", 4) || ret < 0) {
> +	if (ret < 0 || !strncmp(subtoken, "help", 4)) {

The commit message does not mention this change.
Rakesh >> ACK. Will address this in v2.

>  		dev_info(rvu->dev, "Use echo <%s-lf > qsize\n", blk_string);
>  		goto qsize_write_done;
>  	}

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c=20
> b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index 7761dcf17b91..d8b1948aaa0a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -2583,6 +2583,9 @@ static void nix_free_tx_vtag_entries(struct rvu *rv=
u, u16 pcifunc)
>  		return;
> =20
>  	nix_hw =3D get_nix_hw(rvu->hw, blkaddr);
> +	if (!nix_hw)
> +		return;

This does not fall under "remove unwanted characters, indenting the code" e=
ither.
Rakesh >> ACK. I'll address this in v2.
