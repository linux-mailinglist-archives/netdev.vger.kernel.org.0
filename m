Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED486CF0DA
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 19:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjC2RSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 13:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjC2RR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 13:17:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9158F3C31;
        Wed, 29 Mar 2023 10:17:57 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDTRlL008929;
        Wed, 29 Mar 2023 10:17:43 -0700
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2168.outbound.protection.outlook.com [104.47.73.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3pmdqhkssd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 10:17:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UveL6SCX7rNyVgrfA77f+Uvi1gBFdW7Q28HKMNELHe7LUIgXPTauLBAD8CNqPtVR/T0S4k7PtoiavuE0Xyn/y/2J1UROSV+nZnc1MYsxfhvPuMS8uonI8t1v1beBc6v8S4nC7NQgMXXV3p0ZqmATJ2dj1K0l2jPTyyb577G2VurNLJH2X6FHZgT1J+OnjuN8mX33deH0L8iAt5OYxpLjFkudTMDsUSUyEH2lkiF1ZQDumJ3ejREkBvijoXXzLwXoCryYrAgOgCAPpZY3Rml+gULNPWUfBXKyh/eh+DKn/cILTtSdrQr7i/uFMroGTLJBbZjd83NSorYoFiv5OCgmVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CCzKlT1COnRQyLE2ItByZDre6YkRIyhBaO6BlAE9VC4=;
 b=c7ukOAE4b3CXc5r/jrSPs0jz/ptxPPvaZ7Nrwd1qOMVl6gTB9j8MxLC9LEXj583PahULJK79CdpFern3ScGwiKf0WG/GVDqeER2Yig1f748jGZw5BNkQ1HtINRo/xu3BrTG+UZ3brg+TCLDX20PI+glKe0j/3BgBUFqg7nZhEGzNuNNYeq3lOJIQmeCm1nXX66RHaExyIYjqIf7JJNLWSM0D9TdPYA1epHRVboI5pWRLBTE8jsCGEZBk/tAvUoEIctPww3mq4jDfOXHn2N4Mm1ekT2IWBwgVAlF1jDxONN8Q9WoPLn0mnsKuS0usAVNdYJqMeAuTdmd+iXz3J3I5+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CCzKlT1COnRQyLE2ItByZDre6YkRIyhBaO6BlAE9VC4=;
 b=s0rFc3VulATSo/CErT3a2dO12OycDQeFl+l3nrztpRmklVD7Q0dkVztgeqeaFSf5LZecc3QGFVd2SkoK7hN6fDftRKmt6rpz+eZHx/2ZTIrliUL9bIUpcBmEWoGKXtBGFFSCRNJXeFxKwYLLZHFoMMrDw7eN6ewDYxEb1HUX1KU=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by CO1PR18MB4796.namprd18.prod.outlook.com (2603:10b6:303:ef::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Wed, 29 Mar
 2023 17:17:40 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::6968:a4c6:1f37:3ec0%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 17:17:40 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "naveenm@marvel.com" <naveenm@marvel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>
Subject: Re: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB offload
Thread-Topic: [net-next Patch v5 5/6] octeontx2-pf: Add support for HTB
 offload
Thread-Index: AQHZYmJdJ6XjBYfPvUGEMW82DfsoKg==
Date:   Wed, 29 Mar 2023 17:17:40 +0000
Message-ID: <PH0PR18MB44743C4D7AFDE15AA6FE0260DE899@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230326181245.29149-1-hkelam@marvell.com>
 <20230326181245.29149-6-hkelam@marvell.com> <ZCL8mXFZxpTj1Duz@corigine.com>
In-Reply-To: <ZCL8mXFZxpTj1Duz@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctOThkNzMzMWYtY2U1NS0xMWVkLWI2ZGUtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDk4ZDczMzIxLWNlNTUtMTFlZC1iNmRlLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMzU2NiIgdD0iMTMzMjQ1ODM4NTYwNDE1?=
 =?us-ascii?Q?NTkwIiBoPSI5RHB0S0VYUENKYldocFFOU1BheWdzTTFGR1k9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUJt?=
 =?us-ascii?Q?VHpGYlltTFpBZGFTV0MxS0MwVVkxcEpZTFVvTFJSZ05BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFBR0NBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTFGSDNhQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
 =?us-ascii?Q?eUFHVUFjd0J6QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFF?=
 =?us-ascii?Q?QUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdNQWRRQnpBSFFBYndCdEFGOEFjQUJs?=
 =?us-ascii?Q?QUhJQWN3QnZBRzRBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
 =?us-ascii?Q?QUFDZUFBQUFZd0IxQUhNQWRBQnZBRzBBWHdCd0FHZ0Fid0J1QUdVQWJnQjFB?=
 =?us-ascii?Q?RzBBWWdCbEFISUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCakFIVUFj?=
 =?us-ascii?Q?d0IwQUc4QWJRQmZBSE1BY3dCdUFGOEFaQUJoQUhNQWFBQmZBSFlBTUFBeUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-refone: =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR01B?=
 =?us-ascii?Q?ZFFCekFIUUFid0J0QUY4QWN3QnpBRzRBWHdCckFHVUFlUUIzQUc4QWNnQmtB?=
 =?us-ascii?Q?SE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFRQUFBQUFBQUFBQ0FBQUFBQUNlQUFBQVl3QjFBSE1BZEFCdkFHMEFY?=
 =?us-ascii?Q?d0J6QUhNQWJnQmZBRzRBYndCa0FHVUFiQUJwQUcwQWFRQjBBR1VBY2dCZkFI?=
 =?us-ascii?Q?WUFNQUF5QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFB?=
 =?us-ascii?Q?QUlBQUFBQUFKNEFBQUJqQUhVQWN3QjBBRzhBYlFCZkFITUFjd0J1QUY4QWN3?=
 =?us-ascii?Q?QndBR0VBWXdCbEFGOEFkZ0F3QURJQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBRUFBQUFBQUFBQUFnQUFBQUFBbmdBQUFH?=
 =?us-ascii?Q?UUFiQUJ3QUY4QWN3QnJBSGtBY0FCbEFGOEFZd0JvQUdFQWRBQmZBRzBBWlFC?=
 =?us-ascii?Q?ekFITUFZUUJuQUdVQVh3QjJBREFBTWdBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQVFBQUFBQUFBQUFDQUFBQUFBQ2VBQUFBWkFCc0FIQUFYd0J6QUd3?=
 =?us-ascii?Q?QVlRQmpBR3NBWHdCakFHZ0FZUUIwQUY4QWJRQmxBSE1BY3dCaEFHY0FaUUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
x-dg-reftwo: =?us-ascii?Q?QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFI?=
 =?us-ascii?Q?UUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFC?=
 =?us-ascii?Q?c0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFB?=
 =?us-ascii?Q?QUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJ?=
 =?us-ascii?Q?QVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUJRQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
 =?us-ascii?Q?ZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIQUFjZ0J2QUdvQVpRQmpBSFFB?=
 =?us-ascii?Q?WHdCakFHOEFaQUJsQUhNQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBSjRBQUFCdEFHRUFjZ0Iy?=
 =?us-ascii?Q?QUdVQWJBQnNBRjhBZEFCbEFISUFiUUJwQUc0QWRRQnpBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUVB?=
 =?us-ascii?Q?QUFBQUFBQUFBZ0FBQUFBQSIvPjwvbWV0YT4=3D?=
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|CO1PR18MB4796:EE_
x-ms-office365-filtering-correlation-id: 113093cc-a92f-4325-8c78-08db3079805e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pHBzbSaza1PdLu9THnfzaplG0MVo2G3z3ObXTHT93VvpZP+Idx5WVRhSJ1Dv+Thk6kGUB3x26sNz5DcO/ahII/NcPMrDxXpBIoeuhVbrioWP4CP/K20tNSmRF7gsk6lMAZtBbnImhlEjVQ9JmjGbeF/MdQVkPrOp9oPfBkRIdc9F72v3n0DLYNQ5UO7H87U8NwHQkWHLxJp9TyWdWQXZrkSBTsbP1q6vGZH2hbU5i5vQz4LWoSo3CTfw/oeY0n/TlmpHuzjFxRITZs3FZhIHzblNvFJqCe/YDtn/nafgkoIW6DTy2Wr+27YLxBkdmZOjILVYo7RYdc5Vg1fqCMtS88I6Uch7VcQs86CdzorjKeP+nPVy2gDpDZ96dhQNYKJfqZjBzvl4HZsEWYK0nV1KJrjs5Qr5ufD+QIf8icuEP1yzVmAYCYzaXumTnp6lGx8w3ZjZxqvS216C3rkN7jExeXewK9Nk3G6bp7lcm16hUbRQrRA11SsFBXwcqJFJuwXL1RQhCU/hJjXo2L7Jr8aycCt+urJ6FPxT0+S9wt/Eq7nqs9uB+FsVF2bMIYdQWS4sxKLrJfzACQGwCD24rxtCvumf1u5EKC0XiHU93xXm7dQjs9iR0Sf5V9rnvfpDn+6I
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(366004)(346002)(451199021)(71200400001)(2906002)(38100700002)(33656002)(7696005)(66446008)(64756008)(8676002)(66476007)(6916009)(41300700001)(66946007)(66556008)(76116006)(316002)(54906003)(4326008)(478600001)(122000001)(5660300002)(7416002)(55016003)(83380400001)(38070700005)(186003)(52536014)(86362001)(6506007)(26005)(9686003)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?uX25M0MsZ1MIf6j+TA5b8P/oPAsjsIQcTVbZYA6rnuz+21Ych0VJbSB6lKC2?=
 =?us-ascii?Q?Mb3h7B16qaiSO2dj3cRdO/jhJCZXlLchgc2ZHchApKuFIBWZ97nQ2ovbF+0A?=
 =?us-ascii?Q?yedMtBDF2NPuIkCmDalbOfxppbbmNTJ0uOxqJh8TasGjxZ1rH8slK2OTa/3W?=
 =?us-ascii?Q?wECW14GI/5vd9Z2TlYCPi2PWOIJU2kLKTdoQf7izCeozZNq/LnrUt0Ap2EbH?=
 =?us-ascii?Q?uq6pRNVsP7PVUDMx6yEmTJjsv3aq45J7Jx8O42tc1znX2N9ttSQ1dn2uG4zz?=
 =?us-ascii?Q?ELJHRuaKuui7yv61ts0gfZXqCZwhfd/GFkhmHtU51mCHVzSf41t2LFl30dRI?=
 =?us-ascii?Q?KhGB7zPOUW9+kzrmxfoUkE8WrOgSUrcZaYm5NsdKXAZ9oCcMnJ/Cy3nqydGQ?=
 =?us-ascii?Q?Viq9QGpAfe/H6NcQykw/l//AeIfvqcVoMAq2QL4xUP9Rtdvs9T6TV0q6E/3A?=
 =?us-ascii?Q?W/rr15zb2D6AkCrFbpEng5l+7Mw+38ElPW/RfOFgFe39iTt9U6spFWphOPqu?=
 =?us-ascii?Q?ENQrXscRZKmTtO1eS1WxW4rGD+BoNZFa03a8TUTv8yqllLRwloyh7l4/Wlxs?=
 =?us-ascii?Q?ORDvXPyqymNUgy4oZ3zuOO6Jc2AQJfHNPTmBtm+gglasIyxahNNDzPXYw9ou?=
 =?us-ascii?Q?SyAlqvmOyiRInhweofxHIBrIEFi4bJlPaiwLKiQ1+zgaP2UMrN12SfggLt+W?=
 =?us-ascii?Q?x6GUOb+a0fn3O9dFL9hdcgVq+cgqr8u6nriXjgGXWC1a0DsyDQeNBOVQKrNM?=
 =?us-ascii?Q?gH6/lDvRvLJBIAb1JDvCurdw452KfyNSXAXGy7NlmIwBE8SunX9nka3979de?=
 =?us-ascii?Q?5iw7YHZFXrkESw/sFVw4jjHijFh5N+/S6m8GCE17BhnvPplf4Iyk4xj24Yyz?=
 =?us-ascii?Q?C0G+A6DjZ9Hh3zCgLou5Ugqd2m5z6vmdOGEORcuC3IQhHqfbEIO4D4QMbTry?=
 =?us-ascii?Q?h7XMRTUkyewPjSHgpdYdDlfQMYJPSUpc/rsn+S76FN5r4Tytvxo1TfIA3w2r?=
 =?us-ascii?Q?3LSAj+nnWdl+cx+hnh9PFFfoC/AfF+JHmkz6cWgOcDbjH31j6VQ2G0fGN0us?=
 =?us-ascii?Q?YLXrk6wnTmDEQGbpeyfzVPOXR4lw0nGI+MqnWT5AyH5G6EostO8q2VoEEWGC?=
 =?us-ascii?Q?hlvJOamOsAO0U3lvxBGyNyLMMPGqRlfa/C8bNHtKiX757ty7FcxQM4Ai2qSN?=
 =?us-ascii?Q?2BSBvScxItV6FOV/447pvxPhB33liGMgZeDZgYV+nOiKywofhxQwmxiUuQir?=
 =?us-ascii?Q?QmMv1brJgpMKN5ufN9jPDyTRkMOg4sLYlSpIplEAP/d5djD/OB51bpeJ+EiI?=
 =?us-ascii?Q?QPt9NjKqOl/Pee4qtaUqTItpzA1QuIS5hySLgXMOyV1VIGcP+NYrNZQWOVBd?=
 =?us-ascii?Q?qNTsl7ZIRmZrTaJ4oTU7K0ev6cM9mQOH9jq2FSoaeLFTjR5tfOvQNVSZ9kdP?=
 =?us-ascii?Q?Sf/KO2KkudfGdLIHGLhnTbBRaIirlSDXMQhn6saybJQcM++RcscEI/f8+Yqg?=
 =?us-ascii?Q?CDyyyVL1yuge8YfzCvXaHAi0HyYpeUpTI65LPR/aBzIgaJDw4+1exYV8SXG4?=
 =?us-ascii?Q?T6XQyTslDRXv449xJ8k=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 113093cc-a92f-4325-8c78-08db3079805e
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 17:17:40.5858
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nPCp7uWja9F5ndBiSODvyByliwLfP9YeFQ2So3oMMWS+6BAw8hoTI1fvidriVZlu8k89um4+HsoWsWIkDJX9fQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4796
X-Proofpoint-ORIG-GUID: dMRQu_jnaXauiWhA_C56yBqOX4DK4X5j
X-Proofpoint-GUID: dMRQu_jnaXauiWhA_C56yBqOX4DK4X5j
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_10,2023-03-28_02,2023-02-09_01
X-Spam-Status: No, score=-0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review, will address issues in next version.

Thanks,
Hariprasad k

> On Sun, Mar 26, 2023 at 11:42:44PM +0530, Hariprasad Kelam wrote:
> > From: Naveen Mamindlapalli <naveenm@marvell.com>
> >
> > This patch registers callbacks to support HTB offload.
> >
> > Below are features supported,
> >
> > - supports traffic shaping on the given class by honoring rate and
> > ceil configuration.
> >
> > - supports traffic scheduling,  which prioritizes different types of
> > traffic based on strict priority values.
> >
> > - supports the creation of leaf to inner classes such that parent node
> > rate limits apply to all child nodes.
> >
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
>=20
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>=20
> > ---
> >  .../ethernet/marvell/octeontx2/af/common.h    |    2 +-
> >  .../ethernet/marvell/octeontx2/nic/Makefile   |    2 +-
> >  .../marvell/octeontx2/nic/otx2_common.c       |   35 +-
> >  .../marvell/octeontx2/nic/otx2_common.h       |    8 +-
> >  .../marvell/octeontx2/nic/otx2_ethtool.c      |   31 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   56 +-
> >  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |   13 +
> >  .../ethernet/marvell/octeontx2/nic/otx2_tc.c  |    7 +-
> >  .../net/ethernet/marvell/octeontx2/nic/qos.c  | 1460
> +++++++++++++++++
> >  .../net/ethernet/marvell/octeontx2/nic/qos.h  |   58 +-
> >  .../ethernet/marvell/octeontx2/nic/qos_sq.c   |   20 +-
> >  11 files changed, 1657 insertions(+), 35 deletions(-)
>=20
> nit: this is a rather long patch.
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
>=20
> ...
>=20
> > @@ -159,7 +165,7 @@ static void otx2_get_qset_stats(struct otx2_nic
> *pfvf,
> >  				[otx2_queue_stats[stat].index];
> >  	}
> >
> > -	for (qidx =3D 0; qidx < pfvf->hw.tx_queues; qidx++) {
> > +	for (qidx =3D 0; qidx <  otx2_get_total_tx_queues(pfvf); qidx++) {
>=20
> nit: extra whitespace after '<'
>=20
> >  		if (!otx2_update_sq_stats(pfvf, qidx)) {
> >  			for (stat =3D 0; stat < otx2_n_queue_stats; stat++)
> >  				*((*data)++) =3D 0;
>=20
> ...
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
> > b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
>=20
> ...
>=20
> > +static int otx2_qos_update_tx_netdev_queues(struct otx2_nic *pfvf) {
> > +	int tx_queues, qos_txqs, err;
> > +	struct otx2_hw *hw =3D &pfvf->hw;
>=20
> nit: reverse xmas tree - longest line to shortest -
>      for local variable declarations.
>=20
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
> > b/drivers/net/ethernet/marvell/octeontx2/nic/qos.h
>=20
> ...
>=20
> > +struct otx2_qos_node {
> > +	struct list_head list; /* list managment */
>=20
> nit: s/managment/management/
>=20
> > +	struct list_head child_list;
> > +	struct list_head child_schq_list;
> > +	struct hlist_node hlist;
> > +	DECLARE_BITMAP(prio_bmap, OTX2_QOS_MAX_PRIO + 1);
> > +	struct otx2_qos_node *parent;	/* parent qos node */
> > +	u64 rate; /* htb params */
> > +	u64 ceil;
> > +	u32 classid;
> > +	u32 prio;
> > +	u16 schq; /* hw txschq */
> > +	u16 qid;
> > +	u16 prio_anchor;
> > +	u8 level;
> > +};
> > +
> >
> >  #endif
>=20
> ...
