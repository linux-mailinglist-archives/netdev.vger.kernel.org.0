Return-Path: <netdev+bounces-6082-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 32137714C54
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0AB0280E82
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CBB18463;
	Mon, 29 May 2023 14:48:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420A033FD
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:48:52 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59057B7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:48:50 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96f6e83e12fso526555766b.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685371729; x=1687963729;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JKlNcGPxl9mlN8rwjzjxvcvFuvq/iuxFaFEW8rQumgw=;
        b=2+ehGTQDV5i5XJKBMKEJVAhpQenFILVf+B4gsexsUA5Um9FxW43qvQqvOrdqirhTEh
         ahCo3yiNK4qUcuNG84897QIHQEkj3azmE9Jt2axQJTuFpucPSFSppGjhSv2FApgi8B4G
         wzDVZs3vr4mRQTvehmPNDW26wmFKvq90rAEfWzFBkVFBSRcm8c+m+18OvDfUZmcIlO7J
         MM+CpI6DKSzIR8+Tgl9BT3UooNwsRct8Kn5tsgmmMdd55oYm3LIYDyKCgI8cQ9Fdadjk
         hU9HZz0lxCjl/ARgVd7UfC8N6Z+Z+f5N3XapYLTuzBHPbbiFh3akqI1glxSm0oMA6KjX
         UENw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371729; x=1687963729;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JKlNcGPxl9mlN8rwjzjxvcvFuvq/iuxFaFEW8rQumgw=;
        b=mAFY33UTNo5ymcGtCJYPDmo3o5+RCF86/lmVOUyRkZMkxMfkJwMZLOTE4uielSWFII
         vc5xei0G85rxpb+8DOv8aPE7YHe0e6KjfcFKIbseNBQgyYwhUpztVGWWci2hlMREWuWQ
         FiUikg9YrSOVR0NEbxeIa7vCTnoMLe6slYFWfGC9s0YyY7H8/YLg2qGbD7OHToWtX3tC
         yzAHgxM6PoJUblzxqv5AMwCadAuKhgSgDk++8lsYQbNEUe2QzNFxdf16DirkbvdeEowC
         Fh9y+6xiYJuvS1rh4Dqv2a7Uck/21jxJjAX35xaH80AvIn8jSbKsJX1p0wbLAzAGlL6y
         SLHQ==
X-Gm-Message-State: AC+VfDwVxtLfYsA/gAWAAL9/ziwjWEaf3Fon0G6xQSidRJ6CN3dbpPT3
	UV6qeMLq4sNfx2Pl/OaHThXe+g==
X-Google-Smtp-Source: ACHHUZ4otyt7KxDZSKbwEIycXi3UyHAbhclKomWNF0GW/MKFbOX/+3i/05mdCzdQ7zJuRSJcd45vxA==
X-Received: by 2002:a17:907:7b87:b0:966:5c04:2c61 with SMTP id ne7-20020a1709077b8700b009665c042c61mr12095103ejc.8.1685371728690;
        Mon, 29 May 2023 07:48:48 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id ja20-20020a170907989400b0096f89c8a2f7sm6022518ejc.90.2023.05.29.07.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:48:48 -0700 (PDT)
Message-ID: <098121b7-7118-5605-e701-0c47c759ee6c@blackwall.org>
Date: Mon, 29 May 2023 17:48:46 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 8/8] selftests: forwarding: Add layer 2 miss
 test cases
Content-Language: en-US
To: Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, taras.chornyi@plvision.eu, saeedm@nvidia.com,
 leon@kernel.org, petrm@nvidia.com, vladimir.oltean@nxp.com,
 claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
 UNGLinuxDriver@microchip.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, roopa@nvidia.com, simon.horman@corigine.com
References: <20230529114835.372140-1-idosch@nvidia.com>
 <20230529114835.372140-9-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-9-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Add test cases to verify that the bridge driver correctly marks layer 2
> misses only when it should and that the flower classifier can match on
> this metadata.
> 
> Example output:
> 
>  # ./tc_flower_l2_miss.sh
>  TEST: L2 miss - Unicast                                             [ OK ]
>  TEST: L2 miss - Multicast (IPv4)                                    [ OK ]
>  TEST: L2 miss - Multicast (IPv6)                                    [ OK ]
>  TEST: L2 miss - Link-local multicast (IPv4)                         [ OK ]
>  TEST: L2 miss - Link-local multicast (IPv6)                         [ OK ]
>  TEST: L2 miss - Broadcast                                           [ OK ]
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Test that broadcast does not hit miss filter.
> 
>  .../testing/selftests/net/forwarding/Makefile |   1 +
>  .../net/forwarding/tc_flower_l2_miss.sh       | 350 ++++++++++++++++++
>  2 files changed, 351 insertions(+)
>  create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_l2_miss.sh

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



