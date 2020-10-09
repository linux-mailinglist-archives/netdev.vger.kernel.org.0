Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6554D288102
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 06:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgJIEF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 00:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgJIEFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 00:05:49 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8902C0613D2;
        Thu,  8 Oct 2020 21:05:47 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id f37so7762094otf.12;
        Thu, 08 Oct 2020 21:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rKmOpxLKn+fUEFJJdu19a0RxfbC1QrKPlHniKalLJM8=;
        b=ZKhI1VxOZ8UmgnlvJBCR2ft7QBPGwgy+q/1ZxtsubVfT1yRuzeOonRm6Zf/K2SDOuk
         RpaQ6jgH/WOo2Dd+4Wnh96eGyr4GxEKOGJ5NMflTyQCNbzv6pjv2kZXkhPSi43v7zbm+
         LjsPFDBxlRqXVmlLOr+vrP2Alvpv3ZCAaoaW3lEiirvy2J79CIcuI/TgO8VxfCUQH39P
         WB9eKZcuYD9kJjLlu2sTUmU6FEDC7lLijcLZ+KvBvW7Z5S4KSjbEGCoEAc/mBF/hAJxc
         7cJ25Xz1+augKZ+j0zYxuQfi8Ls4ov5ifAcmWkffoGjD8cCNAL1pT4uLGUAzuXss7rVK
         rUgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rKmOpxLKn+fUEFJJdu19a0RxfbC1QrKPlHniKalLJM8=;
        b=F8jq5P6z+gVsD0kIwgs7Ay0C+zoUNrsW2oTuKko/i0URPfkNDpUATJ7Znt791R4+55
         Ya4gSllncWXNOjHb6hlfu7r5B1zAlUl8lcTl/THOKrd6zYgFfYHJT+8ctKp1/nfrSuAy
         7KPgePRQfchJWQiFgaeuTWUIReuF1UwvxmU9hhG2igcCNxvIA/frg0Bl0z7lCtNFMOCR
         qhcrZlAIhFMAErfXsJUEfatEBYlE78oKRbxxgH1Wd+MCfd/0D0DH63bvqqxPzzJBSvvR
         Nl7RvUbpqeUFV/4J5obmqa3MUsqKjdjcTufwFOxLnylDhe9oRM9JBZ/3MI5ckfBUtHwA
         +gng==
X-Gm-Message-State: AOAM530VPJbxta//mi9W3P49QV8zIAQR8IHMuXdDfdlGo9baikgKUKuv
        DiOwtLp674zq3D7njk2pbXTcNkyKVgE=
X-Google-Smtp-Source: ABdhPJx498pAuqlafcgDN61i5NNqbTLZF9PDK9gfPDOFzF1Vy58xzhNqzwIOZwdE59jVbRdWRFZ7kg==
X-Received: by 2002:a9d:3aa:: with SMTP id f39mr7757117otf.29.1602216347227;
        Thu, 08 Oct 2020 21:05:47 -0700 (PDT)
Received: from Davids-MBP.attlocal.net ([2600:1700:3eca:200:c514:e4f4:762:f7df])
        by smtp.googlemail.com with ESMTPSA id y4sm319458oou.38.2020.10.08.21.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2020 21:05:46 -0700 (PDT)
Subject: Re: [PATCH bpf-next V3 2/6] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
 <160216614748.882446.6805410687451779968.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d06ee8a0-79f1-d9c7-ba16-e25f97736c0a@gmail.com>
Date:   Thu, 8 Oct 2020 21:05:44 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160216614748.882446.6805410687451779968.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/8/20 7:09 AM, Jesper Dangaard Brouer wrote:
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
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   11 +++++++++--
>  net/core/filter.c              |   17 ++++++++++++-----
>  tools/include/uapi/linux/bpf.h |   11 +++++++++--
>  3 files changed, 30 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

