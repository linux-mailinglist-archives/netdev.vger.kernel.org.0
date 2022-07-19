Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19EEB5793A5
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 08:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232167AbiGSG6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 02:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbiGSG6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 02:58:09 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1646E2A411
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:58:08 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id bp15so25419914ejb.6
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 23:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=pgMrFU+qEImV5jvhZKnhdxLHcWLuqCE+OAyoxG4pme8=;
        b=YbZYcppP9dA+6qz+j3MJQDbvZEOZiAHmbp42CjpwSYXGU0EoCZK1EKmmjObzd4dSjM
         3oWn2wIO7QVDAh4ROsod6+UfAHnX/VoIOBSYqqHZTf5BuQAxPUFvugznLVe8G/Z6Qija
         0Xmz/nKzdYJrwiHV3zLQmEAH/FUXIIeJaUoldEWbpK4/E4FG57WSEBTW2/7OQA3ITao3
         iOyVh3Zn9Ei8YAKMbb2tE/+4NdLJNdUhjUXdWBbVnTsT9FbDPhMmRG04UQFVFDIdQAu7
         dUiMlwp873B5xUCNZQOMoEgYkaUqgK6OJI5TSOwB9X00HdEwNVxPTTAJ9BEbZJ5Qz9VB
         l1/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pgMrFU+qEImV5jvhZKnhdxLHcWLuqCE+OAyoxG4pme8=;
        b=7D8DmwSi/3ofcjeptN3JPOQcZ2oiR8H+YJA7B3XVRhJTv28S8V9TSK8oMhqZX6H4MI
         jqXFXKG/xKNKbf/XtksJzGoRt9AHqy6C9AlZ47bcANP24BaQCnuqDh8TwR/w5MjBQNlB
         mDbxy7OZKVmJHp1e56CyVAPM4aYv4rhjRDE6qjR89mVpG9sm5qu/Ud+Ef7p/MQBkJHtK
         CTCf8yRKX61anDYlYbtdaffDIWMh22Y5oiXVG1O/YTc9qH83+z85ZPN9w1iB64nFnNyA
         YJcqC8nQZ6LbfDmnaQsBVQBZ23XyMiRixdJtYpcAr4S+nmSCn43Yqo05WgW5JrLgURWL
         E48Q==
X-Gm-Message-State: AJIora8s0nbBVWDA6qZit1S2wwnLm11F70TK5FvMQVJSP1BlRhHTRvUw
        Kw66zcMZ6KGUhU2y5NFuld35Cw==
X-Google-Smtp-Source: AGRyM1sNzzERn6owpOTMShEzVYzNg/n5kCxLDXLcQTwEu1yNAn2Ba1efmwHv6gwPSuECam1564pBsw==
X-Received: by 2002:a17:907:a061:b0:72f:1dde:fac0 with SMTP id ia1-20020a170907a06100b0072f1ddefac0mr11956591ejc.310.1658213886393;
        Mon, 18 Jul 2022 23:58:06 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id 2-20020a170906218200b0072f441a04a6sm1348851eju.5.2022.07.18.23.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 23:58:05 -0700 (PDT)
Message-ID: <75d3ee98-a73c-16c5-2bb3-f61180115b29@blackwall.org>
Date:   Tue, 19 Jul 2022 09:58:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH bpf v2 0/5] bpf: Allow any source IP in
 bpf_skb_set_tunnel_key
Content-Language: en-US
To:     Paul Chaignon <paul@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <martin.lau@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        Kaixi Fan <fankaixi.li@bytedance.com>,
        Yonghong Song <yhs@fb.com>
References: <cover.1658159533.git.paul@isovalent.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <cover.1658159533.git.paul@isovalent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/07/2022 18:53, Paul Chaignon wrote:
> Commit 26101f5ab6bd ("bpf: Add source ip in "struct bpf_tunnel_key"")
> added support for getting and setting the outer source IP of encapsulated
> packets via the bpf_skb_{get,set}_tunnel_key BPF helper. This change
> allows BPF programs to set any IP address as the source, including for
> example the IP address of a container running on the same host.
> 
> In that last case, however, the encapsulated packets are dropped when
> looking up the route because the source IP address isn't assigned to any
> interface on the host. To avoid this, we need to set the
> FLOWI_FLAG_ANYSRC flag.
> 
> Changes in v2:
>   - Removed changes to IPv6 code paths as they are unnecessary.
> 
> Paul Chaignon (5):
>   ip_tunnels: Add new flow flags field to ip_tunnel_key
>   vxlan: Use ip_tunnel_key flow flags in route lookups
>   geneve: Use ip_tunnel_key flow flags in route lookups
>   bpf: Set flow flag to allow any source IP in bpf_tunnel_key
>   selftests/bpf: Don't assign outer source IP to host
> 
>  drivers/net/geneve.c                                 |  1 +
>  drivers/net/vxlan/vxlan_core.c                       | 11 +++++++----
>  include/net/ip_tunnels.h                             |  1 +
>  net/core/filter.c                                    |  1 +
>  tools/testing/selftests/bpf/prog_tests/test_tunnel.c |  1 -
>  5 files changed, 10 insertions(+), 5 deletions(-)
> 

Looks good, for the set:
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
