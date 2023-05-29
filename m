Return-Path: <netdev+bounces-6084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68DD2714C5C
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:49:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8F5F52804CD
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 14:49:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80ED9883E;
	Mon, 29 May 2023 14:49:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766CB8463
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 14:49:24 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0A2AD
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:49:23 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-51492ae66a4so2907209a12.1
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 07:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685371761; x=1687963761;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Rzi88jwPmtFMmjNwM6+2TYx8VpaCHshCTn+VpfHMLE=;
        b=FAGhU7jW7A9tLI0VpW7atmg+20AaVVf4TyuPD/Y58xMx3EQzLKftc9ni7z1NaGkvju
         OrHyWynmv15DprInEjxybJkyRmVr5KeTP7voRFevHss47G0WbdBmYD1+c5W0lT7e5xtm
         AguMydpgy0f3C/X77K0c+raUC5DlZuUh93iSSaY6aSsvwUYv++TwqAwKCdUe2eoRL7gJ
         4oHnIY8HZdAANenhIgFkNl689NdEwJCxC0IslhM/lxl49E7V3srrCMIDbvNYjuDbaEFB
         nWIWq4utExJM4Eq8J7IGTwYNnhUcmX6s4NPKiqUwsooQZtSgSxboaTN0737Em+FNkKNi
         lEmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685371761; x=1687963761;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7Rzi88jwPmtFMmjNwM6+2TYx8VpaCHshCTn+VpfHMLE=;
        b=QVes0+9kAhHI658YtTk4l5OaB98Yqxh5LTvQBHLVYS3yVjyOaha68MErIigfHCfkD3
         0pq6BZQ6TGlhfCvdHoo3C5dPj9rgyhtHMjxfsnWwoB0YSrdFDqjh7bS4rFJysvqoDosx
         KdWgfS91HHUBGUiOZsFZQg2nfPQF33VUw3vTgsCYq4szuHtyurid4zqgDYz8FhbyV6G2
         zL2RRZj808a7D3361NiGRjkEpcXFC7EoJasOq30mP5SiyqKJb/Vk7LUN15qHMTocvFtR
         G1Mjipvp3nDyMZ8rtpuApLcUtPXekVAQLMmDKV7yHlPf/ldFEKbRI140d2FS6IYk74gn
         WIRw==
X-Gm-Message-State: AC+VfDyupOLX07wGjgNBT6JmvjG4vZmCLGAjH86UiADBIq5pzlTx3W+N
	UShxMNgxNUETpjn7X/okjyvCjw==
X-Google-Smtp-Source: ACHHUZ7wMTakfY9XPMXoaoGJ9cw9LAiBHMBIdZCjoBKVZxRkq8jQ9GDJoDkTRXFwlHDqD8uTfKvDuA==
X-Received: by 2002:a05:6402:794:b0:50c:4b9:1483 with SMTP id d20-20020a056402079400b0050c04b91483mr8826301edy.37.1685371761531;
        Mon, 29 May 2023 07:49:21 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id t22-20020a05640203d600b004bd6e3ed196sm3148172edw.86.2023.05.29.07.49.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 07:49:21 -0700 (PDT)
Message-ID: <3582538e-944e-3de6-6415-5384c399e0f5@blackwall.org>
Date: Mon, 29 May 2023 17:49:18 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 5/8] mlxsw: spectrum_flower: Split iif parsing
 to a separate function
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
 <20230529114835.372140-6-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-6-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Currently, mlxsw only supports the 'ingress_ifindex' field in the
> 'FLOW_DISSECTOR_KEY_META' key, but subsequent patches are going to add
> support for the 'l2_miss' field as well. Split the parsing of the
> 'ingress_ifindex' field to a separate function to avoid nesting. No
> functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * New patch.
> 
>  .../ethernet/mellanox/mlxsw/spectrum_flower.c | 54 +++++++++++--------
>  1 file changed, 33 insertions(+), 21 deletions(-)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



