Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A242B680052
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 17:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjA2Qxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 11:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2Qxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 11:53:34 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 608EB17172
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 08:53:33 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30TEO2OT031892;
        Sun, 29 Jan 2023 16:53:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=15/bhCGMvr3ni3x3T4hm4HMRKC/naSvdiUpXZtKti/U=;
 b=qWRyfxthzfarHp6jz9Qwxeg3zHDbayhb74Zn1/DP4CwECeW+WUYMKLCTytJgd4UsVDoo
 +R+5OP1Lg9X8g1uKn7MeZUdUffs4VGoHEn2QN2ez/3AkBRVWa2eHiGn6uZGMCAL/YouO
 KQIYZ0TEqA4o+fUd9TEhNy0alcIj+X6jYFzNFyj6sVhqiyLWkKPrIVGqopOLVpAp1ING
 c/83DxWIDEC1eattCo3nlmKWkgsa08Ar5N9HG4fXxqtVKd+Qzqqex8TbN7XOldt2uguS
 MJc3AKxhUgVAF+6YHGSPh9PFTq95+uq8Gr0rGYW/DZlZDhvny69g41BWGnP+G9m/e4Ji eg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncvqwsjyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 16:53:22 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30TBqVte001501;
        Sun, 29 Jan 2023 16:53:21 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2047.outbound.protection.outlook.com [104.47.73.47])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3nct537nj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 29 Jan 2023 16:53:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CNTV1fJ1Xu6/hnq4DaXb0eXalwFkpnq35/mfTNqkZJ+7WMoEnFxjBFw153TWi/dQPC40eb32FtdpaT8V6Jgm4/3p/mvld5c7c6GWb+So5hBTujHSxscyhK9DHGLI2wE9lBgcZBfDNhsioK6g7+rzW2e5HXPzIP9ArsZovhxJ/WGd11trRXf76fyw3seVdjAB8AVnXYfj4CarrGdQYqnzmD0eq3C00SQqVtO8EjwXPWEKgAvunVW0gvNeEScS22lOB9Eq0tCu1OaB5GI2cunI/JfZ4ZaM0zKLenFmOiSZq4Z0O0WDKotZUry/nYA3BoDcyFDcx6hJqRU8rFjL8FswSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15/bhCGMvr3ni3x3T4hm4HMRKC/naSvdiUpXZtKti/U=;
 b=Sum/ZRMyqJUrGAiYYOqUkp0DTnq/PR38EgL+ZZvgCRvN1shlN+iRjCbfo4Jd0mBPQXrnMsEZ/WbytAKiJ6xHHb1X3Auln0EUVc4c531ia3Sww5dGtwN9/mrsYRi/uD8jEM9XXAQLx0grDCpb175m2C7f3pK3tvmOot7hj/y0Dua/vT39fallk6L3zuUhLijAJ/xs1o+GKlGSvVgCXavcfA1pHDEKA+KQ95um858bEaOGiW+GOq+0Wm7wuUM1o8F8WSfOM5e4oYHlm0MNBuvm14cgPRFCpag8ZQhrm4ZoORXfBIYj/lwCJX+6jtoQg8eeLZTk/i33EpkLXtHK+yya+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15/bhCGMvr3ni3x3T4hm4HMRKC/naSvdiUpXZtKti/U=;
 b=Yb21W9EFVNVofEDNTyeTYYANfBMj927FBD0O2c9HLV/7dQ4qgT+tLzMylWTNGSrdzDzDeK4lzQ5N2mbL8nbDARs7CKWW/c/nHN6LFG3Oq8JppklXvmD9aK1xDpIjBdaG4jgK2nG6R6Fubgc+dpoNpDBFTJgz4BnCPcZ/aI7umPA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SN4PR10MB5798.namprd10.prod.outlook.com (2603:10b6:806:20d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.19; Sun, 29 Jan
 2023 16:53:18 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::96a2:2d53:eb8c:b5ed%5]) with mapi id 15.20.6064.019; Sun, 29 Jan 2023
 16:53:17 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     netdev <netdev@vger.kernel.org>, "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Topic: [PATCH v2 2/3] net/handshake: Add support for PF_HANDSHAKE
Thread-Index: AQHZMvMNX3GnD3At1ECXj8a1a7fZTa60GTaAgAGFQoA=
Date:   Sun, 29 Jan 2023 16:53:17 +0000
Message-ID: <0DA01246-69CE-4509-9397-594ACC038852@oracle.com>
References: <167474840929.5189.15539668431467077918.stgit@91.116.238.104.host.secureserver.net>
 <167474894272.5189.9499312703868893688.stgit@91.116.238.104.host.secureserver.net>
 <20230128003212.7f37b45c@kernel.org> <20230128094005.55190564@hermes.local>
In-Reply-To: <20230128094005.55190564@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SN4PR10MB5798:EE_
x-ms-office365-filtering-correlation-id: 421591c9-1539-404b-ad46-08db0219522b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Dr1mZNmR9BFEPCdmzrPZm55Fg9MnAsklFMHDzDBkqaWglhtiLC64w8rrLlcV11DREU+8dENTX9AIb113e/sVm7y08NkpqDINE0NCADecaxI/5Vfv4CLg9H152fQHBsr2OtbZEhSp86fH9rBOFX1sTl0/nMTT9szsQyTuao5YMQHJJcWF69l4nVFwA72lpjQRY8j89af/8wjj+FDiDmw83lSEwKuDfCRLk7EwpUYLC6MaKzfSgsyi94VVSsF6/eFNLyG5j4q5HfwLLQgX/ZqbIwctqZ31oo/nhGLubevetTD/AMlXEOaqcvq/YWo3R+uyXoc/Tyb3qD+VJ/4ymd2FnLQUbKAxsBzuTnZmmIQii0kikDYa9e3d+f0y6wE6Hre7F9tSrtAqDL+RTeIrpExoFSGASpKyOLEzdBQ0BTLHF+a3NuQalOXDs6rtiOHw7p65MN5nDfz24ne/lwgOF9tA4kno1K2oNtSld+jpivLA7novSLAGi7raGtVLez392mUF5aUo5Y8UoBoBtHt59Fc0n2O69UGhzE+9OD7GDYP9Qax+CiVkMUDW0wt9xezBidSw2sfQYET50djnLsho2UmE0sCJMAwNrIwXHlO1I0wcThE8AFsGBDd+b4D/HdMIds6r8njwHPg1p4A7vxAQzTD266ZCQV9iGY1KCm32I3R0iw8THDxba6qCyjN4OIK5x76/fL+K8IgOgmv+Ny8dOySj7y7eEt2hsTsiIL41hQIpv2ne8fqq+ImgVW3lbMnhwvq64J9zFveodB0vu6Bgn/aZnQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199018)(66899018)(71200400001)(6512007)(2616005)(186003)(26005)(36756003)(53546011)(6506007)(966005)(478600001)(6486002)(8676002)(64756008)(4326008)(66446008)(66476007)(66556008)(66946007)(76116006)(91956017)(38070700005)(316002)(110136005)(54906003)(122000001)(38100700002)(5660300002)(2906002)(33656002)(86362001)(83380400001)(8936002)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6mJiz4q+/QKIBRGQ3frR9dZe31Ko17mY+efcDzeKRPYi2lGJNAfH0tMmWBv8?=
 =?us-ascii?Q?/zCKklMA11HDsRnqMFpVP1MMj1PuZSxA/2vYoUEW/IaJTrvX9s+YzFxVL5eB?=
 =?us-ascii?Q?9t83DWjb8JLh0v6uVihIPFMQ2WTDAlKcTa5gdq6Jp+ZpL5S1laL+kH9r9N8p?=
 =?us-ascii?Q?mJBNcBxUUYEk1MQEr/YeEC5b7kaH/3prX5vYcqUa+1ccdnqHwliWQVdXHZE7?=
 =?us-ascii?Q?r1RxBAmTva6y7SAl9z0/5L4SQ50A4/SvC5HJdr+GROhOKzznDEYvRM0/4hVv?=
 =?us-ascii?Q?5MH/tmLJmgjMG9aNPTMFlvtBq6t/emwo1ReqGftLeMPtD/jGBuvfrgjA9S16?=
 =?us-ascii?Q?w9306ovG7ZAylpg9E58t0lvphFjJ9412EnpQCUa16lMlF7MlMfTaAkpNkDDq?=
 =?us-ascii?Q?eSlPsv6xZTBlG6+qH6PgHRl8pss8OBouAYa8VI6EQoc4Q9Xzdi3sfvFJAP+t?=
 =?us-ascii?Q?cINIohnKSlSzcAWywiVWdP++wCPpyJuVfz++gow+giw/OgaP7caseVf+QDNa?=
 =?us-ascii?Q?oadh9J+IfGUwFPC+VbtcQLofLCtmRzpOvy45qq9ov9dQZaaENasQEuPz1zNr?=
 =?us-ascii?Q?IGCW6ZK39+BOtjVDMGox1LtVAWGX9R+hOmUdUVrzKp5ji5/6fiVGw9e/rcv7?=
 =?us-ascii?Q?tnRymfPYFLECHe2IqrOmyxVKc87exfh3ULPy2PhzPup4HrAFV3Ow4wG+HP1F?=
 =?us-ascii?Q?QqJ4Iw4f4ADAgrkluPZLryHWvvIhbjxOMo44F7vE3kNLvta6fiGleFYoDxbU?=
 =?us-ascii?Q?CjAO//b1fBlGlX9E2Zmc5Z8PSVgHurGCOQz0IYI/NXbTdT4canQF2zY30QCf?=
 =?us-ascii?Q?GMd14Bu/ziMc1AJ7p6CaMsr5Zjh6F+3CBqciqIKZnsBADsnfWIcrFr1/3DW2?=
 =?us-ascii?Q?7uPo4b+6qSbfgjhvfa2IYZ9j40ddauJHAwhiwHXy02OYKdxyLwdhxgItUMr1?=
 =?us-ascii?Q?2Pio9D2Dy7W34OrD1+MtFVuF+FrhqEyJC+XD+QMfTYo7SlNEUe31pCAsLBfi?=
 =?us-ascii?Q?cLMd43qPCWYZCNnZxwhIyLpnSMZCeo102lLsCDAIK1zURbVxRFqSdEIWs/J7?=
 =?us-ascii?Q?XMucsw6+jztPJsXjaslHQ+iQwIgiqsIBCtLN6kJ4jrxpQUX13nqoDC78nbx3?=
 =?us-ascii?Q?NarmzbWYeIN3R+zMM1QkNBG4QCsN1LKl+QTgIy3AszmTr7o1D+Yv6zJV0UT9?=
 =?us-ascii?Q?br2Uv9tvcqDe1QHMEZSCMvhQpLuUAP0R3VHNiodAnJlb7u6FPfEWbHnlhUxE?=
 =?us-ascii?Q?1hyPTmqzrMx4TfB+ffpzD0dGBJruNL7X4MEyR0QGCcCQsn6+jse95wNIL0En?=
 =?us-ascii?Q?qt9F4GzPrFf4UztUpBud9dmBehK+CkwIW9LB3eefSZ5UDH5iBBUVlNOW44d3?=
 =?us-ascii?Q?Yf4M8x8ipTPuMKBVXq9aqmlt/gFRIHmEXbqmkmoavkBJL6+ylEgzZK9Mi0qG?=
 =?us-ascii?Q?Hp6EuUHUzvlHfN22ook4cp5CuWI6DLdTt/jnQFxLyngBCZzXc2geIkqXbuH3?=
 =?us-ascii?Q?d3zWigvmQxKrXD9q5oJV+I7b+IV03M0qerbx4chj01YHVpupnLJ4Lf/+cCZC?=
 =?us-ascii?Q?yMZZ8qJBCgrmCzb3PPINiXqUVCXhiFwzjTvuTP5CSTv7sRe57saO7CBm4iZO?=
 =?us-ascii?Q?OA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DB08F907DFD2F44394FBD2ABFBEAE972@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vc/0cUO9nxvqrrWfMlWenhJZ2+KwYnCCF9Y76U+dIKAgpF+Av4LkoHS/gxX4v/IMaivTe5UPSfvKtgcXw5ywtONddtld7N+cjE6W2eP0PxqimsoJe4BGWnUsm0lnyzsG42d5PkaZS4Jg1v0oVKRf/9hTKF9c4H+ltV+KUKmZn822P7iH53/DXxaO8tguyfmuy9G3sb28aqcoPeWR90PH8ATWboqUCDktMg3LBdTogK7SBSog1dv5Llr5MhesGnWKBbq7gzNqFXIUwlk1uhgzd6wwf99WCXkuWKT1Huh1HgmKL0j3GT/2zxM6Eg6k8dDb7x8TabDhDvXq+SiS2oQZBreP0molQ0LhkkmbNe2pj5x0rNmBbwM7ZHyL/QqZJahE8H49NdEX2U4QbwRD5riQEcMNTzmGMKmvJKrbeYyBNkurx4hecWihrr73HV5DaE/NYeAcRyqobgvnv0ENuQ28ZkvgBV38ChoE4Q58fpiegiosP4K3hhfDiIR0yT93agP1rT9WqAMYhCuw5IWMK/mteohh6JD0dfekp+EzWwrsVXojTGggwoOaXnPZnaT6yVvIV4twOWwamNMkzpZfU/ZxvmqwLAKRt/3r9h9ph7zhqrl61MKYKi/H3byGLMpOQb2o044DZKNmzjJqj8d1sY3GZkzJwQBSogrriQaS/MStwlaZqAoMTC1GM16kiCPsSBkMeznkSwY5PkHVuROz6eRhzsP4mN54pv5HXbMD9My/vaYVs6j1qFNWdLVN0nHWIdWzvfONxN6VjdMrcaYtPvYposc8Y1QNTVDgm9pR8h2HQ5SvcvntTQ7rtfHV/CamHL1n97y6Vmr/VySbOhJWD69w3iggRZBZmTy+0WyoM/6Ezxvv9wFleY9cF+78qITXy7fPEKJP6+SWTSVZ2Aewy+S+LsY5tXBmOdlAOMUgFG99ULw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 421591c9-1539-404b-ad46-08db0219522b
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 16:53:17.8933
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2/UTWjhuAr5BTj6sHBxEpgGSf5GwqvyRkEnDZNZF6tazWaviRQeJHhk+/GNKmu+LQ4ONQAsbKbwDwJZZ7Pb+Fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5798
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-29_09,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 phishscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301290167
X-Proofpoint-ORIG-GUID: nfqcZRCvJoyTyt9lmY297t1CAwOiFbt9
X-Proofpoint-GUID: nfqcZRCvJoyTyt9lmY297t1CAwOiFbt9
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jan 28, 2023, at 12:40 PM, Stephen Hemminger <stephen@networkplumber.o=
rg> wrote:
>=20
> On Sat, 28 Jan 2023 00:32:12 -0800
> Jakub Kicinski <kuba@kernel.org> wrote:
>=20
>> On Thu, 26 Jan 2023 11:02:22 -0500 Chuck Lever wrote:
>>> I've designed a way to pass a connected kernel socket endpoint to
>>> user space using the traditional listen/accept mechanism. accept(2)
>>> gives us a well-worn building block that can materialize a connected
>>> socket endpoint as a file descriptor in a specific user space
>>> process. Like any open socket descriptor, the accepted FD can then
>>> be passed to a library such as GnuTLS to perform a TLS handshake. =20
>>=20
>> I can't bring myself to like the new socket family layer.
>> I'd like a second opinion on that, if anyone within netdev
>> is willing to share..
>=20
> Why not just pass fd's with Unix Domain socket?

Or a pipe. We do need a queue for handshake requests, and a
pipe provides a reliable mechanism to ensure that handshake
requests are not dropped.

The question I have is: would the application then just start
using that fd number as if it had been opened or accepted? Is
reading the fd from the pipe actually an implicit accept(2)?


> The application is going to need to be changed to handle new AF already.

The only application that has to deal with PF_HANDSHAKE is the
user space daemon that performs the handshakes, an example of
which we provide here:

  https://github.com/oracle/ktls-utils

This is for handling handshakes on behalf of kernel TLS consumers.
The new family would not be used by any existing application in
user space.


> Also, expanding the address families has security impacts as well.
> Either all the container and LSM's need to deny your new AF or they need
> to be taught to validate whether this a valid operation.

It wasn't clear to me yesterday whether Jakub's objection was to
the listen/poll/accept part of this contraption, or whether he
was uncomfortable specifically with the addition of PF_HANDSHAKE.
I can certainly see that a new socket family is unwieldy from a
security perspective.

However, what if listen/poll/accept was used with an existing
address family, maybe AF_INET, with either a special bind address,
with a socket option set, or perhaps a new netlink operation can
inform the kernel that the listener is specifically for transport
layer handshake requests...?

A socket that comes from an accept(2) on a PF_HANDSHAKE listener
is also a PF_HANDSHAKE socket, though it behaves in every other
aspect like an AF_INET/AF_INET6 socket. So, using an AF_INET/6
listener instead might be nicer overall.


--
Chuck Lever



