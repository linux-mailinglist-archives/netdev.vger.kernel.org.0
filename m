Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E15619FF0B
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 22:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgDFU2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 16:28:38 -0400
Received: from mail-eopbgr20073.outbound.protection.outlook.com ([40.107.2.73]:52974
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726084AbgDFU2i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 16:28:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z2T5wGNICEoTReNtftTlbNYEM6EYNbmYRxRVTC4dONO0C12M6Lo+eIJns6kak6e0jb7QqGUoj8ZQAdxwblvByQsBjeDf+g41Q0xfnJWx3znRCwK14GkFa9jXm0+9i59DY28HWEad717igibFrhjJWjxyvgm9pvUocXaU5TYAJvf0UkUhGkJb1eaeR1mdKrUszOP8Gi5gnIsfUP7TGN+BdyUOKurWO3+l+wuLKDSs/MjMLJBnXlkg5w74jGSLAoqxqNrk7YIS4//bqPM4fJTjtsp1nS3MddQbPsX9f88FjFHlgk17N+//4ghEq82MyQgh/TWYko38eKNvcSfJImnDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL4MkUPcH1dJZukoTLW8pw7Y8NLIJJqSiAXaDuJteYw=;
 b=bCrOjh9jzDLx+e6c3WvhZpt08OTcdBZgOfo4aHjx6NiTKC+tZCxUyK4ijybk9s/USY1CRc/0BY2Pav3sZuolBFXVU9woB61h/5EFqaEb8UaccoOuCMlRlmHRzgBnHYumu6zBtDMaBTGDPxbc+DdhiqGKgrjST+uT10VXVwQeLJ06cjqCrkim+91xhwL+2ENdt1IZ0b/nRwMz9CjUaIFvTpbkqDo4UaoYaDTwJU46b1GESg4w1uW2nLNMIjTG6JxmVXG59/hqmdFAqXpbyzAdyxmZn22Io1Ggwp7np0gIPVsbNiYSfsEPXlJONScR85SktKz+G/ByKaXl0S0ik3sodQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KL4MkUPcH1dJZukoTLW8pw7Y8NLIJJqSiAXaDuJteYw=;
 b=FjodmKGIdd5HkMuCl243WENGgJvGmvprPVRKT5L5yc2NtOFMOxZA3/koTxijjo4yKeIk8biB1OcitGtlgscSHhIOKsW0EpGinA6QwU/MqLKFQV9kK0XYn7zGFuD6GRD9E6ELnwqaIgT8qXFUsz3xdKUGYOJMnLwgy8PtTyNgmkQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3291.eurprd05.prod.outlook.com (2603:10a6:7:37::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.16; Mon, 6 Apr 2020 20:28:33 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 20:28:33 +0000
References: <20200402095608.18704-1-jiri@resnulli.us> <6c15c9ec-e1e3-cf78-e2bb-9c5db8d43abc@intel.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        dsahern@gmail.com, stephen@networkplumber.org, davem@davemloft.net,
        kuba@kernel.org, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next] devlink: fix JSON output of mon command
In-reply-to: <6c15c9ec-e1e3-cf78-e2bb-9c5db8d43abc@intel.com>
Date:   Mon, 06 Apr 2020 22:28:31 +0200
Message-ID: <87imice4uo.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0063.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::40) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by AM0PR02CA0063.eurprd02.prod.outlook.com (2603:10a6:208:d2::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Mon, 6 Apr 2020 20:28:32 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37e8e4b9-8fbb-4370-5d1a-08d7da6913a2
X-MS-TrafficTypeDiagnostic: HE1PR05MB3291:|HE1PR05MB3291:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3291CF2B155DA2277CCCF9C5DBC20@HE1PR05MB3291.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(66946007)(86362001)(66556008)(52116002)(6496006)(186003)(16526019)(2906002)(478600001)(66476007)(316002)(5660300002)(6486002)(2616005)(956004)(53546011)(26005)(6916009)(107886003)(81166006)(81156014)(4326008)(8936002)(8676002)(36756003);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2N3thrSkliNC1P+P5osF8jrDWRwFgf31HQJaORbyD9JdSGG9B+WGEYAfK0YvswHTUWUY3TDJ1YJbG/vl/2wfPOLq7J8MMz8BV+AmwYEOn+MzHZr9eL9xykhbYtLIFLkIgCH2T+KZE/A24XtWwgSr6U/KSUm2Cb8lY4UPEoi1R8PpgfEU1kjK3rXlicaZHorrP/CLKWKHveKywc3/tQqN8iXgrR27xJ4BwX+Z9Be0MtMbL9Kl/AUbLG/MgOp0J0QjQPZcMLR3gxTSYDzJxeg416J8qtM4TcdPG6IeLkFfFCEboCObv4zDO1AVDk3xn/XecaXZo3BqHpsYkRaNsJPZRfVQhm81GrIejN6d1pDrWp6rgqYeRGSBQbgOg/Q/E5lYjjSmg9ViDvD15HjKsgqFBEyTxZcUdcwfjeAnqdi0AVq/4ArA3QQ/qirz/rxADVsm
X-MS-Exchange-AntiSpam-MessageData: zjbAvbermDQLME4ThVHmPl7j2OYPZ/8OTTnaAx9n/tsIMchTrh1fGsRk6T9PTGhTCOWINIaTI6ey8vIo5/T3mOR3moFSoe/faAep+0gYLiB59fhNTnBjA1IGGZDG/+GEr2RpWu47Uu1TYnEPPod8AA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37e8e4b9-8fbb-4370-5d1a-08d7da6913a2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 20:28:33.3952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FOBbcnwsMWiIOZrYDjnbewh2tNOtip3qqlsxys2p8+WOJvjkJCSIMvRZ49gxXJpy/udc4NsUl8gnZ36EUFqBaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3291
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jacob Keller <jacob.e.keller@intel.com> writes:

> On 4/2/2020 2:56 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@mellanox.com>
>>
>> The current JSON output of mon command is broken. Fix it and make sure
>> that the output is a valid JSON. Also, handle SIGINT gracefully to allow
>> to end the JSON properly.
>>
>
> I wonder if there is an easy way we could get "make check" or something
> to add a test to help verify this is valid JSON?

Simply piping to jq is an easy way to figure out if it's at least valid
JSON. In principle it would be possible to write more detailed checks as
TDC (tc-testing) selftests in the kernel.

Something like this:

    {
        "id": "a520",
        "name": "JSON",
        "category": [
            "qdisc",
            "fifo"
        ],
        "setup": [
            "$IP link add dev $DUMMY type dummy || /bin/true",
	    "$TC qdisc add dev $DUMMY handle 1: root bfifo"
        ],
        "cmdUnderTest": "/bin/true",
        "expExitCode": "0",
        "verifyCmd": "$TC -j qdisc show dev $DUMMY | jq '.[].kind'",
        "matchPattern": "bfifo",
        "matchCount": "1",
        "teardown": [
            "$TC qdisc del dev $DUMMY handle 1: root bfifo",
            "$IP link del dev $DUMMY type dummy"
        ]
    }

Kinda verbose for this level of detail though.
