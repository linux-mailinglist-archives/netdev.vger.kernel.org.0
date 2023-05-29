Return-Path: <netdev+bounces-6086-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F0DC714C71
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:50:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 351AA1C209BE
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:50:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69478BF0;
	Mon, 29 May 2023 14:50:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBFE66FCF
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:50:06 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C536B7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:50:05 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5148e4a2f17so4689153a12.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685371804; x=1687963804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mHZZ92GJ5ZTas5TwDw4/gd16Yq3qwKu+NLw4y0txzO8=;
        b=rzoJFhFQwd8s2j0J7YhRub5SjpCMeLl4XSuJ5tuxJ1gWgsWYZwM/IUDgQvJ33THL1Y
         HQRpxqwQ4LQlX4SHLiJBrjNX6EvsiUVykMAlYInmQsEfkDFzqUHrbBxrMTc67zqz9tKf
         u7hX3Nm1SBoes1oiAsIJityu5J3ca/IqYFmc7bpF32JpIeFM4hIUpkZOIqNng5oynjc4
         fntEcEud09bnR9aniI14YdNxQ+GPcDrQyvT8owt/J5ygvrPJNfqmj8y6+kR+UVVl9cwC
         YVJ52ohCWkgJ+cLe50SgA6CWhBYvcy/LmsSy+1yYV0Pk52jC9AXikoh8YZYBT4So0z6D
         ksdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371804; x=1687963804;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mHZZ92GJ5ZTas5TwDw4/gd16Yq3qwKu+NLw4y0txzO8=;
        b=LdaW6o7tzVGrExMz6t5aw1qx0wRZOLbq6Inf199aa5x8XFAr4AdKsjzo+mfdMzE2Ht
         qlqeDcNZn5uC1naCWbqLFKxjXO7DReIQJX7DGgI9TBPwMdvzlzGhI/gJy5x2WRDpsxjh
         upD3AessOG/JxEtpThI3S73h90oLxpP5dbu9rxkg+fUheCBXlwa9JZNEwsJjWsMzO+bO
         F5oS5l7+uyygAYg21Nfiww26wfR8uyDaTyVC1sTKf8J1adEBSc1jdUdbB8wQxSdEDnz1
         kfxZnECdU8144pdfxDrf5hnHxQ2BayBoUt8tWzPO1SMxZrh8eZ6tuFt4ffeQZXru/Z3j
         WNKA==
X-Gm-Message-State: AC+VfDwSosStHkwaAUJyyEWAa6hNSF7kkU7c1qO9wFeVjAgjbUlIP65g
	j7thk7T5Ftvj0va98hBCfx+MkQ==
X-Google-Smtp-Source: ACHHUZ7Zq+bK1sQ2zvEhivXDtGUvRbpP9L9r6myOfqAciLlbpkE5eW4RFbfhISzOcXXd3xs8nIFg1w==
X-Received: by 2002:a17:907:3187:b0:966:37b2:7354 with SMTP id xe7-20020a170907318700b0096637b27354mr10995943ejb.31.1685371803889;
        Mon, 29 May 2023 07:50:03 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z11-20020a170906714b00b0096f89fd4bf8sm5957708ejj.122.2023.05.29.07.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:50:03 -0700 (PDT)
Message-ID: <cae7f2be-cc0b-b6bb-16c5-eb014e07e73f@blackwall.org>
Date: Mon, 29 May 2023 17:50:01 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 7/8] mlxsw: spectrum_flower: Add ability to
 match on layer 2 miss
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
 <20230529114835.372140-8-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-8-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Add the 'fdb_miss' key element to supported key blocks and make use of
> it to match on layer 2 miss.
> 
> The key is only supported on Spectrum-{2,3,4}. An error is returned for
> Spectrum-1 since the key element is not present in any of its key
> blocks.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Use 'fdb_miss' key element instead of 'dmac_type'.
> 
>  drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.c    | 1 +
>  drivers/net/ethernet/mellanox/mlxsw/core_acl_flex_keys.h    | 3 ++-
>  .../net/ethernet/mellanox/mlxsw/spectrum_acl_flex_keys.c    | 2 ++
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c       | 6 ++----
>  4 files changed, 7 insertions(+), 5 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



