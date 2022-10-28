Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D78E611850
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 18:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbiJ1Qzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 12:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiJ1QzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 12:55:14 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140054.outbound.protection.outlook.com [40.107.14.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC192870C;
        Fri, 28 Oct 2022 09:55:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hC5p0aYep1Cjl9Tdo/qNS5NA7LZpNgeWxoUzBc4soOkl8UJPGYq9doBKLT4ovV5Z5D4EihRyzTwDQXebdEpu8tvAuFWVKDSzUBk9JK16aKlGh3X2vxTQPoXT1EqbzOJmiferdpzCRE/JvLs5I7kHZX3Bnc8Rx0HJl2k30Eb63TslYXIef15pxxLnVsTnu3c8tZ+gEvE0+QVZFBhipBy35qLccODhp6JYDpJEDmGCFNFwE9gWWRDxfGWfghU+E9TxxvFhhAE+hkAjjuzxa1rqxnq3URUNAQBsxa7NmvFtiWktKwpysqFSBzbZLSAbLXHVmdrS2Xn1CU5eSX7I/DQ1uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=35fCT2H9wtsDKsjz0cqEzaCFQMyiLrs1jLLIyUXbK0M=;
 b=fzxg0SPLtbkHOmAgXHy67RnQJTK5w2tVIIw8MnOfUcDzJ+ovYEUoOTb1Ny4uayISX6vflEs5AobxMmrn46EKZuFFhJ87oCBUSISWkUekuvAo8UHe0DkZzRh1htyFh4p8r3Xw7LwL0QYhbsQRwB4kmLMAWyFC5NJeGxs5DsbffbCeovLTiboN19H+vgkZj7/eNQHc382paDRECGI9tHpX41MOgLvx8n6mn7stMnPQwUnLk246bm9T4x3RjD3PNv2Vr2l33r5O/IBi4jwxmnrsGm8cvtMlJmjtUUvK7YBiBoz9WZt79K6AnxvPQocik7j5rMXg8fOe0mnMAdXaWdMSjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=35fCT2H9wtsDKsjz0cqEzaCFQMyiLrs1jLLIyUXbK0M=;
 b=CiQ8Njs5dp9Fzq9URjHE5HawKQg5df48DveUpNa7RUPMR2aSEcRZ1wjjkWAK3XFJ65XSoF+7ScT8kKP1SXbwt2R9ewv5gbrwv7GgETHr0iOz+KUx9IsA2uERDXxnkWED3Imh0Vpdxg3oRIXvyjbWV3gDPFEtjjNyUq1aowgGRWd80Hra39v+0Orq7hK6uFKtVy/btNySEaIlnuKShKGiDReQEwBxPZ7y/mk2cMf7BPITRp70b+tAQopzg/HxzeKjK4O+7yKN8lq57qIPXavjlUjsLssybWgg9RbdY9ibXmw3+fa33ogLopT7q44LUP6HkWY81UcRXVFaXpdXZ/igEg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS4PR03MB8180.eurprd03.prod.outlook.com (2603:10a6:20b:4e3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Fri, 28 Oct
 2022 16:55:04 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::9489:5192:ea65:b786%7]) with mapi id 15.20.5769.015; Fri, 28 Oct 2022
 16:55:04 +0000
Message-ID: <348c4b17-1e2a-cd30-b0e0-3a88c24aafec@seco.com>
Date:   Fri, 28 Oct 2022 12:54:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and MAC2
 as 10G
To:     Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
 <20221017202241.1741671-9-sean.anderson@seco.com>
 <VI1PR04MB580721D3F8DFC5C1BCAC6FC7F2329@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Language: en-US
In-Reply-To: <VI1PR04MB580721D3F8DFC5C1BCAC6FC7F2329@VI1PR04MB5807.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:207:3d::21) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS4PR03MB8180:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a1f0fdd-c6dd-49cc-cd1e-08dab90528a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p4PH3J3iAMhQoE2+0tIcSNnfmoYwy8sDo8o4D9B6DIaBaoJDdON34GOKbD7HQcf9ce43hLVCutOLnRk7HeAmTm5qlBZkyXVg3npoXCFRTKinJiowmDdRL4Voh2yA1R0z1BXwLt8j6ripWQfL48Y0XmBXFfwxKg8kTZ7G+egi6WDeYWnI/GV5NpolbLVecKx3BaaUBdJEQ5dNL0rghdIjxIPD9nY9jVjIKJDxrLTQTamZUFmzxTzvSmp5kNwBpzWCI4DTvz1pPVjF9d2p5XOXZNNalDrn3nFzdUurB7DgRAG8NdlQCFP3wobQOAKdSXQHVyRu8T7dx6+pPne7TnrTZsnKBxkuyKYF7R0gRkvUNtIG58S6HMa4FDxo8vRtXlk0isfmC44kZrtXQ6ZBznOk4PJ21JM1cGk4QctZPRLW6uhJxjjugT0E4zwUyj91sVQtI2uzXN8Nbq7oR1/f4UM6ur35WRa7gG+Vb5YP9pq+5gsPYnxa/xXIFLZ/yM17yg1kFduAUKSV+wVWC5zYHUI4m1zJDatWNGXZ+4PxmaoJmn3BYoniH/tJI4qzl9y0k/uC44ibklTEkCks0JYnf5GHbAvaXciXTbaaWfYyJt7ODDIyujRDBW4CR7ngQkjNKYkrcJOxbyak/dkdZUeFLBj3x2PWxOzKkMZHXlDNqu6tWk0CSlYKbl2MaTB5DuEj/Nww94IH+9DLexgeNAhiSeKVb7QLXQyFQ9qV0Q/hyAMjake1C5TpA89FBfDDE1/5iY1PTP6GJaPfvVxco+y8NPTb1+evOMnR2W3hzlLq+UniEIClVTdztCw3GSIk0v3PQ4gJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39850400004)(366004)(396003)(376002)(346002)(451199015)(26005)(41300700001)(8936002)(53546011)(66946007)(8676002)(66476007)(6506007)(4326008)(52116002)(66556008)(6512007)(31696002)(2906002)(86362001)(83380400001)(38100700002)(5660300002)(186003)(38350700002)(44832011)(2616005)(7416002)(36756003)(31686004)(478600001)(110136005)(54906003)(6486002)(6666004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1RuUnZXdGVqczNlelBZVEUrU0lXWnBxVzBhVFNVRzI3MWFVc1hJbGJmcFhw?=
 =?utf-8?B?T2VwQW9yVkYxQlkraHJ4cVJPWUJadjRZR0ZiMDUwYW5oaExJdXJ0ZjJuZEJy?=
 =?utf-8?B?RnMxeDR4N1JjUFdpVlZJeTAwK2tFUExNcVVwVFlzVkVNejQwVGxKMm4vQTBU?=
 =?utf-8?B?N1UxQjUvb1FkMUFJaXBMbzk3djBKYm9zQWxmUTVOTU9oN1J6QUtxMWNmd2Jm?=
 =?utf-8?B?czJzU2J1bUJvN3dhcFdVdkQwNk53ZmVqN3kwWVM5NGtya0pNVm1xMW5LUWNv?=
 =?utf-8?B?MmJSL1UzWjl1RGtYZVhlbzBxOUpvMGRTaGtXRmNQTDNDb0NLeTVmbmQ4WXo4?=
 =?utf-8?B?ZjF1Z2FhMGtGaHpuSE9pRFdKK2t1NFpUUmFuaWhvcEkyVy84Ui95VitPMXl1?=
 =?utf-8?B?SDJYTEk0ZEJOQ2dCd3JwNnJMRGhSa1N0bkJzN0hYSU9GUlE2Qk9yKzNBdEhK?=
 =?utf-8?B?YTQ3RWNzNWhlYUR6Tzg2RHZBWmNLRUo4dmk5aElhSmxWMmxUZXJIYzUwUG0v?=
 =?utf-8?B?aXl2NkQ1UmFkZ1FwYTRYSmNsN2FWeW44Tm9KWEFOWTNhOE44VWhaV1k3UlNZ?=
 =?utf-8?B?VHY4aC9jK25VZXFNQ2t4SXVqL1BwaHRYVUdvc3dESWk2ZXNVV0J5TFowQTU1?=
 =?utf-8?B?NkdrY0NPNDgzZ1Z4VjNkVHlxbmZscnM3UVZ6SkM5MjJPSmRmVHBlTnB3Vmtx?=
 =?utf-8?B?Q0dVWTdVWEtxcjZzRit6L1g0enpybjZIdDJFT3diWlNzV0RKL0REQVoxN2JI?=
 =?utf-8?B?dmR4TVQyK3FZWWhJZHhPWmZvbHNuRlpaUkoxWlZtT016WGFNUWw1TjlqVzQv?=
 =?utf-8?B?SVB2M09sM3JxOFN4MS94VUtxY05hMkw3YUxPTnY0czNyVllWK1hEVjFrK284?=
 =?utf-8?B?ZEVUZ2lTTFQ2dXBaVGNCeDhGcDJsNkM1VGNLUzNSZ0xZV0NIYXR2bkJOYUl1?=
 =?utf-8?B?azlrcHdZK0RjcnJhTUFZMUc4RHB0ZW5IcCs5Q0pyc2FtWGZOZ2oySGx2MEVh?=
 =?utf-8?B?WkhrVzlhMVVnUnRuRnZuRGNWZDdoRGYxUCtoTXdyS252S1REVUQ1S2ZRZEVh?=
 =?utf-8?B?ejZpbUZCSXRnTUdkNUxQNFN6VGlSK0hEdHFRdjJwWnRnM0dORUt2SWV5ZnhL?=
 =?utf-8?B?bmQ5cjJyQ1M1U3RWemZzeVIyMFNCZFVJYnE2emF6Q0hkZ1orN09XSWZkVEJN?=
 =?utf-8?B?MVRSTFhRZ29ZR0E2dU52THVGS2U4SmJ0ZWxDQm1zSlRYbm5SQklaN2hMS0xw?=
 =?utf-8?B?NnowNjNESk9xdEZJNnMySDYwa3Zsb1p1SXFSRFY4aGpwdXgxcVhyRU9OL2E4?=
 =?utf-8?B?NlI1S2duSTEyTm5NYXZEeEtSSjExN21lTjdsUnlsNjl6K0dzc2hXU2RRbkky?=
 =?utf-8?B?RGF0cVg3SlNqWTVyMkhwRDlTTDVwR1JRRFFkSStkdyttZEprcDRndkhEOXc1?=
 =?utf-8?B?WVQ0RGovODRxZ1Y5WG51THZndCt4ZWltbzhHVXhLL2VLNkVIZ09iNnkvZXRj?=
 =?utf-8?B?NWdqZkgxWW9ORkFBNHpNQmVkbmNtVzVYVDNQT3luQldFSVJlN3UzeGNMV1J3?=
 =?utf-8?B?TTZ2aFhSaVF6RlJBTEsrbkZqbTRWelE3L0ZXemRjQUkzZU5nSzRUa1haUDBW?=
 =?utf-8?B?cDcwUU9kb3owSDRCWGlJMWlYNWl1T0FjRmJ6YktLQ1lIWllSZExNY3FRM09x?=
 =?utf-8?B?MjBCWWpvOFhFRlkvTExXaVd6N2dzalVUallmNlFYZWZKTzdMR1c3MWRNVEJv?=
 =?utf-8?B?eXUzT0NleFh4emM3TTFHckRCY25TVVh5L3lIS3J6QzYzNElHRWtzckI3QSt2?=
 =?utf-8?B?Ym8zZWpnaWhEaTJ5K3Y1TEJEK0VZeEJyWlJiS0wrWUVGSEJvQW9XaVh4LzhC?=
 =?utf-8?B?YVQvYkJxY3RsU3BhQmNGM2NQejFFeGNCOG9wRndZcnErakkvQ2lNUUZBaHV6?=
 =?utf-8?B?ZGphelBQMEZ0KzFOa1BhU3kvMmZyV2QyQ2ErbkRQS2VPZk9pVjdwL1RrY3lX?=
 =?utf-8?B?WTJwUHNyWExrS1RYN3NtK1BaMU8xeFhFaEtDM0Y1MG1sUUVKM0ZoM1d2N20x?=
 =?utf-8?B?aFlGUEtHZnJLemkyKzRHRW1Pb2lTSXowd0RtSkIycTB6OUM3Ri9CMnB6RVkz?=
 =?utf-8?B?MlRaV0hqcGhJL3o5NGVWRUxOSlVtdmJsQkFQZmdJS2dlNjFOeDJsbVRDSTNq?=
 =?utf-8?B?N3c9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a1f0fdd-c6dd-49cc-cd1e-08dab90528a9
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2022 16:55:04.1569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zeVdau1SwpC3SsJAMUHMvgNfu6aAOv6rvKDaFK1vspsVwqko0vpu0ox/L1FxCg/68mo8jUwLmQz1vLdyMxpz4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR03MB8180
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/22 12:30, Camelia Alexandra Groza wrote:
>> -----Original Message-----
>> From: Sean Anderson <sean.anderson@seco.com>
>> Sent: Monday, October 17, 2022 23:23
>> To: David S . Miller <davem@davemloft.net>; Jakub Kicinski
>> <kuba@kernel.org>; Madalin Bucur <madalin.bucur@nxp.com>; Camelia
>> Alexandra Groza <camelia.groza@nxp.com>; netdev@vger.kernel.org
>> Cc: Eric Dumazet <edumazet@google.com>; linuxppc-dev @ lists . ozlabs .
>> org <linuxppc-dev@lists.ozlabs.org>; linux-arm-kernel@lists.infradead.org;
>> linux-kernel@vger.kernel.org; Russell King <linux@armlinux.org.uk>; Paolo
>> Abeni <pabeni@redhat.com>; Sean Anderson <sean.anderson@seco.com>;
>> Benjamin Herrenschmidt <benh@kernel.crashing.org>; Krzysztof Kozlowski
>> <krzysztof.kozlowski+dt@linaro.org>; Leo Li <leoyang.li@nxp.com>; Michael
>> Ellerman <mpe@ellerman.id.au>; Paul Mackerras <paulus@samba.org>; Rob
>> Herring <robh+dt@kernel.org>; devicetree@vger.kernel.org
>> Subject: [PATCH net-next v7 08/10] powerpc: dts: t208x: Mark MAC1 and
>> MAC2 as 10G
>>
>> On the T208X SoCs, MAC1 and MAC2 support XGMII. Add some new MAC
>> dtsi
>> fragments, and mark the QMAN ports as 10G.
>>
>> Fixes: da414bb923d9 ("powerpc/mpc85xx: Add FSL QorIQ DPAA FMan
>> support to the SoC device tree(s)")
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>> (no changes since v4)
>>
>> Changes in v4:
>> - New
> 
> Hi Sean,
> 
> These changes prevent MAC2 from probing on T2080RDB due to insufficient FMan hardware resources.
> 
> fsl-fman ffe400000.fman: set_num_of_tasks: Requested num_of_tasks and extra tasks pool for fm0 exceed total num_of_tasks.
> fsl_dpa: dpaa_eth_init_tx_port: fm_port_init failed
> fsl_dpa: probe of dpaa-ethernet.5 failed with error -11
> 
> The distribution of resources depends on the port type, and different FMan hardware revisions have different amounts of resources.
> 
> The current distribution of resources can be reconsidered, but this change should be reverted for now.

OK, so this patch does two things:

@@ -37,12 +11,14 @@
  		cell-index = <0x8>;
  		compatible = "fsl,fman-v3-port-rx";
  		reg = <0x88000 0x1000>;
+		fsl,fman-10g-port;
  	};
  
  	fman0_tx_0x28: port@a8000 {
  		cell-index = <0x28>;
  		compatible = "fsl,fman-v3-port-tx";
  		reg = <0xa8000 0x1000>;
+		fsl,fman-10g-port;
  	};
  
  	ethernet@e0000 {
@@ -52,7 +28,7 @@
  		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
  		ptp-timer = <&ptp_timer0>;
  		pcsphy-handle = <&pcsphy0>, <&pcsphy0>;
-		pcs-handle-names = "sgmii", "qsgmii";
+		pcs-handle-names = "sgmii", "xfi";
  	};
  
  	mdio@e1000 {

First, it marks the ports as 10g. I believe this is what's causing the
resource problems above. Second, it removes support for QSGMII and adds
support for XFI. This is a matter of correctness; these MACs really
don't support QSGMII, and do support XFI. As I understand it, you can
run a 10g port at 1g speeds, it just won't perform as well. So I think a
more minimal revert would be to delete the fsl,fman-10g-port properties
in t2081si-post.dtsi.

That said, is 10g even being used on these ports? I included this patch
in order to avoid breaking any existing users.

--Sean

> Regards,
> Camelia
> 
> 
>>   .../boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi     | 44 +++++++++++++++++++
>>   .../boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi     | 44 +++++++++++++++++++
>>   arch/powerpc/boot/dts/fsl/t2081si-post.dtsi   |  4 +-
>>   3 files changed, 90 insertions(+), 2 deletions(-)
>>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>>   create mode 100644 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>>
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> new file mode 100644
>> index 000000000000..437dab3fc017
>> --- /dev/null
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> +/*
>> + * QorIQ FMan v3 10g port #2 device tree stub [ controller @ offset
>> 0x400000 ]
>> + *
>> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> + */
>> +
>> +fman@400000 {
>> +	fman0_rx_0x08: port@88000 {
>> +		cell-index = <0x8>;
>> +		compatible = "fsl,fman-v3-port-rx";
>> +		reg = <0x88000 0x1000>;
>> +		fsl,fman-10g-port;
>> +	};
>> +
>> +	fman0_tx_0x28: port@a8000 {
>> +		cell-index = <0x28>;
>> +		compatible = "fsl,fman-v3-port-tx";
>> +		reg = <0xa8000 0x1000>;
>> +		fsl,fman-10g-port;
>> +	};
>> +
>> +	ethernet@e0000 {
>> +		cell-index = <0>;
>> +		compatible = "fsl,fman-memac";
>> +		reg = <0xe0000 0x1000>;
>> +		fsl,fman-ports = <&fman0_rx_0x08 &fman0_tx_0x28>;
>> +		ptp-timer = <&ptp_timer0>;
>> +		pcsphy-handle = <&pcsphy0>;
>> +	};
>> +
>> +	mdio@e1000 {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> +		reg = <0xe1000 0x1000>;
>> +		fsl,erratum-a011043; /* must ignore read errors */
>> +
>> +		pcsphy0: ethernet-phy@0 {
>> +			reg = <0x0>;
>> +		};
>> +	};
>> +};
>> diff --git a/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> new file mode 100644
>> index 000000000000..ad116b17850a
>> --- /dev/null
>> +++ b/arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi
>> @@ -0,0 +1,44 @@
>> +// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0-or-later
>> +/*
>> + * QorIQ FMan v3 10g port #3 device tree stub [ controller @ offset
>> 0x400000 ]
>> + *
>> + * Copyright 2022 Sean Anderson <sean.anderson@seco.com>
>> + * Copyright 2012 - 2015 Freescale Semiconductor Inc.
>> + */
>> +
>> +fman@400000 {
>> +	fman0_rx_0x09: port@89000 {
>> +		cell-index = <0x9>;
>> +		compatible = "fsl,fman-v3-port-rx";
>> +		reg = <0x89000 0x1000>;
>> +		fsl,fman-10g-port;
>> +	};
>> +
>> +	fman0_tx_0x29: port@a9000 {
>> +		cell-index = <0x29>;
>> +		compatible = "fsl,fman-v3-port-tx";
>> +		reg = <0xa9000 0x1000>;
>> +		fsl,fman-10g-port;
>> +	};
>> +
>> +	ethernet@e2000 {
>> +		cell-index = <1>;
>> +		compatible = "fsl,fman-memac";
>> +		reg = <0xe2000 0x1000>;
>> +		fsl,fman-ports = <&fman0_rx_0x09 &fman0_tx_0x29>;
>> +		ptp-timer = <&ptp_timer0>;
>> +		pcsphy-handle = <&pcsphy1>;
>> +	};
>> +
>> +	mdio@e3000 {
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +		compatible = "fsl,fman-memac-mdio", "fsl,fman-xmdio";
>> +		reg = <0xe3000 0x1000>;
>> +		fsl,erratum-a011043; /* must ignore read errors */
>> +
>> +		pcsphy1: ethernet-phy@0 {
>> +			reg = <0x0>;
>> +		};
>> +	};
>> +};
>> diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> index ecbb447920bc..74e17e134387 100644
>> --- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> +++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
>> @@ -609,8 +609,8 @@ usb1: usb@211000 {
>>   /include/ "qoriq-bman1.dtsi"
>>
>>   /include/ "qoriq-fman3-0.dtsi"
>> -/include/ "qoriq-fman3-0-1g-0.dtsi"
>> -/include/ "qoriq-fman3-0-1g-1.dtsi"
>> +/include/ "qoriq-fman3-0-10g-2.dtsi"
>> +/include/ "qoriq-fman3-0-10g-3.dtsi"
>>   /include/ "qoriq-fman3-0-1g-2.dtsi"
>>   /include/ "qoriq-fman3-0-1g-3.dtsi"
>>   /include/ "qoriq-fman3-0-1g-4.dtsi"
>> --
>> 2.35.1.1320.gc452695387.dirty
> 

