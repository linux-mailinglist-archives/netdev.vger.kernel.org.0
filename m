Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C71B1D8BA9
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 01:38:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgERXhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 19:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726053AbgERXhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 19:37:10 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 220D1C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:37:09 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id a23so3978058qto.1
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 16:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AUH5TuFZU4S3hFHGKE9NhVyMrqV+rM5PHKsx58nbAfQ=;
        b=s+oK8GIi8KaabDzvjlCEbMZqXAJrk2eO1vRG9nYfT1C+YZDU8hChvCLtWqOceml2IX
         AZwDw57+hh6mBxooR+R3kKLjHZIDNF1vFOnEQqU1H7nytVsjaQGZmzAPFo7piqmhh7wH
         +9b52xjFrjKEVBr+F+HqzbiESijtKYGpHbYHVmMXo6Ku+kWbYC2uznXLVrok/SgbQ7cc
         yQXDUxRKzJv1KCNScE+EmjDZjGlkFXmkbkWpNjnlSSZZlEEWWubDKjNPw9KInkY4dfaV
         ah9O9NRPp+Xjn0psfy8sGguWPcPLyFtAoyp8hvfQ3pwrUcyi6HwJY8gRUsC896WM/FqV
         5wAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AUH5TuFZU4S3hFHGKE9NhVyMrqV+rM5PHKsx58nbAfQ=;
        b=B3x/dLcrQdj7zqZVm4VGLBvHNETXGBDojgqHAr90yI1B1grOw6w+KmqJK4kMnmxtPv
         vltpz556oqfvwbK2elqZIIOVIADnjXwuoBqQb+U2pBfi7TxujH30SlBtFAr5OcRvwCy/
         Joxx2ZreQXnnsfSqUPgCbMHkKIxYWHN5uu83tlmyNGzjltYH5MzoTOSR5jOd1P8SzMlR
         UOD8Cz081w4Qow6/Iaee52f0lmw4l9RDTFvclD8h0S/S04VQjf/L4cYKX7X3cETiWf+P
         kcoo6SB6i7ef1Pubx0n/B1ylzya+47Nnn2d9UdjZRmYCSNOQei7WyQahlDEzcammbp1N
         RF4w==
X-Gm-Message-State: AOAM533Wua80+v1KeLv9L6imFkpybBzT2ZXO6NPAGdojj8FQYWD5y2BG
        mUnsLEPeulTIbJVmhbIrswU=
X-Google-Smtp-Source: ABdhPJzUnq9e5b//QCq+7tWh/DLrERyOav8emU1XFXKNRjXRj0ulh6WbU2Wb3eWf81P/k9EBlFLhoA==
X-Received: by 2002:ac8:3968:: with SMTP id t37mr19001987qtb.174.1589845027302;
        Mon, 18 May 2020 16:37:07 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id p42sm9122698qtk.94.2020.05.18.16.37.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 16:37:06 -0700 (PDT)
Subject: Re: [PATCH v5 bpf-next 00/11] net: Add support for XDP in egress path
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, brouer@redhat.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com
References: <20200513014607.40418-1-dsahern@kernel.org>
 <87sgg4t8ro.fsf@toke.dk> <54fc70be-fce9-5fd2-79f3-b88317527c6b@gmail.com>
 <87lflppq38.fsf@toke.dk> <76e2e842-19c0-fd9a-3afa-07e2793dedcd@gmail.com>
 <87h7wdnmwi.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b4ff6a2b-1478-89f8-ea9f-added498c59f@gmail.com>
Date:   Mon, 18 May 2020 17:37:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <87h7wdnmwi.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 12:00 PM, Toke Høiland-Jørgensen wrote:
> I meant 'less powerful' in the obvious sense: it only sees a subset of
> the packets going out of the interface. And so I worry that it will (a)
> make an already hard to use set of APIs even more confusing, and (b)
> turn out to not be enough so we'll end up needing a "real" egress hook.
> 
> As I said in my previous email, a post-REDIRECT hook may or may not be
> useful in its own right. I'm kinda on the fence about that, but am
> actually leaning towards it being useful; however, I am concerned that
> it'll end up being redundant if we do get a full egress hook.
> 

I made the changes to mlx5 to run programs in the driver back in early
March. I have looked at both i40e and mlx5 xmit functions all the way to
h/w handoff to get 2 vendor perspectives. With xdp I can push any header
I want - e.g., mpls - and as soon as I do the markers are wrong. Take a
look at mlx5e_sq_xmit and how it gets the transport header offset. Or
i40e_tso. Those markers are necessary for the offloads so there is no
'post skb' location to run a bpf program in the driver and have the
result be sane for hardware handoff.

[ as an aside, a co-worker just happened to hit something like this
today (unrelated to xdp). He called dev_queue_xmit with a large,
manually crafted packet and no skb markers. Both the boxes (connected
back to back) had to be rebooted.]

From what I can see there are 3 ways to run an XDP program on skbs in
the Tx path:
1. disable hardware offloads (which is nonsense - you don't disable H/W
acceleration for S/W acceleration),

2. neuter XDP egress and not allow bpf_xdp_adjust_head (that is a key
feature of XDP), or

3. walk the skb afterwards and reset the markers (performance killer).

I have stared at this code for months; I would love for someone to prove
me wrong.
