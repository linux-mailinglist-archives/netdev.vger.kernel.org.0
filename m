Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51A0311ECCD
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 22:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfLMVXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 16:23:24 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38456 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfLMVXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 16:23:24 -0500
Received: by mail-pj1-f67.google.com with SMTP id l4so257634pjt.5
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 13:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7K4ZPRATy9FX7oWCnvQVOCbUAOP3nMuBpfa7ngyX+Gw=;
        b=n9pMMLnM+e64NEP/V9EDRnRdUsHr4e4OpQj/kWGzrwU0zr2Pg8rAgU9QjIWGw/wcaL
         Tn1V9Ca04mROYvlvMGHAcTHDrT7p79HHSN6IoL1KfPp+sIumVjhDpaNGy43MOgP4V/X0
         nU3QndMVcGZ4aX0z/flvEAwNmbih5MPI4K6T63u21F0x3TgDayATaRJ1Gtegbi6h5VLb
         SXtlJfo+RNSpsgkOuue+arupzV2UeCDyAsOuUt5eEm0pYbdV7rGbJt+O9Pika39O1uXq
         IsqnAVhDW0KiSn6mF7n8OwoqHbIwEohaI8Ei+kxBUVtVRaiJpn7sOdM/ZU1uKQmrw4+w
         q9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7K4ZPRATy9FX7oWCnvQVOCbUAOP3nMuBpfa7ngyX+Gw=;
        b=MO5BIB+EnbNZIzuvV1Rf5yQRC+SAEeuWZdD73iQf5zFTFH5M/HGLIDHJ63blsLGdhE
         8+xnRYwjjg36I2pABzHV5SLW7uuQ9H+mK2PD8xlUWaaYla94CixJFLnXTNZKzUsSOfUK
         3xLkIAvd2iarijeWe2sw5vevyspWdqg+5d71oiwU9yySBOxS6qpkEa3fS5HupoMY8CDO
         GwFlk8fSQw6HflACo53DjHzsx/nchaq+KW4Fg1vpXxjOfoGNp1qIAGJVp+Zwu0r4RQ9v
         Fv03lHlkUn3vwjcyEu9m6n0fd8MyU8sFfqgzpa1m8RdWrk/l5T8lVKp4AYK8UTDxJlPF
         D2Dg==
X-Gm-Message-State: APjAAAUO1huw/R/5RBidLaNQYEkw7T0Nhax6Q4Xj6VwfQtCtdEnifWCM
        H/NIMdfIp2rEW+md9x7iQ8vdUA==
X-Google-Smtp-Source: APXvYqytqJIittAL6SywS5TSNhriqxhqgr5WenVxk94mKGkKDntUuOsPHS/sNJPmFNPsbucacHscxg==
X-Received: by 2002:a17:902:bf47:: with SMTP id u7mr1630085pls.259.1576272203702;
        Fri, 13 Dec 2019 13:23:23 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id i127sm12748180pfc.55.2019.12.13.13.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 13:23:23 -0800 (PST)
Date:   Fri, 13 Dec 2019 13:23:22 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH bpf-next 1/2] bpf: expose __sk_buff wire_len/gso_segs to
 BPF_PROG_TEST_RUN
Message-ID: <20191213212322.GP3105713@mini-arch>
References: <20191211175349.245622-1-sdf@google.com>
 <CAADnVQLAShTWUDaMd26cCP-na=U_ZVUBuWaXR7-VGV=H6r_Qbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQLAShTWUDaMd26cCP-na=U_ZVUBuWaXR7-VGV=H6r_Qbg@mail.gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/13, Alexei Starovoitov wrote:
> On Wed, Dec 11, 2019 at 9:53 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > wire_len should not be less than real len and is capped by GSO_MAX_SIZE.
> > gso_segs is capped by GSO_MAX_SEGS.
> >
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> 
> This change breaks tests:
> ./test_progs -n 16
> test_kfree_skb:PASS:prog_load sched cls 0 nsec
> test_kfree_skb:PASS:prog_load raw tp 0 nsec
> test_kfree_skb:PASS:find_prog 0 nsec
> test_kfree_skb:PASS:find_prog 0 nsec
> test_kfree_skb:PASS:find_prog 0 nsec
> test_kfree_skb:PASS:find global data 0 nsec
> test_kfree_skb:PASS:attach_raw_tp 0 nsec
> test_kfree_skb:PASS:attach fentry 0 nsec
> test_kfree_skb:PASS:attach fexit 0 nsec
> test_kfree_skb:PASS:find_perf_buf_map 0 nsec
> test_kfree_skb:PASS:perf_buf__new 0 nsec
> test_kfree_skb:FAIL:ipv6 err -1 errno 22 retval 0 duration 0
> on_sample:PASS:check_size 0 nsec
> on_sample:PASS:check_meta_ifindex 0 nsec
> on_sample:PASS:check_cb8_0 0 nsec
> on_sample:PASS:check_cb32_0 0 nsec
> on_sample:PASS:check_eth 0 nsec
> on_sample:PASS:check_ip 0 nsec
> on_sample:PASS:check_tcp 0 nsec
> test_kfree_skb:PASS:perf_buffer__poll 0 nsec
> test_kfree_skb:PASS:get_result 0 nsec
> #16 kfree_skb:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
Ugh, it's probably because of '__skb->wire_len < skb->len' check.
Let me take a look.

(sorry, I'm still not running/looking at full test_progs because BTF support
is WIP in our toolchain and some subtests fail because of that,
generating a bunch of noise).
