Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E5962FB48
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:12:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbiKRRLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiKRRLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:11:45 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2047.outbound.protection.outlook.com [40.107.21.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7AB8CF22;
        Fri, 18 Nov 2022 09:11:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JRUEuDvDry0ilx7Y2G9quuaMBQMQJNu1erg87CHj/TZBZ5twmHkaUdHyz7P6Ud/iCi8iF9lR6ZJYbLHesm2KgJpBKdDS7w5lfQcEOSqllVd09eApkcprGL/lkKqqodXLrlYIOGH0LpeAIv5GbWy3xWiLeXmnqfW6FKkcF8xQFG1LxmukIWw9vSrSCMWjCcn4kjWv36ffsihz1WMz3rVizQ7HViVEBIgglyRbysPw7mkziUSYul4Ab6ZpG/oTaT84LwRY7MCsn/uGKSxDOeCkySrMNqHPId2J30YgIIaEpAOnSZXNeKnUQNSoitNeNFQStKReCDUlw6qsCHqALs/N3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ejvo88f7Jpf3Q9AstpFgq1AcEIdXDDEhr0u2lhAfCNQ=;
 b=O7FCyi8DLShJMakf2ghPNmHogNCEjDkNKN/3GV79oRXUcK+RPKTWM2Z1FFotYHtKhLZHQsnfR2qtEGAASbgHm0IM1xRhpAAKdKyydM3O2Pzc/IILWtFJL5v9x448N0qtHWbY8n+1nxa7G0p+9hJxIz8iS1AJBxe2A/+13V070YZ7MB5QMNrzw5FB20UFOMt716+XXeqV5v+LM+jBLKZa6jcBRoV9zL5VSHrv4kMslx5nkLCLewswdDzEu/5BJIfujAnNctJV8RJjvVkyzQSsvzVSG0fsJih8G4a9Zqbhrz200CZhRpySvsHLxWrY+ILgCrRaaxaQViOOJpA4OP2Bng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ejvo88f7Jpf3Q9AstpFgq1AcEIdXDDEhr0u2lhAfCNQ=;
 b=2askRnzOSFNr5qIZWNuUnu59TW5saH5AnRzzKwUkpcBEHVnJU2zVlt++q4N/9atFp8Heiib2ifftnJt+XVKoli/gmxOXhp5Wbs+IVGm+Zd6AbHCjlZtEE+rQaIaaBC0vfCRMoPV2HbFxBRkO9m6kHI3CYQ0363i/Fm5EUAvAvrlI/IwY1/8SG+VnTb5Ygt/yL/hCLRBKaqYAt2Lgz3lyj2cr90XW24OCXtA0tb4fmRdSxK/m9RXXxEryTzOknkrg3yDZp1Kij42g0PwuXFALxllPLhcoe5odZM14B288IGNUnkvpQKe7WZY2KZygIpQqX810cfmW5BA5GKsjb8hzlg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by AS8PR03MB9864.eurprd03.prod.outlook.com (2603:10a6:20b:562::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 17:11:39 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 17:11:39 +0000
Message-ID: <1015dfec-542d-8222-6c4e-0cf9d5ee7e5a@seco.com>
Date:   Fri, 18 Nov 2022 12:11:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] phy: aquantia: Configure SERDES mode by default
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221114210740.3332937-1-sean.anderson@seco.com>
 <20221115223732.ctvzjbpeaxulnm5l@skbuf>
 <3771f5be-3deb-06f9-d0a0-c3139d098bf0@seco.com>
 <20221115230207.2e77pifwruzkexbr@skbuf>
 <219dc20d-fd2b-16cc-8b96-efdec5f783c9@seco.com>
 <20221118164914.6k3gofemf5tu2gfn@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221118164914.6k3gofemf5tu2gfn@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|AS8PR03MB9864:EE_
X-MS-Office365-Filtering-Correlation-Id: 2889d349-8ac3-48af-ca29-08dac987f4f0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 71zHennRJu80lCoDZjk5sixj4XAoqsHrrKqcOWSCUqCiUTNTst5Bp5xESeJcKz5o/6oyW+06VSTTSQvp8cR2SQsyo4Ns2V8U/kCgFxlOEtGr/OO/JNYqcuhdz0U+oZm9NNzxRyw3pBFlkwWAqovXhN/tTt1r4Grbth34LfojdutUmhXhooszk/EXnwtEuQTVGyGlZHLwCEFWud5E56b1ZNBq+NAmJvuHbD2MW4eq7abtpNnVqb4QOYHY994Cpb848Jegwev3bwqkWj1Gf6b1tlrCKC4aAjUq3gf3l5vsMwlSmfBrmcTV38lxN9QHBVpM2Ua7x0uJtUguXj01K0NYDq03CCKtEN+NVgEJYiwfLz0TsrushWJTeFoKaAyRx/xztgIwgB3WfpUS/rWr6Nv7O4N0KQ1Ndhn9BwfnwQirnzfi1dW6Gg+zhKQ+ItGGQ/b8s8bKdjFt0DRlKdITHEyy/4y7s+mv9YyzC0v6jCT5FHVJNQEzZbAhUyuDPvoFQBg0vUYfOsWfxo3KfSwKdiMqUmIpwFdqPuHZol+lV1c6DzvI9jEjHe6ViIlUR3neEfdVt+133mrePUIdZSdF9syQOuGg2CZkr8DYt9hxboMHrbr74mMUHvQYeLQ1v+VpSs+mZ605fWidL1piRmD2qlhtCDGRafp5eIurI6pjISCh0ted8tU2amIucbbMswFW3L2ibNThB6UV8Y3KkSVrahMmXeeMmP1/zEdEd839cxPoQGPJBUEM1OwYPnGzVe4AC1da9yh1VlStd+bB4AMyFEJePIonYM47jH4d4x+LiGW7JkQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(136003)(366004)(346002)(39850400004)(451199015)(2906002)(26005)(52116002)(53546011)(54906003)(6916009)(316002)(8936002)(186003)(2616005)(36756003)(7416002)(66556008)(8676002)(66946007)(4326008)(66476007)(6512007)(5660300002)(41300700001)(31696002)(38100700002)(31686004)(86362001)(6486002)(966005)(478600001)(38350700002)(6666004)(83380400001)(6506007)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y0FrN08vZHhtVGVjVUZWUUpNVkZ4ZzlhRTFpU3VDZFFhQk9kOStBeEtJU2VN?=
 =?utf-8?B?NU1pUEcvZ3hSVXJiUHNrNzlIWEkwWWdoc2U0Sm1rY2JpNWc4Y1l0RTI4K1Fu?=
 =?utf-8?B?a2t0K0tGaFZkelVlaDMvMVg2cUtvbm01K2JoODBkakhTM3JBT2VobWFQeTEr?=
 =?utf-8?B?cDBuNGdCdTNhbzVSL1pZUTNGb05qbFp6SkdGVWFrNm1nNUNsSTNhck8xT1Ns?=
 =?utf-8?B?ejBPYWMrZ1RnVjFCQUhDanQ5YjU3S05nT29kTjZtU0ZVWmhOSStSTTh0NHBh?=
 =?utf-8?B?elZNM05NVHQ1cVh3QUlwQ0cvMm94ZjJKN29aVjFTQXhId1BacW4vcExBWVJo?=
 =?utf-8?B?SU9KTlFyb3Zoek0ySDNkdGVQSlNzdFNiUHhEVHR1WldoQXNXRDkyd2kyS2lu?=
 =?utf-8?B?cG4ranNJRXRkTDN3L2hyYWdydXQ2bkQzK09mRHZFM0VnaWVWMXpDd3NYcGVW?=
 =?utf-8?B?UkRFMW1XU1F6WElKWTN6amFuc0NUU0Q2T3ZNSlp3OW5wbVNDOEdSZGR0bFl5?=
 =?utf-8?B?Rmx1dG5KTlhRWm52TE5jTSsxMzZRNUo1clR1ZWV2MWpNMmErRXhsMDNkelp2?=
 =?utf-8?B?a1ptRTBmN00yaFFQVUd5aDBpNytaNXlYUDVGUS8yV1B0SVUyS3dHNE4yMHAv?=
 =?utf-8?B?WVJWVkVmSHlrYmcvMEcvaC9FM01TdUVuLy9BRmkrUERkbXR1aXZrbGtlenJJ?=
 =?utf-8?B?LytWbzZ2YmplWFI5bjBaMXdZcUdYQUU1T05aWVEwM0N5K05BRnNwNmxpWjNR?=
 =?utf-8?B?Z0lGZXV0ejlWbHNzeEx3d0xUQVZ6eTB6RzVWNDVCMGJNNmRHSWhKQlZFdlRj?=
 =?utf-8?B?VkNwSHkwYlFFL21XRVdCQ09DMzl3eU4zK09PMzRUejJLeGo3L0FWNlR6Wk5w?=
 =?utf-8?B?OUVmWXJabW5hN0FKVXAzcUFOOEY5M1VPUE9jRUJOTHV4U25FVTZGV2NoOW9Q?=
 =?utf-8?B?bUZ1QzNQRUhTRkU3N2JqTE1KaFJ0VXp4TVd6Wk9zWUhIdU5IUHUraFUxWHBn?=
 =?utf-8?B?OEFUV1YwVkFvSXZTcXY2M3llTWFTd2pKbEpNOFRRek1yOXMvd1FiOWpJTk9v?=
 =?utf-8?B?N3NaakIzYlBLZTQyeGo4SUhLT1ZMQ0M0aUdTYlprV2s2b21PSW9ycWEveVIy?=
 =?utf-8?B?TGhtQWVuWk5sY3NwRmlmQ0ZtZ1ZsenRDc0FjRmdnenlPK1Zycld6MTFsamlx?=
 =?utf-8?B?dkN5ZTFnUUhDMkR3ZDQzd0hTdW9VOFRqYVpENEI4L3lPYUdlS0NzR0QvUUdU?=
 =?utf-8?B?KytxY2g2UlpUdUNsUWE0MGtiUUtaSmJmMk5WUFdMeDIwYURzTUErdmJ5ak5y?=
 =?utf-8?B?TXZSL2xza1BvTlVrL25XdEwwMzc2RlZDMjc5cWUxOHdvN1pLOWRxY0NsdFQv?=
 =?utf-8?B?dXhOdFQ5TFlsWTZTdGhHVGhZbWx2SU9lOFVvNEZjTVczTnByMGdoU1ZzRUZ0?=
 =?utf-8?B?dEZXbTJmZEQ2c0EyUWZ2OXVvUXdGUzVzOHRaVHZ1Zi9ZeXBydXBHZ2I1OXpn?=
 =?utf-8?B?NzZkK0FzcGZqRjV4b1o4dDRTOTlOL2pmM293NHBnOXVqbGhVRVZobnFReWlT?=
 =?utf-8?B?WWlnOVFob2c2bExlTWZ4TWMwTUtYQmQ4OHZYY25BU2pKSEF3NXdlcUpMdldu?=
 =?utf-8?B?d0o3NGQzb2x2MHJVcEgvK1lBUWQ2NUJrOEx0ZXJTMEY3QmgrWUVrWWpPWW5P?=
 =?utf-8?B?ZTFpUjdac01QUS9EU0s4VVBZRVlOMzQ4eDNmQmQwUmJLOHNJcU1RRWFEbUpp?=
 =?utf-8?B?U1UyNHNFNUZXZUp4NUxwZ2ZaOU5GVWRVODA0T1pCYWNWUU15NUlqZ2lkUmha?=
 =?utf-8?B?a3hOVDhjdjEvWHU3V0p1WnNBNm9WM3k2dFNKYWpDMmZXOHlLc1d1V25FZlNO?=
 =?utf-8?B?ajI3djlsZkNCQ28rNUV5MlNLbHJsVldjMk1wdGU3aUtLNTNlRkZieG44a3NO?=
 =?utf-8?B?bS9DeTNBNHFKS3l4anNhVDFjN1BQaDY1TE5ZQnVxRno4UjR2WXRlSU1aT1gz?=
 =?utf-8?B?Nk5JYmEvMFk1WXkwaUNXaGhPVmo0MFVYVk1QcEIrSWZNa3gxak91WWlIbXJv?=
 =?utf-8?B?c0xaa0I4MkFwNEJrSjZSVndwcVJ2VmxaaGR6OTVkdTFBSEp5RDlVaGhERGty?=
 =?utf-8?B?QlVpWnVFNkZmMUNkRUhIMXBGM2RUZTE0WnlicDY4aGg3dkNkTjE4a285TEts?=
 =?utf-8?B?bnc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2889d349-8ac3-48af-ca29-08dac987f4f0
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 17:11:39.5253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R4zS4g0MKZ3HH/cFgDZuZxOIJ/V5XOEH22qNf/qp2jc5saPWD34gVwvGJYXdb1iLWEVBllyAOkxudvLMuk8pOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB9864
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/22 11:49, Vladimir Oltean wrote:
> On Thu, Nov 17, 2022 at 06:40:02PM -0500, Sean Anderson wrote:
>> > Even if the change works, why would it be a good idea to overwrite some
>> > random registers which are supposed to be configured correctly by the
>> > firmware provided for the board?
>> 
>> They're not random registers. They happen to be exactly the same registers
>> we use to determine if rate adaptation is enabled.
> 
> As far as I'm concerned, this is just poking in places where there is no
> guarantee that the end result will be a known state.
> 
> FWIW, for internal testing of multiple SERDES modes all with the same
> Aquantia firmware, the NXP SDK also has a quick-and-dirty patch to
> change the SERDES protocol on the Aquantia PHY based on device tree:
> https://source.codeaurora.org/external/qoriq/qoriq-components/linux/tree/drivers/net/phy/aquantia_main.c?h=lf-5.15.y#n288
> 
> but we decided to not upstream such a thing, specifically because
> it might react in exotic ways with firmware images shipped by Aquantia
> to some of their other customers. I don't work for Aquantia, I am not a
> fan of their model of customizing firmware for everyone, and I don't
> want to have to support the ensuing breakage, I wouldn't have time for
> basically anything else. If you do, I'm not going to stop you. Just be
> prepared to help me too ;)
> 
>> > If the Linux fixup works for one board
>> > with one firmware, how do we know it also works for another board with
>> > the same PHY, but different firmware?
>> 
>> How do we know if a fix on one board for any hardware works on another board?
> 
> If both boards start from the same state X and make the same transition
> T, they end in the same state Y, no? Aquantia PHYs don't all start from
> the same state. Not sure what you'd like me to say.
> 
>> Well, part of my goal in sending out this patch is to get some feedback
>> on the right thing to do here. As I see it, there are three ways of
>> configuring this phy:
>> 
>> - Always rate adapt to whatever the initial phy interface mode is
>> - Switch phy interfaces depending on the link speed
>> - Do whatever the firmware sets up
> 
> "Do whatever the firmware sets up", which means either bullet 1, or
> bullet 2, or a combination of both (unlikely but AFAIU possible).

Happened to Tim.

>> 
>> On my system, the last option happens to be the same as the first.
>> However, on Tim's system it's not. I had originally considered doing
>> this kind of configuration in my initial rate adaptation patch. However,
>> I deferred it since nothing needed to be configured for me.
>> 
>> The problem here is that if we advertise like we are in the first mode,
>> but we are not actually, then we can end up negotiating a link mode
>> which we don't support.
> 
> I didn't quite understand in your patch set why there exists a
> phydev->rate_matching as well as a phy_get_rate_matching() procedure.
> It seems like that's at the root of all issues here? Couldn't
> phy_get_rate_matching() be made to look at the hardware registers for
> the given interface?

This is what I propose below as strategy 2. I didn't do this originally,
because it was more complex and I didn't have evidence that we would need it.

>> I think there are a few ways to address this:
>> 
>> - Always enable rate adaptation, since that's what we tell phylink we
>>   do. This is what this patch does. It's a bit risky (since it departs
>>   from "do whatever the firmware does"). It's also a bit rigid (what if 
> 
> I think the mistake is that we tell phylink we support rate matching
> when the firmware provisioning doesn't agree.
> 
>> - We can check all the registers to ensure we are actually going to rate
>>   adapt. If we aren't, we tell phylink we don't support it. This is the
>>   least risky, but we can end up not bringing up the link even in
>>   circumstances where we could if we configured things properly. And we
>>   generally know the right way to configure things.
> 
> Like when?

Well, like whenever the phy says "Please do XFI/2" or some other mode we
don't have a phy interface mode for. We will never be able to tell the MAC
"Please do XFI/2" (until we add an interface mode for it), so that's
obviously wrong.

>> - Add a configuration option (devicetree? ethtool?) on which option
>>   above to pick. This is probably what we will want to do in the long
>>   term, but I feel like we have enough information to determine the
>>   right thing to do most of the time (without needing manual
>>   intervention).
> 
> Not sure I see the need, when long-term there is no volunteer to make
> the Linux driver bring Aquantia PHYs to a known state regardless of
> vendor provisioning. Until then, there is just no reason to even attempt
> this.

I mean a config for option 1 vs 2 above.

>> > As long as the Aquantia PHY driver doesn't contain all the necessary
>> > steps for bringing the PHY up from a clean slate, but works on top of
>> > what the firmware has done, changes like this make me very uncomfortable
>> > to add any PHY ID to the Aquantia driver. I'd rather leave them with the
>> > Generic C45 driver, even if that means I'll lose interrupt support, rate
>> > matching and things like that.
>> 
>> I think these registers should be viewed as configuration for the phy as
>> a whole, rather than as guts which should be configure by firmware. At
>> least for the fields we're working with, it seems clear to me what's
>> going on.
> 
> Until you look at the procedure in the NXP SDK and see that things are a
> bit more complicated to get right, like put the PHY in low power mode,
> sleep for a while. I think a large part of that was determined experimentally,
> out of laziness to change PHY firmware on some riser cards more than anything.
> We still expect the production boards to have a good firmware, and Linux
> to read what that does and adapt accordingly.

Alas, if only Marvell put stuff like this in a manual... All I have is a spec
sheet and the register reference, and my company has an NDA...

We aren't even using this phy on our board, so I am fine disabling rate adaptation
for funky firmwares.

--Sean
