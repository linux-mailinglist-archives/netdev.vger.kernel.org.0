Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6A693868
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 17:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbjBLQUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 11:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBLQUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 11:20:00 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6BCCDDF;
        Sun, 12 Feb 2023 08:19:59 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CFnsXi024735;
        Sun, 12 Feb 2023 08:19:39 -0800
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3np98ujaa7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 08:19:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j2Ya+ygwy2lcM8B2PhH0hgFMP31gxGFFIuXaKHL7xKF/SBCeuiuTJfppYwykv37Uvk0fGJWhZZp8/C9Ll972pq09fz5ehmkZeoCD4LkFEqj5iahrbtxF41Y8OsMhOiF3h0P7jGgiOg3Vnd81pi3k9EtcHgSu+m0aV6UttsEp2Q2kV7gjmlnKywBQFcF94yarl2ausVTM+ZzSBxv6RvqGqRjbXvrZ0sA3o9uXICaaneFr6SU59NPdPCIUBc0ZgyH/n1NyibGWWpf+QXAUplqwNjk2/2JNrVftksBPBMImazqwuLQ5lFzY96sOYyoTa7CtqsN/PM6QdlQqM1o5rf3olg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KwpJMbGpGdFTBBG0auKAqH2J2hTiZrgvBwXlk4CpKRA=;
 b=gLpSSkrCFWXAipAujBpRTIQ9bp9vZYqAs/chctfJg4lVahr2kKGX84uOkHjwNQNI2Cy1GDDf4jtFi4R9VBdQf7aQHiHt3b2mZld3UpGyexuKEmDVAYTGYQheB9mDcRomODZoaHOIqu/hjWvZkVeba3xUJj9BQ0cQiV9T0v/yYP28Ldq2EHWyjZyYWIgDE4+Qvrm6/rZzKr5pMMxfbL2qaXPEuxCkTOe5UC/p0bcFemnVC9pYazSBNnovHBM/IuvgB8WsPyjuarhnxMaYKioSzPkrQ0J0R1GUFE3Egdn3ZutClfyuLfa6rUX1VuODNx5ceuUjTy4wszUumwKJ3/mUEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KwpJMbGpGdFTBBG0auKAqH2J2hTiZrgvBwXlk4CpKRA=;
 b=fvLSzCx7u/VhoWQfOkz6uDqYHAU2pOYEJsNxIiB7Jw1s1arWdIAskFVWl5LttIp6EWyEdSJiU4eEbatQsaqU8fXLMLZM8RqByL6HgrJI0g0bSyDVfGUrSfms2QYduA7+I14MPd2OL8OP8QEIDk+pxc0eEdfbJvmQKyla2+3yDSo=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by DS0PR18MB5477.namprd18.prod.outlook.com (2603:10b6:8:162::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 16:19:26 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 16:19:26 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Simon Horman <simon.horman@corigine.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "maxtram95@gmail.com" <maxtram95@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>
Subject: Re: [net-next Patch V4 1/4] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Topic: [net-next Patch V4 1/4] sch_htb: Allow HTB priority parameter in
 offload mode
Thread-Index: AQHZPv3G3JptYvJTH06gQoPeAlW8cw==
Date:   Sun, 12 Feb 2023 16:19:26 +0000
Message-ID: <PH0PR18MB4474ACB4E8103A05AE160B17DEDC9@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230210111051.13654-1-hkelam@marvell.com>
 <20230210111051.13654-2-hkelam@marvell.com> <Y+ZF4k8+CidOG75r@corigine.com>
In-Reply-To: <Y+ZF4k8+CidOG75r@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctMDI3Y2U2MzItYWFmMS0xMWVkLWI2ZDQtZDQzYjA0?=
 =?us-ascii?Q?N2UyYmEwXGFtZS10ZXN0XDAyN2NlNjM0LWFhZjEtMTFlZC1iNmQ0LWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmJhMGJvZHkudHh0IiBzej0iMjUzMSIgdD0iMTMzMjA2OTIzNjM0MzU4?=
 =?us-ascii?Q?OTI4IiBoPSJ1RkcvSEoxV2tPRHl2NFJkb0pJMVN5NjFMTms9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFIWUlBQUNR?=
 =?us-ascii?Q?T3RuRS9UN1pBYzZJL1hKS2lucnh6b2o5Y2txS2V2RU5BQUFBQUFBQUFBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFB?=
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
 =?us-ascii?Q?QUFBQUFBQUFBQUJnQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFD?=
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
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|DS0PR18MB5477:EE_
x-ms-office365-filtering-correlation-id: c67ce555-5063-466a-72dc-08db0d14e928
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eam4hyA+bk8IaYeVB1yhJfoaxkNBQ8S/JhL6I8OfZomtCUcOYbN9P49+fbJ1k7LjRp8YhBGzD0ajhu8qoy8nkMB5CoNq5zWsZ9KY72h8w3RcuiDJWv7m7AQwv7WhwjsoYvsXzspHEOVViEKooZmUftVSIxido1sDp61bG0jLnTJXRXXwqm11TbuLEXEW3ejNf53b1UMgWlrwP4wGIRxyOxu/ELluXnEgvMqeaf4YBK8rdfGHZhWZOtza+nEsY9tTTArQDg4TWN9lRKxXUS/ko8jiAjYH1ugoEuzSG7cD+0PPx8KDMxbza77zD6RqcgKyFjYkDMYo4Kq/kx/jyIDbBZnaSDypwf9IlZGdDYF3iPPD+9V76UAL3nebzgbV9YWhI+SdJ5hGkK1+GtOtfV2AZEpcXtBuhx8hrfwC0Jhfr3Xn6vyaTlZlD49yqoYDtk5QrkkGBVJfq29AwNog+MhwH4ft0KybrF3Zusi89H4/RuppzneSn+J3LRbWRa7c9a3o3yER7Vcdw2JtpIIKORTTndw6OjlYoykKVn5siQh3Kdybc/9jd7gk54W/nzpfewz4BEreBZBjdLF4QDwXDCVHFhV3dnmDn6hbgyuWO4x56IrODttFT0YemYUa3s61n5/uJj6VjsbSKFKJw7cNFdB9T5+Hl5CWoHnpR5UsY3FgQKqADsAGZdMrov8S8EXoLkVj0VP+EGaS6Wr1ZYnlrz7aPw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(346002)(366004)(39850400004)(451199018)(5660300002)(316002)(54906003)(52536014)(66556008)(8676002)(66476007)(8936002)(4326008)(6916009)(66946007)(76116006)(7416002)(66446008)(64756008)(71200400001)(41300700001)(2906002)(7696005)(478600001)(186003)(6506007)(9686003)(26005)(33656002)(55016003)(83380400001)(86362001)(122000001)(38100700002)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?03mECWzUi6FnPzbbDHynl/Aazu1S4dxY8WWbR8qgKpfeQiDd43hQpAw0Nurf?=
 =?us-ascii?Q?dLCgZ9fwe8WTN8rjjK3D8zG6QleVxbdKzd54AMa0ZQHNhTCp6dJ4u0UDS1P8?=
 =?us-ascii?Q?9s+heQ7w6XLKEf7RhTueFg9PdmkNeNpZUaUsHWf/jl9lV/JmICxTHM9foc/W?=
 =?us-ascii?Q?QCFyCvduHVtbaJkLxr+twam0c01B2DcYvksom16gIkixAK2TcNYLOVQc1szo?=
 =?us-ascii?Q?Wdj9sqDj0yiYvB5m1fDrVxafHiqRLSp6gAL6ucLMxys30XD5IHRGTtX0wvyy?=
 =?us-ascii?Q?NeSJAKP33EABrpWVzwYTC+grs/p+tx9kFbUpsveMuTRF94bOx8babTn+kl4N?=
 =?us-ascii?Q?puuuEJL+YaDQglSP7zhOkUr2uhh6racPWwJVBRgWL/uBF8tA6umpi49BjRqf?=
 =?us-ascii?Q?Sqctdq3Pzt5Erp92TH/WLBKDD2bUUh1rUQPfjT4H56Hz3dkDMjlL1sUr6Yyg?=
 =?us-ascii?Q?wrQ1sR6U/gJXOyi/st5ToMkySzjvgumeI3Rck0JIV1hx+sAuOkXEVTG49XhI?=
 =?us-ascii?Q?molcCFUPBpOppVpiihob15DT2odIfGdo5VP5tqQEOEO+DFYsShRTl01x1OXZ?=
 =?us-ascii?Q?8Vjs5iObfp+ZrdkE8cFOruV6sQ8SqTeQgoRvlVj61+CrJyq/rvb/1mwQuhNC?=
 =?us-ascii?Q?Q4gqnpALha8AL9iBIi72JsRMgDP6PdBSMXAX7EKPAubMZVw4ax3lRzRqC+er?=
 =?us-ascii?Q?jom07sN2INyQiZOBURJDEIDqeoU44Aal7P7uD3vR6MJZBTX76/lqBa5N+jml?=
 =?us-ascii?Q?nNJdqLP6ky2iIgDRLt/mMv08Xucdg2oeIpImDmT7xz/MQOrMDMR0eJhAZ8UW?=
 =?us-ascii?Q?isnSxnjSP1hpOiSP3UwfveBoVVO96vIMRRpAkPcHtPmwwkm+Uhbsi6YBy7Zi?=
 =?us-ascii?Q?ihu7B5nfgF/lvV33F3K1Tpt0U/ZEnFPqKl4NVa9tnPYL0u/P/IB/EemvM5VP?=
 =?us-ascii?Q?fzXcX4tMcswIz7pD2wBPKaA5/sYg2/oAdIi9W6ZFK9ITr85TdJffUbmgp5pj?=
 =?us-ascii?Q?KypUYJ7gYdFg4CqzTWQY7X5DbQle7bXdGuvG4PupMltUP0ISGYab3GRymtR5?=
 =?us-ascii?Q?8zF50jd250u2BRTjeVwZE8fEjXVs6gODuGZMt6LxCxtYWJ/EElA6vyLwdk1d?=
 =?us-ascii?Q?BCzSimIiVFsyxHyBvYO9Jx2iQZcIeuTD+2Iylp4n+4B5m/pasFQ6/SgcTfyJ?=
 =?us-ascii?Q?Vp4+X1b5rYc6MprDitq92hOxywu5uXTE8ft9kUSFxSVtNVav+kMpwfuxSmF5?=
 =?us-ascii?Q?sNTAmxlIzb2fzs3Yew7gf/qH8Vjsfyxf4DuMCdnNLxi8qN/xhjTv0DxKhAaF?=
 =?us-ascii?Q?hjsJbSXlWcLy4e1yOhv7v05ERddMbVzHqU4FY1EHa7pGyFFJwsjOCLJr7UDa?=
 =?us-ascii?Q?26T5nFuKy8S8rTLyX9HrCQMYzcctzVydo1zzp8vsehZ+4iC9WdCx4R9U1rWB?=
 =?us-ascii?Q?puoaUFjLUmmMgS3QoQOQ7uAVl7ZBFcjqgxVNkSzeXUQb2KrSaUd/c1sHA4yq?=
 =?us-ascii?Q?m0WUfKQYntO3PD6voIT+2j5pT2iVZgWLHGL9bW+b5L1MEe7Xvgp/I+tGz1zH?=
 =?us-ascii?Q?v/WcaSF3SrwPKd1N5PFRqZMQeBj8pFs11bgq3CiK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c67ce555-5063-466a-72dc-08db0d14e928
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Feb 2023 16:19:26.5150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K2G1QZXEZCohEsziO9gq6Cz6AG5bJg7ninGHEtEbOtrgDRI3VEgl6LI3Z8qlWZH9mTQQ4jQrSMPa0Cxi7dY5hQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR18MB5477
X-Proofpoint-GUID: s4BTVeZUj3Z0JU8LZs1yEeUe6hxmE-Em
X-Proofpoint-ORIG-GUID: s4BTVeZUj3Z0JU8LZs1yEeUe6hxmE-Em
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_06,2023-02-09_03,2023-02-09_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Fri, Feb 10, 2023 at 04:40:48PM +0530, Hariprasad Kelam wrote:
> > From: Naveen Mamindlapalli <naveenm@marvell.com>
> >
> > The current implementation of HTB offload returns the EINVAL error for
> > unsupported parameters like prio and quantum. This patch removes the
> > error returning checks for 'prio' parameter and populates its value to
> > tc_htb_qopt_offload structure such that driver can use the same.
> >
> > Add prio parameter check in mlx5 driver, as mlx5 devices are not
> > capable of supporting the prio parameter when htb offload is used.
> > Report error if prio parameter is set to a non-default value.
> >
> > Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> > Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> > Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> > Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> > Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en/qos.c | 7 ++++++-
> >  include/net/pkt_cls.h                            | 1 +
> >  net/sched/sch_htb.c                              | 7 +++----
> >  3 files changed, 10 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> > index 2842195ee548..b683dc787827 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/qos.c
> > @@ -379,6 +379,12 @@ int mlx5e_htb_setup_tc(struct mlx5e_priv *priv,
> struct tc_htb_qopt_offload *htb_
> >  	if (!htb && htb_qopt->command !=3D TC_HTB_CREATE)
> >  		return -EINVAL;
> >
> > +	if (htb_qopt->prio) {
> > +		NL_SET_ERR_MSG_MOD(htb_qopt->extack,
> > +				   "prio parameter is not supported by device
> with HTB offload enabled.");
> > +		return -EINVAL;
>=20
> I think returning -EOPNOTSUPP would be more appropriate here.

ACK, will fix in next version.

Thanks,
Hariprasad k
>=20
> > +	}
> > +
> >  	switch (htb_qopt->command) {
> >  	case TC_HTB_CREATE:
> >  		if (!mlx5_qos_is_supported(priv->mdev)) { @@ -515,4
> +521,3 @@ int
> > mlx5e_mqprio_rl_get_node_hw_id(struct mlx5e_mqprio_rl *rl, int tc, u32
> *hw_i
> >  	*hw_id =3D rl->leaves_id[tc];
> >  	return 0;
> >  }
> > -
>=20
> nit: This is a good cleanup. But not strictly related to this patch.
>=20
> ...
