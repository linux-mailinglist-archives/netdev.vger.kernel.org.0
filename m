Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372C058021A
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbiGYPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiGYPmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:42:36 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2057.outbound.protection.outlook.com [40.107.22.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9D2BF4;
        Mon, 25 Jul 2022 08:42:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HSzeI0oIKhky2Pl3zeJeGmuJyNpPNIc8rZmX7INAWm79oQigVKcE61BWQcE+SmjTsQur19hCjiXsnoLYAFeYbxb12o27K99Qw71qgW8IjiYjNcepOIMtI1xPTEVUIE/TDvmmzgnH7mTUniLUiNFMa+Bq/MXaO8l3TDa/HuQ/cePRES+EwF5D3o736c97PyooOsVo81kd4GF12gJoUD9JJpPtRse9HYM+8eKVf2NJuzkrvanLGPEJstblvEY1LbtM1wcFCCoi8XQkaN1NzaETaGuFXaQtUTldqiuG1EhGrgALyi9DRtNEfEmMWv+OgwBvzStPzTGUGuXuQEvLAukn+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HPYrud96qcn7N0tWKtK0xij2qKOt6Yj4LWfOZmILMBs=;
 b=jxvBd94zChZ/Bz3DxMj+EM2NwF7jhG7cWCiIsoYDURlK10+tJ/c9v4zsexwDsVD8okJSYyAk4ThsoU5/ggCfYlv/LYDEU4prbutZRZ0U7nL199ld3rO13CQVGkNgbFPigMQYs+atLVOq0HDdDsSXDrcyfxZ1YyaIn2etpZyAZ9mBP5zU+S38zGzCxB+DwCv1ZK0J39HdRutuCeIXuHo6mPdxUXn/jWvf4XOJYZda1maork7DlEy21m/6BOIAm0TkmJMu/PwdrD4bZkUITUSAPPXFovAh+9OY8KRHQtcLSXdQK6IzvUL6b+XR+Z6LrKO9/pcZdfE6E9z4cUlZWJynPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HPYrud96qcn7N0tWKtK0xij2qKOt6Yj4LWfOZmILMBs=;
 b=0V1c14Z8a0Wxw8Er9S9VzTpDE9UMLrFmH6iuJRxT6FTtJVu+C+W0LPFyQcvu65h03YQknh5cVJE+57bu/ZiDqSS+jpTpnB64HFfJ2ng+qoAYKUcBR2zJ5D/qDwBXRBcQW8VNUAZyvcZhC/gXmOZ5PqGROKUAml+lk49TDEPgrlazfmUYV9EiavICfhieNP1jri5mntS9lUNhhvHh+Q0481CjME9ZaBkf6HcOIkqNsyxQ29G18NFPXRzuPGED92PAaZRrjHTtGtMFWkjclcA7sU1jV7tFHWtrbjIrGC6kBc0Z6/jYSyfOj78Nlj8jWZ+PGga/oJfBKejykVbBaykL8g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB4394.eurprd03.prod.outlook.com (2603:10a6:10:1b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Mon, 25 Jul
 2022 15:42:32 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:42:32 +0000
Subject: Re: [PATCH v3 06/11] net: phylink: Add some helpers for working with
 mac caps
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20220725153730.2604096-1-sean.anderson@seco.com>
 <20220725153730.2604096-7-sean.anderson@seco.com>
 <20220725154103.e3l4cde3bhgdl65y@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <2c7b01e3-0236-3fae-7680-05a47b9c266a@seco.com>
Date:   Mon, 25 Jul 2022 11:42:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220725154103.e3l4cde3bhgdl65y@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR18CA0012.namprd18.prod.outlook.com
 (2603:10b6:610:4f::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bc5f8dfc-545e-48eb-3dbf-08da6e5449a7
X-MS-TrafficTypeDiagnostic: DB7PR03MB4394:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZRMv00N31Lv/WGGOkei47jKGGlBaAOKlXdW8TFlpr2Zt6/uP6Wgfe9SWu3WZ59RfkcJLuyTHil4l2jslK93AgTeap43pfsz3+q4WeozD5ywVqR05K4lDwNO/o8epBY4IXt2SNwdf7OEUTcwXHLkvlwqrDUEA7oFmB+go13NSX1JHtz9gbNnLcrDKvQKGIwotR0Mj5L/tExjUQqcU5MxrznfoGM6UzDeuvzWgSQyRqdliPYOnq0fqUrEc+20m74CNXGmDBzESPUJFjWCZChCKjxsJl97o8erx4658g+2MVJPl4lg8oTee5v7BPfZFJDm410j0GJgw0XpWtHJYi25qvWiEzwXz6nz6SNlIelYN5kgywo16UqjF5vbiuCePH69TvgV56BtpxUYdlEorLUg3CFJr+4OiFEBlAaapDJ97m3ILtyFK0hT/RNKuGERb4JUzqdzqztEGccJkPkLQgeShSY1v2PavNxdyfYjUls2wdRpJ4nqSlVL3GUr2ecFg7FONvy/XCP6TALKk1Po8rjham5/6XQna6zGGIP4G2X8bI8QDNeHqrl0ifL1VUEnYwL7mPLGQUw2OcEz7NBTieGFcPBklFVWtdgXH1FhKJ0V5rVMLL/9mM9JvOhojUWC+jFit7SFi1aRCfkAHUAro+aGi3ZJ8NJ8ULzwWinkTFHId+teHh3c+Fq9nT6zpggkHkgiwyaqs2oAG5sR6JTtO7NyUNPQVjHXW0FPT6saAivEtBvO1LheHhtLur1KjfGPIqUpOr7ksqJOY2z1XAKXJgor+NSbimB/Q08LshHIjnqXyYVBV125tL1ZnVSOGL75gOLTg7fTkKiAUKJfF0ri0l4j8ny6eenLuMrflVHlgEQkE+sTjjzFC6D52wSZKCtCBJvjTvCkYl8+V0BEMrs0tVPWDfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(136003)(366004)(39850400004)(346002)(54906003)(6486002)(966005)(4326008)(6506007)(41300700001)(2906002)(86362001)(478600001)(7416002)(52116002)(36756003)(6666004)(53546011)(38350700002)(26005)(31696002)(31686004)(2616005)(38100700002)(6512007)(66946007)(6916009)(66476007)(8936002)(44832011)(5660300002)(66556008)(186003)(8676002)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NzVweUhSMGdleFR5WXZHZUI0QVNnMlN2amU0SXkxSlA4NDhTVTBVdlEwSk42?=
 =?utf-8?B?NVJaK0t0UmR4ZFlwVE54UFVYZU93WXowdzd1RGVUMGtUNCtpMzhQRkUrYkVj?=
 =?utf-8?B?cXRiWEExRHA4cGU2NmFZZm5JZmxGYWZqdlpXclpBeWRyOVFObVdISjB4L3Fl?=
 =?utf-8?B?dE56d2dtS2krQmFyZHA1dFBWL3U3U2hxQncvSWtxc2RpTDhndDR1TWxzZ3ZY?=
 =?utf-8?B?V2JVNlNkekoxRW5FRnQ3V0xiOUNCdDVmbjFJVFhDc0cycmU4NXpXQU83aGQw?=
 =?utf-8?B?ZkxETC9pNHAvazIwQkt0RFkwbjQ3OEExNC8ydHBnRC9qNHMwTG0rKzF0WDl2?=
 =?utf-8?B?Nk4rbnhyNTIwMlIzeFZ3eVhWUDN1dllqRXRKaGRSZVc4N29nVjFrd0oyb1gr?=
 =?utf-8?B?aTNFN2VNT0VBNzFEZTROSjAxRDJoTnl4NWVhR3ZVL25UME9vc1VEOGdQaHNU?=
 =?utf-8?B?YS9ad0N0Y3V3RE4wNjhWRXkwWW9CNk82MGJYejVrczFwRmlTQWpsWWwrOEZ6?=
 =?utf-8?B?T1ZTSEJ6V1dnVVhhb0xHOFdDdXU3bzRhY05seEZwVlA5cXlVeTNFckxRUlpD?=
 =?utf-8?B?OVMzUmxRcitUZFZtdHlCblBYTDBhK3hPVjU5KzFaZ3ZkUUhNQmZoc3BzV3RW?=
 =?utf-8?B?MjFWZVN6c2doa0tyVG1TblhPM1MzQkZBc21EZTRTL3A5QjVsU0RwWCs3d3Y3?=
 =?utf-8?B?YnRQa3dnUkVaRjdQb1BnL2o0MGozUE81MW1PV2JMMU05QVhiQ0RXQ3FsWFVm?=
 =?utf-8?B?VzQ1ZndQT2tNUlAwWmgvNjZ1V0h0WVg1bTJIVkxyTjlqNUx4SXVOZVJrckxI?=
 =?utf-8?B?NVB1Znc2c3VWUFNuQktVUGt6OXFZbTRxUWZrOWV1bXRsbkZiYnVhMHBGaVdD?=
 =?utf-8?B?amhKZllETkwzamt5NHBPMXlpV1l6VUtQbDc3bmdoa1BpcjllWmpNdk0rdnlH?=
 =?utf-8?B?Zjk3Unp6Um04TnZTQ3RVdk94Y3RKQ0EwdXVxQkt5Sno0UXRNUjd0T2xJU3ZW?=
 =?utf-8?B?VWkwVSs3cTU5Z1hzMEZ3R0ZUNFR1VWxXcGp2T1Vvc05jdEFwMjd3dVlFVSsw?=
 =?utf-8?B?TUI0amhBQmZTS1RlMTNURW9qbUxVbDkxWXA1RUxuSUl3ODZ2ODZ5ZWw0NHBw?=
 =?utf-8?B?eXcyUTBtTUMrc1c2cTJwL0xSUUtkZExoMW1vOElpNXVhOFk4MjZFZWVlbkgy?=
 =?utf-8?B?Q092d2Y4S3Axb3dMS0RpT3pKbU9Qa2dCOHBacEFXYkF4S25TSFFJYkU0SS9o?=
 =?utf-8?B?eGpjMDhNbHZMb3JwUUJ5bkJjbUpsa1RoWXF5cXRUMWt5M0tqNTRPL00wbmlR?=
 =?utf-8?B?cjFlQlZsemIwL0haMTJrTnZTcEwvZko4VzFDaEtjMHFpTTlSRnpMcXczWUlY?=
 =?utf-8?B?L3orR0N3TFhhZ0xMR0t5cGJzS3lhTHBBblFSTGZRZkphUGJjWmlKcGxCZ0JW?=
 =?utf-8?B?MTN3UUd3VlFDcFU3SE5kZWVmemJnMElYM0MwOXNsWGVTK1ltRlB5c283Yi9a?=
 =?utf-8?B?UVB4ZVY5REtGMk5XT3l6clhjWlhDeVJtT0MyeWp0cVVZMzV4SzhoK0k4TS9D?=
 =?utf-8?B?UDc1L2NRWUZ0RXFYMEttOHlnS3JhM1BGQXUyemFNb2xLYkg4TkhHRE1vNU41?=
 =?utf-8?B?cml3KzFKSGw1cXlhditpNjJNbG1YTEhTS3ZGZFpJMEpYSEY2V3ExM1lhQnlx?=
 =?utf-8?B?enU3eklBUzdseUpqbzhGV3UweHoxdkhZV0VOQm5VVno0QUwxVjROc0dwb2lM?=
 =?utf-8?B?WXBaSml6Q3U1eUdNQUtOVkNyY0dNRUhNaE5QMUdLRXhlZjBGaVJuclBZbHlO?=
 =?utf-8?B?S1JUMnlkYko1Q0NTalpuWDlzZDZ6ckRGZWljNE1HRTRORGVteDRrbmM0TEhU?=
 =?utf-8?B?MWROVDkzQ0pVUUtOQUJHYjFQWGFCa2E3NFVnWExhd3loaTcrcHdRWVQ3bUZH?=
 =?utf-8?B?eHFVRzR5YyswRmJIOHRSbG1yOVNyR0dlVlExVWxtSUdISnd6LzkrZDd2MWRV?=
 =?utf-8?B?eWIzUEM2UmpVWGF5QXl5MFlWL1M0dFNuNDRUNzc2V21tai94bmQ0UGRqYjBX?=
 =?utf-8?B?aXBYT29pYzgxR1RueVQvd0tqT0NSaDBzenNoZzlBSnlnbG96Z0NIejdocFF6?=
 =?utf-8?B?c0s2ODdMdzZ5ZHZVTHZoSEpZVXJDaE4rNHZaa3VJTXFwRWY4UmhVWFZKalRy?=
 =?utf-8?B?NGc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc5f8dfc-545e-48eb-3dbf-08da6e5449a7
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:42:31.9601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V0cu9CyaLFpzlQMNykq5kq8fOynj6GIde8BQy27i6gbJAAS6I7Ahe54tFYQ9943k6vy4cbTQyc+bggmh30Zp6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB4394
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladmir,

On 7/25/22 11:41 AM, Vladimir Oltean wrote:
> On Mon, Jul 25, 2022 at 11:37:24AM -0400, Sean Anderson wrote:
>> This adds a table for converting between speed/duplex and mac
>> capabilities. It also adds a helper for getting the max speed/duplex
>> from some caps. It is intended to be used by Russell King's DSA phylink
>> series. The table will be used directly later in this series.
>> 
>> Co-developed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>> Co-developed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
>> [ adapted to live in phylink.c ]
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>> This is adapted from [1].
>> 
>> [1] https://lore.kernel.org/netdev/E1oCNlE-006e3z-3T@rmk-PC.armlinux.org.uk/
> 
> I did not write even one line of code from this patch, please drop my
> name from the next revision when there will be one.
> 

I merely retained your CDB/SoB from [1].

--Sean
