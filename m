Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC2119B998
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 02:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732872AbgDBArM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 20:47:12 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38269 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732527AbgDBArM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 20:47:12 -0400
Received: by mail-pf1-f195.google.com with SMTP id c21so910143pfo.5;
        Wed, 01 Apr 2020 17:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gKLfRHXqeC/oi2xP24lA0VxkwaXTW253NCEpbDodjM8=;
        b=TQ5U5WQwnl6uazN/fdbqBwcYVhvaEdWSkMdvsbnu3CIQe9EtEnej6O1oUa2hLwpMyI
         WjaCa5H/8AG8MYT1bUp2cQryZgIU73eqS953Nng2zR/9xGGxnpO7rTw4X0jXLB6hwkiJ
         uwa3Yhd1bztdbxwwUFFoIzC+r1z2uc5Fdgk4ZkX81lZitAZdNeYKrzRKtdmkLwCHzuVQ
         aNQml7SPwtnlHWSbbNUf+NOtcRxM0N36tKc5l10vgoCTU8Sf+FTwQ1KCoRxS6JcNAnlR
         V85JKyQFo9nqRfVL4kMjlaOTWGCXr5qMc4w9jKsZr69iKvFYeXknjB0B3+rLE3G6BAI8
         G4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gKLfRHXqeC/oi2xP24lA0VxkwaXTW253NCEpbDodjM8=;
        b=UMMgse8FaQ7XjiyquOtZ8+rPcjFsBer4PmBMo9rcbYtokvMRaccc9W930X5CpdOCNW
         KBXREQAtvCj+TeFuaPlTQOIHwj8N2rid+XDPaRx2QF2V8y6nr6E0Ux0C8izCGOpw66qj
         rz+sb7Kw0lOmLFmzy3bfr+uE5DFv38iJRmkpL3G6itmGMwUdvJ5qdeE93sXiBXlE5KZJ
         RQCKTny4PpGvAoSoSQzBDedLU7OIA/IPzyppo0nwelS/pxP0EreawInUupbI/PBGO3EI
         cuAs1qkTllfUBfNkWm1KDoOQ5NHTQM7mlBVf/vtWArYA10ClsaEJXNGGwE+J9KXCL2kx
         UWgA==
X-Gm-Message-State: AGi0Pua7NJ2lI2OOyd2RjXEH+eNqo8FHEM6QNekZZQZtBXGsnrXqEOnl
        OeASkG6SJgz+qd+Ziq+zDZz3VyAo
X-Google-Smtp-Source: APiQypJUo1ChJEV935jbuqqDGBmqOSPXf7PQPaGev8X1QugSrNwjI99o4UN3g6xKqwJEPMoQZ5fpxA==
X-Received: by 2002:a63:5fd8:: with SMTP id t207mr873597pgb.186.1585788429294;
        Wed, 01 Apr 2020 17:47:09 -0700 (PDT)
Received: from [192.168.1.18] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id 63sm2451755pfx.132.2020.04.01.17.47.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 17:47:08 -0700 (PDT)
Subject: Re: [PATCH net v2] veth: xdp: use head instead of hard_start
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Mao Wenan <maowenan@huawei.com>, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        jwi@linux.ibm.com, jianglidong3@jd.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <fb5ab568-9bc8-3145-a8db-3e975ccdf846@gmail.com>
 <20200331060641.79999-1-maowenan@huawei.com>
 <7a1d55ad-1427-67fe-f204-4d4a0ab2c4b1@gmail.com>
 <20200401181419.7acd2aa6@carbon>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <ede2f407-839e-d29e-0ebe-aa39dd461bfd@gmail.com>
Date:   Thu, 2 Apr 2020 09:47:03 +0900
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200401181419.7acd2aa6@carbon>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/04/02 1:15, Jesper Dangaard Brouer wrote:
...
> [PATCH RFC net-next] veth: adjust hard_start offset on redirect XDP frames
> 
> When native XDP redirect into a veth device, the frame arrives in the
> xdp_frame structure. It is then processed in veth_xdp_rcv_one(),
> which can run a new XDP bpf_prog on the packet. Doing so requires
> converting xdp_frame to xdp_buff, but the tricky part is that
> xdp_frame memory area is located in the top (data_hard_start) memory
> area that xdp_buff will point into.
> 
> The current code tried to protect the xdp_frame area, by assigning
> xdp_buff.data_hard_start past this memory. This results in 32 bytes
> less headroom to expand into via BPF-helper bpf_xdp_adjust_head().
> 
> This protect step is actually not needed, because BPF-helper
> bpf_xdp_adjust_head() already reserve this area, and don't allow
> BPF-prog to expand into it. Thus, it is safe to point data_hard_start
> directly at xdp_frame memory area.
> 
> Cc: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>

FYI: This mail address is deprecated.

> Fixes: 9fc8d518d9d5 ("veth: Handle xdp_frames in xdp napi ring")
> Reported-by: Mao Wenan <maowenan@huawei.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

FWIW,

Acked-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
