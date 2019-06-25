Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E5955567
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 19:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbfFYRDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 13:03:49 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:33486 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728130AbfFYRDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 13:03:49 -0400
Received: by mail-wr1-f43.google.com with SMTP id n9so18784880wru.0
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GEQ2iPLIX3P9r+aam6xPIL5jitO/ctg9DQvewvUwftI=;
        b=luKHFtP1jap/OOvbZWvE4/pF16+oNiU2GFQSQc3f5RhSM4pFSQMPnqFGlseuHxAB9P
         jvseW6gizODix4PSAYU17I7wbwhyCPsdeaCUsfMiYpEq3Hox8jh2nhySmD4OiKzHCaaX
         dqtpDvqr9q9bbrK0MT4IALPgSjiPCrRCIaDPADML75cjKHo1l8Wf31t3frd2yjaJOqtw
         UFd4T0BjcFC6UGvgRBeaCiPu2ajnHjzeRYDmDFtdAXiFrt4TJLMpC342lwrb7gab1hRg
         IOTDJ1iAC6VCJGiGDr6oj/xHMMUYFnyiEwq2mu8wtaKIMaORGxYCMPLhvf0VM6wgNHi9
         Fklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GEQ2iPLIX3P9r+aam6xPIL5jitO/ctg9DQvewvUwftI=;
        b=DqCUJtxKtfErk6gvVOops6HdbCsbONfxBJESnHGTcXQrgl9dozUAjhUVQn96mwSMI6
         BOvnJPBlcA+cZwJNosAowZ0RWGeqjzdVNHFSjViNDQKJL/YzGkgMiyzF0O5OZK0Df8Eb
         +usyHXCLuZz6LnrIFA5VvOIVCYOck7jMGUkjGrknWJjaf7R8mYGPI0YfzHS54/K0+4T9
         GfGyD7BBLsBhz4tYqZjF8J2iOtp/iTDwcNnAGTHfIfxTOGT1N/0YV3rb9NMY5AzSxHdn
         Im/s4KF9x9PSTUQOtvkI893VqNP8EpZyrh8NtMNn1ed+WKC0v2ESXJ/H5+tumIqEIYZ0
         Rx1A==
X-Gm-Message-State: APjAAAUh2eD7i0U8fFFzHy/KWtiNLE5NJ3mzngZ2kEs5nB6ae1Qx+A3q
        ar6L0k7qpQbjqEbQUk5pGm8=
X-Google-Smtp-Source: APXvYqybHqbQSG/93WN+oJVVCshrG9z6SSYZtyUq7jOPWzfWoGzXOOhDs5S2jSbOAUKhdFUcG5xnUA==
X-Received: by 2002:adf:9bd3:: with SMTP id e19mr37310117wrc.38.1561482226961;
        Tue, 25 Jun 2019 10:03:46 -0700 (PDT)
Received: from [192.168.8.147] (104.84.136.77.rev.sfr.net. [77.136.84.104])
        by smtp.gmail.com with ESMTPSA id t12sm15996718wrw.53.2019.06.25.10.03.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 10:03:46 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Joe Stringer <joe@wand.net.nz>, Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Flavio Leitner <fbl@redhat.com>, ast@kernel.org
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <20190621205935.og7ajx57j7usgycq@breakpoint.cc>
 <CAOftzPi5SO_tZeoEs1Apd5np=Sd2fFUPm1oome_31=rMqSD-=g@mail.gmail.com>
 <b6baadcb-29af-82f1-bebe-56d5f45b12e6@gmail.com>
 <4deff7d7-cc10-090d-86f2-850148fdf032@iogearbox.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5f916eb2-9971-f3a8-fac8-b4b51cd881b0@gmail.com>
Date:   Tue, 25 Jun 2019 19:03:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <4deff7d7-cc10-090d-86f2-850148fdf032@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/25/19 2:35 AM, Daniel Borkmann wrote:

> 
> But wasn't the whole point of 9c4c325252c5 ("skbuff: preserve sock reference when
> scrubbing the skb.") to defer orphaning to as late as possible? If I'm not missing
> anything, then above would reintroduce the issues that 9c4c325252c5 was trying to
> solve wrt TSQ/XPS/etc when skb was sent via veth based data path to cross netns and
> then forwarded to phys dev for transmission; meaning, skb->sk is lost at the point
> of dev_queue_xmit() for the latter. A side-effect this would also have is that this
> changes behavior again for tc egress programs sitting on phys dev (e.g. querying
> sock cookie or other related features).


Unless we can detect/decide that a packet going through veth pair is going to be locally
consumed, or forwarded to a physical device (another ndo_start_xmit()), we need
to skb_orphan() the packet, exactly the same way than loopback ndo_start_xmit()

(We could have setups where these packets going through lo interface could be forwarded
to a NIC...)

Backpressure is a best effort, we should not make it an absolute requirement and
prevent doing early demux as early as possible in RX path.

 
