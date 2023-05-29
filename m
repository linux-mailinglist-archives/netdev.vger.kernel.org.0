Return-Path: <netdev+bounces-6068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4DBB714A21
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 01A621C209FA
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92DB97472;
	Mon, 29 May 2023 13:19:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F946FD7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:19:23 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455399B
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:19:22 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-51458e3af68so5625355a12.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685366361; x=1687958361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7liou2UMGklqRO9dLDDOCk0JRNw6KtAVNVlIZMEBmcs=;
        b=KLEPR262FOslxo55V+tYUh11CnbmuKwlngkBTAky1p8umNg5QkIQI38Z+WeJjBGE12
         mTo1wstdR1L3Nc60NQMJ84pybpUYD7b8Qki9ssLYEfDB2lWGw0jpHfVDwGs3T0twMVi/
         6ka5i2joKgJKGAltya1QnjrVtLEV6/cKNa+2v4khPlSqLl1NY17cP9b84mtZwbzsO+Qk
         tcfzeuzvWocAmamqtjZo7aAeew57i4swF3AbZkCZ7Y8U1IfVIgquLHvnMHVzlEb24sUa
         H1wCIkOEINjeqd6IrFGY8B5WA4yUTRjvJqQIKHcWa/MVAWMCSMBgbiUArnVIzW8N/5S4
         V2AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685366361; x=1687958361;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7liou2UMGklqRO9dLDDOCk0JRNw6KtAVNVlIZMEBmcs=;
        b=HxBUvUrP2GlkNoHhYQHhEindsUgBsSCLhneiy2semoCi9JNdqkUybdRSHSirx5tUgV
         FLHv4KS3Nq0dCud6Caao/8h6KIrBFw3uj/EYFLizOt5ZGB7JDtFmAlX5kMqZ6BmZ8r65
         1CwEF/4cmLzrA1ojQy3JJL97YqeQC7izYzsTK7nGJbRnX/Dy8R7ccLNnrTeCjX7Wjltv
         3w5ZC8G/uvuDXhq/rhhee8I5HR49YEPSC4R/fLoY3z1WStg4uaQv1KDkGk8egolNhNHK
         mJGAcmgWsa1Q9id0DBCmeVyKPeu01j1SAy2OOuSUZaAHf45MYMIc9guwIbHG6chXTE2N
         kvHQ==
X-Gm-Message-State: AC+VfDxIAoALRbUyhNzvQm6q5Bn3lxNCXTWBQ6bideJvVEly8Z/bxVvA
	6YVvi+MOvmMBM5SniHuDlALfo/LzS3KrOZfgezRSPK0s
X-Google-Smtp-Source: ACHHUZ7N/lXymSO4KkAUma1tzAydULDjaCN5ORz1N/mJAB0SGLYVqb1nWG2s9sReyZMjGUKJWPnTsg==
X-Received: by 2002:aa7:c91a:0:b0:514:94ff:f67e with SMTP id b26-20020aa7c91a000000b0051494fff67emr6307174edt.5.1685366360627;
        Mon, 29 May 2023 06:19:20 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id b7-20020aa7dc07000000b0051056dc47e0sm3058753edu.8.2023.05.29.06.19.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 06:19:20 -0700 (PDT)
Message-ID: <a6d5285b-641e-16a1-ca29-2d020b628ff8@blackwall.org>
Date: Mon, 29 May 2023 16:19:18 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 4/8] flow_offload: Reject matching on layer 2
 miss
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
 <20230529114835.372140-5-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-5-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Adjust drivers that support the 'FLOW_DISSECTOR_KEY_META' key to reject
> filters that try to match on the newly added layer 2 miss field. Add an
> extack message to clearly communicate the failure reason to user space.
> 
> The following users were not patched:
> 
> 1. mtk_flow_offload_replace(): Only checks that the key is present, but
>    does not do anything with it.
> 2. mlx5_tc_ct_set_tuple_match(): Used as part of netfilter offload,
>    which does not make use of the new field, unlike tc.
> 3. get_netdev_from_rule() in nfp: Likewise.
> 
> Example:
> 
>  # tc filter add dev swp1 egress pref 1 proto all flower skip_sw l2_miss true action drop
>  Error: mlxsw_spectrum: Can't match on "l2_miss".
>  We have an error talking to the kernel
> 
> Acked-by: Elad Nachman <enachman@marvell.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Expand commit message to explain why some users were not patched.
> 
>  .../net/ethernet/marvell/prestera/prestera_flower.c    |  6 ++++++
>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c        |  6 ++++++
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c  |  6 ++++++
>  drivers/net/ethernet/mscc/ocelot_flower.c              | 10 ++++++++++
>  4 files changed, 28 insertions(+)
> 

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



