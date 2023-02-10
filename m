Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 195AA6920DA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 15:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232272AbjBJObl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 09:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbjBJObk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 09:31:40 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA76B7358A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 06:31:38 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AAnhYr009278;
        Fri, 10 Feb 2023 14:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3rhEN4HwgoMlkp9bnO2x6Lrae0N+YFI5Zoa7+m+gHec=;
 b=PPKB7YlWBQWpjRz+fYEJCQxiph6RBsJUnH5ylxce0Zjh5TMoWpCuYZIpIoFiPRjZbACs
 4kaTNu5ku4yZVfKTeJKh6RkkgBUqZRNsnbryD/42QgxOQ5a5dCUPQZ6QSfMsR6n3oIuG
 NEbDIAmFLBth2tRPS4ubQNOIO3gFSsw8kJa1qUhrlROXUFSFvGLElcRojVF3JPE3cUyZ
 Mn52HDNczrl4BVVn9O50XRohP0uv2CMLERViMc/fIr0bxYay3WDxM/8UJurC2wffZNpg
 Gv0reKzy+TqiVIbJhhCJTv6dlbnE5GxM++qu3Lzy4CQKwxhVPjc4mejHBCr2vGQ5+DDr Nw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu5e9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:31:28 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31ADbg13036229;
        Fri, 10 Feb 2023 14:31:27 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtgnbb5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 14:31:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ho0vXZUPTh5IKZIG6vnV/6dQUv/zaMX4ex+EocqbG4icWZpD8NJJ/oMedCsm1kJrPAbqxwJIms+EeCf7nfV6rW/RKivfxmO8xcGk9bwi8Q9BIqeY5sD6/GG5EySBIvK/YNGoVZdDza9o2FKYhu9wxiPYMc8ABNkPwPk26/VJVMIOOcU06YZhfF/1rtyPDMUDc3ZRsf6+T+dQICjInDjuj+efl0aPARwyACTFxE+HcygB92WC/KoOLALODJYv1+OxrpndGhcG+El3QrH7mS8cMHGxXnsV88dje3Kxoe87HUG9XhMU7n4IL3FIwcYey4GB4Ty9UpGWdANUfYvB/oMmkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3rhEN4HwgoMlkp9bnO2x6Lrae0N+YFI5Zoa7+m+gHec=;
 b=gjQKZJesKPaSj7aZvzMvy+55Qh2TPEACS98uNggsjbt26cPyHRnaOiT0g8ortyVY6dFq31tgbV6L03c/SOt5J+mPRtWB8Xy7KFjy6VBzMhAlH/5Y94VcI1pMhbOFs1SDWsRiwpj0I3EdbcWQMEHtGj1vnn01bUa7E8j780g6ytXKeD8pZINw9t/wmryIpxD24EIjb9gfBgjzi9WT0s2JD5LUzhGdYjBc111SNi0zzpPhMvUiLP0Nm2gQIP+6QfYXpeWjQh3Db2MeSLghAQNbpy+hSR8znj+Mcy1NcuJ7lJ5GIjriLuXcsU6uY7WBvZXPAR4z7AqRSoSvQhpAQelbFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3rhEN4HwgoMlkp9bnO2x6Lrae0N+YFI5Zoa7+m+gHec=;
 b=VnqtZm6xFGquym8vmN+S+B2FRNY5LE9K+rAL8POssylEV+n/iRKiP6L+Hvq9Ay7m/bUtcA9tusZufk150mTjlpiUz7XXx8zYAqPdLWq53w9npYpR0B1w5KSl+S63SJ399CLr7zmLukDF8fNYF/s1RuUynyvB+4iAltSz3groXKM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5013.namprd10.prod.outlook.com (2603:10b6:408:120::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.7; Fri, 10 Feb
 2023 14:31:25 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 14:31:25 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgAAFWQCAAAknAIABQGAAgAAvbwA=
Date:   Fri, 10 Feb 2023 14:31:25 +0000
Message-ID: <68DCB255-772E-4F48-BC9B-AE2F50392402@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <a793b8ae257e87fd58e6849f3529f3b886b68262.camel@redhat.com>
 <1A3363FD-16A1-4A4B-AB30-DD56AFA5FFB0@oracle.com>
 <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
In-Reply-To: <71bb94a96eebadb7cffcc7d4ddb11db366fd9fcf.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BN0PR10MB5013:EE_
x-ms-office365-filtering-correlation-id: 4c205b7d-10ee-4779-feb2-08db0b737d15
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5ko7g9dXWIhMe49igD51IAGASM27PA+BdZV/z0i1urBBkQLSr1OTu7IKx0osusvnEPkBplYCtM3FOMeayAskntn7bA1P5SdTZrOyeNDOgCQHRxRDadFqF4rAVJwRxZX54AnB+L9XWYclquJOGkyJp6hjBW7lEYOZrsKhlAwA5jWan7LDi7dpE3F7MseooXbBZzSqmY9crl62IoH/7UJOGTS8LB/TkyJpVIxbffZEjuE44MOsyPqD7gWIrCincRCWZgOivtgRgUnte6KYcUItzbFuBbkBNVdBH5pjNI2KmYNhZWzcK7APjax/R6umHEDmGJFaPElf5B58ddRKuHoX8hbouZYmLfNnxXnKcSv7xg/0O5+sIjd/HXdYSCg/URFz6v2B3OiQzFnKwGHM5TBWjoGrnSF7hgNtwI8jPkQy9cVCqI95mOCEuXTr8UO6PLemmwtHVvsPyrQA5xZ+uhRkL5UsRDAH/r9OWQ07NUf/1UexmBXDn8Ftlf3y3Fb902FgqEU1YtL7czJI3QI5rRBx5Pc1dljIDrViwrgYevSbpVTmuqROXG7OD35hzXSjTO6EJOBdMMqsYrcpTNoM2o22Dw1ujWtsJkmr5jm22igu7L0i1H/xqk3p+gkSUQb0B+v08QaFMYMIvIZz9WmvbTABydpaPb+T9jXGlFc1sv1DidtmpbXcfUz2jJ1FrXKkj10ohLWR+85sLdPl6HaZtBJkyD5O1Te/+rYy93bkS+p4LUM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(396003)(39860400002)(376002)(346002)(366004)(451199018)(66899018)(38100700002)(2906002)(316002)(8936002)(66946007)(76116006)(66556008)(66476007)(66446008)(4326008)(6916009)(91956017)(5660300002)(64756008)(8676002)(54906003)(36756003)(41300700001)(71200400001)(478600001)(6486002)(83380400001)(33656002)(26005)(186003)(2616005)(122000001)(86362001)(53546011)(6512007)(6506007)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WgZfL1N4nNnD33IG9QJAnBdUlixDswhx2gTQnYgItSpM1nuvx/BP5hIuk7Gu?=
 =?us-ascii?Q?jps8YSks8447keFxG0eDy1d29Z0RwwjLU6PvjTf/rEbATZw+f6j2O6olco/8?=
 =?us-ascii?Q?1bhsWR1u2VFcw0BGE8UIo1IFNRjwZI7VfRuZZJrbD7LxbEGPSDNsDdBPfhd8?=
 =?us-ascii?Q?ayFew4/NOChmh7ESMnP3lU0Vs/AnncSyJdioXrp2lBwO+ZHm+iCkcAXlaKGt?=
 =?us-ascii?Q?fg2GuR2M237j67vhM6BNbSd1T23Ehki9ny12OEDASbPNPq3qPykSmJmuHR64?=
 =?us-ascii?Q?mMCMOfFNaHC1iRjcccH5FPMby0yW4JHwYaiP86x5mDk2GUgZ5Tj3Pn13Vf+E?=
 =?us-ascii?Q?nFZfAG9487ouUrPYGv68VyqYoCq+QxVAWVBni1XYSHrDD2zorwx+R6ZMOt87?=
 =?us-ascii?Q?BlUoBLgMZ3Z5/tUHZHIWzb2a4OHjrlnSGr6raRbOBF31sOs1mb7FxbiN86EG?=
 =?us-ascii?Q?dDrciZUODtnzFGgZkUmc5R5uisiZ6JjAZqxkblk5T2RHi8HnWLPCok8fOrYv?=
 =?us-ascii?Q?AVPOBcjuApr4BHnH9VBPQFNLAy5/JYwtMekClCeJMa24RdPdlvFnvVPv0ppi?=
 =?us-ascii?Q?MzdMmaj5GDNdeQa71UzijUraNTRikJQjY1zyIBFG3xKCA9ExB8mg/kuH5ItG?=
 =?us-ascii?Q?v4lJc/ZsLsjFj82l3AJM9qjBNFAwMGGiCqIIbJ276uo++dbdQauynnCEvj9B?=
 =?us-ascii?Q?8CCVp5gTfy9tNGohnhoZtw7TeygOex7j3TYnVLxNwee2Op8tA1m4uqPIHBMx?=
 =?us-ascii?Q?AfTsMyn8yrIHszu4A1Xc+qwMU4bJEO9Qkc2IPKyrAJAPYlMGQ6jkAH0zNAOm?=
 =?us-ascii?Q?Fcz1fiIvAFkSUXL9mpzGi5qox124SGE448dwX5ZKj24Fh/rbw2XUQ6/oOUkq?=
 =?us-ascii?Q?QsRMofZQG1fdY8Ecqw0w37KfqamEECcFzrWd5k8kqndQf6kjruFZ4Nuy2ckf?=
 =?us-ascii?Q?+AWD7E9ubmZLzkC368HLDkFa/NHnhaJpIFsVTyWrFlacViHhd+jGL50Px5Y0?=
 =?us-ascii?Q?hBU2oD/g8/3Got1VpJUPJP8D6OYvKwE9OC3jkpJzeI6tlcA+ZCsc5YHkFb8d?=
 =?us-ascii?Q?x+VjnliYFfZe741ytEm6rVLUqIi7Kl7N4iN7FbtbhB8oIOZRIvCwcL98ZVcU?=
 =?us-ascii?Q?8XWxl2HcPqp55lcBYZuwwLyf/zuFAcTtRjvQ41/B3Ko+/VWnqGFjX/UjXEAt?=
 =?us-ascii?Q?hjeIiqiGtMVCa7yI6ammOwXuvg2KNd7m5S1m4qky49jo3fn1ahKrLaAH84qQ?=
 =?us-ascii?Q?OGfwgIwFORcBQDlRliBlsDdACfcULLWzV8+Wr09KNEyCCiK1FPavp00ClMp5?=
 =?us-ascii?Q?rqr47rLEKNu4DK56p2N6ccCBU9EFlJhtZZEOyBV61F56tOnDoQniRBR3wirQ?=
 =?us-ascii?Q?1TVtYoTiCTq0Q6X5LcQN1a3pebrR0HiX1fF7HSor8A9uyHTdiX2ZvlCfrsqa?=
 =?us-ascii?Q?V7KsnETT8LzNWhMGmwu34uq3TbQxVzoMr+hJQgTLud2xV0JvxEigADAUBTeC?=
 =?us-ascii?Q?bLZtjvw6ChTARhDjCO8lpz72QWX0XqcJ68zou+HrEiRIoOdAu+SJG0M601sh?=
 =?us-ascii?Q?MsmkqB8Yp1a/P6rT36IM7xRcK6YO8SVh77RuLgPYuDwCvzpty+2pO80lmEn9?=
 =?us-ascii?Q?AQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1E0486F62D63BE41B3797E841C4AABAC@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: I1DyBB6jm5Z7AUWY4uYG8JxqTvJGiBMj0zqA3ZbXlsLFjVieofqnCyzKChtMLznIN196JRrve5DXuh2l/QyQVBhV54GCRpqjPmSPPiU2mynoN2JQgZQ3nnaOoVsdwAGW+ky2mfUOpsRmCHe00zz9AjbkGvaWsjIHtPknVBslgQFNAwJ/qXj92c027kisv0roygXGCtn/4uQIRrl4E2gGFLUrPnTWjoTAg13vp06LKRbm0n8ZrXcIPKhoraBGP56OOpX0eBU3a8uY8jorl2fh5IpMEI5/FObsUiYYQntNRulWlbd6urAcEqAhLJrOwisX9wDKy5IVsIKP4IeWwP25s3HbBrNGGozhzAwsjxSjK4n4w6W4Tsg4A/DFIgLFtA0Yie3jjn/gsbJgZfah4Zz4Erh+dRLP8hlFlxBf4FsgUv37Iszirvawi9RMMenwH00i95myN1nvav5Nj6CEEK3QBILTj6tEdEs0wtvmAoXBS3VRvalxCJL4n6duoxXXiKA7JJi+l+tVKA5z5XXAah832f9KVl6DPtBjFI86ssrQIY/Txj6sOSdcL+6JI2+MYzoLb78eZI9cMIz/fqY+TCDMiGhU+UF8ZztpaqiJsi9Pu7fLOpmJDCKGvmZ+v3pVbZJRVR6QxpmI0OoYZZ0j57xSv4PAmWUdndu9vr9VAkf70RkCINE/O4eEwLInesGA+8xTDGyRiaYh1h9ANsXePKSFb+PhiYOn2Hy1la5Gf9aL5vz5CCuq+RgWuGrJ45adyz2dZgLeWA94MM++IyKW6h/wQWu9CwlfZSYTMSqzzw60F7zBKILcw55tvTozJOwMqfWDv8P72wbtJb83BpC4m6/O+OzK2S+5w6/zgxNacrIT1u+D2khTlC9US3gERvuKVtcp0WbbZCajXd0/lhqWWsdxnQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c205b7d-10ee-4779-feb2-08db0b737d15
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 14:31:25.0326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1BA/YOXaclM6NPJLAE2mlIrdRwu6OZftZ8G5MCs/3hCwnwcxyuuhBKfYgwZcbaM/eA3CNB0mFErP/5tOPHGl8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_09,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100119
X-Proofpoint-GUID: k32UXUxucyd6bm2e5RJGJlXJwSzhHrbp
X-Proofpoint-ORIG-GUID: k32UXUxucyd6bm2e5RJGJlXJwSzhHrbp
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 10, 2023, at 6:41 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> On Thu, 2023-02-09 at 16:34 +0000, Chuck Lever III wrote:
>>=20
>>> On Feb 9, 2023, at 11:02 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>>>=20
>>> On Thu, 2023-02-09 at 15:43 +0000, Chuck Lever III wrote:
>>>>> On Feb 9, 2023, at 1:00 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>>>>>=20
>>>>> On Tue, 07 Feb 2023 16:41:13 -0500 Chuck Lever wrote:
>>>>>> diff --git a/tools/include/uapi/linux/netlink.h
>>>>>> b/tools/include/uapi/linux/netlink.h
>>>>>> index 0a4d73317759..a269d356f358 100644
>>>>>> --- a/tools/include/uapi/linux/netlink.h
>>>>>> +++ b/tools/include/uapi/linux/netlink.h
>>>>>> @@ -29,6 +29,7 @@
>>>>>> #define NETLINK_RDMA		20
>>>>>> #define NETLINK_CRYPTO		21	/* Crypto layer */
>>>>>> #define NETLINK_SMC		22	/* SMC monitoring */
>>>>>> +#define NETLINK_HANDSHAKE	23	/* transport layer sec
>>>>>> handshake requests */
>>>>>=20
>>>>> The extra indirection of genetlink introduces some complications?
>>>>=20
>>>> I don't think it does, necessarily. But neither does it seem
>>>> to add any value (for this use case). <shrug>
>>>=20
>>> To me it introduces a good separation between the handshake mechanism
>>> itself and the current subject (sock).
>>>=20
>>> IIRC the previous version allowed the user-space to create a socket of
>>> the HANDSHAKE family which in turn accept()ed tcp sockets. That kind of
>>> construct - assuming I interpreted it correctly - did not sound right
>>> to me.
>>>=20
>>> Back to these patches, they looks sane to me, even if the whole
>>> architecture is a bit hard to follow, given the non trivial cross
>>> references between the patches - I can likely have missed some relevant
>>> point.
>>=20
>> One of the original goals was to support other security protocols
>> besides TLS v1.3, which is why the code is split between two
>> patches. I know that is cumbersome for some review workflows.
>>=20
>> Now is a good time to simplify, if we see a sensible opportunity
>> to do so.
>=20
> I think that adding a 'hi_free'/'hi_release' op inside the
> handshake_info struct - and moving the handshake info deallocation
> inside the 'core' could possibly simplify a bit the architecture.

I'm concerned about lifetime issues for handshake_info. I was
thinking maybe these objects need to be reference-counted as
well. I'll experiment with adding a destructor method too.


> Since it looks like there is a reasonable agreement on this path
> (@Dave, @Eric, @Jakub: please educate me otherwise!), and no
> clear/immediate show stoppers, I suggested start hammering some
> documentation with an high level overview that will help also
> understanding/reviewing the code.

In previous generations of this series, there was an addition
to Documentation/ that explained how kernel TLS consumers use
the tls_ handshake API. I can add that back now that things
are settling down.

But maybe you are thinking of some other topics. I'm happy to
write down whatever is needed, but I'd like suggestions about
what particular areas would be most helpful.


>>> I'm wondering if this approach scales well enough with the number of
>>> concurrent handshakes: the single list looks like a potential bottle-
>>> neck.
>>=20
>> It's not clear how much scaling is needed. I don't have a strong
>> sense of how frequently a busy storage server will need a handshake,
>> for instance, but it seems like it would be relatively less frequent
>> than, say, I/O. Network storage connections are typically long-lived,
>> unlike http.
>>=20
>> In terms of scalability, I am a little more concerned about the
>> handshake_mutex. Maybe that isn't needed since the pending list is
>> spinlock protected?
>=20
> Good point. Indeed it looks like that is not needed.

I will remove the handshake_mutex in v4.


>> All that said, the single pending list can be replaced easily. It
>> would be straightforward to move it into struct net, for example.
>=20
> In the end I don't see a operations needing a full list traversal.
> handshake_nl_msg_accept walk that, but it stops at netns/proto matching
> which should be ~always /~very soon in the typical use-case. And as you
> said it should be easy to avoid even that.
>=20
> I think it could be useful limiting the number of pending handshake to
> some maximum, to avoid problems in pathological/malicious scenarios.

Defending against DoS is sensible. Maybe having a per-net
maximum of 5 or 10 pending handshakes? handshake_request() can
return an error code if a handshake is requested while we're
over that maximum.


--
Chuck Lever



