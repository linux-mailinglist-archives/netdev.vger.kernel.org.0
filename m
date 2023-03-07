Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9796AEBC4
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 18:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjCGRsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 12:48:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjCGRs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 12:48:26 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04hn2245.outbound.protection.outlook.com [52.100.17.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32418C96C;
        Tue,  7 Mar 2023 09:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YU9ZQdnGno3h1Hvh5Q7/OaiOBoWpH/SBTsGCuGX2sM=;
 b=GnA4kO1FxiInmtstj1qesFMvBmoqAzYq3Sh/QL0AGd5jhszHftoTzHZmZIASmu50z9ai2Q5fQIyIEhFUAylxM59t/MRKtrTikBl8qua5xbOrHDt1wc8Ul6Vy0FmQUmfxG+yvkYiR/pspgjpcocxSKrB8NRPZnrKHB1UIj+ATyrmRJcrQ4FZGEPeh70R8VNHUE8nvyxzhQ8yKjxPu04lyZW+AXii/BiD5om+DoLnGOgfzM2FliDAtFLjtHStO5w8oZ6uhYh1qUnz2kNXnexiEidb/h75zFYdPrCuc94CXaqDL5gl1u598t+GXO+pcGMJ2dzZfmZ/gL5+Hb5lRB3BBUw==
Received: from DB8PR04CA0003.eurprd04.prod.outlook.com (2603:10a6:10:110::13)
 by AS8PR03MB7014.eurprd03.prod.outlook.com (2603:10a6:20b:297::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 17:43:02 +0000
Received: from DB8EUR05FT057.eop-eur05.prod.protection.outlook.com
 (2603:10a6:10:110:cafe::2e) by DB8PR04CA0003.outlook.office365.com
 (2603:10a6:10:110::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Tue, 7 Mar 2023 17:43:01 +0000
X-MS-Exchange-Authentication-Results: spf=fail (sender IP is 20.160.56.82)
 smtp.mailfrom=seco.com; dkim=pass (signature was verified)
 header.d=seco.com;dmarc=pass action=none header.from=seco.com;
Received-SPF: Fail (protection.outlook.com: domain of seco.com does not
 designate 20.160.56.82 as permitted sender) receiver=protection.outlook.com;
 client-ip=20.160.56.82; helo=inpost-eu.tmcas.trendmicro.com;
Received: from inpost-eu.tmcas.trendmicro.com (20.160.56.82) by
 DB8EUR05FT057.mail.protection.outlook.com (10.233.239.147) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.16 via Frontend Transport; Tue, 7 Mar 2023 17:43:01 +0000
Received: from outmta (unknown [192.168.82.132])
        by inpost-eu.tmcas.trendmicro.com (Trend Micro CAS) with ESMTP id 19A7D2008026E;
        Tue,  7 Mar 2023 17:43:01 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (unknown [104.47.17.111])
        by repre.tmcas.trendmicro.com (Trend Micro CAS) with ESMTPS id 942CD2008006F;
        Tue,  7 Mar 2023 17:41:22 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fetpZ9ssJzyL8zb9RWOL9lqTXIiCMcUlWY/D1vDEoldOLLBYOFb5335S6Y5rTrsx/N1GNsZDhGW1XOhZ598HxFZDk5Fdh8PLSDqJMQLgHTkcZ1njKPIyU0yC5AkrFph8NyVqdGjbjQGBPUBRX8HUAoIkcmNj6eIqJzXOFcswh99C5WOb7EXslxXxbKbcn1z5MQnWMrvw1qVQYz4T1hhUP9T/McvvR09epEho+VoosKwZNESD+Lo3BhdZnKnMMxUzgROJiO4xv8JKwaiu374u12JtzhxVFOXJMnL0HEREqw0GY3AjXUUgvlm6sLU2aE1NzKGy/kSyYWo2jhAMVu6kdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/YU9ZQdnGno3h1Hvh5Q7/OaiOBoWpH/SBTsGCuGX2sM=;
 b=QVuhtkFxIPFkZrO13M0S5lvR1GkxRKEG8V3sv11Te8sGDvkiBL/GdktWgEvvjwebrrwIN7eVfpjbXwTyXOlB10+KBN+X/2TSWICmIr0ZdvCts1lmaJURCKvze+/GnlS7VXzqgnm/OswEa6X6C9OrHGmrsAwa9N7YAdj54WVKmcH5qxdnnU4+a4621WMgRfYJ2RIDQgeXD7D7mmbVOk7oOp8NIsNMx8elJHu2ZeEnltHYaZ54m5d/agX9Iw+mjm9ugogz79F/Uv4EfI11xJRJyn/e9jJqU3UfgY6ajdNoBb/WrgwUlQKfwQ6ha0UV95FbZJG9FYSfWdLVEkTdUZw64w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/YU9ZQdnGno3h1Hvh5Q7/OaiOBoWpH/SBTsGCuGX2sM=;
 b=GnA4kO1FxiInmtstj1qesFMvBmoqAzYq3Sh/QL0AGd5jhszHftoTzHZmZIASmu50z9ai2Q5fQIyIEhFUAylxM59t/MRKtrTikBl8qua5xbOrHDt1wc8Ul6Vy0FmQUmfxG+yvkYiR/pspgjpcocxSKrB8NRPZnrKHB1UIj+ATyrmRJcrQ4FZGEPeh70R8VNHUE8nvyxzhQ8yKjxPu04lyZW+AXii/BiD5om+DoLnGOgfzM2FliDAtFLjtHStO5w8oZ6uhYh1qUnz2kNXnexiEidb/h75zFYdPrCuc94CXaqDL5gl1u598t+GXO+pcGMJ2dzZfmZ/gL5+Hb5lRB3BBUw==
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DBBPR03MB6777.eurprd03.prod.outlook.com (2603:10a6:10:205::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 17:42:55 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::dbcf:1089:3242:614e%5]) with mapi id 15.20.6156.027; Tue, 7 Mar 2023
 17:42:55 +0000
Message-ID: <f58d54ae-c144-2e1b-dc0e-23c7b3d9b489@seco.com>
Date:   Tue, 7 Mar 2023 12:42:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
 <7a02294e-bf50-4399-9e68-1235ba24a381@lunn.ch>
 <f947e5e2-770e-4b12-67ae-8abf5866e250@seco.com>
 <ae66193e-db1e-4883-bda1-2be5312630df@lunn.ch>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <ae66193e-db1e-4883-bda1-2be5312630df@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0125.namprd02.prod.outlook.com
 (2603:10b6:208:35::30) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DBBPR03MB6777:EE_|DB8EUR05FT057:EE_|AS8PR03MB7014:EE_
X-MS-Office365-Filtering-Correlation-Id: 9f0b7c9d-e578-4300-4c85-08db1f3365c5
X-TrendMicro-CAS-OUT-LOOP-IDENTIFIER: 656f966764b7fb185830381c646b41a1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: cIU0kwu7bUcWuUumiZd0jbgdoMCIEEYiLlAGnS87jtnw5a86gN/x84SIlPYKVc5zEJHEKW0G/vieLcik9YyXoiKTz0W/RE7WGQcVPkkeepavmiUAmNlKLpeXxnkBrCR5GaASMivIsXf8gZUHGoHaR5hXVHJZaXu5PVc/J9+KddAdqOV9FFYgw8VtAXYV6mynQsZXYu9VAaVBvcIknDS1/oT6QlGat1KZiJPj5refl51vm2U+58tdY+hBwoaY3bWYh7Td/GyNox6T01gWO2/0paO4EcFhWgflrtYyRIvN+dmViYkdnGvZWvxYrRYWwllhfanuHhWograDXuz1kiy9aOLsq/DYlgw80ElPSD0nBsMdvTnDphuQOvj+VbPPTSzNoQEaHBe6hh8njxBAta1ErCMOeF85Pe+wwo3xX5CE5ZJZ1c7JO/BrW0n//I49pLxaOr90m4f9OGBb8c5cGsb29wcxRmvzsqpNJMwUu69s07+oD1sKHYDoQ7mz5fXIStJPejVT1JX3m8x+93/ZrwE01VMR+s7frO53Uv8KW5bt8MCT3qcEMY4aSV+V4yQVw0QY4or/CQhAODJyRnAXkBtm3U+Udj25Phtxw3JYnWnWozr4oerzOdsGELHMh0jzvRxSWaJm0vIV1yvysPCHJAUpIkWQRNZNO+dz4cnMTJUivhUrBUFwPNEDEPdn28z0v/2v0JnZjKKXH1DLJY8hVYLM9korGx2qTFtir1RGIbbrTTL7MPEvmIMzQxNmSOkcknqgniLCGx8G8c37rSRKSqsFJQ==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(39850400004)(346002)(366004)(136003)(451199018)(31686004)(44832011)(2906002)(7416002)(5660300002)(8936002)(41300700001)(83380400001)(6916009)(66556008)(66946007)(66476007)(4326008)(8676002)(54906003)(6666004)(478600001)(6486002)(52116002)(53546011)(26005)(6512007)(6506007)(316002)(31696002)(86362001)(38350700002)(186003)(38100700002)(2616005)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6777
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB8EUR05FT057.eop-eur05.prod.protection.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs: e4c88975-8125-4a65-12d7-08db1f3361dd
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6CImOjAnoLBoYClR0WXyHtE9RQiSuKeh8hJ1hZvVF/ZS18F+6ecWDknkwVWdaxVEOlY79l+sx6xJ0IcAXUbb9NB8WPLl28EyGwUEABKV7w4aVp/Rl4wttTnz63L9bGuFZIjT5SQahcMdFIykndeJbEqdxEqkSO2hdoxmaZ2iPXrQFuXCH1v0iYXCvO65sf0mjGp1UJCc9BplGw+190ap2MpQW04TBJ01X8FljjAcN4/kXUAw/ZZbecW7U0l27CQzdJX8kdCXsx2DOIaXtbRlfI4ykg91/ocHejidn24XNV0BkGuwOnfHTVcO0NkDuS+YQypwgRBS/STHsTLJmK2jgAMf1mzKfeTjbw5gaRKuL5xEXyAG0FexmdB/3R1oW9OgLsSvpYK0ke7tjDnmY92a0uYHntw04vKkvo5axmUKM0+iK9K1tTDcAlF9rqzStzOnME5oGNNX9sNvbl/p1SXmiQkl8ixEICa6TopF2KgfStlQj3P9bMJuoWk2arrjdUYbHMcv0Me/LbFnE0ZkMttcp6nd85nmZf+yxRhKstybIF31TN5DvEtU13pcahhlgxPnR/pg4ePCoibB1tszujmwT7VSkU4eJ6IpT5QYrDiO0SnJr14X0eNb7OgqF7FB1ekbvWKcbpij0TOpPextMM97SNTL9aJnwRFgfJVYeTgJb568CUQVUcRVpfygl3cyajwvyDMsn+IZPNDcRBrUABxhW68IuC7h88C8bcdarP3sciAB99DU4R+RTl07cX4auggDDyHE/8x3UJMvWM5G8GIeGkcaWTHoY5VinEL0JeBww0WWf0a4f6QCOhNvQXu3TZ0AB3/N6Mc+jD3L54pgfTdjn35+Z9gLn5+UjpDFFDRS/Gg=
X-Forefront-Antispam-Report: CIP:20.160.56.82;CTRY:NL;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:inpost-eu.tmcas.trendmicro.com;PTR:inpost-eu.tmcas.trendmicro.com;CAT:NONE;SFS:(13230025)(136003)(346002)(396003)(39850400004)(376002)(451199018)(5400799012)(36840700001)(40470700004)(46966006)(70586007)(8676002)(4326008)(70206006)(6916009)(83380400001)(186003)(31696002)(86362001)(336012)(47076005)(40480700001)(82310400005)(54906003)(7596003)(36860700001)(356005)(7636003)(82740400003)(34070700002)(36756003)(26005)(34020700004)(6666004)(316002)(53546011)(6512007)(2616005)(478600001)(40460700003)(6506007)(6486002)(5660300002)(44832011)(31686004)(7416002)(2906002)(41300700001)(8936002)(45980500001)(43740500002)(12100799021);DIR:OUT;SFP:1501;
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 17:43:01.3498
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f0b7c9d-e578-4300-4c85-08db1f3365c5
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=bebe97c3-6438-442e-ade3-ff17aa50e733;Ip=[20.160.56.82];Helo=[inpost-eu.tmcas.trendmicro.com]
X-MS-Exchange-CrossTenant-AuthSource: DB8EUR05FT057.eop-eur05.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7014
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/23 12:23, Andrew Lunn wrote:
>> Yes, and I should probably have commented on this in the commit message.
>> IMO the things you listed are... iffy but unlikely to cause a
>> malfunction.
> 
> You consider a missed interrupt not a malfunction?

Hm, yeah that would probably do it.

>> >> +
>> >> +	for (insn = xfer->prog, pc = 0;
>> >> +	     pc < xfer->prog_len;
>> >> +	     insn = &xfer->prog[++pc]) {
>> >> +		if (time_after(jiffies, timeout)) {
>> >> +			ret = -ETIMEDOUT;
>> >> +			break;
>> >> +		}
>> >> +
>> >> +		switch ((enum mdio_nl_op)insn->op) {
>> >> +		case MDIO_NL_OP_READ:
>> >> +			phy_id = __arg_ri(insn->arg0, regs);
>> >> +			prtad = mdio_phy_id_prtad(phy_id);
>> >> +			devad = mdio_phy_id_devad(phy_id);
>> >> +			reg = __arg_ri(insn->arg1, regs);
>> >> +
>> >> +			if (mdio_phy_id_is_c45(phy_id))
>> >> +				ret = __mdiobus_c45_read(xfer->mdio, prtad,
>> >> +							 devad, reg);
>> >> +			else
>> >> +				ret = __mdiobus_read(xfer->mdio, phy_id, reg);
>> > 
>> > The application should say if it want to do C22 or C45.
>> 
>> The phy_id comes from the application. So it sets MDIO_PHY_ID_C45 if it wants
>> to use C45.
> 
> Ah, i misunderstood what mdio_phy_id_is_c45() does.
> 
> Anyway, i don't like MDIO_PHY_ID_C45, it has been pretty much removed
> everywhere with the refactoring of MDIO drivers to export read and
> read_c45 etc. PHY drivers also don't use it, they use c22 or c45
> specific methods. So i would prefer an additional attribute. That also
> opens up the possibility of adding C45 over C22.

Well, this is really just because there is an existing way to specify c22
and c45 addresses in a u16. We could definitely add a "please do C45 over
C22" flag. That said, I think that sort of thing is handled better by
allowing writes in the general case.

>> As Russell noted, this is dangerous in the general case.
> 
> And Russell also agreed this whole module is dangerous in general.
> Once you accept it is dangerous, its a debug tool only, why not allow
> playing with a bit more fire? You could at least poke around the MDIO
> bus structures and see if a PHY has been found, and it not, block C45
> over C22.

I can look into that.

>> >> +			if (mdio_phy_id_is_c45(phy_id))
>> >> +				ret = __mdiobus_c45_write(xfer->mdio, prtad,
>> >> +							  devad, reg, val
>> >> +			else
>> >> +				ret = __mdiobus_write(xfer->mdio, dev, reg,
>> >> +						      val);
>> >> +#else
>> >> +			ret = -EPERM;
>> > 
>> > EPERM is odd, EOPNOTSUPP would be better. EPERM suggests you can run
>> > it as root and it should work.
>> 
>> Well, EPERM is what you get when trying to write a 444 file, which is
>> effectively what we're enforcing here.
> 
> Does it change to 644 when write is enabled?

Yes. But it is more like 400 and 600.

> But netlink does not even use file access permissions.

Is EPERM reserved only for files?

> I would probably trap this earlier, where you have a extack instance
> you can return a meaningful error message string.

That sounds good.

--Sean
