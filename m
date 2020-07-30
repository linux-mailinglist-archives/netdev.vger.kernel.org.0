Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977B123323C
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 14:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbgG3Max (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 08:30:53 -0400
Received: from mail-eopbgr00050.outbound.protection.outlook.com ([40.107.0.50]:9285
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726773AbgG3Maw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 08:30:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CXY2r6T9+DxFRW157yyn+Fx3CCEbifRzhsU4s+4dKWcoibMIqJXTYP5O8+FJZ8fSdvtNNhWnz/2LVmZ80LIXcOXC5sh0/yvVY8ru44XsTeMDQoJzr7lUbeXapVZqSqlC//j5SlPwb6IAkRvOnGbLnuQHSAjJc5UoEXEkgmvs3cziYT2UI8aITfyga2XEXKOY49QrsCQhXe/e/L6Haj+ku63ebas48js0B4MHMVHmuOU6xu3IBZt4x/jKZ314TExXpA8DOtL85/4V+ihtz7RQajl7fhUaOZq40DZV4DEFrTmDAimEnb0t62d3B7So+uRfr4JisGhNLTLVzIB7I9lJ+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O1qT0XmCGyVzdiP3tfXf7fvI2yLW3Nq+7WHWKEoMD4=;
 b=Z6TYhxcBAvb6ttQfEJIRgSK1S4/Uj0334qNudNf1QgNAafdqFb68xEsQ0XVhEmDAKIcBIpyRf2QFkaqwELFFRA9enmkuUvmzEamZYEBEPx+UPnNwWWsP3QulNgQE2WDDd/cd2OqvbCP2gE//aiYqdfC4r7EG8VQE8gRf2F9YeRp/qMBuwAzqmnWQGBGsCdLAhQEpOUgArACiGqOOyDJXOT/zi9wp4RL9bVRznkBF2sikIttZZZqQNVrYrsJwvOYlcv0xwpMEcPX52d/RftwgJ1E43Zk1QZwn6+pkeghc8Yrw7vTOX1Nuz+CHUcXNNuQIJY29QX2MX8N+1AKExyvlZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1O1qT0XmCGyVzdiP3tfXf7fvI2yLW3Nq+7WHWKEoMD4=;
 b=PMt5ETALI5+Rs3RNlhpJ8fomnXVddaxA1UJ50Q6BeHwmAbYv+0b9mvwEWG+ScwC8jb2L0f375snRO8gTeQcksv5o+SzdmY3usFt45HOadT4Vyqnkz4VpNS7Xaf8SJeeJvhJjsZer32rTsX1WOM4DTKifyldzt7vq0yqqZaM+LaI=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=mellanox.com;
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com (2603:10a6:5:27::14) by
 DB6PR05MB3174.eurprd05.prod.outlook.com (2603:10a6:6:1e::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.28; Thu, 30 Jul 2020 12:30:48 +0000
Received: from DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be]) by DB7PR05MB4298.eurprd05.prod.outlook.com
 ([fe80::f0bd:dfca:10ef:b3be%4]) with mapi id 15.20.3216.033; Thu, 30 Jul 2020
 12:30:48 +0000
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200728135808.GC2207@nanopsycho>
 <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
 <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
 <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
Date:   Thu, 30 Jul 2020 15:30:45 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::20) To DB7PR05MB4298.eurprd05.prod.outlook.com
 (2603:10a6:5:27::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (5.102.195.53) by AM0PR10CA0040.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Thu, 30 Jul 2020 12:30:46 +0000
X-Originating-IP: [5.102.195.53]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 799721ff-94f7-400b-cd0b-08d83484632d
X-MS-TrafficTypeDiagnostic: DB6PR05MB3174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR05MB3174907D7F6383B264657C6AD9710@DB6PR05MB3174.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 74EtRrWnxufHkwB9IOWwGcn9pk3BJCk4xpgQgjpdzTRpmb2refS6HZULU/mB3mHUvlEg96pnYncHybMiRMabhJnSYbEHu9U9wBv9uIFkPCcOKushJV1IAJXD0RpxCcH01tJq2vKiTUOoLw8wuYSa0aOcxhLDiJHg0OpPmnX+vj4uYeuiFH2aYW3nsNS79Hh7/FznB01U1Kqc4A4pd88RjGKVuFVRGd+KRq+NGOpgPunZvvcpV8T+3l2oL/5EGuxFOmRdORMZRukIpqVd3IXkGSfhZguoyYT3xgE5TRWdOTRNaqh6riBaTFP8kNgLe0fZ/GKG6n9YLp4kpfCd65+8dJ7bHeyv5A0J7blwSAokL75s7el3OqDBaXwcl5dCGZ28
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4298.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(396003)(366004)(346002)(376002)(136003)(66476007)(66556008)(6486002)(6916009)(956004)(8936002)(8676002)(2616005)(31696002)(54906003)(4326008)(66946007)(316002)(83380400001)(31686004)(2906002)(478600001)(86362001)(5660300002)(26005)(52116002)(36756003)(16526019)(53546011)(16576012)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: pdTKXD8T4TD3o3nE/lsA0scOD4rENSBUIoBIu8R6rFrQHUI5Bups9gy/c7aq8vTiPXQHmhwQV1S1HZS8QnWEaP68bKVjDDHhAyXwmFDiLHkL/3biiYY5hKc6VQXt4PSFalqTSXaSxLZo0vkgcfH5Ahlzp/QmQ0OYp8sCHEXnoneNgUFIJ09suxuaFjAv0snNU2vmqDqD5jgtJkeUgIxe8gh9zoNrxlUtoWPhl8xMZ7acBsi7mGodjFI0GDkKGtIUrr6YRTwat8YyX47gDvOF7pFAyeoyHJHBfSirlXRYXVZyxs333mBKfij4pR95ZUYC33jDB4pd9PHtEY6g71PYyoVXTQ1GO9Dc/QmyAIjvw+DlxeUh5WYu5LqZ2ctmTFE7UlvXyn78Suut3+ea3Xy3MUy1sGyM0TDMsjUKatVMTt6cE55hbNPJmRmtoJBc15o/h/tjU6rcSm5nMujoxQiojC41AzgsGMTHp21Rfl/IE6E=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 799721ff-94f7-400b-cd0b-08d83484632d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4298.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2020 12:30:47.9177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qi6YU4wCZPznnbuwCHG4wvirVu8/qdP6FDZqkitxdiv7cmu0uFUxE9oTJwLqc/gtEPYQRO/zoWtIrkH9SmNvWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR05MB3174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/30/2020 12:07 AM, Jakub Kicinski wrote:
> On Wed, 29 Jul 2020 17:54:08 +0300 Moshe Shemesh wrote:
>> On 7/28/2020 11:06 PM, Jakub Kicinski wrote:
>>> On Tue, 28 Jul 2020 12:18:30 -0700 Jacob Keller wrote:
>>>> On 7/28/2020 11:44 AM, Jakub Kicinski wrote:
>>>>>   From user perspective what's important is what the reset achieves (and
>>>>> perhaps how destructive it is). We can define the reset levels as:
>>>>>
>>>>> $ devlink dev reload pci/0000:82:00.0 net-ns-respawn
>>>>> $ devlink dev reload pci/0000:82:00.0 driver-param-init
>>>>> $ devlink dev reload pci/0000:82:00.0 fw-activate
>>>>>
>>>>> combining should be possible when user wants multiple things to happen:
>>>>>
>>>>> $ devlink dev reload pci/0000:82:00.0 fw-activate driver-param-init
>>>> Where today "driver-param-init" is the default behavior. But didn't we
>>>> just say that mlxsw also does the equivalent of fw-activate?
>>> Actually the default should probably be the combination of
>>> driver-param-init and net-ns-respawn.
>> What about the support of these combinations, one device needs to reset
>> fw to apply the param init, while another device can apply param-init
>> without fw reset, but has to reload the driver for fw-reset.
>>
>> So the support per driver will be a matrix of combinations ?
> Note that there is no driver reload in my examples, driver reload is
> likely not user's goal. Whatever the driver needs to reset to satisfy
> the goal is fair game IMO.


Actually, driver-param-init (cmode driverinit) implicit driver 
re-initialization.

> It's already the case that some drivers reset FW for param init and some
> don't and nobody is complaining.


Right, driver may need more than driver re-initialization for 
driver-param-init, but I think that driver re-initialization is the 
minimum for driver-param-init.

> We should treat constraints separate (in this set we have the live
> activation which is a constraint on the reload operation).
>
>>> My expectations would be that the driver must perform the lowest
>>> reset level possible that satisfies the requested functional change.
>>> IOW driver may do more, in fact it should be acceptable for the
>>> driver to always for a full HW reset (unless --live or other
>>> constraint is specified).
>> OK, but some combinations may still not be valid for specific driver
>> even if it tries lowest level possible.
> Can you give an example?


For example take the combination of fw-live-patch and param-init.

The fw-live-patch needs no re-initialization, while the param-init 
requires driver re-initialization.

So the only way to do that is to the one command after the other, not 
really combining.

Other combination, as fw-atcivate and param-init may not be valid for a 
specific driver as it doesn't support one of them and so can't even run 
one after the other.

