Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5290E6283FF
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:34:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbiKNPeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:34:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235709AbiKNPeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:34:06 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2082.outbound.protection.outlook.com [40.107.22.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFD5962CD
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:34:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXLHYDHsyIFIbel7X+g3xUZ4xbhzfJzHZ9YufTbSQfQtTrJtYVmjsH9kUb4w+qmmEIxA81AYzZ/LkcBBJxjmcEzjc6XA/sA/RKSPFOfr6+wAIXsXIIWQfSAhoSyjmW8peoDSm/UGaVwHpMVz6ReLnP5b2wgALZLdfmOReKoLAMFXI4RtVqVzHc75msEQe8bSj0RpZv+NnTlTF6A8O2ETzZPYzf/EWwmwOP0v9QpHASEltaLK2EyV0WfY3dmO1qcB/epXO6SAAJG2HbZ87eAdKBtk6xd7A09m/r0C9l/xEBKZPk/v5cwiEEN2YkIPEOHX8ElK+r5RhGyNJz6zQFFCIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WF34V9bEL0064sjmUOR4hWsS5iDiusx2Yi68yt6IKpw=;
 b=n7H5HIMgO3U2TyWme0AoKSj5lCCcZd1B7sc+KpWuT67MEh4HXDevXYmEv30HQ/QfNK22igSKJE1iV0nRXdz/TBogUJbzlCssLi4/ThYpePuJ+dp4u8dp5DsTSoxkhbLcZYtD+9L4Y+j24RwAeNjl24F4bgub1Tt+4KO5bsDJNHOvQjFgaHTWSzbxHF2+DRYM1QG0hSXozodPSEZ5SdHecQP312sq5mITjSzq/VaBWHyIapntsRFxUmj+G+yEWyfPkgeiQrGBVRmYsgy1KwENfDZC65n5IgEGIIYNHbLAIYPNLq1EbQgZEmbOFKJWMsd9gRLfn2j+lytIuVFl7aHdxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WF34V9bEL0064sjmUOR4hWsS5iDiusx2Yi68yt6IKpw=;
 b=JdBCdzhJhpJxsx+VXxqOtgpBBDgdHeIJA17c1Pn1PXFRs2+qo6VOkFxIp2eEtp9f0XnA2qn5pAldVC2AYLaF2Ek4K563sF3naNnZvzikfXIQ9JqdE9ggWr18jGwAEEqxv5QdNbcuskT4e3YyRolX34ukCTqgE1pB8icOay3EkSXKErTUC4MJh8x7ez5qRg0XAQk/jNlp0/bPPha+ZBaNr4CbiacPYdWAEBHTDmTxf8A4ruOfLTXH8qpSruBaUa6sRLX/cH+7db2cjG+0tb3f0FDFZCKkV4zYql2kqzzNuZGZP/6S2q5GRALShtLWGCjKCg2TZG7SWdVATIrI3EAt8w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS2PR03MB9562.eurprd03.prod.outlook.com (2603:10a6:20b:599::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.16; Mon, 14 Nov
 2022 15:33:57 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::e9d6:22e1:489a:c23d%4]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 15:33:57 +0000
Message-ID: <ea320070-a949-c737-22c4-14fd199fdc23@seco.com>
Date:   Mon, 14 Nov 2022 10:33:52 -0500
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
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <Y2+cgh4NBQq8EHoX@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR11CA0011.namprd11.prod.outlook.com
 (2603:10b6:208:23b::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS2PR03MB9562:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d3d6c3c-e73b-4f8a-8551-08dac655a459
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gqw4CRdDsC48r7GBsOjoPHbzGjWdGHlqrjl//nwW5G5rW62r2dsOq5M5Qow+9/O2pj+AlNvEmGIgiTmad1wx7kir37xs2YTszxNVObWvUzoS3OzBbhYgAnOC/SsNoVUuiHrjXaU07hbb2xVKCMYd0P9qc5stPR3+6CujjHhGZfRpDgi7F6Kyv70qMBzcLJ6+ubguWFXr1ON4lwvMMm6D9QDFnrjADPm+bC1M0eBfS0ThRD4L/4mRi2N4xdMg3ZnO9yrt5zVlpiMUHHWGU1OD/urZmCZAO+jnbL9dWdkpqfuLC/0XkRkClmWbJUs7ZzuGsl7VS+H7pCVKP6QIOgWxY37j+RfnKoxk/Aducog7YiRNtoPuaC/7Z+DxzBMB3ff2l+W+qPphHC5p3m+F3VaxZmOECR/q8KGRW2JUhJMh6EvTWZJh0a37muFmUiLJ1G2D+ShLhBvFZ1le1cPQgxCoeHV6gfKST3h7DmmFAPTMGV2fW4Q2lO5dnhVZVOE3zoXhhwEeARzCk0fljCOICX6vqLvAk5D68axz0YDZGVvBV63SglvcKhqbKBIjY3o1RigDZ8bW6tiX+S76gd2mwY70F28gOQQVap3vJSjgOni1SAFNXJv6Px8k96YTB7U52ARAjug5b3a+G3QxnQIxNc1/ia6nvJd9IFnxbk3jyJev4THmeI+R5tg7Me7icZFh2TrERZo8bOc39RhjOY0000veNXx82caIaTtosKKY2Hux2Hh8AIgUAvtj/ush3NzV83Qy5xwvMnghgDtfyW6fCwX43Q0CUW0NMicPUmvIMaXWZna0840p1BosYdAfwaCuBz1xhjxervsV8S8SoApOBSBGdod09xUPz5SRKNcgzOOY5dg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(366004)(136003)(376002)(39850400004)(451199015)(31686004)(5660300002)(44832011)(36756003)(2906002)(8936002)(54906003)(41300700001)(966005)(31696002)(316002)(6916009)(53546011)(6486002)(52116002)(478600001)(8676002)(6666004)(26005)(6506007)(66946007)(6512007)(4326008)(66476007)(66556008)(3480700007)(83380400001)(186003)(86362001)(2616005)(38350700002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDVYTkpETE5RZ3d3NFdNWlRYVkdwZElXdDdQeTdrcmVWZFZodUNUaTBmWXNF?=
 =?utf-8?B?TkZmTWhXSDB3VE5hRU8zSVcrMDNYdkpJNXZyUnlTZjZiblVaeXJndVdvV1Ew?=
 =?utf-8?B?TTg5WjhjdWhpeVpmaGhKMzJ3NkgxZTlvamlGT1BhR0EvUitPRWVnR1pTSE5C?=
 =?utf-8?B?REQ1ejczem9qdkFITHg2ajNWdTh4TVlLNGtTV2QvN1RNYlRpMkRNb2NRdmtK?=
 =?utf-8?B?ckR2emZOYitRR2Vzbm5xdTZGR04wQXBzZG9tSUlnaE81Vnl6ZzNUNlNYcE1w?=
 =?utf-8?B?Y1F2d2d2NlJYNFFmWkd4c0ovTmFGczJ6dEhCYVR4Y1ZkbHBTWHJtRmNTV2FD?=
 =?utf-8?B?Yyt5Si9nbndiZWxIU28xS1UvbVVzUDVoYXVDQzUrMlNXUXBzSE5MYUV2aWVS?=
 =?utf-8?B?UHFoT1oxNVBkZVN4c3dnWUN2cUVmWGtmU0xWRFhXZzlrU3JiTWxBWDNnMHBl?=
 =?utf-8?B?VTVlMkhWQzlpbGp0eFBzQ3g1SWpPcURQYW5GSGtDRnM2ZExZcVVWU0VXTWFU?=
 =?utf-8?B?YUVRTWo5bFRJRE80a0VsU21lYzAycXBka0JWREZ2M2s4d3d4QlF1TlQxc04y?=
 =?utf-8?B?ZnhMQnNPNGIvdnp0VWdMUnRvbTVTVktRYkZjbHd6NCtGM1FLblJCTXFrc0xY?=
 =?utf-8?B?T1ZMZThJUTRTRVlYOTJuR3NZTWVEOGkwVUFiQTU2cThpN1o3cEp6aTA5ck82?=
 =?utf-8?B?ZEJKekxCaXdIdlBLZHNjMUlldndPOHBhN1ZuS3E3c2JpL0FBL3ExdjJETkl2?=
 =?utf-8?B?b2JkNWRzUmc5ZWRYUVpBRkIyT0ZBc3ZYZ2t6UWROTkxoZUpHS0hFTTFIcjRT?=
 =?utf-8?B?UFYyVXdGUU4zRlBORk5JZGxBbXZEUzVZbXZlNmRPZWFtTW10ektYNnZmUDNz?=
 =?utf-8?B?L2dRcTZYY0Qya2lUZkdaUEh4QWx4bGV0VGdnSnRRaGlBR2kvbUZzWlc2RWd5?=
 =?utf-8?B?RWU4TzJ5WXRGUEY2OGdqbjE0ZVBDcWxsbW14d1R1aHpURzFmQ3ZhSUs1MUYr?=
 =?utf-8?B?MnMzS21JV1VhYzVhRENtSGw2NkdwVnYxSkI0bDVqcmdjVDhJVkM3bUlwUDBw?=
 =?utf-8?B?NHkvRy80TG80NENQcmE0a1JhSzdrWGRXZzBibElhdTJQSVpwazJXMnpXM2lx?=
 =?utf-8?B?V1NqWDJTTGJNUFpzMmdONmY1MlI0QUtjQnpOcHlnWWt2UEhTYWtPemlISFJV?=
 =?utf-8?B?K3Zvd0U2OFp1TWc0MDB6UHdnNlc0aEw4VFlSSlRhY01QaUhGbmlaUmxNT21P?=
 =?utf-8?B?Y01QRlFrbUVZODdobCtvUis3amZHTzZzZDd0Z1BvckMvb2dYcmxia1NNSlRo?=
 =?utf-8?B?NktmbGdoUEdUM0NQMWs4REZBMG1Gc3BNdVN3bDZiOE5pcUJjM0cwcUhzQW80?=
 =?utf-8?B?U2dZZGhYRHNody9sNG1Jdnd6WFRqSXNCMzhQejA0UDF5clJZemNRMXJJOWcv?=
 =?utf-8?B?NTF4WFp2bkdmWDhOSGFKK0k5RThjSTBvem1CNWh3QnhPWmhBcGJXenFhRHRP?=
 =?utf-8?B?clJ1ZEI1WVJ6bVJqKzFwRkg3TzJhQ1RXcjZHOVMxcmx1YldvaDhneHd5ZkFs?=
 =?utf-8?B?SmtkNVBWdzhHSTE3bWNRNWFuK0FkOWczK2dpTWRJeDhDR25mbS9iQ0NEdms0?=
 =?utf-8?B?K0FTUDBtZkxzcG1YallBaTRRL1FlNjJKRDVhUGx4TW5tOFZFSndQQS9TMWxD?=
 =?utf-8?B?R0dDL3dibVZSejJ5aUtJaTlCMUZSMTg1aWorLzVyaWJNckNmS2N6VDFETTJD?=
 =?utf-8?B?d2NWZnJDQ3IxeG1laXVOZ1JqR1laWEF0dk9OYmw3Z3VHVmJQMXVJRFRvTC8x?=
 =?utf-8?B?eCtsV2Q0SkRWVEd1OTdLZzlPRElUaU02R0FWdmNpVHpsVElOTlNkb3hxS0JT?=
 =?utf-8?B?c3pHRVk0cTMrUzhCSkt4ZVRjby9UQW5sNWxlcTdybHNtcWhoN2RSdjZLeXNL?=
 =?utf-8?B?V1F1bmJUZjFja2h2ZExIYUFpYlgvWWVVMXQzaTV5SjhCVUtZRG1nL1o4SGxk?=
 =?utf-8?B?ZytYYWJDWGJkV1hhOVB1SnJCbkRWS2xFeE1QQml6YUVVRzdibUJiOTBidTVn?=
 =?utf-8?B?MXNPUUEvcVk0dVdGVHVLaGZHMUdNU0p6WVV2WWNZRktxelBBSHNaOVBZcjc3?=
 =?utf-8?B?djNyRUVHZndsWHIxa0RFS1NUMXlaVDRnRkRTN0wwd0c0ekhXbThyVkxRcTJm?=
 =?utf-8?B?eGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d3d6c3c-e73b-4f8a-8551-08dac655a459
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 15:33:57.6164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VAGFOGK9pRKCS+Mxwf7xOVDzcfrTZylWJNXUh29n/hH8DRNAwHJuUdvhDzkbXpEZbD+RPrblPKGPqLY1YN9uSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS2PR03MB9562
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/12/22 08:15, Russell King (Oracle) wrote:
> On Fri, Nov 11, 2022 at 04:54:40PM -0500, Sean Anderson wrote:
>> > [    8.911932] mvpp2 f2000000.ethernet eth0: PHY
>> > [f212a600.mdio-mii:08] driver [Aquantia AQR113C] (irq=POLL)
>> > [    8.921577] mvpp2 f2000000.ethernet eth0: phy: 10gbase-r setting
>> > supported 00000000,00018000,000e706f advertising
>> > 00000000,00018000,000e706f
> 
>> > # ethtool eth0
>> > Settings for eth0:
>> >         Supported ports: [ ]
>> >         Supported link modes:   10baseT/Half 10baseT/Full
>> >                                 100baseT/Half 100baseT/Full
>> 
>> 10/100 half duplex aren't achievable with rate matching (and we avoid
>> turning them on), so they must be coming from somewhere else. I wonder
>> if this is because PHY_INTERFACE_MODE_SGMII is set in
>> supported_interfaces.
> 
> The reason is due to the way phylink_bringup_phy() works. This is
> being called with interface = 10GBASE-R, and the PHY is a C45 PHY,
> which means we call phy_get_rate_matching() with 
> PHY_INTERFACE_MODE_NA as we don't know whether the PHY will be
> switching its interface or not.
> 
> Looking at the Aquanta PHY driver, this will return that pause mode
> rate matching will be used, so config.rate_matching will be
> RATE_MATCH_PAUSE.
> 
> phylink_validate() will be called for PHY_INTERFACE_MODE_NA, which
> causes it to scan all supported interface modes (as again, we don't
> know which will be used by the PHY [*]) and the union of those
> results will be used.
> 
> So when we e.g. try SGMII mode, caps & mac_capabilities will allow
> the half duplex modes through.
> 
> Now for the bit marked with [*] - at this point, if rate matching is
> will be used, we in fact know which interface mode is going to be in
> operation, and it isn't going to change. So maybe we need this instead
> in phylink_bringup_phy():
> 
> -	if (phy->is_c45 &&
> +	config.rate_matching = phy_get_rate_matching(phy, interface);
> +	if (phy->is_c45 && config.rate_matching == RATE_MATCH_NONE &&
>             interface != PHY_INTERFACE_MODE_RXAUI &&
>             interface != PHY_INTERFACE_MODE_XAUI &&
>             interface != PHY_INTERFACE_MODE_USXGMII)
>                 config.interface = PHY_INTERFACE_MODE_NA;
>         else
>                 config.interface = interface;
> -	config.rate_matching = phy_get_rate_matching(phy, config.interface);
> 
>         ret = phylink_validate(pl, supported, &config);
> 
> ?

Yeah, that sounds reasonable. Actually, this was the logic I was
thinking of when I asked Tim to try USXGMII earlier. The funny thing is
that the comment above this implies that the link mode is never actually
(R)XAUI or USXGMII.

On another subject, if setting the SERDES mode field above fixes the
issue, then the Aquantia driver should be modified to set that field to
use a supported interface. Will host_interfaces work for this? It seems
to be set only when there's an SFP module.

That said, imagine if Tim was using a MAC without pause support, but
which supported SGMII and 10GBASE-R. Currently, we would just advertise
10G modes. But 1G could be supported by switching the phy interface. I
don't think this is supported right now. But if it were, we would need a
way to tell the phy to use a lower phy interface mode, instead of rate
adapting. We might also need a way to let the board tell us what
interfaces are supported (like [1]).

--Sean

[1] https://lore.kernel.org/netdev/20211117225050.18395-1-kabel@kernel.org/
