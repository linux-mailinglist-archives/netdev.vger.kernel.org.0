Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2692814A307
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 12:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgA0L3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 06:29:21 -0500
Received: from mail-eopbgr20095.outbound.protection.outlook.com ([40.107.2.95]:10630
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbgA0L3V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 06:29:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qo4GFzY6LMH6WkdySjqIqXVdmVdDJmIRU23I5F7jQsqz3qGmn/ZvqKnm3iXgkIDlakQIY+E+MBqhrm6LHLmW4jA2G9oCtvB2dX4WtMuRPbDBnko9Zrp/bgSIRK+q6KVnf5K23gIAT4jJpca0KBwGqrGVXROq5RvJj2KIS/dryAgyhcUZtkCn2v64ChUV/iqPrmEjZO8p+NSGyEmAH4OjEiWUnNlVsR+D7c9vkQ/WFGBs+YGSJoVwxO59UeVymuSpXaFIJ8ElrvgSYRCpgzgNwQ+rRXG5ANbZfORczciCHrZrFaiPvi1490M23Nv9SCDKS5uxC3yJ9/N1H93dF6bReQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfxmN6M+qSoBSMuH4LLbCunzFwNaYjkjHfOmTq+le0w=;
 b=i580OshIyeuuukdjXcu4zp8g8TGcI6adNss2dZewFXHuUF/reOK6KIk53VCfCT5n+6TPAyZ07d0QJmom/XgUG4BaW05GHaa/vpdHULnpi7BOhv9UMUf0W5YaJSzK1wxdAGlgJLP1xN/6nNzfx6UqREcruRDlTioBTbJoopdJovOgAtUW/jdqkB3MD7j74w1BNNcNT1zLdwvZibM01l7o8KuZ6AYLOa6C/TjCA2HgRjm98r+FWkOwUynvDQrRS5hpoL+3XJRPYNYOeUntP4ULlZPdE4u23I6EQY3m3CtusDEbPVAEVejEfCGEPyBoZGfKL/orT3jNG19UCHP5HhCVPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfxmN6M+qSoBSMuH4LLbCunzFwNaYjkjHfOmTq+le0w=;
 b=lBEQUSZowgJ99l3oS1zGfxQJDgGnMF3fMMhVamOtdQ4U1CjB0ImzAepACtI9//kbl7JkkVTCiTRt4sukl2NOg6+3zEuNGGF9YULnHBNgb1jyo7uy7ZU0r4UqcpNUgZ5UaV0bJV7Up9A0aDJ4aNeSGq+uVBdjfD+zxwc1D5igfLQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB3437.eurprd07.prod.outlook.com (10.170.239.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.17; Mon, 27 Jan 2020 11:29:17 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2686.019; Mon, 27 Jan 2020
 11:29:16 +0000
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
To:     Andrew Lunn <andrew@lunn.ch>
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
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <13ac391c-61f5-cb77-69a0-416b0390f50d@televic.com>
Date:   Mon, 27 Jan 2020 12:29:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200126155911.GJ18311@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR07CA0022.eurprd07.prod.outlook.com
 (2603:10a6:208:ac::35) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM0PR07CA0022.eurprd07.prod.outlook.com (2603:10a6:208:ac::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.12 via Frontend Transport; Mon, 27 Jan 2020 11:29:15 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 776a8e3e-9212-49f5-59a7-08d7a31c24a1
X-MS-TrafficTypeDiagnostic: VI1PR07MB3437:
X-Microsoft-Antispam-PRVS: <VI1PR07MB3437E7437BC93B1CDB48CC6BFF0B0@VI1PR07MB3437.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 02951C14DC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(396003)(366004)(376002)(346002)(136003)(189003)(199004)(7416002)(4326008)(53546011)(16526019)(2616005)(66556008)(26005)(66476007)(956004)(186003)(66946007)(8676002)(5660300002)(31696002)(6486002)(478600001)(81166006)(81156014)(31686004)(86362001)(316002)(16576012)(36756003)(52116002)(2906002)(66574012)(8936002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3437;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nH/UNwXhjzhq9raVOASj5HK3mZoragmDc5IGR/ObWknhN239fO7JFaANqn3Xiu05EWSWSg/X5gqEv/Ez947MW6PEYni8wX3AeeeExO0pLJsU16g5RnlTRLsMK4tPT5TNQTlHxEJCUf97w9ymGLVTqezqJRE/5d9fCrPkQMalGXEWv+dI3N0eYZ9JwTCWN+cKJU8Gc5moAeaVNnmhBgtGdQJ6RDWJiAA9zdNZHM0/awHYQiHkBLl2DgPricf9TAvqBMU3CywOKVEVcym1eUxDlEGkvcr6aniMomhJMK3LbZGDASGHb3PPmM/z6Z0zoEMhGC8OqS1ElNTVbty5mkk9cZcDxkGgDmwPIyI/9s5so4FSbVDV3liq0zLDbHM9UCTzjOILd6xGnHVMqPVjLIgkLlNn6iE0/Vi8UJMsInoeKV7tdBcqxewLPbQMd08+ZfMN
X-MS-Exchange-AntiSpam-MessageData: /qgfFHnm2oj5HzKz+NZOH2Tq6GEtmLzG/6Npi11OSeMk7x5Nsm2B1EcKLFAwe7gI/vkUPa2hc+IUFYVELmbhi5yT1efqp3EZVd5rScxFx/+MtrX4/RJxdL1JBlenE5YPyipoucCUzdKbsBjOGTq3uQ==
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 776a8e3e-9212-49f5-59a7-08d7a31c24a1
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2020 11:29:16.8008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uuLyokYHCIuP/zKO41nSkCpgBkgbB/HS452rlQDoxqAZ7lt4kLoR86JIIJ8Iv1xa0RtNNpNYZ9zlqArbMILGDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3437
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/20 4:59 PM, Andrew Lunn wrote:
> Given the design of the protocol, if the hardware decides the OS etc
> is dead, it should stop sending MRP_TEST frames and unblock the ports.
> If then becomes a 'dumb switch', and for a short time there will be a
> broadcast storm. Hopefully one of the other nodes will then take over
> the role and block a port.

In my experience a closed loop should never happen. It can make software crash and give other problems.
An other node should first take over before unblocking the ring ports. (If this is possible - I only follow this discussion halfly)

What is your opinion?

(FYI:
I made that mistake once doing a proof-of-concept ring design: during testing, when a "broken" Ethernet cable was "fixed" I had for a short time a loop, and then it happened often that that port of the (Marvell 88E6063) switch was blocked.  (To unblock, only solution was to bring that port down and up again, and then all "lost" packets came out in a burst.)
That problem was caused by flow control (with pause frames), and disabling flow control fixed it, but flow-control is default on as far as I know.
)

Kind regards,

Jürgen

