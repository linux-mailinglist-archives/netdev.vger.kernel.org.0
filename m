Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791D56BA78F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 07:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjCOGOo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 02:14:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbjCOGOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 02:14:42 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E73025BCA1;
        Tue, 14 Mar 2023 23:14:41 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id b20so11067639pfo.6;
        Tue, 14 Mar 2023 23:14:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678860881;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zrO+pcZdXTBSpsHTsNXDHYa0ybcj9wOqWg+hyVu3ao=;
        b=i0o8rxmus2RNFC1A6PS/PYuv7rdtb6JC8doDd8PgFanoflCbv/oUNQE8n2N3TsS/Bz
         ud4GSZaqE3ubs2h+eLeuYo+M6KwyfpK8IEZWELLeLSwmVcYucVHIyOig+xD+KFPZ/PAm
         +q13PRroHaNOXkTj8m07PcAVKzFF2qaAFPwHh/dYdEtfm9tocZLveA2vW4rbGOuMfsO5
         nrt8yPeWjBfbkz5Gulc0GMxpeguDw93I0PDBdR2j35Rk7h2Wpga9Xtr7lTBB5/wxQfqA
         Rs/56jlE4X+DwojTihBJI/tIbj7Rp51SNTjIjdTbmIYVFKfHbDZCkY+X6f9Lnm38/0/e
         Q1gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678860881;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0zrO+pcZdXTBSpsHTsNXDHYa0ybcj9wOqWg+hyVu3ao=;
        b=5Nq50xYDLZ8IIC1wUm/mKh/2tgOfqKJfZeS0hedzZJgWlXHvEa4yYkXE7wx78gw09j
         JRUmX3Ah4n7vCoh1p2hzPyqpCek0S8wgdeL4PwarqAgCLsvBEICt6CyxjPvOZliMaP/Y
         1/z5EVQdG1IrHYbM/4j1zrSouiHE1X1kxHc6wDAbPIE+FGApphGBYbTw1u2LurDfxcA3
         6nKBAGvq62ikyX3V5Mx6H7OOGfZFj7qxWbFiyfFu5IaxsLh4OMklqGisTGwJw8Sy7sy/
         ziVfDJ4c09wnhJWOtsjTdOY4/+NOqb6Yd9MN/w5yIPG1VvOFMR38kCXuvTqODdMZ791t
         9cVQ==
X-Gm-Message-State: AO0yUKWO9zxxCB/nFU2L+FMjNny7H1GtQhtAhuFQ5o8a8WyrhSePPXNS
        c8LI+OzrjgKZBgCUleOMj28=
X-Google-Smtp-Source: AK7set9ZrPKQMflKE9FAcdRA6OMTf/PX2nTksgH3Pq9yhfjd3O7RYe9niQu9eNqYRtpJeYsbyxa5Gg==
X-Received: by 2002:aa7:9f44:0:b0:622:85e2:fb93 with SMTP id h4-20020aa79f44000000b0062285e2fb93mr12236994pfr.15.1678860880727;
        Tue, 14 Mar 2023 23:14:40 -0700 (PDT)
Received: from localhost ([98.97.116.12])
        by smtp.gmail.com with ESMTPSA id a17-20020a62e211000000b006247123adf1sm2711104pfi.143.2023.03.14.23.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 23:14:40 -0700 (PDT)
Date:   Tue, 14 Mar 2023 23:14:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6411624ee725f_4664d2087f@john.notmuch>
In-Reply-To: <20230313041619.394914-1-xiyou.wangcong@gmail.com>
References: <20230313041619.394914-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch net-next v2] sock_map: dump socket map id via diag
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently there is no way to know which sockmap a socket has been added
> to from outside, especially for that a socket can be added to multiple
> sockmap's. We could dump this via socket diag, as shown below.
> 
> Sample output:
> 
>   # ./iproute2/misc/ss -tnaie --sockmap
>   ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1
> 
>   # bpftool map
>   1: sockmap  flags 0x0
>   	key 4B  value 4B  max_entries 2  memlock 4096B
> 	pids echo-sockmap(549)
>   4: array  name pid_iter.rodata  flags 0x480
> 	key 4B  value 4B  max_entries 1  memlock 4096B
> 	btf_id 10  frozen
> 	pids bpftool(624)
> 
> In the future, we could dump other sockmap related stats too, hence I
> make it a nested attribute.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---
> v2: rename enum's with more generic names
>     sock_map_idiag_dump -> sock_map_diag_dump()
>     make sock_map_diag_dump() return number of maps
> 
>  include/linux/bpf.h            |  1 +
>  include/uapi/linux/inet_diag.h |  1 +
>  include/uapi/linux/sock_diag.h |  8 ++++++
>  include/uapi/linux/unix_diag.h |  1 +
>  net/core/sock_map.c            | 51 ++++++++++++++++++++++++++++++++++
>  net/ipv4/inet_diag.c           |  5 ++++
>  net/unix/diag.c                |  6 ++++
>  7 files changed, 73 insertions(+)
> 

[...]

> +int sock_map_diag_dump(struct sock *sk, struct sk_buff *skb, int attrtype)
> +{
> +	struct sk_psock_link *link;
> +	struct nlattr *nla, *attr;
> +	int nr_links = 0, ret = 0;
> +	struct sk_psock *psock;
> +	u32 *ids;
> +
> +	rcu_read_lock();
> +	psock = sk_psock_get(sk);
> +	if (unlikely(!psock)) {

wont this be the common case because we call this for any sk from
inet_diag_msg_attrs_fill(sk, ...)? Probably drop the unlikely?

> +		rcu_read_unlock();
> +		return 0;
> +	}
