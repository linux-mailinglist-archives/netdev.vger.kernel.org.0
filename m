Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06DB21936D
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbgGHW30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725903AbgGHW3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:29:25 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42E7C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:29:25 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id w2so23218pgg.10
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 15:29:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=12moK1imdj5+Kv/e3/hbcbYfop44kWkDJPAIBfHMbzI=;
        b=CXg4QWndiZ1ndhPGVVWhJ5xO8x4IFFqaZtXMAA5HQ7jdlSlmMPKhamADZH9vlVJeyH
         +FSpX7xcXLkSBX6rE4wz7icw/9dtyNmVPyxnxMaFvXN2g6iUs1qOVLesQuf4LB8m9bMo
         FxVpjOb8Oxo6nQ0stvPkJJmD6xoWtGubU5+PZOQnphiyJikGUQVtxRbg9DCcot+VCsr4
         h6f0jkuBufnTt2QgF4LLy+YhYnstmlje7PVX6TwLNK/91Glkdtp8qvpa2johh24x32Lo
         MatV0MoOZIOEDzdVUi9u6V4g9rqeGB3P5XF/twMDQok0nIYU/QC/cnpR66kAo3W0ZTUt
         uFKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=12moK1imdj5+Kv/e3/hbcbYfop44kWkDJPAIBfHMbzI=;
        b=GB6LvDacs2ixMaoTqMmJTMqDFq5KEPEAwteK56/CLXAcJieXgjotaUT8Xlh3a6W/TN
         7jTnzDDoerdsLwAcmQKrQAfht4FO13dVSPyN84LXIKsfZrz9u+/CUnj2hC4i8Zk5SWbM
         B28kVZA2F23GjT2QuIDYQun0p4m2hzEjZaNIfMAV7gjTMbWzlZihyUg3g0VO0CQgD4fH
         BLPyunUPj9pFLaAsVJkUBOrGFyMTn+r07JF2uvnHR1ZjHcROh0nkR2cJmtFNrtsdCKhs
         XMWmH4eWNsovY+0yxr6ab6eYq8vnA8dYT7/w5XHy0WmnHfuW9BB1dnEb5+L1fGep+efa
         70Bg==
X-Gm-Message-State: AOAM531zn8otiuHN2tjopQjHLDlGbwTJJmEgSojArPgUTFqZQdaY77f0
        7fTxA4dOKgRHidLBUjWEa7Q2IeYT
X-Google-Smtp-Source: ABdhPJwNupJ7TLBkHQhV8Rj3sjwrcspC6FNuCR+MvPpgUkWKJA03eV5ppJQ7ihd5DZeoDGpDMbJVrw==
X-Received: by 2002:a63:8f17:: with SMTP id n23mr53011860pgd.40.1594247364702;
        Wed, 08 Jul 2020 15:29:24 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w9sm709825pfq.178.2020.07.08.15.29.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 15:29:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <554197ce-cef1-0e75-06d7-56dbef7c13cc@gmail.com>
Date:   Wed, 8 Jul 2020 15:29:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 9:38 AM, YU, Xiangning wrote:
> Lockless Token Bucket (LTB) is a qdisc implementation that controls the
> use of outbound bandwidth on a shared link. With the help of lockless
> qdisc, and by decoupling rate limiting and bandwidth sharing, LTB is
> designed to scale in the cloud data centers.

> +static int ltb_enqueue(struct sk_buff *skb, struct Qdisc *sch,
> +		       spinlock_t *root_lock, struct sk_buff **to_free)
> +{
> +	struct ltb_sched *ltb = qdisc_priv(sch);
> +	struct ltb_pcpu_sched *pcpu_q;
> +	struct ltb_pcpu_data *pcpu;
> +	struct ltb_class *cl;
> +	int cpu;
> +
> +	pcpu = this_cpu_ptr(ltb->pcpu_data);
> +	pcpu_q = qdisc_priv(pcpu->qdisc);
> +	cpu = smp_processor_id();
> +	ltb_skb_cb(skb)->cpu = cpu;
> +
> +	cl = ltb_classify(sch, ltb, skb);
> +	if (unlikely(!cl)) {
> +		kfree_skb(skb);
> +		return NET_XMIT_DROP;
> +	}
> +
> +	pcpu->active = true;
> +	if (unlikely(kfifo_put(&cl->aggr_queues[cpu], skb) == 0)) {
> +		kfree_skb(skb);
> +		atomic64_inc(&cl->stat_drops);

            qdisc drop counter should also be incremented.

> +		return NET_XMIT_DROP;
> +	}
> +

> +	sch->q.qlen = 1;
So, this is touching a shared cache line, why is it needed ? This looks some hack to me.

> +	pcpu_q->qdisc->q.qlen++;

> +	tasklet_schedule(&cl->aggr_tasklet);

This is also touching a cache line.

I really have doubts about scheduling a tasklet for every sent packet.

(Particularly if majority of packets should not be rate limited)

