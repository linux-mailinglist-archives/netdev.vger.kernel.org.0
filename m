Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B705A62FC46
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 19:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242559AbiKRSQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 13:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242565AbiKRSQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 13:16:09 -0500
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2076.outbound.protection.outlook.com [40.107.249.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DEA98CFDB
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:16:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HhcADIE0dX0YGU9YiV0aTIkg+e3NjX81SaiE8msvOkofOfgbJxEwh6kQ2gQAKTwDuLOL9RCcLzb6pzcqu2ZJxloIsnUT8sDSW7AL7MG3abhcFWKlyr4NMDj+l7pLY2KL+l61Mm9AHc6DK/qQiiXWs9eK6+Ze4inxl5ORX4O7b00klOAWIsk2kF9EfeZSWzTWWkArDK7OjjaJ7PNbdE7xgHfPXXGlsNxlpdlk9je5tnFdpt9ssIACPEkVMRY1r00BLS61D0aXLknXTV7nAgLWn0+CnLNoa1aEwlDzMpyPnY7mxYAfuGu/45SSUFU1cx7ieJC+VmlstDmJoNCXIopOeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0dAW+qJ0f1UHCcnUhPgp/csucIdfgjI7/SiExP91bHo=;
 b=gI8TyzSWSCZUzDtecEnJ/18ZDNSOCGdNr4vt6OqSgujJtlcDCMDthUyIUdrvY1OYVSLmHekDG838WfAwjN3bhVF5XnBTg4R5SwdhZn+K6rCJxbY1CFgEIUxuHvonCgKt7+ZsEdTftTy2xNmFq2u0HUieug+4XYczoiQJ5mLz0Vcr6w+MfgDrR+HrOo8VMrzbk5vrt9LwtplcCqo6u22vHFDT++p4W0jgIcb+tY7RGr0HB37qjjeIdy9U2j2HSuILI2CbZJdfTTwpalmWvBJlzY9ZbMzF4wNdcn9nx3KRNyno8Y45YybrxtYbmlPwwk/Fo+ZtgegiTc4YS4L3jM9Yow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0dAW+qJ0f1UHCcnUhPgp/csucIdfgjI7/SiExP91bHo=;
 b=IXrrVkcy9cWj2SUgJowM2F751bykNBBLVSXZLenLkd32Nz9qxPp6WchXokBoruYMcmNWwpnCmSrrzM3y+tllf8bj6zDyERQkQcESiFDZBQf9QGq6F2DoQ+8mYtfU8U9mUyOJxvqPElGb4v8ZxT9VmOnb9IM2XhmNG7zGNFR1AYbXOYSnRRRkZyWpJD7YBtosIkX/oo7x2eV2wK2yhMjQT0WNZXC8P6AcOz+mc+14Jg22JpIjHjGY7gO7AQYMFCjkgrZxRzk4kNVThlFzcuuPuJIafMP5nouIOd3epRoGV8qWATgNHwfmCM+s/rHioJDFzGc3bYJSUHE40iIOq/iMdA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by PA4PR03MB8247.eurprd03.prod.outlook.com (2603:10a6:102:270::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Fri, 18 Nov
 2022 18:16:04 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::2b95:1fe4:5d8f:22fb%6]) with mapi id 15.20.5813.019; Fri, 18 Nov 2022
 18:16:04 +0000
Message-ID: <78caaf5e-620b-6627-5333-6fcf80c72860@seco.com>
Date:   Fri, 18 Nov 2022 13:16:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: status of rate adaptation
Content-Language: en-US
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <CAJ+vNU3zeNqiGhjTKE8jRjDYR0D7f=iqPLB8phNyA2CWixy7JA@mail.gmail.com>
 <b37de72c-0b5d-7030-a411-6f150d86f2dd@seco.com>
 <2a1590b2-fa9a-f2bf-0ef7-97659244fa9b@seco.com>
 <CAJ+vNU2jc4NefB-kJ0LRtP=ppAXEgoqjofobjbazso7cT2w7PA@mail.gmail.com>
 <b7f31077-c72d-5cd4-30d7-e3e58bb63059@seco.com>
 <Y2+cgh4NBQq8EHoX@shell.armlinux.org.uk>
 <ea320070-a949-c737-22c4-14fd199fdc23@seco.com>
 <Y3JpJDvCdI21yb5v@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y3JpJDvCdI21yb5v@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0017.namprd10.prod.outlook.com
 (2603:10b6:208:120::30) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|PA4PR03MB8247:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae4f898-f036-44cc-903c-08dac990f470
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R3lxdfGguWcCJA7z41Xmyd55uuUZ1IHQsMjInyT+uFKcptIWoKbXUPojYD9Vl9lYfrfEAvFYg49GiEFklZkjhYHpv8iZxsArgnjGqIQtu8ubPqI0W7iG8vrdpGf+IdUMVZmu/DPNUW/MnyrxE4gBbeZJQB3zpt3EI7fyS4jRWcXxD9QdpfnZJKz/qeNi48ctZf4olKJ32xAnyW+q6KmtI0DK8GoK4QcjMkSwEe6LJyTFe6EXhR11LHfqxiwQxol/P+/XSIQfnTRgWGopC6BCKpwB53HW2hPLtL6UPccfaS8gxBufQZYfi01UoD9XPlGUklj6hcJ2A1nwF9SWqKTfyiJDoEwqc8c+WlYUko5+aliD2SoQiPJQ5PjeKfyT2XGMyIyU6MR7Zoqf3HRA1EUZCJhFUfXcnxKtiVEr54MP1kKgoMfP37c6XNYkqwk/lI2QEmG72rbdZolDtbo+3zsrqxnBa4CSzqBowulTH/4L8vv1toBUhadmikSxOpdURBgRvSDfaXS3S2aZ36//BIttI2ySnom+QLcIigtekpx1Rtrkob+kL67zvH1UdwvWqTzFf1JxTq/ATudaDh50Nen8EfQHFUgliO7SjLMx8Uwe6wQELHCs4WKduxUwy9CqNlYKMia/95s+rdRM/Y8bowLYdR2YddiKTU2gvYeRoJGOx5Q4WKx0eSsTJYZngMbKKTugO+cpwFlxKsct9SH6r61f2FL+0pLwD2Mv1XZ6gWgaaqgJZ5Y8/jrRwvvyvl3RLLjse0avFB1Tgf0gcUQKG3qH5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39850400004)(396003)(346002)(136003)(366004)(376002)(451199015)(66946007)(66899015)(83380400001)(6486002)(31686004)(5660300002)(478600001)(8936002)(66476007)(4326008)(8676002)(53546011)(66556008)(52116002)(44832011)(2906002)(6506007)(86362001)(31696002)(26005)(6512007)(54906003)(6666004)(3480700007)(38100700002)(41300700001)(2616005)(186003)(316002)(6916009)(38350700002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RUh6cFBWZXp5WGV2dVJsUEtjWktoWWNheGdmNWlnbk9GTnR6Z2graEJwZ2sz?=
 =?utf-8?B?YkxORTZGZFhiSXBvS3FDUlFTUkxNdzRHbzUxNlVNQ25Bb1RKeXpqK1FBSzdy?=
 =?utf-8?B?eFNYTzF0dC9lV0lyWGVVaU5CRDNUUGtmV2xPVTBDZEJpeTl1YzVKRUl6VXZz?=
 =?utf-8?B?NVNyUkdFdktkSDR6OHd4VEVUSEg4WVJJVmpuMjZaRmVVaU1pbFNYeURvbEVR?=
 =?utf-8?B?cmdPUi9sWUxrRUJ3d2RKZml1VDRlek5OaUlKQUpGTjR0Q2w0ZkdqbkNjOHBN?=
 =?utf-8?B?eDg1Z3g0M3lselRiOW40VkRBM09lVHZORWdZUkI5dFBRYkNldTdHUjdSQklE?=
 =?utf-8?B?RktIVHJVYytCa21iV0xITW9HTVhKYTlIM1g4ZG5oNk1TZGhscHZSbU1oQnZM?=
 =?utf-8?B?czBJblc2QUFEMXFOeVI2K3ZaVjBnVHV3Uy9lK1VxdEFoa2N4SngrKytRYzhX?=
 =?utf-8?B?NzdiZWVxZGpEZWgwK0RLb0IvczRzcGc4SlQwS21Ob25qbURlZ3RhWFBxTVJr?=
 =?utf-8?B?emVESVZGOGVZbEZFaHVZMFVzOGQ5SVE2YlBmNEVyMThScEdlZC9YaEZtc1di?=
 =?utf-8?B?aVBnS1R0WWd1bnFLaEIzYnVOc3Nmd204T2JnbDRrT2pxeFRVRXBJNlRQV0M3?=
 =?utf-8?B?MmdiOFpjTEhKYjA4aGk3UkxuV25GNll5ZjVqWFhUMU4xZ2RaMXhuU01MaFgr?=
 =?utf-8?B?aEpmc3BnaVRLam83cit3Y2VncUpVRG1KbEtPblFjUmg4T3JoTk5zRDArdGlj?=
 =?utf-8?B?eE16L2tEK3VwVm5mNE9IMEdHcjBGUDUyQW5CRU1Wc3RWbHJLMWltRnhDbzky?=
 =?utf-8?B?MHhNUWNTSzVNb3I5b254VHViSitkeVpwQStCZjZxeHdkUitVMzB6ZEpsTzFa?=
 =?utf-8?B?OTViWUg0NEptY3ZrZ1lDTGlRVU1wSzlhM2U1UGhEU2dIVU56MWVucXBXMmpa?=
 =?utf-8?B?NDE3SlZ5U3luVnJHYVdLekJoOER2YlJJK0FnYjlTWFhOcTNSalFTcG5WeSth?=
 =?utf-8?B?UXRZYktNUkpPZ1ZKSkFsN0hmajE1REtJSi9wUURTVlA1YjZhRlVmUXc4eXJW?=
 =?utf-8?B?TlgrRFR3WkFwQU5COTFRUjR3UDkyTG5TMlg3a1B0MW55dm84NXhNV3VYNE5R?=
 =?utf-8?B?T0pVcmhPS3ZxWkJrdWdHRnhlVldFaHo3bWlVd3JwOVVjQlg3SmZ3VUZ0K2Yw?=
 =?utf-8?B?UUxQTEMwdDlPQnpSa05YT2JiUFNMakQ4Sy9vYmpEaTB2a0lBMWl0T1hiTUZp?=
 =?utf-8?B?NHBaanA0T3BTWVprMmVKSjVBQVhxdzRCbHFsc1JsUFc5SnBnVktxSlE2bFdQ?=
 =?utf-8?B?cmxlTHdFcGpLdlQ1L0lCeXFqMndNOTNlOGFhRnlMdmdLK1ozQmt6ZlNHbDRL?=
 =?utf-8?B?T1NhS3NCdmk0VlVWTlFueWlRSVlNYWlHTTNQNkxwOFoyR0Nsckd0aTI2M09i?=
 =?utf-8?B?aGVmUHZoN29Rdmw2TTNJSDhGMnlOSnR0OEF5N2tGT2xJMG81N0N5a0lLQm5q?=
 =?utf-8?B?UGUrV0xxdktSc2JreVQ5SmVqZjc4MzlLdHd0VDN2SzNuQXZubEJuZlQ1K1Bj?=
 =?utf-8?B?K0tOYmQ3SWZWL2dMVmQxZjhyay9kOEVGN0ZYaW9SQXJjQ05jc2VxNHZWVkxp?=
 =?utf-8?B?Y2NXdmdwbjVQRnFNUDVHbUFxNU1zTmFuUXJLR252L2VyS0RMeGlkcFZHS2dq?=
 =?utf-8?B?bSt0aXhCVXZLRnRBaGZleFN4TDFCalp2QjJ1S2tIRU1IU0FtUnl1b0tkY0Ji?=
 =?utf-8?B?OWkreDV1R3k2aEJXbW02djVXVUhHc3d5RmRHdGhpNUhrTnplaGdveGR4dmJ4?=
 =?utf-8?B?djMxbmxTR1RLV3Z5dnZzeXptTElFMWRtZlBaamZnWkNhS0U3aHA2c1h4QjRu?=
 =?utf-8?B?MzVsWTZKT0FKZEhYb3ZyQ1J2RThYcEVFekxuaGRFUnFXSEZsMElCSWdydWhB?=
 =?utf-8?B?T1hrTVBDczIrWnRwbTNhMnBydVdGVEQ5aUpRWHEvVGFwUWd4Vk1wWTY0QTBk?=
 =?utf-8?B?Zm95YzlTdUM3Qkw1Q0IrdlJsWnVEbUNlU3FUV3FzUThKRkZnYldSZnp6WXpC?=
 =?utf-8?B?L1NGM29rRzA5UEtlOGpCTTREK0hSTUhhbXhlS1NzNDhaWHJwUU5Rd085Uzh6?=
 =?utf-8?B?S0t4OTdnaTdzVDM5Tk13SStRSHFDOWpNN29ya2R0VnNxL1lIaE95VTYvNnNi?=
 =?utf-8?B?Ync9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae4f898-f036-44cc-903c-08dac990f470
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2022 18:16:04.1399
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F9WSJTVvET85HtoniLDyEBOBPQXVvIoX2A6GVxbfS65M+/jRYdeUrapikVHddiSEYFcHdEaOtc7nGJvbtTgiww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB8247
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/22 11:13, Russell King (Oracle) wrote:
> On Mon, Nov 14, 2022 at 10:33:52AM -0500, Sean Anderson wrote:
>> On 11/12/22 08:15, Russell King (Oracle) wrote:
>> > On Fri, Nov 11, 2022 at 04:54:40PM -0500, Sean Anderson wrote:
>> >> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
>> >> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
>> >> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
>> >> > supported 00000000,00018000,000e706f advertising
>> >> > 00000000,00018000,000e706f
>> > 
>> >> > # ethtool eth0
>> >> > Settings for eth0:
>> >> >         Supported ports: [ ]
>> >> >         Supported link modes:   10baseT/Half 10baseT/Full
>> >> >                                 100baseT/Half 100baseT/Full
>> >> 
>> >> 10/100 half duplex aren't achievable with rate matching (and we avoid
>> >> turning them on), so they must be coming from somewhere else. I wonder
>> >> if this is because PHY_INTERFACE_MODE_SGMII is set in
>> >> supported_interfaces.
>> > 
>> > The reason is due to the way phylink_bringup_phy() works. This is
>> > being called with interface = 10GBASE-R, and the PHY is a C45 PHY,
>> > which means we call phy_get_rate_matching() with 
>> > PHY_INTERFACE_MODE_NA as we don't know whether the PHY will be
>> > switching its interface or not.
>> > 
>> > Looking at the Aquanta PHY driver, this will return that pause mode
>> > rate matching will be used, so config.rate_matching will be
>> > RATE_MATCH_PAUSE.
>> > 
>> > phylink_validate() will be called for PHY_INTERFACE_MODE_NA, which
>> > causes it to scan all supported interface modes (as again, we don't
>> > know which will be used by the PHY [*]) and the union of those
>> > results will be used.
>> > 
>> > So when we e.g. try SGMII mode, caps & mac_capabilities will allow
>> > the half duplex modes through.
>> > 
>> > Now for the bit marked with [*] - at this point, if rate matching is
>> > will be used, we in fact know which interface mode is going to be in
>> > operation, and it isn't going to change. So maybe we need this instead
>> > in phylink_bringup_phy():
>> > 
>> > -	if (phy->is_c45 &&
>> > +	config.rate_matching = phy_get_rate_matching(phy, interface);
>> > +	if (phy->is_c45 && config.rate_matching == RATE_MATCH_NONE &&
>> >             interface != PHY_INTERFACE_MODE_RXAUI &&
>> >             interface != PHY_INTERFACE_MODE_XAUI &&
>> >             interface != PHY_INTERFACE_MODE_USXGMII)
>> >                 config.interface = PHY_INTERFACE_MODE_NA;
>> >         else
>> >                 config.interface = interface;
>> > -	config.rate_matching = phy_get_rate_matching(phy, config.interface);
>> > 
>> >         ret = phylink_validate(pl, supported, &config);
>> > 
>> > ?
>> 
>> Yeah, that sounds reasonable. Actually, this was the logic I was
>> thinking of when I asked Tim to try USXGMII earlier. The funny thing is
>> that the comment above this implies that the link mode is never actually
>> (R)XAUI or USXGMII.
> 
> I think you're misunderstanding the comment...
> 
> If a clause 45 PHY is using USXGMII, then it is highly likely that the
> PHY will not switch between different interface modes depending on the
> media side negotiation.
> 
> If a clause 45 PHY is using RXAUI or XAUI, then I believe according to
> the information available to me at the time, that there is no
> possibility of different interface modes being used.
> 
> If any other interface type is specified (e.g. 10GBASE-R etc) then there
> is the possibility that the PHY will be switching between different
> interface modes, and we have no idea what so ever at this point what
> modes the PHY will be making use of - so the best we can do is to
> validate _all_ possible modes. This is what is done by setting the
> interface mode to _NA.
> 
> Obviously, if we are using rate matching with a particular interface
> mode (e.g. 10GBASE-R) then we know that we are only going to be using
> 10GBASE-R, so we can validate just the single interface mode.

Ah, you're right, I was reading this backwards.

>> On another subject, if setting the SERDES mode field above fixes the
>> issue, then the Aquantia driver should be modified to set that field to
>> use a supported interface. Will host_interfaces work for this? It seems
>> to be set only when there's an SFP module.
> 
> The reason I didn't push host_interfaces upstream myself is that I was
> unconvinced that it was the proper approach - and I still have my
> reservations with it. This can only tell the PHY driver what the MAC
> driver supports, and it means the PHY driver is then free to do its
> own choosing of what group of interface modes it wants to use.

Well, this is what we have already. The Aquantia phys are initialized by
the firmware to use particular interface for a particular link speed.
Rate adaptation may or may not be involved. If it picks an interface the
MAC doesn't support, you're SOL (until you get a new firmware). Ideally,
we'd be able to configure the phy to always select an interface the MAC
supports.

> However, think about what I've said above about phylink not having any
> clue about what interface modes the PHY is going to be using - having
> the PHY driver decide on its own which group of interface modes should
> be used adds even more complexity in a completely different chunk of
> code, one where driver authors are free to make whatever decisions
> they deem (and we know that wildly different solutions will happen.)
> 
> I had been toying with the idea of doing this differently, and had
> dropped most of the host_interfaces approach from my git tree, instead
> having PHYs provide a bitmap of the interface modes they support and
> having them initialise in their config_init function which interface
> modes they're going to be making use of given their resulting
> configuration. I never properly finished this though.

That sounds like a good start.

>> That said, imagine if Tim was using a MAC without pause support, but
>> which supported SGMII and 10GBASE-R. Currently, we would just advertise
>> 10G modes. But 1G could be supported by switching the phy interface.
> 
> Note that we already have boards that make use of interface switching.
> Macchiatobin has switched between 10GBASE-R, 5GBASE-R, 2500BASE-X and
> SGMII depending on the negotiated media speed. In fact, that switching
> is rather enforced by the 3310 PHY firmware.
> 
> We could force 10GBASE-R and enable rate matching, but then we get
> into the problems that the 3310 on these boards does not have MACSEC
> therefore can't send pause frames to the host MAC (and the host MAC
> doesn't support pause frames - eek) and we have not come up with an
> implementation for extending the IPG, although I believe mvpp2
> hardware is capable of it.

The DPAA hardware is as well. As I understand it, the 10GBASE-W standard
specifies linear scaling of the IPG with the packet size, not A simple
implementation could be to have MACs expose something like

	mac_rate_match_ipg_numerator,
	mac_rate_match_ipg_denominator,

With the intention that they'd do something like

	numerator = SPEED_10000,
	denominator = 9500,

and then we could multiply the speed to adjust. We could also do
something like

	int mac_minimum_speed(int base_speed);

But AIUI we are trying to move away from these sorts of things.

FWIW I don't have any 10GBASE-W hardware.

--Sean

> However, there's also the BCM84881 PHY which does the same dynamic
> switching which we can't prevent (we don't know how to!)
