Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF2466AAB93
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 18:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbjCDRZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 12:25:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCDRZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 12:25:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84F9EC78
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 09:25:36 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 324GSw8d007320;
        Sat, 4 Mar 2023 17:25:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=t4EsVj2OASGODtDNthjBikWqGdgQdvezYbdmRjQ6/is=;
 b=o5Ps7rXrtbJuVKFpIN315x97tw5q5YEftvyJqGa0SdfGheAoYucwFNMDPj1ENk3u6F5/
 GKT5Yu8OSOgrHYo0RHDYmQ03bpZxm+kvcPgwCwrzup0JFMMcETzyK86xqfAxbTh6HMga
 OA3BBUShohZGBayOBDNuOaB/+ICnnTRiAIqirs1nppS1n5Nu5uKs+lZqujIB93j52XoI
 ys/7/xvEJgThyhES4bZrea9coVCc/hbXactvqoJi/6GCz95yeVfTfXLAyNUyyZXxqQsm
 svRcj+s0XftoLLFC/sPmjW4GFTvKoQAlhwvdhdkJBRLsPE0gLLZZ2D2nCKRHH0DZN9+r 9w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168ghu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 17:25:25 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 324E7CbU011893;
        Sat, 4 Mar 2023 17:25:24 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p3ve2hb38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 17:25:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksQdbHyhVE1IZGiJSl+D1/HuwXeqcpu6Ntx2VIYa2IRJIULfaYPw8/nWlr0xHITmvHuVnY8pubYZnH9TgnjydieU15HV5iVx/l7Xl8Ujz0l+Tb50ihpt2KLpTD9Scsqtri3aW8PcFCnB+diaWyti9jyYpMlFiJu/0lLBrmg0kiAAhhKv92tr+kzyeiqxGrOxb2XYqp2jGEwNxO1mTXqMo0Cn7s5smD1S8sKoECwrGirtuRu4NMfRWW9JVyZJroubdNVXcaKOUeuAIct/Q/dclpLZw0oow8azxIoX6nTcMHMoRN6Z4eqYgE52LBe9tw1RlF7uQ2oIYK+jYFEAyHZg/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t4EsVj2OASGODtDNthjBikWqGdgQdvezYbdmRjQ6/is=;
 b=UMjBE+eyln2pPUP73cr7o6EJpyoC+0E/mh32GnX+f1LLbOtcCl/Wz2jkR+9DLM/tAqvEuo2VsmO7UymQ4/Q1olPrJnzKL+c3NJxhcjQFYoqsw+DkLEvnnhqZc6JUYYDFSrQUevsKSTdzLeniXmPy4V0CYl/S5fy/CnDRMMWGX8tpK9x16l2RbEuuUQT4CedSWLpq3t38MNvfI4o1HigTo2WYmPae7vYaCSv6oJuO9oUuhz6zqbo7XPeku3TNCNx7dTTs6peD9csTArbYvxrUKu9ENkuFf4uDrWxlhCMo6ddHL82K4KnAHyJ5Hc/ENiJiqhVITv27gqpU4dS5nnpcbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t4EsVj2OASGODtDNthjBikWqGdgQdvezYbdmRjQ6/is=;
 b=I+e0btckOuxa/aR6wVTVbdHWBHlcQTI6iS9d4yYkO0JwsWeSsauJtz7HWlNa77kyAmYENhNiDDkKNpwDStK0ynLQAaM0n6Cz9Abiij/G3g53LIZrhrhBY6LBEo61d52shdPv/7VnzRq07fSpJ9grZvid+CKo2TQ6fhX81j708S0=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by IA1PR10MB7447.namprd10.prod.outlook.com (2603:10b6:208:44c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.22; Sat, 4 Mar
 2023 17:25:22 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08%5]) with mapi id 15.20.6156.023; Sat, 4 Mar 2023
 17:25:22 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4A=
Date:   Sat, 4 Mar 2023 17:25:21 +0000
Message-ID: <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
In-Reply-To: <20230303182131.1d1dd4d8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|IA1PR10MB7447:EE_
x-ms-office365-filtering-correlation-id: 28e96e5a-012c-4ec7-2fb8-08db1cd56ef5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zTXX7mQjXWk+HDvRVL2cQMN0EXpsTm15BHo/xKo4Tmc1ks++J9qkHpoYw74OlrVd42qMe2lZoPOJFj+VGui37uC3fGZCRnSwxvkOkM47C8uvX42i+6KEREdzcCo6H2fJBaQa0aRDOUkw37TTNiDn6GgxCNmbVxrq5JJIOWSbnhj8okSFtn8qwXun5ZAcNMQEYIFBwbg90bfiUiAyvH/gKHOKq6xEe5qJmVvId+xYVrfQWx1J1eg6YVTx4mz/3Ww9qn8OYxhL12zB0JUmXLQ2AzAyc+HzWqfcfCkhWK1xCRMV6DaLT1mcdsHczr3tz2aE6R+LjKmQOPLz6t+dbrLn39FMf6MCGJnKj/ABr5ESJQWGJjc5OxozzbDGNHSBcvrlDHd03dmsB2fOGJ5i5HTYyed2HKBLsdrFWNqzur3eikXY3hMzTa81YARIu/XrFoWzpn1sZOH2bYlpjeoHGP9AXrPaQ1ItpCxeJ/B+sD8HEHCHmOZNf3ADzlxvJSAZ1hqfxMk4eg9UE1werlGPCeWW7xKzO2jQM/CBfYG9xpNCyP1MUT8mDl1dxjo8n4SNeiocFod2dx5ObYe2JwBWlhT8SsNssRx3GbgM5dqIxYyAaf6pciiD9gH5AO/a65sqBgXdYw8hRoEY4JFcPrxQITZ/f26lqaGCGHptJ32VaXukgEbvPDZrKYbGenV/ggwEMn3a6nzb6bAAXz5rxnP4uKEY4hNy/OAgad1UGdDDe2ktp6o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(366004)(346002)(376002)(396003)(451199018)(6506007)(6512007)(26005)(53546011)(6486002)(107886003)(36756003)(38070700005)(83380400001)(86362001)(33656002)(122000001)(38100700002)(186003)(2616005)(91956017)(41300700001)(76116006)(66476007)(66446008)(66946007)(66556008)(64756008)(6916009)(8676002)(4326008)(2906002)(8936002)(5660300002)(478600001)(71200400001)(54906003)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?COraUrzwCNaPDiVU8WLXP6AkYabb+zXneNoOSoyiUEfR3O2txWsESkNv8F+6?=
 =?us-ascii?Q?nCxLlThouQBoORyYJh1xvSZAQoTjIeuZN8MTFVmEVj4ApTXdXE+2OPgSzQuY?=
 =?us-ascii?Q?J/mzINGdhaUhA7BReSlUe1rJRE1bDTvpsNcdNeC5uer6ky2M/TaoThXWRYY/?=
 =?us-ascii?Q?iX0xeXXMRGPy74yFF2IUtXxAEDB1ZWsFjLAOp4tI1ocxwKg113DUAK7vh0gh?=
 =?us-ascii?Q?cX66jPBfNsiRk2fLB5dqyGKwP8YBbVSxiyOfymHNKHmZB3QL00qNNMBWik40?=
 =?us-ascii?Q?ecCCUcVfnVYVtSTisGsXg7MW4IXtY1X55xZ+vKaADyINhJ/uDSt9M6cZ68cX?=
 =?us-ascii?Q?cIpKjHE/2f7e8wjpJzy9iWkRDms+7yCtOwPA7CaN55BDIGXIgiRjM2bXH4rj?=
 =?us-ascii?Q?ucTWhlJRPfi8u5OPhY+/TZsn859fxV2We2qEzKFArGoqJNuPcieRuSNRrXRo?=
 =?us-ascii?Q?4Cmba2ZM3/XFWA1zntK+odxlWohxbXnt3ta49wa2HrUuFNQZ4mkhTOfWkjI7?=
 =?us-ascii?Q?EFz/nt67ZRSpTZPzeRY5Yh6YE5hmPU0ZHbe2Ea6fA9AujSCOskjn9P0cQzzD?=
 =?us-ascii?Q?sFR4IW879uBtN4syfMrPEsi106W3hCM6bMtV9ycxLLMpkQ169lArtBrQdBvV?=
 =?us-ascii?Q?/d0YSeM5DCR/sQFcE1CzE0C7H8aMvkoNx8YToLutd7JdcJHi5G5696ysSBvC?=
 =?us-ascii?Q?oLiWM2Ivn/dpEhlJ0hXVfM1l25cTAzeXq1YHpKTlgYtyFRMT9rQ8mwOb5yQj?=
 =?us-ascii?Q?7wHrWm262nCUCebyr4CRtJTYIoDL6RV6tUzP2ecDr2NF23K1BYxSPCmZgwaE?=
 =?us-ascii?Q?ealRwi0OSbrqfIDwYSw2STcWCM6PMNyj3kuIlAT9EmcydgHKFyW7CCQapxG4?=
 =?us-ascii?Q?wJg2CVj06AeovJgJgADNyJxUuN5YDymr1GDmnRXIBX0q1LACinJioUwyxQG/?=
 =?us-ascii?Q?a35cWbcFYOx4dW3cgqwtW2O2VBalqOKjXfUjmFRkU6WZXsh7SzWIegNOKM05?=
 =?us-ascii?Q?vgOOEw4PBdhT4hazgxiL9VV3ZnVYVBCbQXItF29urmam9ZukIQD1N6gJF1Na?=
 =?us-ascii?Q?NIn/hmucoPXgBeeAxYdBFuekxMcKGOlBHX+bpfMd5Gb7NeOY3sSdUX0XUTYC?=
 =?us-ascii?Q?8qTFiJUwsD/s6eAPbXSe4NtALGHq8UowIzYyBejoPdffWTUMQ0p4scnica4H?=
 =?us-ascii?Q?9TYC+U/8DePXhHE+PjKVrYyG02l7goqlwwHQi/KMUUIvUVYFvlop2/DqUizP?=
 =?us-ascii?Q?UHWnjLHWc5P61UHfVvfPQWnOX5LKZtR+aLlBxsLHbdEkolAv/xbICq5DaVxm?=
 =?us-ascii?Q?CakB0qVPaooKOKiknbbkcJdSUGzeAOh91yYrJU318VCUFyIOloAZ44TjEfW6?=
 =?us-ascii?Q?iqUzDfTKJ1T5GDT2vOqCTNZWveYwlTN+mhduSzXm3oxQWEnUKvkZj7MN5Jra?=
 =?us-ascii?Q?L+ciHBpNowA5UImGO7Ouk9k4y1Kar6Ws7o7Z53LPh9TUCyNlgMsQjjxuhfc3?=
 =?us-ascii?Q?O/oSiorXFib7DsxzYCXbZE6zPWoUbo8GtG2kLxwPg4E/ch9D8d0zBnP+SxPh?=
 =?us-ascii?Q?klr5WTBlQCyeO4iraL/KOXRCDn8Vb1MD4BiaOnEvzctZkeF3AU2j931y+Vbn?=
 =?us-ascii?Q?0w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <568E7844BCB22643B7457C940E77BD78@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8gwTM8CWwjCH95LYr4Yox3wGOAMtxFOV1F6KbN+YoG4MFE4K9BqCKNwMzOtDDKGZ8USAdyapA9xS2QhTb1p5sN1D6T+QTL0zfkz7WI06Ab8N9a+46FcSVW0EYl1bmIWegvovhvNBRjcFGvafJTvPilBInqjK5Y5IKDTaKqnk5TitPED2NmSKAbPiISDsy77hPAZUYZXBeoZt2royFQr4njMpbgGHBETS2daWoL3ENoMSibT65nvnUwwhN/XHAXBOM1lBHqQRGEwn7K8cCb6/UA8GWsgs/GBJPpJ8Tmz/nOZ+zqdyry7QsFBQJz+UWyt7ajRGYLtrSMkl/Bq1LgiIM1f05+NrE3ikw7l42i/emkBeifImlAw4ak0PSNiJ9Kj2CONErCNR1u2K0WSRcXvm35FDD3Vgcl+3Vr3chtqFaV4Xa7NR3u6ffDvCWbMO9Z1NKq84jtNuXBHD+xGiY6kM1OFVki2TutUuoJ8heFoVwRUVwi6hGZrd7MePm7tNy/0YDr+AbTfJpUnrUI7BE2J36Zhtkw9Xo/FVXf7sDpAjkbQHmAXY9hs3XjsBIHkSxjts/SLKJx0ZGIPTKiIZMrcURp7ZbTe4u2HOEm7U7Hg4sxTej4HLxamlK8JBdhCfMsXiKziFVptyD8MRLyoG23enRvR1u/Cvu5LyyUlxPa9azUqCuTosHJy4M3ztWZBCQtYpzJjbX23iLofEgt/KVGEUc5uyT4TuaZbKxZmcDseRTSTvC1ELCAc6MITrfL3ZEhnQm1K4amAAuBSblsNtVQWthn/seZaBHn30mXF3HrIiYgI0cbbd+Ry8Z9wIPn8qxW9ZompqCN+XL9iRZmXrgTMnbChP3MVckTcIOlGoP9wcxaXDq719AWPCtiykMvPYC0XVuJj1b8XzTL9yzne8TueEBg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28e96e5a-012c-4ec7-2fb8-08db1cd56ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 17:25:21.8231
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hPAlbZftNL61uuhvCDlyqfDfuP0gBF9ODA1Z/SdzMtQWQmCddehOjpD+GTaiXDXyQa8/Hz+yYhh+ClFuVsvEAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7447
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_10,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303040148
X-Proofpoint-GUID: 65bAotFt5ns1g2oPGKho86ARhde0L8r4
X-Proofpoint-ORIG-GUID: 65bAotFt5ns1g2oPGKho86ARhde0L8r4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 3, 2023, at 9:21 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Fri, 03 Mar 2023 13:51:31 -0500 Chuck Lever wrote:
>=20
>> +static const struct genl_split_ops handshake_nl_ops[] =3D {
>> +	{
>> +		.cmd		=3D HANDSHAKE_CMD_ACCEPT,
>> +		.doit		=3D handshake_nl_accept_doit,
>> +		.policy		=3D handshake_accept_nl_policy,
>> +		.maxattr	=3D HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>> +		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>> +	},
>> +	{
>> +		.cmd		=3D HANDSHAKE_CMD_DONE,
>> +		.doit		=3D handshake_nl_done_doit,
>> +		.policy		=3D handshake_done_nl_policy,
>> +		.maxattr	=3D HANDSHAKE_A_DONE_MAX,
>> +		.flags		=3D GENL_CMD_CAP_DO,
>> +	},
>> +};
>> +
>> +static const struct genl_multicast_group handshake_nl_mcgrps[] =3D {
>> +	[HANDSHAKE_HANDLER_CLASS_NONE] =3D { .name =3D HANDSHAKE_MCGRP_NONE, }=
,
>> +};
>> +
>> +static struct genl_family __ro_after_init handshake_genl_family =3D {
>> +	.hdrsize		=3D 0,
>> +	.name			=3D HANDSHAKE_FAMILY_NAME,
>> +	.version		=3D HANDSHAKE_FAMILY_VERSION,
>> +	.netnsok		=3D true,
>> +	.parallel_ops		=3D true,
>> +	.n_mcgrps		=3D ARRAY_SIZE(handshake_nl_mcgrps),
>> +	.n_split_ops		=3D ARRAY_SIZE(handshake_nl_ops),
>> +	.split_ops		=3D handshake_nl_ops,
>> +	.mcgrps			=3D handshake_nl_mcgrps,
>> +	.module			=3D THIS_MODULE,
>> +};
>=20
> You're not auto-generating the family, ops, and policies?
> Any reason?

I couldn't find a way to have the generated source appear
in the middle of a source file. But I see that's not the
way others are doing it, so I have added separate files
under net/handshake for the generated source and header
material. Two things, though:

1. I don't see a generated struct genl_family.

2. The SPDX tags in the generated source files is "BSD
   3-clause", but the tag in my spec is "GPL-2.0 with
   syscall note". Oddly, the generated uapi header still
   has the latter (correct) tag.

--
Chuck Lever


