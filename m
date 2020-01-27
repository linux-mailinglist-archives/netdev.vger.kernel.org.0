Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFFF14A65C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729147AbgA0OlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:41:19 -0500
Received: from mail-eopbgr10112.outbound.protection.outlook.com ([40.107.1.112]:39687
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728760AbgA0OlT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:41:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FcebcYjW7J6/2ReO4WyRPnM0B3TaTO9vW3dHNPFGOrEO102+WEhxc/3PhfnpHGWId+d3YoQqRQ3mGcnTqZMxs5b2WQySFhmGYXOlCbIMjdeKGR/IPTPCAW3u+c1onL3lUyDC860P4emcbkZARCL7gc26umLGTO5RUMr9eZyOqfALCkOKrl06Be7PlP3O9xCo1wYoxSeyuDxCJtR1D0ddB+ndDPMqV5A1ODU1myxDGnvLsDtXBvdSt++K4UlNJ/aQaXozwj9hFR8iJYMm7NT27mA27ru7q0rwx4XkVbf93lXKZe4PLpBkuRBg3/oqAgWRm7OyZ+WaAp2/SZ7pfISLLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz9E4BnLE1LViKBc5cRkLR5qPkf7ZyUPc+9hQi8yhS0=;
 b=LPrY696Iac79PhGmznzb8zfB25KdLo26tSpCNndTaNmorb15xLZV886uXYtIKXrAnaE88cHsHNwPmqe4YcKIUUhcMIy1ImebD22SsavGrY7fJcn3oxTU2NZkvyRfH6dbxki6W92pgocxplR6TWBfLxnD8UfWYgBFg8f53Hgz4BDUErV+2BWYR1RjY3T8jmmzPLjXxtzBVjg1W5oBEfX8H9gvFNFAGP3c5D0k9scgdSTbNlYItjd3gsY86r4GhrETz3RF2idGAL6izE3Kc5JoCTFJDcc1wR4rWtAQxXWg6kQ7e7C7plo8LzqcfcfybuuEkywwCJM60jtUQ9CFz5HNqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uz9E4BnLE1LViKBc5cRkLR5qPkf7ZyUPc+9hQi8yhS0=;
 b=CroxyoyCfSGcJ5n3d00CfSYNGAWGap8mxVFqTzEGniX5k9DduGCtZvjZxfpAuB9gfhJi2FluUZh295qd8RKTmU/IK/n52rSkF60DaYQHA3iurB748ZOaPNuuFS1o5tqpByEcrIrUfsrQzgFbCz9LmbFJSpgBi37OuWXoI2UjcZU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB3199.eurprd07.prod.outlook.com (10.170.236.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.14; Mon, 27 Jan 2020 14:41:15 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2686.019; Mon, 27 Jan 2020
 14:41:15 +0000
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
 <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
 <20200126155911.GJ18311@lunn.ch>
 <20200127110418.f7443ecls6ih2fwt@lx-anielsen.microsemi.net>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <879c5144-183f-51d3-21e3-51c20d1d02b4@televic.com>
Date:   Mon, 27 Jan 2020 15:41:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200127110418.f7443ecls6ih2fwt@lx-anielsen.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0501CA0064.eurprd05.prod.outlook.com
 (2603:10a6:200:68::32) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM4PR0501CA0064.eurprd05.prod.outlook.com (2603:10a6:200:68::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 14:41:14 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 33f5213d-bf4b-41fb-be77-08d7a336f641
X-MS-TrafficTypeDiagnostic: VI1PR07MB3199:
X-Microsoft-Antispam-PRVS: <VI1PR07MB3199DBF3C2DD3D6EA84289F5FF0B0@VI1PR07MB3199.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-Forefront-PRVS: 02951C14DC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(39850400004)(346002)(136003)(189003)(199004)(4326008)(2616005)(86362001)(316002)(31686004)(5660300002)(16526019)(7416002)(956004)(26005)(66574012)(52116002)(53546011)(31696002)(6486002)(8936002)(478600001)(8676002)(2906002)(110136005)(16576012)(186003)(66556008)(81166006)(66946007)(66476007)(36756003)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3199;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8vCODGR08tz/WZxePD/fCqUjtAHLXw4/NumQ5EVrEXY0Wk4+m5LG7b+2yPc5D7r0dzAlS03/0plt2Tkr4lwJogoDUcEuSNWPydShDnab5Xs4sCP33i9YqaqKbDbgdbpk6a5lf9eaWdOtiBrHs8yv8s6ZUwx8jyRE+ebDFXfzNE2rQYHgnsQcys1TZdD9EDbq0l9SHc5TLpCEVyUCkx+ancfw8pZ3u1P5Jffsw2Gb5Y6uaWfb65e+yEBHVyDMnylPi2I7BZm6iFCjby0canHlZJyT05CN8mPw2uTWq8Mzrs5Q7jFUWmMYn1DTi3Gu/HwqQKjCHSsf5ENGHd0KP0jp7MfJzIsdn6TcWHsxoqTs5A5UyJzOn2husIcq/mAw/RhlUoVqKkC/mv0AuaSrv49RpOTgVMv13uCzBQ1M65Hx4edkGO4CQ2QgYvJCLfqt2j+4
X-MS-Exchange-AntiSpam-MessageData: TfEEl5RJZJI49l15cnsA/NhtA4NTEZCouOIHQWj8Q3kTyrxnNVLP7zryEhdf4dg+Y1/UCh4R7IaCTiUE5qv8aizi6rS8q+qZmpjB+zDjx9d3j+0zpjqHRN5l52Fu0eCu/JLpX9peLJXYlaniLK0SHw==
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33f5213d-bf4b-41fb-be77-08d7a336f641
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2020 14:41:15.3758
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kVlwKSBGyLV0DM0kSF+IwqZQ760tOZ77SO5gNIrV7eHC7AIzM8z3Be8c+i+tt2giepxHJQQUSGtjqXiU66ZWwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 12:04 PM, Allan W. Nielsen wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> On 26.01.2020 16:59, Andrew Lunn wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On Sun, Jan 26, 2020 at 02:22:13PM +0100, Horatiu Vultur wrote:
>>> The 01/25/2020 17:35, Andrew Lunn wrote:
>>> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>> >
>>> > > SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
>>> > >   MRP_Test frames on the mrp ring ports. This is called only on nodes that have
>>> > >   the role Media Redundancy Manager.
>>> >
>>> > How do you handle the 'headless chicken' scenario? User space tells
>>> > the port to start sending MRP_Test frames. It then dies. The hardware
>>> > continues sending these messages, and the neighbours thinks everything
>>> > is O.K, but in reality the state machine is dead, and when the ring
>>> > breaks, the daemon is not there to fix it?
> I agree, we need to find a solution to this issue.
>
>>> > And it is not just the daemon that could die. The kernel could opps or
>>> > deadlock, etc.
>>> >
>>> > For a robust design, it seems like SWITCHDEV_OBJ_ID_RING_TEST_MRP
>>> > should mean: start sending MRP_Test frames for the next X seconds, and
>>> > then stop. And the request is repeated every X-1 seconds.
> Sounds like a good idea to me.

Indeed, and it should then do the same as mentioned below and "... come a 'dumb switch' ", except that I propose to make it configurable how to fallback: with auto-recovery ('dumb switch') or safe mode that keeps the ports blocked, and then some higher layer protocol should fix it.

>
>>> I totally missed this case, I will update this as you suggest.
>>
>> What does your hardware actually provide?
>>
>> Given the design of the protocol, if the hardware decides the OS etc
>> is dead, it should stop sending MRP_TEST frames and unblock the ports.
>> If then becomes a 'dumb switch', and for a short time there will be a
>> broadcast storm. Hopefully one of the other nodes will then take over
>> the role and block a port.
> As far as I know, the only feature HW has to prevent this is a
> watch-dog timer. Which will reset the entire system (not a bad idea if
> the kernel has dead-locked).
Indeed. Our designs always have a watchdog.

And then I again propose to have 2 bootup options.

I refer here also to my answer on Allan's answer on my email of 12:29PM.

Kind regards,

Jürgen

>
> /Allan
>

