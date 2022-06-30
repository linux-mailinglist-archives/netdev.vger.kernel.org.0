Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B29C5621BC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 20:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbiF3SL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 14:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbiF3SL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 14:11:27 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977673AA6F;
        Thu, 30 Jun 2022 11:11:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDU+Ox3BPdK4UEpkGourcHw+gJV5jDnfUwlst6Moz/d8AIA0Ga76gPvhcN5UGMuPgCgLPp8itgGFd0FXv420aotgOflLFNRG270J1mW693ljWDuVEHhDg/2EIBy8NHIrcCRWoqjKHP1NGSYheakUWm4fkRGXq0uG3OLZEtYduxAOiepzT2xQddGXVmob5vEXJ6kTeQ2W3FOzWi7I1o4YQY/Uy18Bx0NM7mgYfIKBYBj0eSeQk2k3QbJMIYlyVPFMy3kOQjbXBoaoDrLpYUfwPml6rxShv+zf46Y/ZqpYLNMCdQr0WtbN9K89RF1o2U7kR/lfTcLBqH0DYnjUCRZljg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/88wiFDdYcoPBOaQpefSVmBhNllDXt3mI7vc9YGu9Ak=;
 b=TVmpafUDmyIXEzYEhrgC+Ms0CCaF2POZ0ttuGmNJaop9xnV4oEXk8N9qHVufYCeZo/i0eu9Z1HnFuIKkemYLv2xl07S2O5vX+PVYMIGPgio8NS14qo44p365+1rZA/XaJ0ZGuUOEZ9vWlkFYE6xkjp/SCwKEkmwO+5Wdb9ZVmzQDUI+FKbc/m04R1zv/KbSm3cU/CfDQ7u9+Pipik8pu1yCv5xVIeQKPNDYFsLuLvjuD1LvM2LHlOcXryGC8UiH96Hyhgda+RVRdIAc5q7mHhHy2J6UkVYMiK5yQfk5EgcCzoFq7Ae4EC5ws0UFSWyhQUPWcUCImf8O3WT4sYTNZ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/88wiFDdYcoPBOaQpefSVmBhNllDXt3mI7vc9YGu9Ak=;
 b=bAhFzmgXy4GM+LptfPjxd8fnHoGf75+nrKMSnPrTB5VkqfSMAx5oghvi7B/xYKym0M0gfYhH12XUhWc6oUTETJeSNPW4L3ez7no1OxzX1u1zv/6wkLt43GTrOYS+LcEAF+ZaAbmjbBS254+I8bhOU8s5o+JWbevHsLaTjz+hP4qKAhZ9Ax9OQ0XEqaTj0gn8OQK6DVF0m3q/4Yh9repbVDV+t9hoJgLpi3MWM762nf3W7+QyFPX8GeTk7SlVMBhCqoKpsXki9cFKNQtYkNwJopVVv/wLRPbgli4TdQiCSjgTH21FTVrCN1Ev6XjdhmEWgpGgXiQoIRXgjYP5jkoWEA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR0302MB3332.eurprd03.prod.outlook.com (2603:10a6:208:3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 18:11:22 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5395.015; Thu, 30 Jun 2022
 18:11:22 +0000
Subject: Re: [PATCH net-next v2 04/35] [RFC] phy: fsl: Add Lynx 10G SerDes
 driver
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Eric Dumazet <edumazet@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
 <20220628221404.1444200-5-sean.anderson@seco.com>
 <20220630155657.wa2z45z25s4e74m4@skbuf>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <0ed86fb5-4d26-4fb2-8867-adf9df1eea2a@seco.com>
Date:   Thu, 30 Jun 2022 14:11:17 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20220630155657.wa2z45z25s4e74m4@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6)
 To DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5e836e72-4ef8-473a-6339-08da5ac3f06d
X-MS-TrafficTypeDiagnostic: AM0PR0302MB3332:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HrKaPgl9otAipp17pBSuQLrccU7iX8QYibWi9iPNqYYkYx2woS3sPPvg8Cgk7Z14w9HbmBJJ/RDZoFr/tbKgMVBOm2YzV0NyLQcrpXePLJXtMMvHDs68LnnQw6G2hR8liXSuJiMuxRHc8Npk7Ikn5P1NqurkZkAcAftyQwrDbioegeg6nP1oWImhk2I0Ltq9WXq2iJLwFdJutb2fwwl4UdSPLgXhbLtJ3vxozt8GEsZnBt3WYnWvw8U7JMWCEgo23GDkgYGbzS6GHkqOswWMihjwGrh1WLc6KfudIbPJFbxXZGEmd6x2KoHhhxbGOlKai8nGSR7/cllkgqg4riFeK7MXnS5EdW4pFmq+tmthfmWH/hPuN0yUXwpkdtxadWwDXV/ZEZzur9qxjZS9lT/GXf+PfDwGRO83fi2FBwwZ4aFCSubNCdbldPqifeLQlObBy4E1KMOZjTTw0mA1hQQhlzDSmqBMcvjJ6ovRwBXHCXh1yu0v+plF+wf1QokF68Y6xS2JNyJJiXWrQwt94hcHC/hILsiZ3rnVEvDv3Gh8Dyu3V2x3ne4IXMAbfcS+u16fJ2m5X4a+Fi94qFBtst+q4qgFq23sOvbWwFsHrHbN3bGsU9oGLF1Trlg6Tb/PHbaaR0jh3fznWBuLqI6AELtGZtt1Cce89BM/pBylB7BunyWpBu7rHxv82U+UmJNhkc//unNci/QdPL/W2VwgyNk9DfhfRXR2ErGXbu9vvonmUgQhF82EpDwiDX/8LoVRCmYpZbvsVPE7BQ1/uRKc4M/+tpnHCdrKoCWu1ATS7FUAIx3EeDOrXTZ0EFOQolyNhoGKLo4BTENXAZljY0C/b+NiuhKq6LhbkG2M9Q68yX/uvFfzpdL1OPiRdAlvHGIbmLwj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(376002)(346002)(39850400004)(366004)(396003)(52116002)(6512007)(26005)(2616005)(53546011)(66476007)(86362001)(5660300002)(38100700002)(186003)(83380400001)(6506007)(38350700002)(2906002)(44832011)(7416002)(8936002)(66556008)(41300700001)(478600001)(6486002)(6666004)(6916009)(4326008)(54906003)(31686004)(36756003)(66946007)(8676002)(316002)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SnpmbGd5M0llOG9wYlh2b0lkWk1JTDJ2Z0VSaUZpVkdHemtkZDZEVGNSVXFu?=
 =?utf-8?B?MS9hc1E1WHJJRTNBRlZlTUlSVmNramhwQTU2WDZXKzNmMGhob2hsSldlNzFJ?=
 =?utf-8?B?TXFsWU1qL0hRWUl5TFhYZndrdkNzQzdzdkMyRXFHbGVVL2ZHN2JrZi9LSnQw?=
 =?utf-8?B?WWNpS1ljY04zdkY2UllFaXVZbDlWNzlqempCK0JOVDZhT1NpRzgxNEpVSGh6?=
 =?utf-8?B?alR3VU53TkxwSjIxU2JUWDF1WXY3WFJIa1AvNGNIVjVseGtUR0dyZ3VDT0h4?=
 =?utf-8?B?OXIxWHFRWExSN2oyRWw4WVFHaGNRcjd6Nkp3c01Sc2lsbzQrbUJpYzc3cDcz?=
 =?utf-8?B?NjR0bllHNjlOTDV3VmtqN1JmRjFNYTFkaFAwMng2enNsems1bGpiSzhBUlBt?=
 =?utf-8?B?R0tZZ2xYdXF3V292cGVKZWxjcDNaek5HUWJ5aHBJcWpZOG9ZWldBTktGWjI2?=
 =?utf-8?B?R1NTNzZmVnNTUzRSWjYxdFBwZlU1U0xKTUUycWZPT3h2UmlRNjZHdDNtTVNs?=
 =?utf-8?B?SmthK2RmM0tYVTBoaTY4QlU3d28wYWdOVlhtRHdDS3dQMU9QWXBqTmsxdlkw?=
 =?utf-8?B?c3FOOG5JTXdkYmwxOUI4VTdJT1hDWm0yeFFlZ28ybENFNjgxY0JGN2x5R1la?=
 =?utf-8?B?K01oRVByaVBIeG9KUVlrYUNZUmpoUDdXVkluUTM5RXVSbjZSeURhY2tNdldk?=
 =?utf-8?B?YVVpR3hIUGlQYU5vc1BDTjUrSG5zUUlUcGx2WXVZeXB4b0toVUVmc3BtNXIw?=
 =?utf-8?B?UHhwdWZMNTBxKzZKekJHTmdpaytIRUFYUTZ5UVF5S2tzUHBUNFBVNTlXS2NU?=
 =?utf-8?B?a21sM3BsYTVCelVpMXBudXc4Y2ZwWkliMVNBKzA2VFE0ZnVob2ZoeDJydldK?=
 =?utf-8?B?cDFwK2NSa0lWTVNjSWlidWlOOTlPTlNrek01S3NDQ25VREtCSnhYanhFS3Zw?=
 =?utf-8?B?WkpIaDh4YXlPYVRFZFE2REZvVG41L29XSDNFempkVDZWd05IZkJFT3F2U2pZ?=
 =?utf-8?B?ZE82V2xnamxJZjBjaDdPRDNNM2Z3eXJNRGJhOWd5dHd6U1VsSTlYbW9jeklI?=
 =?utf-8?B?SnYxVkR6S0ZlUWZiMlY0NWxWZUdFcWVyNWdTdnhOUXVHTlNpbGUzZEZzN09s?=
 =?utf-8?B?d0ptQmplR3NKOEUybjhUVU5xWW5Ma3A4dndSSHBEN1h4Zm41Y2RqazNqVGU0?=
 =?utf-8?B?emFCRWdTZk1pZXNSaE42U01Pc0puU1grODZ3dElTQjJXeHEzcnduOTVPSTNK?=
 =?utf-8?B?dHV4TmRBYUFkUjlHY3I4cjJmSkk1MEsxWXJlaVFyUW44WEFvVUEvZHhQNTh5?=
 =?utf-8?B?czdwRldxWXdjZ0hsSi9zeFcrczhXSG5PQ1gzbEQram92bmJKMWdsd1J0eXVR?=
 =?utf-8?B?Nkt2eEY5MWpCclFPL0hrVHBLSW1QM3RqNmV6RDJxOEN5R1IrVkZnOFdGWUlT?=
 =?utf-8?B?KzN6NUliUmRHZTAxdjFiM29NbExURjgzVnVaeE41MmFCM0JKWURYZDd6UldJ?=
 =?utf-8?B?TGlXZjIxczJoa0JBdXRiY01EL0pObDROYW5pTEJUWGM2WVYzK3piUFBQMnVN?=
 =?utf-8?B?UGlsTitGQ1pGbjFoazlCU0dTOE16Z0ZvME55OFMzQ2I5ZXVVS0UyUHhiTE5z?=
 =?utf-8?B?SWRXZUZmQXdCSU9SbG16NTVaMkRJdUJiandnemwycEhYbmVCTUs2VDYxbC90?=
 =?utf-8?B?NWhnZ0pSYThFYkpjT1VJRVpVbzl6Syt1akNENVpuUVhFVm5tNDg4SldFU2NK?=
 =?utf-8?B?VXArYkJJS1RyeXFIZ0RleHhGUFEwWHZZZldjT2FYN2RsZEE2a1JpRXpkQXhZ?=
 =?utf-8?B?aFhzNm5vUkx2bk0va0puOUxiMzNGVm5udjllZWRKSytkZ3BGdCtnd2ozTkg1?=
 =?utf-8?B?bTQrNUZPam1lWmcxZzBnWlNjcmRLaEtKUXJVU1JuYnZ4YVQ3bGw4WFp2b0wv?=
 =?utf-8?B?MEllVlNDMjRpZjFnZlNKN003MzdQaEhtdlluaVBEV3pxb29SNkw1WVhMUUsz?=
 =?utf-8?B?ZzBsU004bkJ3MDczNHpZMVZUKy9sVXJrTk9ERWFBblhvTFhNcjFCdzJxOS9M?=
 =?utf-8?B?NlAzTFQxVmxXZjdkL2RHTG54VTRkU2w3bks2UTdMYmlWZU9PM2Z2S0JBVzlF?=
 =?utf-8?B?UVRWU1kwTHNSQzRCUHBCZHJjMzh5YUNFMjFJNHFkODBVR3VUTkQxS1lYbDJj?=
 =?utf-8?B?Rmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e836e72-4ef8-473a-6339-08da5ac3f06d
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 18:11:22.5950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5PS4d6KK+Monyxpj+OM5u+/VapyTc62Nbw0t9seogAj/mdLodZfx1Zq19vfU5jps2Xu96ayFWe3OtK9piPgblg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0302MB3332
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/22 11:56 AM, Ioana Ciornei wrote:
> 
> Hi Sean,
> 
> I am in the process of adding the necessary configuration for this
> driver to work on a LS1088A based board. At the moment, I can see that
> the lane's PLL is changed depending on the SFP module plugged, I have a
> CDR lock but no PCS link.

I have a LS1088A board which I can test on.

> I'll let you know when I get to the bottom of this.
> 
> I didn't go through the driver in detail but added some comments below.
> 
> On Tue, Jun 28, 2022 at 06:13:33PM -0400, Sean Anderson wrote:
>> This adds support for the Lynx 10G "SerDes" devices found on various NXP
>> QorIQ SoCs. There may be up to four SerDes devices on each SoC, each
>> supporting up to eight lanes. Protocol support for each SerDes is highly
>> heterogeneous, with each SoC typically having a totally different
>> selection of supported protocols for each lane. Additionally, the SerDes
>> devices on each SoC also have differing support. One SerDes will
>> typically support Ethernet on most lanes, while the other will typically
>> support PCIe on most lanes.
>> 
> 
> (...)
> 
>> +For example, the configuration for SerDes1 of the LS1046A is::
>> +
>> +    static const struct lynx_mode ls1046a_modes1[] = {
>> +        CONF_SINGLE(1, PCIE, 0x0, 1, 0b001),
>> +        CONF_1000BASEKX(0, 0x8, 0, 0b001),
>> +        CONF_SGMII25KX(1, 0x8, 1, 0b001),
>> +        CONF_SGMII25KX(2, 0x8, 2, 0b001),
>> +        CONF_SGMII25KX(3, 0x8, 3, 0b001),
>> +        CONF_SINGLE(1, QSGMII, 0x9, 2, 0b001),
>> +        CONF_XFI(2, 0xB, 0, 0b010),
>> +        CONF_XFI(3, 0xB, 1, 0b001),
>> +    };
>> +
>> +    static const struct lynx_conf ls1046a_conf1 = {
>> +        .modes = ls1046a_modes1,
>> +        .mode_count = ARRAY_SIZE(ls1046a_modes1),
>> +        .lanes = 4,
>> +        .endian = REGMAP_ENDIAN_BIG,
>> +    };
>> +
>> +There is an additional set of configuration for SerDes2, which supports a
>> +different set of modes. Both configurations should be added to the match
>> +table::
>> +
>> +    { .compatible = "fsl,ls1046-serdes-1", .data = &ls1046a_conf1 },
>> +    { .compatible = "fsl,ls1046-serdes-2", .data = &ls1046a_conf2 },
> 
> I am not 100% sure that different compatible strings are needed for each
> SerDes block. I know that in the 'supported SerDes options' tables only
> a certain list of combinations are present, different for each block.
> Even with this, I find it odd to believe that, for example, SerDes block
> 2 from LS1046A was instantiated so that it does not support any Ethernet
> protocols.

As it happens, it does support SGMII on lane B, but it mainly supports
SATA/PCIe.

If you happen to have some additional info about the internal structure of
the SerDes, I'd be very interested. However, as far as I can tell from the
public documentation the protocols supported are different for each SerDes
on each SoC.

E.g. the LS1043A has a completely different set of supported protocols on its SerDes.

> I'll ask around to see if indeed this happens.
> 
>> +
>> +Supporting Protocols
>> +--------------------
>> +
>> +Each protocol is a combination of values which must be programmed into the lane
>> +registers. To add a new protocol, first add it to :c:type:`enum lynx_protocol
>> +<lynx_protocol>`. If it is in ``UNSUPPORTED_PROTOS``, remove it. Add a new
>> +entry to `lynx_proto_params`, and populate the appropriate fields. You may need
>> +to add some new members to support new fields. Modify `lynx_lookup_proto` to
>> +map the :c:type:`enum phy_mode <phy_mode>` to :c:type:`enum lynx_protocol
>> +<lynx_protocol>`. Ensure that :c:func:`lynx_proto_mode_mask` and
>> +:c:func:`lynx_proto_mode_shift` have been updated with support for your
>> +protocol.
>> +
>> +You may need to modify :c:func:`lynx_set_mode` in order to support your
>> +procotol. This can happen when you have added members to :c:type:`struct
>> +lynx_proto_params <lynx_proto_params>`. It can also happen if you have specific
>> +clocking requirements, or protocol-specific registers to program.
>> +
>> +Internal API Reference
>> +----------------------
>> +
>> +.. kernel-doc:: drivers/phy/freescale/phy-fsl-lynx-10g.c
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ca95b1833b97..ef65e2acdb48 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -7977,6 +7977,12 @@ F:	drivers/ptp/ptp_qoriq.c
>>  F:	drivers/ptp/ptp_qoriq_debugfs.c
>>  F:	include/linux/fsl/ptp_qoriq.h
>>  
>> +FREESCALE QORIQ SERDES DRIVER
>> +M:	Sean Anderson <sean.anderson@seco.com>
>> +S:	Maintained
>> +F:	Documentation/driver-api/phy/qoriq.rst
>> +F:	drivers/phy/freescale/phy-qoriq.c
>> +
> 
> These file names have to be changed as well.
> 
> (...)

Will fix.

>> +enum lynx_protocol {
>> +	LYNX_PROTO_NONE = 0,
>> +	LYNX_PROTO_SGMII,
>> +	LYNX_PROTO_SGMII25,
>> +	LYNX_PROTO_1000BASEKX,
>> +	LYNX_PROTO_QSGMII,
>> +	LYNX_PROTO_XFI,
>> +	LYNX_PROTO_10GKR,
>> +	LYNX_PROTO_PCIE, /* Not implemented */
>> +	LYNX_PROTO_SATA, /* Not implemented */
>> +	LYNX_PROTO_LAST,
>> +};
>> +
>> +static const char lynx_proto_str[][16] = {
>> +	[LYNX_PROTO_NONE] = "unknown",
>> +	[LYNX_PROTO_SGMII] = "SGMII",
>> +	[LYNX_PROTO_SGMII25] = "2.5G SGMII",
>> +	[LYNX_PROTO_1000BASEKX] = "1000Base-KX",
>> +	[LYNX_PROTO_QSGMII] = "QSGMII",
>> +	[LYNX_PROTO_XFI] = "XFI",
>> +	[LYNX_PROTO_10GKR] = "10GBase-KR",
>> +	[LYNX_PROTO_PCIE] = "PCIe",
>> +	[LYNX_PROTO_SATA] = "SATA",
>> +};
> 
>> +
>> +#define PROTO_MASK(proto) BIT(LYNX_PROTO_##proto)
>> +#define UNSUPPORTED_PROTOS (PROTO_MASK(SATA) | PROTO_MASK(PCIE))
> 
> From what I know, -KX and -KR need software level link training.

There was no mention of that in the datasheet, but I suspect that's
a PCS issue.

> Did you test these protocols?

No, as noted in the commit message.

> I would be much more comfortable if we only add to the supported
> protocols list what was tested.

Fine by me.

>> +	/* Deselect anything configured by the RCW/bootloader */
>> +	for (i = 0; i < conf->mode_count; i++) {
>> +		const struct lynx_mode *mode = &conf->modes[i];
>> +		u32 pccr = lynx_read(serdes, PCCRn(mode->pccr));
>> +
>> +		if (lynx_proto_mode_get(mode, pccr) == mode->cfg) {
>> +			if (mode->protos & UNSUPPORTED_PROTOS) {
>> +				/* Don't mess with modes we don't support */
>> +				serdes->used_lanes |= mode->lanes;
>> +				if (grabbed_clocks)
>> +					continue;
>> +
>> +				grabbed_clocks = true;
>> +				clk_prepare_enable(serdes->pll[0].hw.clk);
>> +				clk_prepare_enable(serdes->pll[1].hw.clk);
>> +				clk_rate_exclusive_get(serdes->pll[0].hw.clk);
>> +				clk_rate_exclusive_get(serdes->pll[1].hw.clk);
> 
> Am I understanding correctly that if you encounter a protocol which is
> not supported (PCIe, SATA) both PLLs will not be capable of changing,
> right?

Correct.

> Why aren't you just getting exclusivity on the PLL that is actually used
> by a lane configured with a protocol which the driver does not support?

PCIe will automatically switch between PLLs in order to switch speeds. So
we can't change either, because the currently-used PLL could change at any
time. SATA doesn't have this restriction. Its rates have power-of-two
relationships with each other, so it can just change the divider. However,
I've chosen to get things exclusively in both cases for simplicity.

>> +			} else {
>> +				/* Otherwise, clear out the existing config */
>> +				pccr = lynx_proto_mode_prep(mode, pccr,
>> +							    LYNX_PROTO_NONE);
>> +				lynx_write(serdes, pccr, PCCRn(mode->pccr));
>> +			}
> 
> Hmmm, do you need this?
> 
> Wouldn't it be better to just leave the lane untouched (as it was setup
> by the RCW) just in case the lane is not requested by a consumer driver
> but actually used in practice. I am referring to the case in which some
> ethernet nodes have the 'phys' property, some don't.

The reason why I do this is to make sure that no other protocols are selected.
We only clear out the protocol configuration registers for a protocol that we've
configured (e.g when we go from SGMII to XFI we clear out the SGMII register).
But if the RCW e.g. configured QSGMII, we need to disable it because otherwise we
will accidentally leave it enabled.

> If you really need this, maybe you can move it in the phy_init callback.

That's fine by me.

>> +
>> +			/* Disable the SGMII PCS until we're ready for it */
>> +			if (mode->protos & LYNX_PROTO_SGMII) {
>> +				u32 cr1;
>> +
>> +				cr1 = lynx_read(serdes, SGMIIaCR1(mode->idx));
>> +				cr1 &= ~SGMIIaCR1_SGPCS_EN;
>> +				lynx_write(serdes, cr1, SGMIIaCR1(mode->idx));
>> +			}
>> +		}
>> +	}
>> +
>> +	/* Power off all lanes; used ones will be powered on later */
>> +	for (i = 0; i < conf->lanes; i++)
>> +		lynx_power_off_lane(serdes, i);
> 
> This means that you are powering-off any lane, PCIe/SATA lanes
> which are not integrated with this driver at all, right?.
> I don't think we want to break stuff that used to be working.

You're right. This should really check used_lanes first.

> (...)
> 
>> +MODULE_DEVICE_TABLE(of, lynx_of_match);
>> +
>> +static struct platform_driver lynx_driver = {
>> +	.probe = lynx_probe,
>> +	.driver = {
>> +		.name = "qoriq_serdes",
> 
> Please change the driver's name as well.

Will do.

--Sean
