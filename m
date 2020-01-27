Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3836814A655
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 15:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgA0OjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 09:39:14 -0500
Received: from mail-eopbgr10096.outbound.protection.outlook.com ([40.107.1.96]:42582
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726635AbgA0OjO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 09:39:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQMzZRKuiVklFLrP0nI40YtDMC96QJ7vb66Os06FY8pLk1vVkPQfmGr+p0X/jzopjRfso0Lp1lNlX0sRtHWPYgJuVVlyJO2jNAS0qlURmuzg3PjrtRzCsfI1VUU70+LRYhCcW/E7pfB4MWYgkDYnFn95ATyCgOanCVTz3h9GXSP4mFXeRmSpZvDUYNXzqRahV6VEKLjgWbFX1dkP/8Ef7M8MRkCHrBIEvUmC7xpW8YFarNTanT+fMdByceoBwl9V3sZo2VPHkqhnXvr/1xUI6DeYbl1QmsM64dmLpb1bba1X90J2ozQ68+TNi0xngiUfn4vdHZZWJ9T+M8e9g0ixTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqy/EXa1/yyKcS+GeKRA5O51ZBMd/tcvxlCjxOQKYjg=;
 b=XZN5roLNs1QrS0HUGFkR7jSnyHQr0p/rmpYlep+hqJ2KvzWOtFN2URkm3f7oU+8VX2ww0pBEH3CQeiuTt5hKM8g3blZMlnIa+i5tsk2LW0D+KpT6BALDGvnBReS3u8V0d11L9EHvMr8ziMRZ151a/cchWY9nbkT6YRI9MMblFH3UtfrTh3fDe4d0yAh+kzP2IbOWa46rBszPQQ7TW3E+BAcI4q5OKm8yiefyveDZNNmAZnLd8tSh8AQhd6lrL8I0i95v0thb3IH0aqu3s5oZLeHZOYKip6J5m6E1fmtK+JTnPG0jli/IuUDJaDZiuOJfjylm1dXBKdOwB9ikG/ctVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qqy/EXa1/yyKcS+GeKRA5O51ZBMd/tcvxlCjxOQKYjg=;
 b=po8BIu2oh/cOD4SyDifFi4fknlpltacGCmjpN4+ILrRiMXHBUnkrPfLkFAfbTL4L7E4bvVIwF8agDQtxZ0Nip+qXexjt2gcV2GUUvWpJwZmvtCpXSdTgX8zyE13Gl7zKb0mUKqan7CaVosYpGI0HBxEth8E5AZMI8JFFPuC3Wss=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB3199.eurprd07.prod.outlook.com (10.170.236.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.14; Mon, 27 Jan 2020 14:39:06 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2686.019; Mon, 27 Jan 2020
 14:39:06 +0000
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
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
 <13ac391c-61f5-cb77-69a0-416b0390f50d@televic.com>
 <20200127122752.g4eanjl2naazyfh3@lx-anielsen.microsemi.net>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <8561814d-bfae-5e23-b0e8-a0e3adf800b4@televic.com>
Date:   Mon, 27 Jan 2020 15:39:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <20200127122752.g4eanjl2naazyfh3@lx-anielsen.microsemi.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR02CA0065.eurprd02.prod.outlook.com
 (2603:10a6:208:d2::42) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM0PR02CA0065.eurprd02.prod.outlook.com (2603:10a6:208:d2::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.25 via Frontend Transport; Mon, 27 Jan 2020 14:39:05 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cf665011-52ac-4ecd-56ac-08d7a336a97a
X-MS-TrafficTypeDiagnostic: VI1PR07MB3199:
X-Microsoft-Antispam-PRVS: <VI1PR07MB3199198C6C058CEB013886AAFF0B0@VI1PR07MB3199.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 02951C14DC
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(376002)(366004)(39850400004)(346002)(136003)(189003)(199004)(4326008)(2616005)(86362001)(316002)(31686004)(5660300002)(16526019)(7416002)(956004)(26005)(66574012)(52116002)(53546011)(31696002)(6486002)(8936002)(478600001)(8676002)(54906003)(2906002)(16576012)(186003)(66556008)(6916009)(81166006)(66946007)(66476007)(36756003)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB3199;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z8Fi8FZW6NVTyH+X9DVRBOx8bPWlusEkVFmGuEUuh/OvBOqOWoo90nqYwl1XWq0tEa7yfcxcEOhGTDGxuc5aUVpmbAYBPXE/E6eV3znTPwdZitKSy4huLYB6pQiXZ4g+/dwfUSg0H9BSSh5IWfvuFmLMsDuMRTU14ukJiAX9NO+mCN9gizq5UzmX1LjMF+1MCkZ6CMG3in462JI3c3FQQcY+xtM72xnGKnbcxbwTMkmz/I5mk8ATy2lxteo6/gKTx68S1TRjZzrqfYcO7PGbw51ju+4MWuRuCWcE1L/73QwxllWGZqNxOlQm27ciOMxqOKdegfDQcO2siX6o4maKJRJaKkCFqVbR7PfEh8449mryLL04UdvCVcggt9x70RcNHbck5IL1bb4kWcZBzY3quNRecxyqwariFBdhW8csd4gafySpgYYHTH7HyqPi3+MQ
X-MS-Exchange-AntiSpam-MessageData: cOq7aEQ1CNkHlod5/PDeB7jQNUVdlYK80NMp4LAq+TtjhW3KEg2aByx7PXAigIogWouZ+82TRoX90lU5Ztx8Psz1TonoBYUkacbSGnyjzDTrJNFfqIZYu+0Rnx1yyiHKchx3ywfO6bm0y+swokBZIQ==
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf665011-52ac-4ecd-56ac-08d7a336a97a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2020 14:39:06.5351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VKEPufgsN8HDhfueS3JKu8/ByyVZt9nfFmllmcZIjsp2/4CCBSnh0rMaKa4pd+121e78/zxaU1fBhi1GQW6m4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB3199
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/20 1:27 PM, Allan W. Nielsen wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> Hi Jürgen,
>
> On 27.01.2020 12:29, Jürgen Lambrecht wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 1/26/20 4:59 PM, Andrew Lunn wrote:
>>> Given the design of the protocol, if the hardware decides the OS etc
>>> is dead, it should stop sending MRP_TEST frames and unblock the ports.
>>> If then becomes a 'dumb switch', and for a short time there will be a
>>> broadcast storm. Hopefully one of the other nodes will then take over
>>> the role and block a port.
This can probably be a configuration option in the hardware, how to fall-back.
>
>> In my experience a closed loop should never happen. It can make
>> software crash and give other problems.  An other node should first
>> take over before unblocking the ring ports. (If this is possible - I
>> only follow this discussion halfly)
>>
>> What is your opinion?
> Having loops in the network is never a good thing - but to be honest, I
> think it is more important that we ensure the design can survive and
> recover from loops.
Indeed
>
> With the current design, it will be really hard to void loops when the
> network boot. MRP will actually start with the ports blocked, but they
> will be unblocked in the period from when the bridge is created and
> until MRP is enabled. If we want to change this (which I'm not too keen
> on), then we need to be able to block the ports while the bridge is
> down.
Our ring network is part of a bigger network. Loops are really not allowed.
>
> And even if we do this, then we can not guarantee to avoid loops. Lets
> assume we have a small ring with just 2 nodes: a MRM and a MRC. Lets
> assume the MRM boots first. It will unblock both ports as the ring is
> open. Now the MRC boots, and make the ring closed, and create a loop.
> This will take some time (milliseconds) before the MRM notice this and
> block one of the ports.

In my view there is a bring-up and tear-down module needed. I don't know if it should be part of MRP or not? Probably not, so something on top of the mrp daemon.

>
> But while we are at this topic, we need to add some functionality to
> the user-space application such that it can set the priority of the MRP
> frames. We will get that fixed.

Indeed! In my old design I had to give high priority, else the loop was wrongly closed at high network load.

I guess you mean the priority in the VLAN header?
I think to remember one talked about the bride code being VLAN-agnostic.

>
>> (FYI: I made that mistake once doing a proof-of-concept ring design:
>> during testing, when a "broken" Ethernet cable was "fixed" I had for a
>> short time a loop, and then it happened often that that port of the
>> (Marvell 88E6063) switch was blocked.  (To unblock, only solution was
>> to bring that port down and up again, and then all "lost" packets came
>> out in a burst.) That problem was caused by flow control (with pause
>> frames), and disabling flow control fixed it, but flow-control is
>> default on as far as I know.)
> I see. It could be fun to see if what we have proposed so far will with
> with such a switch.

Depending on the projects I could work on it later this year (or only next year or not..)

Kind regards,

Jürgen

>
> /Allan
>

