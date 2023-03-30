Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 684AA6D06B0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 15:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjC3N2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 09:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231980AbjC3N2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 09:28:01 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EB38A5A;
        Thu, 30 Mar 2023 06:27:58 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32UBn2Jl026527;
        Thu, 30 Mar 2023 13:27:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=+a/CJxQu+j0KJ0ENs4/Lqw/7cdi7GgFI1ZzCKwD4Tuk=;
 b=bB/paMSor49pUT0hHUs+yEnkSd3VKyTpAFNR+AYe4cx9kC+q1vlBV0O0/AMTGEtBjlTw
 AB4ABJN+hj3owCzjTrhvxdAWEIjfdgO6QiSAJEN6AvMIN1A3U3Szjs3OsjomFRgbH36K
 dT20f3n7L/SnC4JFeZpJlATq1oDU11PicFk7dwwHFT3p5XOXwNWZslYx7XVo27FgThkq
 zmWBSLTnwmL0BTCWKnO3U5N3s+KIon9JE/gOWY8cUO6GUuw3KUeOsBhSR1nt8VF1Jp1N
 lzkHU+v4QNUAnaNHCI+tfoidVRGKXy7LNlGnDktsBJTa9SGJi6IZk1LKNGAkbWNP/aTz Sw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmqeajh9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 13:27:36 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32UDJBhN035012;
        Thu, 30 Mar 2023 13:27:35 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3phqd9devm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Mar 2023 13:27:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJNPypBlqP2qgEyhaoPuMsgfH/Ki3Mf/yr9Ix0JftAhx+ycz4XkD0vCo+REFoG+rEuLWFLVek4pH0m74HCA76m0IXcJ7mqCus3zkrGS0jBZdkIl32zY1QW/dWk/krbJfZEsT94t8zmLbGEphjUNdzpY1NhbXwiaGPlai38jTjxSX/xUJbbihTa5HsP1sul8OtqUVrILL6tz3BEewoI+lJ2RmoHgfB5DtjMQwLLaHAWVKh34ANX4Jv7t91bvyxGeacN1MB7n+hpxWc/KiJiPY4IQhIzJQNpzJmGrP7iHt8sNSjj5qn3he1WDlsXfk4hMgOpZCOSwa1GkHByfrtku3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+a/CJxQu+j0KJ0ENs4/Lqw/7cdi7GgFI1ZzCKwD4Tuk=;
 b=JPEUGW3th1VSEAiKc86c+YXvq6GxvgwLA0VzzWYYWppGXCln8Z9f1myoMWxE9jPCNVfSf5poAYvYmPGjbZKo5K0ehde55p+B7aoEwTRziJbTKuP2drBbkzKoUYNjk3W2tBHjOvVeR5oZmdH7Mohz0fEt5EaVDJ5dEzaMzxOBIlrNvvJMpx++JCgs4Wucg51B+SvtgLKC9x6/YbtRVVzAaS+x4AUFompEbPXSBMpl6XIj5SsHcvkL9bDrJ9GXVta5ZeOgQfm2LT7f9Jgg2D/1u+k8ZksaCX2jjZOtGlWiMkETXp+1oND5G3/Ar99gtbvVthKn/jNmXmTb34PrP4msqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+a/CJxQu+j0KJ0ENs4/Lqw/7cdi7GgFI1ZzCKwD4Tuk=;
 b=fCRpducqgfZijnOzWLldPcxRoeKM1b86f1tA5uGiyKF/O6Q283z5ZYGIZTXn9kZc+SumNSlChrtITDVuQt0n7iwCeLlUVeUbo1j/POGfqFl/ge62tNn8qhqkldXx+Uqamw77+pnZwYuVGBVHkuTPh6fFr94O/JjSbUOjOIEPt8A=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB5892.namprd10.prod.outlook.com (2603:10b6:a03:422::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Thu, 30 Mar
 2023 13:27:30 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6222.035; Thu, 30 Mar 2023
 13:27:30 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     David Howells <dhowells@redhat.com>
CC:     Matthew Wilcox <willy@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
Subject: Re: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES) rather
 then sendpage
Thread-Topic: [RFC PATCH v2 40/48] sunrpc: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Thread-Index: AQHZYkj+dLwZN/D8CEye9eJOITPkS68R4ZoAgAFpS4CAAAQ3AIAAAxGA
Date:   Thu, 30 Mar 2023 13:27:30 +0000
Message-ID: <3A132FA8-A764-416E-9753-08E368D6877A@oracle.com>
References: <812034.1680181285@warthog.procyon.org.uk>
 <6F2985FF-2474-4F36-BD94-5F8E97E46AC2@oracle.com>
 <20230329141354.516864-1-dhowells@redhat.com>
 <20230329141354.516864-41-dhowells@redhat.com>
 <812755.1680182190@warthog.procyon.org.uk>
In-Reply-To: <812755.1680182190@warthog.procyon.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB5892:EE_
x-ms-office365-filtering-correlation-id: 35e60ebe-865d-40b7-ea07-08db3122836e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0AGPjEfkIvG6ZFAH3TxFG4TM3j9AJ5LGt+PbN0y9TkTVgZ3hQPEKDcqkqNb0uSailVvBRV4fsuE5Yyd/C2lM8J8+ua43kiww2tyjIvPffUOLx2/PGPU62HFEIKo80Nz4rhUSBL+vdlvdxVfLVcZcIdq7MDxva0lAhYOOrGz5XR/vhGOoaX6C0UPfA9wuHDGjP1ezLimtEXrmtlPe0dENRu/njHl2+gqlzdx1r+0ywKUxslcFaGxZK5V7uFAVuT88HbK/14V76wYKSqi0u0xuR0PikeAPkNxw+x+mzZb12k9JSsClkLIServV1QesS0IzKFZfPy4RvdPkRD/GZ2CEkgF+1BAGzDYueQ0HkoJ/YYjTxcS+878jHsQoWpgQYHE7Z83U6teG4/XdKpKXpQ+pxRO2KPm/X1SQyCOnU+mN3FeRmXoTOoE9r6Nfpi2tGe8eLzLekafi2NGVnPD96t8UP9V0fucfVZ1qzUGFodeKIgbkcOeAJw0pnRQTM5iYFvLFlx/KHFz6q85bEZ7mnrBKEVab66LUQ9a1aVgDAWdwmjumqPBbURjwtMskvjrf+I+5FqKrCJZgVZiI0I7yWevpW5bxonDRXYZ4E+MRTFc2B2EwlORTqnU8cfE2ywLRqlyJQ5h9IaE5m8n2HXUmPgK0Ag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(366004)(396003)(136003)(39860400002)(376002)(451199021)(66899021)(71200400001)(33656002)(86362001)(2906002)(83380400001)(6486002)(478600001)(316002)(54906003)(38100700002)(6512007)(91956017)(5660300002)(38070700005)(122000001)(66476007)(186003)(7416002)(66946007)(64756008)(2616005)(4326008)(6916009)(76116006)(8936002)(6506007)(26005)(8676002)(41300700001)(66446008)(53546011)(66556008)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1yMYFA1tQVIPgV1u80yNwrc54fZVh/oz8N91cVPbwsq37gWz0jsWlapPvmkw?=
 =?us-ascii?Q?cOGiQ/my5SSFI2FX+LXUnhQvx7Rn0ofRHLHeDzh7zGS6gEHuqRgiyMPkbM3e?=
 =?us-ascii?Q?NzjzPiaN6evmtjqsGPHgpbxZOTWH6UEFb8xEi0VayGUDACtm9eKWCuAs+7Lx?=
 =?us-ascii?Q?ajm0cCHIZCNXcuX2+fErQ+M6sO04qwnLtFpMUYboIHcK3dojXd5D8EO5OSNw?=
 =?us-ascii?Q?Xe3XBsOJhjOjUvFqzAF4vMlwOqQ/KC8AQXsbtc+yLyDMNwWom03IEDNfqsW5?=
 =?us-ascii?Q?8nR0ciRKKxusVB7nWFTZmANi+1/O9Vork9asgD77a3XMPZb2Zp8TYGrjZmtg?=
 =?us-ascii?Q?6SVsWEzTTZCHSoyuqF1rF3c+cApFVeGZo74twyBNrtgkXiKvjd8cpbKM48r0?=
 =?us-ascii?Q?AwUX5CXk1kDnR8JZlhDuLVCTAZ2rkBehStklN6OfO5TdkhPmvQQl9DFFEmRT?=
 =?us-ascii?Q?Lg7YeMoEtN96WpkxcPzqjwIxy4vvfioFd9OERZ2l8Cq6YgOkw9nn5yRzrtOa?=
 =?us-ascii?Q?HWBACr0IZFCHLAg9iuDr+4oKrI3n/TgUVUZwf5od34Gtxzr2O0WNu7d6Cd3u?=
 =?us-ascii?Q?1cqz2du6jZYMtXg43yzSIvwskKX26oW0nVoy6rjRlLpd6O4WQ38DCd8AFHkn?=
 =?us-ascii?Q?npkDQj05nGGxkOPLpMt1F5BqFOvH+p5TQKCyy4FbotpUUPn+dwYPHgpO9E/P?=
 =?us-ascii?Q?mD/DtU1Eja2MISCH9VgFH1Yhb5bjCWxH+itEoTpupvbIxtW4wgLVyiS7U+XC?=
 =?us-ascii?Q?ZMHsEXxcbkpke59957myuT0rzetKhVFWhQqOEhKAR4wHo36qPjm4uXNCvU16?=
 =?us-ascii?Q?7M2Hd7Ulqd+HtdCyFgTmlgaHYiE+5iZwi1R6VkDJ4ZopyL0NJmvZq1C0iWC2?=
 =?us-ascii?Q?kEmvb/UUEJAF+JIH/aPfxh84lj20djgu03klj73bKARoyoMaUkp+QYpwwNq7?=
 =?us-ascii?Q?LrLDy9rm3RGYFBdGmLwyI6CwVQLgizRoOQsYYLsvOoZZZaJicL/Ne1qsxEFm?=
 =?us-ascii?Q?yUQDx4rAXMrhANg6pCVTeGlNElDN1ZFdyfZEYNMTFSpt8TUsr3183Dyr3fmj?=
 =?us-ascii?Q?lp+bpCGr6GY4xscwM53PuPC5QDu4LumsQ8fHCGpOrzwlRkwrojuUHYr2WNyx?=
 =?us-ascii?Q?BOHN8GvEAS/7nWZJd7eVX59Cqh54+5c4PJxqOWWVIWtYbY+D9hwIkfd1FgZV?=
 =?us-ascii?Q?OP1KiIjP2SyKta//va/3n76mA5Fngo/ygam5wFIHEwhwm8yHnOq1nsiHOUrK?=
 =?us-ascii?Q?9ILltgcUX+SctQqM4VB3Z07yzpk0Iuj4Dqb7pCheJkRq5545yX9fJMziDfKh?=
 =?us-ascii?Q?bh7gt4IXnNcwoON9OJnGqD6QhGtLkeiE+UsJwxE2U7mIKDVPg95l2CNm0uSd?=
 =?us-ascii?Q?2wK/71tbJDkmvfvNep19NbX9cAm7GXokQToxOrRLVkB+EwFOz36I0jNr+NlW?=
 =?us-ascii?Q?PkA5/I7g3WONY8ZhEsRn4H+vsrJv3YUnAdQFF9+LUcDkJ1zw3ZHEgWfEoaZf?=
 =?us-ascii?Q?h9RmcQti7xFjh5Y5AqofwX6FjjoeIG1ubIn/yGSWHEaGnz1z8g8H3AuQ4SQN?=
 =?us-ascii?Q?5jshBf97Erkl4Lx4oTJz39DY5u0V783YZHK9pjO1nDcrVSy5UaYqiEdqQRpI?=
 =?us-ascii?Q?DQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <73F49870D6A00B49A1716882E34272E5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?ZzNmNctZiVRYAsO0jD6nwepcqmwuRVj6vDxfsdxctqRUoZgQZfm0psboFw/B?=
 =?us-ascii?Q?nD+QPxRcQQhn11LXvJtDAfGc0bo1NQxTMST7cVmu97GcSZZLckaz4aw4gS00?=
 =?us-ascii?Q?+C5/+QbSzX8Ua2RJRQZ53Rm0jg2c9EHBHZ5QtQhhlD3AnF/1K+bEb4n3kwDp?=
 =?us-ascii?Q?ZlonkmK2ElG7YpPGM1n3LDgdX6EAAKvZ2Q3ma2iD0SndMedTclrq6+oFBaC/?=
 =?us-ascii?Q?TA0hYhw6gCd0ivbRP3toz/F/t/oJAUIievCNvqfauIXoY/ebQrYCOhylXEJr?=
 =?us-ascii?Q?YxqzIS8lN+P1WwUMbt+qy1RWXBhbe7mxbbIPsal5/vvnTXESn5R0wKSLWbHB?=
 =?us-ascii?Q?v5Rhxo0OORyhmIleR+AUb4SyqvUEZ8f31Om7VYDPMY3G9Bp/zEQmKpr8XcRu?=
 =?us-ascii?Q?ExednjDTKRL/OHwVDMPMD3VLcJjhevWfzIQlhN+DgWAnNnrnMW16ElC3wbKw?=
 =?us-ascii?Q?+AIB51JiBvxYx3jS87hegW74EPNco21qovMIUhct0sMOaAy8SflY1kqkcUTJ?=
 =?us-ascii?Q?1TmVY3KWNKwRdnwSIBFJHBycO/vPyIE/7APvAnrYrVXX2MzLJDjIZ5KXqmtv?=
 =?us-ascii?Q?zrgmbGncQonIfDNi+o51vtCCi3a1wLyO3ptSUK8tmNj0JjgY2s6KOO3VmwJI?=
 =?us-ascii?Q?mrvfqfiIaa8WFyxTIY3tFj7uF2L8P4nersrBx0uIe2EUqHiaQUBE7NNQ/CJ1?=
 =?us-ascii?Q?Sh9jDNbxiPn8m/hwFSr6UQgtotEMuyLSAHF8yUdgILNtYVko/M09nUKZkiml?=
 =?us-ascii?Q?IFkJZQrfa3rtMIFlg/OQvM7Qw3uO9e+ch9Jv5Sr/upXNP4vPSw+vXqh+FFRy?=
 =?us-ascii?Q?X14MzDxb0hIGDYBwHam09fFj+h6u6l7+JvMM/HlsqL810Z69tN49lpAu+ZvM?=
 =?us-ascii?Q?56Jo5MZUgaF5iR0gfLwnTsvfuX54sZ8MSUpICbf4f82EnFFRd0JxEP41EFyE?=
 =?us-ascii?Q?C9QfZj7v0z/YuKCGwk2L1wLm8/KvDdUhyVuOAp4ya9bv6pXRW1MhSf2BgKt+?=
 =?us-ascii?Q?TgfOYKZ/EYxGFc8zItSdbC78XtW16yHMagrUjp3JmsNhMKD0C1cCAqvw4CoH?=
 =?us-ascii?Q?YeEtMgwv+E76Gm46elD6WQF7bmoE2Ez3v+UtfD5KFdQSXEYM3xKR0oOzc8HF?=
 =?us-ascii?Q?k35k1ltEOLd3?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35e60ebe-865d-40b7-ea07-08db3122836e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Mar 2023 13:27:30.6753
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nskeAQ9JLm1sD5lQ1c00EeHZA9rXBrcuTlyiaPrXkB1GUueHdk9ts66oNwr7FILKDrjp0i4luLayius00wtuMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5892
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-30_08,2023-03-30_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303300106
X-Proofpoint-GUID: HjcaDIeBTD7QhJfj7vt8qBMXwFoLGHPT
X-Proofpoint-ORIG-GUID: HjcaDIeBTD7QhJfj7vt8qBMXwFoLGHPT
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 9:16 AM, David Howells <dhowells@redhat.com> wrote:
>=20
> David Howells <dhowells@redhat.com> wrote:
>=20
>> Chuck Lever III <chuck.lever@oracle.com> wrote:
>>=20
>>> Simply replacing the kernel_sendpage() loop would be a
>>> straightforward change and easy to evaluate and test, and
>>> I'd welcome that without hesitation.
>>=20
>> How about the attached for a first phase?
>>=20
>> It does three sendmsgs, one for the marker + header, one for the body an=
d one
>> for the tail.
>=20
> ... And this as a second phase.
>=20
> David
> ---
> sunrpc: Allow xdr->bvec[] to be extended to do a single sendmsg
>=20
> Allow xdr->bvec[] to be extended and insert the marker, the header and th=
e
> tail into it so that a single sendmsg() can be used to transmit the messa=
ge.

Don't. Just change svc_tcp_send_kvec() to use sock_sendmsg, and
leave the marker alone for now, please.

Let's focus on replacing kernel_sendpage() in this series and
leave the deeper clean-ups for another time.


> I wonder if it would be possible to insert the marker at the beginning of=
 the
> head buffer.

That's the way it used to work. The reason we don't do that is
because each transport has its own record marking mechanism.

UDP has nothing, since each RPC message is encapsulated in a
single datagram. RDMA has a full XDR-encoded header which
contains the location of data chunks to be moved via RDMA.


> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Trond Myklebust <trond.myklebust@hammerspace.com>
> cc: Anna Schumaker <anna@kernel.org>
> cc: Chuck Lever <chuck.lever@oracle.com>
> cc: Jeff Layton <jlayton@kernel.org>
> cc: "David S. Miller" <davem@davemloft.net>
> cc: Eric Dumazet <edumazet@google.com>
> cc: Jakub Kicinski <kuba@kernel.org>
> cc: Paolo Abeni <pabeni@redhat.com>
> cc: Jens Axboe <axboe@kernel.dk>
> cc: Matthew Wilcox <willy@infradead.org>
> cc: linux-nfs@vger.kernel.org
> cc: netdev@vger.kernel.org
> ---
> include/linux/sunrpc/xdr.h |    2 -
> net/sunrpc/svcsock.c       |   46 ++++++++++++++-------------------------=
------
> net/sunrpc/xdr.c           |   19 ++++++++++--------
> net/sunrpc/xprtsock.c      |    6 ++---
> 4 files changed, 30 insertions(+), 43 deletions(-)
>=20
> diff --git a/include/linux/sunrpc/xdr.h b/include/linux/sunrpc/xdr.h
> index 72014c9216fc..c74ea483228b 100644
> --- a/include/linux/sunrpc/xdr.h
> +++ b/include/linux/sunrpc/xdr.h
> @@ -137,7 +137,7 @@ void	xdr_inline_pages(struct xdr_buf *, unsigned int,
> 			 struct page **, unsigned int, unsigned int);
> void	xdr_terminate_string(const struct xdr_buf *, const u32);
> size_t	xdr_buf_pagecount(const struct xdr_buf *buf);
> -int	xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp);
> +int	xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp, unsigned int head, un=
signed int tail);
> void	xdr_free_bvec(struct xdr_buf *buf);
>=20
> static inline __be32 *xdr_encode_array(__be32 *p, const void *s, unsigned=
 int len)
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index 14efcc08c6f8..e55761fe1ccf 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -569,7 +569,7 @@ static int svc_udp_sendto(struct svc_rqst *rqstp)
> 	if (svc_xprt_is_dead(xprt))
> 		goto out_notconn;
>=20
> -	err =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
> +	err =3D xdr_alloc_bvec(xdr, GFP_KERNEL, 0, 0);
> 	if (err < 0)
> 		goto out_unlock;
>=20
> @@ -1073,45 +1073,29 @@ static int svc_tcp_sendmsg(struct socket *sock, s=
truct xdr_buf *xdr,
> {
> 	const struct kvec *head =3D xdr->head;
> 	const struct kvec *tail =3D xdr->tail;
> -	struct kvec kv[2];
> -	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES | MSG_MORE, };
> -	size_t sent;
> +	struct msghdr msg =3D { .msg_flags =3D MSG_SPLICE_PAGES, };
> +	size_t n;
> 	int ret;
>=20
> 	*sentp =3D 0;
> -	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL);
> +	ret =3D xdr_alloc_bvec(xdr, GFP_KERNEL, 2, 1);
> 	if (ret < 0)
> 		return ret;
>=20
> -	kv[0].iov_base =3D &marker;
> -	kv[0].iov_len =3D sizeof(marker);
> -	kv[1] =3D *head;
> -	iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, kv, 2, sizeof(marker) + head-=
>iov_len);
> +	n =3D 2 + xdr_buf_pagecount(xdr);
> +	bvec_set_virt(&xdr->bvec[0], &marker, sizeof(marker));
> +	bvec_set_virt(&xdr->bvec[1], head->iov_base, head->iov_len);
> +	bvec_set_virt(&xdr->bvec[n], tail->iov_base, tail->iov_len);
> +	if (tail->iov_len)
> +		n++;
> +	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec, n,
> +		      sizeof(marker) + xdr->len);
> 	ret =3D sock_sendmsg(sock, &msg);
> 	if (ret < 0)
> 		return ret;
> -	sent =3D ret;
> -
> -	if (!tail->iov_len)
> -		msg.msg_flags &=3D ~MSG_MORE;
> -	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, xdr->bvec,
> -		      xdr_buf_pagecount(xdr), xdr->page_len);
> -	ret =3D sock_sendmsg(sock, &msg);
> -	if (ret < 0)
> -		return ret;
> -	sent +=3D ret;
> -
> -	if (tail->iov_len) {
> -		msg.msg_flags &=3D ~MSG_MORE;
> -		iov_iter_kvec(&msg.msg_iter, ITER_SOURCE, tail, 1, tail->iov_len);
> -		ret =3D sock_sendmsg(sock, &msg);
> -		if (ret < 0)
> -			return ret;
> -		sent +=3D ret;
> -	}
> -	if (sent > 0)
> -		*sentp =3D sent;
> -	if (sent !=3D sizeof(marker) + xdr->len)
> +	if (ret > 0)
> +		*sentp =3D ret;
> +	if (ret !=3D sizeof(marker) + xdr->len)
> 		return -EAGAIN;
> 	return 0;
> }
> diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
> index 36835b2f5446..695821963849 100644
> --- a/net/sunrpc/xdr.c
> +++ b/net/sunrpc/xdr.c
> @@ -141,18 +141,21 @@ size_t xdr_buf_pagecount(const struct xdr_buf *buf)
> }
>=20
> int
> -xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp)
> +xdr_alloc_bvec(struct xdr_buf *buf, gfp_t gfp, unsigned int head, unsign=
ed int tail)
> {
> -	size_t i, n =3D xdr_buf_pagecount(buf);
> +	size_t i, j =3D 0, n =3D xdr_buf_pagecount(buf);
>=20
> -	if (n !=3D 0 && buf->bvec =3D=3D NULL) {
> -		buf->bvec =3D kmalloc_array(n, sizeof(buf->bvec[0]), gfp);
> +	if (head + n + tail !=3D 0 && buf->bvec =3D=3D NULL) {
> +		buf->bvec =3D kmalloc_array(head + n + tail,
> +					  sizeof(buf->bvec[0]), gfp);
> 		if (!buf->bvec)
> 			return -ENOMEM;
> -		for (i =3D 0; i < n; i++) {
> -			bvec_set_page(&buf->bvec[i], buf->pages[i], PAGE_SIZE,
> -				      0);
> -		}
> +		for (i =3D 0; i < head; i++)
> +			bvec_set_page(&buf->bvec[j++], NULL, 0, 0);
> +		for (i =3D 0; i < n; i++)
> +			bvec_set_page(&buf->bvec[j++], buf->pages[i], PAGE_SIZE, 0);
> +		for (i =3D 0; i < tail; i++)
> +			bvec_set_page(&buf->bvec[j++], NULL, 0, 0);
> 	}
> 	return 0;
> }
> diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
> index adcbedc244d6..fdf67e84b1c7 100644
> --- a/net/sunrpc/xprtsock.c
> +++ b/net/sunrpc/xprtsock.c
> @@ -825,7 +825,7 @@ static int xs_stream_nospace(struct rpc_rqst *req, bo=
ol vm_wait)
>=20
> static int xs_stream_prepare_request(struct rpc_rqst *req, struct xdr_buf=
 *buf)
> {
> -	return xdr_alloc_bvec(buf, rpc_task_gfp_mask());
> +	return xdr_alloc_bvec(buf, rpc_task_gfp_mask(), 0, 0);
> }
>=20
> /*
> @@ -954,7 +954,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
> 	if (!xprt_request_get_cong(xprt, req))
> 		return -EBADSLT;
>=20
> -	status =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask());
> +	status =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask(), 0, 0);
> 	if (status < 0)
> 		return status;
> 	req->rq_xtime =3D ktime_get();
> @@ -2591,7 +2591,7 @@ static int bc_sendto(struct rpc_rqst *req)
> 	int err;
>=20
> 	req->rq_xtime =3D ktime_get();
> -	err =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask());
> +	err =3D xdr_alloc_bvec(xdr, rpc_task_gfp_mask(), 0, 0);
> 	if (err < 0)
> 		return err;
> 	err =3D xprt_sock_sendmsg(transport->sock, &msg, xdr, 0, marker, &sent);
>=20

--
Chuck Lever


