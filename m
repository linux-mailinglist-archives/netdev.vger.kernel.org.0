Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A928249D25
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 11:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbfFRJ2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 05:28:49 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:35970 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729113AbfFRJ2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 05:28:48 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5I9Po14013985;
        Tue, 18 Jun 2019 02:28:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=2OMFaY3DvEdNQscN/Z79rzD5wQAQXAiehbS+Tsi/kqw=;
 b=MP7flYTOiu4LCXAMLtfsv3L7EfSBlEHfpLyq8s3uPwMexZnWXM4dHZBmNDIq+2levbmr
 gLgnJVRydDfl7MOXegaeeWkUEBxznfEba06kW3w02Mx4hWGxl9Fbg5N9CVb6443AK4I9
 NfQvbEtPK0B0GfaxLaJFGxVDP41CGmDfX3vnW9kdEeczypgeqwW+QipiYh3uraOFwRHQ
 p/XV2bXKip61CE0kKS1ykTm17f6EfOySsEY+oLLW8YvGhHiCsIomygShKdgIpNz28wx7
 MabAptoaCnuseRw5b2d7D2PlvxzTWGK0GNhCm45tctlkO6htynjvY7FqZt9GJ+jD7iM/ jQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 2t6qgp98x1-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 18 Jun 2019 02:28:42 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 18 Jun
 2019 02:27:34 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.59) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 18 Jun 2019 02:27:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2OMFaY3DvEdNQscN/Z79rzD5wQAQXAiehbS+Tsi/kqw=;
 b=JI4+b7lrDFYwfK7SrBkUGrPtIzn8mhCUzokBaeoyxkdjOKd3bY0IIvuhZEtW1VMlik2jef0yzqBqtMeAV0aY55s6yCj05J+pbadiOGooV5h/V49SGJ/mvOW84cN042cHroDG+x2nhbFEt4FXFVI8Ei4zwINRuv2X8tHtPH/J96E=
Received: from MN2PR18MB3182.namprd18.prod.outlook.com (10.255.236.143) by
 MN2PR18MB2384.namprd18.prod.outlook.com (20.179.80.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Tue, 18 Jun 2019 09:27:29 +0000
Received: from MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413]) by MN2PR18MB3182.namprd18.prod.outlook.com
 ([fe80::9880:2b8b:52e5:b413%3]) with mapi id 15.20.1987.014; Tue, 18 Jun 2019
 09:27:28 +0000
From:   Michal Kalderon <mkalderon@marvell.com>
To:     Arnd Bergmann <arnd@arndb.de>, Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Ariel Elior <aelior@marvell.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Tomer Tayar <tomer.tayar@cavium.com>,
        Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] qed: Fix -Wmaybe-uninitialized false positive
Thread-Topic: [PATCH] qed: Fix -Wmaybe-uninitialized false positive
Thread-Index: AQHVJQ1RjdAP7KlUu0KWNfQZMWSgEaahJdXw
Date:   Tue, 18 Jun 2019 09:27:28 +0000
Message-ID: <MN2PR18MB318218F121EBE1144A4AA36EA1EA0@MN2PR18MB3182.namprd18.prod.outlook.com>
References: <20190617130504.1906523-1-arnd@arndb.de>
In-Reply-To: <20190617130504.1906523-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [212.199.69.1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 203523ef-8246-450f-00af-08d6f3cf2ee4
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2384;
x-ms-traffictypediagnostic: MN2PR18MB2384:
x-microsoft-antispam-prvs: <MN2PR18MB23842DF7EF97073DAA581DBCA1EA0@MN2PR18MB2384.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 007271867D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(346002)(39860400002)(366004)(376002)(189003)(199004)(305945005)(7736002)(229853002)(102836004)(71190400001)(2906002)(6436002)(68736007)(52536014)(76116006)(33656002)(66476007)(66946007)(64756008)(66556008)(6246003)(73956011)(66446008)(25786009)(316002)(4326008)(86362001)(11346002)(446003)(476003)(486006)(76176011)(186003)(9686003)(14444005)(26005)(8936002)(71200400001)(54906003)(110136005)(8676002)(256004)(5660300002)(7696005)(55016002)(99286004)(478600001)(74316002)(6506007)(66066001)(14454004)(81166006)(53936002)(3846002)(81156014)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2384;H:MN2PR18MB3182.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RHdU2ycBejTqu/Y0rE/iEne+MXO9TsxKf+nMoA+lndUH+hUqL8/+e4jsZtRO0H3xkCHN2VbcZ5/FZi3CgE2BsyLwCtvgIybXk7s2ynLRxaTicw1FLBMKp4hsYBwhJ2l2jVj1uhd9SwgHmUsIR6cM9iPf1JCCFdxGkBLOgG5B4T03kb8qoX6vczCih+GKz46Ssrexcq5rAPe+K4rFvqjoNuO0utketsMvACz5rYt+F/KcBcRilRj3R3g96InuJ7bubZGCI59yBOYZZaF+DDPvoLwh9EM9voldj6O6Shr1RLZm+4N6YfUGTRsL9YM/+Dm+NLrdz4MHEl8g+5svPjy4kOd9Mxd/LNsuUQfboZdvkVAMz0La5v8CR+7HNE2JnOgKqKeqLLZLeT3MkK6sozwUQpVRq2nZkMIwAusgAZNF4a0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 203523ef-8246-450f-00af-08d6f3cf2ee4
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2019 09:27:28.8478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mkalderon@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2384
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_05:,,
 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Arnd Bergmann <arnd@arndb.de>
> Sent: Monday, June 17, 2019 4:05 PM
>=20
> A previous attempt to shut up the uninitialized variable use warning was
> apparently insufficient. When CONFIG_PROFILE_ANNOTATED_BRANCHES is
> set, gcc-8 still warns, because the unlikely() check in DP_NOTICE() cause=
s it to
> no longer track the state of all variables correctly:
>=20
> drivers/net/ethernet/qlogic/qed/qed_dev.c: In function
> 'qed_llh_set_ppfid_affinity':
> drivers/net/ethernet/qlogic/qed/qed_dev.c:798:47: error: 'abs_ppfid' may
> be used uninitialized in this function [-Werror=3Dmaybe-uninitialized]
>   addr =3D NIG_REG_PPF_TO_ENGINE_SEL + abs_ppfid * 0x4;
>                                      ~~~~~~~~~~^~~~~
>=20
> This is not a nice workaround, but always initializing the output from
> qed_llh_abs_ppfid() at least shuts up the false positive reliably.
>=20
> Fixes: 79284adeb99e ("qed: Add llh ppfid interface and 100g support for
> offload protocols")
> Fixes: 8e2ea3ea9625 ("qed: Fix static checker warning")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_dev.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> index eec7cb65c7e6..a1ebc2b1ca0b 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
> @@ -652,6 +652,7 @@ static int qed_llh_abs_ppfid(struct qed_dev *cdev, u8
> ppfid, u8 *p_abs_ppfid)
>  		DP_NOTICE(cdev,
>  			  "ppfid %d is not valid, available indices are
> 0..%hhd\n",
>  			  ppfid, p_llh_info->num_ppfid - 1);
> +		*p_abs_ppfid =3D 0;
>  		return -EINVAL;
>  	}
>=20
> --
> 2.20.0

Thanks,=A0

Acked-by: Michal Kalderon=A0<michal.kalderon@marvell.com>


