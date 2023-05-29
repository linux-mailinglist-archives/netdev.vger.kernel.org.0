Return-Path: <netdev+bounces-6067-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 709C7714A1F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:19:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2BA3F280E5E
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F21C37460;
	Mon, 29 May 2023 13:18:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D383D60
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:18:59 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE7291
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:18:58 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-514924ca903so2937583a12.2
        for <netdev@vger.kernel.org>; Mon, 29 May 2023 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685366337; x=1687958337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/vKSVewvvgNmBaS2m89L7HPH8tzhUP9OKuLAcv7eBrA=;
        b=C8HQzWxLngDUWXWbOKeK6W+9+VQlAZu8nbLFYw9lmw75B5y/D+Kvvw0MuIfnEk6JjA
         oBFn4pw/SmXtgL5VNY6i3BxzvYtVbJCLycd2QR1VoXp2jA6iYnQLVumnPY4GT2iIIfYL
         ZMSxLWYf0CQl08haYhgjxGguMPcpqE75T2GwIZHNQvC8H02mHYNn2OPSc3GmY98ha2oB
         InKxNqdaSG2IvB+Und5d1cqintkU9/4Ib5IP25vgEIiUEOwuwAjA95KCf7PcvHd7NuVI
         UcKbNwG5VGEQc1o2DFiGzxR6/UIjexYMM7XsI67iWwXT/DTaDj+yv5jeqon5lVup6Ydc
         y+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685366337; x=1687958337;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/vKSVewvvgNmBaS2m89L7HPH8tzhUP9OKuLAcv7eBrA=;
        b=RwWNbC0qzmdzVNywRNGHJXnJzNNz1zCL2oPmm2ta/PeqbzfrGuNkvg7L1ucYoGw92K
         fq9hHIpqnCy6wJvNwAQmFdn3qGpAorEfR644yylpg9FDI3lzwqZfp0fyDbemRzc8Rcyc
         gBBJW2d+tbL7iVlkxCaumHPGj7Sb/qFvO8NSImsMfS75bAGScS3Qcb8sJfCvNis0BH2u
         nll2bUqHZ0DkeAx4W3BhysqIUJhRj2iY3thXmdnXYih/hXElldFESRQkUyyxd0KljInx
         ZN+Ol7E4eeTfh2HuXnJgUJPu2gDZYERZeSPk+VAv+Vx88kikw/2YZzzLIY4mmV/gF6yE
         xWWw==
X-Gm-Message-State: AC+VfDzZsCTeGv6uF2Xz8g/FtKi3Nq8g4MO7jZyyIGhiKAcKi3RLU5Ev
	0blLGYCzdo2H7+d7f+9xUQIZSQ==
X-Google-Smtp-Source: ACHHUZ7jf/qGi2YiFapIE0brjV4aYUJ7L/6oGeZWh4eSAlrBX5XMGklZk5nFgnRPzVhwN1Iwq+DOMQ==
X-Received: by 2002:aa7:c458:0:b0:514:9904:c8fe with SMTP id n24-20020aa7c458000000b005149904c8femr3356861edr.39.1685366337102;
        Mon, 29 May 2023 06:18:57 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id v15-20020aa7cd4f000000b005149dc73072sm1318955edw.56.2023.05.29.06.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 May 2023 06:18:56 -0700 (PDT)
Message-ID: <753ea732-2016-36b7-bcc3-4536fa5cd6a4@blackwall.org>
Date: Mon, 29 May 2023 16:18:55 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next v2 3/8] net/sched: flower: Allow matching on
 layer 2 miss
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
 <20230529114835.372140-4-idosch@nvidia.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230529114835.372140-4-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 29/05/2023 14:48, Ido Schimmel wrote:
> Add the 'TCA_FLOWER_L2_MISS' netlink attribute that allows user space to
> match on packets that encountered a layer 2 miss. The miss indication is
> set as metadata in the tc skb extension by the bridge driver upon FDB or
> MDB lookup miss and dissected by the flow dissector to the
> 'FLOW_DISSECTOR_KEY_META' key.
> 
> The use of this skb extension is guarded by the 'tc_skb_ext_tc' static
> key. As such, enable / disable this key when filters that match on layer
> 2 miss are added / deleted.
> 
> Tested:
> 
>  # cat tc_skb_ext_tc.py
>  #!/usr/bin/env -S drgn -s vmlinux
> 
>  refcount = prog["tc_skb_ext_tc"].key.enabled.counter.value_()
>  print(f"tc_skb_ext_tc reference count is {refcount}")
> 
>  # ./tc_skb_ext_tc.py
>  tc_skb_ext_tc reference count is 0
> 
>  # tc filter add dev swp1 egress proto all handle 101 pref 1 flower src_mac 00:11:22:33:44:55 action drop
>  # tc filter add dev swp1 egress proto all handle 102 pref 2 flower src_mac 00:11:22:33:44:55 l2_miss true action drop
>  # tc filter add dev swp1 egress proto all handle 103 pref 3 flower src_mac 00:11:22:33:44:55 l2_miss false action drop
> 
>  # ./tc_skb_ext_tc.py
>  tc_skb_ext_tc reference count is 2
> 
>  # tc filter replace dev swp1 egress proto all handle 102 pref 2 flower src_mac 00:01:02:03:04:05 l2_miss false action drop
> 
>  # ./tc_skb_ext_tc.py
>  tc_skb_ext_tc reference count is 2
> 
>  # tc filter del dev swp1 egress proto all handle 103 pref 3 flower
>  # tc filter del dev swp1 egress proto all handle 102 pref 2 flower
>  # tc filter del dev swp1 egress proto all handle 101 pref 1 flower
> 
>  # ./tc_skb_ext_tc.py
>  tc_skb_ext_tc reference count is 0
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v2:
>     * Split flow_dissector changes to a previous patch.
>     * Use tc skb extension instead of 'skb->l2_miss'.
> 
>  include/uapi/linux/pkt_cls.h |  2 ++
>  net/sched/cls_flower.c       | 30 ++++++++++++++++++++++++++++--
>  2 files changed, 30 insertions(+), 2 deletions(-)

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



