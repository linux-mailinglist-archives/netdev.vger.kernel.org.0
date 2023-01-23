Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D16A67827E
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 18:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjAWRD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 12:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjAWRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 12:03:18 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D86B7EE6;
        Mon, 23 Jan 2023 09:03:17 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30NEEhBD026059;
        Mon, 23 Jan 2023 09:03:05 -0800
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2168.outbound.protection.outlook.com [104.47.59.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3n8e9swkbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Jan 2023 09:03:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SOqMGJgMk/n/EpTtZ9P0KIshgsEsZhQO3Kk3t7Nx83TvE30iIStjAWrdYrsf+DIS1DeiX07WS3T1Qs53J7473uOOgKciEKiw37ANEuAYu9Y3wp1MSqCeIVnFMd0Z9SZ+yxwk2tz2oDxJC89re3xXOiRdwdkoMkBX4+D3w6vlXMNDH1SNzIuSMxDt8XJ1s7GzCj+8/brV3i2nYINX6DQ1275tQ1Lisv3VVKsqTKNbQ4hqP3LFSCpdrtO5PEAY4A21AhMchl87i+Vq4XkH0aECEjbHbUfx4aFrXYaGHoWXef6YglvVlisydUcScneGDppkgc83qZSmS/sPrZ++I45iFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0JlsK9hPWfHIm686g8gk+RNNx205vOFK2/oBNhzGyjA=;
 b=iTMoKXbMjpsdbQlnvg9B4bkwIcpNYXkKXb3ErKmHVBIGllqphW9+7jylmI+QARQh3GIPwo3GJjryAjYOMcXy7jE9Ynd9ecDlP/OpkKCabvF13n9iGhx39F7odXArGmJPuURi8mbctN56xCC/y9X5r1I//Fg0L3i2R/z5VthsH1BaFD/bwIzm8MLnl7A2QlPoaLEzJxZ3tiP9cRtD9c3bA+MTHKzONUYPs2uvkOq7inEK271eZF8Yimtn2UuRzgJdP5pYl8fd/D4fcd4Rxdavtlci4ZsobeqIxe26XdHsC8AvUy5u+hr8c0StY3X4qFnYrz+nX+KG6RKUs08zhN8JzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0JlsK9hPWfHIm686g8gk+RNNx205vOFK2/oBNhzGyjA=;
 b=MT0qXVYCJqT9UIsxsbwqJuiwX5AA4AqDdzlfHnInRdRFc5fnXIJvy64VF9nukBQg/utjuSPXO2E/b+JodztX6vVbY51l454jVrYMSFZxIi//S/vkQxMeTDd8g2Bf9TKEV1MQPaNMPExg0qXm/rwe9lv9U4LgmnpJghBFZd+MLfQ=
Received: from PH0PR18MB4474.namprd18.prod.outlook.com (2603:10b6:510:ea::22)
 by BN9PR18MB4362.namprd18.prod.outlook.com (2603:10b6:408:100::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:03:02 +0000
Received: from PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e]) by PH0PR18MB4474.namprd18.prod.outlook.com
 ([fe80::e6ca:f949:a109:b83e%2]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 17:03:02 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Maxim Mikityanskiy <maxtram95@gmail.com>
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
        "hariprasad.netdev@gmail.com" <hariprasad.netdev@gmail.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: Re: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Topic: [net-next Patch v2 4/5] octeontx2-pf: Add devlink support to
 configure TL1 RR_PRIO
Thread-Index: AQHZL0yNZq/codrNv0Szoe9H0a3AXA==
Date:   Mon, 23 Jan 2023 17:03:01 +0000
Message-ID: <PH0PR18MB44741D5EBBD7B4010C78C7DFDEC89@PH0PR18MB4474.namprd18.prod.outlook.com>
References: <20230118105107.9516-1-hkelam@marvell.com>
 <20230118105107.9516-5-hkelam@marvell.com> <Y8hYlYk/7FfGdfy8@mail.gmail.com>
 <PH0PR18MB4474FCEAC4FA5907CAC17011DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y8qZNhUgsdOMavC4@mail.gmail.com>
 <PH0PR18MB4474DBEF155EFA4DA6BA5B10DEC59@PH0PR18MB4474.namprd18.prod.outlook.com>
 <Y803rePcLc97CGik@mail.gmail.com>
In-Reply-To: <Y803rePcLc97CGik@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-rorf: true
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcaGtlbGFtXGFw?=
 =?us-ascii?Q?cGRhdGFccm9hbWluZ1wwOWQ4NDliNi0zMmQzLTRhNDAtODVlZS02Yjg0YmEy?=
 =?us-ascii?Q?OWUzNWJcbXNnc1xtc2ctYzgwYWI2N2QtOWIzZi0xMWVkLWI2ZDMtZDQzYjA0?=
 =?us-ascii?Q?N2UyYjlkXGFtZS10ZXN0XGM4MGFiNjdmLTliM2YtMTFlZC1iNmQzLWQ0M2Iw?=
 =?us-ascii?Q?NDdlMmI5ZGJvZHkudHh0IiBzej0iNjQyMCIgdD0iMTMzMTg5NjY5NzY5ODk5?=
 =?us-ascii?Q?ODQ3IiBoPSJsZlEyTzhsL243bG5xaUFMaDc2bFlwUHVLaWM9IiBpZD0iIiBi?=
 =?us-ascii?Q?bD0iMCIgYm89IjEiIGNpPSJjQUFBQUVSSFUxUlNSVUZOQ2dVQUFOZ0hBQUJI?=
 =?us-ascii?Q?NzJLS1RDL1pBUzVJZ1dPUUswYUVMa2lCWTVBclJvUU1BQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBSEFBQUFCb0J3QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?RUFBUUFCQUFBQTNUekZBQUFBQUFBQUFBQUFBQUFBQUo0QUFBQmhBR1FBWkFC?=
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
x-dg-reftwo: QUFBQUFBQUFBQUJBQUFBQUFBQUFBSUFBQUFBQUo0QUFBQmtBR3dBY0FCZkFIUUFaUUJoQUcwQWN3QmZBRzhBYmdCbEFHUUFjZ0JwQUhZQVpRQmZBR1lBYVFCc0FHVUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFFQUFBQUFBQUFBQWdBQUFBQUFuZ0FBQUdVQWJRQmhBR2tBYkFCZkFHRUFaQUJrQUhJQVpRQnpBSE1BQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBUUFBQUFBQUFBQUNBQUFBQUFDZUFBQUFiUUJoQUhJQWRnQmxBR3dBYkFCZkFIUUFaUUJ5QUcwQWFRQnVBSFVBY3dBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQkFBQUFBQUFBQUFJQUFBQUFBQT09Ii8+PC9tZXRhPg==
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR18MB4474:EE_|BN9PR18MB4362:EE_
x-ms-office365-filtering-correlation-id: 633b58f6-b5f9-476d-b806-08dafd63afcc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bQavtia1qyvLOTgSlqQX93GXuMavWVrAaXqlnuGfsOzuQ1peQvQmXs5M4SNIIxpRMCUt8Fniwk/yZfdGxnmVGndlN5ZpSQmeRu5T/kBQCM+WKjrEE8vDf08+opWqbNMfvXsUH3bT3kbXo+k8bfYd4OYQvjZebKKItzVmwYSSzhjE9rCFcW3Oa3Tej5FCPtz9tGs0RZZjJ1zSZnOXlZevmSRByX6ucwnEhwo94hK0vXB9AMGzB7JnDBDURGOpD1gRcKmG8VJRLGMsxZ/OUzkne1KrNzIITDkXt2Ve9fm2A0YmssXs3IjFdxFTtCmWTCtCqshP21r+BfjlfzY56DlZxXntqtXtbqxwI9gOyVQXt1MjGPwg88gsd86BK2/7UbHttg7XIU2Cdgj1boYpfur9xyLTVm+QGbnFd3b8Xc3RDJy4SeV8xmXyTUKFIInFdnOZlhUM6bcCf6aEH0E3FC3OHL1SFvawtBUwy8IT1KecesClp1zXzAzHxiG7fSF5ZexDe287Mn6wntuseWkqTGoVzAQTWf9vNmUX2Q19tEzSVkP3Tm2frP8fqsTm1zd118KM2KBmhYE2Am1SMEaiZ9PZ2GcDqMPNT8xiUfa0tif4BMrldGn+TEl8q083SMcCkjvibBp5IDsmwkfzjTOqPBRr6XrLBw32diT23ImK1CLVG4KTGKGpMI3AvIr1iF9lX+FGawSK0E/dkbdV79a6IQ3CUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4474.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(451199015)(86362001)(2906002)(38070700005)(76116006)(33656002)(316002)(54906003)(64756008)(83380400001)(107886003)(6506007)(7696005)(478600001)(71200400001)(9686003)(186003)(26005)(7416002)(52536014)(8936002)(38100700002)(5660300002)(66946007)(55016003)(122000001)(4326008)(8676002)(66476007)(66446008)(66556008)(6916009)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iPuddEUtd2hO73Vdph73dI85fpim1S0IS+ilzVs5SMOkPSyUFSSHu2FlMhHx?=
 =?us-ascii?Q?bBTf20XUmJM8zGT84+hmieu/2bjkJD38nTpO2PjSZGpK+vXvEJV0TgN8x8c4?=
 =?us-ascii?Q?y/sWNsxtbtpc/YosbACXg1kt19wQ3j+5f7eVBaCBzUY493C83LYhLVL5OVx1?=
 =?us-ascii?Q?62z4CDzbYcCOBMf6NgIFGOiF69X3Z8xe52cPENZ4BycJZDQjTmdPJ04scSEo?=
 =?us-ascii?Q?4u/77NCOyXFNE5185x0VsV65iSZDrEMybMIhiO0b/HxiUiy0Muuix9K6E7SN?=
 =?us-ascii?Q?KrKTWZUMGnebr494YN1uhWMDGdZc1MoSl45y1pAra0RUmtDTiLeP6RwrXr6M?=
 =?us-ascii?Q?Q3UFQBjizseDIIEd1W2sA/lqhfrGmyDw4AppcRMWQXwHtU8KetrcjXnfzKTO?=
 =?us-ascii?Q?Wz090wdLeO03DvWnB73mbdcn8N1Oe/JYjXsja/+LAgZw/Wj+Zi7ruEbgBSW9?=
 =?us-ascii?Q?YkGhWSY8luqZoV0XyV4b+SFn/hSrexAFml4nfgAUm42huVZJDTKeEVbxhbpr?=
 =?us-ascii?Q?92bNNzYlZaI0PFmVyRdq/h2dNgGBm6yGy+Ku0ipL8DZFm3QrJcit7WweGFXb?=
 =?us-ascii?Q?OeuwCDf9Q+DN2x3lPbNUzQAPllYlCRAf35kdjMyDrbpY7rr9SoG0Uc8voGwC?=
 =?us-ascii?Q?bK9oWjfHNE20Q0WM5PlWp0pk3cTGCPbtXk5uSOGvNB6+flFtmVe6TDOpYKJS?=
 =?us-ascii?Q?Rjv/G1Up/sTciBpiFToC2BvYaB5aG8SjCAmmJOYiaueaaL8W1l9mfHjJTRBQ?=
 =?us-ascii?Q?ny9OLrLpVBunpytyE15gYP//oMqF163sdJDaZgWlA6NhipvQ+naHeGeIBRJ8?=
 =?us-ascii?Q?/CNO4tINv803s70/7MT4YFH4jUU7RvLxW1nxBoA+2+tOaW3dbutfGsJTcrbZ?=
 =?us-ascii?Q?AcdcE/x392ja32KiF5bb827iwdKYL5Lt9F54Mwai7F3NzvvhgfMqnPSRRjw7?=
 =?us-ascii?Q?AXJC15ntAaWofdQHpXsZ5Dw/WaI5dsv8n3I8ryuWQit0/dm+bBfu7vBCvP4c?=
 =?us-ascii?Q?MEAjtMLKVFDsTYD1AeJkY/Z/fX6qWw/MwTuF/daKT8GSyGSAGqS+32vcah9F?=
 =?us-ascii?Q?WCuKHyQMlGkPZyurWQmgr10vCNxI7ys065ySNNJMO1fpduc8t6O5cRmLgU2u?=
 =?us-ascii?Q?sW+srOYH5V41NbGIQn6IxUzTCpsAUs71pfHqbAP6ID14XUWLsFj5Nan08bxw?=
 =?us-ascii?Q?5vT2WxGZ5/A+JGw/KSK1O7sze9+vvcRvnHGz8QjIKA9mbSW9I3Zl6LFz/LLC?=
 =?us-ascii?Q?EB1TWsX+RBRyAKQ0ZwimiJoKVi6+PBpRhcs5nqjkVsnsXLH7SWBnQxmP4wmv?=
 =?us-ascii?Q?OoqxMcRAxbcWRkgkLEJmzhjOnWnlgiigxVElYl2hL5C4prEDe0LcAw/LaQSf?=
 =?us-ascii?Q?X9rdYCda9neE95hCRX8vhU0VYMRR2WOxQahGdQSGBBH0xL85gU2g8u6d1+vK?=
 =?us-ascii?Q?6khEWZGExl106ldgjRsylbUpeZRvph2tpGPUxINLGWZxuk9i90QoAuIizHwG?=
 =?us-ascii?Q?yHaCDFbh9pYNtJw7F0GL3EJpiGSR0yiWdEIY2d69bycQCBSi8X6HiE7UGslC?=
 =?us-ascii?Q?bCjezUQ6/JO59tVr+o4JYUFLZ95snjjukz79WqA8?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4474.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 633b58f6-b5f9-476d-b806-08dafd63afcc
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 17:03:01.8740
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jj8yhDBDUxVF1Wt0IUfIPtHIWixF4avrSCRqUEG2u+63Il3IkDRV42GgSNymX+rX0PERU2tqe5m/g8duUXw//Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR18MB4362
X-Proofpoint-ORIG-GUID: KHzH7Zuax8HqnrUrFN7nehzTg7fNPU8H
X-Proofpoint-GUID: KHzH7Zuax8HqnrUrFN7nehzTg7fNPU8H
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-23_12,2023-01-23_01,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>=20
> On Fri, Jan 20, 2023 at 08:50:16AM +0000, Hariprasad Kelam wrote:
> >=20
> > On Wed, Jan 18, 2023 at 04:21:06PM +0530, Hariprasad Kelam wrote:
> > > All VFs and PF netdev shares same TL1 schedular, each interface PF=20
> > > or VF will have different TL2 schedulars having same parent TL1.=20
> > > The
> > > TL1 RR_PRIO value is static and PF/VFs use the same value to=20
> > > configure its
> > > TL2 node priority in case of DWRR children.
> > >=20
> > > This patch adds support to configure TL1 RR_PRIO value using devlink.
> > > The TL1 RR_PRIO can be configured for each PF. The VFs are not=20
> > > allowed to configure TL1 RR_PRIO value. The VFs can get the=20
> > > RR_PRIO value from the mailbox NIX_TXSCH_ALLOC response parameter agg=
r_lvl_rr_prio.
> >=20
> > I asked this question under v1, but didn't get an answer, could you she=
d some light?
> >=20
> > "Could you please elaborate how these priorities of Transmit Levels are=
 related to HTB priorities? I don't seem to understand why something has to=
 be configured with devlink in addition to HTB.
> >=20
> > SMQ (send meta-descriptor queue) and MDQ (meta-descriptor queue) are th=
e first transmit levels.
> > Each send queue is mapped with SMQ.
> > =20
> > As mentioned in cover letter, each egress packet needs to traverse all =
transmit levels starting from TL5 to TL1.
>=20
> Yeah, I saw that, just some details about your hardware which might be ob=
vious to you aren't so clear to me...
>=20
> Do these transmit levels map to "layers" of HTB hierarchy? Does it look l=
ike this, or is my understanding completely wrong?
>=20
> TL1                 [HTB root node]
>                    /               \
> TL2          [HTB node]         [HTB node]
>             /          \             |
> TL3    [HTB node]  [HTB node]   [HTB node]
> ...                       ...
>=20
> Transmit levels to HTB mapping is correct.
>=20
>=20
>=20
> > This applies to non-QOS Send queues as well.
> > =20
> >                        SMQ/MDQ --> TL4 -->TL3 -->TL2 -->TL1
> >=20
> > By default non QOS queues use a default hierarchy  with round robin pri=
ority.=20
> > To avoid conflict with QOS tree priorities, with devlink user can choos=
e round-robin priority before Qos tree formation.
>=20
> So, this priority that you set with devlink is basically a weight of uncl=
assified (default) traffic for round robin between unclassified and classif=
ied traffic, right? I.e. you have two hierarchies (one for HTB, another for=
 non-QoS queue), and you do DWRR between them, according to this priority?
>=20
>=20
>  Not exactly, In the given scenario where  multiple vfs are attached to P=
F netdev.
>  each VF unclassified traffic forms a hierarchy and PF also forms a hiera=
rchy for unclassified traffic.
> =20
> Now traffic from these all tress(multiple vfs and PFs) are aggregated at =
TL1. HW performs DWRR among them since these TL2 queues (belonging to each =
pf and vf netdevs) will be configured with the same priority by the driver.
>=20
> Currently, this priority is hard coded. Now we are providing this as a co=
nfigurable value to the user.
>=20
> Now if a user adds a HTB node, this will have strict priority at TL2 leve=
l since DWRR priority is different this traffic won't be affected by DWRR u=
nclassified traffic.

So, did I get it right now?

                                     [strict priority**]
                           /---------/                 \-----\
                           |                                 |
                        [DWRR*]                              |
        /---------------/  |   \---------------\             |
        |                  |                   |             |
[ Hierarchy for ]  [ Hierarchy for  ]  [ Hierarchy for  ]    |
[ unclassified  ]  [  unclassified  ]  [  unclassified  ]    |
[traffic from PF]  [traffic from VF1]  [traffic from VF2]    |
[      ***      ]  [      ***       ]  [      ***       ]    |
                                                             |
                                                [HTB hierarchy using]
                                                [  strict priority  ]
                                                [   between nodes   ]



        Adjusted picture

                        /--------------------------------------------------=
------------------------------/       Transmit level 1
                            |                                              =
                                        |=20
                        [DWRR*] [ priority 6 ]                             =
         [strict priority** ]      [ priority 0 ]  Transmit level 2
        /---------------/  |   \-----------------------------------\       =
                    |
             |                   |                                   |     =
                                      |
[ Hierarchy for ]  [ Hierarchy for  ]  [ Hierarchy for  ]                 [=
 Hierarchy for  ]=20
[ unclassified  ]  [  unclassified  ]  [  unclassified  ]                  =
    [ strict priority  ]
[traffic from PF]  [traffic from VF1]  [traffic from VF2]  =20
[      ***      ]  [      ***       ]  [      ***       ]   =20
                                               =20


As far as I understand, you set priorities at ***, which affect DWRR balanc=
ing at *, but it's not clear to me how the selection at ** works.
Does the HTB hierarchy have some fixed priority,  ?

Hardware supports priorities from 0 to 7. lower value has high priority.
nodes having the same priority are treated as DWRR childs.

i.e. the user can set priority for unclassified traffic to be higher or low=
er than HTB traffic?

Yes its user configurable, unclassified traffic priority can be higher or l=
ower than HTB traffic if a user wishes to configure it.

Please also point me at any inaccuracies in my picture, I really want to un=
derstand the algorithm here, because configuring additional priorities outs=
ide of HTB looks unusual to me.

  Please check the adjusted picture. Let us assume a user has set the prior=
ity as 6 for DWRR (unclassified traffic)  and  HTB strict priority as 0.
Once all traffic reaches  TL2,  Now hardware algorithm first pics HTB stric=
t priority and processes DWRR later according to their priorities.

>=20
> Thanks,
> Hariprasad k
