Return-Path: <netdev+bounces-3935-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F734709A11
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21B4A1C2129F
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05710AD46;
	Fri, 19 May 2023 14:40:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D4D5679
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:40:27 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713D1E1;
	Fri, 19 May 2023 07:40:25 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JENrdi014363;
	Fri, 19 May 2023 14:40:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=+yF9F2rgo/ApxMpkibjMCYj7DDE4Iobh68HmxcnFXv4=;
 b=0nDz6Mcia6ZMUIH3Oe5pULA9DF4jfV5tXhpPaCH9qzm47lLc/Hkka30hs2P/iS0H6C4q
 76Jkau/Guo62VxANoJ6ssxE+LA81tCbUyeHppVNFP3JIw163+5CaSzY37N0EKaAqGgRr
 AnnrW38xFCIOnxzFBitS+2uICmFjj7mOBp2vg3Us9O+vIG1Itd7/8AP+CY1DrUxEE3X/
 47mVi4bet5gxhrk3ZDo2ZDZ5Jj0l9kXvmag89EIKnapm62Ua22X9JHJGlL/Ion4mp3ew
 ZZKY3kx8h6VZ8pr1ELg0i0TYK1RapGLWlXD95jhn9qT1GYK4pu/HXS58KHnRmUXsFlN9 3g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qmxwpmxm3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 14:40:09 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JCuYlZ025047;
	Fri, 19 May 2023 14:40:08 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj1085sm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 14:40:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBN0KJeGiK7HY6nGX/Mdse5VYA5G0cWQAiav3c4hVO6YpW650cH6OaWK4N4OvZP6AXZhk+yop8xh3tKEACZ49bCGZbKnfsRNJ1aPkeQLBPT6a1p5k/L5Ym3alhjYnaItQSNamhs0Ikz9v5qmOL0XoXDwJbwEnLF15VrtZ4+aBhbvSFz0KgYkpv1HHlEgdUjmayw79Vtnl6vRUcxdvpQOQuKEIN64cNXpoT9iN5tawv75b/30fvpGgnfzIogF5WIYxyjLdGaaso6WukAKqkvKG+rmTvFpFSwUHDYi87HDkmR5cZQ1fwarE0AOBFCsEp6CAny7AH/IEG+mYAnE0U35dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+yF9F2rgo/ApxMpkibjMCYj7DDE4Iobh68HmxcnFXv4=;
 b=OZQ3YFgzStCzbxAAF4pvg4t0YuKFMi9Zw62MnEPPzbiXk/BHYI17v5F2wy9f37jHtSYQw6fGzAYd4RSnu87T1LSMwQFqcrSno9c9m5OsHHCCnn9TaEpnmhlveVNq5C+b/GKwnaOv/1g35nqNIZhpHVZcsDhIJV+lEXZ4vy4l5d6CgSVFXh462K4dcpEuuWkXnyQrMB232n404xmxpZUYkhHO0+72dF/l8s3XuP2c9riuKYoVWEscbh+w+/esHlogG/cgF6j0wiSOWPRr4J/fKq8nsm2pSapshXIVielSM4cvXGgYpXkIzx8tfZ++5RPwx0kYTWSQI0Cs5QdM0t+Wxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+yF9F2rgo/ApxMpkibjMCYj7DDE4Iobh68HmxcnFXv4=;
 b=bhzfCHOsmcnp51u1v2R5rPmt0FtnRcDJji3IIuvEWO2d6lH36gTGCVJeiP+6fTJM0cAGVJLuVBJS/msmP54NPcRPt4SCTSNcH5Q1KQVquF9XMHC8sICnylHQ9nPgtSWmEqs2dAT7PV3dlwGrA7kN+a80V53oIaZMtxPR7YSXDN0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB6079.namprd10.prod.outlook.com (2603:10b6:8:c9::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.33; Fri, 19 May
 2023 14:40:05 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:40:05 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
CC: Dan Carpenter <dan.carpenter@linaro.org>,
        Linux-Next Mailing List
	<linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        "lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
        Al Viro
	<viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Paul E.
 McKenney" <paulmck@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Anders Roxell <anders.roxell@linaro.org>,
        Jakub Kacinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: next: qemu-arm64: kernel BUG at fs/inode.c:1763!
Thread-Topic: next: qemu-arm64: kernel BUG at fs/inode.c:1763!
Thread-Index: AQHZiMDxoePRYBOvEUaiPCVw5Sc2Hq9ekUsAgAKF1YCAAJbrAA==
Date: Fri, 19 May 2023 14:40:05 +0000
Message-ID: <3C4B5AC6-275E-4176-BD1A-AB1FBD319C5B@oracle.com>
References: 
 <CA+G9fYszs5wPp+TWJeVZsdRjnBTXTa8i3YY3qV9SHbB1+R2+4Q@mail.gmail.com>
 <20680bb5-71c0-4945-a058-05f43bbd03f4@kili.mountain>
 <CA+G9fYvY8HZ=F0hQueeX2x2RvP-fJgrDF_7y-Q_yhpVE_8Y9Xg@mail.gmail.com>
In-Reply-To: 
 <CA+G9fYvY8HZ=F0hQueeX2x2RvP-fJgrDF_7y-Q_yhpVE_8Y9Xg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB6079:EE_
x-ms-office365-filtering-correlation-id: f1c21e58-f496-4a8a-dd0b-08db5876efbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zgZwqXnR1PVq2sz6y/iub0oIwncSDvxKXJ4LbFaJosaOWj2Tz7GPLbKqO6RYklI0sNiFS0EmBL+BpAmpLNhTVa/YtvluPOTWCSGulA3jYfiCZCKJ3TbSlm00SbtIFsSfVdUpEARvN8bOFnzr44MUvt2mDoaQ5AK5c8RN2Mc39bLgGAHHP9QBpWlZtlJsKcvxZLZD3g9f+H4BA9HAPSNrTyG1ZKqeTGQF/kdFwq2aREQ1UK9OMjlx0vLrnYrABbgOFQsNGRsp0hfi7fdrsu+BxJF2r/nM1yjvziUYxR0fypgaHgVVrOMJC4DN6M8C+UhbejmMkGKgnjmtyttxHqz+DR7mp0nfIJoJgPcyWmGA2GUBMk+xE9VStzLVny+bbdLb6dcHOtOoIQAnLz3Ro2hkWLqjeSMuPzxlIdbZG1nAZuRJ7C+RZx/d4vg3Apnn1Zrmu52fK2qqc7TDkb0oF+mPOvS4uI8LDTI/uxGsEm7/m+hw5gmYQWIBU5zi/TQYetAJ6GxkdGaQS2dCW6pvCRZ5ePiWAOHnDwr9N11d0mjDoUuFCVPlxuFbTNLQQcMLnVeihSSwFY7NOa6lS0VU/BDfFxNxPW0RIZpoYHShrOPRcOyhdIlvJ8r9x0PH72wbg1stEOD7gyINn4Bnxz8Qg7z24+O443oeet6rKxEuKdFNTE4=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(136003)(366004)(451199021)(478600001)(66476007)(76116006)(53546011)(6506007)(91956017)(66446008)(6512007)(64756008)(66556008)(66946007)(4326008)(54906003)(316002)(6916009)(45080400002)(6486002)(966005)(84970400001)(71200400001)(5660300002)(8936002)(186003)(41300700001)(7416002)(8676002)(2906002)(30864003)(83380400001)(2616005)(38100700002)(33656002)(38070700005)(36756003)(122000001)(26005)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?ATlZ359a537cd9g5RnaYntbdgnvJN+TPgPFmdcUXEf7dkFiHZSZJIykBMPif?=
 =?us-ascii?Q?MtlEwGJn479ITP6VCXuH7aYkKQWcZXpgQDMv/AJvCyXoUqV1hr6iIBRy8nnA?=
 =?us-ascii?Q?wevkAN4IQYenA2v7dsozGxzo9/2xg2wSGxcHXEWeSKEpIbJrwqnadiXF93tV?=
 =?us-ascii?Q?f9/oWPBrC1Y2sTK+rdNiZbDHO5AkAh1TU5W/udz+jS2wJP+YP9rWse5ZUv2R?=
 =?us-ascii?Q?1/o8XFYgnwBjCVlb89DVYSgtQ59e0176D9ufcYfQcWps/E3Wjp57+vplNxDT?=
 =?us-ascii?Q?xMOr7S4HUixf7E9dBhUudmTaK1OsH4fyNNcvXAJ/TVOwjVLnlJTTv+aAfMCq?=
 =?us-ascii?Q?CW8B6Xrs62XushZHKmNB5xgAxS7CY1Z4HwEpU12CtqMaPRV/Mg8Wu9YvIecR?=
 =?us-ascii?Q?eSY9GCjRh6GuwVyUkJgvA0weUCgSOz8X8QlRRuEeabM50PmovvG5xsOTbabH?=
 =?us-ascii?Q?IqGnieBRhGx81U3sZjB7vwJNvn5jfC9IrhfLkTtAOy2EuARKRZ4gB0R5+DJC?=
 =?us-ascii?Q?RNXFFi7WCPEvOzLmwlVUO47ArADY5rbRutrT+1tRGaVijjZpYr/8xHBlFdt9?=
 =?us-ascii?Q?NiwFUNuiF6O8yjfab7N22T92uXUnHH33igC4WP+TEnVQcDdlq1Jxu/KNnkMt?=
 =?us-ascii?Q?xlqI3tocLD0AjI9a1EWH+RFYZ5g59yB8gbHaU3OLItOxH3bOOOy5B3i78A/C?=
 =?us-ascii?Q?y7VDsx0w0CVqNpNQDoI7yiHEYgSX+Dd5QH3MGKF0Sg5kJD38b7lBYpVoLQle?=
 =?us-ascii?Q?D4+Vk9XbgZ+dOgv3EnZn0Wm2YMrAGnT2NKqCqr3I7NxjgD4KeEHX4IWWYMYz?=
 =?us-ascii?Q?BNZdMfcAyCYGT6ywuIhmo4xhK9kCiSVbBmKghaw+RGFWvV7sd3ckWM6C/bmS?=
 =?us-ascii?Q?vOp2/hDaRKpXYffrpYUynE5IKVP1X1I5P5lUp3g7hAMYuMlLr8sHXO7d9/MQ?=
 =?us-ascii?Q?OHeI4sYSee+9rkT7gcrtZxfUllelCeuf9xoEvG5TxlQijJF+GA5+QwcUACIE?=
 =?us-ascii?Q?WgdKW7d1y+nj4LAualT/VaaVtzf+VbrxmljxmZdKZesdZpM2mmGQ5n2MSlSY?=
 =?us-ascii?Q?5660BYJa478hDTgk3uR30qMEZNFIeQ5L0Nb1w2AdzlT7VYOFZyTzNypvY3cV?=
 =?us-ascii?Q?Z+99QuYxb5gd3bIPugeiQZDPN08J8+wDMMAHXTZH8ACQ/nUaVz/jpN5DaarK?=
 =?us-ascii?Q?xUvv/QFLGnAiIHicWznOabk3uNVm+OdwQqUC1yBPXeYIbYrdD0WnkRxkOQ75?=
 =?us-ascii?Q?DfHJZi/0Feb1jbrXBVwXaLTlEaNnGcYFqHpnw8LobmTIj1jeOLP6g7AyB7lO?=
 =?us-ascii?Q?cuYfdy6XNV4loIHGW38m+XJP+zdqjlDf++q2QfLG0NN2CP3CSlDj4l4dDSsN?=
 =?us-ascii?Q?2z/3SBXkc5/p+VDv7RMUQ166wp0oGX1LGO76Js75nODaQ157Q6p0b5E9xz3v?=
 =?us-ascii?Q?1j2w++FpDDAyFSSp1ZqZ/ZfUBnCkBBFVmz4P07ahtYv28ZXJafCU9tTr2sWq?=
 =?us-ascii?Q?w46qFaildJwJA1DgswziwJI2FD4yLflEHxsB4owElfPJxqpx6kCizaAUj0x7?=
 =?us-ascii?Q?NlzCEDsZZ1T8mHFDT0PchFWhUBVXpyZP5MGh3R+Nh2gDL8Ys5fGtQwWAoZGc?=
 =?us-ascii?Q?lw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FE9502F4049B0545820BE46D615941AA@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?GA8Uyq5GIKPkbrTYM6/xgN0jETH2AAq8+9YL4l2Aqu0PhozPI8wag766F5C5?=
 =?us-ascii?Q?w7C7WfqnGXibCgRKq7jq7bZARKp9EMKifTSoy2mPxp/zEC+qMpQFpCsUPqom?=
 =?us-ascii?Q?yPMvyPjN95Xq8/Wtan38bvYW1FHDTdebCP0EC9SiAjurzRuv6NHzALaOi710?=
 =?us-ascii?Q?WfPC+BzF7aAlrjaZ9RufmLjL6nsZ3MlX0Mmf6hEJt6T3O1QcW6WUsQLNjwEF?=
 =?us-ascii?Q?53i7TyPEpSPM9aCxZsm4MxcKkptheaP+zoi0IOc6TCm8aUoTKnsKKacQy8mf?=
 =?us-ascii?Q?gF4T2kFIbNg4sBkFHjFmC5hL2k1Jv6LQ98vJOnyKkt5jqm9LMXWYda4QR9U6?=
 =?us-ascii?Q?eaYJ4ghisbjbd68kpH4dYSOqbpvyrNHaMI0I/erlgElegtzyb2CDK2N6Jd7a?=
 =?us-ascii?Q?sta+GURYsaVlAX93eIq6YLUmpX7PT2qWun9hxK8df8BmpuWtEmYD3dLPhIet?=
 =?us-ascii?Q?MvfH1QY/I6nyjhqJu3r+tBrMVpaMyVfnMBE6ET+SlTdIV0DLXaJDy+DkXJe6?=
 =?us-ascii?Q?mDmW3uRqHxJ+3Tdj7f+pp6mhtTS0FwPAGm4oYwmXU8SJKZTcUS1xkq3dJxme?=
 =?us-ascii?Q?HVq7T0j30Gv3n999roN3eO/4Sg6qHXPyPniy+4kNmAfSJcRC98BcEmQGWwVu?=
 =?us-ascii?Q?OK73FgWoEyKVIffsS/iN6h84NeaP9ROLje1r4JoGVq4Knd7cqRgw+KwvyAN6?=
 =?us-ascii?Q?6UYOk+WvbWSpuDxlVwBUek3HdBPKsuDYKycayx1VqTQDzC13wa1O2GKjXvt+?=
 =?us-ascii?Q?HYKXI/hw8yaBsP0NvoxlI6Yd3bny5rgj4Y/2BG5Z4cZ0wAQXLHwHmNsMCet8?=
 =?us-ascii?Q?j91XojBsINI88ch8j8+cmVk4n1z8hcaF/RNcv/Zt/ZbcBnY8gKJCv+ujBOS/?=
 =?us-ascii?Q?oOO/ntfLz2K0Orn8GPGxR3qQYXQFO49Q8U7blM3iS/jFtr51XhviTJuw5Kn4?=
 =?us-ascii?Q?IJ03qTW9/99kr7orIXOTvTEn0wpcUuQy8FcC/mmk5PTpAeLfDhO/B4kXHYZ3?=
 =?us-ascii?Q?pxSV?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1c21e58-f496-4a8a-dd0b-08db5876efbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 14:40:05.4199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTeVh72qpeNtulhDpl+muBKxms9YmsQn4R7Vf66JMCsYwD0FuhSSVJDXQkjSRlIBFla5of7ZZGp8zP4c9dX5TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6079
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190124
X-Proofpoint-GUID: QAUUAXgeNlI21MeixnSZuHu2JleASZ5j
X-Proofpoint-ORIG-GUID: QAUUAXgeNlI21MeixnSZuHu2JleASZ5j
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 19, 2023, at 1:39 AM, Naresh Kamboju <naresh.kamboju@linaro.org> w=
rote:
>=20
> On Wed, 17 May 2023 at 20:38, Dan Carpenter <dan.carpenter@linaro.org> wr=
ote:
>>=20
>> The fs/inode.c:1763 bug is more stuff from net/handshake testing, so
>> lets add Chuck to the CC list.
>=20
> Anders bisected this problem and found the first bad commit,
>=20
> ---
> commit f921bd41001ccff2249f5f443f2917f7ef937daf
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Thu May 11 11:49:17 2023 -0400
>=20
>    net/handshake: Unpin sock->file if a handshake is cancelled
>=20
>    If user space never calls DONE, sock->file's reference count remains
>    elevated. Enable sock->file to be freed eventually in this case.
>=20
>    Reported-by: Jakub Kacinski <kuba@kernel.org>
>    Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for
> handling handshake requests")
>    Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
>=20
> net/handshake/handshake.h | 1 +
> net/handshake/request.c   | 4 ++++
> 2 files changed, 5 insertions(+)

I don't offhand see how test 9 might leave sock->file NULL.

I don't have access to aarch64 systems for a boot-time test,
and I'm not able to reproduce with kunit.py:

[cel@morisot morisot]$ cat .git/HEAD
ref: refs/heads/net-next
[cel@morisot morisot]$ tools/testing/kunit/kunit.py run --arch=3Darm64 --cr=
oss_compile=3Daarch64-linux-gnu- --kunitconfig ./net/handshake/.kunitconfig
[10:30:44] Configuring KUnit Kernel ...
[10:30:44] Building KUnit Kernel ...
Populating config with:
$ make ARCH=3Darm64 O=3D.kunit olddefconfig CROSS_COMPILE=3Daarch64-linux-g=
nu-
Building with:
$ make ARCH=3Darm64 O=3D.kunit --jobs=3D12 CROSS_COMPILE=3Daarch64-linux-gn=
u-
[10:30:49] Starting KUnit Kernel (1/1)...
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Running tests with:
$ qemu-system-aarch64 -nodefaults -m 1024 -kernel .kunit/arch/arm64/boot/Im=
age.gz -append 'kunit.enable=3D1 console=3DttyAMA0 kunit_shutdown=3Dreboot'=
 -no-reboot -nographic -serial stdio -machine virt -cpu cortex-a57
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Handshake API tests (11 sub=
tests) =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D req_alloc=
 API fuzzing  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[10:30:49] [PASSED] handshake_req_alloc NULL proto
[10:30:49] [PASSED] handshake_req_alloc CLASS_NONE
[10:30:49] [PASSED] handshake_req_alloc CLASS_MAX
[10:30:49] [PASSED] handshake_req_alloc no callbacks
[10:30:49] [PASSED] handshake_req_alloc no done callback
[10:30:49] [PASSED] handshake_req_alloc excessive privsize
[10:30:49] [PASSED] handshake_req_alloc all good
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D [PASSED] req_alloc AP=
I fuzzing =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[10:30:49] [PASSED] req_submit NULL req arg
[10:30:49] [PASSED] req_submit NULL sock arg
[10:30:49] [PASSED] req_submit NULL sock->file
[10:30:49] [PASSED] req_lookup works
[10:30:49] [PASSED] req_submit max pending
[10:30:49] [PASSED] req_submit multiple
[10:30:49] [PASSED] req_cancel before accept
[10:30:49] [PASSED] req_cancel after accept
[10:30:49] [PASSED] req_cancel after done
[10:30:49] [PASSED] req_destroy works
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D [PASSED] Handshake=
 API tests =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[10:30:49] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[10:30:49] Testing complete. Ran 17 tests: passed: 17
[10:30:49] Elapsed time: 4.956s total, 0.002s configuring, 4.439s building,=
 0.478s running

Any advice would be appreciated!


>> regards,
>> dan carpenter
>>=20
>> On Wed, May 17, 2023 at 06:39:57PM +0530, Naresh Kamboju wrote:
>>> Following kernel crash noticed while booting qemu-arm64 kunit builds on
>>> Linux next version 6.4.0-rc2-next-20230517.
>>>=20
>>> WARNING: CPU: 1 PID: 1436 at mm/page_alloc.c:4781 __alloc_pages
>>> kernel BUG at fs/inode.c:1763!
>>> WARNING: CPU: 0 PID: 0 at kernel/context_tracking.c:128
>>> ct_kernel_exit.constprop.0+0xe0/0xe8
>>>=20
>>> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>>>=20
>>> Detailed Crash log:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> <4>[  800.148388] ------------[ cut here ]------------
>>> <4>[  800.150072] WARNING: CPU: 1 PID: 1436 at mm/page_alloc.c:4781
>>> __alloc_pages+0x998/0x13e8
>>> <4>[  800.151978] Modules linked in:
>>> <4>[  800.153337] CPU: 1 PID: 1436 Comm: kunit_try_catch Tainted: G
>>> B            N 6.4.0-rc2-next-20230517 #1
>>> <4>[  800.154662] Hardware name: linux,dummy-virt (DT)
>>> <4>[  800.155921] pstate: 22400005 (nzCv daif +PAN -UAO +TCO -DIT
>>> -SSBS BTYPE=3D--)
>>> <4>[  800.157079] pc : __alloc_pages+0x998/0x13e8
>>> <4>[  800.158148] lr : __kmalloc_large_node+0xc0/0x1b8
>>> <4>[  800.159238] sp : ffff80000b5e7aa0
>>> <4>[  800.160154] x29: ffff80000b5e7aa0 x28: 0000000000000000 x27:
>>> 0000000000000000
>>> <4>[  800.161762] x26: ffff0000c4509f00 x25: ffff800008087a98 x24:
>>> ffffd0168ffa8460
>>> <4>[  800.163283] x23: 1ffff000016bcf74 x22: 0000000000040dc0 x21:
>>> 0000000000000000
>>> <4>[  800.164813] x20: 0000000000000015 x19: 0000000000000000 x18:
>>> 000000000000000b
>>> <4>[  800.166307] x17: 00000000bd2c963e x16: 00000000a2b18575 x15:
>>> 0000000033b8949b
>>> <4>[  800.167831] x14: 000000006d0ad0a4 x13: 00000000e32f85f5 x12:
>>> ffff7000016bcfa1
>>> <4>[  800.169363] x11: 1ffff000016bcfa0 x10: ffff7000016bcfa0 x9 :
>>> 000000000000f204
>>> <4>[  800.170928] x8 : 00000000f2000000 x7 : 00000000f2f2f2f2 x6 :
>>> 00000000f3f3f3f3
>>> <4>[  800.172467] x5 : 0000000000040dc0 x4 : ffff0000c614e900 x3 :
>>> 0000000000000000
>>> <4>[  800.173976] x2 : 0000000000000000 x1 : 0000000000000001 x0 :
>>> ffffd01696633000
>>> <4>[  800.175603] Call trace:
>>> <4>[  800.176314]  __alloc_pages+0x998/0x13e8
>>> <4>[  800.177355]  __kmalloc_large_node+0xc0/0x1b8
>>> <4>[  800.178401]  __kmalloc+0x158/0x1c0
>>> <4>[  800.179350]  handshake_req_alloc+0x70/0xb8
>>> <4>[  800.180510]  handshake_req_alloc_case+0xa4/0x188
>>> <4>[  800.181598]  kunit_try_run_case+0x88/0x120
>>> <4>[  800.182614]  kunit_generic_run_threadfn_adapter+0x38/0x60
>>> <4>[  800.183809]  kthread+0x194/0x1b0
>>> <4>[  800.184813]  ret_from_fork+0x10/0x20
>>> <4>[  800.185873] ---[ end trace 0000000000000000 ]---
>>> <6>[  800.202972]         ok 6 handshake_req_alloc excessive privsize
>>> <6>[  800.217425]         ok 7 handshake_req_alloc all good
>>> <6>[  800.219182]     # req_alloc API fuzzing: pass:7 fail:0 skip:0 tot=
al:7
>>> <6>[  800.222082]     ok 1 req_alloc API fuzzing
>>> <6>[  800.243148]     ok 2 req_submit NULL req arg
>>> <6>[  800.260195]     ok 3 req_submit NULL sock arg
>>> <6>[  800.274397]     ok 4 req_submit NULL sock->file
>>> <6>[  800.294631]     ok 5 req_lookup works
>>> <6>[  800.310289]     ok 6 req_submit max pending
>>> <6>[  800.326669]     ok 7 req_submit multiple
>>> <6>[  800.342645]     ok 8 req_cancel before accept
>>> <4>[  800.359161] ------------[ cut here ]------------
>>> <2>[  800.360659] kernel BUG at fs/inode.c:1763!
>>> <0>[  800.362464] Internal error: Oops - BUG: 00000000f2000800 [#1] PRE=
EMPT SMP
>>> <4>[  800.364079] Modules linked in:
>>> <4>[  800.364978] CPU: 0 PID: 9 Comm: kworker/0:1 Tainted: G    B   W
>>>      N 6.4.0-rc2-next-20230517 #1
>>> <4>[  800.366607] Hardware name: linux,dummy-virt (DT)
>>> <4>[  800.368282] Workqueue: events delayed_fput
>>> <4>[  800.369511] pstate: 62400005 (nZCv daif +PAN -UAO +TCO -DIT
>>> -SSBS BTYPE=3D--)
>>> <4>[  800.370861] pc : iput+0x2c4/0x328
>>> <4>[  800.371839] lr : iput+0x3c/0x328
>>> <4>[  800.372882] sp : ffff800008107b50
>>> <6>[  800.375744]     ok 9 req_cancel after accept
>>> <4>[  800.376704] x29: ffff800008107b50 x28: ffffd016924f7400 x27:
>>> ffff0000c08d4da0
>>> <4>[  800.379288] x26: ffff0000c042f918 x25: ffff0000cc273918 x24:
>>> ffff0000cc273900
>>> <4>[  800.381160] x23: 0000000000000000 x22: ffff0000c042f9b8 x21:
>>> ffffd016924f7b40
>>> <4>[  800.383408] x20: ffff0000c042f880 x19: ffff0000c042f880 x18:
>>> 000000000000000b
>>> <4>[  800.385535] x17: ffffd0168fb6f094 x16: ffffd0168fb6ee10 x15:
>>> ffffd0168fb6ebd4
>>> <4>[  800.387985] x14: ffffd0168f7d5de8 x13: ffffd0168f617f98 x12:
>>> ffff700001020f53
>>> <4>[  800.389672] x11: 1ffff00001020f52 x10: ffff700001020f52 x9 :
>>> ffffd0168fb67384
>>> <4>[  800.392442] x8 : ffff800008107a98 x7 : 0000000000000000 x6 :
>>> 0000000000000008
>>> <4>[  800.395053] x5 : ffff800008107a58 x4 : 0000000000000001 x3 :
>>> dfff800000000000
>>> <4>[  800.397652] x2 : 0000000000000007 x1 : ffff0000c042f918 x0 :
>>> 0000000000000060
>>> <4>[  800.400110] Call trace:
>>> <4>[  800.401352]  iput+0x2c4/0x328
>>> <4>[  800.402741]  dentry_unlink_inode+0x12c/0x240
>>> <4>[  800.404519]  __dentry_kill+0x16c/0x2b0
>>> <4>[  800.406047]  dput+0x24c/0x438
>>> <4>[  800.407331]  __fput+0x140/0x3b0
>>> <4>[  800.409152]  delayed_fput+0x64/0x80
>>> <4>[  800.410708]  process_one_work+0x3cc/0x7d0
>>> <4>[  800.413032]  worker_thread+0xa4/0x6a0
>>> <4>[  800.415041]  kthread+0x194/0x1b0
>>> <6>[  800.416283]     ok 10 req_cancel after done
>>> <4>[  800.416205]  ret_from_fork+0x10/0x20
>>> <0>[  800.419090] Code: 17ffffc4 97fffb54 17ffffd4 d65f03c0 (d4210000)
>>> <4>[  800.421577] ---[ end trace 0000000000000000 ]---
>>> <6>[  800.424335] note: kworker/0:1[9] exited with irqs disabled
>>> <6>[  800.428252] note: kworker/0:1[9] exited with preempt_count 1
>>> <4>[  800.435635] ------------[ cut here ]------------
>>> <4>[  800.436529] WARNING: CPU: 0 PID: 0 at
>>> kernel/context_tracking.c:128 ct_kernel_exit.constprop.0+0xe0/0xe8
>>> <4>[  800.439070] Modules linked in:
>>> <4>[  800.440326] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G    B D W
>>>    N 6.4.0-rc2-next-20230517 #1
>>> <4>[  800.442196] Hardware name: linux,dummy-virt (DT)
>>> <4>[  800.443408] pstate: 224003c5 (nzCv DAIF +PAN -UAO +TCO -DIT
>>> -SSBS BTYPE=3D--)
>>> <4>[  800.445031] pc : ct_kernel_exit.constprop.0+0xe0/0xe8
>>> <4>[  800.446629] lr : ct_kernel_exit.constprop.0+0x20/0xe8
>>> <4>[  800.448263] sp : ffffd01694ed7cd0
>>> <4>[  800.449375] x29: ffffd01694ed7cd0 x28: 00000000437e90ac x27:
>>> 0000000000000000
>>> <4>[  800.451354] x26: ffffd01694ef1e40 x25: 0000000000000000 x24:
>>> 0000000000000000
>>> <4>[  800.453397] x23: ffffd01694ee2ba0 x22: 1ffffa02d29dafb4 x21:
>>> 0000000000000000
>>> <4>[  800.455573] x20: ffffd01692f29c20 x19: ffff0000da667c20 x18:
>>> 000000000000000b
>>> <4>[  800.457649] x17: 000000000055a8d0 x16: 000000006cbc159c x15:
>>> ffffd0168fb6865c
>>> <4>[  800.459662] x14: ffffd0168fb680ec x13: ffffd0168fb3b03c x12:
>>> ffff7a02d29daf81
>>> <4>[  800.461787] x11: 1ffffa02d29daf80 x10: ffff7a02d29daf80 x9 :
>>> dfff800000000000
>>> <4>[  800.463827] x8 : ffffd01694ed7c08 x7 : 0000000000000000 x6 :
>>> 0000000000000008
>>> <4>[  800.465864] x5 : ffffd01694ed7bc8 x4 : 0000000000000001 x3 :
>>> dfff800000000000
>>> <4>[  800.467860] x2 : 4000000000000002 x1 : 4000000000000000 x0 :
>>> ffff2fea4773e000
>>> <4>[  800.469981] Call trace:
>>> <4>[  800.470946]  ct_kernel_exit.constprop.0+0xe0/0xe8
>>> <4>[  800.472535]  ct_idle_enter+0x10/0x20
>>> <4>[  800.473923]  default_idle_call+0x58/0x90
>>> <4>[  800.475213]  do_idle+0x304/0x388
>>> <4>[  800.476492]  cpu_startup_entry+0x2c/0x40
>>> <4>[  800.477885]  rest_init+0x120/0x128
>>> <4>[  800.478830]  arch_call_rest_init+0x1c/0x28
>>> <4>[  800.479961]  start_kernel+0x2f8/0x3c0
>>> <4>[  800.482015]  __primary_switched+0xc0/0xd0
>>> <4>[  800.483086] ---[ end trace 0000000000000000 ]---
>>> <6>[  800.487780]     ok 11 req_destroy works
>>> <6>[  800.488283] # Handshake API tests: pass:11 fail:0 skip:0 total:11
>>> <6>[  800.491161] # Totals: pass:17 fail:0 skip:0 total:17
>>> <6>[  800.495059] ok 75 Handshake API tests
>>> <6>[  800.514129] uart-pl011 9000000.pl011: no DMA platform data
>>>=20
>>> links,
>>> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230=
517/testrun/17029810/suite/boot/test/gcc-12-lkftconfig-kunit/log
>>> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230=
517/testrun/17029810/suite/boot/test/gcc-12-lkftconfig-kunit/history/
>>> - https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230=
517/testrun/17029810/suite/boot/tests/
>>>=20
>>> Steps to reproduce:
>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>> # To install tuxrun on your system globally:
>>> # sudo pip3 install -U tuxrun=3D=3D0.42.0
>>> #
>>> # See https://tuxrun.org/ for complete documentation.
>>>=20
>>> tuxrun   \
>>> --runtime podman   \
>>> --device qemu-arm64   \
>>> --kernel https://storage.tuxsuite.com/public/linaro/lkft/builds/2PtylM1=
zfMZo4vZUtwFtBJhJRvx/Image.gz
>>>  \
>>> --modules https://storage.tuxsuite.com/public/linaro/lkft/builds/2PtylM=
1zfMZo4vZUtwFtBJhJRvx/modules.tar.xz
>>>  \
>>> --rootfs https://storage.tuxsuite.com/public/linaro/lkft/oebuilds/2PeQh=
lPkvTmtoQVO1F0CQ7lAsm5/images/juno/lkft-tux-image-juno-20230511150149.rootf=
s.ext4.gz
>>>  \
>>> --parameters SKIPFILE=3Dskipfile-lkft.yaml   \
>>> --image docker.io/lavasoftware/lava-dispatcher:2023.01.0020.gc1598238f =
  \
>>> --tests kunit   \
>>> --timeouts boot=3D30
>>>=20
>>> --
>>> Linaro LKFT
>>> https://lkft.linaro.org
>=20
> - Naresh

--
Chuck Lever



