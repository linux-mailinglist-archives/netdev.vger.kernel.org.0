Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DF4518F8
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbfFXQtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:49:19 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42581 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732095AbfFXQtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:49:18 -0400
Received: by mail-wr1-f66.google.com with SMTP id x17so14642588wrl.9
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I98MXEv1VI3vfVpYvlP/+/BZIrp7yLfVm5Dvh/S08Jc=;
        b=ZtfnsLRGhvdPgK/WdczPWayzjhzGsDwPws6KNWla02AXNDGstPg11/AQ0AUzh3rIov
         Ns+XiJcJdHkY1kXo9miJetrXIVfR20qm/ljtrDoVo0Ia9jfRAGGfEfUn0mxkMmZJLV8x
         KqSP1D7EyGTxyfxISHuThTa11BPUsRZR16GE+uyBZb3anInTa4C7Fh8mBqDCtam6U21j
         67wkQLI/OW361R560Lx3dr0tYxqchQ8bW0jgEaT3WGqWJmFJW0/dHxBuf008V+PArIpJ
         6plX8UntiRtvVI24zNb/TJgNjzD0kvRxoKCE9YW2El7Y8JmO0KFXbVWur/OBXzwrozgg
         WSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I98MXEv1VI3vfVpYvlP/+/BZIrp7yLfVm5Dvh/S08Jc=;
        b=A4uxkr1CbHUkXktBHu2o9j53QVrRRl22LneYjPpfaBdxyuc8M9hexVJG3QP2J1XZnH
         lqg3NqGbLZG2JQpMTR6LhZ5eh+TL+zYjRHD1PPzRc8V3mJwWCaUmkoGT3Z4Ja5nr4AfW
         CEPgRRafnLyCcJ8wvREPmC6I38Kl4NDLw2Ki5Jd2FgFv0mJjPF+i18zQxcsMVsajmLNs
         ooH/yPx4ZTGK6MT0f0O9T/qW6L7blUfT+bB3kP6Ha3bnKQBDyyIJ1yMR+tpnXVOidWPs
         n5BDaqOFAIfR6scl9iuohLuyiDvkSAWV7mq1SC8PNHw4bQhnZO2C+b59Dlw0GN3rrD5Q
         WzvQ==
X-Gm-Message-State: APjAAAUPyCjI9GAR+TGa278v+FnZ5iw3h5pDJ1e/gxUSa/iiwIsp7gj/
        BaDXT4o87W2UWpFYHkEFOhM=
X-Google-Smtp-Source: APXvYqxW73I6XfDzEk9sjwwADBPqRxDF39H2Hgr8GzODkwP2lG3ebIH+ASKkTP1QJMUmlsGmmX//pA==
X-Received: by 2002:adf:e50c:: with SMTP id j12mr31589990wrm.117.1561394957023;
        Mon, 24 Jun 2019 09:49:17 -0700 (PDT)
Received: from [192.168.8.147] (59.249.23.93.rev.sfr.net. [93.23.249.59])
        by smtp.gmail.com with ESMTPSA id c1sm21771862wrh.1.2019.06.24.09.49.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 09:49:16 -0700 (PDT)
Subject: Re: Removing skb_orphan() from ip_rcv_core()
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Joe Stringer <joe@wand.net.nz>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     netdev <netdev@vger.kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <CAOftzPisP-3jN8drC6RXcTigXJjdwEnvTRvTHR-Kv4LKn4rhQQ@mail.gmail.com>
 <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d2692f14-6ac7-1335-3359-d397fbe1676f@gmail.com>
Date:   Mon, 24 Jun 2019 18:49:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <ab745372-35eb-8bb8-30a4-0e861af27ac2@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/19 7:47 AM, Jamal Hadi Salim wrote:
> On 2019-06-21 1:58 p.m., Joe Stringer wrote:
>> Hi folks, picking this up again..
> [..]
>> During LSFMM, it seemed like no-one knew quite why the skb_orphan() is
>> necessary in that path in the current version of the code, and that we
>> may be able to remove it. Florian, I know you weren't in the room for
>> that discussion, so raising it again now with a stack trace, Do you
>> have some sense what's going on here and whether there's a path
>> towards removing it from this path or allowing the skb->sk to be
>> retained during ip_rcv() in some conditions?
> 
> 
> Sorry - I havent followed the discussion but saw your email over
> the weekend and wanted to be at work to refresh my memory on some
> code. For maybe 2-3 years we have deployed the tproxy
> equivalent as a tc action on ingress (with no netfilter dependency).
> 
> And, of course, we had to work around that specific code you are
> referring to - we didnt remove it. The tc action code increments
> the sk refcount and sets the tc index. The net core doesnt orphan
> the skb if a speacial tc index value is set (see attached patch)
> 
> I never bothered up streaming the patch because the hack is a bit embarrassing (but worked ;->); and never posted the action code
> either because i thought this was just us that had this requirement.
> I am glad other people see the need for this feature. Is there effort
> to make this _not_ depend on iptables/netfilter? I am guessing if you
> want to do this from ebpf (tc or xdp) that is a requirement.
> Our need was with tcp at the time; so left udp dependency on netfilter
> alone.
> 


Well, I would simply remove the skb_orphan() call completely.


