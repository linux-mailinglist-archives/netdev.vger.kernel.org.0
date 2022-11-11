Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 706FD625CDD
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 15:22:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234355AbiKKOWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 09:22:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234397AbiKKOWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 09:22:32 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC177E58
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 06:18:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gJ2L+2qzwinq/7x9iJJ+0XMuPbyl6QgevTu5fcCRI/PfiE8MpuwLTxo6gPSZikvROXrcL1eztiacp78AbGQucYBt95eU9Q6m0KXWFxmCR6IMgOjj8afhAu5yEFA5C9xmCTLt4NmK9sCD18ch5wcLHPY5o48Rou53HdHnPN2LupnQF2OW5ChviLB2kEa6SuVHx8rPnzhJe0BS2N4GG9ZKNkCAOvisZK+OR8yFGOGTkuQaHmPlZxfMoPylZl54BO1fZ0U7orKdd9SDhZZILoyYKPTAIDaxTwflVADYcbGfOJnxri/5WmzpZeFv6lz4JpnSeHGBau/KpwpK+0cikBF7/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCDeghhatpJEU2Wr9Hp+3MTkGX6jEdLWjXE0qolLaqE=;
 b=OHtaPpwjIyqNKgYVJ7N1euhhmYvBLxBQLBe45xldl4acwn8WXY4orUULMQis/eX26zZTks4kJdpFzsORzv4wuk+QuRDGw89yV8SNrVVKLMze+otNdPV72DQWBs+42m3gQxmWqvmD8V0lv3vJmctiR4NyREBq6gn3xvVoY21KBn9qX+Kb+n72WIi8TfK8rfvBVx2Zc9fx7VIikYSWwLShQf6vExetAgZ2Q+P6B8g9+yn5GFKeOJVWulzeWxuX389zQVsHe2mwzrJxi5DKrfhrvEw04vLfDfDS1ZPT0Od49Cmr2X1LT2RikJpLPsQJRb69nof23iutkjYAlK8NCKaeqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCDeghhatpJEU2Wr9Hp+3MTkGX6jEdLWjXE0qolLaqE=;
 b=cOguf9Xy6O8mOkc0HBkCHajmgZNYxRvZX+2baV2KMnP9HdPYFE4ZzB923Q8yXmYwbZGH1AN6LOhcjumkbqXE+l1JLv82rI3mb69xTJ1vkfqGfM4F/tHUvNNtUtcLp7/rs5HknVzBsHipum0HkhcIY8u8sscoEUWPxxdc38OrJj4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM6PR12MB4497.namprd12.prod.outlook.com (2603:10b6:5:2a5::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 14:18:02 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::4da8:e3eb:20eb:f00%2]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 14:18:02 +0000
Message-ID: <b2dedffc-a740-ed01-b1d4-665c53537a08@amd.com>
Date:   Fri, 11 Nov 2022 08:18:00 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH v2 net 1/1] amd-xgbe: fix active cable
To:     Thomas Kupper <thomas@kupper.org>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Raju Rangoju <Raju.Rangoju@amd.com>
References: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
Content-Language: en-US
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <b65b029d-c6c4-000f-dc9d-2b5cabad3a5c@kupper.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0114.namprd04.prod.outlook.com
 (2603:10b6:806:122::29) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5229:EE_|DM6PR12MB4497:EE_
X-MS-Office365-Filtering-Correlation-Id: c98c75dc-f518-44d6-8f6a-08dac3ef8b23
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1xSjMzHLNFZqF2iroDf/88vG27aqfBySKW8C0+iw3FGd0pr/7tiEfxP94yO1IKeqwAPw0TNLQri8DCGorktcvULDrNGoZI4/hFSYMmeRnPMetXgB8RrCz3TMnoKeZWFblOCgJmDaNyVvpcgugnT7gownm+tkxNU7b7FF1CY/Ht4/1fjWys6jjLS8+l4ig14m2UnJnRiMNkHzVxAUkKNnPOaNYOQSD9yG63YKTHevuG7ITIQCmY6Jcf6or0fasR7zgj2LtEuWHYRfSXYGBKheha2VBH0lSZOr6NSriFmJ4EKp5L6xrcpyX/d90D5xat5DElfbD0WS4e+GP2dhVzR4DTv5GyMVRsAW3mYjBqx/YZJZ9e09Mv+xddbJs7SqvQJ42LnV2IPKy9dW8OI7brev7rHUlFObzudB9Ckbpz5+CjILW3xcms+0pbeVmhGux1V/WKWVJCXbHrkOXuSji77B04I0RNEx9J7AuOHKSBLKxZiV1+3lyznr9qtgAC3ulM69Y8e4cxfVWyL2+kUo3o/pwls7nvgaFMw9GD6oopxH2iGJk+BD49NdxZqglXYow0o9QOFmTqtqsXn+3VROMBE49U2ZPM/E2IxxJoj4JveAkFosZACXK7SImo0HzUP3cDPNq471Kxqw7S9UhWCESUd1BhEsgWIx3qK9pSfZ09CeKXhJb7vSf+bQnj3+rOf+SlNizysJ4uBAqXaxH1ElK9RRYhLDr/7yqjAnzjD0znOM3AcUfnfcOuzm3W1MXJ7vUJjj1tKZl9X28ZaipenbtJWSaGL92bW36ApaAaiKfAth+Qs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199015)(83380400001)(6486002)(8936002)(478600001)(41300700001)(5660300002)(2906002)(186003)(6506007)(316002)(38100700002)(4326008)(66476007)(8676002)(6512007)(36756003)(31686004)(26005)(86362001)(2616005)(66946007)(66556008)(31696002)(54906003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Q2crSUszT01ldEJjUkpVNkhXaGk5eGE4VkFtYmZEUC90cjRGOUxKZ1VCS3R3?=
 =?utf-8?B?cFhFTkJIRWozM0xrbVZLaVU0UkNPWnJvQmx6dXl3bjRHRWh5aWt1bndqYmVy?=
 =?utf-8?B?N3RSaHR2eU1wT3ZVQThWSWpaSEZNQlVCR2UzQTZ5bHhWSU9TOWhRb0lRWW1K?=
 =?utf-8?B?U1p5Z2NvV09QSWxidVlVUHl5d0prM2VKeER2bnpWUEIwTDREVDE5N21jdC9K?=
 =?utf-8?B?UWhxbEtSN1B1U3U1R0NLMEZRY1VWVzlxR1l1bEdKcktLVmQyMXdGVVlQYUd1?=
 =?utf-8?B?SjN4L1FFQkJ4SkNpNXZLVzRNbWpZQm5EaGRaN2VRNmwwZkhWQnlqNDI1bVdn?=
 =?utf-8?B?V2pITUxYMTVoemYzanVvV0pabDBKbE8yM05lVW43VkNhWW9iTjNNdkM4cTFh?=
 =?utf-8?B?aWU1dVRuZ3BpNThyQzJEeXJXcC9TaHFoSlJ0a3NyR1VrUm9YazY3TWh5WSsx?=
 =?utf-8?B?ZDRZSXQ4V3AzZTBPQ202VGdVYm1wWEZPSWNibWEyWXVYQXVubkFUdUt4L0xp?=
 =?utf-8?B?N2VtUU5ta29OOC8yekVodjBDTjFVUnIreWt4VXBKWVNGZU4wSzlUNmhuQ0Jv?=
 =?utf-8?B?cmJ0aWxrZHd1RVo1VjV0VUU2VVBaeC9xQ0FCb244NmlnMlVKRVZZZ0laWDdY?=
 =?utf-8?B?bDFHRTBXQk9VN2dxZTRTZENMcnNGcmZmaDJPTDZiWG5PNDVRd1RSM05USzlV?=
 =?utf-8?B?QUZ1M3A5MDUxdlZ4VFc5VStnRnF2SG9zbVJqOUZWcXlkK3FocjFmTzZXOWYx?=
 =?utf-8?B?MUxBY29ZcEJLcW03a0ViaUoxbS9KYS9zdFFwaVNGejRqbksvZ0U4Tzdodnds?=
 =?utf-8?B?V0pVTGtRamh4YlVMSXNNU1o2N0NVWHZpbE5VY1p6VVRlK08wNGtXSmN0YnBF?=
 =?utf-8?B?em5ibkVWK1RJbDNOcFVuRHJXT0NPL3k1N25MNmtaVDloQlZoaUZtV0lLcTNI?=
 =?utf-8?B?aVVGNXFiRHNzaDU2b0tQRUx1UnNSR1hlOWlTSjVWL2hpT0dVMCtoMGpzWUlD?=
 =?utf-8?B?Vm5BS1NTWlVWcWpWZEFVRmRBK256NnNaWS90R01EVS92c3BaOURkaUxTaVJO?=
 =?utf-8?B?S0RvVWhUSEUzMXloRWFlYk1tTkpXekozUHJrSjNPdWJhQ01NZXhLUC9kMnFJ?=
 =?utf-8?B?Q0Y5eGx5d1RIYmtyWGtpUDh5UlFRbGNXWXhtTzFZZzk0UEFQRUo4TTRUSXRp?=
 =?utf-8?B?aHIxVUdqbmhxdkRtTTh2Z0QzallNZDlNM21JN2JieVY5S2NJRXR0NGtibUxK?=
 =?utf-8?B?dDFTSzYzM1VsU1cwVHNjSEM0RmdSTzRlVlA0ZzRrTDZyYzNzZnRXWUlVdnNG?=
 =?utf-8?B?MXE2Vk1XeGhMbUVFc0duaGJwSGE2Q3kzN2Z2bUdJOTZsYWduNEdlWE9NczEr?=
 =?utf-8?B?Zk0vOE14MC9sL1hYOVNvUWNmajRJN0ltN0lPWFQ2Z1NUWFdTTWdlMHc2Nm9O?=
 =?utf-8?B?b1dxQlA4bG9MUUE2Um1wUTFOMGpSdXlRMkhYOEhEQ2t0RUhtV2IyOG93U3ZJ?=
 =?utf-8?B?WlB3VHA3cGQwUkdSSVdPczM4SnowUWRBLzY3VVNwWFJxVTRGK242MHFDcjRH?=
 =?utf-8?B?TDR2TkREV240VEh0eEhRVmh0d2k4T3VWRFIxN0Z2cEh5emdDVzlBM0hwbTNa?=
 =?utf-8?B?OEpFMVZJdDJydUhRREtmdzlHYkg2RnZlekZ2eHFRY3d3SVZCMWR2dCtPRjFp?=
 =?utf-8?B?UkczaDNBZlg0Q2NFYzk4cVdJdnJNaHZIVlMrdFBWRzJNU3U4NmI2c2lLbmlF?=
 =?utf-8?B?biszNlFCYzdmNFBmZzM3MXRMbnpwSE5PckZlQnQ0VHkyekk1ZVoxTDhwU3RZ?=
 =?utf-8?B?Q0Nza1I5RytNV00xNWlSdVZnampGNFNOMlkvYVFhZEZ1eWdrSEpudkZmbU44?=
 =?utf-8?B?UHEzdk51Y1JPZDd6TGhTSm5NVCtCQ1dzSzlLSjRUaHFOU3JIMm1qVDZVYjQ0?=
 =?utf-8?B?c1l0OUVCT2pWY0NYeXlxWjlMTzFpY0d1SWhEdWtmSTFIQytBNE1IZ1luMTl3?=
 =?utf-8?B?SkdCNFlkb1l0SE9LeVEyRlhkN2d6N21DaGZMYmQ0ajk3UWJITCtrREFNVitC?=
 =?utf-8?B?cC9aN0JmcVFZaWhaWWVsRVJXeldXNjhWN1JUdXA3dWVCSXRGVFhxaVFDKzd5?=
 =?utf-8?Q?5rO8zSzrW4APY6TgD4S7B8POQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98c75dc-f518-44d6-8f6a-08dac3ef8b23
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2022 14:18:02.7028
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DffbQwCuiuGkeLZw3pYs/2w/xhvFdsMWZQyrwlEytGh4oCBPiV9m4JVaBj5o3XzFIj1haZV2mK+Zwxg7Yys7oQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4497
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/22 02:46, Thomas Kupper wrote:
> When determine the type of SFP, active cables were not handled.
> 
> Add the check for active cables as an extension to the passive cable check.

Is this fixing a particular problem? What SFP is this failing for? A more 
descriptive commit message would be good.

Also, since an active cable is supposed to be advertising it's 
capabilities in the eeprom, maybe this gets fixed via a quirk and not a 
general check this field.

> 
> Fixes: abf0a1c2b26a ("amd-xgbe: Add support for SFP+ modules")
> Signed-off-by: Thomas Kupper <thomas.kupper@gmail.com>
> ---
>   drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c 
> b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> index 4064c3e3dd49..1ba550d5c52d 100644
> --- a/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> +++ b/drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c
> @@ -1158,8 +1158,9 @@ static void xgbe_phy_sfp_parse_eeprom(struct 
> xgbe_prv_data *pdata)
>       }
> 
>       /* Determine the type of SFP */
> -    if (phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE &&
> -        xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))
> +    if ((phy_data->sfp_cable == XGBE_SFP_CABLE_PASSIVE ||
> +         phy_data->sfp_cable == XGBE_SFP_CABLE_ACTIVE) &&
> +         xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))

This is just the same as saying:

	if (xgbe_phy_sfp_bit_rate(sfp_eeprom, XGBE_SFP_SPEED_10000))

since the sfp_cable value is either PASSIVE or ACTIVE.

I'm not sure I like fixing whatever issue you have in this way, though. If 
anything, I would prefer this to be a last case scenario and be placed at 
the end of the if-then-else block. But it may come down to applying a 
quirk for your situation.

Thanks,
Tom

>           phy_data->sfp_base = XGBE_SFP_BASE_10000_CR;
>       else if (sfp_base[XGBE_SFP_BASE_10GBE_CC] & XGBE_SFP_BASE_10GBE_CC_SR)
>           phy_data->sfp_base = XGBE_SFP_BASE_10000_SR;
> -- 
> 2.34.1
> 
