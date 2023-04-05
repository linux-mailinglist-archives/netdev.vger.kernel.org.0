Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA286D7ED7
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 16:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238351AbjDEOML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 10:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237960AbjDEOMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 10:12:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA07B61BE
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 07:11:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 335Cx5V1010133;
        Wed, 5 Apr 2023 14:10:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=fMtMo2SuS4MOWu41Sdhj/LAUYy9AjzVamRjIn6EQUOA=;
 b=HtD8EpmIeJp7KIvHcp4s7/x6QAjDb4cee8F7XE243QKuzbmmztpgwy7rgy2cgeYNDMj8
 piyMEsZdduODFfPIqf33w6k6Q2sABLfLLE2zrWVy0gNyeTstEF15FESZLxMH4c0wQUta
 S1GKZrV6Wuaz7GRkYwT443kpqxK1hZzPIV+F6Xa43bguIoAqxyi5ZKf4+4gUUT3b6hvp
 nm7qNr/0BimdEMTM4Cn5DGohkmV0rGOcquqMc1tsmdCVEtDwEkIuXe0OpVZnl29jtZ3N
 e4syVtHerX0RyjGQDSJU+xvnd6UeyRkGdtcT64wA+IZX3p/g3beivZ9wtSK2/6cdpW3y tg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd40fwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 14:10:23 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 335CbZSD039457;
        Wed, 5 Apr 2023 14:10:22 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ppt27w97u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 14:10:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oHz3DIxynef7VE63zRFkTkO/rduH6+cgHhzhfQa6MBLwfz0E5Eh1FQbGhGBdDH5dmT7la8zwp7O1pIwDVwtBdlgIXydQmVDunltO2lxx9fQ5jvry2yUbTJ9AZf9FHQE6C30JVJfK7UK9Ib1IQppmFK1TT9mMimNQlYQJ+Ia8ea63IBhbPQCdrB15PKny5cY4p/LOZ/cz0rzU4AU8ksnxKSzmjzr3BWG9+wHhhebY4+F7oCHYk9py3nDEgkiDdZh1NBfuhRcLXTYa8d/AewIPIPJKF9A4o1TM9D2Rb7RbfAahswnjGpL8kGIIs84w7BYvpfrbXMIScR4OisKWt9AIgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fMtMo2SuS4MOWu41Sdhj/LAUYy9AjzVamRjIn6EQUOA=;
 b=QvDWAO94GVMTh+o7PyUcvePp5GeKNYry3Fm3jhblrygwuZyWrkZl1n+RkaDhigiPfefILVY+khQOTmgYtR3woc0VGho7sdfMeMspo6QXuvxxt8j7mV3WkcV807nrpFle57ZKSNsB5DI5pRO2puYDdhXbeTpaWcD2W0RPE+95RpIKAoUI6oQwywfVLNConHqeo34MrxdqOEeGpyxj3+1Vq1hwC2fxYYXHmnbtt6eDPXPpa4d5U2DFQc7oMKLEh4mDlhLVgiWhcRCLijajTDqd9RgcVm18W3WIqs9y+Ett1XqB/cUNhP3Jh6E4ms5TVfFMyaqAo+uKo6+TA/4u7oYcsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fMtMo2SuS4MOWu41Sdhj/LAUYy9AjzVamRjIn6EQUOA=;
 b=DeakkkgVpz4nzX56pBKpz52VGCXscS+2Tj48EtNDvSnqSCt7f+szm7u5mPStWYnNRxOI7W6rtVrmst4RF0ZyMmNqxo3OJ0ZXoSoxwkIeFLTDJKQBft3Z2rmA6b2lge+/jZpqei04SQ1m5ofDgecZOIOZwur8s0o4eXNe02yC6AY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4571.namprd10.prod.outlook.com (2603:10b6:806:11d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 14:10:20 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 14:10:19 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v8 1/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZZlySHnrWBVVuSE6PrOQpkUIzqK8bSb6AgAACLICAAIqngIAAbXiAgAB/5QA=
Date:   Wed, 5 Apr 2023 14:10:19 +0000
Message-ID: <78F3B3C0-D863-4DC6-BAA0-9730ECE32529@oracle.com>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
 <168054756211.2138.1880630504843421368.stgit@klimt.1015granger.net>
 <63A1FBC9-8970-4A36-80B1-9C7713FF1132@oracle.com>
 <4dde688e-21db-6cc6-080e-c451eac2a9ca@suse.de>
 <20230404170035.6650027d@kernel.org>
 <7dc57e79-bba4-edb3-28ee-60293bcaa9cd@suse.de>
In-Reply-To: <7dc57e79-bba4-edb3-28ee-60293bcaa9cd@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4571:EE_
x-ms-office365-filtering-correlation-id: f0838063-969b-4e86-7aba-08db35df7ce6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: t2Gb25S657hy9LwmVoR1QY4iaaaYO19LqoLV0WWubHIsNTYl6MaFb7XvABrm53hUsXvcsws2o4r9XEDq28vKgz8CJL4k0jolWUGcN+wekT99HrOQMY0u6NCYqUEvIxUW/zBxTlszcIJ5FhmN4Kjulcp3qnWAFISx0AdLzaZfdN3On8ntnk3nyZbKGJ8HjDy9bGn0qonmfrwAoyBlYxYXhRBXFN5Bao4JBas/jNmCv/B6fciZsjUzZNr1NvK6LIhksOYQfUzYMSkpxri7I78kDcM+o/MMiJcCnBZDNF3SfaEQ7JzFC5PeLsCEiyTbRJLrEy+R/2UNtfr17eiQf8w9zGtDVWEgFuSA92kJ/2gVR+bIKh4+UpljO2QjbZeCOVjik3E9KKhJeRkNKKZX54l5EJG91r6/S9hzxZ/j05EPjkPSBWuO70f1kFFOtrp+pZ/bqwhCOtT3J8YYxbDMQt42D3FpzTRS4r+21pQQC4XqZYNcZd20iMJ0Prvpdrihb1xNn/CVC3MAFjUIKqydM6V9UHPf+09NgLbWg0kNG3F8ePefS8iJj2W94YlmEZxIAiQiTBN4taZvI3BRkDVmqyp59VP9FFBz/eWz+BGWWU5lg8yOUMnHKQefUnIqs9T38VUU1K8CkvsrxgI8Z/FkpYyMcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(396003)(39860400002)(451199021)(2616005)(186003)(83380400001)(91956017)(26005)(6486002)(478600001)(71200400001)(316002)(53546011)(54906003)(6512007)(6506007)(107886003)(5660300002)(64756008)(38100700002)(33656002)(122000001)(36756003)(76116006)(8936002)(8676002)(66946007)(4326008)(2906002)(66556008)(86362001)(6916009)(66476007)(66446008)(41300700001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?TWFC18woArUY5xR5J23OzL/DmHRmp34Ijvp3klJjR367PSRMTmYaS4QNWaQw?=
 =?us-ascii?Q?fHhP6MFZC19Ju/vog6dbAGnJSvNIrJVz0kbv/Uhzy+2O+u7yeRqHcfRJlvxu?=
 =?us-ascii?Q?kHwAsIBs32Fx6OtXMsUbUzi89JAonOfG/hX8tseR+Kr4jcuN/R/9Bf5U5I16?=
 =?us-ascii?Q?oY0pi+Hm18qeuF7qnFsHXz6OMO9+K2Ie3nilvJT5MnD5zAru+jqJ826KKXCC?=
 =?us-ascii?Q?G8unl3+UD1Nk+SidWcJ+UkesfSqDWA+MDa5HQw8fFfPN6Cmq7ZWAPYl/6xaD?=
 =?us-ascii?Q?7UrJ7rklVN0lOvtHivELj+yULA91bxf7aCM1yS79GQgU82DyR52ZXO0ghTZo?=
 =?us-ascii?Q?mVl/HKvlMChX9TwFmivDP6bz7trxJpH6ZIvDl4ZeYpKBxpxe1z8x9ntrZHMX?=
 =?us-ascii?Q?8s8f/IuoDYoFFwwZJ7xElTI4IEFgeP0zGMtV1nV1PhMKrEqpYvkfze1u21ov?=
 =?us-ascii?Q?gRk4gpCb9rLjHZhSNIYpkwidJHT1w+Z2HeezQIlunQ0qkUCB9M1vlTP/WnNJ?=
 =?us-ascii?Q?efIareXt1Hn7nTsSaWO27mLmDMpK59Eqogn8nVptRxmw8fcb5hsqEOKH4Fb0?=
 =?us-ascii?Q?KRlEHMwjE9tLI+HImRfk1ADZ2RIP33lLLMhFo9u1usFXRqINKESeieo3FXBw?=
 =?us-ascii?Q?2aLRNqdRf5xo0anfcP93GVHoHpVMqpPsfNiy/riMfbcCjdOi8/AzM8xSROlO?=
 =?us-ascii?Q?6jZE0Wj6eEjjr/Ecj56sD6G52c9vkVgWRDxiEexYpewXDJaow8i5xB/Y7HBr?=
 =?us-ascii?Q?QtbTAPJW9eGXR/jGCPb9HqJO3ZhE1LGHxyhSFjpYLxWVrCKJxH0HxEH9AoZ4?=
 =?us-ascii?Q?cDffHM+WpqldmTag1Mt6xlvuwbmGdtgGjsz1aGNbSHQ8y8OMy0LTykn6cEC9?=
 =?us-ascii?Q?KbU9ECM5UGqre4N21jCz7WnrSeqLWyHADrjFmtBecu8FKLGP0oU9p4EUAIYc?=
 =?us-ascii?Q?pS3uZG4t7eRDvl9WYoMgn5E2Jng2igbPZcjDh6n9WxZMkSSLo3F2hADHSC6m?=
 =?us-ascii?Q?UVTrai81eY3u2Waj05nUKjGaAtwjE/NrQIxk+3gBaPczLwL3JlP/6ZeXq3+s?=
 =?us-ascii?Q?stwGItpClZ6kZyTyj3MpCFs31E1IhdvTkGdkQ2TawerKj3tWeAN59zwkIIvQ?=
 =?us-ascii?Q?jDcZAGO92T4G5NDA7JVkMhYER+i6MWFrlSXnMzBxGaWd1DsE0cnP7TDJhqfG?=
 =?us-ascii?Q?wxUR+Hn4FJ14RTvEPILWPWTHV8wAtUkLjkkyNBRZfY9dxJdlriFwhOPrZwRk?=
 =?us-ascii?Q?TYvMjyq89f4TWaTC7fHpXqf7zHRF4tgqI1ffVOelJfWvjLHk7jh7nhA+XdJQ?=
 =?us-ascii?Q?aUnWPjHLC1oKKuNECMJqy4te4/SyZ881nr1y05AMV3mQXO3AIobJpRNiXqng?=
 =?us-ascii?Q?m0gxG62sWoCSxGGCNjRwd6KmdnT69UTk4fOS7DLTaOnoW4iMC72qs3cBTR4Z?=
 =?us-ascii?Q?9QM4F4ojSAiHlgghR4yup1KMSaizPwDK6j1Ca71K1vwANfjkNmN3tGvR1GuY?=
 =?us-ascii?Q?1+AHItmxBMG4bWgPnCOWVl6/QZUkBbzPCzFhygvqb38kLO56NQ9bQ/Q2081m?=
 =?us-ascii?Q?bvHUefYa4hVrvi/9AQZ5PsNN0vTke9U9gvLukle/WS6957bNixlyYYeDypmm?=
 =?us-ascii?Q?yQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5B26C28E8B333A4CA956A371A7880AAB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?mIjNmRheKnZYCT9dYYonbokWt832tNVzyZzPJ17q2Cqtf/qEwfDIzrtd1ZhP?=
 =?us-ascii?Q?cn4c1qsi4ne0/FyaKCiHcSn7pbPGokP8WkKOjyxwmretd/iLa7gBa++NGyOA?=
 =?us-ascii?Q?h/8vvJMS+BiFNHhpHI4VLlA8Vce6JClzqHg/GX2Qvs5vflZnj3xtXnnUpru7?=
 =?us-ascii?Q?H6he6u9CS+BggCqi0WDJxPaw+RgOyklHlY1rxsbravAAmvLtNAI0rTNY9GdF?=
 =?us-ascii?Q?7IeA+k1ntGo1ErHom2MLJpeo4B3ESFa6N8BzXmk8smDQTCtjIyomgr8xN9Lm?=
 =?us-ascii?Q?J26nAGUbimtLyeNM7T77s+K41JHdxXQOWN/QACqy29X2fh6qY58BiUEIoqQ7?=
 =?us-ascii?Q?r8cE3rg6MnuloLRmHw2OGJtwHyEYDD3f7IbwFkCssHJIycs9bn/IShhtF27j?=
 =?us-ascii?Q?S7T2g3wgnYCcSJM8EktHnJ9BBEehSWWA8AlALo5UndWkMPncoSqHozIFHhNH?=
 =?us-ascii?Q?GaVv81YmDtMSmCYyXcWpVXSvrSiDmv+etwMyh8cP/GRn9VY4pCTaWhGRSLKJ?=
 =?us-ascii?Q?qmVYuty8PLUTygyyChModtwtwC+MiViIAmU9zciFOuf+HqpAfpBW+R+bXeVW?=
 =?us-ascii?Q?942zAoYmlOUfvsNk/6B/3ostkNSeAmcTUdzsKgi58Ufr6lvGjB6lgQgniUnC?=
 =?us-ascii?Q?+b9yRQZ/ERIwAB7whdZ3FXuKOoUmkN/6/Hnv70d84K2eoKKc778zPCe8OKPv?=
 =?us-ascii?Q?gAEPNKiAcNFtYyQh7umsDouZEEcLudk62TnTPp5OvRwGZ6DT0ep88mJXonCs?=
 =?us-ascii?Q?dF/IIaScH/APM544lWVP2OodCXSErllgjyZRi5SUaLnBiwlVU/Kp3eUiFTHa?=
 =?us-ascii?Q?AnBaq3G+YiLSQJjw/zYggcv6yt3zGFmSAcU/KzMLYZDaNTLab33C/JCHV05K?=
 =?us-ascii?Q?ocZmYlr3sk5LqGZyWFsWEK1i9uzx8hj9Ee/L66DQAJSoYkpwoctxPnegdeK8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f0838063-969b-4e86-7aba-08db35df7ce6
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 14:10:19.0986
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TngSNNor6jqTafy1tVwb23GYzw9t7iNpLxHvjSzS317uzdqB0TnGXyFNfm7AjaEtNSpI6cdb6v9Ai+wSZ+aR3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4571
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-05_09,2023-04-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=838 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304050128
X-Proofpoint-ORIG-GUID: MiNRa3z6qkNC6cBPmUmxSPrv7kTu9TNA
X-Proofpoint-GUID: MiNRa3z6qkNC6cBPmUmxSPrv7kTu9TNA
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 5, 2023, at 2:32 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 4/5/23 02:00, Jakub Kicinski wrote:
>> On Tue, 4 Apr 2023 17:44:19 +0200 Hannes Reinecke wrote:
>>>> We're still seeing NULL pointer dereferences here.
>>>> Typically this happens after the remote closes the
>>>> connection early.
>>>>=20
>>>> I guess I cannot rely on sock_hold(sk); from preventing
>>>> someone from doing a "sock->sk =3D NULL;"
>>>>=20
>>>> Would it make more sense for req_submit and req_cancel to
>>>> operate on "struct sock *" rather than "struct socket *" ?
>>>>  =20
>>> Stumbled across that one, too; that's why my initial submission
>>> was sprinkled with 'if (!sock->sk)' statements.
>>> So I think it's a good idea.
>>>=20
>>> But waiting for Jakub to enlighten us.
>> Ah, I'm probably the weakest of the netdev maintainers when it comes
>> to the socket layer :)
>> I thought sock->sk is only cleared if the "user" of the socket closes
>> it. But yes, both sock->sk =3D=3D NULL and sk->sk_socket =3D=3D NULL are
>> entirely possible, and the networking stack usually operates on
>> struct sock. Why exactly those two are separate beings is one of
>> the mysteries of Linux networking which causes guaranteed confusion
>> to all the newcomers. I wish I knew the details so I could at least
>> document it :S
>=20
> Bummer. I had high hopes on you being able to shed some light on this.
>=20
> So, Chuck: maybe we should be looking at switching over to 'struct sock' =
for the internal stuff. If we don't have to do a 'fput()' somewhere we shou=
ld be good...

I've made handshake_req_cancel() take a "struct sock *" as
a starting point. I'll send out something for you to try
later today.


--
Chuck Lever


