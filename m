Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2F00180415
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 17:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgCJQ4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 12:56:42 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:7234
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726442AbgCJQ4l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 12:56:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AbRt9Uhz6cDBbIegsdeQooT7QvqdZOcDOrLOHIiw2HrOcQEekbeSU85ZMfuJdkSuzrHtSeEuQSRPHN8BpW2PzCjaMMz/TVVImCZ3efbTYIaKwpUjJdyHuiBYcjPApWWuo7+n1/4OyA2cIcYHri+VoKrQR371BdnOoGwOO1OeS2Sr9zI1A8vwCpOXXnIlLSnQ38cjL7Jo0qTN6yd5ooC2RSfFNLAjHGhZADktuESaqGSEa6pc+nS1ANI7YJyzG+rdorHj5VB09Yqg74LyP4m3xJFWs4z1tigUMDTRo4dbf9eni014boxU/NjxDv8zlu6Mk6gU/6IfWEVMk11dIDFbXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1dxURRMKDlFvsUz1leQpHKQ5RLXMh0ocFPo3JsAvSs=;
 b=FyU3IBkcbEKA0SQgd0wZzZE8Zasvo9sl6GtMrTG5m1GjpwbOnbbuwPTNzNND1ZxRuu+OxGWP/1WCRBglmensHql+wyR5J2+T6XbmYeTvzzdCCG1RA+pMIPgGeZ3KuTXXfmW0mgNMrRW7rqXGzsFHVDtOFR0H6ceZ4aNheWLXZD+EeIwNoglobz7rCF4qrJDjjJdseC+kfeXFjJjMdAfGhgOMtGH82ygFDi6PrKdWGjPbQGaQuV452EjW3CSYunbXyLLCQgtdHiyEDFOrZo2MxT60uj+301/ht4m47NrrUszO4QnyiMSgsWhQ4rxr7raYuE9kulQ3lQjr/3EYh3CN7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c1dxURRMKDlFvsUz1leQpHKQ5RLXMh0ocFPo3JsAvSs=;
 b=uCqez6hoEWvT+5sWZ8pEs/ELVHl0b9/JbFzY48lMqdGENY8qvknqLduP/aNHei+sXcboh7l8soGMcILCT735pHsIKoh8SnZOVj+1hLETCfWxpTpDPPbwmEemD5eebiFLqR6uujTgiQ4mzK1BwbYDIEMStBUVbQoVI0O8hKuhulo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3356.eurprd05.prod.outlook.com (10.170.242.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 16:56:38 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 16:56:38 +0000
References: <20200309183503.173802-1-idosch@idosch.org> <20200309183503.173802-2-idosch@idosch.org> <85a74o5icv.fsf@mojatatu.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, kuba@kernel.org, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 1/6] selftests: qdiscs: Add TDC test for RED
In-reply-to: <85a74o5icv.fsf@mojatatu.com>
Date:   Tue, 10 Mar 2020 17:56:35 +0100
Message-ID: <87pndkxi64.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 16:56:37 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9f0a32a-c67c-4720-a644-08d7c513ff92
X-MS-TrafficTypeDiagnostic: HE1PR05MB3356:|HE1PR05MB3356:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3356BF6300A098B0241FB074DBFF0@HE1PR05MB3356.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(366004)(346002)(396003)(39860400002)(136003)(199004)(189003)(6496006)(4326008)(6916009)(36756003)(81166006)(107886003)(86362001)(8676002)(6486002)(66946007)(81156014)(8936002)(2906002)(2616005)(956004)(66556008)(16526019)(54906003)(186003)(26005)(4744005)(66476007)(52116002)(478600001)(316002)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3356;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZ7F5GOr9OYosLuLvdnB8WseUERGg6m+6NyNf4AjxZxHLq0kpU7qABnhl4yi5df74Dd5DgZuzbgwXems8BE2a8TJUazqLo6t92gyMMgCBAP5LXnXagI5D1SdgA480ZLdh50VDwFBUCJHfSLAJo/xjq31s6O9b+L8AVPiRAX6uhHXyhgsKkzxIYratkwuv8lq0L5XQCU+NiaSHNELzI989e93FR0FCTJHdAGcCIXw3vhH6LaJYiKYlX4UZwrMifImaW9YZ9KPpbJI3SPUyM9HPlOChj6/ux11T3oGIA0FWyMPfH+7suHkU1+SKnKVaKnt7Jxu1mKtwmwVbNXMkyZEu45IX96fhRsdZsCQYUmgtc3P1biQHJPj3KqJ2Nh8BdyHBWzKwQTRW3hz2wy5A4mIVuDtexHx/PD10YuOBVKHnZQdHMe+2PTE9HUKEyt2T4Q2
X-MS-Exchange-AntiSpam-MessageData: KdmErjBOSvxZPjYMVw/zvKcrpIWeJy1rTiml+MV6UyhuuP9S944unDDukUtmLTrVymw/zt7OoS1/L3kLptWKAGfJzoQHaLCHNVoBKZIl1/mhE66M3Lq67QjOnQNY+LXmf7kfY0jYRm6YWVHsOoKwAQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f0a32a-c67c-4720-a644-08d7c513ff92
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 16:56:38.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6HRHbc+WOfDeo+SxSURDBrvYhNwamnXIvAnKzFOds7TtvJnQlxTIsZ08E8U8yVOOTMZx8bxHTzFegxLU5Vnx9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3356
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Roman Mashak <mrv@mojatatu.com> writes:

> Ido Schimmel <idosch@idosch.org> writes:
>
>> From: Petr Machata <petrm@mellanox.com>
>>
>> Add a handful of tests for creating RED with different flags.
>>
>
> Thanks for adding new tests in TDC.
>
> Could you give more descriptive names for tests? (Look at
> tc-tests/qdiscs/fifo.json or tc-tests/qdiscs/ets.json as examples)

Yep.

> Did you try running this with nsPlugin enabled? I think you would need
> to add the following for every test:

Is there a flag that I need to use to enable nsPlugin? I put in the the
"plugins" stanza that you cite below and didn't observe any changes.
That either means that it works or that it has no effect :)

>
> "plugins": {
>         "requires": "nsPlugin"
> }
