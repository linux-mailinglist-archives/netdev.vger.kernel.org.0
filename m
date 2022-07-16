Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C74FB577207
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 00:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbiGPWrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 18:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbiGPWrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 18:47:18 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2067.outbound.protection.outlook.com [40.107.22.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E55183A4;
        Sat, 16 Jul 2022 15:47:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V2SoNsRod8z+Dy8hlrVtonM1r9MGqOqIVnKbiU3OWclykawULrLvZIwKQDKdAHVsEUPeuoSGce0tsJJ24RWzxgpwO719M5gd3gyJ2XpAiPcUMGMm95euK4jMRsmjFwuz6xIP79PX8GV3HgaepX7hCL2BPLw6WBQ9JmZwkJQfhiTbHOBfwF09eVIPsa1b9gXHUauZOHJbZ5RsUSsQkpnPRMm3w0AUW1VUtXPR+WN0JUua6I5/ajlE/Q5nwn+GinQvQKhcxnped5veWaBobSz0TW3UcXMdAQ7d7BpXq2AlZi7JBVFMGCe63DCAnLeCifywKz6M6VpPHqa99Svglf/Icg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HgsbMVmtnHfeqy+vNpf4joH/Ju7GUw/tOidwJXF0eYU=;
 b=VXyGrtQatz7S9qoBnvBoZEgSw6LnBcB/FZf8dKooIsAjByrjoK98JeHwsoBwDWPvHLSA/o7v/PFpocroEjIHngkbr9hWnBSXf+KUoVLnkGPov6g82+DIpgPFzmk43oscK6U3K2smHa6otIltsCw108nU8bx0Dd02VnP1xhjS8OwESXPPPJSsJVyk1vHy9nr9Hzu3fXmZE1wfXEqwqCDar7zvv4SDJtRYbivLbkFz64w0I4fHx+xDmgXpoOugH7KqgFnrHwEaVgXWG7fBkrzLMr+eaXCWB8zvJTPcmtDR2/QRlTdEgsXtzFWCKLuVieWzi/EU99im/5/UW+6p6C4DrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HgsbMVmtnHfeqy+vNpf4joH/Ju7GUw/tOidwJXF0eYU=;
 b=n4MIvn1XhHDZYjg3cMkRCzo7fgzeiW/c+eonkC6APlK//6rQREGXzFGqOMEcxuUw/3D7YK6VHKyHmnMM12CNQuMgHRMPmiRqRzp9wH8zeK8yZ5ynqJ3tlsXJ0IrVj4Zs3Y0J7dPAOmlQr9/5ZQgjUWZCd7Mw9xEKsd5E56RFeogVp049A2ccu6y3fLOngdYPltHiQWXs6n3lmnY9X/CgqekHoiMgDXWqCYLBgzRv16h3pXlQ7H2yWD2OBTxwx4eXChMmN2HycszUXvkRotoJ6DUUWgLrI+TXdyTOXxDFy/sSjW7E7BYYNKi46+0WQN88tzRgAHWFevJW9DndzhPSrg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5541.eurprd03.prod.outlook.com (2603:10a6:20b:d9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Sat, 16 Jul
 2022 22:47:13 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5438.022; Sat, 16 Jul 2022
 22:47:13 +0000
Subject: Re: [PATCH net-next v3 03/47] dt-bindings: net: Convert FMan MAC
 bindings to yaml
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-4-sean.anderson@seco.com>
 <1657926388.246596.1631478.nullmailer@robh.at.kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <1b694d96-5ea8-e4eb-65bf-0ad7ffefa8eb@seco.com>
Date:   Sat, 16 Jul 2022 18:47:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <1657926388.246596.1631478.nullmailer@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0222.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: de676978-7ce9-49fa-1be0-08da677d1ffc
X-MS-TrafficTypeDiagnostic: AM6PR03MB5541:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ksa4on011v7zykfgepeUuD6dlEYVBzXLobfmSHMMTB2LJUJaaIwlNtgjJhh2SNEx0u0maVh+EMAyYt3hloUI0HYsD928szH3a83Fvk6ryli85nW36ddHBuKUeHI+jgdyqBdBf4pBIPRQtRa5KSNiQNlpt4wmFbQgxCmURrN+1YoARMLIxMdeuRtGWwyZU/iy3JFwFHHjRWF6PnBfsC9XCVRPvH+JZH0zomRE+lsFonD0LxKZ3U/uumRO688b/STG8B9aN1Em0nK8bvKRRU4UmPOZDw3Iwgw4rVPCtgTyJCjYcESBakZ3xTMnMNxaz1yxuz86I2F/OQtrhplm1dIXYMu5unx15vDauSWuJmrerNDWRQexy7z6EJe1TGu8Qx6TgbgecC0Hgr6apLyzCd0a5DQ5kPUuBJTSkQryhJHb0rze4lK01p2WP1Bq/4lZIPgW1nJrn3O4Bmmlw8XNttsjlAMo7Fjmwguy1KeauZEKEmRrb3RfSyXD+MaXnOortbjjkHpwfl7nkJhuhHKmM2UJWpX+ISxPAy3lXCYUfoAE/cY9Cnlk9lHFZHgRn/zXA/qCUgqoPSlZ/0qyRyiOdQ6741wY1M9I1jqGX2zCX5a2iazslBqB/245gaNHFFcthzspVOdh5Wa5yxv+4tunEKltdB4M5GzDmX/YTCY1/wmtz6nw4GfM53imTVyOg1rd3qKEUMCoCVGIpwVwEgL8B5ZxwzR2WaZCL9Ph9zZ1Anf+42n2c9A6LCo7fMhB7FXiLqq0IWpJHXIlytA9KK9djl2Ur5+mNoq0DCKnMsCUMBKfyF8b62+FHi+y0UrX3jdlWvtUSm4aNvHt4qqQeCN588TnSqgC1kQbAjV7irfDU9sUH8mFF20dyFFlYzfZkO+zMT71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(396003)(136003)(376002)(39840400004)(2616005)(26005)(6512007)(41300700001)(6486002)(8676002)(2906002)(6666004)(31696002)(86362001)(66556008)(66476007)(478600001)(53546011)(52116002)(6506007)(38100700002)(54906003)(6916009)(36756003)(4326008)(31686004)(316002)(66946007)(83380400001)(8936002)(44832011)(186003)(5660300002)(38350700002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cDVwRTJacWJEVC9WeXRLWHEvSktkZnQ2VUZmTzgrM2MybEZvWXVicEVYTmpx?=
 =?utf-8?B?dlkwb2ZCN3B0dWRIcU1KUzUyTGMvTFBrOU1idjRObndRRHZNWmNCZlFuOFAx?=
 =?utf-8?B?SW91SEZGM1RXNXBlT2lCbHlHOGFyeU9ZVWZYWEtiaUMyemdWSXFHc3VpUFVC?=
 =?utf-8?B?OHIyMHNIVE9JTkVnVk9MbVlsRlBRWXY0Zjd0ZkxCc2R3SjM1Qko3S05mZ0l0?=
 =?utf-8?B?dUdZdDhJYVhrODNxNUFnUFhGc01Kb0toWG10LzM5SDhVUWs0bVZ2WGtuZGox?=
 =?utf-8?B?RmdMbHFqc2pqRWdBYWZ2bjBCaUtQbGNqK2ZXZXhwWnRkZE13UUFzcmRkT2lj?=
 =?utf-8?B?N1RGMU9VMW9KNzYzdGVBRkhwOWRmSnBDcXhvRE1JUlhmSUdIclZKUjU1VUJ2?=
 =?utf-8?B?bHV1b1Q0clRyTXRrT1VRZlNPRW11MWVUcG9PQmdDNmRRNVZBNTk2MmhvSmhB?=
 =?utf-8?B?aVU2UWtabkZKTEErTHUxOFpCZkQ3dnp1OU1RSmlSZWZkb0hOT25ENGlwWDNC?=
 =?utf-8?B?TW1Cd3ZLUmR0NUhtSThzeENDRlpJdlRsaHhpNjEvZFlVNTBoTmtHNWVJRmhh?=
 =?utf-8?B?S0hvZXhpYTVjQXpYaVVMS0ZMQ2VLdS9GK3JScXFMMWM3UXBWRlFIcGNmMmVo?=
 =?utf-8?B?WmlNcjUzL0NPb0xKMjcwZHBiUytnSGE2QjVra01GNlNuZldWcGFyNFRQSjZw?=
 =?utf-8?B?TGR6WVpVb2p4b0orQ0MyYzF6UzMzVitoaU40UjZ0L1BmckVQRUNUVlk5YUgz?=
 =?utf-8?B?MTc3U1hXbWUwYXRGVFBFeEtCdGtyVWVEcWw4d3p1TXYwWkMxVk1PS25MV001?=
 =?utf-8?B?SmpDelBmSHJ1cUQ1T25ZU2VnRFZoSnlmNWZGYlNSNUovdjRSZERJM2tFYXhT?=
 =?utf-8?B?VW1oK0FRdVB6elh5UG5KMHd5Sk9nQ2kzUkh2TmZJTnFmWm1jR2JqMTVKSVo4?=
 =?utf-8?B?aXNzR3VtVTMvZmZ3ZzByZTRMK2JwRlY5cGRzcEYwTm9zNUpkeVlWU0t5SHEx?=
 =?utf-8?B?WUVzOEdkSUJDRjRUK3RCNUZMS1JmTDVERUcrcmFJRG5EbWptZ0QyVUdDZEJr?=
 =?utf-8?B?UWw5U2JFOXhUUHNGYXQ0V0hpaU5idHpnNnUxUDA3MHhxR25wajJTVDE1ZlJm?=
 =?utf-8?B?aHFQOThZYzBiQlJnek95T2dsYXYxRERQdUlVMUVyWk1wSFUrbFMzRHkrWjcy?=
 =?utf-8?B?dUxuNkRya2R1SVZZUC9QUW03Q1hPLzlPZE1VZTdTaUxtdUcwaEYraFZ4TUVv?=
 =?utf-8?B?dUVhUlJiV09GVGdHaU1SQWhMbVIyK2hOTnpsZ3hweklIanh6NjhiQ3hXMnJo?=
 =?utf-8?B?YkxvY1FMSUUzS3ZkUm9meHZIbE1Bc3V6bzdkdzhPbC9xV2cxeFd5em52aUhL?=
 =?utf-8?B?NWs4cVpsUkZzY3l1NmZaYW9tUmJ6Tlp6WVBhdUd5TitTNG90VVZ6eFRrQ21M?=
 =?utf-8?B?Q3ZCZG9ESXgyWTF3aDFhcHVpc2JKdVZvWXFQVkVSZXNiQWZDbnR0RDZudko4?=
 =?utf-8?B?MDVDdGdoS0ROZDRxaXorY2RRTWE5NU5NWjVmdFhkZk9FVzVSRjlKMUp2QXZK?=
 =?utf-8?B?OHZKVUFhd0czbWQ2Z3hsdzR0cE5vTVg3Wi9xd2pTWTB3ODdTVjZnVFJaeFIx?=
 =?utf-8?B?SkdWU0gvQ3cyVU1ObVFIL3BIM1hOSEYyN3JCb0dsU0NTR1hab1RPQkl0dkVQ?=
 =?utf-8?B?ZDB1Q0JzSXR5bFlTRWpJbERKSnEvTUw1cllVY2NxV2JVZzNBM203UVlURTNC?=
 =?utf-8?B?L2FGLzNhYU0vMFhwMWlJcFJVb0docWczU1duOS8wUXoxYTlDQ0VhTTliV3ZJ?=
 =?utf-8?B?N2l1bXZOcS9QK05ibFJDc0paMnQwaDl6cXk2ZmNMamdZU2xNZEFHVkVzRFVJ?=
 =?utf-8?B?UXRYcHZ6UzZaRThrV2MzVkEyYi9QbGFudXZzZ1R2WmxHS1N3RFhaT1BGZU9q?=
 =?utf-8?B?S1A0N09ZVjh3bTZ5dXROMVo3TWRiSzNMTE1rSURqcnlxYUZUTFlFRC9CU1JU?=
 =?utf-8?B?TGp2Sk1semQxUDRNM3JlNzF6RUdOZFlrMnhSN3dBaTB6TjBRWWw1WWlJclp5?=
 =?utf-8?B?VWhTaXdMTWVkZktVTUVCVTljaWpkbnFlMmRHcVdNT1BOcVlIVWhiWmhORFN5?=
 =?utf-8?Q?eoemRXGElqxMCiCZIbFP9Ibny?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de676978-7ce9-49fa-1be0-08da677d1ffc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2022 22:47:13.2785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1piClGBMC6OiUleGA2Pl0gM5jMoo7VbusLHyejz8VzZ69WV+m/YiKC4sQUnzJFVs3Kr7ixdkIkW/71XvOxMCA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5541
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/15/22 7:06 PM, Rob Herring wrote:
> On Fri, 15 Jul 2022 17:59:10 -0400, Sean Anderson wrote:
>> This converts the MAC portion of the FMan MAC bindings to yaml.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> Reviewed-by: Rob Herring <robh@kernel.org>
>> ---
>>
>> Changes in v3:
>> - Incorporate some minor changes into the first FMan binding commit
>>
>> Changes in v2:
>> - New
>>
>>   .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
>>   .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
>>   2 files changed, 146 insertions(+), 127 deletions(-)
>>   create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
>>
> 
> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
> on your patch (DT_CHECKER_FLAGS is new in v5.13):
> 
> yamllint warnings/errors:
> 
> dtschema/dtc warnings/errors:
> /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.example.dtb: ethernet@e8000: 'phy-connection-type', 'phy-handle' do not match any of the regexes: 'pinctrl-[0-9]+'
> 	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
> 
> doc reference errors (make refcheckdocs):

What's the correct way to do this? I have '$ref: ethernet-controller.yaml#'
under allOf, but it doesn't seem to apply. IIRC this doesn't occur for actual dts files.

--Sean
