Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD8681AB5
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 20:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237948AbjA3ToA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 14:44:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234818AbjA3Tn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 14:43:59 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2064.outbound.protection.outlook.com [40.107.21.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77008C163
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 11:43:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FIL5boR4+Qil/Nuw3XX8WUZAmoPtXmn+jCFHA8NeSMY8SgxYxeU3ouaA0j0TYi+dTTUz32D4nX9lKxpkGgDSAtjExZq+hPgQYeXA8M51IdoPtDzRtnVFGnj9EUxZuXjHt2ofJrMKIHMdLmsUKv2S6V2/dD6i2gSos1zwV9+oZJT/ruFJN7utQxFmAwpVo9YQ6p1ZMN9eGzZFEnqC4lmmLM7TDxmY4LVbLzcpvuAfYu4D/anUuKydkJe6WssNvp6wm9yJHijf274XBwUwbVOBZISw41+3lVV4v5VmUsMq0v+FTn0DmN31JH21CtY8v7jdiwCWTwP06vN9aEfvlIgbJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsywG8Em7jsvB4LD9Rb45rgBwkqfpJR2/Tco/sByuig=;
 b=ISkaKJtR8IrflWjnjqr5yeS1cnWJTRTpmAHCRBl+BQwYHUElYtKhP2jR63FRRldUf2+ZkkUd5e/2cLX7D0SOML3smC+vJnW/GXfbhCqjKidZeL2Inx949XfxPrg7ppkFrxO0ciT44ZMlx7o3kCEG9TNBNLdw0ipKUj27SVitZcg/N8l0CHL8lgfNGeJfJdv/O5lfnR4nBQtb8O9NVCFkft8Drk3Cw59Fcgx6EnSpc7Qz9xueTk8pkiGpC3Mc2wXhppsfFeCVBzj+0boH1PHfLQF0I+VkJlEW2fCyST1e6pU7RYIEyaerkmEOighwnvqcJtnFcK70yi9Z7v4WKm8jDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsywG8Em7jsvB4LD9Rb45rgBwkqfpJR2/Tco/sByuig=;
 b=y741ISfjxf3x6HdFz/s6/VY4bnpCRr9DVKyHohsCUZrTjIbL8QBiRTA+oN+XMmcGTqWgmvLnof6TRPnnA5EJonHCQIcfKhZPqn8Bbgbich3JIe284ziyOO+kc24LB+W+iRiHimdv6m/rTwGxthq00Dl4AXlV22YgtWFgFW/Yw5r3O7EhyxbH69LagtdPksz0eJZfTfjhuEn2SqkbXzp0Zu77JsIIgUgX2jE5e56I+w8rRZdx0olIXPwsIUhPHcmITK0WYCMT7VBeIKoEtpXvuwvr4LSOePHdatSKVLT3AyIDdMMCXb3i+NlT/Qo7Ciegh+v/ok2ZnDjxtZoQ/aymbw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com (2603:10a6:10:3dd::13)
 by DU0PR03MB9149.eurprd03.prod.outlook.com (2603:10a6:10:465::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 19:43:54 +0000
Received: from DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166]) by DB9PR03MB8847.eurprd03.prod.outlook.com
 ([fe80::6b03:ac16:24b5:9166%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 19:43:54 +0000
Message-ID: <e4ab1950-a209-1748-7bee-c24d862800c5@seco.com>
Date:   Mon, 30 Jan 2023 14:43:50 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net] net: fman: memac: free mdio device if
 lynx_pcs_create() fails
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
References: <20230130193051.563315-1-vladimir.oltean@nxp.com>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20230130193051.563315-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:208:91::20) To DB9PR03MB8847.eurprd03.prod.outlook.com
 (2603:10a6:10:3dd::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR03MB8847:EE_|DU0PR03MB9149:EE_
X-MS-Office365-Filtering-Correlation-Id: eb3f5fca-f05c-40f8-93d2-08db02fa51f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nvm6kRr+MRps7X8hDAhmwXw4DNwEhJJnhhbj6YvNyQ1xhWhbkN7Ah8CopBGhjqNS2KlyyOQaYmYgI4dglrLBquOtKaAQSuANsK2rxL9cVPKSlAW3JQLeVojG+HYIX7Eyk726rPMhbuY9tAlvA5oPSt3INBoZfpeIxTA1XTBkfBzV0LrcQap6tVvcUIqWaO0wSL5zI34Lb3PO5YSs3gErx7w0vTtz/DdNZMmKhQrp5TTsfmC7DvAo+iEgVmhdooIbiyW95Rmtg6iUNMf4quSUl4v8opxBEeBv1AQee2vGDIGm+jp+jnuo6tWajz5ifVnWkg9wmzKYOpzrVmdrZ7bI7WveAeWnTSzRke7EG1sDafMUvF01QkBUSJza9/TI43k6R0eNJy03ePCTOZK3SXcEqcNkkQNN6ZlIL8dD9VBVrgZMTE5wkk6/o/OTXLixXbd4oHSOrGWZ3mbjmWmrRXR/nxnRvTZbvlVDM4dRvh/VsvUclp5f3IVURNYwnTqSftw5lRnzDB6mvyso4YGZuN0d1ylBawT9a8cSOK8iHLykIXUVF3AaIVORRxdWdte1nWHEotPwoQ3bV9W6La9P5FRqwX9orvXhSSokFBXb7H3M5TUYU6M45CjnEezdbt+5hzh1Fc+9lJ5Bk0kKwGnQ7O8C3uJUjKs5F2a/gqFXztmiV9MGvdHwQ0RRI1wH1iYW8W4IkD8Rjt5JIrtYIsQ5F2zOFOQ6AgvSzCgHSmcVJ6FVfWuZ5J3RVATGTqjuE2XfM9q83IWfeQUyMfZ4vu4Nin8bRw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR03MB8847.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39850400004)(396003)(136003)(366004)(376002)(346002)(451199018)(31686004)(83380400001)(52116002)(36756003)(86362001)(31696002)(8676002)(38100700002)(38350700002)(186003)(2616005)(6512007)(26005)(44832011)(5660300002)(6506007)(6486002)(316002)(53546011)(478600001)(66556008)(54906003)(6666004)(66476007)(66946007)(41300700001)(8936002)(4326008)(2906002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UkpXM01BeFNvZWNDSEp2NUwwS0VmZTQveDRyVU11VVRQT1VBekFtVzZIdVlz?=
 =?utf-8?B?akgyWE5NWVBVWTAxOEhBZ2JFUmRUN0ZiTDZkc016TlV4dXExM3h6ZHc5bmpN?=
 =?utf-8?B?dThmaDVTbnhQU25TbGZZdjhqWGMwUUNUaDVWNmZlNHBKaFVpdlVXaWNnZUNw?=
 =?utf-8?B?QVNrT3FGRGVqbzlTSVBwYm8zRVZMdGc1K3lDb3RsRWdrRVp0VlZOWGN2ZXpQ?=
 =?utf-8?B?RkloTCtOU0tBeHJTN05tUC9TZjhDUjVsVkR4YWJkSWpIcFVzVXd6bVZqdEtp?=
 =?utf-8?B?dyt3Rk1SK01xWldVOCtMR0h4NFN5YjJ1TVB5ZGljU3FnSndDcEV6TmdpTlFt?=
 =?utf-8?B?a0RRY2NDcFRMcHZMaWdwdWlrTGZXbFE1NWNrY282aGRRL0tid3lzTG1WQVZy?=
 =?utf-8?B?RzFNUFhYWFVST0VVUjJQWEpmcll6ejU3WFR1aWpxMmxpWFArdXNVYWdNQS9O?=
 =?utf-8?B?UzJiRTVDM0VERW5zQ3IzTnJNUFgzNnZKTkZOSTJib0NYeExPa1dkcEhtZVRX?=
 =?utf-8?B?UUwwZVhCNlZjSit6N2NBVU5IcnE2T0N3dG5PSDBYYjg3YlpWNDlYWXpZd2d4?=
 =?utf-8?B?Nm5uWlgrU3RjWlY1d3NhWUNuNWRweVh6QmFWbHRXd3BicmNoWHhDWjNSZFlF?=
 =?utf-8?B?cFVzcUpheUJua1VHekJkRkV3TjV3azNmd0R1OVU3OTVVRVFheXk4djZaN2wz?=
 =?utf-8?B?S2g2eW5FYzJvM3JVYTdhcnBJa2xmZ21mV2h5eXpGN01FZzgwdWh1UlAxMEVH?=
 =?utf-8?B?clVSdTBpb2lqcEwrdmpRa2didXVtMy8xMFdpbDA2dG54VG1NT0xaeUVheWJx?=
 =?utf-8?B?UjNOZUxSak1La09wbUVsV21nNEU5Z1R6TUpUUENnQjZZeGdNZFR0UWtaSC9V?=
 =?utf-8?B?a2FHRGVTcTU5b3dQY1VyUFIzdUdxMXNycEZNSE5HYXFTbEx3dnhIQlczTS81?=
 =?utf-8?B?YW9vOW1RYnd1OWM4Tk5UOUZmcnd2eCtoMWN5bDhXdWo2U2FKNnJWK016MS8x?=
 =?utf-8?B?Y1NVbkFuMVRHNE84ZFRmWHNmdkdJeVVWSFlScjY1YThwcU9RU1V5TFgvek1u?=
 =?utf-8?B?OXBpN1pTSytQeTVEbCtvVW9WTDdEOGUvVldiN1dOSG9RZUdDVzdySU1nY3BD?=
 =?utf-8?B?VGtqczI4eGdRSEkrS213UGpiQUFiSUVHS0NHWFJ4and5Ykp1eDJYdEx0R0RH?=
 =?utf-8?B?TkR2UjVnRHViSHJLbVdJak9OQk5NNnBaZEpaVXJjVVNlQnNmd2ZRZVRTSUdq?=
 =?utf-8?B?QWQzaUY5UC9TVWxpRVFtdktIcFQ2YjZUUlkrSW0xY21DOFZJNnB3MnB0a3pj?=
 =?utf-8?B?cC9Dd0Y5OERYMisraHZxWEVxell4eUw1Zm9WZ2RYM2NhdWdqQ0s0UGJTaVdR?=
 =?utf-8?B?Zlc3TW9RbmJHNTFqaDZBSXQwYTEzN3QrZm5remNJREhSSFJ3WTNQb0JaOGZz?=
 =?utf-8?B?eXNhQ1U1T2E1S2J4eXJYeHdRZC9lcUpkeTQwMXRuWWNiMTgrclV0N1BjVVNT?=
 =?utf-8?B?YlFTNXlXaHBBV1dzMXN5V1gwRGR1dVVGSHVWb1lHbmJBTDdLcjYzMjJPbE51?=
 =?utf-8?B?eUhvMXVtVFFUMHZNc09IVGM3TWx2a3loYUpBbzdmczQ0WnMxbXdCMzdZU2Rk?=
 =?utf-8?B?dVhsMW0rN2ZzeWRNQmJoZzFqTitYSlJpWTR4aEFWRk93VnlhdjQ3alJ5SXN4?=
 =?utf-8?B?TnM0akpQQ1h2OGg0eENmaDkzcDZWNFpUdXZheVJTam42ZzlzRmpJUDFMREJr?=
 =?utf-8?B?SU1QYzcwYTFrK1lYYjZ2aXdQR0NjWDlBeE56QUovOWNVUFJRUGUwbFUrL2xr?=
 =?utf-8?B?TjBLM05Zbk5Ody9qTFk1MmZMSUpDYm1nK2JoYk5MNkkxa013UE04R0FoZEdZ?=
 =?utf-8?B?V3FQTjNYYTEyMmFFY0FwdEpXb1JJMFdidklYa014S1hmOVcwOVRpaVczdXF1?=
 =?utf-8?B?eTNJaHI0cCt1U29adlBkN2VxWXlPZmRZYTAyUyttTzBNb0N5dHp5bzcyN0o2?=
 =?utf-8?B?clZMcGdmNEN5TzlGL0dDaFREVGk1OW1CT3pqWHkzdTVEcUFyR1FiVUlOT0x1?=
 =?utf-8?B?Sm9OMTc0Z3dwbEQ3Qk9HYkdDYWpkMUxiZmp0dVVkNXFmUjZqMHpkb2s1SW9p?=
 =?utf-8?B?QzB2OXd2aUVtK3dMK2ZpWmZZc0xyK2ZmaWtSelBqdUQvd2xIS1RoYVpKSjJn?=
 =?utf-8?B?M1E9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb3f5fca-f05c-40f8-93d2-08db02fa51f1
X-MS-Exchange-CrossTenant-AuthSource: DB9PR03MB8847.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 19:43:54.4641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HjRfaxSkDotbiw1t4S6BS3l9HYt7y4KceiFdo7iPLdHgMebh6uVAQs55uyTYWlTNsayBVVhM77knz4eDFYf55g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB9149
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 14:30, Vladimir Oltean wrote:
> When memory allocation fails in lynx_pcs_create() and it returns NULL,
> there remains a dangling reference to the mdiodev returned by
> of_mdio_find_device() which is leaked as soon as memac_pcs_create()
> returns empty-handed.
> 
> Fixes: a7c2a32e7f22 ("net: fman: memac: Use lynx pcs driver")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/fman/fman_memac.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
> index 9349f841bd06..587ad81a2dc3 100644
> --- a/drivers/net/ethernet/freescale/fman/fman_memac.c
> +++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
> @@ -1055,6 +1055,9 @@ static struct phylink_pcs *memac_pcs_create(struct device_node *mac_node,
>  		return ERR_PTR(-EPROBE_DEFER);
>  
>  	pcs = lynx_pcs_create(mdiodev);
> +	if (!pcs)
> +		mdio_device_free(mdiodev);
> +
>  	return pcs;
>  }
>  

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
