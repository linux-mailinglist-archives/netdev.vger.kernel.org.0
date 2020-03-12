Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BF4182650
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 01:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgCLAnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 20:43:35 -0400
Received: from mail-eopbgr10070.outbound.protection.outlook.com ([40.107.1.70]:8706
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731476AbgCLAne (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 20:43:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eDxV7Rgb2V+zn33jmthfskVT484kIvnsbB7VJgYH0mUMgGCqhBl/10oP0d182cTw6P6xXTuSroMid0bjHKwD6GS7m9IxA3cBkyscB81ddzNn7MnizbAg6y+BmOz2dzBipAE/yobSye+BPF+S5rP/Aux6Y6N9OO67Vwyswq5oz5T3Xr6/QHLMwvpgVYv24IuVO3XBGlRM5xIChPQKfUp5wZm0Oi9y/2AeYIz+liu424eoNAzDpm0ucKMqqwl75kaOPh3v2KIqAHlUP3mnL9gJxSfDwneYDbHOGzjzsW5kzwYkUr4F1i4gfFKZ4XxJWSZISwefCaC2driXXO4hUfu6qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Usx/BgzlfP+c95yriCKmBor99ujANjPibsokCZYsP4=;
 b=fhlSG0T++h+wvPHWgOpp5x1mjgFMyP3FOZ590X42ggMRWjHO+2+iqaHlgEtcGY5Qosr2oMoZrxtiIpLJO4WLovHUXpCwjQ3OyPSdNFoU8lY8YSwrVPw0ixZBVIaqys5E0F3HLKhJm3g/fBmmzdInhVWaiaEvZ27qJY1xPZPvgy3lwc7q3hLflFM6GZltYUJmfQmfJKKa0vVitPLPVmWdiSNiWBoGYlQgsdSvCHYnG8ZSvtORdWk1175zE3HbLyC/e907EB17awd2W3Gnmm6dy3Tf/VWvbwzTAqyIjXsggO9xhMVmuBYj3anpovwDqA/4LloDRLeW6TeWTtq1i1T7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9Usx/BgzlfP+c95yriCKmBor99ujANjPibsokCZYsP4=;
 b=j4OidCP3G45rVunFiE7KCtqoNiWKBdOFYjsXLduzQ6BBx8Tu7uxC5woJHoAzzNdED1bTKMxT2M0+CX3MtBTTSI593kwVa1aSOBWZ8ogOVwARrheEv6dYGMZdu9Yl7pjIQdx1EvBSaIKALkO6i6aJLz9a6Dbc9xUGMqiec6lFrto=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB4700.eurprd05.prod.outlook.com (20.176.164.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.20; Thu, 12 Mar 2020 00:42:47 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.018; Thu, 12 Mar 2020
 00:42:47 +0000
References: <20200311173356.38181-1-petrm@mellanox.com> <20200311173356.38181-4-petrm@mellanox.com> <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN tail-dropping mode
In-reply-to: <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com>
Date:   Thu, 12 Mar 2020 01:42:44 +0100
Message-ID: <87imjaxv23.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::10) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (89.176.246.183) by FR2P281CA0023.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Thu, 12 Mar 2020 00:42:46 +0000
X-Originating-IP: [89.176.246.183]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7289d7c2-b955-4e03-69bb-08d7c61e48a4
X-MS-TrafficTypeDiagnostic: HE1PR05MB4700:|HE1PR05MB4700:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4700EDB5B6A693A6FDD8AF40DBFD0@HE1PR05MB4700.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0340850FCD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(396003)(366004)(376002)(39860400002)(199004)(66556008)(966005)(66946007)(478600001)(6486002)(2616005)(4326008)(107886003)(16526019)(66476007)(186003)(26005)(956004)(36756003)(6916009)(81166006)(5660300002)(8936002)(81156014)(8676002)(6496006)(86362001)(53546011)(2906002)(52116002)(54906003)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB4700;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IPYvGkOYlh3Xt7JT9vBHuSARvHJ6efKWqr5ej2shOJ/aeVOMw2wc4I94Wf2aSxzThsMqxElTI4Q/kDkQjLkNtJSnhVRStdByo2bFQvfONJnYJrI7Jcel7Dd9iELb7808cwBlCqwPtblNlZuKK6zZTpAXWBIiF5TeLqpzmsPSvjg2Cly6qqm7uzL332smqgr2fhT4EjSaO5xBk8HSF+JbRZoGTnOd32Q06y5wNmlBa9nXZrcoTy3d1f1WnRKPHOWMPr7wWbK7wM0a6UuJEpuxs7OIykzbN/R1eKEu6xgeCidKwQT0LsVaz1r+K5pG/DVy0awuKYciWD+OwxG44XDrPTf2IRKWPE2K670IEHmBzqIoMSKL/XCR+Htbi/qYUeC81zIV6WYDL8FnpUxlYbUFMsOdeumI8lObbqVJphpL5eWqX1sIScSEEUlyW8YdzY5n2qgFbeopNayVwSP8xvKsu/QXr8Ubbq5fqy5zf6LRIbavMEwD2G+YL//dLcXKbkt5d9aPEE0mUS1tnL7jXnFt8Q==
X-MS-Exchange-AntiSpam-MessageData: iwcosb/GriEYPRZUWwjF1rbbXoikEvmd0NT5RFML/Tk6h5UjFfxJyASDHtFvdT0Ficndrlme/duOX4V3gSjDigXtVw7j2neLT4Gc6hRoHZLv9izPNRDDodl/zK3LhpT+0Zm7lqf/6hgwadgBK2+eTQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7289d7c2-b955-4e03-69bb-08d7c61e48a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2020 00:42:46.8936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9GFa3ZeDKkKiCI42OF9RY1aFFmVIlP0SSnbeGkVsQpPIHfRPQgl7pja7GSQEm4GtkDF6t8LDzCkfaDgiWVK7jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4700
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 3/11/20 10:33 AM, Petr Machata wrote:
>> When the RED Qdisc is currently configured to enable ECN, the RED algorithm
>> is used to decide whether a certain SKB should be marked. If that SKB is
>> not ECN-capable, it is early-dropped.
>>
>> It is also possible to keep all traffic in the queue, and just mark the
>> ECN-capable subset of it, as appropriate under the RED algorithm. Some
>> switches support this mode, and some installations make use of it.
>>
>> To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
>> configured with this flag, non-ECT traffic is enqueued (and tail-dropped
>> when the queue size is exhausted) instead of being early-dropped.
>>
>
> I find the naming of the feature very confusing.
>
> When enabling this new feature, we no longer drop packets
> that could not be CE marked.
> Tail drop is already in the packet scheduler, you want to disable it.
>
>
> How this feature has been named elsewhere ???
> (you mentioned in your cover letter :
> "Some switches support this mode, and some installations make use of it.")

The two interfaces that I know about are Juniper and Cumulus. I don't
know either from direct experience, but from the manual, Cumulus seems
to allow enablement of either ECN on its own[0], or ECN with RED[1]. (Or
RED on its own I presume, but I couldn't actually find that.)

In Juniper likewise, "on ECN-enabled queues, the switch [...] uses the
tail-drop algorithm to drop non-ECN-capable packets during periods of
congestion"[2]. You need to direct non-ECT traffic to a different queue
and configure RED on that to get the RED+ECN behavior ala Linux.

So this is unlike the RED qdisc, where RED is implied, and needs to be
turned off again by an anti-RED flag. The logic behind the chosen flag
name is that the opposite of early dropping is tail dropping. Note that
Juniper actually calls it that as well.

That said, I agree that from the perspective of the qdisc itself the
name does not make sense. We can make it "nodrop", or "nored", or maybe
"keep_non_ect"... I guess "nored" is closest to the desired effect.

[0] https://docs.cumulusnetworks.com/cumulus-linux-40/Layer-1-and-Switch-Ports/Buffer-and-Queue-Management/
[1] https://docs.cumulusnetworks.com/version/cumulus-linux-37/Network-Solutions/RDMA-over-Converged-Ethernet-RoCE/
[2] https://www.juniper.net/documentation/en_US/junos/topics/concept/cos-qfx-series-tail-drop-understanding.html
