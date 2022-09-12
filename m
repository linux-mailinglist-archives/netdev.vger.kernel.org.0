Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21E45B5CF2
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbiILPKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbiILPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:10:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34C11EEEC
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:10:16 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28CDHSmt011824
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:10:15 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jgt3my884-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 08:10:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbiOmCu+ywaoPesCIqx76kco4egOrkWV/oMC5ojsHj25DXlWAKfB59v/tk+DAfnBSL0cTiyQga9oEslp+Ci1wxD/nbIKq2+DuAk1NHZQz6+xxYIqxJJ2Ork95QMsWh94QxNk/J7Ptjw5KNTWg8smdIjyg/bMZjvD+HpgqV3C0zNgTtvN+zSVFkYV6FArXxrI6mPK9Ww6rLkHhzKZ/jXx4RxJ0rk9F14aMrRQ6fOFrAYWAduLwVPSz5T74HocLnPvU+mVD+1vIbfRpII9DC/H1GXXy4tVO46mXSXSr6akUn1y/UkiV6TdywaPbKZ9Dg1SWCKs88nChqF7Fyi/zH2skQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PqH4g7Tr0jxph4pvPUEors2L76wG5A061kejZkst7a4=;
 b=HXtpc6AOJlV+2lQZrYMmwb48CD0GOrInh7ox2onTiZ+pYPk7DnpU0Yu218Tr7q1xVekqQyF+qjqO9PbMnY8SBs0kVvkovlpkpgrs+ZygYQlZTe6ALrXYRdnHA67/inRoPNLFsTru5LNE89XkuT87sC7gCGGtnzHYYg6JVpRlELGSjmh8zzjYotFygCx/HZqRG1b1ykjTCVnmyMBRbdIfOMih3miGNCUrB4DOp0SZaTc0xo055LGJxUqGnL6WYRT60nCaRGBNfEHeUKniaIbojoz+IuX3bwHbfVmZ4bHEbsftdT0hJd+xL32Df6IjvUkZxb0FNFJf2LCrSulsD3U9CA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PqH4g7Tr0jxph4pvPUEors2L76wG5A061kejZkst7a4=;
 b=K7stFgmvH609PlJ+qEkoSCo3wpXkEO72+58VlULeeeU3OILnv52nDVtWB4sLCRx9Qs6YHq4BrCeipLdAIsT5XpN/PyTFfN+tSLzrkicnoyW3w87FktCGvAZHBaJivIiPa04Ef7tSo2pre9pcb6VRdriRXAYwPiMfJW2BIMmtVMw=
Received: from DM5PR1801MB1883.namprd18.prod.outlook.com (2603:10b6:4:62::23)
 by MW5PR18MB5238.namprd18.prod.outlook.com (2603:10b6:303:1c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.18; Mon, 12 Sep
 2022 15:10:13 +0000
Received: from DM5PR1801MB1883.namprd18.prod.outlook.com
 ([fe80::58:fc18:d19a:e313]) by DM5PR1801MB1883.namprd18.prod.outlook.com
 ([fe80::58:fc18:d19a:e313%6]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:10:12 +0000
From:   Bharat Bhushan <bbhushan2@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Are xfrm state_add/delete() calls serialized?
Thread-Topic: Are xfrm state_add/delete() calls serialized?
Thread-Index: AdjGub/fR70yQVpJTS+eN+GwmjB17w==
Date:   Mon, 12 Sep 2022 15:10:12 +0000
Message-ID: <DM5PR1801MB1883E2826A037070B2DD6608E3449@DM5PR1801MB1883.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR1801MB1883:EE_|MW5PR18MB5238:EE_
x-ms-office365-filtering-correlation-id: a757cd7f-af2b-4085-a443-08da94d0e43f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TN4aPBBL7YD8HA55gzrM3GM8N+S9M2Sak0WRCGZhDxrynRZUwPw+6ZEhpnNopdJXTaQIyLOI1YkySDsFcvYImM/H7PigPQ+hImqx/mldv+5SlCWIua64f7BMu6vmgXYKA0cP2g/vn2HEQcWGWcwyMQtecEO6puQvsb/XXE8uMYnfDNdROPyY6LHeOqBJ4oFhxE8uhJPhSMgRrSgdKvxPBnr4A0to6AMDLbsh0kDg1dF6U0L6Fys3QOogwAQj5jxCLZTMxpOMlkcgnwc15U6Y+jUtPas+/2wp2mzc1Bjo7oHoCzzkVpIUVroKnibUQws2iVjvDECxMEuZp9LThZpIfN6vKsAK9uJ/V9J7n6lHw9kl1l/f3D78GTG09AbwhcI0ffte593Ewk0wVCK/xu12PMVMy3/v2FM+KwtiFNGb/hflE+okaM+cqRe6g43HyLO11XkhnnGfSKJ34X1Wl5sJFjK4KcYrTx7FXVmGjmyDj/SBjvka13l9fyGTVW+mo4kSah3CaQuV9WUIPPmnSncvtuElIelWesrNZhhq7R2Zwm9wYBRBxn+ivNZ1xLUBCyELSLkVarhaCTX7ad6WSIfBFs1v1/52/j1AYV6CL8taFDKh5b1YjmEimdeG/9eKpGHV0NP55hDel57TLXTn5G165ex386tqxXaEnVpizNX7SK1anXAN9LYJFQWm4e1awd+LPlmpqNKlJXrLAhdIlAXi5PnvCq3o/6wDGzWohLAfjjd2wAKQYuKU8sloVZkOTqIjVYzBhg4WVFwOr6QJJWEnpQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1801MB1883.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(38070700005)(83380400001)(38100700002)(64756008)(76116006)(6916009)(66556008)(55016003)(66476007)(66946007)(8676002)(66446008)(316002)(5660300002)(2906002)(4744005)(8936002)(26005)(6506007)(52536014)(9686003)(186003)(86362001)(478600001)(7696005)(41300700001)(71200400001)(122000001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YYoe/l+ga75ELqKOtqfJGewJyHlZ9Ve5SBwxVumx0+Z0XL+poQiQ5ekL8SBI?=
 =?us-ascii?Q?YvYeIrKwB7dZbAGJjpBl1shoDgB8m7tJ1BxIpD+VrC+xnSe/9HZp13S9QFS2?=
 =?us-ascii?Q?WguQyTus1a62o9NPwKd/9D3Q2FOuSW6rjWJIRrSm93ge9wXyewuzHsoJ3EuV?=
 =?us-ascii?Q?hsTI4UY74nmxSJYXG5yb2ob9giN+JFl7I3HK8kFvhmAYNy4Y6T5sAL16Z7fS?=
 =?us-ascii?Q?TDSIPvXTT2CcZ39WBasZzRpfWhCu2rpUHjp0BnkgkJSGy5sJKDnC50zwOvZa?=
 =?us-ascii?Q?m8rPpS8Pf9ozi5Srsw0f4YANSEJf/Pu2MJvOC2Gb/1R/Ks1ZSlivlOQa3uEl?=
 =?us-ascii?Q?PbYLf0aBvr2SZ6mn6o4uqRtDjBja8dElUW4bfbXdUli1mtyDgQ6690vSptio?=
 =?us-ascii?Q?IwqUQq15BDBbaKzEHbPrneUfjtwUSVeBx/xmtGYag5yAd30Yp1TZGwFRgc4w?=
 =?us-ascii?Q?qd1JWIOKt5gmhVBlmC0Wz8+6MrseCA7+3JolKVXororEk9Pm1hNpcMve5/vR?=
 =?us-ascii?Q?I9oKqpwYHBnldtKPwRkTSo5SLqxT3RrHL0NWHyXf5yKF0pg76u8EV5LtZz1k?=
 =?us-ascii?Q?RFlI62jUnoDUbCXxUmKZUPvyEVgixtCBR6FznzZBNdOLNxCnP+EjM48YTaez?=
 =?us-ascii?Q?NIt6989WVgy6jolLU4SJyLerKn09psWFrt32+0uq8lnk0L1dDHBGdZhkYVCd?=
 =?us-ascii?Q?0X7Q3u/UEGEccCplCVMHp9K2OtGXa+hxhV3HEUwFrIEny/RavkBTp4xbLBNe?=
 =?us-ascii?Q?+jqyYr0kHFIQ7rgFTGJ2PG4QsZoyA7mFP6voReQbTWkNV3fGiBzikM8YY5u1?=
 =?us-ascii?Q?TLFV1vbktbhHQYeTJKiLZ2l46IEy0/9IZTany1eT4PCL5K3iqRdTxx0bIbbj?=
 =?us-ascii?Q?iP2cSU7KekVo2EisiEn7LgKhJFTSdpli+NhetUaHUQz2ZxF+N0XGZ1N+sjNc?=
 =?us-ascii?Q?TtuPbmq5CT/7tMSEEGBjKpjaaY2fMx3vUNxnFdz57a9Pha62ZtpLl5Smyjbu?=
 =?us-ascii?Q?XtchGZGnNCdoRYpEs4fqnQE9SFsGOurz3Y3mANe5p2z12CV/r4BevY7r7a/s?=
 =?us-ascii?Q?0f35k0/yAOV76dQ3OUQZY9JZ1IpMWVw697Kyu5lfSvb08OoJGGYPF2Tbx8cv?=
 =?us-ascii?Q?INZHMF0TheD149GiUAMtMvRZDRgMOxBau3OMqSileN8LK4DjhFbeocCELAPw?=
 =?us-ascii?Q?SyZ/IBUvw4AYKnjH3KIczemXWq02ab+e3nuJJZW+vtvVPiVajbCuAYLU3Xlh?=
 =?us-ascii?Q?7NpHRJAfTEipd7/yZI5eNDPmz6XOKgVlKVnJC+wXpcHyk9cs7QNKRkU584lq?=
 =?us-ascii?Q?P6M7d5MsIkFo7dDunBB6Lr1AHukUfK0mEONnPBxmAy4BmbA32AnPyFLli5Pd?=
 =?us-ascii?Q?XTegwQ13ocN4IqSrwcJ8o1PJe7DW2gOl1PzP4GXpjM8HDInTAqeH0mVKVHrS?=
 =?us-ascii?Q?qU1pDGVeVk8VnsCyu0zXO75gubXv69fgLacxbAhdoByfCo7QS0BjNMxTpI8R?=
 =?us-ascii?Q?OtG9uQ13vUXdbvTg7r1QEbvbuYSXdrgUxX3X8BQiY1XiHApiF1RQGFaP0Q3m?=
 =?us-ascii?Q?ZtFBnMcRnOIwxmE2QJoM6aCQWdrjtNaiC1deKpYU?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1801MB1883.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a757cd7f-af2b-4085-a443-08da94d0e43f
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 15:10:12.9206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jbDjgrh7gSjNmVd+0jk84/AwX/31QqijslsjbqBUxZQXcufSCrLpL14gy4CtSidhn39LjfudRDGpoK8IMUwHKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR18MB5238
X-Proofpoint-ORIG-GUID: jue9qHe_fnFHyzKdUSnLHtpjgOJbkwkR
X-Proofpoint-GUID: jue9qHe_fnFHyzKdUSnLHtpjgOJbkwkR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-12_10,2022-09-12_02,2022-06-22_01
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Have a very basic query related to .xdo_dev_state_add()/delete() ops suppor=
ted by netdev driver. Can .xdo_dev_state_add()/delete() execute from other =
core while already in process of handling .xdo_dev_state_add()/delete() on =
one core? Or these calls are always serialized by stack?=20
Wanted to know if we need proper locking while handling these ops in driver=
.

Thanks
-Bharat=20
