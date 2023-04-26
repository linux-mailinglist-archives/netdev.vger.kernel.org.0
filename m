Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5306EF8B0
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbjDZQrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:47:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233451AbjDZQrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:47:32 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151486A5E;
        Wed, 26 Apr 2023 09:47:31 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 3f1490d57ef6-b9246a5f3feso13080130276.1;
        Wed, 26 Apr 2023 09:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682527650; x=1685119650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vw8MovSgVlct4xecbDPsUdMVs+ZN+eTaQAD87jE8/qo=;
        b=fBNh0YI6DrGm6AnlSsqOcQu8gJE2McCnEUTw5gulWAVInqJ6nVN8TndNgx0qFmqWkZ
         oi+Y8TUkz05m+BZk7Eth4HVLJKq8whw0bxAHu5ugrxhvDFEEkSV0QSKsNqOYHzSmcgij
         YWWS62fV6fNcxIQahltjqnk1QEN1kmFqHzhlSL2z041V+IdAdyT8/cyrBY1yd0a2KuWW
         Lnkd0DTBn5AlZZh8DWkSjbYw2egKaD13bADXf4/G8XXTb8PW8+jL5B7xKfYTjht3GIop
         XAY7KXt8n0aAwwXaZ5rC1zwHqzDH1K0C/a8t0KliMZ35L02FHXIxJIXuyj11Qz7oP3AP
         lJfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682527650; x=1685119650;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vw8MovSgVlct4xecbDPsUdMVs+ZN+eTaQAD87jE8/qo=;
        b=baOY72uuNMjoGfpEOPM3nJKdVqi1RbvFtkxp097vmOHAK9vaFWb2ONtJbrRN2YHUG2
         vNCzTHdMjZuL2IQQHdaqae8BiKr0zA2t7aLhglAKUgEZmAELRx+Z9TBXnquY6J4Na1i3
         UVrnVyj2aQxHlyLFG3ArDR2y8EZhu5u58Yh4JunXH12VpTjTQSDLq4/Zh3Pt0ad1f9ng
         jhL3GWROOP5NfIjMW614Mzmqs5FOfcH2z9kySpXkp89U6GtN1dRBrCTphYeRNrN9cXzg
         yC71ciICGbXTB5eDd3JkZcBpPrfHzR1XgCO2fCuUQZVSTnhA6NZjUv6XRswJ++j0cBRa
         QHKg==
X-Gm-Message-State: AAQBX9cLTUUUqY0pLH30jN9pGtbSMGDrb0t550iDOu2Y78bZckMK3sQG
        tw8AeUTSpNNv5s0KI2i/WE0=
X-Google-Smtp-Source: AKy350YPo3V9QN9cf71rUP7gaSeHZy2hUj3QZQdMTzU42pL14p7+rZPT0jNX4iqhUEYxj/mTYR8hvQ==
X-Received: by 2002:a25:240b:0:b0:b8b:f3b9:7f64 with SMTP id k11-20020a25240b000000b00b8bf3b97f64mr15823577ybk.21.1682527650268;
        Wed, 26 Apr 2023 09:47:30 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:2021:437f:610d:4e30? ([2600:1700:6cf8:1240:2021:437f:610d:4e30])
        by smtp.gmail.com with ESMTPSA id b129-20020a816787000000b00545a08184a7sm4314612ywc.55.2023.04.26.09.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 09:47:29 -0700 (PDT)
Message-ID: <8e1694ec-9acf-a4bd-4dd2-28a258e1436b@gmail.com>
Date:   Wed, 26 Apr 2023 09:47:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH bpf-next 2/5] net/smc: allow smc to negotiate protocols on
 policies
To:     "D. Wythe" <alibuda@linux.alibaba.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        pabeni@redhat.com, song@kernel.org, sdf@google.com,
        haoluo@google.com, yhs@fb.com, edumazet@google.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, jolsa@kernel.org,
        guwen@linux.alibaba.com
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
References: <1682501055-4736-1-git-send-email-alibuda@linux.alibaba.com>
 <1682501055-4736-3-git-send-email-alibuda@linux.alibaba.com>
Content-Language: en-US
From:   Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <1682501055-4736-3-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/26/23 02:24, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> diff --git a/net/smc/bpf_smc.c b/net/smc/bpf_smc.c
> new file mode 100644
> index 0000000..0c0ec05
> --- /dev/null
> +++ b/net/smc/bpf_smc.c
> @@ -0,0 +1,201 @@
> +// SPDX-License-Identifier: GPL-2.0-only
... cut ...
> +
> +/* register ops */
> +int smc_sock_register_negotiator_ops(struct smc_sock_negotiator_ops *ops)
> +{
> +	int ret;
> +
> +	ret = smc_sock_validate_negotiator_ops(ops);
> +	if (ret)
> +		return ret;
> +
> +	/* calt key by name hash */
> +	ops->key = jhash(ops->name, sizeof(ops->name), strlen(ops->name));
> +
> +	spin_lock(&smc_sock_negotiator_list_lock);
> +	if (smc_negotiator_ops_get_by_key(ops->key)) {
> +		pr_notice("smc: %s negotiator already registered\n", ops->name);
> +		ret = -EEXIST;
> +	} else {
> +		list_add_tail_rcu(&ops->list, &smc_sock_negotiator_list);
> +	}
> +	spin_unlock(&smc_sock_negotiator_list_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(smc_sock_register_negotiator_ops);

This and following functions are not specific to BPF, right?
I found you have more BPF specific code in this file in following
patches.  But, I feel these function should not in this file since
they are not BPF specific because file name "bpf_smc.c" hints.
