Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 257492A18A2
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgJaPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 11:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727867AbgJaPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 11:52:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E888C0617A6;
        Sat, 31 Oct 2020 08:52:40 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id q1so9175773ilt.6;
        Sat, 31 Oct 2020 08:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qOPt4BECPdA3YISIeZuCSrNm7VpOf59xjoy7hduu96M=;
        b=guuU9AcLClZ14Z6yaYzC2sVsSZrrOL7gAqwt1FBX5R5ucqJypqE61w8zO2vJJ+R5OP
         Msy89p3jTvkSuIxtLltuBascrDqcqIxt6MjvsxmVCQN4Lmg/4p9uSkrzeafP0J0WU5cw
         nmwBNHUrtJ5IzBcLiPK+undMICSAMO1PS6XcBwoQclNCTkkHRlLeqbD8P1VyC4CM4782
         phyXsVXeUayKR7/vXW1uHl/AOhCYylBs/+DzYo+gSbo/8oA6Av7XyCEeEUzXu4A2z2yF
         rywTzwZ6CltfmD7m6Fr7GMdiM32IQyFu0yRqoKoKdiEsgKvrV36vMdLY1PPU//40gbA2
         OKmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qOPt4BECPdA3YISIeZuCSrNm7VpOf59xjoy7hduu96M=;
        b=ihBiBFBP6m69SkfK76KIa5blzZccBfR/B/rywNsMzHEKIadqkhYWckBS3E1hgXz+cf
         u9SOF52k11u+ty02amlH/X6NpW7KzfQRpDlXYS6PYUo7kgXJer1i6YMVcG5T9m8AizDy
         o9heOMERbSFsJ/wIn0p2V+VsZ6sW2gvvstzXLtXy2rdXjpe0fUzx2jxd/uVoWViLn3/R
         Q3aluHUIMEPdOCTUKdkFMkXW659IKWED7tbaLxvyCSuUZGOSGKDXa5LVOXc0WVpAm6E0
         jJZvuMpjp+xQOwYmd/kW3cfC8tKSMMBj6yUeesqtfVkK8/0Z6DOCKkj09ddfA22BP/Ab
         bTKQ==
X-Gm-Message-State: AOAM530cnVTqPnFDGikY8lcjwyPKXLLiHVObZfY5T9wCE1+5gCR1JVyR
        NdQHfD9FjzSE0AdfklBzlDs=
X-Google-Smtp-Source: ABdhPJwJ4750X04UhtyNtvyS2fPKOWFOKQXO5wkY5SX0ip8jCRsKoe1BWA1+jXFZ59Y1A1yk6qr/Sg==
X-Received: by 2002:a92:4a02:: with SMTP id m2mr5432246ilf.51.1604159559987;
        Sat, 31 Oct 2020 08:52:39 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:10cc:b439:52ba:687f])
        by smtp.googlemail.com with ESMTPSA id w22sm6317579iob.32.2020.10.31.08.52.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 31 Oct 2020 08:52:39 -0700 (PDT)
Subject: Re: [PATCH bpf-next V5 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160407661383.1525159.12855559773280533146.stgit@firesoul>
 <160407665728.1525159.18300199766779492971.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7a836323-3f22-0143-3f12-cc67fd9a43a6@gmail.com>
Date:   Sat, 31 Oct 2020 09:52:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160407665728.1525159.18300199766779492971.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/30/20 10:50 AM, Jesper Dangaard Brouer wrote:
> The BPF-helpers for FIB lookup (bpf_xdp_fib_lookup and bpf_skb_fib_lookup)
> can perform MTU check and return BPF_FIB_LKUP_RET_FRAG_NEEDED.  The BPF-prog
> don't know the MTU value that caused this rejection.
> 
> If the BPF-prog wants to implement PMTU (Path MTU Discovery) (rfc1191) it
> need to know this MTU value for the ICMP packet.
> 
> Patch change lookup and result struct bpf_fib_lookup, to contain this MTU
> value as output via a union with 'tot_len' as this is the value used for
> the MTU lookup.
> 
> V5:
>  - Fixed uninit value spotted by Dan Carpenter.
>  - Name struct output member mtu_result
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   11 +++++++++--
>  net/core/filter.c              |   22 +++++++++++++++-------
>  tools/include/uapi/linux/bpf.h |   11 +++++++++--
>  3 files changed, 33 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
