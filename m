Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA4B570CF5
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 23:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiGKVri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 17:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiGKVrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 17:47:37 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18682443;
        Mon, 11 Jul 2022 14:47:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AzEEozAW96AXhbZY3W1muaD+mYdV66qBC08Rcl0STuAO3u65OFmZRXGJwo9G6OP9+iyNTuxvE6o4M0M/NssjHtmPi8AhN1pOTvp898rhiZ+7cK8jY3BtXIUmS6FKkNRfF9og0PmI1u05Eu3oCmHH7365WEpDOfxt2In9a7KPo8OIf0c4CY0GnatqW8EJ6iT53TmMAhHMwhIuGueV84lhpo7aBu1NFgAKxlRK2cM23mdP4OXkN4ByYrelvHEXUX+wY6BrzuieJNd/HakZHrPEVn+Nx7MphE/drVO94z4tL56fNmEEamhNdKLMBOIZm94mWeZCFp5JH22SZONLjKONog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/gUEFRWoJDyggpSwTcb53bsubS/tVw1oV2aDh1SHzAU=;
 b=WGTOC+eEEvYcqBBp+FF1G7tVhAhunLbDtJQnu2rvhZPHU/azcn9ezt+Y2foAeHw4Mhv5XhPjiFk+OCRkRSw2f4KFVS/vpJe0X5D3hY0QKB/ULg8J2cK9U8YMBYzAkWUGos9fQ8iNEG9/Snhq90q/bqksnE+mMIo8wC9Cmbn1H5OimSylGmdWnPSlbVROXppHPtjLZM8GspU1qgtNVaaAInjuyKJ9iisIvKrjGs0mtRqPG6I2E66cYqSkO2JqTQ5n2QQp2PBc+ilk8J0wfFKmQ4cILKbOE1DYR9LURfeu3fe63bVBYoVleCnadPfCfa6WkCrzf2gzVQdNf6F9G+0kCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/gUEFRWoJDyggpSwTcb53bsubS/tVw1oV2aDh1SHzAU=;
 b=1kyO8FQVIdJET2Bv12BPGUGRjPvevPTREOBxStFTlH1IVsu+9Lb7UPaO9QH7M9EmxPVsf1jFx4N+allG7C8frAN9Cd7pL+xaMIunenNcVjw/ij54noqVzxsKSHJUbxrmI9YvNAc4NQmgVxtOmPwjjMiQeMM040QEz/AoNDwNL/0PcsfW76p0bmkEip4dgvDfsaez5DGR9Q8mhQq+vnblriNMn7G1fgmhIuX38WOHHXNDlY9vUAqULcKhnuINJiNNuEvaDg7VnsjI/aeeXeE9OYRbnwxOJSG4O22ijLRY+X9F+Daj9UuKt4TX+IvabpkBmuNXa+EdJf1OfNsV2ovidQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM7PR03MB6596.eurprd03.prod.outlook.com (2603:10a6:20b:1b0::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 21:47:32 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 21:47:32 +0000
Subject: Re: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering
 and finding PCSs
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-4-sean.anderson@seco.com>
 <YsyPGMOiIGktUlqD@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <3aad4e83-4aee-767e-b36d-e014582be7bd@seco.com>
Date:   Mon, 11 Jul 2022 17:47:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YsyPGMOiIGktUlqD@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:610:33::18) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e4e85ca-a0c5-4e55-55aa-08da6386f570
X-MS-TrafficTypeDiagnostic: AM7PR03MB6596:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HVJSZYwMCd+aO2xOL6KIdkGHgIZ7oOdZ9BEA/HL3cHSX5P6rfMLulOxzGxgFbyHWDyighlZDNgqS/RKFjce5zy2tTX2sbmzuaIb2iZExvVpQacoA6SAdZGC6iYEIRR/R7+Uw+SLWA9ycvk5w4rnbI6ZLP9VY+FaX/1MmPMlbVWTOo39k6CLiEbXh1YZkw/AaYbkGiJEkS7qr4KLilWde3Mz+St3ptIT9moUcoLABTDgLtB9f0rJMiPexqgEJUf9Rn8MHO2TlYjPybQ/eNWwTDollHXBYyWEMV63TeLgAHScmCprGESvaDZ/f8rQ/oO/mSzpPD9McfrkLOvt0309V9w/sHeCTsf6rHlsP+6jYof/zLV7iwQKHg8BVpD92ZJcb8y1TZgzNJ51zHfyXlzTjrEQNJX1SW28F9JW8JT/AW144ZfsG7lMwxuwjSMIsx9Fa9c8mYiy2JL+2uNCdIW3nRReO2hzVmgdpS9yi2+KcvzMFKiOui0jNMmNHSovs/kEV8Ube7RPqCcv9mSFUumHbsmkxlYx7QKTNCZ3HfEo/yTcFiBFSS++q4lmHjd52InMXhQiJKoIFkUyHoDfmT1NvoK2qrtT/VBik8EVQZQ4qRBe6Bm83smAwImuxTiS+R1pS+eOAUVQQfGsR5IBJQIAWTGr4QmAiqvXXBx7u4wyhd3lRuuoKH9y5tZ3z4TDza/7nWwmjYfNGqMBbnurhOXPoNzD1/uIUl1dn4nVZyfyqUxoFhRvXzCzUqs4EriqCZCmw3om2+2RqqapYaoTJAJDo9Aj+YMO8J8VsuuLa/zxXxRw5Bu+opl1c6DgE1oZ8U2Cvur8zkDvOukOdK1Wa/hpmWkrTJbpdZu20dIhdIebSbHSM9ePxPOEMG/FFHR5WNRyF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(346002)(136003)(52116002)(53546011)(5660300002)(6506007)(26005)(6512007)(6486002)(31686004)(6916009)(478600001)(6666004)(41300700001)(316002)(36756003)(54906003)(66946007)(2906002)(8676002)(186003)(83380400001)(86362001)(66556008)(4326008)(2616005)(66476007)(7416002)(44832011)(8936002)(31696002)(38100700002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UVV3NmJ1MGU5cFBETDd6THJMam8rdzgxNlI3ejJVMkxDUjMrMnh4WnJZRUFE?=
 =?utf-8?B?c2pKQitzL3phUlloWXZ0aVhRK2JUUU1PODNXYlpObmVRQW1KazZFR2xHVmlY?=
 =?utf-8?B?TkZZS2JHSHoyU1F1Z25nRjlNdHdlRlpqRTBNNGhwbkxTL3hzbkVPZWtwTWVG?=
 =?utf-8?B?N2VrclcxSGd4WTlqVUxOT1ArMnlZRTduYW9wOGVXbEZ3UENHUUcwLzFGUVov?=
 =?utf-8?B?azVsQjAwWkZVbHFBdndvc3JIemhhcXllRDkzVkpaVVQrQVFDczVBUkZqdkht?=
 =?utf-8?B?dTcxUE1WTEtNZURPcHcxT28ydGFOczViSFJDWWVxZG1rR1JHU3NOc3JlRGFl?=
 =?utf-8?B?UG5XNWFxa1Z0RWhpQWRRelJHSzV6YUtTTHU0NHFVdEFwS0NZQmJ2SFd5bitP?=
 =?utf-8?B?djNPZWZsRGxNQ21BdGhzSXpVZmtZZ09WVlUxSXVqeUt4N3U2VGczcWR2dzM3?=
 =?utf-8?B?Q2RVRDhzT1BtV1J0RFZYcWc3YlZzQjJSSFBaMncySDlITVh1QWxmemhxUExP?=
 =?utf-8?B?QkV0VjNjb2xteFZDaTBTSDVxeGV5My9OOFhTazBZVlVLa1BMK0tCZTYwS2lY?=
 =?utf-8?B?RG1CVkFSMktwTC9FRkxva1ZwZ0F0VlZTM3NnNHR0SU9hRjZuYUhyTFFQUGV6?=
 =?utf-8?B?YTUxb05ISjBScmNxUkM1QlpuWFIwY3lxejBMTUYvK3JzbitKOWNYa2o4TGVq?=
 =?utf-8?B?N2c1T2VTbkkvaU9UZzdMYUJDdDU1d2ttOWUyejlVejNPRmlTeXNEWmRDMks1?=
 =?utf-8?B?ZXhOdVdqY3RhcmU0U1NKK1VqbmcxNytzeFgyemRITjAralJJVkNJZDNiT0xG?=
 =?utf-8?B?eEJERjdMNVk5bStQc2xvei9nSzhTcGVUUjVmNDVWOUpBSVdUeUU1T3FLMXNp?=
 =?utf-8?B?VG9oN0JGc1lidHVzN3ZvYWdFNEhNRjZYQVNFSTk1dTBwcTlrKzRRSG52Zzhz?=
 =?utf-8?B?MU1WMS8xTGZPd2VCVU9sUGgwdXN3Tmw5ZHhZMm4xcmQ0RlJBaHMyNlhoWDc5?=
 =?utf-8?B?OVhqVmhSRWZsZldGdVZiaGJPVGlZUHN2bE1VM1VCOHJmbG1FU2ZUTllLallr?=
 =?utf-8?B?K0xacTRWT0VMbFhENmFrU2JJUkx6aUlhaEd0M3RUT1gxb285ckV4UUNkdkNq?=
 =?utf-8?B?aXA5eVN6V01rRTVQZlRxN2pmd1UrWjN0VWhlRHFBb3R6UjcvM1lZL2QrUUhB?=
 =?utf-8?B?NnhZTU9lWjU2aUpMNEZWV0VLaFhBL0FlcWRtSDIyMlUzZzd4MGFtV1BqNFJj?=
 =?utf-8?B?Ny9pSnZuNGFnM2Noa1BiQVFIZVl2ZVBXRlZ1WFhGY2NaVVJxemlRbjFEem5D?=
 =?utf-8?B?WklNOUl1V281YzBic1NVVHR2UWEwa1JRaGVnVUtRVDdMay9hL1hyelZ0R0wy?=
 =?utf-8?B?TER1Uk9NZHRkaGV2M2Z0Wnl5THdyOW9pVENQaElEWmY5N2g0bDhLRTE0RlZX?=
 =?utf-8?B?UFViVGNsUU5oelh3ZkVLTktkL25DMHE4OFFGOExsRHZONGNRSWZaOXViZ3Rk?=
 =?utf-8?B?WHZBYXJZZE5NcTNsN3N2bVJpYmthdkRaSFhWL28rZEJ0VXNEZlo4WGkxeXRn?=
 =?utf-8?B?QSsxVWdrK3BraHl2UTVpT3lCV0tWR2VhMk56K1U2VzhPTlNtaEhZZUthQzEr?=
 =?utf-8?B?dnpYcWx1T0ZrWWFOc09Pbm1YZmJsenJkSGFwZGgvU3FIclRHMXZQRGNaeGs0?=
 =?utf-8?B?blNBdC9rTkdJZnpsdC9rUXlDeGV4MDRjSytIOUJxL0dObUpxNUhQWjJxS21u?=
 =?utf-8?B?TEVjVnJ5ell1dWdPTHUwUlljcm1XeU45dTRFc3hkTWZsZFVMN2ErK3gvdjRW?=
 =?utf-8?B?ZDczc2lpMmZIMlp3eFhoL0I5U0ZjWmlwTEFVZEZCeDh4NXdweThuZlAvRUN5?=
 =?utf-8?B?RjF2TlB1TnRnb2Fod1JMQmhaZnQ2M2oxS3lmY1kwUnZUYkJVU3AvNjdtS29E?=
 =?utf-8?B?cTk4cDhDOVBaY2NRMmxGbTFOQVFlVDQwQzR5WG9SZFdJM1YxaWdjQ0lTSkRE?=
 =?utf-8?B?U2Q3N0VmbkxWTGFyQXZoK2d0bnlJT3c2ZG81clNMai9naGNmcnNwaWdIN0py?=
 =?utf-8?B?YTY5UmNlRGdmUVAwUm0wY2NKRHV2a2lrSmEybkUzRzEvMmFqbWVJREh4eE5M?=
 =?utf-8?B?aFgzNHBTTVFxUGc4UzdJWWJKZzFuOW04ZlFYcmtKQnROQWVudDk3cEk2SU91?=
 =?utf-8?B?VXc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e4e85ca-a0c5-4e55-55aa-08da6386f570
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 21:47:32.2300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVmICDUhHYEJ6PQMMtVZpH1BWTjrrbySPk0xpPmg4mBpJIO7+9fCsOBTiFjvrxzCM6MNXqBgIWYW5E6ni5P1AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR03MB6596
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

On 7/11/22 4:59 PM, Russell King (Oracle) wrote:
> Hi Sean,
> 
> It's a good attempt and may be nice to have, but I'm afraid the
> implementation has a flaw to do with the lifetime of data structures
> which always becomes a problem when we have multiple devices being
> used in aggregate.
> 
> On Mon, Jul 11, 2022 at 12:05:13PM -0400, Sean Anderson wrote:
>> +/**
>> + * pcs_get_tail() - Finish getting a PCS
>> + * @pcs: The PCS to get, or %NULL if one could not be found
>> + *
>> + * This performs common operations necessary when getting a PCS (chiefly
>> + * incrementing reference counts)
>> + *
>> + * Return: @pcs, or an error pointer on failure
>> + */
>> +static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
>> +{
>> +	if (!pcs)
>> +		return ERR_PTR(-EPROBE_DEFER);
>> +
>> +	if (!try_module_get(pcs->ops->owner))
>> +		return ERR_PTR(-ENODEV);
> 
> What you're trying to prevent here is the PCS going away - but holding a
> reference to the module doesn't prevent that with the driver model. The
> driver model design is such that a device can be unbound from its driver
> at any moment. Taking a reference to the module doesn't prevent that,
> all it does is ensure that the user can't remove the module. It doesn't
> mean that the "pcs" structure will remain allocated.

So how do things like (serdes) phys work? Presumably the same hazard
occurs any time a MAC uses a phy, because the phy can disappear at any time.

As it happens I can easily trigger an Oops by unbinding my serdes driver
and the plugging in an ethernet cable. Presumably this means that the phy
subsystem needs the devlink treatment? There are already several in-tree
MAC drivers using phys...

> The second issue that this creates is if a MAC driver creates the PCS
> and then "gets" it through this interface, then the MAC driver module
> ends up being locked in until the MAC driver devices are all unbound,
> which isn't friendly at all.

The intention here is not to use this for "internal" PCSs, but only for
external ones. I suppose you're referring to 

> So, anything that proposes to create a new subsystem where we have
> multiple devices that make up an aggregate device needs to nicely cope
> with any of those devices going away. For that to happen in this
> instance, phylink would need to know that its in-use PCS for a
> particular MAC is going away, then it could force the link down before
> removing all references to the PCS device.
> 
> Another solution would be devlinks, but I am really not a fan of that
> when there may be a single struct device backing multiple network
> interfaces, where some of them may require PCS and others do not. One
> wouldn't want the network interface with nfs-root to suddenly go away
> because a PCS was unbound from its driver!

Well, you can also do

echo "mmc0:0001" > /sys/bus/mmc/drivers/mmcblk/unbind

which will (depending on your system) have the same effect.

If being able to unbind any driver at any time is intended,
then I don't think we can save userspace from itself.

>> +	get_device(pcs->dev);
> 
> This helps, but not enough. All it means is the struct device won't
> go away, the "pcs" can still go away if the device is unbound from the
> driver.
> 

--Sean
