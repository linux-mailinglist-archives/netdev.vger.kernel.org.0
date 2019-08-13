Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFD0E8B5DD
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbfHMKqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:46:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:20052 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726287AbfHMKqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:46:44 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7DAjOmY022197;
        Tue, 13 Aug 2019 03:46:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=Aa3vJQQyVr1uf6SV+3BVStbvqQShk6MjpPTKe4KBf4g=;
 b=rksO+TLIT9uGQh/mzEec/CTaSP7gWKF0gDS4gE2k1ipvJFAIqfLOnB27hucdWvDbClz2
 CR20oGD91Caui/6ph525AmTenGwSSOejOw98Pacoj1uPSVydkgroPMmBFyLS1nzZGGPA
 pPz6ksSYvDRJi/3dY3vcVv9LChpTKGxtWxZNBC7ZHR+WcFyhk2OpKebd+4Qh7uyk8ckT
 IwZlK43T0/eaDTvZFoRjmPuHULq0lO/psJJwaID0ctPwK7yaelyPwJZeaTv5qFDR5BNR
 bjcDzjEr38pHM25VcskKkyYhG1iOQwb/ElXpoi2GoWk1h5QHllXcIhZ/LNsoopHbnA85 Qw== 
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0a-0016f401.pphosted.com with ESMTP id 2ubfactdk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 13 Aug 2019 03:46:40 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 13 Aug
 2019 03:46:39 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (104.47.48.51) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 13 Aug 2019 03:46:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iF2XD6WoH6EVOqUwGJ4tTCU/wsqvEptd5yp4sUADhfkwhuPf/lnxadgg4ze9mr9Nlgo1WM98L3Us1mI/rQtijo09jQfPlmnXymeTvjjA+txoFP7L6X5IEn8FUaGTJ/jStZ6ml80B9uTiZN/ABwrNuBMQVERtxyC88cGo5x+BBgmsNM+/UlatHWR+mNvX7fMY6DQjr0dTSIS8cyBK9ncHucFBs0Fqj71YwtKYtXG+aVTkHS7aqMEWDxqK40Ml6Jn4Hw8yb5SISdrVdM5tVsrOC+rupaCqGz+n44Akau/6+6P4NNjnNX9uUWZszTNauNC2PM/eaSwXZjOJXVMGT2SY3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa3vJQQyVr1uf6SV+3BVStbvqQShk6MjpPTKe4KBf4g=;
 b=G2xeIhaKwZcI0GJQqKbFIPvfyqmgv98hp7fKoKm/tJRc9M/yFdvhrX0de/u6TSseFvvzHLsy5cWN5UsZy5TAi6hptjSL3uktGblCtks241GFHv23dlt2ZH7WCIaSWt3GzgM0JpHLrNw1kBu8v4G7KEOCnUfxdrqc4aBkFjgecycycuTgGN4nEABTt38QezSKaNKIF4yFUvD/b1gPZKF5G6+IVi0R5kTZUhRjBkJ9r1Eg2OkJUityEMB1RogXv7YCdUAsopsifD3lm+AdU96XlafWd/sOJY10pWoJaDaFHtGScj+S5jtT+pJi292nY3Wdu1YeYsjxaAHrKw19i0JXVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aa3vJQQyVr1uf6SV+3BVStbvqQShk6MjpPTKe4KBf4g=;
 b=D1umlj0rEILZduoEHkOV9Jb+M8PDZQ+VzCgnJ+Z2KXIX2YbFoSY4CAIbC1UxGSo+I3RgJ0pMzJd/R+fTNs+hxQd+Jek9J5/RObMCmRmRMLoaaEvMOp6475nHoolhsvPCiJLhV0jfU6B/+k/VD022c+kQAT5/C6vOS3I2+ZQ354M=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2512.namprd18.prod.outlook.com (20.179.82.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.21; Tue, 13 Aug 2019 10:46:37 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2157.022; Tue, 13 Aug 2019
 10:46:37 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:QLOGIC QL4xxx ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] qed: Add cleanup in qed_slowpath_start()
Thread-Topic: [EXT] [PATCH] qed: Add cleanup in qed_slowpath_start()
Thread-Index: AQHVUb6iCK7ea0SB0U63wBrSN321uqb44kig
Date:   Tue, 13 Aug 2019 10:46:36 +0000
Message-ID: <MN2PR18MB2528D8046DFC6BB880D8EFF6D3D20@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <1565690709-3186-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1565690709-3186-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [14.140.231.66]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: efc1ba30-387f-4077-c313-08d71fdb8412
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2512;
x-ms-traffictypediagnostic: MN2PR18MB2512:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB25129B987C391092F87678C7D3D20@MN2PR18MB2512.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01283822F8
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(376002)(136003)(366004)(346002)(13464003)(199004)(189003)(52536014)(66066001)(53936002)(6246003)(2171002)(8936002)(4326008)(6436002)(478600001)(6916009)(296002)(86362001)(25786009)(229853002)(9686003)(55016002)(316002)(14454004)(81156014)(54906003)(81166006)(5660300002)(99286004)(33656002)(186003)(476003)(76176011)(53546011)(6506007)(3846002)(14444005)(256004)(446003)(8676002)(7736002)(66946007)(74316002)(102836004)(26005)(2906002)(11346002)(486006)(71190400001)(71200400001)(55236004)(7696005)(6116002)(305945005)(66556008)(66476007)(76116006)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2512;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: wNQgKzPHaIVqEFaFMd3aaBLqKbaxI2QMofIaCSbc6sOdpSTb5xcWyckrQwI7YY8hnbzGy5MBYtHLwkA9e/v5MmDPH4wMrF4lViQwJLhTmS7JoFFuvMAbonkTKcCZ7AM+B4j1+wfq9ruN1J7hBpFInQ3oNE39419dSrqCG+XV7YPemw6EWHcL5vpS8VU7EJvrgTaoIDmUUjoQGleDe60lFJFTojTZUl9IRFwb3CiCqwFfWVpsZR5N67O8NxhBeCPqtvwy8+Tdu2heEwosXwrGX1fjrEKaNH4I9a9IQ9loyutTgHeXglnZVgl0T/G6rIXUPlW8abgNtAYNKPRVkRlzSZGd96MFc9kkQSFWTs6R/dPUx8/jzie7itR89cHWRjHfyiiIwOUs1Z8LMspBfcHp9waXwg8l28N1FxqgeqFMwDQ=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: efc1ba30-387f-4077-c313-08d71fdb8412
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2019 10:46:36.9645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hxQ6G0GKphDwd60EFmBZCxbHKs80BHLRJCjWKxXf+DFjYlJkEBTMAUTAhhI1Mn9Z7m2GDFPwYD0yHSqlLRwo9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2512
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-13_04:2019-08-13,2019-08-13 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Sent: Tuesday, August 13, 2019 3:35 PM
> To: Wenwen Wang <wenwen@cs.uga.edu>
> Cc: Ariel Elior <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-lin=
ux-
> l2@marvell.com>; David S. Miller <davem@davemloft.net>; open
> list:QLOGIC QL4xxx ETHERNET DRIVER <netdev@vger.kernel.org>; open list
> <linux-kernel@vger.kernel.org>
> Subject: [EXT] [PATCH] qed: Add cleanup in qed_slowpath_start()
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
> memory leaks. To fix this issue, redirect the execution to the label 'err=
3'
> before returning the error.
>=20
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index 829dd60..d16a251 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -1325,7 +1325,7 @@ static int qed_slowpath_start(struct qed_dev
> *cdev,
>  					      &drv_version);
>  		if (rc) {
>  			DP_NOTICE(cdev, "Failed sending drv version
> command\n");
> -			return rc;
> +			goto err3;

In this case, we might need to free the ll2-buf allocated at the below path=
 (?),
1312         /* Allocate LL2 interface if needed */
1313         if (QED_LEADING_HWFN(cdev)->using_ll2) {
1314                 rc =3D qed_ll2_alloc_if(cdev);
May be by adding a new goto label 'err4'.

>  		}
>  	}
>=20
> --
> 2.7.4

