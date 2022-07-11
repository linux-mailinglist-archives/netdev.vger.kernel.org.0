Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2C16570D0C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 23:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbiGKVzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 17:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiGKVzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 17:55:14 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B32A95D;
        Mon, 11 Jul 2022 14:55:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JqCFKN4WgHra6ueOCfcJphLB4TRYwL1cDUcrhpJWlFju3+jwmvNXcAGy4Q3joV7beEIkTU5ydgBkS0lbsv1zkO3gBqtfxmQTW1w2m8A9oq4iAM3WE31F9EW/xRBbAuHRUsnSXYMqj52v0hCe+/M09cFDQjx22zrITqsG2o5/q3oS2/mixDfA1a5kPKadrV0MU4Uv6pfOavesBx/LyihsRsfMJURfGRK1BONnvUA5/r4J0JuyW8xcVRLxQADqUg6Ls84QIFywf51hcQchVcxtl59hXbH2zoQr3kySpxtOc/354kHpLquUqjoep4b/Jywr6WWKKLAsOFzUAF4slPmCpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cJF+E5gQKrK9RlHGVJF4vpSWAXTQCyvK2+uORg2FSvU=;
 b=JcHW73oNZiiEDA0MKPPpUNOUZ18dW4cC9E69wbmhHZ2U2GZNe7ySTKAbt4vFDKU/8uhljlwxD+gKJwGbszAml9EjJ5fLG/nuRssahx8nu24PFKfU7MiX0n5Qib4hDrTDa92TYn080UENr1wn53qkG8emTEX36tVwvpjKRA4y4wW14HyTBp7OCdmR524kNyTrTjIpguoQ+EbI9xhaA7eqjpbiTNU/cxKvhZ7sRM/X+0DDmq6VuoXpyctU7q+cQD5Gi3jhgcyxrfHam8jq90fBm6H4yHgpzB4P0EHfVZ1tNjb/fNzI3qcli+wmCxoD6RED3AJG9u2pu8ayf36YaB8ZKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cJF+E5gQKrK9RlHGVJF4vpSWAXTQCyvK2+uORg2FSvU=;
 b=X2QXurbaWewylQMDK58tgFuutuwNO22CR0zfcArobhWJe6kQ8Tz75aaaPzGUDJwzSnzv66WU/eM5EuY9xAJKgfMj7pVpJNY40E5sbkLEmdYNH3JDtTVgQ5az9e3MLycvERaYUvJTK0a2yChmDboeCe8VMbt26Qmf3izRGXqnihIyZDiVssigO9+lzHbSmerMUAcrUwvviydT8gugH3Le0caspez3ztAZpoEBKY/eox+Mdxaoi2/rLw7W+bGS648zvLAq3HykAEFB/LHmJ3BF2WiXwXi0SPvngd/BlIzyDeX3uNBJ/M6e5hmUptr9WhDPEqWj29Xtu1Y/UUwS8z6v0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7376.eurprd03.prod.outlook.com (2603:10a6:102:107::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 21:55:10 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 21:55:10 +0000
Subject: Re: [RFC PATCH net-next 3/9] net: pcs: Add helpers for registering
 and finding PCSs
From:   Sean Anderson <sean.anderson@seco.com>
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
 <3aad4e83-4aee-767e-b36d-e014582be7bd@seco.com>
Message-ID: <77824ea3-7d74-9738-4bdf-e624d46e0003@seco.com>
Date:   Mon, 11 Jul 2022 17:55:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <3aad4e83-4aee-767e-b36d-e014582be7bd@seco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR20CA0013.namprd20.prod.outlook.com
 (2603:10b6:208:e8::26) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 737cdc76-70bf-41a9-f274-08da638806c5
X-MS-TrafficTypeDiagnostic: PA4PR03MB7376:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mO9lZe5MSWxbEQvV0vYDTr6NYrLs++KEbZeRJXeKy3qdsNO/TJH1jgNHoqheBPdg7XepMQ5TB9IWnHBkGgZE2YpYfXO+e56l3OIlJcstuVOHV5IdRlD09iWZALec8+GWDRgsmrhqx/Dc3pxbBmmP95R0swiZJP9RoU9WMk2bS1k4AyBLpqHyLaAu0/PcCIh85v2HX3TAXn69AmO2kOwLd1JhMaw/hz/NQuXGvnBRasisdKfuNpICut4Rfh2XZV0LSmCH8/xHH9z2JvZRsgcSb6+QU2BA9xCXi1pz90ehuiKbvLU83yG0JycGGwWnb4t8S9usilnlhH0KDkrN3uUqkat6f2McF0TnznJZlyaOpfc5CF7jnUvxyX1/eoKD/V61vpl8ANrJKDH9w9rd1RBXdArgoRXFT3YJUyurFVV9OubufVVnCpVURxOY5YOlxLjPQa/n4ZNaDrMkxKPCaJEA/c6jMvlDMVpcXUfJyxU6mgBrt4T6JItXwm94WwXwNbVrAyA0Luw5tkrYXP9W7Cnqvs40bRCCPl0gG5pa3SLa6VkkbREEj8aJNhMMH3noPu1ve0IXoz73vmZs1Q8SMX2DZyYqBotNcJQ4SEo9zLgo4zjsY0jDZi/FNzF8MwLbjalv3odUCtYDg89S+Pk02IJJCuGABKW9/ywN9ejOL9cKbv5/9j/yG05Lh2V2jiChR1q8y1SphZX3x1dWPn9W8K9nofF4CR6Lz2lyciW9eMz2MGcMckEL2kNLyYrB68yzI6ByKUN78InOc6p1Jbg/VQVEXpQ0gAQ61vcI7+U3ZrsgTH9FhMMeKNR+h8TrVK5+8k3QO1Do+7kMks7AdsMo8sIB0l3c4b6IX9nTMvT58oQlXJWXiFOW064jtEh4ESPpe4E7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(366004)(396003)(376002)(6506007)(478600001)(6666004)(6512007)(2906002)(86362001)(38100700002)(53546011)(41300700001)(26005)(6486002)(44832011)(38350700002)(52116002)(8936002)(5660300002)(7416002)(2616005)(31696002)(83380400001)(66556008)(316002)(66946007)(4326008)(66476007)(54906003)(36756003)(6916009)(8676002)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TFVIUm1wSUVqUGlaODZ5WjkvY0tVSVE3UW16c2pTQlJIRi9NZHl5L29hY2dL?=
 =?utf-8?B?azk3SGEvZkVhZ0Q1OTdwYkJDdE5CQTd2RHhiQUszdmVac1J5NlR5Q0xIUlI1?=
 =?utf-8?B?aVF6TGM5RkpicW10ZVZWTHpPdWJuQ01qc3N3R0VkOGNVOTFPRHRodTdaSlNU?=
 =?utf-8?B?VkpsT2c0NjNhc21YMHdsdDVNakpWVnhiUHNpNDg1dlJKNXgzOElTcFNPWUEy?=
 =?utf-8?B?OWcyQ2tvbU5IdnBtc2lDdDVIQVFLT0NTd1V5SjhUMTdXR0ZmMXp2ck5ub1pN?=
 =?utf-8?B?RDdMVGg5NGZNWmxzeTkwUytLWmVucFZHdjlsOVZGUnFwQlJPM1hHTERaV09T?=
 =?utf-8?B?NWMwbEFuZkRTakd3UDh4RDYvem9JTjhzdGppL3JNOWZtdFdJV3VWNDlqSjdw?=
 =?utf-8?B?TU41M3ZSR1R2RzJ0UmpIWU5NT2VXTXYxT3FQYkFycGtHN05UR0RMQUxCNUhU?=
 =?utf-8?B?WkVuZUVCcW1DWEpNNHNhRzh1RXZBUG5ZWnNxVDcvMlRSd0k3R1hkTnJVZWRo?=
 =?utf-8?B?dmhtdExXSXJTc2pwOTg3MzJTTzg2eTk2VDc5MStDYzJyQnNqRHd4RXRkVHFh?=
 =?utf-8?B?Tkw3MHp2WHEyaXlNWXVsUHBLRTdJSTk5VUdUQmpNaWtxRnVvOFREbmlpMm9F?=
 =?utf-8?B?d1JKOHhOV1dkYTVKR29IeW5UbzFpakM5RUhyNTZaNGRSQlpYOFVuNGNkaWJl?=
 =?utf-8?B?VCtxbWN0dHVicTIycldPMjRNbTlGTDkxbjRPZHQzWWJ0dFVyZ2FVVkdBeGhs?=
 =?utf-8?B?RC9ydVVyRVZzN25zczh0cDdOTE8vMG42Rmc2Y1Jrci8wRzJKT1dJYlc1TTQz?=
 =?utf-8?B?bmQyTkExb05ld29QaVJqMld6WGVydlNRWlZzRXZ0eC9mU1d1ZndpVVhqTlRS?=
 =?utf-8?B?UGdneDVYMGZqVzZ0UHNqVko0cXFsRW4wZWFEdWhUZUxjQXB2UVRYMXRmbXBp?=
 =?utf-8?B?cHF4MDI5SmFOOFJWZy9Obm5jY3lNQ1pqTk5ZQVh4VEUvTHFQOEJGNHhSbGM0?=
 =?utf-8?B?Zk9KbDZYQisvWXdsU3JUOWJVR0x4d3hFaXg5Z2dvdGhRYTZXRmtlMDdGUDhF?=
 =?utf-8?B?VGp6dlJ5aFgxanJZZ09sN1orY0JNVm5mMXNtQjdMYTBSU01PWDBQdmtYL29a?=
 =?utf-8?B?eWp5NitMSzEvbkF1Q1FXQmVrQkd1UDJ3UklIbWlpSk50cTdlcTE5UlZJQzhk?=
 =?utf-8?B?OVAwODVsUFJIWEZzamRmOEJHVUpTV1Z6OTk0ekJnOWRLM0ZqSWo1UXF0b1Jm?=
 =?utf-8?B?ZU9ubWdlM1VnM3NmZFJNU0NidWZtZkZHWkEwcmFEa3duaHVKL1JsdWdMQ1I0?=
 =?utf-8?B?dGFSRDlSczkzbjR4SDg1Z09xSVNDVUdodmJtQ09lc0hJbVE1MWh2UXlwRGly?=
 =?utf-8?B?Rk0yNUVXNmJ4NHpuaFhhbjJkdXd4TlR1YUZGa3FPYkxmejc2YjA5WEJ4c1Za?=
 =?utf-8?B?S09YTmthNDhKNXczeDZNVTRBQ1F4OStHekVqSUkrUnVDSzEzN0RuS1VHVGVW?=
 =?utf-8?B?ZW05dVhDV09Sb2FVTVArcnBLd2dnUHpYZVBJc2RIS1F2Uk5WRlN0OFp4cFZQ?=
 =?utf-8?B?djNFc2RCR2Rpc2NVMFhpZlR6b0x6RTBkcXc1U3dLakN0NGNxbWRSZ3RrVncw?=
 =?utf-8?B?Tkpvd3dzRWJNUGRhR2g2UzNWWFRlNG4ybnlnQzFucS9hTUduRlZPTHJzR1Rn?=
 =?utf-8?B?dDB2R3hFZWtPb3NZTERaV2MvRXFsWmhGNmlQbzJUMDFadXBabWxITGtmcHlF?=
 =?utf-8?B?SWxlTlplQ3YyemtxRkFuUEhtMllhblV1UVU0eXUyQzlDNlRQc0sxeFErVFdV?=
 =?utf-8?B?dnFZZ2dKb09yN00wSFFyRkNySnVudHlYMlJST3R4SUhZQ2NVZG1Fcmh6Q2gz?=
 =?utf-8?B?WWcrOFdkMHoxRWw2aFZmSUhGZDZtM3JtT1BvUWFQMXF6UFUzVVZCK2ZBZllI?=
 =?utf-8?B?ZE04TitnSndiOS9nL1RhbE1oeGIrQ29DVTlLTGNha0J3c0dLN1AwaUlhcTRX?=
 =?utf-8?B?T3lOdmJhQVNNak9qT04vaHU2ODBoR2V3UEMvZXE5WldIYkxvY3doU2I5Z0JT?=
 =?utf-8?B?ZGJvVUVTckhzM3gwUGJ4bitEajcvS0h0MkVVMUNVT0tUUXJZQzdGM1dyVXUz?=
 =?utf-8?B?M3llcWFFWmJ4bWVPL3RaUVhyMVV1RVh0WGNxWjd0T1A5KzZsVjR3Zi9hK3NZ?=
 =?utf-8?B?N0E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 737cdc76-70bf-41a9-f274-08da638806c5
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2022 21:55:10.7934
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z/49V6nNJXN24BAkMYVzCgJg84GAUivkmJNl6THRoIloSov3x14Mm3jIotk2GSR+VTo8q9mWf/2iap6clkC/AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7376
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/11/22 5:47 PM, Sean Anderson wrote:
> Hi Russell,
> 
> On 7/11/22 4:59 PM, Russell King (Oracle) wrote:
>> Hi Sean,
>> 
>> It's a good attempt and may be nice to have, but I'm afraid the
>> implementation has a flaw to do with the lifetime of data structures
>> which always becomes a problem when we have multiple devices being
>> used in aggregate.
>> 
>> On Mon, Jul 11, 2022 at 12:05:13PM -0400, Sean Anderson wrote:
>>> +/**
>>> + * pcs_get_tail() - Finish getting a PCS
>>> + * @pcs: The PCS to get, or %NULL if one could not be found
>>> + *
>>> + * This performs common operations necessary when getting a PCS (chiefly
>>> + * incrementing reference counts)
>>> + *
>>> + * Return: @pcs, or an error pointer on failure
>>> + */
>>> +static struct phylink_pcs *pcs_get_tail(struct phylink_pcs *pcs)
>>> +{
>>> +	if (!pcs)
>>> +		return ERR_PTR(-EPROBE_DEFER);
>>> +
>>> +	if (!try_module_get(pcs->ops->owner))
>>> +		return ERR_PTR(-ENODEV);
>> 
>> What you're trying to prevent here is the PCS going away - but holding a
>> reference to the module doesn't prevent that with the driver model. The
>> driver model design is such that a device can be unbound from its driver
>> at any moment. Taking a reference to the module doesn't prevent that,
>> all it does is ensure that the user can't remove the module. It doesn't
>> mean that the "pcs" structure will remain allocated.
> 
> So how do things like (serdes) phys work? Presumably the same hazard
> occurs any time a MAC uses a phy, because the phy can disappear at any time.
> 
> As it happens I can easily trigger an Oops by unbinding my serdes driver
> and the plugging in an ethernet cable. Presumably this means that the phy
> subsystem needs the devlink treatment? There are already several in-tree
> MAC drivers using phys...
> 
>> The second issue that this creates is if a MAC driver creates the PCS
>> and then "gets" it through this interface, then the MAC driver module
>> ends up being locked in until the MAC driver devices are all unbound,
>> which isn't friendly at all.
> 
> The intention here is not to use this for "internal" PCSs, but only for
> external ones. I suppose you're referring to 

(looks like I forgot a sentence here)

...things like MAC->MDIO->PCS. I'll have to investigate whether this can
be removed properly.

>> So, anything that proposes to create a new subsystem where we have
>> multiple devices that make up an aggregate device needs to nicely cope
>> with any of those devices going away. For that to happen in this
>> instance, phylink would need to know that its in-use PCS for a
>> particular MAC is going away, then it could force the link down before
>> removing all references to the PCS device.
>>
>> Another solution would be devlinks, but I am really not a fan of that
>> when there may be a single struct device backing multiple network
>> interfaces, where some of them may require PCS and others do not.

I wonder if we could add an enable/disable callback of some kind, and
remove the devlink when the PCS was not in use. Not ideal, but then all
you have to do is set the interface correctly before removing the PCS.

>> One
>> wouldn't want the network interface with nfs-root to suddenly go away
>> because a PCS was unbound from its driver!
> 
> Well, you can also do
> 
> echo "mmc0:0001" > /sys/bus/mmc/drivers/mmcblk/unbind
> 
> which will (depending on your system) have the same effect.
> 
> If being able to unbind any driver at any time is intended,
> then I don't think we can save userspace from itself.
> 
>>> +	get_device(pcs->dev);
>> 
>> This helps, but not enough. All it means is the struct device won't
>> go away, the "pcs" can still go away if the device is unbound from the
>> driver.
>> 
> 
> --Sean
> 
