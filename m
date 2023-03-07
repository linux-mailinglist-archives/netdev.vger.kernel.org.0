Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 052A46AE67D
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 17:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCGQbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 11:31:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjCGQbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 11:31:07 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05hn2236.outbound.protection.outlook.com [52.100.175.236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263A182360;
        Tue,  7 Mar 2023 08:30:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfytIfEOycFHmXWz11+CfP640FlpgN6nMHO+k0JvP+w=;
 b=sSJZX22VhA2X0hx/9o1FehZzG+c0MByu46bVcXfWtikcYy4LRoR44bTud+tga5Y5YrzdFzRM9JzCBjWwSeeCCV2qJtKeI+IggE6QAcLG2cqjWQRESeAjTNdwLT64ff/wpPuIHKQHKk9+pWum/7nTRqZrMX9N4olfVtxo8+ZUDU+i92jKv6GR0NQXWC90IQIgJHG9tUKMf2v4aAkDeRZ3yCInlhZfXImlg2fCmi/vCJYClXNyOsSPW8Qa1kYmgtzsnHhFY/PnRkGbPRjb91RWuzYCCtHIH+7k9VX0Vktyaqtc5j9Jp5n7cMx2pWNHEd1NrCwdUhdt8DWeXIRL8+GJ5w==
Received: from AS9PR06CA0164.eurprd06.prod.outlook.com (2603:10a6:20b:45c::15)
 by AM9PR03MB7884.eurprd03.prod.outlook.com (2603:10a6:20b:437::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:30:55 +0000
Received: from AM6EUR05FT037.eop-eur05.prod.protection.outlook.com
 (2603:10a6:20b:45c:cafe::40) by AS9PR06CA0164.outlook.office365.com
 (2603:10a6:20b:45c::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 16:30:55 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.86)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.86 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.86; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.86) by
 AM6EUR05FT037.mail.protection.outlook.com (10.233.241.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 16:30:55 +0000
Received: from outmta (unknown [192.168.82.135])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 431372008026E;
        Tue,  7 Mar 2023 16:30:55 +0000 (UTC)
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (unknown [104.47.11.238])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 6F30A20080075;
        Tue,  7 Mar 2023 16:22:33 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F0m9CenAVjR5rJHslwaZOLP+ugsfU0XrNyeZVtfvLnO6YjFojyNGBNoTgARGZyPIJRv0cji4E0MSvchzMNPyh8kRTR78DCGXjsEXezBeZQ5uUho8FTqrnU6hx/tWEulQz25Mbou2y9jokzixgf50ZopbnLkyQ6oGszI71MfYfFxyL8oPliPvOcQYvtDLE5qv3t4RqFzWf0ftvZ1w1FXxmfXDFNCoeJ5nxs0i4WJsDAHoJGZMsLo3JYv6KDmDGJy8Z7IGUw5+MIYWg7KIj0SBtpx18eChIPE0DP5NGH+qLvM/3kKzCZgk8a15rx1K7/6puDTsgqyd1WgvmEFxD0gtrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xfytIfEOycFHmXWz11+CfP640FlpgN6nMHO+k0JvP+w=;
 b=mCLsUyE8C6gePP1XnkUPePDI1vlHL6wV0CpMRWmHBsQWeRLqURHi1Ob7EhwKK+c7auqu2DubOWxOFDs4UGOFejE/WFHwkJswPS/WzxznY6GWDCm8ilH5GpNgUwESCsvBM6GAmhTA2IyMFtvJgM9OA4DA8doYxkGS0PDTnH9Ovr5Iyl2gauQ82Ko+5oRSsCS2nTf99wbG6e2mY+fUkEq3MKwYwwx2I9axworOWAytmlHvz+5qMryYrxl0m0Y2q0mDwIARVnatESUiC2PXmr3aWmPs3qBicFMfX02DUyfHKDUzgEv4BKShgWd4vuRJrMQ8RWQHo6oy0se2NYzSEKb8MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xfytIfEOycFHmXWz11+CfP640FlpgN6nMHO+k0JvP+w=;
 b=sSJZX22VhA2X0hx/9o1FehZzG+c0MByu46bVcXfWtikcYy4LRoR44bTud+tga5Y5YrzdFzRM9JzCBjWwSeeCCV2qJtKeI+IggE6QAcLG2cqjWQRESeAjTNdwLT64ff/wpPuIHKQHKk9+pWum/7nTRqZrMX9N4olfVtxo8+ZUDU+i92jKv6GR0NQXWC90IQIgJHG9tUKMf2v4aAkDeRZ3yCInlhZfXImlg2fCmi/vCJYClXNyOsSPW8Qa1kYmgtzsnHhFY/PnRkGbPRjb91RWuzYCCtHIH+7k9VX0Vktyaqtc5j9Jp5n7cMx2pWNHEd1NrCwdUhdt8DWeXIRL8+GJ5w==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB9471.eurprd03.prod.outlook.com (2603:10a6:10:41b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 16:30:43 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 16:30:43 +0000
Message-ID: <0963cc8b-a092-c743-05dc-c96a5c9d618f@seco.com>
Date:   Tue, 7 Mar 2023 11:30:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <874jqwkart.fsf@waldekranz.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <874jqwkart.fsf@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL1PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::6) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB9471:EE_|AM6EUR05FT037:EE_|AM9PR03MB7884:EE_
X-MS-Office365-Filtering-Correlation-Id: d63b1218-7f12-49d2-f90c-08db1f295342
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Skikquv6JT1MV4Wnn+/yYFVB3xe1n98uMGJJvof3s6mhpKes01VZT5w2jEgWShAJyVsoD2EleRyqiRLCqA6aJvPsOqabejkxfh2ldnN9PJ9zIQ8KIqfrtBYlHY0cjY6o+W4M8QBqEVv82j0ABfIaM7TqdMI4LBzlsFR4rg+YC6DMN9vhuuZzRr8tlMs76fnOl0WAkMrz/sXsd3KVxihC4F7WB9EMRlBMa0Dv+41mszn2s3FWX+aSqLqayUw8B2jfU02DENu8SGJtw3kmaskfE7PU896er9Bs8PI71e6FoArpsvW0Vw9pDEnsY+veYtCpQF/JsOswV1Q4Tai482rHamgphg68S416gppZQ2nti402Wc8m4KPTvPO0+PkozzGEVyJ2o1hzlGIaYmjprSKzMAsCGjPOGKQcA7GOu59kG/kH4LrqbeIACfnHIiybmv9Z5ve0OQdgNAqeVB8t+p1jbWHUaH8usPGs+zy11xbN32zldzGxqCQfgT5S8gjI+bRcfOYrT01ZwjYzw0menbu231ZwhRZHfAItN1+tfnAgevRwzk6buHLJiZQMjhx4mezmPEyGCei+5ZEneNTcUp4MKwJvoEx5doJ0RSkWiSCT65+As/5Qj9uPlj2Cq41up0A64BFfRFmfTVMKSGSVI99DUDarFv6JHbLc497tNzZ9hRtQ8ADr4WXZJLxfkzf6qIRIkr6skS78Mh7oxEb2GYA8QDwZs5JfRUFMjeXx0S2XpkiduzyoKQstLf50P7jqYszJCGLv21CoNq7qfZf/S3apAn6dwqqNCPrSCBn4m/8HklM=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(346002)(39850400004)(396003)(451199018)(66574015)(31686004)(110136005)(54906003)(36756003)(316002)(186003)(38100700002)(38350700002)(31696002)(86362001)(6506007)(26005)(6512007)(53546011)(83380400001)(6666004)(2616005)(5660300002)(8936002)(7416002)(52116002)(966005)(6486002)(478600001)(30864003)(41300700001)(2906002)(8676002)(4326008)(66556008)(44832011)(66476007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9471
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM6EUR05FT037.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: 1a937479-3d2e-4302-d8b1-08db1f294c47
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MpamVr+o3+kniWXSuM1TJm5LRJHdxnSaCVFx2evjVROttRYagZqa/+k/rwndjJWuxavPTMdtEs2IrQqf5f37cLc0bTxt3QTkpVuYaIkwuD8AieMHO1i2Se8AixRzjy1ksM+5bmo0ToW8Sriouqo0O0tkc8G5Ilu6jezFZjziBej71PVeQGLC8M6xV+8plgNWTZ08JDEMEt+XGZRilDZ4rh5edLERyMuF4bx8Gm7AzN4MxYANud3b3F3tBrIid4eENNePZpdZu+kg+Q1I2EAGFgAEK/UX+SD2hPWmSefNm4M63eTT9uvbxFnybuBSLPhPvAS2k88yM/0IFTw29Kd0CIjIlojh0d9xhPM/MOkgtp73PJRg6kHvVQcUZlSPfOE3qzc0LHqIjjXw2JfUys5b39Fas8Xx+o7+s7wh4PyeUGBSM5/rbHctPFnwyltiNu1KV+TNA2Tl2bo5u+djosKZKVGRKhK/k3xTcVfz9FuG5dGSBMHORF5DCnp2T5JjG6msRZmaKceGRTiCDS3B9fcOG3Mf2dABvwCu3a8aBIPr23gS27rFX2iwVsWdIDdBd8ZKTAOtYoEyC2TQSBxE+xuXaxPm79cgLxh6EYHb6BwAL8v8O6M8sj310N/8EUQmeS9z+3E3ETGSWt/kqAvtlTNupjKzri3WHzvx1S096HGEZJq1JhcZnxe7GtUgJjLjtOb60xq+NYDvajTGc4lz6ajvjuMjBsUOunxyH1hVxw1DPmsxqXBAKWwN8jIP6uFRjE6rvELZ1EJBVCNRo3pGMW8JYT6a773P46yC/ShRO1xAxgOa+ZmdxvW0AkWBRxioztyCt+mIzf3WO5vD+fDGcE91zliValkBMJfwuDA86gfndyM=
X-Forefront-Antispam-Report: CIP:20.160.56.86;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(376002)(39850400004)(346002)(396003)(136003)(451199018)(5400799012)(36840700001)(40470700004)(46966006)(82740400003)(336012)(36756003)(7636003)(110136005)(7596003)(54906003)(40460700003)(186003)(44832011)(7416002)(478600001)(6486002)(2616005)(5660300002)(82310400005)(2906002)(356005)(26005)(30864003)(53546011)(6506007)(31696002)(6512007)(40480700001)(6666004)(8936002)(86362001)(966005)(36860700001)(34070700002)(34020700004)(41300700001)(8676002)(4326008)(47076005)(70586007)(70206006)(31686004)(316002)(66574015)(83380400001)(43740500002)(45980500001)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 16:30:55.3606
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d63b1218-7f12-49d2-f90c-08db1f295342
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.86];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: AM6EUR05FT037.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7884
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 07:26, Tobias Waldekranz wrote:
> On mån, mar 06, 2023 at 15:45, Sean Anderson <sean.anderson@seco.com> wrote:
>> This adds a netlink interface to make reads/writes to mdio buses. This
>> makes it easier to debug devices. This is especially useful when there
>> is a PCS involved (and the ethtool reads are faked), when there is no
>> MAC associated with a PHY, or when the MDIO device is not a PHY.
>>
>> The closest existing in-kernel interfaces are the SIOCG/SMIIREG ioctls, but
>> they have several drawbacks:
>>
>> 1. "Write register" is not always exactly that. The kernel will try to
>>    be extra helpful and do things behind the scenes if it detects a
>>    write to the reset bit of a PHY for example.
>>
>> 2. Only one op per syscall. This means that is impossible to implement
>>    many operations in a safe manner. Something as simple as a
>>    read/mask/write cycle can race against an in-kernel driver.
>>
>> 3. Addressing is awkward since you don't address the MDIO bus
>>    directly, rather "the MDIO bus to which this netdev's PHY is
>>    connected". This makes it hard to talk to devices on buses to which
>>    no PHYs are connected, the typical case being Ethernet switches.
>>
>> To address these shortcomings, this adds a GENL interface with which a user
>> can interact with an MDIO bus directly.  The user sends a program that
>> mdio-netlink executes, possibly emitting data back to the user. I.e. it
>> implements a very simple VM. Read/mask/write operations could be
>> implemented by dedicated commands, but when you start looking at more
>> advanced things like reading out the VLAN database of a switch you need
>> state and branching.
>>
>> To prevent userspace phy drivers, writes are disabled by default, and can
>> only be enabled by editing the source. This is the same strategy used by
>> regmap for debugfs writes. Unfortunately, this disallows several useful
>> features, including
>>
>> - Register writes (obviously)
>> - C45-over-C22
>> - Atomic access to paged registers
>> - Better MDIO emulation for e.g. QEMU
>>
>> However, the read-only interface remains broadly useful for debugging.
>> Users who want to use the above features can re-enable them by defining
>> MDIO_NETLINK_ALLOW_WRITE and recompiling their kernel.
> 
> What about taking a page from the BPF playbook and require all loaded
> programs (MDIO_GENL_XFERs) to be licensed under GPL?  That would mean
> that the userspace program that generated it would also have to be
> GPLed.
> 
> My view has always been that a vendor looking to build a userspace SDK
> won't be deterred by this limitation.  They can easily build
> mdio-netlink.ko from mdio-tools and use that to drive it, or (more
> likely) they already have their own implementation that they are stuck
> with for legacy reasons.  In other words: we are only punishing
> legitimate users (mdio-tools being one of them, IMO).

Yes, I agree with this. It's always seemed silly to me to exclude a good
debugging interface on the grounds that it could be used for userspace
drivers when a vendor can just as easily supply their own proprietary
module implementing the same thing.

Last time, the discussion seemed to get hung up on this topic, so I wanted
to start off with an approach which would obviously prevent misuse (albeit
rather draconian).

--Sean

> Perhaps with this approach we could have our cake and eat it too.
> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> This driver was written by Tobias Waldekranz. It is adapted from the
>> version he released with mdio-tools [1]. This was last discussed 2.5
>> years ago [2], and I have incorperated his cover letter into this commit
>> message. The discussion mainly centered around the write capability
>> allowing for userspace phy drivers. Although it comes with reduced
>> functionality, I hope this new approach satisfies Andrew. I have also
>> made several minor changes for style and to stay abrest of changing
>> APIs.
>>
>> Tobias, I've taken the liberty of adding some copyright notices
>> attributing this to you.
> 
> Fine by me :)
> 
>> [1] https://github.com/wkz/mdio-tools
>> [2] https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280/
>>
>>  drivers/net/mdio/Kconfig          |   8 +
>>  drivers/net/mdio/Makefile         |   1 +
>>  drivers/net/mdio/mdio-netlink.c   | 464 ++++++++++++++++++++++++++++++
>>  include/uapi/linux/mdio-netlink.h |  61 ++++
>>  4 files changed, 534 insertions(+)
>>  create mode 100644 drivers/net/mdio/mdio-netlink.c
>>  create mode 100644 include/uapi/linux/mdio-netlink.h
>>
>> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
>> index 90309980686e..8a01978e5b51 100644
>> --- a/drivers/net/mdio/Kconfig
>> +++ b/drivers/net/mdio/Kconfig
>> @@ -43,6 +43,14 @@ config ACPI_MDIO
>>  
>>  if MDIO_BUS
>>  
>> +config MDIO_NETLINK
>> +	tristate "Netlink interface for MDIO buses"
>> +	help
>> +	  Enable a netlink interface to allow reading MDIO buses from
>> +	  userspace. A small virtual machine allows implementing complex
>> +	  operations, such as conditional reads or polling. All operations
>> +	  submitted in the same program are evaluated atomically.
>> +
>>  config MDIO_DEVRES
>>  	tristate
>>  
>> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
>> index 7d4cb4c11e4e..5583d5b8d174 100644
>> --- a/drivers/net/mdio/Makefile
>> +++ b/drivers/net/mdio/Makefile
>> @@ -4,6 +4,7 @@
>>  obj-$(CONFIG_ACPI_MDIO)		+= acpi_mdio.o
>>  obj-$(CONFIG_FWNODE_MDIO)	+= fwnode_mdio.o
>>  obj-$(CONFIG_OF_MDIO)		+= of_mdio.o
>> +obj-$(CONFIG_MDIO_NETLINK)	+= mdio-netlink.o
>>  
>>  obj-$(CONFIG_MDIO_ASPEED)		+= mdio-aspeed.o
>>  obj-$(CONFIG_MDIO_BCM_IPROC)		+= mdio-bcm-iproc.o
>> diff --git a/drivers/net/mdio/mdio-netlink.c b/drivers/net/mdio/mdio-netlink.c
>> new file mode 100644
>> index 000000000000..3e32d1a9bab3
>> --- /dev/null
>> +++ b/drivers/net/mdio/mdio-netlink.c
>> @@ -0,0 +1,464 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2022-23 Sean Anderson <sean.anderson@seco.com>
>> + * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
>> + */
>> +
>> +#include <linux/init.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/netlink.h>
>> +#include <linux/phy.h>
>> +#include <net/genetlink.h>
>> +#include <net/netlink.h>
>> +#include <uapi/linux/mdio-netlink.h>
>> +
>> +struct mdio_nl_xfer {
>> +	struct genl_info *info;
>> +	struct sk_buff *msg;
>> +	void *hdr;
>> +	struct nlattr *data;
>> +
>> +	struct mii_bus *mdio;
>> +	int timeout_ms;
>> +
>> +	int prog_len;
>> +	struct mdio_nl_insn *prog;
>> +};
>> +
>> +static int mdio_nl_open(struct mdio_nl_xfer *xfer);
>> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr);
>> +
>> +static int mdio_nl_flush(struct mdio_nl_xfer *xfer)
>> +{
>> +	int err;
>> +
>> +	err = mdio_nl_close(xfer, false, 0);
>> +	if (err)
>> +		return err;
>> +
>> +	return mdio_nl_open(xfer);
>> +}
>> +
>> +static int mdio_nl_emit(struct mdio_nl_xfer *xfer, u32 datum)
>> +{
>> +	int err = 0;
>> +
>> +	if (!nla_put_nohdr(xfer->msg, sizeof(datum), &datum))
>> +		return 0;
>> +
>> +	err = mdio_nl_flush(xfer);
>> +	if (err)
>> +		return err;
>> +
>> +	return nla_put_nohdr(xfer->msg, sizeof(datum), &datum);
>> +}
>> +
>> +static inline u16 *__arg_r(u32 arg, u16 *regs)
>> +{
>> +	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_REG);
>> +
>> +	return &regs[arg & 0x7];
>> +}
>> +
>> +static inline u16 __arg_i(u32 arg)
>> +{
>> +	WARN_ON_ONCE(arg >> 16 != MDIO_NL_ARG_IMM);
>> +
>> +	return arg & 0xffff;
>> +}
>> +
>> +static inline u16 __arg_ri(u32 arg, u16 *regs)
>> +{
>> +	switch ((enum mdio_nl_argmode)(arg >> 16)) {
>> +	case MDIO_NL_ARG_IMM:
>> +		return arg & 0xffff;
>> +	case MDIO_NL_ARG_REG:
>> +		return regs[arg & 7];
>> +	default:
>> +		WARN_ON_ONCE(1);
>> +		return 0;
>> +	}
>> +}
>> +
>> +/* To prevent out-of-tree drivers from being implemented through this
>> + * interface, disallow writes by default. This does disallow read-only uses,
>> + * such as c45-over-c22 or reading phys with pages. However, with a such a
>> + * flexible interface, we must use a big hammer. People who want to use this
>> + * will need to modify the source code directly.
>> + */
>> +#undef MDIO_NETLINK_ALLOW_WRITE
>> +
>> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
>> +{
>> +	struct mdio_nl_insn *insn;
>> +	unsigned long timeout;
>> +	u16 regs[8] = { 0 };
>> +	int pc, ret = 0;
>> +	int phy_id, reg, prtad, devad, val;
>> +
>> +	timeout = jiffies + msecs_to_jiffies(xfer->timeout_ms);
>> +
>> +	mutex_lock(&xfer->mdio->mdio_lock);
>> +
>> +	for (insn = xfer->prog, pc = 0;
>> +	     pc < xfer->prog_len;
>> +	     insn = &xfer->prog[++pc]) {
>> +		if (time_after(jiffies, timeout)) {
>> +			ret = -ETIMEDOUT;
>> +			break;
>> +		}
>> +
>> +		switch ((enum mdio_nl_op)insn->op) {
>> +		case MDIO_NL_OP_READ:
>> +			phy_id = __arg_ri(insn->arg0, regs);
>> +			prtad = mdio_phy_id_prtad(phy_id);
>> +			devad = mdio_phy_id_devad(phy_id);
>> +			reg = __arg_ri(insn->arg1, regs);
>> +
>> +			if (mdio_phy_id_is_c45(phy_id))
>> +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
>> +							 devad, reg);
>> +			else
>> +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
>> +
>> +			if (ret < 0)
>> +				goto exit;
>> +			*__arg_r(insn->arg2, regs) = ret;
>> +			ret = 0;
>> +			break;
>> +
>> +		case MDIO_NL_OP_WRITE:
>> +			phy_id = __arg_ri(insn->arg0, regs);
>> +			prtad = mdio_phy_id_prtad(phy_id);
>> +			devad = mdio_phy_id_devad(phy_id);
>> +			reg = __arg_ri(insn->arg1, regs);
>> +			val = __arg_ri(insn->arg2, regs);
>> +
>> +#ifdef MDIO_NETLINK_ALLOW_WRITE
>> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
>> +			if (mdio_phy_id_is_c45(phy_id))
>> +				ret = __mdiobus_c45_write(xfer->mdio, prtad,
>> +							  devad, reg, val
>> +			else
>> +				ret = __mdiobus_write(xfer->mdio, dev, reg,
>> +						      val);
>> +#else
>> +			ret = -EPERM;
>> +#endif
>> +			if (ret < 0)
>> +				goto exit;
>> +			ret = 0;
>> +			break;
>> +
>> +		case MDIO_NL_OP_AND:
>> +			*__arg_r(insn->arg2, regs) =
>> +				__arg_ri(insn->arg0, regs) &
>> +				__arg_ri(insn->arg1, regs);
>> +			break;
>> +
>> +		case MDIO_NL_OP_OR:
>> +			*__arg_r(insn->arg2, regs) =
>> +				__arg_ri(insn->arg0, regs) |
>> +				__arg_ri(insn->arg1, regs);
>> +			break;
>> +
>> +		case MDIO_NL_OP_ADD:
>> +			*__arg_r(insn->arg2, regs) =
>> +				__arg_ri(insn->arg0, regs) +
>> +				__arg_ri(insn->arg1, regs);
>> +			break;
>> +
>> +		case MDIO_NL_OP_JEQ:
>> +			if (__arg_ri(insn->arg0, regs) ==
>> +			    __arg_ri(insn->arg1, regs))
>> +				pc += (s16)__arg_i(insn->arg2);
>> +			break;
>> +
>> +		case MDIO_NL_OP_JNE:
>> +			if (__arg_ri(insn->arg0, regs) !=
>> +			    __arg_ri(insn->arg1, regs))
>> +				pc += (s16)__arg_i(insn->arg2);
>> +			break;
>> +
>> +		case MDIO_NL_OP_EMIT:
>> +			ret = mdio_nl_emit(xfer, __arg_ri(insn->arg0, regs));
>> +			if (ret < 0)
>> +				goto exit;
>> +			ret = 0;
>> +			break;
>> +
>> +		case MDIO_NL_OP_UNSPEC:
>> +		default:
>> +			ret = -EINVAL;
>> +			goto exit;
>> +		}
>> +	}
>> +exit:
>> +	mutex_unlock(&xfer->mdio->mdio_lock);
>> +	return ret;
>> +}
>> +
>> +struct mdio_nl_op_proto {
>> +	u8 arg0;
>> +	u8 arg1;
>> +	u8 arg2;
>> +};
>> +
>> +static const struct mdio_nl_op_proto mdio_nl_op_protos[MDIO_NL_OP_MAX + 1] = {
>> +	[MDIO_NL_OP_READ] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_REG),
>> +	},
>> +	[MDIO_NL_OP_WRITE] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +	},
>> +	[MDIO_NL_OP_AND] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_REG),
>> +	},
>> +	[MDIO_NL_OP_OR] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_REG),
>> +	},
>> +	[MDIO_NL_OP_ADD] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_REG),
>> +	},
>> +	[MDIO_NL_OP_JEQ] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_IMM),
>> +	},
>> +	[MDIO_NL_OP_JNE] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg2 = BIT(MDIO_NL_ARG_IMM),
>> +	},
>> +	[MDIO_NL_OP_EMIT] = {
>> +		.arg0 = BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
>> +		.arg1 = BIT(MDIO_NL_ARG_NONE),
>> +		.arg2 = BIT(MDIO_NL_ARG_NONE),
>> +	},
>> +};
>> +
>> +static int mdio_nl_validate_insn(const struct nlattr *attr,
>> +				 struct netlink_ext_ack *extack,
>> +				 const struct mdio_nl_insn *insn)
>> +{
>> +	const struct mdio_nl_op_proto *proto;
>> +
>> +	if (insn->op > MDIO_NL_OP_MAX) {
>> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Illegal instruction");
>> +		return -EINVAL;
>> +	}
>> +
>> +	proto = &mdio_nl_op_protos[insn->op];
>> +
>> +	if (!(BIT(insn->arg0 >> 16) & proto->arg0)) {
>> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 0 invalid");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!(BIT(insn->arg1 >> 16) & proto->arg1)) {
>> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 1 invalid");
>> +		return -EINVAL;
>> +	}
>> +
>> +	if (!(BIT(insn->arg2 >> 16) & proto->arg2)) {
>> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 2 invalid");
>> +		return -EINVAL;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int mdio_nl_validate_prog(const struct nlattr *attr,
>> +				 struct netlink_ext_ack *extack)
>> +{
>> +	const struct mdio_nl_insn *prog = nla_data(attr);
>> +	int len = nla_len(attr);
>> +	int i, err = 0;
>> +
>> +	if (len % sizeof(*prog)) {
>> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Unaligned instruction");
>> +		return -EINVAL;
>> +	}
>> +
>> +	len /= sizeof(*prog);
>> +	for (i = 0; i < len; i++) {
>> +		err = mdio_nl_validate_insn(attr, extack, &prog[i]);
>> +		if (err)
>> +			break;
>> +	}
>> +
>> +	return err;
>> +}
>> +
>> +static const struct nla_policy mdio_nl_policy[MDIO_NLA_MAX + 1] = {
>> +	[MDIO_NLA_UNSPEC]  = { .type = NLA_UNSPEC, },
>> +	[MDIO_NLA_BUS_ID]  = { .type = NLA_STRING, .len = MII_BUS_ID_SIZE },
>> +	[MDIO_NLA_TIMEOUT] = NLA_POLICY_MAX(NLA_U16, 10 * MSEC_PER_SEC),
>> +	[MDIO_NLA_PROG]    = NLA_POLICY_VALIDATE_FN(NLA_BINARY,
>> +						    mdio_nl_validate_prog,
>> +						    0x1000),
>> +	[MDIO_NLA_DATA]    = { .type = NLA_NESTED },
>> +	[MDIO_NLA_ERROR]   = { .type = NLA_S32, },
>> +};
>> +
>> +static struct genl_family mdio_nl_family;
>> +
>> +static int mdio_nl_open(struct mdio_nl_xfer *xfer)
>> +{
>> +	int err;
>> +
>> +	xfer->msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!xfer->msg) {
>> +		err = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	xfer->hdr = genlmsg_put(xfer->msg, xfer->info->snd_portid,
>> +				xfer->info->snd_seq, &mdio_nl_family,
>> +				NLM_F_ACK | NLM_F_MULTI, MDIO_GENL_XFER);
>> +	if (!xfer->hdr) {
>> +		err = -EMSGSIZE;
>> +		goto err_free;
>> +	}
>> +
>> +	xfer->data = nla_nest_start(xfer->msg, MDIO_NLA_DATA);
>> +	if (!xfer->data) {
>> +		err = -EMSGSIZE;
>> +		goto err_free;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_free:
>> +	nlmsg_free(xfer->msg);
>> +err:
>> +	return err;
>> +}
>> +
>> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr)
>> +{
>> +	struct nlmsghdr *end;
>> +	int err;
>> +
>> +	nla_nest_end(xfer->msg, xfer->data);
>> +
>> +	if (xerr && nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
>> +		err = mdio_nl_flush(xfer);
>> +		if (err)
>> +			goto err_free;
>> +
>> +		if (nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
>> +			err = -EMSGSIZE;
>> +			goto err_free;
>> +		}
>> +	}
>> +
>> +	genlmsg_end(xfer->msg, xfer->hdr);
>> +
>> +	if (last) {
>> +		end = nlmsg_put(xfer->msg, xfer->info->snd_portid,
>> +				xfer->info->snd_seq, NLMSG_DONE, 0,
>> +				NLM_F_ACK | NLM_F_MULTI);
>> +		if (!end) {
>> +			err = mdio_nl_flush(xfer);
>> +			if (err)
>> +				goto err_free;
>> +
>> +			end = nlmsg_put(xfer->msg, xfer->info->snd_portid,
>> +					xfer->info->snd_seq, NLMSG_DONE, 0,
>> +					NLM_F_ACK | NLM_F_MULTI);
>> +			if (!end) {
>> +				err = -EMSGSIZE;
>> +				goto err_free;
>> +			}
>> +		}
>> +	}
>> +
>> +	return genlmsg_unicast(genl_info_net(xfer->info), xfer->msg,
>> +			       xfer->info->snd_portid);
>> +
>> +err_free:
>> +	nlmsg_free(xfer->msg);
>> +	return err;
>> +}
>> +
>> +static int mdio_nl_cmd_xfer(struct sk_buff *skb, struct genl_info *info)
>> +{
>> +	struct mdio_nl_xfer xfer;
>> +	int err;
>> +
>> +	if (!info->attrs[MDIO_NLA_BUS_ID] ||
>> +	    !info->attrs[MDIO_NLA_PROG]   ||
>> +	     info->attrs[MDIO_NLA_DATA]   ||
>> +	     info->attrs[MDIO_NLA_ERROR])
>> +		return -EINVAL;
>> +
>> +	xfer.mdio = mdio_find_bus(nla_data(info->attrs[MDIO_NLA_BUS_ID]));
>> +	if (!xfer.mdio)
>> +		return -ENODEV;
>> +
>> +	if (info->attrs[MDIO_NLA_TIMEOUT])
>> +		xfer.timeout_ms = nla_get_u32(info->attrs[MDIO_NLA_TIMEOUT]);
>> +	else
>> +		xfer.timeout_ms = 100;
>> +
>> +	xfer.info = info;
>> +	xfer.prog_len = nla_len(info->attrs[MDIO_NLA_PROG]) / sizeof(*xfer.prog);
>> +	xfer.prog = nla_data(info->attrs[MDIO_NLA_PROG]);
>> +
>> +	err = mdio_nl_open(&xfer);
>> +	if (err)
>> +		return err;
>> +
>> +	err = mdio_nl_eval(&xfer);
>> +
>> +	err = mdio_nl_close(&xfer, true, err);
>> +	return err;
>> +}
>> +
>> +static const struct genl_ops mdio_nl_ops[] = {
>> +	{
>> +		.cmd = MDIO_GENL_XFER,
>> +		.doit = mdio_nl_cmd_xfer,
>> +		.flags = GENL_ADMIN_PERM,
>> +	},
>> +};
>> +
>> +static struct genl_family mdio_nl_family = {
>> +	.name     = "mdio",
>> +	.version  = 1,
>> +	.maxattr  = MDIO_NLA_MAX,
>> +	.netnsok  = false,
>> +	.module   = THIS_MODULE,
>> +	.ops      = mdio_nl_ops,
>> +	.n_ops    = ARRAY_SIZE(mdio_nl_ops),
>> +	.policy   = mdio_nl_policy,
>> +};
>> +
>> +static int __init mdio_nl_init(void)
>> +{
>> +	return genl_register_family(&mdio_nl_family);
>> +}
>> +
>> +static void __exit mdio_nl_exit(void)
>> +{
>> +	genl_unregister_family(&mdio_nl_family);
>> +}
>> +
>> +MODULE_AUTHOR("Tobias Waldekranz <tobias@waldekranz.com>");
>> +MODULE_DESCRIPTION("MDIO Netlink Interface");
>> +MODULE_LICENSE("GPL");
>> +
>> +module_init(mdio_nl_init);
>> +module_exit(mdio_nl_exit);
>> diff --git a/include/uapi/linux/mdio-netlink.h b/include/uapi/linux/mdio-netlink.h
>> new file mode 100644
>> index 000000000000..bebd3b45c882
>> --- /dev/null
>> +++ b/include/uapi/linux/mdio-netlink.h
>> @@ -0,0 +1,61 @@
>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>> +/*
>> + * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
>> + */
>> +
>> +#ifndef _UAPI_LINUX_MDIO_NETLINK_H
>> +#define _UAPI_LINUX_MDIO_NETLINK_H
>> +
>> +#include <linux/types.h>
>> +
>> +enum {
>> +	MDIO_GENL_UNSPEC,
>> +	MDIO_GENL_XFER,
>> +
>> +	__MDIO_GENL_MAX,
>> +	MDIO_GENL_MAX = __MDIO_GENL_MAX - 1
>> +};
>> +
>> +enum {
>> +	MDIO_NLA_UNSPEC,
>> +	MDIO_NLA_BUS_ID,  /* string */
>> +	MDIO_NLA_TIMEOUT, /* u32 */
>> +	MDIO_NLA_PROG,    /* struct mdio_nl_insn[] */
>> +	MDIO_NLA_DATA,    /* nest */
>> +	MDIO_NLA_ERROR,   /* s32 */
>> +
>> +	__MDIO_NLA_MAX,
>> +	MDIO_NLA_MAX = __MDIO_NLA_MAX - 1
>> +};
>> +
>> +enum mdio_nl_op {
>> +	MDIO_NL_OP_UNSPEC,
>> +	MDIO_NL_OP_READ,	/* read  dev(RI), port(RI), dst(R) */
>> +	MDIO_NL_OP_WRITE,	/* write dev(RI), port(RI), src(RI) */
>> +	MDIO_NL_OP_AND,		/* and   a(RI),   b(RI),    dst(R) */
>> +	MDIO_NL_OP_OR,		/* or    a(RI),   b(RI),    dst(R) */
>> +	MDIO_NL_OP_ADD,		/* add   a(RI),   b(RI),    dst(R) */
>> +	MDIO_NL_OP_JEQ,		/* jeq   a(RI),   b(RI),    jmp(I) */
>> +	MDIO_NL_OP_JNE,		/* jeq   a(RI),   b(RI),    jmp(I) */
>> +	MDIO_NL_OP_EMIT,	/* emit  src(RI) */
>> +
>> +	__MDIO_NL_OP_MAX,
>> +	MDIO_NL_OP_MAX = __MDIO_NL_OP_MAX - 1
>> +};
>> +
>> +enum mdio_nl_argmode {
>> +	MDIO_NL_ARG_NONE,
>> +	MDIO_NL_ARG_REG,
>> +	MDIO_NL_ARG_IMM,
>> +	MDIO_NL_ARG_RESERVED
>> +};
>> +
>> +struct mdio_nl_insn {
>> +	__u64 op:8;
>> +	__u64 reserved:2;
>> +	__u64 arg0:18;
>> +	__u64 arg1:18;
>> +	__u64 arg2:18;
>> +};
>> +
>> +#endif /* _UAPI_LINUX_MDIO_NETLINK_H */
>> -- 
>> 2.35.1.1320.gc452695387.dirty

