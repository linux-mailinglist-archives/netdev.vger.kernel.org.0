Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 061566BBB18
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 18:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjCORmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 13:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCORm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 13:42:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84359224C;
        Wed, 15 Mar 2023 10:41:55 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32FHEKPb007673;
        Wed, 15 Mar 2023 17:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=e2FesA8HeGh4f4SA6PJuDQ4fC32m0QQ8CO7VOQyRWN8=;
 b=QFS2V7MdQhF5B61JEfLgyJGoZ8QHPmwpuOY2B3gWNOlyzcUL3Htri/RQI6P+omaixk7c
 BC6HaWqiP26Bxfve03jc/vZMear9CpxaUA28e6TQdVhCWW78crv20ORkvCm4rQGZo0gh
 7zrbU2BiWEp3e1iwPspntg7NSdWMYlHC4r5KLPSBYd7hgfLPcOYbINSLB6Eg0G0LPEKV
 Vj1odf4SnyCjWc8VEKnbLhfrClo1YnaDOa8UATUngQcP4Q8qzDKIhqQQtzgSOvJsCoWU
 tkB1AoGYU5pe11fcTUMSJnuOz3Q5fEGQ+PlAjs3lulMH6E0kOjuyN/aIsEPpVP2APAJJ /w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pb2xpj1gh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 17:41:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32FHZsbD038347;
        Wed, 15 Mar 2023 17:41:13 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pb2w8pa4j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Mar 2023 17:41:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=anV9UpiLB1UJniebLEO9WxjipUhx/pZ2ibUMPRcvBKJankgMolFKyRN/n/IZ4BfvB/OxOTvSkm/0rbOpZqeeeCEbW2b2vY4qz3Aanq89CfztBxo0qSP+2qa8fdi68itwScxELJJqkfHMiGdU22saugqvr9hyRg/8IHi9ML5/4I2JyZ/Riq93UE/KANvBn5hnEtF+KmGR4zOrVLXl4eyM7x8KODDhwCUjef03qXbkiDY8UYJp8UUr+3xjdc9K8+ec4wsvsasqb0PrSIou+R3k+e7x+dU11yYqExNU8YGxDG2ZKVoIqCEGiArPobhf0dk0pQ+71He3xlYEls1beIAVag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e2FesA8HeGh4f4SA6PJuDQ4fC32m0QQ8CO7VOQyRWN8=;
 b=WxHMeSrBHWqUQ2yFZRg75VcWSjOx3Rbrjr6CA+EOBcgDM3N3iv5bPTwSEw8yA5NYNF0REm0Tim11331gaE01HdYXdZLibeNCpa8nvLhT8qes3xS92BpYoBQm42QyIboZrO8cfXx/kfZDu2P4YYtRl9Ko56IdY34VLT5mk3ZvxnXkTA2o4AzXKUkl0XNYmMsIDbfn+Xo2Z9HpetHLUGe1e60u7q+l73t6D8w1WCYEefh+We/vkoXUuAo0rTfUZbOd729mNHvu51o5UXweqTzguNndRo3dfsmR16IsYfeLE/BVQMOEwBoVPxclMysh5hLPGGV3DPAmzSzAlvkK7Mfqqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e2FesA8HeGh4f4SA6PJuDQ4fC32m0QQ8CO7VOQyRWN8=;
 b=n0LWn2w1F76Bnm/YVhxmExbL0vFhAOWlMyfmg4V1sLujChRF1jTE+Trx9e6THgFj8jvRsurfVhRbJPSy5KLFvTaItMHgKcA9X2DFBfxdTrcBr/p8mN7LbgbbVDx6f/N/sPVRTF2hR2pke/ngIzjzw9IucuO1wBHOKx7obsvBSRw=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA0PR10MB7135.namprd10.prod.outlook.com (2603:10b6:208:401::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Wed, 15 Mar
 2023 17:41:12 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 17:41:11 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH v2 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Topic: [PATCH v2 2/5] connector/cn_proc: Add filtering to fix some bugs
Thread-Index: AQHZVuR/gMApZDZt5kiq6XYKUuZ/aK77TNSAgADQDIA=
Date:   Wed, 15 Mar 2023 17:41:11 +0000
Message-ID: <FD3D56A4-EDD3-43CA-B12C-CAF736A3821E@oracle.com>
References: <20230315021850.2788946-1-anjali.k.kulkarni@oracle.com>
 <20230315021850.2788946-3-anjali.k.kulkarni@oracle.com>
 <20230314221633.1e6c9bef@kernel.org>
In-Reply-To: <20230314221633.1e6c9bef@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA0PR10MB7135:EE_
x-ms-office365-filtering-correlation-id: 175fa94c-c9a3-4f7f-344f-08db257c77cb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Zibe6ZtvSz0sI6S5E7Ook9PoL2jCm4XFGHdfepxP4wYJpN+2G4CUDYzXFnfNqPAoEzXe6iIKlRHjRVMlE6z0Xy/nNIR45bTTv92q5RtSCYFuZRjosrptcJkODFDc7SLuUL7qzbpPPI6VEJaLe600+KzrW/dagNTV5xkpDa3SHvYilzTjL2ANmPu147IVMbW0ESbT7Lsd0hB8GmvN0sl/WjiXHMQTxp9g/FpqK/l7nWxlUpploEifuGYxGW1LL/DG8ZOmGbhwWp6SoA4wXxEdT3q9LiAZ6jQsLtOMfft+yby5KQVkx+KBiMFrTRi5isqguXfvJkEpNZItNkWaR5L4yy+PCnZGKHpk4h7aea3TwyIJmeyhbebwwcZ3S0f/kahUGfkbdBI/XuEB0Cw9r8agMiQmpb32aJvJFJvIn9RsW73jZAzkpYV3ZrkGdRhlgk+tegViFdb+fNqVXVt2z1/zBlNQjhRmNoBjFC9CEPPbi7FCwy8/Lmo6jAUwU0h9SH8lqKVuNPiVcb4pskGzeXW0ikTN3BhWZAlFZTjRjVb9IgX2e81FgFTa5sQKE3AI3EXeKYNfrQJh5KOkpW782fBTwzYasul5enx6BA2XyGCQS+Uja9q+3kRZ1uR7YV4RKk6pk7yVvf42QcBOw+mbsFy/U5ZY35xS642Gby94lpZRlOvHFrbD6AXcrfeAViml3Kfnng3Zk7A4ZlCfBNwGKGXfToldQ7SaIYNvOU0qtMj582M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(346002)(396003)(366004)(39860400002)(451199018)(53546011)(38070700005)(33656002)(36756003)(478600001)(86362001)(54906003)(71200400001)(2616005)(66946007)(66476007)(107886003)(8676002)(76116006)(64756008)(6506007)(186003)(91956017)(66556008)(6512007)(6486002)(316002)(7416002)(2906002)(6916009)(83380400001)(66446008)(38100700002)(4326008)(122000001)(8936002)(41300700001)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Bp0xqm04IrEBTk5EZutr/3TeUwsgE05lEQX8WVObj61XZ2x73c5HWSpSZlh3?=
 =?us-ascii?Q?6NiBPR2pqWYHgbR9ex7jr4BiEWxQD41nB12L8US1tLJLrBnQw4Vcsszfl3+n?=
 =?us-ascii?Q?/2UZsVpCvpo2Xh1YBhh3jwlXxYQh0G/Ja7Txuwv0HPjjSZf110OQEPbnJGe4?=
 =?us-ascii?Q?4EkoCPyZcSwuJ+cAl8rsoCEBmU6DM0Jh+812LyfWUVWYCuP7ovtSJA7m49CL?=
 =?us-ascii?Q?yRE2n6OgvkxqiNz9MLmWqW3/R9cGWgILw27pO0yXIwLsvt+cyQpn2A5sp+yu?=
 =?us-ascii?Q?X4Yq0JRFXDOxw8l/iaeONTSF48A//Mp4GrKtmeYHmM/EOXB0qBMw8H0AUs+4?=
 =?us-ascii?Q?CCpXUaKhQZCc5wJPKyK4QFJxv1EtzZeTt3EP+GX+PZduQhxk96maXftj8Pc4?=
 =?us-ascii?Q?UnlyhXph3iACNTevp5ot66T5Fx2YBW9016/wEPWm208VTq+hqJgAnS7mYyge?=
 =?us-ascii?Q?sRUu4SPBWlgSHTwYsZTRqX2vpAj1AwtzGzNxakkBkjAmtjJJV7YJeEGskZ5h?=
 =?us-ascii?Q?sFelV73Zffvomys8gheZBHWOtqf8xlRTVhQFUXOC0kOY1/JbXCGmgMyz/SO7?=
 =?us-ascii?Q?jlcNI7JXtD5QCafLHwGaCBnLuqNxefrNbPGSl+McTDS4gJ37D1PaFY467uuo?=
 =?us-ascii?Q?O8HnBhehwFGlIiN9MQJZe8nptr+jUGKb315LObh47W6wk/BqcSSetkB77YWi?=
 =?us-ascii?Q?N6euK1EM3GGVkHr9CJqe2coxNss5O9gy7CS6Mf+NDuDU3BNVP47SgcwUa1KO?=
 =?us-ascii?Q?3JE+93ZVSthtJ+VhTBtQmQuHFHOt9RiZpKSNTR86DKy2KpdTcBUBZBvb2NHN?=
 =?us-ascii?Q?CVXXPDngTXYnUd6F5hnHyEA7UGEgmF05/CJlTpPLIhVKVqNIRyvauvKxu6Hk?=
 =?us-ascii?Q?dC+x4wQHm7Fh+knD1UpoFN7Y2FMtM72jsN7m15Y4OWofC2jcGUuj3Yj1RVU/?=
 =?us-ascii?Q?vKTsG+P8oPTseyFYFNcAV+PWYwRlsa3fpmmICuiYW8AhiCOnjG6gzEL74kje?=
 =?us-ascii?Q?Py0V/+ZEhUarZqGq0Tc7036mezL4FX3Q5NqFlYJK1rkAmxYR3paK1Pkr++qw?=
 =?us-ascii?Q?d7GgTiuyKvbngcO/gi+fl/6/Ma38+Sbe+cNbGmI4vRPbjQu0KWpq8Cp2RKkw?=
 =?us-ascii?Q?sNHIB157e43q/fc9/EoGgMs/iZfdGSCtZCEiD/Zk1lEGUdtJhVHPvIdvr3ns?=
 =?us-ascii?Q?emlTelVYvmwbAaDrnKNBYEv7FKwU8prwrQzcTyimvsM06qxlZxVJFM+kaI3G?=
 =?us-ascii?Q?TuFpGk/IJR/eC6XGtW3lhLjLqSXZBWtFljoWdPgD2Udt9QyOltVTcaWJyLAI?=
 =?us-ascii?Q?SOOTTFAy00ufRoV+SuIobIm4TnUW/qsxA1ZBWUyGarZaphgkFrzFdC+wD0hp?=
 =?us-ascii?Q?jPvPjKy+Ebi5jT3WCPPQtsDBD0Mp5dMbZaGFaCxxj7iUKVcaJNwCX2MZrvto?=
 =?us-ascii?Q?ShkdqTNULDHGC5OJQnTt+5u6mLSd/mJQ/ysHpEf82zGZvYcYm5DgWdznCagg?=
 =?us-ascii?Q?bEwsNvtsIgBxXF/cH+PCwQO5qhiF52BOayC8xhLU4Od7DUYFOHjvO3GvG0k+?=
 =?us-ascii?Q?HaxGeMC4d4yYNcbwCgzxyq9QSl1Kj2ZQ6K96AEz9UFTZC15qE4m8QUV2Xl7x?=
 =?us-ascii?Q?SMLVPG28mXB3zZQ91oHb8rRRuVSUx3jdECNsFOtL/SBF?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AA416A0E355B004D91A0ACFC6D269DC5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?bDg4GQUdya0mLigbTdyyk2MZAaoOrdd6QOJ5b9ww468OjQvqWOP+FC4BARMF?=
 =?us-ascii?Q?E6ovpiaWP4D/K0LjCUgRL6+1hk2PLxjVE05Zb5yNtcHDrfid2lY2pWM/lJs8?=
 =?us-ascii?Q?6ZMgRr7iOiBW7zItaoFGPIozUpW3IE8NqJLxveVMI2Ecb/shjtqV0dNWQF9C?=
 =?us-ascii?Q?99Yo2HT6XJLOrbhD1VBpS9Z/cAKTz3YRvR9r1bpLuPYMpIe2OJZNHegWYAGs?=
 =?us-ascii?Q?KxJJutetJ3zbb4h7fos8iryXZtn9FpC+i6DrW5LEd8+8nDHTV2AlCuy8Eg/u?=
 =?us-ascii?Q?DXOi5P3Sif3t7B74m98UmpYwKqoSZIRERcgIX7Mue+WBcPKyFaEuEdOFACob?=
 =?us-ascii?Q?KrdEWzJJ7fTJU9AMwyPRsgE38Jxmq7udL3r6BqezMHxnw/SmVESOwutUl54y?=
 =?us-ascii?Q?nxbZc8WmRFRZ48u6qsB5EA4OZcW9ppkdY20CwbjjmAe/WAvPC4Rlpp+2CAGU?=
 =?us-ascii?Q?69GoaSEyFC7KiiUYRjCDOtjjxfiUHdKWJiXud0Mq9ningE+Ak5hcbzmYZqkp?=
 =?us-ascii?Q?ROacFnIXMpLYIXiHQhZNmIftC/jIOChz4FszXFKhNSOxVjlitcLdj9xfEsPc?=
 =?us-ascii?Q?Q72KtTRbdJu5AGXypUT84CNJ/W6qlwySbGZKHprdrH4B/vAeljJi/kAhskdN?=
 =?us-ascii?Q?m7bgSKXIEbTftDLGSq8CeoITs3LiUQL8We7jHu4x7jMv/V/5x7tphDEp7vdl?=
 =?us-ascii?Q?tFWlRE9+WGshs/TPs5xYcvSlvPTwOP/XeUBqbJwTBzPYSHKUtcDiU1jHWoea?=
 =?us-ascii?Q?TrSzhRA8f/CzNAIWQhoF82uyuKbzXPGX+/5TesbweXtLeSE9ogW4NHpmPp0f?=
 =?us-ascii?Q?ZL5SUOsjPFhanL66mKl7GbD/96cXpHbJLPh/Qr4lSxezNQ/y4eayEbk+RCtS?=
 =?us-ascii?Q?BenK57A/rPkFC2yav4tl2TihFbHQzfHI5CvVBk8b1+KYloc6HlMl1eYoSiQa?=
 =?us-ascii?Q?2Xx1S0CEr2ZC67mGX4aphUUX0orpdghZXf1XlRX0OBkQnSYmlAgOqPH3alOe?=
 =?us-ascii?Q?9dgQMPy1LWnPYfK3e8xeNsb7qFjRi1ip56bqE7UmjnJVyYmZgr3P8wpsH3h0?=
 =?us-ascii?Q?arbeg9rLLJjEsLa6YCo8xCF0bGI75A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 175fa94c-c9a3-4f7f-344f-08db257c77cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 17:41:11.8879
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S6hL7SLVtkvxSX1BDqpXDZCDYWlpQity5Y9OkWaiJ6PAdL54Toas11Cj2TCjFfP8CyWRaC6kY8GZ08FteJl61TRJ0VOWuatgCaO25B3yX9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7135
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-15_09,2023-03-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2302240000
 definitions=main-2303150148
X-Proofpoint-ORIG-GUID: DL6kdSvdfY4EJFe7KKj1iriI0m6dz75Q
X-Proofpoint-GUID: DL6kdSvdfY4EJFe7KKj1iriI0m6dz75Q
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 14, 2023, at 10:16 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Tue, 14 Mar 2023 19:18:47 -0700 Anjali Kulkarni wrote:
>> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
>> index 003c7e6ec9be..ad8ec18152cd 100644
>> --- a/net/netlink/af_netlink.c
>> +++ b/net/netlink/af_netlink.c
>> @@ -63,6 +63,7 @@
>> #include <linux/net_namespace.h>
>> #include <linux/nospec.h>
>> #include <linux/btf_ids.h>
>> +#include <linux/connector.h>
>=20
> Not needed any more.
Will remove
>=20
>> 	/* must not acquire netlink_table_lock in any way again before unbind
>> 	 * and notifying genetlink is done as otherwise it might deadlock
>> 	 */
>> -	if (nlk->netlink_unbind) {
>> +	if (nlk->netlink_unbind && nlk->groups) {
>=20
> Why?
Just an additional check, will remove
>=20
>> 		int i;
>> -
>> 		for (i =3D 0; i < nlk->ngroups; i++)
>> 			if (test_bit(i, nlk->groups))
>> 				nlk->netlink_unbind(sock_net(sk), i + 1);
>=20
> Please separate the netlink core changes from the connector
> changes.
Will do in the next revision
>=20
> Please slow down with new versions, we have 300 patches in the queue,
> replying to one version just to notice you posted a new one is
> frustrating. Give reviewers 24h to reply.
Ok, sure!

Anjali

