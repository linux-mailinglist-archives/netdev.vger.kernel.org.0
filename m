Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B71D5FCC40
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 22:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJLUm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 16:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbiJLUm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 16:42:27 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFA210B788
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 13:41:44 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id u71so9004752pgd.2
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 13:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SppwEkcvWOPeltbOIlm2QfiW9L8NWtUYGk7H5RN7E4o=;
        b=oyDifa+Vsg1QsTXxPtUI8drSBMtWnynlcPDf75aU4tbbb1Z+qww9H/oEMGIynpPvCc
         rjbIEFvxk57kc7YmZJ033TrlutXSfvoXOQyJAbCTECMfg+oPEFGioGWfTPjbM4b8qmk2
         0TvWw1mS5Fg71FOYyLsDSqziRzCO1H63XZZQ1m59LjUxH0rKeQ5cTbjsg0KtwrkbqzWT
         hOAuzYgA6u4jy5rcXNhzZlL7VwncsnSwiN5U3yZtfRwUH18CwwiAJKuMsYj4MEvaRW7+
         4q1WuO7xtZLHpK7djwya2n6N0IN/p0a8xTwELYGY5j9GZO6cU1w6HXVwYfaIZk64tObP
         r9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SppwEkcvWOPeltbOIlm2QfiW9L8NWtUYGk7H5RN7E4o=;
        b=v0C82+G9pVFXQWHnxcfMtJOcINWs4uddciVQZn5QXXCiI+6iYZu+bfLi+Ul1Ginyq+
         qAdQhoM53LZO6mnXUHfXqQsG521zeWaxEzY9w4hXM6N6ysITKMc9YptfRBh1WQ9w6T0A
         6PVV/DbWhLOUmGGoBTPum9StrZkBs9PJ/T61WLOYNukd4k4gXo+PGK/fE+rZNt/Mo7Ca
         Uj6zHuKRwyWfaXAjgPfDvj/8Q+Ec5KKMNg0XRB61ezZBhRzDSgSB5n/U7k6AxHIXGID6
         LyipR62E01M+vK/TbyWgEwNdTJcxWWDL28MaYe+2AussG1+WqkMb9WsXgdJ8zqj2qOGT
         a20Q==
X-Gm-Message-State: ACrzQf0NpBYiUJGJo+msr1Zsen7GwhNynY8uLGiFOpLN+xY3umn0w5Z5
        lT8BR7BWc8ycR8bwwzEiTdthLkOz68Q=
X-Google-Smtp-Source: AMsMyM610NAjjPkqNK88BuAbyJeskkNQ/BOeulVEqIc8nTIsfXRIfSm//HEZjxtylRbrqtVATFmftg==
X-Received: by 2002:a63:440d:0:b0:43c:5e0:121f with SMTP id r13-20020a63440d000000b0043c05e0121fmr27686362pga.617.1665607301149;
        Wed, 12 Oct 2022 13:41:41 -0700 (PDT)
Received: from ?IPV6:2620:15c:2c1:200:9517:7fc4:6b3f:85b4? ([2620:15c:2c1:200:9517:7fc4:6b3f:85b4])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a784e00b001ef81574355sm1796349pjl.12.2022.10.12.13.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 13:41:40 -0700 (PDT)
Message-ID: <3660fc5b-5cb3-61ee-a10c-0f541282eba4@gmail.com>
Date:   Wed, 12 Oct 2022 13:41:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: RFH, where did I go wrong?
Content-Language: en-US
To:     Thorsten Glaser <t.glaser@tarent.de>,
        Dave Taht <dave.taht@gmail.com>
Cc:     netdev@vger.kernel.org
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
 <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com>
 <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de>
 <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
 <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
 <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <8051fcd-4b5-7b32-887e-7df7a779be1b@tarent.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 10/12/22 13:17, Thorsten Glaser wrote:
> Dixi quod…
>
>>> I'll take a harder look, but does it crash if you rip out debugfs?
> […]
>> And yes, it (commit dbb99579808dcf106264f28f3c8cf5ef2f2c05bf) still
>> crashes even if this time I get yet another message… all of those I
> I may have found the case by reducing further. Disabling the periodic
> dropping of too-old packets wasn’t it, but apparently, the code now
> guarded by JANZ_HEADDROP is it. Replacing it (dropping the oldest
> packet returning NET_XMIT_CN) with trivial code that rejects the new
> packet-to-be-enqueued with qdisc_drop() instead… seems to not crash.
>
> So, the code in question that seems to introduce the crash is:
>
>
> u32 prev_backlog = sch->qstats.backlog;
> //… normal code to add the passed skb (timestamp, etc.)
> // q->memusage += cb->truesz;
> if (unlikely(overlimit = (++sch->q.qlen > sch->limit))) {
> 	struct sk_buff *skbtodrop;
> 	/* skbtodrop = head of FIFO and remove it from the FIFO */
> 	skbtodrop = q->q[1].first;
> 	if (!(q->q[1].first = skbtodrop->next))
> 		q->q[1].last = NULL;
> 	--sch->q.qlen;
> 	/* accounting */
> 	q->memusage -= get_janz_skb(skbtodrop)->truesz;
> 	qdisc_qstats_backlog_dec(sch, skbtodrop);
> 	/* free the skb */
> 	rtnl_kfree_skbs(skbtodrop, skbtodrop)

This looks wrong (although I have not read your code)

I guess RTNL is not held at this point.

Use kfree_skb(skb) or __qdisc_drop(skb, to_free)


> }
> //… normal code to add:
> // line 879-885 enqueue into the FIFO
> // qdisc_qstats_backlog_inc(sch, skb);
> //… now code protected by the flag again:
> if (unlikely(overlimit)) {
> 	qdisc_qstats_overlimit(sch);
> 	qdisc_tree_reduce_backlog(sch, 0,
> 	    prev_backlog - sch->qstats.backlog);
> 	return (NET_XMIT_CN);
> }
> // normal code remaining: return (NET_XMIT_SUCCESS);
>
>
> This *seems* pretty straightforward to me, given similar code
> in other qdiscs, and what I could learn from their header and
> implementation.
>
> TIA,
> //mirabilos
