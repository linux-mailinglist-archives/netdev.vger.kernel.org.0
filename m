Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC8329C0FB
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 18:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818000AbgJ0RQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 13:16:48 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43554 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1817367AbgJ0RPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 13:15:35 -0400
Received: by mail-io1-f67.google.com with SMTP id h21so2350262iob.10;
        Tue, 27 Oct 2020 10:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UNZZEUo7M3Py+N4O575RWXsyVUJ1PdLqmuN8Dya1LYg=;
        b=nEM8WngeKxQWl7pJraFvnO0/aEHZzGQVcIydUu+B66VjxG2JwBDTxnLzg6CIAeRqzT
         JDoxLLrcKO8Y9T17m+u+kDfPD/qHHP8MRtZlwkPDJ0xQ3EhAEAwJbBo3JUoEB/Yv346x
         wKRWKBzJTy+EtIKTw2L8d2sDJowgfPCb6mhUUfiNAkfloakMMgPv58utYueo8SxMtquw
         /l7IAQGaOCdxflyPDjWhS230qiOuUig3rbVFnFgczz3sm5x09M6c9kwVDGozywv2GHs1
         MtcoAq1eYJQ3qpsyb7+yw8mcvFWL5KcXfFra6lqvdtZfYFW1bM0YC6GML2r5SFHn3y6T
         Qmqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UNZZEUo7M3Py+N4O575RWXsyVUJ1PdLqmuN8Dya1LYg=;
        b=NNB5GssRMl35GuX1otetUtFlTDZ3MFNYeCtHYOulv6JX4g3ZZuGVT52/yJvfY9LRQV
         mI652LpPv6g65tOS1YLIKXVoTli9T8xnqMjXM11nOKk397a9A1W/J7FA8Mr6GP9T6q5q
         HusjLYXV0/CMQgk3yfr1lBNmXXRteZH3YDVsOeSj0QIQyevqmTRuqhgK18SowlN4kqFJ
         U4iIZDe564jOvpF1xo7Rb1W2JFU62daHFeZmLxLqen3KRLXttAZv5jgPgfkhWVqdDJot
         bo0GH41wLdMEeZ+W1doA5WTyp8lUALYRpPPYHB2eQ+Dt+F2sV2Bb4w3k46T0cEdMcesy
         36Jw==
X-Gm-Message-State: AOAM533pOkaK+4YXkZ2Xb+SaQdApRXEQlE0gSLdKTqWynJrPx4r25DHP
        NOmm9wmmnsfNYkU69KMXVWA=
X-Google-Smtp-Source: ABdhPJxYpiS3Fhm2fn7zgSeQ/jwT8hDriulsc8LCKsMqBUxWubgu4PQf39G3i7mPwG36TQJ7aUXqTA==
X-Received: by 2002:a6b:f401:: with SMTP id i1mr3161062iog.130.1603818934261;
        Tue, 27 Oct 2020 10:15:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:f994:8208:36cb:5fef])
        by smtp.googlemail.com with ESMTPSA id e4sm1285847ill.70.2020.10.27.10.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Oct 2020 10:15:32 -0700 (PDT)
Subject: Re: [PATCH bpf-next V4 2/5] bpf: bpf_fib_lookup return MTU value as
 output when looked up
To:     Jesper Dangaard Brouer <brouer@redhat.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
 <160381601522.1435097.11103677488984953095.stgit@firesoul>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b41f461b-ec5b-edb0-d69d-b413e93359de@gmail.com>
Date:   Tue, 27 Oct 2020 11:15:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <160381601522.1435097.11103677488984953095.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/27/20 10:26 AM, Jesper Dangaard Brouer wrote:
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


Reviewed-by: David Ahern <dsahern@kernel.org>


