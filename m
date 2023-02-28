Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A89666A5CB1
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 17:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbjB1QB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 11:01:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjB1QB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 11:01:58 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F315FFD
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 08:01:57 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SEOSr7018575;
        Tue, 28 Feb 2023 16:01:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=9fkvLD5NPoslI/UC+r6bNEe8Ujj0Hn5PN4DT12trAyM=;
 b=oiWRz9O+4Ib5kVaR7m+ayGyLLLPVSQdFTh/ZHdwoc5t7ZrcUaPxQXqggC7j273BixpMc
 mugL+ReW2HXKANFGvBuJhBi+8weZRrlEzb3twVba8Dxehq4lgjBqTE7++nPeD89AGATp
 9DoIkKF9jtEwtFHoALaKvgdbDpK5aczjBHTJocNaUlxlgyrvtgDqQT8QEUIRPSrBzW5l
 n4eIwo4aY4S/RC16ug6mZAbwbuqG5sxCshYphASlFs6X2Qe1fzJgUGCAl7PzEhy63uI/
 u+vIa33jiMJjM4V8FLshru0i/L7paLZHwSnvf+03zw250QocucvuBVINeX/NCGSeofNO fA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7eh5u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 16:01:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31SFZh8h029351;
        Tue, 28 Feb 2023 16:01:34 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sd21qj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 16:01:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lar6p+7izD9Bw1bi00pELtfSDXygMxxcFsh9bbKNfUrm3MD/ZJ7zXT5qluUODkhNKvIknXriBI+DNKuzgFK9eL8/eEtq2ZQF07YpIxKGIUwitS5VS4D1OJUrNm4ShtKtPAfomp7UudXQ3WkpsCk5/t23hmhCd5lm1b8PI9SqP+mpAw5vJEyNSsYoULzRZZvQuuFvtjjMUmzPtPZVpRpi1BAE5QL8bd23LzMla0TsJctHKZPrDUdo8ocIGDIQlBrOAkrk5G7Wh17Vh/OxpxtsUwsgJ+QvtYMFSahWeOvZOz/VlwUDSlYh4+5Y/Usvt+qEU1igUcCBjiH5SDCfmKlTHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9fkvLD5NPoslI/UC+r6bNEe8Ujj0Hn5PN4DT12trAyM=;
 b=Uikf5854jYty58Q2+2umyhI8a/3hT/d3EMlcTuphferonV4mhgcg8ckxXuNJDXa8UvSqfE3vvJg1Wi685QS7Izs7FFdZzoMfruoqOccHw1VNasEf3SHUEBWo/zMO6xzuPyZvjV4GLn1qhffo3YTNwvjyS5Q4ctxywdJ7y69DhgQ2rdzReNgC8yABgdP5egvSLAtXliCdfC8meEelTBj8aTVyiHrDiRmLlOJmWrq2FORIl+1E0mASr2rBosS3oHWRDqMD08I/v5+jnuEEwrRkYDvYmab6/vTLYCQDdD8TugfrmfXZ9YN7shwufekIw8YDa8ro3dW+FkdILekOzV38Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9fkvLD5NPoslI/UC+r6bNEe8Ujj0Hn5PN4DT12trAyM=;
 b=FArJsS7xyoBABQ7HiMZ1Sqe2YmXJeHIfpcIPpblW2/Mx+WuEtZBVgxz3XU39MeWIMlO3BYE8ww+p3wxSP6YpDRWJAIQIBXKVkeCUhvhRTeCQujqHWNDFrag2wXp2gAnAf9cs/WLiZB6h1D+o59sPJNrge6UEb/XCAW6LrK2IW6M=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CY5PR10MB6168.namprd10.prod.outlook.com (2603:10b6:930:30::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Tue, 28 Feb
 2023 16:01:32 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6156.017; Tue, 28 Feb 2023
 16:01:32 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chuck Lever <cel@kernel.org>, "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v5 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZSITpzXcU72XpWUqa2tRUnzVdcK7iiYuAgABdpYCAAARFAIAABu2AgAAcTACAAA3tAIAA1mqAgAB95ACAABZMAIAAA5mA
Date:   Tue, 28 Feb 2023 16:01:32 +0000
Message-ID: <8344D4BC-BA32-4D63-847C-D03C017E7955@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726635921.5428.7879951165266317921.stgit@91.116.238.104.host.secureserver.net>
 <17a96448-b458-6c92-3d8b-c82f2fb399ed@suse.de>
 <1B595556-0236-49F3-A8B0-ECF2332450D4@oracle.com>
 <006c4e44-572b-a6f8-9af0-5f568913e7a0@suse.de>
 <90C7DF9C-6860-4317-8D01-C60C718C8257@oracle.com>
 <71affa5a-d6fa-d76b-10a1-882a9107a3b4@suse.de>
 <69541D93-7693-4631-9263-DE77D289AA71@oracle.com>
 <b9c3e5aa-c7e1-08dd-8a1b-00035f046071@suse.de>
 <D06D70DC-D053-4212-B72C-82C1BB1AF9F2@oracle.com>
 <aae5c8e6-738e-669f-3f0e-059282d55449@suse.de>
In-Reply-To: <aae5c8e6-738e-669f-3f0e-059282d55449@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CY5PR10MB6168:EE_
x-ms-office365-filtering-correlation-id: 143bca55-60db-4c0a-7ab2-08db19a50fa0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FXiBnsuKb/6yHOe63eoQSuGtnR4v8uAbuw6mkWqL6qSQepxjtpBYpMusE+TV1z6/TP1l7CKLQyTExL4ARoLA7AHTBdotWHckVJ6dFkNGpQJJ22SG5+BDJGy523SLnDK908ti0/6LZMsFm+1Vfj0yJ5fH2g9xwrICEuLydY/LT36F32pu6w6AJEOMOFuH6mCiWJoM0P478cEAGIdmpFSqeUcY1l4lIV91AImLHySmLTpim5fGLq5O7ps0nBUIA254vbkvuT2OIOWCm2wRFR/+1j3xXqTN/CuwHy01mAI+QxJdcfCS8lLGNs8FUGlFqKUPtlAfQjLFFlgfLJPTZENSAekzzMoIK8M05MmaYqaCvyKpq9ApqWPOlDmakicPGyRt4ibjusiDdy9qKogbXSy/FuE14etLH57pNVJra7d6P2i9sn1RGn4pomCB+pO+/hKprHyeO/9HZLu2/prR2VcmbYdhObwTVnOcqrKqK62CkzzGueYqyOF/PMiy8HJy1IUHaMUN/9nda42bVcCuFW86f4vJZ2RJ5AbzlS3hmVAFz2FL+gt4hK8oIfggvxtsgovPjk8+OJ1/1LDCKD3rO+F826x6jWSqudyk3iVu4xH1zgNVQGzuI0G35SsXkZq6D9ijyF6LRxfZ1aWi/OlWf09bT5BNgj7oX3EMWnl5QjvAuhp7f63cK1nBdExewr9vXK081GByFjAEAToQzsjCjZS/LkjxbE2nLVpWTflHS+jaNuMm/Rp4j3szRE2vJ6+UZu9j+DgBk+f9cJNlxkXVYEyI1UoOY6CsjQgSvT9PUEer3/k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199018)(66556008)(6916009)(4326008)(8676002)(76116006)(91956017)(66946007)(66446008)(64756008)(66476007)(316002)(36756003)(2906002)(54906003)(41300700001)(122000001)(38100700002)(83380400001)(2616005)(71200400001)(478600001)(86362001)(33656002)(26005)(186003)(6486002)(53546011)(6512007)(6506007)(38070700005)(8936002)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?YCsyqdjf0TGUx9NWhG5ySu45tD2FPrSoeKF3X+OxGFeoEP5suD2xD6ARLTog?=
 =?us-ascii?Q?tfuoFGNaLUjMvp9Nly0S9zwRRWirHBd/iwdD/mSoP8oRLCx76VwT/HoITTHE?=
 =?us-ascii?Q?QIGN50oy78vs8HFFi1EIEZlPpn5pZ4hkUW3++GKh7gBxLtpSTra4EVUVSehn?=
 =?us-ascii?Q?Vvjht36Qbd86IXZKUm+mnOFDhI6JQf6dt76W7cHMA0J9Lkn4DScjI2LNwFdn?=
 =?us-ascii?Q?S138QKp/hEWaDQkaA3U1YJrdGdyj/uodiEmk3uDzSXK619PTDhrdIdEAff+P?=
 =?us-ascii?Q?DcGChWIBP9MOgtoii6RsRxNrp3gLMao21y34BXcwbtGopLQpCPnVl/JFdvq9?=
 =?us-ascii?Q?0Yu9rXWO8Y87GL4kdNOS5gy1Q066yaxwppb5o9Z2VdQOCNKNNHbJHocPfcGs?=
 =?us-ascii?Q?3gBJC/7H9sOu1Y1q6HlK8eetL0Zix8UZLEdvoQItjiEGUzGd9BVaT2WjN8g4?=
 =?us-ascii?Q?5S5MCQIzUrHbU+ZeF+Z/OFQy2vioo3wYOUMtX5Z05iuybFz/2M8xb6Bc8p0z?=
 =?us-ascii?Q?6JztucDlCZNfc/qQDSUKMxbXH6km+fKpotvJyysVVb2wnHhjAASQ97oIzQ3b?=
 =?us-ascii?Q?C/nObmsgbJkh9+yAwlKOiwQlwxFkc6FVT8hmbEQIKDVT/ZbN0nphViDIXFzk?=
 =?us-ascii?Q?7hu2wnCQhkCp/K/rL8Z9/fs0Ev/6sdFIWXi8g8HCAP331ML9HZz60F9og6+O?=
 =?us-ascii?Q?6mZmLoJF+qXkXtzGIaz4dtQTrGt+IpNspMnOmhk5bvFwEZ52T8qOh2uU9Wrd?=
 =?us-ascii?Q?0hbmJvy2aY6tTuGjHiNNXetanMyuNufgtMfqqEAXfHNe0Qa1Q0BK9mRuH4S0?=
 =?us-ascii?Q?RGqe/BHWIe9MOwVZhtRz9ZMuo4iyKBEzqo8CSxVQrct1LD9kumfpCOTImFLJ?=
 =?us-ascii?Q?gAXjYKle501x8rMb+DryiwzHGzqe2Jkqa/eYEuuQUvFxqssyDPbS0jR6Uvtk?=
 =?us-ascii?Q?0DrJNWdKEUWVmrjZR7pvnv6SjfrD/FoovAhDLpYdysb+/qyAYoSVHqwkVj+h?=
 =?us-ascii?Q?HjVxGLzVDr/w/JXnf5VTA1haIr500SkxG6Q11OsuEIxCCNFnX3PFpeRIeBKp?=
 =?us-ascii?Q?VKsauHeFX6wz3ST8biAWplRdVYRUun6NEjf7UXECD73AoYA0/ojwfOjomcB0?=
 =?us-ascii?Q?hAYm+xwQCWBIKSCXeeekmQd+K6zK/J6UHg9WIIplyAbs+ito24/PQFaxut9y?=
 =?us-ascii?Q?Nfg2rrRgQ27AbO5hEQ9VTqyJVPwfD+buLMX++/e3DnVom89jBfTaXFLzM3kX?=
 =?us-ascii?Q?jxvJTc6EXFiOLsH9Kz+DwQJsMixHFIi3eY2QaLb/AUsXRQsSoMibgDhBgBdF?=
 =?us-ascii?Q?Tl4vUacT+lX38mp9NyDixxOfC3gPcWuoYh8olyDOJuR/2CEymOiC7JjAKoGp?=
 =?us-ascii?Q?9X5lO4NKIuOClatwhqt3P9ZW1EI+v1bIUw/3e71toQ69HqPCufPAmiHcj1Ck?=
 =?us-ascii?Q?mkZ1ZSh4WV4XolyVZDwrPvdq9w+Uk2jhFVO6NJB9jm+B8qggPjr0N7fHIVlZ?=
 =?us-ascii?Q?NcbgUDcNHuJ09f6c4PAXh3SdNAlvp5Qdhf7JP/Pu1Tbmm/AcXsBNp6zA6Q33?=
 =?us-ascii?Q?zV0dlCVckLrioMGmJ78U2W2CYAbwhuxgDnAUR4U9adsb1C60NK1FlF31hnn6?=
 =?us-ascii?Q?xQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D0A9392C7C06484E8E95981B3F108DB3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: rAbElsf8UcW43Xdv47ImXySsTsWflY8SZ9rWh4ZsXIWSMyzi4LoA1TAUmRV5FF8ZSWW/qsVGp9c0n0sTPyx1lSPaXwUVfaco95X/8E3siB2WsumwJ5hfmpl4hX17sv/FlEcO+uPoL6oO0krsx61pm+rqG0XkpwYMdtPnm0iHcJ4sKbxjI3GV/yy74QdPpQqN2HNdFiqusEdsdrIdo9el6BOfdSK0eutueoPRRHErSCKkhYVWjC29QMEfqRmCME9DBt1a7kTeoNnOx9VIwWDoX69D19LpWRyT7dhy6ODPUhldDVbyK6JyOsWBn2xDcKdOZLhm++pbYrChVPa0YbKFle6ukdQX7YyFwBR7Q2ofHFhlT/scMaiH7fCK/lrXe1zmUrIvvW9DQw7Tb3vfTEMCtonoYu1oiM4XI1cIMhQrcIiGOuOaHM03NRVZwL/ctjRTddVwgGI3FRNab3cr4zbmVsCDnnBBqnYmMtWenvUZUkA4ykOfniAs3aHdARwShPynA8SUGenNrE6xuykq+d135Jgc7lQtvdA7uUKPSEKoMNw0gm5OloiwL19Kl8bQmLY4I8Eu+nIj8raSjtvj5WX3HnbHAoCqmYyK4G9A6je8Zx9R40JqSS+MHwZofa8MhulPHoRxEsP+vnekptj7OHI6NxjmNsMkKaRRfxSTo0SUfSkHAtN62aN9OxSpXJIivK2oQoxBxaqlGrr5JFpS03gQ5V83MhDR1PrrZHx6N1+iLg1/mYhWytmc699zaqyAdAmxhsv6GpIss7nFWjNQUwz0jDOPus3+VTyejO4D/p4v3mcMnuCHNbIldewHAbiusOijbtzNS2yauFKoXxA0kj8JvNVUhmz5piOqiSEFD6w3n6HwyUTQFPMWW34YHdYqYLhL0gUThdWUt15bcUNCCnm5Nw1lV+fWI2t2VRdOPW3o6pg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143bca55-60db-4c0a-7ab2-08db19a50fa0
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 16:01:32.4905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dlKg1V7SpsbF9Cxhz2xKbsslLpmQLxM5uaeynn5z/Jfr7OlyiSirZm159vGt8N8s/8Z930ZPUqkqkCLQHXgr4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6168
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_13,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302280132
X-Proofpoint-ORIG-GUID: VSb59mxu9SHRm6i9I4-TVfnw45DZuGpv
X-Proofpoint-GUID: VSb59mxu9SHRm6i9I4-TVfnw45DZuGpv
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 28, 2023, at 10:48 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/28/23 15:28, Chuck Lever III wrote:
>>> On Feb 28, 2023, at 1:58 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>=20
>>> On 2/27/23 19:10, Chuck Lever III wrote:
>>>=20
>> What about the narrow set of DONE status values? You've
>> recently wanted to add ENOMEM, ENOKEY, and EINVAL to
>> this set. My experience is that these status values are
>> nearly always obscured before they can get back to the
>> requesting user.
>> Can the kernel make use of ENOMEM, for example? It might
>> be able to retry, I suppose... retrying is not sensible
>> for the server side.
> The usual problem: Retry or no retry.
> Sadly error numbers are no good indicator to that.
> Maybe we should take the NVMe approach and add a _different_
> attribute indicating whether this particular error status
> should be retried.

ENOMEM is obviously temporary. The others are permanent
errors. This is handled simply via a tiny protocol
specification, which I can add near tls_handshake_done().


>>> So the only bone of contention is the timeout; as we won't
>>> be implementing signals I still think that we should have
>>> a 'timeout' attribute. And if only to feed the TLS timeout
>>> parameter for gnutls ...
>> I'm still not seeing the case for making it an individual
>> parameter for each handshake request. Maybe a config
>> parameter, if a short timeout is actually needed... even
>> then, maybe a built-in timeout is preferable to yet another
>> tuning knob that can be abused.
> The problem I see is that the kernel-side needs to make forward
> progress eventually, and calling into userspace is a good recipe
> of violating that principle.

That's why RPC-with-TLS uses wait-interruptible-timeout.


> Sending a timeout value as a netlink parameter has the advantage
> the both sides are aware that there _is_ a timeout.
> The alternative would be an unconditional wait in the kernel,
> and a very real possibility of a stuck process.

I'm not following you. Why isn't wait-interruptible-timeout
in the kernel adequate?


>> I'd like to see some testing results to determine that a
>> short timeout is the only way to handle corner cases.
> Short timeouts are especially useful for testing and debugging;
> timeout handlers are prone to issues, and hence need a really good
> bashing to hash out issues.
> And not having a timeout is also not a good idea, see above.

RPC-with-TLS has a timeout. The kernel is in complete control
of it. After a few seconds, the kernel abandons the handshake
attempt and closes the socket. It doesn't care what the handler
agent does at that point.


> But yeah, in theory we could use a configuration timeout in tlshd.
>=20
> In the end, it's _just_ another netlink attribute, which might
> (or might not) be present. Which replaces a built-in value.
> I hadn't thought this to be such an issue ...

It's an issue because you have not identified a particular
corner case (via reproducer) where user and kernel have to
agree on exactly the same timeout value, and it might be
different per-request.

Show me one, and I will agree to add it. So far, I haven't
seen sufficient justification.


--
Chuck Lever



