Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CE045D5A3
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234796AbhKYHmm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:42:42 -0500
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:39361
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236544AbhKYHkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 02:40:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izjhJdksfabDCndVHAVYgR0mEQgknWBgKZpsSeL5D2E/LGvg6LBhlzi/H+WgeNnfuwHIqV12hD6k5qej4usDOOMf/fVGffe94S46zfeuoWWwHnEho6vquc+gEmc7V78LyDFu5srtFgz8YTtRVbJWwBR0RnsrV7QL/Ng23A7/uXdRoCSXOq5bRCnpwrM1HTVAYDQf8cbG8gQt6CEwiFlFAHiAw0RFbbyDhm5bsQ2608pwKw7ZOwG/jnKUAsQjmG3aWuDzGFn53n67rnRiVHdJ01gA6fxwdwfjAJuZXH7yvKpy+fDcyKIkKOjUJP016U78YM1Ts9vzNWxkn8K9tWwQwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GvFJBmoUE1iDOc0UGQc2qnUc4UYKimwqluc7++B2cBw=;
 b=XZYlJO77tE7tL4DOYiuEGBZp6Uxjf06R1IT1LJ0Z98fdSZbvq8snqcDhpe4I71f91e2q4DMQEYcy/U9RoKS4NjYGDt8p+Ep+/Uds2bzaXke2764QuFmaquhJdWBCOVwN6HxU93cESTtNWKrEilaWH+Upn7Dk29oOCYIaVN0qtYWFA36n0gX0hiNkg7u8nYqZbETvgoGCGV0hip8FF2gSNoX8d9uK3/hEvXVjRUpaKL6nx6h2h5Y1QR1v8gFhiaNUznf9AwShEh1MVAIY4e2fh1JJnX3LQxSsOe3RYKyuUkPyE06F1p1X3GcDBAAwjxuAUmbOj8/hLL0Pc0EaBT3/Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GvFJBmoUE1iDOc0UGQc2qnUc4UYKimwqluc7++B2cBw=;
 b=CIjASsxhBcQy/TazdWaInF916/+87MlonrAQVzB2DCEwDTpuVG13o1gLZqTVkhSjt23/GxKXszTQccIR4yhq2uIhEvD2OI+vOfpUEu/tSlJ5DWokITjHKZdaNcwyZmUG5XJG+4lMYB6+YcmWMu6F5V4rXkzDN/av0eVI7Wdhtobn9dcqWoSMRJBiSxgGF0pTl89PhdpgZcPaiqniStoI9IrYvR9RD5TBJxFV67ZwtvhCe/A6xmvtQOpHC4N5ImFUXaaHfeqp+znBPDF6wNcwd40uxkoFZD8tB9h/RQhq7B7ZyTY6B82p/yDkdtJzIldsys3DQ5ix7WLJ3OQjyc19OA==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3179.namprd12.prod.outlook.com (2603:10b6:5:183::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 25 Nov
 2021 07:37:29 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::a5c1:7bee:503f:e0d0%8]) with mapi id 15.20.4734.021; Thu, 25 Nov 2021
 07:37:29 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: RE: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Topic: [PATCH net v2] igb: fix netpoll exit with traffic
Thread-Index: AQHX4KpS8IRO8CTaPUObrYaieVzqnKwT3RWA
Date:   Thu, 25 Nov 2021 07:37:29 +0000
Message-ID: <DM6PR12MB451662EC02B77D17A9C27473D8629@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
In-Reply-To: <20211123204000.1597971-1-jesse.brandeburg@intel.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b1bb70b-66f7-4d48-d702-08d9afe66f3e
x-ms-traffictypediagnostic: DM6PR12MB3179:
x-microsoft-antispam-prvs: <DM6PR12MB31794C2BE28DAEFCDABE0DBBD8629@DM6PR12MB3179.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z256MIAIJGVpsvbYW53a91FaDDAzLcHpFFsD2iFOonoQsVM2XRXiTl5Yxv21TonWFswiKU/B1cndwnbr1XoLeU6BFC3LXbatmnTONoY8LY3KIsuOE6tlbC0s73ceoOvHryheJTRQyR+b2bM4hUOSpZKyM/+IzfdOJPQrUyYk8XoPe7HZuKGv6Whlk+FOPRW7cD1Rgy+TwrYwguWbo1UObJwXGDWShukcgjHvfBViWBM8EMzvjHg6bUIZGJQ8oVYfrSKEBeu4YS8G5HaOwTPlAgCpLCJRkEH4VT7gElOFjJITLinBLpLASFWPFEqEexh8SXCbN2/lQs/hedgxvkGwg8/CRQtpuNlOlWoHmCqwMBHQlKG9gSu8Rul9TDY5r2hj2NWDkLPP2skTtxhrtDmYs154nXCwDv1WyN3Wifi2xb2wU1cq/4wVhA9aiAKe8BdcToIROps3ozMs0ivtE8DHSB6o3j9pv19IMVup8/lbRSE7okiDYXk6q1Fmlc+FZ3Egeoo7/SI7y4mfYE6mshZesfhEroVRZT+kb8z8x6UaoEkvZB2HCUCx9XXDkdanlvILxW/ifAORmsqsZk/Wk7ULXlAVyaQAY8BJOpVyGQEbfGs4ohhKmi9YBFasY9UTm363vfj/jiWH3X9dmmqB9N//dSjO6CceU7ojbhp4pJaY6nzpItQqKR3Jond0iKPoiRzlVMYveGQAmxJXqeG24Nis3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(71200400001)(316002)(508600001)(110136005)(83380400001)(86362001)(52536014)(2906002)(54906003)(66446008)(66946007)(66556008)(66476007)(64756008)(8676002)(186003)(8936002)(38100700002)(6506007)(53546011)(38070700005)(55016003)(33656002)(4326008)(76116006)(7696005)(5660300002)(9686003)(26005)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?w7IcrJPTxA9uRop8MlhGjQDdjU5cT7hgt8xQbOpJL5wQ8jTpEe2RxzR9QIWy?=
 =?us-ascii?Q?fFEoTSiGNWVTfDlILxVWWZ+AdW5HQoayPpPuhYIsfED11r6xYuZph099Qcn0?=
 =?us-ascii?Q?6y1aBKr8mqnhsVc2hEi4wEyco/0nN0Sl0higMImiFbfNyvK0qtIQEKNvSYVy?=
 =?us-ascii?Q?0V91R4Mfjyd5+aMAIBMzdFCGLobJNL/su+N9DeWafiqpRpZ/hdo79p7rzLx2?=
 =?us-ascii?Q?x8elu4YGdX1pRMwG/mQCbZd4Ap26S+nQ20b4ZVJ2bvEryy4wS9RnOwnEMlNv?=
 =?us-ascii?Q?QdaAMcKjshrMvN1hm37orbnJ+UI/gyzqsKHCYOdonIedXpSPdWUGoDYHvs/5?=
 =?us-ascii?Q?816ywR6DglqE5Ii2+V+2+/2ueP5n+Cku1T86xUEi1W+XxK+GSoIPfXuiAcyo?=
 =?us-ascii?Q?Ea6PyPXK322lTDZnkc8ulyj88X9ruGOTRK+dujwcFTrP/Gn0sjHbhZH7KR++?=
 =?us-ascii?Q?L4Vlilij+BtjvgPBDRup8Beb7Bh2MvwveqKu6jx2lj4ld/nMgIhchPcFKnyF?=
 =?us-ascii?Q?YhpuJJi8j2jCOYYGZYNay92XNb/JsmFT6fbXQFENG4kIStqBE+GQu/9ujwy0?=
 =?us-ascii?Q?oJn4m7i4v8WIFen9QHCeZFayDtV+VzunXhYVgd9fuCltzz3s4pZesb04ezwz?=
 =?us-ascii?Q?w52uM0SYu5xOILTsx8mRjsLYuIEPOAAWPytP5zHtDzTNWbTHktbR3lYQ/rDl?=
 =?us-ascii?Q?U56NS9RwjBeDCbhdereyGzFClCAeEIwZS5+tkvyN9EYGL+xM+sz9xZzeE1e9?=
 =?us-ascii?Q?KIvRqg7KnnvCPvNCojwazLoDQWtjbKXQDMsqssd2UcTViDOa8KY81vU7g9HL?=
 =?us-ascii?Q?n/jqpQ3VghbB8mdUAlEH32y36Jf7l3/3HZu/V2OUKvYZ2E2v+qQqBYY/q2d4?=
 =?us-ascii?Q?p76XMcAU5WgMzLMVgm53iU8lINagsF6SH21GnQ70rxf5G2ppE1IaoZV/mPtF?=
 =?us-ascii?Q?1/vG1LavWbKU/tyPzhw1p4fDjmIVvVR+NfVK+PwFZYBGO0Bb1WBEexu0E7QE?=
 =?us-ascii?Q?5o9dS6PbuL5COwh33KxyveH9/13T91W36/GqUkzzB0dCdY2Qvxs1nJ+x4bBo?=
 =?us-ascii?Q?ETPXbzOWOjlBZKs5b46YPNL1iowdMJpV42WLnSOG5lehXMpT3PQKdGIKs2GB?=
 =?us-ascii?Q?H9nqgnDkwDJJdQBoUxDxAjhrVwZcoeb3LqWVjb3I2phZaPFhswgDSfkS3y7a?=
 =?us-ascii?Q?0gPRN/O7q7FXV2P45ybZtiU5Bj6LRvVS7aJCpNQw/kCcEKUlw/H6Ib8T9dr4?=
 =?us-ascii?Q?Rd4jzf/ylVFQP0oGGuNOajfvbHgAVc4ui6e/oJQ47fN3p5DL9nPE+A6vDXF5?=
 =?us-ascii?Q?EXR9JIQmZMefCGIezXEgYRLZRjoA02+fsxAYVhn3CATWs5vgDVUIf3hdj+Hr?=
 =?us-ascii?Q?Cfo80hwOCCyt/gG2SIhTZlTljTe0Lz5Q5uxz0rO/dBU0yiokhs7iJ1vtS+bm?=
 =?us-ascii?Q?pd3SK8c5+7H6sy4pL+6jyJIhRr56watOqGZSwoorRJdZLhF5EW62DRb8lA2s?=
 =?us-ascii?Q?7LUAWopikjb23QZcxXQ/a9IlaTFS3w86JSp905xqyAz7H9GN11VdLY0puQQF?=
 =?us-ascii?Q?JrzYZOza4+Nj0rHOQUWLePx4b6iE9gUAGmCOIgOyaSBCiCnAmqYlpWm3jrO1?=
 =?us-ascii?Q?UmZwmyjgGfKOTOpQxsl1uBE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b1bb70b-66f7-4d48-d702-08d9afe66f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2021 07:37:29.2786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TR51NsV/tI2CK5QWBecvrIPVqZClDhhRuzQrkIIF1gQ9/XaFPo8J33d3qcXctY1r47MlkOvwY8Ir53PZKVopsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3179
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Sent: Tuesday, November 23, 2021 10:40 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>;
> netdev@vger.kernel.org; Oleksandr Natalenko
> <oleksandr@natalenko.name>; Danielle Ratson <danieller@nvidia.com>;
> Alexander Duyck <alexander.duyck@gmail.com>
> Subject: [PATCH net v2] igb: fix netpoll exit with traffic
>=20
> Oleksandr brought a bug report where netpoll causes trace messages in the
> log on igb.
>=20
> Danielle brought this back up as still occuring, so we'll try again.
>=20
> [22038.710800] ------------[ cut here ]------------ [22038.710801]
> igb_poll+0x0/0x1440 [igb] exceeded budget in poll [22038.710802]
> WARNING: CPU: 12 PID: 40362 at net/core/netpoll.c:155
> netpoll_poll_dev+0x18a/0x1a0
>=20
> As Alex suggested, change the driver to return work_done at the exit of
> napi_poll, which should be safe to do in this driver because it is not po=
lling
> multiple queues in this single napi context (multiple queues attached to =
one
> MSI-X vector). Several other drivers contain the same simple sequence, so=
 I
> hope this will not create new problems.
>=20
> Fixes: 16eb8815c235 ("igb: Refactor clean_rx_irq to reduce overhead and
> improve performance")
> Reported-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Reported-by: Danielle Ratson <danieller@nvidia.com>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> COMPILE TESTED ONLY! I have no way to reproduce this even on a machine I
> have with igb. It works fine to load the igb driver and netconsole with n=
o
> errors.
> ---
> v2: simplified patch with an attempt to make it work
> v1: original patch that apparently didn't work
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> b/drivers/net/ethernet/intel/igb/igb_main.c
> index e647cc89c239..5e24b7ce5a92 100644
> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -8104,7 +8104,7 @@ static int igb_poll(struct napi_struct *napi, int
> budget)
>  	if (likely(napi_complete_done(napi, work_done)))
>  		igb_ring_irq_enable(q_vector);
>=20
> -	return min(work_done, budget - 1);
> +	return work_done;
>  }
>=20
>  /**
> --
> 2.33.1

Tested and looks ok, thanks!
