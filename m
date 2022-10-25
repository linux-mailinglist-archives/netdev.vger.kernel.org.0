Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADE3260D43F
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 20:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJYS4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 14:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230245AbiJYS4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 14:56:35 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2083.outbound.protection.outlook.com [40.107.104.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B8F513F2F
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 11:56:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3tfcpa/wF4hk/cgN5jsvox4d5inoJMNp4gO9OygFyA+DNK2iWBI2ywwOYLIbLgss9cZ4VjOXjTUoO4ox1msnKof1UHn8QpFsOPsxCSmGHNFuSwkBzeJ5+JHtfLkhp6/MkGOSt3I9FRK3sVMX0EGBcIV2UtlxCd/mKRWmC4CEiSssDgKO9loc06Aa5IdwagRMIHZoPd5EpNySDv7UQmzIzC5ADzenKLCDVI7UUB5JDhKd6fghuJGiTFA0e+OVAdAATItN3ql5JxHTBm+FrafpPdRnKHSviW0yHxHwxa9Q/b0UKe0ZkQ8girhwTT3ArAJkjM2EtLkCHxZVhK+PoPiQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JUUbEvqVp6FcoKDN/nfOKH/787G15SunYhZ3RB0nul0=;
 b=HaaiFOGqJgy3NzjvL6MJr8qdgFbPRoGJ6De3lu2RPFhk7GbHUXgyREq/mwJsERonR0pWGLk/Xq+UzdOeBCtw6ZkgTD/u69MlAuMw2aO32HZSuotqSsAbLjT/rjrTG5KkkHx86O4BgZxFklpcXp9bsTfA3ShZlhmSU2h6FXImPdAjV1mpLL74z6j4oHkIhSxrF1zsroRxMNuS9AEgntUzcSnTSzK0Qw89WX/6UYKUj+GV0mUTxGZP3IyCF588JtRsJiSMbL7lDpAtoATjaFaegYoEktwwlmLrGDJcKJorMzPVCNUca7Vwqv4QUCx9ZkgyBw2ljn7pHMgcHZ0cqXRC+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JUUbEvqVp6FcoKDN/nfOKH/787G15SunYhZ3RB0nul0=;
 b=XheeCSDW0tHM2pz9oZy48eUsOlWieclUdLX5ko0uzMPcpEzcD+nf50TaMn5QTNmvHMpuRCoM8XBtc/dADXzjj+paajlO0zU4xZXq013DU4hTvQg8OW7LQoqZDLYhfm9VLZGtAPFDaNgyPiQk0hxlzQHS8iKm+qiWUuRsPn/9FBvXHyYjUzw2OEeYaxieIALFBQVX8BKWPLjUctr9P49cAM7ZG50p4lnVCr2lh9aRyN8RawyrsdmUShaNo1Y1zOPgh+umUOGTSI0JxiZ9UK4RCR4U75zeOTllkAxm7W/3uY/NwklcteYdHFJv+91mQE6lk2Q31jt05U+lyt4wo4BQSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DU2PR03MB7958.eurprd03.prod.outlook.com (2603:10a6:10:2d9::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Tue, 25 Oct
 2022 18:56:29 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::447d:3157:60b0:ded8]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::447d:3157:60b0:ded8%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 18:56:29 +0000
Message-ID: <d89c52a3-8f2b-e8a2-b15b-3b702913787c@seco.com>
Date:   Tue, 25 Oct 2022 14:56:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH net-next] phylink: require valid state argument to
 phylink_validate_mask_caps()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux@armlinux.org.uk, andrew@lunn.ch, hkallweit1@gmail.com,
        rmk+kernel@armlinux.org.uk
References: <20221025185126.1720553-1-kuba@kernel.org>
From:   Sean Anderson <sean.anderson@seco.com>
In-Reply-To: <20221025185126.1720553-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR03CA0026.namprd03.prod.outlook.com
 (2603:10b6:208:2d::39) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DU2PR03MB7958:EE_
X-MS-Office365-Filtering-Correlation-Id: 65062f38-f9b1-4673-64a7-08dab6baa042
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A+9973LHgIwlv369R2HU2L3A4qM4IOBJ8ZmRcjCVODoGRR6ldZjYsNGffHjSSVhxmUW1yzfxMDiqS3qItroYdMgKX4x4YLRbqNsI3IzS0CwkUR7Pj6QAWe+RPgjFLB+cm269RG2+wUr1ECfT5XElidHI3V3jN9T4e9lVz6ZZL5fbyyQOvEKuvIYY4G3uOfPlwS8biuXvvOdImDhUlf3Wh3OFQfQpFLbOWVHPI6tokijuOgpS/NAXuyzGfdBg/WRPpQ80iAE7HlUJKkydqYZyiiS8jP6fWV+x02GZ0CXqiPujPzk7qf8QhxDqM1DJVNmhsHy596Nj7/vPenCz68EicjM668wMgTiN+dEtH+57IJHZHbTD7rJE+A/G4XHXYXW0TUcHTNS28+J9vlBhBRr0TEK9rOmiKNTG6+MiMNPCoRtrAksgB54z4RPjj4rliPSDfNC+5/xBpTSYUadAIcb26geDNdH4M7WF5ZpuxZ4Vy7sLIOw8xTFw/lLyg4YUpcfAIOQ1JXcHWDQgsskEgePbAoic3bxOp3QNztHNLCSqT26fiheR/dz3WFjR0NvOTfLV8EyavdhNRidytx0Ds6IrLkTRHWkKfTCMzVIur3SGtAarZjqbIWAoqWJJ/xIfHlMoPGzV9D7IQoxa2n//Wue1oXHwP7KW0mjpPG9i1pUHzsV/pfuEns7R50+7jKaW0wi5Ivt19IeFrNAcjfduq4IfRlKGNvLdlmxCnIEsAs82FZMQwFCdfn3nupm6Pyig7YDKBcqs+R1jxXvPD79HtB1sHv6jKhuo6KSUmGrZ/tmTh6QW5pytM/kh+jSIFEx/M+B3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(39850400004)(136003)(346002)(366004)(451199015)(26005)(52116002)(53546011)(6666004)(6506007)(6512007)(83380400001)(478600001)(186003)(44832011)(2616005)(2906002)(66476007)(316002)(6486002)(41300700001)(8936002)(66946007)(66556008)(4326008)(8676002)(5660300002)(36756003)(86362001)(31696002)(38100700002)(38350700002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T2tKNEhtdSswSkZ2L1hXbTVHQzJNcmhIak83b0dMUEdmMTV4ek4rV3JzY1VS?=
 =?utf-8?B?MTFZTklTL3ZaYnR6QVJJdHZnY2NGR1ZtNUg2RG9DYzYvb0Z3V3phWG1JMElo?=
 =?utf-8?B?NU9CQXcrQ3VpbGFIbWpMYllJYU1KTFNZRlV0eHdxTnlKRWsxdEFLa0ppODBD?=
 =?utf-8?B?bHF4TTFVY29qRjhydGVBRnYrQ3F6OCtScG0yTzlkTURPeU5ONS9adnl3a1Jw?=
 =?utf-8?B?Mk1na3BpRVBXQ3RJSzZ2WHQ1K0JQTXBQbFlRbU1oVGduQ28zN2Zzd2YzWmxE?=
 =?utf-8?B?dU1wK1U0c0hJYldLZ3BqbDU0Y3NpVUFLQ0MvRkhKMFdNQlBIMnc0RXZiUVcr?=
 =?utf-8?B?alcxNERMUnJpSEg5VUFwYjYxUDZlRTdrZnFySEI5Uy9iT2kvbVlRZjlrclhH?=
 =?utf-8?B?YkpQQ3N3dXNIWXRzeXhLUllIOGwzTmFrd05BSkdxS3dDbFdSZGpPcmg3Yjdr?=
 =?utf-8?B?WjQvWGZPdit5UUY5UnZaU09ybU5ZejVCWXlJTlN6QUdkSjBjYzlaSjBBWXFp?=
 =?utf-8?B?OHVIblJ2dVVLY1hiV1hGMnhGbUtUcUZKRlZ3c0FqSWdHd096dE9mMm5ONUJ1?=
 =?utf-8?B?ZThtNXpLMDdnN1Q2YmNPV3JpbXd0eVRIS21qZDZ0bGdDekM3K0NBbDZ6eFBh?=
 =?utf-8?B?Yy9jclRad3JiWFZ3a0t5dk9ITjJ2bXZvajBvV2IvZlcvajZKdktoM3FFWGt0?=
 =?utf-8?B?aXR4eVd2REdhYlF3S0JaWG9lbVVPVjB0bnE1Wmh5dU5oWStOc1JNblJxM1BX?=
 =?utf-8?B?SmtvUVZ4c2VyNDJLTStGTzljWVVHME8rVTRVKzVqSU5sYkN1UDllQ2xpTHU3?=
 =?utf-8?B?TmRCSzFESDh4cG9QL01IeEZiR25ZMHFtVmkvbk1qb3Y3QmhxY010R2xaZDZp?=
 =?utf-8?B?LzNGSlN0QkVINkJnQWU2d0NTRDlsVi9waTQ2cDJoaGxqM2paK2VSamQyRFF5?=
 =?utf-8?B?UXU1Q05XQzQvcStVQ0diY0cxSW9WdHJWMUp3MXAyN1pJZ05URlNTWTducnhK?=
 =?utf-8?B?dllMVjl0Zml5MElGWEVEZHBjeHFHQzlPS0M3ZGVvYmVjYlRSUXdOaWhlS0RD?=
 =?utf-8?B?Wm9pT3E5ZG1JaTRsblNZQUdrTjFVWFlpdXhjdE5sRzkzUjh4YlVDWUtBU3Zm?=
 =?utf-8?B?RHNTQ1JtNktVR2xYYWFGNFQ0OUMvd05rcVc0MS96SHdNZmluNUpmN3ptcUp5?=
 =?utf-8?B?aE5wUldabTMzVFdPZC9rdmdDQTBYUkUwYmo5bDZsbEgwOURZNkZLSHpXaTZk?=
 =?utf-8?B?RlhYT29BWVNZSER0WjBDaCtucFJCTFp6VVJVaENFcDZDd1VJN1BvUXA3MHU2?=
 =?utf-8?B?OGhWeHlXZjRBc2RodDRhbWJTVFRIbU9ZWFJjQ3JsTU1tSWhBWFpZdTNFcUNB?=
 =?utf-8?B?RmVSNUhMMGt4QUluc2lCdkRNTTFwbG1KMmlFbFVjOUVkNjFPUEZ1bDFOc2FB?=
 =?utf-8?B?Q3lNTUJqOHJpWk5qVXZ1MUw4NjF2VGYxSk9EWFI5clpNNXA1b1JMTTc5MkFB?=
 =?utf-8?B?bmliKzBSNlpUWkxhWDdXV1oycnBrV2pRbDdQeGFMZ1NQMzJSdU05cEFqWmVu?=
 =?utf-8?B?aVJQWU9icFFzM0hNS0VFRFdsTlY4amxxQjVDSkZ4bzFISzFCakQxMEhOdE1J?=
 =?utf-8?B?d3UxSEF4d1dPRDdZME9Nb3grd2Y3MDJRMjNmMG52d0MwWTczSXpLRDc3TWJh?=
 =?utf-8?B?c2JUNStMQzdQT1BPOWZ3encwMDZZbHBXWlpKUmtWMVYzVVdXcUNQdStrb0lR?=
 =?utf-8?B?bTFJTnZ3M2Y5aUpMM3dzc2hXVFhTODJmRFdtUlBlVDNic2FyTjlWZG1ITWlM?=
 =?utf-8?B?UFd4aUtFUjFFdkRQRDZMbEZNTVZXU2VxSWViM0dQM3dxL0s3eUhEZEJQNHhP?=
 =?utf-8?B?Zk9USkMvNm1RQU1RZUZCeUd0TjliL0JnT3h2ZWVYdEhjcTRZbk4yUlF6QjlZ?=
 =?utf-8?B?L254NVRNM1FhSGtFZjFpazI2blJPbmVneCs0ZVNLVFNqa3M0WURTcWk0bFpG?=
 =?utf-8?B?NUZZU2pKRUdmeG1sZnJISGVrUnQyTGhlc3R4bmlQa0JXSkoxR1YxTW5IYjhw?=
 =?utf-8?B?VElPOEphN3d2UGxCVElwN1hpZUhjN3NVUUh5Qy93VFNEdU03MHcxZURUUTY5?=
 =?utf-8?B?T29pdlA2WFQ2TTlvZnpKYlNhbEgwUTlqamNpQjhkZDFVOUxEQ2pSOGNDSXI3?=
 =?utf-8?B?Zmc9PQ==?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65062f38-f9b1-4673-64a7-08dab6baa042
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 18:56:29.6943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: suH1eu8WX41/RQr6iFo/ufz7M3XGyo3bVTPr3U0gZvDIXgHT2RuHjY7pVOmfqGU5fW3kJx+qYOzUoLt9qP0eLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR03MB7958
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/22 14:51, Jakub Kicinski wrote:
> state is deferenced earlier in the function, the NULL check
> is pointless. Since we don't have any crash reports presumably
> it's safe to assume state is not NULL.

Yes, I believe this was in place just for a patch which hasn't
been upstreamed.

> Fixes: f392a1846489 ("net: phylink: provide phylink_validate_mask_caps() helper")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: linux@armlinux.org.uk
> CC: andrew@lunn.ch
> CC: hkallweit1@gmail.com
> CC: sean.anderson@seco.com
> CC: rmk+kernel@armlinux.org.uk
> ---
>  drivers/net/phy/phylink.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> index 62106c9e9a9d..88f60e98b760 100644
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@ -564,7 +564,7 @@ EXPORT_SYMBOL_GPL(phylink_get_capabilities);
>  /**
>   * phylink_validate_mask_caps() - Restrict link modes based on caps
>   * @supported: ethtool bitmask for supported link modes.
> - * @state: an (optional) pointer to a &struct phylink_link_state.
> + * @state: pointer to a &struct phylink_link_state.
>   * @mac_capabilities: bitmask of MAC capabilities
>   *
>   * Calculate the supported link modes based on @mac_capabilities, and restrict
> @@ -585,8 +585,7 @@ void phylink_validate_mask_caps(unsigned long *supported,
>  	phylink_caps_to_linkmodes(mask, caps);
>  
>  	linkmode_and(supported, supported, mask);
> -	if (state)
> -		linkmode_and(state->advertising, state->advertising, mask);
> +	linkmode_and(state->advertising, state->advertising, mask);
>  }
>  EXPORT_SYMBOL_GPL(phylink_validate_mask_caps);
>  

Reviewed-by: Sean Anderson <sean.anderson@seco.com>
