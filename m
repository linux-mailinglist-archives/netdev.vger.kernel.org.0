Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094C3353C60
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 10:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232326AbhDEIZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 04:25:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhDEIZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 04:25:37 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CA3C061756;
        Mon,  5 Apr 2021 01:25:31 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso7245816wmq.1;
        Mon, 05 Apr 2021 01:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H/0+G/p8tUP3jzEhCTql+Tw550CCeXnthrGtXnd5hkc=;
        b=CcRc/YfsGwQ/cB/zZ+QTzebFyTwuDoomeOxOi4ogiMaMnu+cu0e2azaM9KyCOP86Cr
         ExlgKSc+8sEvEeajKxKZVLj06I+J7eZzagIQdR8aS8FYIHGpvSUVq5ApT2rzLzNsC+Y5
         8nzvfSiSEmvC9roOYPM2IOmzaLhcjwCTS/lZySKNWEpC5hHiuZI/nGpn07c+YwZ88roc
         m3na9LFsjOuTAukgzDe3vg0mERtdTFE3b3wuIXBpIOWctL1Jf9lcrL5NSGz8HQsQ80ex
         rftbjfn9EUgA91b8ikRfsCY2REcG45ayIad3cexwyguKQvUF+fKgtFf1pEo+7Ro9AARR
         uSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/0+G/p8tUP3jzEhCTql+Tw550CCeXnthrGtXnd5hkc=;
        b=cGS1MpQpxFA8o4N8qGJAgpAVUCTP7rttepseX3VxzjUaVjz7tlU1LiESEvj7PitJcX
         RmprFc5XeFPxk2WM4VPH7eEJgc2pLHmtw9cbUqVL4sJuKMOqr/dAYUEBq7pxQ/diVTHV
         eiGU5QYu7pSdYJ1DZlxBM7tvL0mHuOcrDD6XzCZNyAIPZeGRaUR2djpdaw+ET5U0X8zs
         UIzIVXI8RyDAQzfXmERECUQBtPYBLlPon9LeW/d+zU08imwj1ZuCUz/79QYLSVdgIekZ
         TUd7rKRV9+4NDD7WYxTZQ+JLTPjHQfnXUwni3vOt5CyvvDlMHJT36NmjndCdMS9CGnyu
         X8NQ==
X-Gm-Message-State: AOAM530caRtWzIlObPxCed0OAqZWcNlPEPGmjTilhWkN7rDMdma//BzR
        bM3ym4ZbtflValOC095XORM=
X-Google-Smtp-Source: ABdhPJwXb76ryddMPep8c1GXTtSARX0Xzwralvoy60CdRCp6u+pryVASJkFxk/ZM4/1jJVB51O9TCw==
X-Received: by 2002:a1c:750d:: with SMTP id o13mr24190507wmc.76.1617611129962;
        Mon, 05 Apr 2021 01:25:29 -0700 (PDT)
Received: from [192.168.1.101] ([37.170.219.60])
        by smtp.gmail.com with ESMTPSA id o14sm17172857wrh.88.2021.04.05.01.25.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Apr 2021 01:25:29 -0700 (PDT)
Subject: Re: [Patch bpf-next v8 10/16] sock: introduce
 sk->sk_prot->psock_update_sk_prot()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-11-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1aeb42b4-c0fe-4a25-bd73-00bc7b7de285@gmail.com>
Date:   Mon, 5 Apr 2021 10:25:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210331023237.41094-11-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/31/21 4:32 AM, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently sockmap calls into each protocol to update the struct
> proto and replace it. This certainly won't work when the protocol
> is implemented as a module, for example, AF_UNIX.
> 
> Introduce a new ops sk->sk_prot->psock_update_sk_prot(), so each
> protocol can implement its own way to replace the struct proto.
> This also helps get rid of symbol dependencies on CONFIG_INET.

[...]


>  
> -struct proto *tcp_bpf_get_proto(struct sock *sk, struct sk_psock *psock)
> +int tcp_bpf_update_proto(struct sock *sk, bool restore)
>  {
> +	struct sk_psock *psock = sk_psock(sk);

I do not think RCU is held here ?

sk_psock() is using rcu_dereference_sk_user_data()

>  	int family = sk->sk_family == AF_INET6 ? TCP_BPF_IPV6 : TCP_BPF_IPV4;
>  	int config = psock->progs.msg_parser   ? TCP_BPF_TX   : TCP_BPF_BASE;
>  

Same issue in udp_bpf_update_proto() of course.

