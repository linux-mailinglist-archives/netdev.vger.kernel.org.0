Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A7B5787B3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233616AbiGRQpQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233162AbiGRQpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:45:15 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30072.outbound.protection.outlook.com [40.107.3.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5D4183;
        Mon, 18 Jul 2022 09:45:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHIukWZmrelzGdeQuRHwP/u+gEhdrAbBeRayishdb8ks34X8deDD8iJNpYWVzsOxeTHpYZlUU1h7Q69o0HiGpN/sSHyQK6lujnAqjNMSCovDWWZV4WqY1n/qiK08b2UrWfeGmXUNcdECwTEEyBT5Ne+QwA/ktF9dxn9hDd96wAuQ01A0jqZZgkEegGuugQkvR2sgqOE76UWZfmHY0phTg1zARCF03UVM6KW9tLc2tfmpeVvp/Cb4zu5xZPaI35Rv82+SvZeqWEG7kp5NbEds7UeWse1kYVqd6U0/qdd0oeMc+LVNATcvGlYFoEqMAGrMNIRWFCU/KJGhSgNCcPu5KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8de9/IXARlwuszu31MRhEzUqkMhFnveT7HioF/xKnpY=;
 b=fl/qpg8aOtRfYwAT+BNAUb+5tEUJvVR67m+TGn6XoKBtoSy8DBi47XAi3alNB6wkksobRp81pw2hAnw7W/E5gQaSOgBSD3OjcxBxkS4zgBlKMWWa9zu9dWPn14ybWLVu0wycjirfeIQhgUcPhv7qkxlNkLxc4jp62ZsPAFfQgn7N8I01/OMXiwvAKTXkzev32/1l9tydC26CJgDfDH33o8qZf9HLFvPqm8WXSzxpZ9pjGA6tfDODvvJnwSItCdJH3gelq6Jlt3Jbkt/TlX6ojoMHPi6aCt6aMY5LSGSjvgZxFiZmaBoauWHSjkqaE00JyqJJmTganSknCmxpbq4ifg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8de9/IXARlwuszu31MRhEzUqkMhFnveT7HioF/xKnpY=;
 b=PW0zaMpcRhJqZvL/5bj6zW1vyxffb8SUCSohYLKnFYG07wDBay1U/M6evxqm0KqrXzUg6okas3WF9dte45dLOIetPfRunVoZrb7tadJJiaizwKdwnGonHQiUI96RI/fpecgPskR22BvmQJa2qRQkhGMUhLU7wYqA/fvONW6e/GKyC884rANH7aqdSaNIcqlN9Ok8EIouQO5AElmITEFjjvI4Mn+h1mZd5y6BLISXHLDKwk2p0Weg0SIL1Xks162Nf2XSJ2MBf39HgKsDPlhpzFtH7g0+wPj5AZFPimQFQ1NpGjXc89BZY4SGlZLaXT3tzTWc/fLl7uk53nw8zqiqSw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5814.eurprd03.prod.outlook.com (2603:10a6:20b:ef::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23; Mon, 18 Jul
 2022 16:45:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.023; Mon, 18 Jul 2022
 16:45:07 +0000
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
 <YtWGZ4ZJ6rmLmlWk@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <9a968425-5621-09b9-febe-2086d5492c96@seco.com>
Date:   Mon, 18 Jul 2022 12:45:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YtWGZ4ZJ6rmLmlWk@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:610:b0::13) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4da51b64-a2d0-4681-96af-08da68dcdf15
X-MS-TrafficTypeDiagnostic: AM6PR03MB5814:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ifxk1tzBROLousUVgHS1nEPegXI3qobLYW2T9sFYCnfVzb+RYEbFCYmq5nyl01GVjAAaISja2o39mR1rfeQvSrjEtaUwpm8j0J0JSyZOjyR7ILhNA/OSMBR4ylg+sMc5FQMvgnr91DSNBpuF9AHAEaVSCbinXfpfjs3kzzPefwgYCgzJD+JKxCHEubEiV96DQwBtw8lfgQwiDRgcLtR3lFm0TaxIeIuwUvHKDbYLbd3AJIGYDLccCSkoT+SxwAZOaDJxIsYivMmBbB0oBnRIHv0bpI4TRLpyTMs+jjJ508qOYSjWYWYRso21Qx68CPPcLqUDZDQ4+8IRBEXRKEAu8yIGzJOZyDulROi3kza3+G3kLgq8u60dc17L9jcSvdfgOHhPejUqIcE3+zeQ9DtWqzFgLsVTsS7RImeW1+06LZ6GSwcDCC+YWfTTKK7nmgzB/UixBtWKvmYtnesXYxAEzjRgnVvJzpHWyZj3T5LAMLr3AhRNMw7+Dn9h02cx/azHrROLwjA5RxK6Zkg23qXWgQ9U+VD7CrezMjbudjUIvyGr9Yzegy+ZREjrPPS4dwlBcv0/TYL7a0s2WJSI9EBRnxvSyaVmq48DaXV2zYT3J4sZxs5WiejKtq/Jpi7LV0IltxaY9jbW8cNBIQt3tyCX1SqyEfGI5QfQrLWErDKs8bPAzWc9Ssk1UAWXqTsjBb7FVv8+mnjdfn+rS5ixCZ3iCFJ4zQiQc5MsdGxWW2x04Tcx7+G3bOumXRLo0V5yd+jtlKpMRbuPWJjjrFUg3QL43FQshjOinXzUbQ5RaUMRpkCOd3sDi5+P/3pR36tnbU75bLjTa7WGiC/FR9R9JicHGo0JEUIyMMDZr/MaXs1rb0qlys3YAPa0FzmsxK+OAoty
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(376002)(39850400004)(366004)(346002)(2616005)(5660300002)(86362001)(6512007)(6486002)(6506007)(478600001)(6666004)(52116002)(31696002)(53546011)(2906002)(8936002)(44832011)(7416002)(26005)(41300700001)(4326008)(186003)(66556008)(36756003)(31686004)(6916009)(66476007)(316002)(66946007)(83380400001)(54906003)(38350700002)(8676002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bzArRTFVOVk1OS9FckxoOWNVbFVBWnRXc2I2K2hiclZtN2xEZ0VDZHFyeFFh?=
 =?utf-8?B?MTRYQnZzekJwVWdzRVFTT0NuaGc0cmdKWW9iK1dheTd5ZUkxQ1RGc0pjWm5C?=
 =?utf-8?B?ODA3dVpLVklQUmRxSFhPYXExL3RUTjF2cGRZZXZ3M0dTaHBDZU9TK0RRNFBI?=
 =?utf-8?B?UEFuSjNGVW94RFlQY1NGZE1pSy9xKzdlOENiaUp4dzE4N3FhdndQVmpvazlH?=
 =?utf-8?B?VnZTTkp4eFp4SkVoK3EvUmU5VnIzNzkwNUxuQVI3L2RKbnRYcnZjeVdKcnU0?=
 =?utf-8?B?ekEwRDMrUUtpQ3lYRVlHeC9oMm5YU2NTeDFYekpGbnJncDNXajVNOFB3SlVp?=
 =?utf-8?B?ZmZuU3JJYmNRNXJCUHNVTmNHdFJFRnBYcjd3QldEM1FXKzg4SXVkOHdEcHVU?=
 =?utf-8?B?T2JFd2tUdk5jUjNXM3NOaHVEOTdTQlZUS3VhdHkwVi9kU0pFejJpcG01WjZy?=
 =?utf-8?B?d2pPZWdORDRvMzc1d0FBdzB1YmUxb0VLY3JaWDBMRXIwdzBOazh5emF1YzdQ?=
 =?utf-8?B?b3grT3BQUlJJSHI4anU3cnROYmI3SzNOaGttRUpPU09IN2VpK3I3UFZEMkdi?=
 =?utf-8?B?WmxlcWpRSG9Wanh1RG1hbFBkYVJncFJhV0QyK04ySklGNEMwVm40ZW80VXJs?=
 =?utf-8?B?dXdpcm5kbGxCRVAvbXIwNno2MnNieFNDQm5xRGdGMzIzRkFmRUswdStBbTYr?=
 =?utf-8?B?ZjFqM3Z2UGtCZ09rdnoxS0lzUzlvMnM3UGF2bnJEMUFyazRBTzc2bS91ZTh3?=
 =?utf-8?B?Wlc3TVRBSkk5QTd1NmhrdVpXV3VFcmRWbHFydkdhSHdLSEcrUk9wL3AzUWlM?=
 =?utf-8?B?Si9lYXFOaytUT1k4cjNiYzJwY0VlU3dlSHVqM24yTkZVYzRsd3UyV09aamtW?=
 =?utf-8?B?a2FXY0RxV21ZSjNhZFVZKy9vOWw1bWRRQWhVb2RzbThFUFVNU3F1Uy9ITytS?=
 =?utf-8?B?VWZPYW5wVEtCRE9pN2RzUDU3ODg4RjE1OFhYcnRIWWRLeHFBaXp2aEdqeHJO?=
 =?utf-8?B?b2ZWVWM4d1ZCNVZWOWVpRGM0VEJLZitSNW1aSlJsVkVnN3dxWHlvdVZDUy9N?=
 =?utf-8?B?c3lBWmdDM3dRUVpwN29TNSt6T25hUFd5azhZMW5HemdESEMxN1VLQkNVRE5S?=
 =?utf-8?B?WVNBKzFMZE8yZ3NiQnhwd0drUHFLVjl6bGs1K0dpRlRIbHYybSt2eEhQK3o3?=
 =?utf-8?B?clpVYjZIS0tFME9mTnExaTdySk94a1c1S1lReXZ1ZXdDQUwzUVBUOUpuYnl6?=
 =?utf-8?B?dU05eitubVIzNGExNnFFNGhadW14Ykh6bHA1VWtyUnZFTW5QOVUwNkZpSnBC?=
 =?utf-8?B?SytpS3NSWEFDaE9kQlBydEZkQm9LVzlnUWJHOVVnVTFVaElwVmNnRmlWcmdE?=
 =?utf-8?B?YUs2WHJmanNWQWo1cHYyYlRHTUxnek1aMlkzMlYvZnZtRGVuR3RtaEJ0OTMv?=
 =?utf-8?B?dGlHd2NVQStHVDhOejVmbVpteVVZblVaZlN1Y3hWNzYrZVRuMkNWNnVJd1BM?=
 =?utf-8?B?MUZ0b21ocDhOWnRZUFZKeTM1TFJPS2NvaStWUVZvYlJQVTRJUmVMVVJ0bFNJ?=
 =?utf-8?B?WXBORklNc2NsNjh6U0l5ZFlsSGtZUVBPMEQyTWRrYnBOdkU0YkdwbHNNeGla?=
 =?utf-8?B?YU50bmxhSTcxWFh4TkwxSXpqRmNOQUp3UHZ2c3VxWTAySHhjckJnUWgwS25n?=
 =?utf-8?B?OXRGbDRhbWdtd0dCa1JSblNEZkIzMlJiZHZnQTNTbFQxY3JQbG1DZ0RyYWZW?=
 =?utf-8?B?Z0pKRzd2Z2QwaHlxZEZtbDl6cEpuT2Vvd1k0Q09mSWQxUG1MVElNYWRjZFc0?=
 =?utf-8?B?anpQeVFvTHRpR0hzOWlHakE5R29xNkNpRXYzUlo3MWR3WEg3dENZWm15cEhk?=
 =?utf-8?B?TmZyVGkxRDBqYmVMbUxGdTNnVWxzVUl3V2h5WUFMdS96NlBveVZPeDJ3KzNU?=
 =?utf-8?B?d3JtQ2UwYjg2Y3FHU09seGVQT1dqMVpZYzZ6MlBFWFJRN0lXZU4xL3VCdXNO?=
 =?utf-8?B?WVd5SWtCd2lYSVJ6VCs1eW0wMWZRTno2ZFk2RTRyeHZXRVc5SjVscUZTQnZF?=
 =?utf-8?B?dTZCT1BxVXV4ZWpoc2cyR1VWN0hnSUVoKzg3NHZuK3JhbVNJZ1RkMmlKZ0t4?=
 =?utf-8?B?VGFENXZpdk56QStndUFaNld1bjVSNkhYdW1jekFVUEJqVDU4ZzFYUHNadERk?=
 =?utf-8?B?d3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4da51b64-a2d0-4681-96af-08da68dcdf15
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 16:45:07.2580
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrjYozCM2sYMYz88KOwXKRvTjkYd9hWgS7bNeFSjCANIlUEVWbgNVPz8dPg+G5Byz7JdKbV0l1N5s3eE1/olNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5814
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/18/22 12:12 PM, Russell King (Oracle) wrote:
> On Fri, Jul 15, 2022 at 05:59:17PM -0400, Sean Anderson wrote:
>> If the phy is configured to use pause-based rate adaptation, ensure that
>> the link is full duplex with pause frame reception enabled. Note that these
>> settings may be overridden by ethtool.
>> 
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> 
>> Changes in v3:
>> - New
>> 
>>  drivers/net/phy/phylink.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>> 
>> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
>> index 7fa21941878e..7f65413aa778 100644
>> --- a/drivers/net/phy/phylink.c
>> +++ b/drivers/net/phy/phylink.c
>> @@ -1445,6 +1445,10 @@ static void phylink_phy_change(struct phy_device *phydev, bool up)
>>  	pl->phy_state.speed = phy_interface_speed(phydev->interface,
>>  						  phydev->speed);
>>  	pl->phy_state.duplex = phydev->duplex;
>> +	if (phydev->rate_adaptation == RATE_ADAPT_PAUSE) {
>> +		pl->phy_state.duplex = DUPLEX_FULL;

Just form context, as discussed with Andrew, this should never change
anything. That is, it could be replaced with

WARN_ON_ONCE(pl->phy_state.duplex != DUPLEX_FULL);

Since the phy should never report that it is using rate_adaptation
unless it is using full duplex.

>> +		rx_pause = true;
>> +	}
> 
> I really don't like this - as I've pointed out in my previous email, the
> reporting in the kernel message log for "Link is Up" will be incorrect
> if you force the phy_state here like this. If the media side link has
> been negotiated to be half duplex, we should state that in the "Link is
> Up" message.

So I guess the question here is whether there are phys which do duplex
adaptation. There definitely are phys which support a half-duplex
interface mode and a full duplex link mode (such as discussed in patch 08/47).
If it's important to get this right, I can do the same treatment for duplex
as I did for speed.

> It's only the PCS and MAC that care about this, so this should be dealt
> with when calling into the PCS and MAC's link_up() method.
> 
> The problem we have are the legacy drivers (of which mv88e6xxx and
> mtk_eth_soc are the only two I'm aware of) that make use of the
> state->speed and state->duplex when configuring stuff. We could've been
> down to just mv88e6xxx had the DSA and mv88e6xxx patches been sorted
> out, but sadly that's now going to be some time off due to reviewer
> failure.
> 

--Sean
