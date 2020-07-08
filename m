Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D208821931C
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 00:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGHWI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 18:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGHWI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 18:08:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A745C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 15:08:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id e8so12318pgc.5
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 15:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=+gbI8N1SxnTHnSqeWcxGK2BNSatylc/hgRVmL7x1pxA=;
        b=l3OzAUW/8VAapMNw9WkqEox91I3aMynfLGRTfycQ0UtRYkfmKQwUbLmg8DiLUS0Sqo
         jkbl/iMPurB7XAH/T7t58d0k26CerUdbw55VDvaeh2/4iy2XVao68VUazs6JVWb4EYkb
         j8mEyW3VInMnTQyfHddxzqNAi7K5Hne90UHuZeF5NAfsewclaUZN2FyasKrG1GQqFH8v
         HOulROxUYCPuWQAs+PQ+nTnnHI34CkVnJtrNmbC43Q10BnhdA3m/eQrI8QvYzM0z+bxQ
         P3az1YYkjMQw+JXccZ1RkZuI2TpJqpZhcNMWLyvNTJr3gEN30zjo+FhF/+KpTde1bFPD
         Z4AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+gbI8N1SxnTHnSqeWcxGK2BNSatylc/hgRVmL7x1pxA=;
        b=nuu4eLVmtDCdu05FY8nnHb0qgQovzWjYLSvlHZxgllyFAPmK2SvUe/HukEwMlvaISJ
         GAcQ59260PkMBfS8JOHK9yFzkFYdj7ba04HqcwjLTYMT6lDfstN9Igds1aAdHV/sT0h+
         eadnuEw9M359xybtA2jdAlXg6doMJ6iGEQiBgdycIgVQMTVTivmNAVbL/WlZLopka2SI
         faIcbrXfw1VPtBZ5knuCyaTqRc4kjvMHLdtFhiLI4btlt0ZwAiFRbXm0REpmncjfLm6w
         vA1KAlDMYJ0UcIHOoULM/YSZqhXwTPkCoMCfaOtLTRSmQ3HLGRMXVa2iY7JJR0Sk5/yJ
         4Vmg==
X-Gm-Message-State: AOAM531/tUt6PK5I67sEnDyenfZgof2JlM8gXCDcBTrqdvppQrux3c5j
        O3KmwRH9cOPmhEM6oa8eqAJxQCGG
X-Google-Smtp-Source: ABdhPJwbFAbbI9Hd0V/DMZxr36uFvUFB6/CFNRInZN+bxVwCwprGGxLFsqqFYvjgG7xDevykFQ/ssQ==
X-Received: by 2002:a05:6a00:4f:: with SMTP id i15mr24664704pfk.93.1594246105784;
        Wed, 08 Jul 2020 15:08:25 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d65sm672079pfc.97.2020.07.08.15.08.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 15:08:25 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] net: sched: Lockless Token Bucket (LTB)
 qdisc
To:     "YU, Xiangning" <xiangning.yu@alibaba-inc.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <4835f4cb-eee0-81e7-d935-5ad85767802c@alibaba-inc.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bdb18ae2-8488-d443-4a57-1ecb39d8ce35@gmail.com>
Date:   Wed, 8 Jul 2020 15:08:23 -0700
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
> 

> +
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
>

Silently dropping a packet in a qdisc is forbidden.

Instead we always make sure to increment a counter, so that "tc -s qdisc" can give a clue.

qdisc_drop() is how we handle this.

Then, you might hit an issue if 5,000,000 packets per second need to be dropped.
(So you will probably need per cpu counters)



