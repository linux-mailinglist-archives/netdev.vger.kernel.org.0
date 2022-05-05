Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D04D051BF92
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377246AbiEEMll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbiEEMlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:41:36 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2131.outbound.protection.outlook.com [40.107.215.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EFB55494;
        Thu,  5 May 2022 05:37:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HR5R7fzhqOQpGcICBLa/FzWBqUCSixEdxO4qhvzVHr30C7/CCbmXtVneQlcYkkMU0P3VfPY8el6YwMqwOIznRT5yXqMIIhIBuvwGGpEIQXYB3VIMvUYfVd60Mi3ckxDOPPwE0OD/3Gwe20wTy+dxUGpW7/h1/tEcxjUmXXnBXOajGZNBV8C1aUngV9iO52eAbHrOtnXHJZf69fSuxc+cOxM5EJvSICdyB5Xn45ygpFxvTFM8wqaLf8eVsmocogU9eXi0egFBS9XvjKJjUy3hHBupf30bA1KZPZt0VGL97zJG1nzMSU3pyIsIVSySX9R8FhEzDdCJkL2rWKqTiZCJlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hcEp71tZdo6mMWqKqI3RM/dIYw7fTY141eHjgucWGeQ=;
 b=ahjSLA9HiBX/DrN9Exmin6v/OsdOyMgyPkHq0z7Fwam7K5xN2oo+XgaB7Nyb73WuGNOAl44ILUh7GOSH66+656pHsppdwEEh8O8VAsidOkagEaCaY2BQ8U7a1UB3TTAbCj3PeYCkjtcQjX2mBxYPjowplnnM1PEf4gPpjWs2VmKafcubvGRZ7n50/5dJOWcyLh7WaGPzWIO98hdyBAVtHtXL9dQ2SL3WUbWWP6rAZAgbLHkONgZOxozc3VvKqsqvbTPThRDP0a9CE1ysT4smLNevBmXnXVk6+QgJlLI/fTMvcMROseauqz/hnfr1x8VLfcaLoJP6ZHQjQGpYow872g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hcEp71tZdo6mMWqKqI3RM/dIYw7fTY141eHjgucWGeQ=;
 b=SG70BorcKg4NBJWbRPIUWk8wiL+c0gjxrnn7kz3A92cGvSRuBGwE5gfvqPijapuMyqxI/zuHMuB5fJWiyRD7h8sfVPOMDUOUAGOabLYnkuT+vMyTTWubVi35DHV4tkCx38IlJoZlBXLWdZ/tGBQFYQ3yy5uXs6Ixy7nSno5bZxA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 PS2PR06MB3528.apcprd06.prod.outlook.com (2603:1096:300:67::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.12; Thu, 5 May 2022 12:37:53 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::4591:4f3e:f951:6c8c%7]) with mapi id 15.20.5186.028; Thu, 5 May 2022
 12:37:53 +0000
Message-ID: <2ec61428-d9af-7712-b008-cf6b7e445aaa@vivo.com>
Date:   Thu, 5 May 2022 20:37:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] net: phy: micrel: Remove unnecessary comparison in
 lan8814_handle_interrupt
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220505030217.1651422-1-wanjiabing@vivo.com>
 <YnO/VGKVHfFJG7/7@lunn.ch>
From:   Jiabing Wan <wanjiabing@vivo.com>
Organization: vivo
In-Reply-To: <YnO/VGKVHfFJG7/7@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR0302CA0013.apcprd03.prod.outlook.com
 (2603:1096:202::23) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3359d140-1ea1-4554-f545-08da2e941225
X-MS-TrafficTypeDiagnostic: PS2PR06MB3528:EE_
X-Microsoft-Antispam-PRVS: <PS2PR06MB352876AEEAD715C095FA0B47ABC29@PS2PR06MB3528.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BjQbic4/R3kuJq7wsxGOpQE9N3RBqfDLRz9lR6dLCXSCsJSeNAheYgaRTgZDPOvyyfY+rhdGySWb4DSfEDlOTuUAmWuDVRkgD0OrH6warg0+QIscQEN5e9rSnuKV8x/KhtPON7LDXDva8bC9JDOdWLktuxcR+z+qs8lIn/G1OybiN7l+FsYl68N3xVjw4LOS3MidMS3vxHqFAAY30sTfJObabIxZvP7tYmqytBpsDKk988pbKGRrjs97P+WVhMp1g2Reha5MLqZltb/1HBd5e8jBOsdfBBSxY1SRRmQL/FI3Qr8HqXrrJOGdiSVXTJiHSJ+2obQgdOQzDDB47k1/M4LUPWd+rKbfDTNEJYVHrUlYhXPt1b1UIvFFK5NzbXsSH5o5glJAwzsAOOr6xitUyhm2KlLXVPvbcWPk7idkgSxNJO7G4RI7yqX1zkAAOKwSCzPJkae4JXEggLy04OPAcwNfZgCAYlSrCFiAy/37752ziq5RR86mCGG7OdC2G4Yrbe0HP/+zm49fDHDzhM11YDSz4hWDLqooZ4adRDIWFsMNRbb6OkNOrzbG+jck0HqDeqfvzq3Rr9HPTRGnQ1gQWJGjT90njBOFY819uhNgybstpa5WthXSm+h5ofNfjS8+v2TmYE3D86PcgRYAr/Q4PoUwPnHbd7RbWMG2cWNMrhiMR5jedDkwVSyBswxb6ajN6iHFLrlBNnv7I5fnstOchKymrwnHUENPjj51RIWkf3gN85eRMtnM7eY4xO3CZBAwszMXIe8ZWwpScH8kDTtmnZLaR2MfgFrPEQCHO0ZAAZU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(31686004)(316002)(6512007)(54906003)(83380400001)(6916009)(26005)(66556008)(66476007)(66946007)(5660300002)(31696002)(86362001)(2906002)(6506007)(52116002)(36916002)(53546011)(36756003)(6666004)(38100700002)(508600001)(4326008)(8676002)(49246003)(2616005)(6486002)(186003)(8936002)(38350700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eFdFWW5yUXNyOWgwNko3TDdIYWhZWWsxVFhYbm9GOUVBNU9RWFQvWFdaVDM3?=
 =?utf-8?B?UWE2bnFqSXJFVzBiZGE2NWUvVzN1OXFGQXJuQWkrN0poNlhMYnZiLzk0cjdV?=
 =?utf-8?B?TWNreVRYS1pFbEM5TnJkcDRLV0hIOVk2Q2FPV2E5ODdxd2lscll2RW0ybUh2?=
 =?utf-8?B?c0JDdjJpeWFYY2t3UnUvbDlQOUxGNE8wby9Ydzcwd2MzSGE1aWw0ZjlLZDd2?=
 =?utf-8?B?bXRMSEd4WUxLRGc0c2lqVWhnWFQ4c0piUDIxUDhuT0tiTXg1cGVzOGNCUGhG?=
 =?utf-8?B?cHFieStQOFBQcGdhTFpYWDdnc2ErWloxVjZnUDFIWjlraEVBYzJUVHNTQW1r?=
 =?utf-8?B?VDFRQjg1b0pEKzd3K2JvUXZrUW8yTHIxaEIxdkEvTkRjY0FkeWM5Y3prLzlS?=
 =?utf-8?B?bm1QYUtCdzM1ZkRWb2VFOW1ndlpOZnNmSHpzOGZYSVRrS0ZWVHV4TnpaL1Ux?=
 =?utf-8?B?b0J0REhaTmk5UDRmMGN5dDlVbHVreFJFU2Z0ZlhKVG4yV0pnRG85RjhIWngz?=
 =?utf-8?B?RGp2SVZ3Y3VUbXRGOFBwb3p0WTFHTXYyOWZYVU5VL0tkci9wL3RCODA5WWJR?=
 =?utf-8?B?TVQ2bjFoWVJRSll4VWd0SUlSZE11bHlqM0Z5b0VGbXVUbmgrMU5CN3BXNFBB?=
 =?utf-8?B?N1RBSnpzSG82MlJScUd0Rmdsd2IxQ3lMQm44VUpGVklDcGM2ZmpRRThaY1M2?=
 =?utf-8?B?TmIwTXZGZCtmWHN2enZSMXl5MVgwT0JDRmFJMWh6RmFQMThKVWV4cjhKRko0?=
 =?utf-8?B?bDZJL3poRmNIZXJvSEpLSjFTRDVqSmdOZktpUXFRUjJ1a21PcVFYSDc3cUR3?=
 =?utf-8?B?MjdxbzFubkZwVDZRS01MQU5McmNOdGZ5WWlkZktmZytSVUNVVjJmN1ZlekJZ?=
 =?utf-8?B?YlgvamhlMEREUndOT2VweDZpSi9rR2hFbmNSVmY0akFidTh3QUhoU0lDb2g4?=
 =?utf-8?B?ZFNpcCtaTEJLa2hhcGRSaGxad05aWG9QRzRFUkkwT3MyNDZJaERjRVVDQ09U?=
 =?utf-8?B?WWkwYjhnM2g0Mm0rM0lVWFRDdjdvRGYzNnByY1lXK0x4K21ZVWtFN2JqYTJm?=
 =?utf-8?B?UVZ4N1ZFdms3Szkram05YmhhNjFNenByejVkd2dmRDhYQ0MycmVDbSt0MGs2?=
 =?utf-8?B?ei9pVG56bW1qOGwzNTA3WkpHbk5hUTRKZWtvVWtYSmZrMWtHa3AzRWU5WUhB?=
 =?utf-8?B?dFlhRTNsQytrMmludld6U0d1bkM1dU1tU1pVbmE4Ry90cjRRbVZ6dGFIVjBk?=
 =?utf-8?B?OHZTVWFWd3JOR01vV3o1MVEySTlIREo1OEs0NmErRkk3ZGFhT1VMQ3BVNTdU?=
 =?utf-8?B?ckNpSWtyUDV0S1hhcFFjcmE1VDBLTFN2NTl0UFAvL3FBZXUxM1FrZXhldFNG?=
 =?utf-8?B?blkyRFRSTkxWaGpuTUdUOGlDSU9kT2ttcldkb0JJNXllN3ZZREdIdlEwL3ZS?=
 =?utf-8?B?L2xDMXRHZTZrL2dmbTF3WEFmdU81RWkzZlUxMm5BYTNsZE0zT1U2STRGSktr?=
 =?utf-8?B?bC9ROVZKdTFLaXpsOWorVjBMTGdvL2ozUmJmM1FKZ2g0eVlBYjV5VVhOa2I2?=
 =?utf-8?B?RFFIT2lxUVQ2QXowZDNXb1JFajdGekprVzE5UERIL2JSWFdBN1FCcUpGOVNv?=
 =?utf-8?B?UFdCSnhGeWFZNG1Gc2w3dy94dTVUTjFkUEoxdUw3ZzZZRnVXbFAxQXJ4T1pW?=
 =?utf-8?B?ZVF2TFNRZWk3VUFEMlRKbzdIc1M0Y3J6aVFYaSs5OFBTbTJqN0p5aXdzaCtw?=
 =?utf-8?B?K3pPOHVKYkd2bDBDeFYyMEd5M1hKR2pNS1RYNHRralFkY1J5Qk9ob1RPdkhY?=
 =?utf-8?B?RUh6THRvQjJ3YkVLQzQzaWRaUTZ6L1FZTXpyVWhmcEMzNDhYVjZnVTg3Rlpt?=
 =?utf-8?B?Y21TVU5USmZxK211Ly9kWk9hZWlWZWlrd0dxbjUrZWJGR3Bxb3VMZkpXbnln?=
 =?utf-8?B?U25WcDhKV1AzOHhUeXhLYmZ6M0RBTE5xRTVxTjIyNno1V0ZmcnlDbzBSb0Z1?=
 =?utf-8?B?cWpXS0dYbXJPQjg5ZG1XR3FIbVVxSVN1ZUNoSUZZd1R2K3JUOU1sVXV3TFhr?=
 =?utf-8?B?eklzNWtJTy9wbEFFdGxLMVhEclFmZ0tGQ2p6OWZ4TEJtTFlCZXREOEwvSUgw?=
 =?utf-8?B?ZGo4S3h6OVNPOWhUK3NFankyQnhVTmM4ZjRkQTNKVlNXYnpGelFqZFRxaDBY?=
 =?utf-8?B?L3cydzI5MEZOQllGdTlGcTV2djV6VE1PZzdpTjRTaEgxaDdlVEl1amRJR0hJ?=
 =?utf-8?B?K3hGa1JHSDJjajdYU29uZWx6a1pVOFBxTlVYUGNLMlhmem83SDF3SEtDbGNW?=
 =?utf-8?B?akRoQ0F6Vmh6b0hkckZVQlpDVmx6ZlJiL0I3eEk2b2JJcTVlV3I5QT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3359d140-1ea1-4554-f545-08da2e941225
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 12:37:52.2892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K+fcUd8dF5+3JT035zJ82Bnp7bvbZijb9cVLFevR/pk9mG1zxMqpEgQDqhx/3Tj5IxYIz6NWycBHh0DM/3mYCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PS2PR06MB3528
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Andrew

Thanks a lot for your priceless advice!

On 2022/5/5 20:13, Andrew Lunn wrote:
> On Thu, May 05, 2022 at 11:02:17AM +0800, Wan Jiabing wrote:
>> Fix following coccicheck warning:
>> ./drivers/net/phy/micrel.c:2679:6-20: WARNING: Unsigned expression compared with zero: tsu_irq_status > 0
> There are at least two different possibilities here:
>
> As you say, the comparison is pointless, in which case, it can be
> removed.
>
> The code author really did have something in mind here, the comparison
> is correct, but there is another bug.
>
> I would generally assume the second, and try to first find the other
> bug. If that bug really exists, removing the comparisons just adds one
> bug on top of another.
>
> So, check the return type of lanphy_read_page_reg(). It is int. If you
> dig down, you get to __phy_read(), which calls __mdiobus_read(), all
> of which return int. All these functions return a negative error code,
> or a positive register value.
Yes, I actually check the lanphy_read_page_reg and I notice 'data' is 
declared
as a 'u32' variable. So I think the comparison is meaningless. But the 
return type is int.

1960  static int lanphy_read_page_reg(struct phy_device *phydev, int 
page, u32 addr)
1961  {
1962      u32 data;
1963
1964      phy_lock_mdio_bus(phydev);
1965      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
1966      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
1967      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
1968              (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
1969      data = __phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
1970      phy_unlock_mdio_bus(phydev);
1971
1972      return data;
1973  }
>
> So the real problem here is, tsu_irq_status is defined as u16, when in
> fact it should be an int.

Should the 'data' in lanphy_read_page_reg be declared by 'int'?
>
> As a result, a negative error code is going to get cast positive, and
> then used as the value of the interrupt register. The code author
> wanted to avoid this, so added a comparison. In an interrupt handler
> you cannot actually return an error code, so the safe thing to do is
> ignore it.
>
> Please consider coccicheck just a hint, there is something wrong
> somewhere around here. You then need to really investigate and figure
> out what the real issue is, which might be exactly what coccicheck
> says, but more likely it is something else.
>
> NACK
>
>     Andrew

Finally, I also find other variable, for example, 'u16 addr' in 
lan8814_probe.
I think they all should be declared by 'int'.

Thanks,

Wan Jiabing

