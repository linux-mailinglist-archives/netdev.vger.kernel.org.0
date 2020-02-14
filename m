Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACD6215D694
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 12:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgBNLeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 06:34:08 -0500
Received: from mail-eopbgr00043.outbound.protection.outlook.com ([40.107.0.43]:4791
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726092AbgBNLeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 06:34:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PMim8wKYIXT1VdtBkGUX6ww2kDSganCPJ6tG3/+iP7JhVnR04MIiiJYPf1tPjZuxD04hDaJ/flV56NcbAM8d4QmZIqiLThaPRwh81t1eLr+bKI7Q4bG8+GQ3WPd9IZ8zPHavAq/I4Vbz1zQ9srsBl0C2K9ijwqjeXaJxJOk3ai2buwbcfvtHTnrgFY2ooROzQ6pnW6oXsVsGiJxZQMEKq3RYtQFTopfB+pbsc7qs+e9iniA1UwZ/N5g2YYlVVkJ5AxMteZOVj7t+f+WTLIruJG70QlVsPG3s/1mpHx+AR4bQEk4AFkloCY+TaYtbklUe+5TiYmdnZmuD9BstzmZkNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcVDmhw3lZaZbkq0Zj+TZ4p24Z75Fcor1xKBz64AlS0=;
 b=jzSzPi6WojKCrCg/viGpAIJzMECuMIGGBkO7q4fhpy9G7etvLTz3mqCFzOnnR1FfMMyjrgUp/cYFoEp+EGKUVV9piDCh/gD1F23j8JbMJ96dYvuX5T7hXCzySeT6sUzKIfMmx3aYAFh3eUW3otVdSD18ScFaC4y6+VqOuo/fgxNY8T6IT5ExneDN3HtylAKl41BvLfGQW1Rp7DPFpUysgXL/SsvDpSvdBDhI2ycoX6kbFo4hF0PKbYqjQQu0XzTmwAmgA7PjPXmsDakWvjvzLS0SFykloLRaORA5xZI9EPUI7m7Ja6WMhbTDMsH1/uumQo3Lyom5l1GNgdFlel24jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZcVDmhw3lZaZbkq0Zj+TZ4p24Z75Fcor1xKBz64AlS0=;
 b=I1Cx/whTH2Z23NghhI1P9t4M3DATIqYFfTnN+RbviP2Y4zV1fWFjUDZPdrkfvSPthEukWkSFo9TnmLOoNtx5F/NnKZWJWe73Cx2RNKUMVUgCQ6dZ4irHZLbbQb2hZbi4eZxeUp9RsTQwjWSUhe891Pgc7wU040vWeUUz4oZTHjs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=yossiku@mellanox.com; 
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com (10.168.21.32) by
 DB6PR05MB3446.eurprd05.prod.outlook.com (10.175.233.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.24; Fri, 14 Feb 2020 11:34:03 +0000
Received: from DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::d58:c039:72df:3c2d]) by DB6PR05MB4775.eurprd05.prod.outlook.com
 ([fe80::d58:c039:72df:3c2d%7]) with mapi id 15.20.2729.025; Fri, 14 Feb 2020
 11:34:03 +0000
Subject: Re: [RFC] Hierarchical QoS Hardware Offload (HTB)
To:     Dave Taht <dave.taht@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
References: <FC053E80-74C9-4884-92F1-4DBEB5F0C81A@mellanox.com>
 <CAA93jw6tgQF4XMKN5etJqkO4xvxSFDCn41en7LSJ55gVJeGybQ@mail.gmail.com>
From:   Yossi Kuperman <yossiku@mellanox.com>
Message-ID: <ad3c29b8-2b45-1b1a-7cee-336c0699e9ac@mellanox.com>
Date:   Fri, 14 Feb 2020 13:33:56 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
In-Reply-To: <CAA93jw6tgQF4XMKN5etJqkO4xvxSFDCn41en7LSJ55gVJeGybQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: PR0P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::18)
 To DB6PR05MB4775.eurprd05.prod.outlook.com (2603:10a6:6:4c::32)
MIME-Version: 1.0
Received: from Yossis-MacBook-Pro.local (213.57.108.109) by PR0P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Fri, 14 Feb 2020 11:33:59 +0000
X-Originating-IP: [213.57.108.109]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb508de8-e6af-44ae-44d1-08d7b141caef
X-MS-TrafficTypeDiagnostic: DB6PR05MB3446:|DB6PR05MB3446:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB3446F2AB372682D8C9AB1CEAC4150@DB6PR05MB3446.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03137AC81E
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(396003)(39860400002)(366004)(189003)(199004)(54906003)(478600001)(6486002)(316002)(26005)(31696002)(6666004)(2906002)(956004)(36756003)(86362001)(2616005)(81156014)(8676002)(107886003)(81166006)(53546011)(31686004)(6916009)(8936002)(6506007)(5660300002)(66946007)(16526019)(186003)(66556008)(66476007)(6512007)(4326008)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR05MB3446;H:DB6PR05MB4775.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LLTsFdtGdTSgU+iwinQwdPzPpnWCM7+o7lT9SKhz52e8RMZtXZaSTCNj1Oavg+sZ1msA7igF3Komr4++YaoosDhcnphIZ+z4Dr8JQvFKqx/bISP2271O6zkvq7iNP3M1Zv8Be3XB6wGNI8ZzAnL/BRKgjxKHnlp91J/W0XNTDlHMHJSaM5sUhMzOlsfgSxHkm+UYfkJ1atc5xOQjms2/C3Zv8Rv0a5bYD/4yORaaM54+J8DHGlyhltOjKxv7PnoC8RMrwW6Zv79R40g78iImJl0qOuH58CAdY0Mr6FG0LiGVShk1LSKbTI7IMVuj/pqQaEm1XIvtyftZ6l1x3q16vhPLeA8UoF6UYTeqPbQgmDCQHvIrkl+75dPVj24nirK3KdHemfC8RWaYuzostdRQtCOp0YxC5RGcOOAELzUDOawpMZSbX4KhkIO64r6V1+2H
X-MS-Exchange-AntiSpam-MessageData: 5GRE4wRrHBc30k7/ewOVbOZ09idRxw4LbwMySPkvXVWaUwMfYxF5/KMeyEZKpnGUZTnbBrzpamMKyRyUqxgpi+XeJVWFdXtD3Gxb0hlME6+LUaXr3pFepoRFp9xgPBbFDdNUpBXFpNTYuAgICFA14A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb508de8-e6af-44ae-44d1-08d7b141caef
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2020 11:34:03.3602
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8B93NFCZ9xYYf1pa4XKxE9+vE036Y/FqYhD1ysPXgTnaIN65VgYuQiLoA3ROa+SPYW0kPqe9T19O8xCqqmj1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3446
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/01/2020 3:47, Dave Taht wrote:
> On Thu, Jan 30, 2020 at 8:21 AM Yossi Kuperman <yossiku@mellanox.com> wrote:
>> Following is an outline briefly describing our plans towards offloading HTB functionality.
>>
>> HTB qdisc allows you to use one physical link to simulate several slower links. This is done by configuring a hierarchical QoS tree; each tree node corresponds to a class. Filters are used to classify flows to different classes. HTB is quite flexible and versatile, but it comes with a cost. HTB does not scale and consumes considerable CPU and memory. Our aim is to offload HTB functionality to hardware and provide the user with the flexibility and the conventional tools offered by TC subsystem, while scaling to thousands of traffic classes and maintaining wire-speed performance.
>>
>> Mellanox hardware can support hierarchical rate-limiting; rate-limiting is done per hardware queue. In our proposed solution, flow classification takes place in software. By moving the classification to clsact egress hook, which is thread-safe and does not require locking, we avoid the contention induced by the single qdisc lock. Furthermore, clsact filters are perform before the net-device’s TX queue is selected, allowing the driver a chance to translate the class to the appropriate hardware queue. Please note that the user will need to configure the filters slightly different; apply them to the clsact rather than to the HTB itself, and set the priority to the desired class-id.
>>
>> For example, the following two filters are equivalent:
>>         1. tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80 classid 1:10
>>         2. tc filter add dev eth0 egress protocol ip flower dst_port 80 action skbedit priority 1:10
>>
>> Note: to support the above filter no code changes to the upstream kernel nor to iproute2 package is required.
>>
>> Furthermore, the most concerning aspect of the current HTB implementation is its lack of support for multi-queue. All net-device’s TX queues points to the same HTB instance, resulting in high spin-lock contention. This contention (might) negates the overall performance gains expected by introducing the offload in the first place. We should modify HTB to present itself as mq qdisc does. By default, mq qdisc allocates a simple fifo qdisc per TX queue exposed by the lower layer device. This is only when hardware offload is configured, otherwise, HTB behaves as usual. There is no HTB code along the data-path; the only overhead compared to regular traffic is the classification taking place at clsact. Please note that this design induces full offload---no fallback to software; it is not trivial to partial offload the hierarchical tree considering borrowing between siblings anyway.
>>
>>
>> To summaries: for each HTB leaf-class the driver will allocate a special queue and match it with a corresponding net-device TX queue (increase real_num_tx_queues). A unique fifo qdisc will be attached to any such TX queue. Classification will still take place in software, but rather at the clsact egress hook. This way we can scale to thousands of classes while maintaining wire-speed performance and reducing CPU overhead.
>>
>> Any feedback will be much appreciated.
> It was of course my hope that fifos would be universally replaced with
> rfc8290 or rfc8033 by now. So moving a software htb +
> net.core.default_qdisc = "of anything other than pfifo_fast" to a
> hardware offload with fifos... will be "interesting". Will there be
> features to at least limit the size of the offloaded fifo by packets
> (or preferably, bytes?).
>
Yes, as far as I know we can limit the size of the hardware queue by number of packets.

>
>
>> Cheers,
>> Kuperman
>>
>>
>
