Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73DD43D2489
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 15:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232071AbhGVMpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 08:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhGVMpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 08:45:10 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED29C061575;
        Thu, 22 Jul 2021 06:25:44 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c12so5946670wrt.3;
        Thu, 22 Jul 2021 06:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mUWOLWbYCSm/rovP4uz4q3GcAfsEzycZgM+L6hPpGFg=;
        b=EIxJy7jjP0STE+V3GvZWU20nV7ZQP2swdueNX9dYT6kHAw5kyu3Q8wNQiLG5URECrD
         4gTN+2+YvYwlhpDKAg9z1gIwZ1LIDozV4Xb4pffpVXsQuOnfy/ZHE6wNDOkQbsT1WGxZ
         z/GlALooEBWQ2TUC39jKNMw4cUxEDfb3Fk+g2cDQkoj1yOFy6A+nhiZ9xHUn/JgvDuDI
         hhY96yTsVeRaMpBbiGyALUoEINIKcxKEo8ngh4C/Ll5zjkyfN/y+2sOCJmbO/7fhABcu
         BRFqKsbOqxSQbb6YcoDyjKIRSeItTStUb/WM7NmCFFCrsT/8I/9uFVuLPNLWf7stS9ga
         tZsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mUWOLWbYCSm/rovP4uz4q3GcAfsEzycZgM+L6hPpGFg=;
        b=VapU02edkncV4/rSC8CrxsZPrXWJuqOTlVF4sg3t+/+ONoDQQCYVUZyGe0xMrTpJg8
         BLfkKk5Tg4nCtIKuyEG/wWGD3EmgkxFH/yoBlFCBNlkIIgXl8Cgh8Yqy272Y1NxKQaMP
         tVG2KWbc5Y5tGua/d3WnIalJ3LFHqh5X7d9kl5MGbpz21mSn+a2gv3mJVMnJdhO4klqW
         GIjCmRnzTsxH/ZixvZpggGdl9wQccMmBAR5Zm+YGFDasv0LOXJIBVSFzLwHI7sd4VI//
         sG1cBm3zFRqx7mas7bXF7PRu24c25QuJYsy8kKZEGSDgGb/Mr0nZaqb/cKu5OBKs2Vze
         Nk8g==
X-Gm-Message-State: AOAM531NHAHkQORyI6aCeBFMB3ukOeI32DL8kA+J0/iEmH7L6fTKzQu3
        TQfUAt3xXJNo7VtpuYhtlmo=
X-Google-Smtp-Source: ABdhPJxG1T9BimqH1Y6ye74RcGmbgFWMNsXM8Qw7GFgDiDc8BcL/Npnl1z5cb7PFtG0VbUSHhMPLbg==
X-Received: by 2002:a5d:6189:: with SMTP id j9mr49525750wru.196.1626960342240;
        Thu, 22 Jul 2021 06:25:42 -0700 (PDT)
Received: from [10.0.0.18] ([37.168.21.168])
        by smtp.gmail.com with ESMTPSA id d29sm36583975wrb.63.2021.07.22.06.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 06:25:41 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 0/8] bpf: Allow bpf tcp iter to do
 bpf_(get|set)sockopt
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Yuchung Cheng <ycheng@google.com>
References: <20210701200535.1033513-1-kafai@fb.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d5ffdaf5-08e5-2b28-d891-73d507bae5fa@gmail.com>
Date:   Thu, 22 Jul 2021 15:25:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210701200535.1033513-1-kafai@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/1/21 10:05 PM, Martin KaFai Lau wrote:
> This set is to allow bpf tcp iter to call bpf_(get|set)sockopt.
> 
> With bpf-tcp-cc, new algo rollout happens more often.  Instead of
> restarting the applications to pick up the new tcp-cc, this set
> allows the bpf tcp iter to call bpf_(get|set)sockopt(TCP_CONGESTION).
> It is not limited to TCP_CONGESTION, the bpf tcp iter can call
> bpf_(get|set)sockopt() with other options.  The bpf tcp iter can read
> into all the fields of a tcp_sock, so there is a lot of flexibility
> to select the desired sk to do setsockopt(), e.g. it can test for
> TCP_LISTEN only and leave the established connections untouched,
> or check the addr/port, or check the current tcp-cc name, ...etc.
> 
> Patch 1-4 are some cleanup and prep work in the tcp and bpf seq_file.
> 
> Patch 5 is to have the tcp seq_file iterate on the
> port+addr lhash2 instead of the port only listening_hash.
> 
> Patch 6 is to have the bpf tcp iter doing batching which
> then allows lock_sock.  lock_sock is needed for setsockopt.
> 
> Patch 7 allows the bpf tcp iter to call bpf_(get|set)sockopt.
> 
> v2:
> - Use __GFP_NOWARN in patch 6
> - Add bpf_getsockopt() in patch 7 to give a symmetrical user experience.
>   selftest in patch 8 is changed to also cover bpf_getsockopt().
> - Remove CAP_NET_ADMIN check in patch 7. Tracing bpf prog has already
>   required CAP_SYS_ADMIN or CAP_PERFMON.
> - Move some def macros to bpf_tracing_net.h in patch 8
> 
> Martin KaFai Lau (8):
>   tcp: seq_file: Avoid skipping sk during tcp_seek_last_pos
>   tcp: seq_file: Refactor net and family matching
>   bpf: tcp: seq_file: Remove bpf_seq_afinfo from tcp_iter_state
>   tcp: seq_file: Add listening_get_first()
>   tcp: seq_file: Replace listening_hash with lhash2
>   bpf: tcp: bpf iter batching and lock_sock
>   bpf: tcp: Support bpf_(get|set)sockopt in bpf tcp iter
>   bpf: selftest: Test batching and bpf_(get|set)sockopt in bpf tcp iter

For the whole series :

Reviewed-by: Eric Dumazet <edumazet@google.com>

Sorry for the delay.

BTW, it seems weird for new BPF features to use /proc/net "legacy"
infrastructure and update it.

