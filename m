Return-Path: <netdev+bounces-5106-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C61B70FA93
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:40:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CC0F9281006
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E53D019BB8;
	Wed, 24 May 2023 15:40:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3E019907
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:40:30 +0000 (UTC)
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B56DE4E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:40:10 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-19a13476ffeso352297fac.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684942737; x=1687534737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JXUt/ydD2q4pGzaniA+mmW+0t+wCIp9nemsCnmX6WJM=;
        b=ApkFE7FQIqtU+VA+oa0mvicWOFz/g4CGP4NH6NMNWbCDVr+9O9kRrzWFriVrJd7zN4
         IAa/GNxjZY9eimkVY+MHM1PnSo0NYuYj7N2udCRiav67WP4FdDNlkvCZTHnJ9pwW4ONr
         3Rbhx2fO7KadJ/BY1wPyOJ+NtdL1nhNNvdlR/JUeCbfrYPdfuEwNXOc3AyHB/Gi+qAIP
         yZFv3tPh7JpGq+SiUkoshP/k1qT+sOEUBPdUb/nRS8FK21d4zv4SiF6GHknM1Z+ZyRf8
         GBER3kRXY6k/leyJslNXHqViYQsPmyEcF/PHZHPy+9/MitL6NfOcQc9iaA61ThziQS6G
         MDZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942737; x=1687534737;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JXUt/ydD2q4pGzaniA+mmW+0t+wCIp9nemsCnmX6WJM=;
        b=Z0yUIPSj4Wfb8X/SJ+S0xAkY8b+HVCIKT30w4xSVOlK0CgcXg6zqDAeapMlWyc0NKC
         Mbh9jPCEFJIMSd/h0dGsz3H6bVEGoQa2iJcmPG80CmkVH8DPTk6uIMT6Ip/mFWU4Ek7M
         cfjlVgaMJ9VPsLwSKH+iZ+FuDq9UlnOVnYccEQrmpj9OUZbGEwj+HK0aRmXV1kzgOyCl
         PqapyxDV/Mav4C+L3zWQzMxz8OEa14ZwPlzk/C74oK1KaGgrunj1DYereTt1hiaJXqrG
         +AsP5lsyDcUVSpy7nUETlA+tIwlzuLGjRTyLqgsBHGfZRShQZXczPRPAlsBFdb4TtyMz
         QxkA==
X-Gm-Message-State: AC+VfDxxqNO7nfXBcQDWQgnyJSG6yk74y6y05KC4PJd0VgXstcE5QctE
	EBkNzpxWRJd7YQu5IwsSqH3wp0BLTOtI+AZoVp8=
X-Google-Smtp-Source: ACHHUZ5qtv6wn5gvW7KsUlCuOFdPOiCezYd0GSkwBzr7dnEIQHsZczZ1YnlS7/iO4LKIicpwTG9ygQ==
X-Received: by 2002:a05:6870:c803:b0:196:7dec:dbd7 with SMTP id ee3-20020a056870c80300b001967decdbd7mr116390oab.3.1684942737273;
        Wed, 24 May 2023 08:38:57 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:522c:f73f:493b:2b5? ([2804:14d:5c5e:44fb:522c:f73f:493b:2b5])
        by smtp.gmail.com with ESMTPSA id e21-20020a056871045500b0017243edbe5bsm23381oag.58.2023.05.24.08.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 May 2023 08:38:57 -0700 (PDT)
Message-ID: <9b58d882-743a-c392-0407-17bb0b075516@mojatatu.com>
Date: Wed, 24 May 2023 12:38:51 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v5 net 4/6] net/sched: Prohibit regrafting ingress or
 clsact Qdiscs
Content-Language: en-US
To: Peilin Ye <yepeilin.cs@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>,
 Jiri Pirko <jiri@resnulli.us>
Cc: Peilin Ye <peilin.ye@bytedance.com>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>, Vlad Buslov
 <vladbu@mellanox.com>, Hillf Danton <hdanton@sina.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Cong Wang <cong.wang@bytedance.com>
References: <cover.1684887977.git.peilin.ye@bytedance.com>
 <81628172b6ffe1dee6dbe4a829753e0d97f61a48.1684887977.git.peilin.ye@bytedance.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <81628172b6ffe1dee6dbe4a829753e0d97f61a48.1684887977.git.peilin.ye@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 23/05/2023 22:19, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Currently, after creating an ingress (or clsact) Qdisc and grafting it
> under TC_H_INGRESS (TC_H_CLSACT), it is possible to graft it again under
> e.g. a TBF Qdisc:
> 
>    $ ip link add ifb0 type ifb
>    $ tc qdisc add dev ifb0 handle 1: root tbf rate 20kbit buffer 1600 limit 3000
>    $ tc qdisc add dev ifb0 clsact
>    $ tc qdisc link dev ifb0 handle ffff: parent 1:1
>    $ tc qdisc show dev ifb0
>    qdisc tbf 1: root refcnt 2 rate 20Kbit burst 1600b lat 560.0ms
>    qdisc clsact ffff: parent ffff:fff1 refcnt 2
>                                        ^^^^^^^^
> 
> clsact's refcount has increased: it is now grafted under both
> TC_H_CLSACT and 1:1.
> 
> ingress and clsact Qdiscs should only be used under TC_H_INGRESS
> (TC_H_CLSACT).  Prohibit regrafting them.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 1f211a1b929c ("net, sched: add clsact qdisc")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Tested-by: Pedro Tammela <pctammela@mojatatu.com>

> ---
> change in v3, v4:
>    - add in-body From: tag
> 
>   net/sched/sch_api.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
> index 383195955b7d..49b9c1bbfdd9 100644
> --- a/net/sched/sch_api.c
> +++ b/net/sched/sch_api.c
> @@ -1596,6 +1596,11 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
>   					NL_SET_ERR_MSG(extack, "Invalid qdisc name");
>   					return -EINVAL;
>   				}
> +				if (q->flags & TCQ_F_INGRESS) {
> +					NL_SET_ERR_MSG(extack,
> +						       "Cannot regraft ingress or clsact Qdiscs");
> +					return -EINVAL;
> +				}
>   				if (q == p ||
>   				    (p && check_loop(q, p, 0))) {
>   					NL_SET_ERR_MSG(extack, "Qdisc parent/child loop detected");


