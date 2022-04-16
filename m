Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5E503493
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 08:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbiDPG7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 02:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbiDPG7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 02:59:08 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183B715FC5;
        Fri, 15 Apr 2022 23:56:38 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id e10so7960933qka.6;
        Fri, 15 Apr 2022 23:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=punmqzR82m/ivhuuKbOeeSpij9rdVwj6dBLRCcjDN2k=;
        b=i9cqRmdeTs/dXZI7D8kVcvX7nKhAwVdRcsrrwV0udpeEz8u7vILSkXeM6Y4ILBwLw8
         8vo5kZ1OpuvzjvqTf1HFeDTKoIjZ3dPKmhQboel8qI974hmxHwWLFUgsJNBUVEjw+Tc6
         kL2AsD9EAsTN+etwV5KUcpvxVUXCVNLj7No/z6ySWd/UQPvsJXld/Ne2ur4Qh5dZkDMs
         NVMTGlHHChISbR5xF6QAxi1kd9sFXWZxFSvDrV+fzbtmH4ROgYXbxibN+7iaiBKKMlo7
         csRB5we2ap8f6joUB0iF3pPQT1DiNQCDPjN73JxXkn/llWZ2F5PBI5wzgrcfeC3Jkjmb
         uaqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=punmqzR82m/ivhuuKbOeeSpij9rdVwj6dBLRCcjDN2k=;
        b=d9YExKATJmhUa09dPHJ6Zmh2X3Dg+7fJZ4rHiZNQMVK++ND8lNUV91qrN7+RJSjat5
         AMeM6xFXjyuvTwUJupKy8iO71JvPrahGF0S1kKV5WpK08H+UPVS1jD1V3eAy4OwNDUVC
         OyF949SW77fTndSDnBNfhvyyqH0CfvSSTnD+RCGMAAIB8VBAJ0tF2JOL2u03YCWr2Hem
         KsPyDVfG90k+g1Jf3DP5YUblO3sGiwQgIEXOQvRsA0aXGix54qMROc26sPUi/w9EUA7a
         oFUmPl3PTRdm4pMNxAed6lrAuaUE7A/qxhRxpJenevJUrCNy6ESKnG8IdFGN1VtDOscV
         oNlw==
X-Gm-Message-State: AOAM532Udbm/PoQV6QYLG3oULQK7xiscRQNbniZpbnPH/e6s/AUkCk6t
        RxaX/RRC6uTmwXE3If8gDQ==
X-Google-Smtp-Source: ABdhPJze666BWXOZ7v9o1b6NG80dduEFjgHheOq3DDDAfADinL6HdmzmCwEKN6ASVTQtu2Maih3mqA==
X-Received: by 2002:a05:620a:bd4:b0:47b:4c75:894e with SMTP id s20-20020a05620a0bd400b0047b4c75894emr1303721qki.425.1650092197189;
        Fri, 15 Apr 2022 23:56:37 -0700 (PDT)
Received: from bytedance (ec2-13-57-97-131.us-west-1.compute.amazonaws.com. [13.57.97.131])
        by smtp.gmail.com with ESMTPSA id d8-20020ac85d88000000b002f18ecfd221sm4087252qtx.82.2022.04.15.23.56.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 23:56:36 -0700 (PDT)
Date:   Fri, 15 Apr 2022 23:56:33 -0700
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Feng Zhou <zhoufeng.zf@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 2/2] ip6_gre: Fix skb_under_panic in __gre6_xmit()
Message-ID: <20220416065633.GA10882@bytedance>
References: <c5b7dc6020c93a1e7b40bc472fcdb6429999473e.1649715555.git.peilin.ye@bytedance.com>
 <9cd9ca4ac2c19be288cb8734a86eb30e4d9e2050.1649715555.git.peilin.ye@bytedance.com>
 <20220414131424.744aa842@kernel.org>
 <20220414200854.GA2729@bytedance>
 <20220415191133.0597a79a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415191133.0597a79a@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 07:11:33PM +0200, Jakub Kicinski wrote:
> On Thu, 14 Apr 2022 13:08:54 -0700 Peilin Ye wrote:
> > > We should also reject using SEQ with collect_md, but that's a separate
> > > issue.  
> > 
> > Could you explain this a bit more?  It seems that commit 77a5196a804e
> > ("gre: add sequence number for collect md mode.") added this
> > intentionally.
> 
> Interesting. Maybe a better way of dealing with the problem would be
> rejecting SEQ if it's not set on the device itself.

According to ip-link(8), the 'external' option is mutually exclusive
with the '[o]seq' option.  In other words, a collect_md mode IP6GRETAP
device should always have the TUNNEL_SEQ flag off in its
'tunnel->parms.o_flags'.

(However, I just tried:

  $ ip link add dev ip6gretap11 type ip6gretap oseq external
					       ^^^^ ^^^^^^^^
 ...and my 'ip' executed it with no error.  I will take a closer look at
 iproute2 later; maybe it's undefined behavior...)

How about:

1. If 'external', then 'oseq' means "always turn off NETIF_F_LLTX, so
it's okay to set TUNNEL_SEQ in e.g. eBPF";

2. Otherwise, if 'external' but NOT 'oseq', then whenever we see a
TUNNEL_SEQ in skb's tunnel info, we do something like WARN_ONCE() then
return -EINVAL.

?

> When the device is set up without the SEQ bit enabled it disables Tx
> locking (look for LLTX). This means that multiple CPUs can try to do
> the tunnel->o_seqno++ in parallel. Not catastrophic but racy for sure.

Thanks for the explanation!  At first glance, I was wondering why don't
we make 'o_seqno' atomic until I found commit b790e01aee74 ("ip_gre:
lockless xmit").  I quote:

"""
Even using an atomic_t o_seq, we would increase chance for packets being
out of order at receiver.
"""

I don't fully understand this out-of-order yet, but it seems that making
'o_seqno' atomic is not an option?

Thanks,
Peilin Ye

