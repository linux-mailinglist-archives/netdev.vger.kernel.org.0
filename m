Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14301DEB53
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 13:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbfJULr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 07:47:27 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40529 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727831AbfJULr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 07:47:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id x127so8286253pfb.7;
        Mon, 21 Oct 2019 04:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pxuyK2J8Zv4RiKfi5R/IvONY3RKXJZcwRIOIT1s+V5Y=;
        b=YjBPDWhb0qC7qfbYdQCSh833ufO9oM3ufqCj/fNKmpR5DzFG73dwGQwCauBf4aIzfz
         CoCvBeRDQCVaq4OR1dAcnxLohErHSg1byu/0unv6VXz4uh+r16jiTcRPPvSL0VGSiX6L
         PJ20Jg41AH7/e3/5fpIlvVn8nRMYnPOjCOWbTXmrHHNxuKHnwCNbIU855yawe776Rurv
         uv+PfXHI6w52/BponRxV6Mh4JqZcvmo88utViYmTDRtOutKG2VPOkeRVkEgb2kaqKzSx
         4xFGAW+9AKxwzoQfiII8INp9dW1lmyjkqNGqTvQoFUe0wrveJlDRDiEmQj3SeXuf9x4a
         aJ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pxuyK2J8Zv4RiKfi5R/IvONY3RKXJZcwRIOIT1s+V5Y=;
        b=d2nv7GLoezQgF0KyiMlJ7FqM8lAjtfKx3wTI7SImLtfUK6ZCSV8Csfr7qIKAy2qCdX
         1NJFhg/K5vZkJCnmSLoFPrF/ioVEYG7aWHSxYRGM3W8Y2ZuvRqjfPH2DgZvWTLU7B5gL
         cUHVD5K5gN83qaTAbHriWDUldiHe+5VSHRj7Cet7QKSJ2fxp9dP7TtudRzAmnL3E6dDE
         bbjd/PBIZbf2tGClNQ1HLSNvZdkqtB+n5P7tvGB9T0YwKLEvQlPBWWB2K5dgX4eiw3RL
         mz7hX1bIanuTK5KBGuoQxk8wymIDo5Qyvz/L6W+cyfdi5+Y65sFogXkOx4KhmZQ6wj7z
         TW5g==
X-Gm-Message-State: APjAAAV0wNvBCdBdjnnZZ3n5necf3ckK9XKQzEqlQVFBJXjW4SbYZ7bg
        mw0jjmaG2QctDLY/unBRtLY=
X-Google-Smtp-Source: APXvYqyO7KhTEKa8BGtvKo847jWrgMDLYwdwECPs/k+Tk5uOd7EX7Ec9hGP6Dcpw37a2RHoY38QhKA==
X-Received: by 2002:a62:60c7:: with SMTP id u190mr22348821pfb.256.1571658445921;
        Mon, 21 Oct 2019 04:47:25 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id l23sm14491937pjy.12.2019.10.21.04.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 04:47:24 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        William Tu <u9012063@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <CAJ+HfNga=XFeutQuGvGXkuWKSsDCqak-rjutOzqu-r-pwLL1-w@mail.gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <25ade2e7-a8fe-2adb-8d4c-6cc6add21267@gmail.com>
Date:   Mon, 21 Oct 2019 20:47:17 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAJ+HfNga=XFeutQuGvGXkuWKSsDCqak-rjutOzqu-r-pwLL1-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/21 20:23, Björn Töpel wrote:
> On Sat, 19 Oct 2019 at 00:31, Toshiaki Makita
> <toshiaki.makita1@gmail.com> wrote:
>>
> [...]
>>
>> * About OVS AF_XDP netdev
>>
>> Recently OVS has added AF_XDP netdev type support. This also makes use
>> of XDP, but in some ways different from this patch set.
>>
>> - AF_XDP work originally started in order to bring BPF's flexibility to
>>    OVS, which enables us to upgrade datapath without updating kernel.
>>    AF_XDP solution uses userland datapath so it achieved its goal.
>>    xdp_flow will not replace OVS datapath completely, but offload it
>>    partially just for speed up.
>>
>> - OVS AF_XDP requires PMD for the best performance so consumes 100% CPU
>>    as well as using another core for softirq.
>>
> 
> Disclaimer; I haven't studied the OVS AF_XDP code, so this is about
> AF_XDP in general.
> 
> One of the nice things about AF_XDP is that it *doesn't* force a user
> to busy-poll (burn CPUs) like a regular userland pull-mode driver.
> Yes, you can do that if you're extremely latency sensitive, but for
> most users (and I think some OVS deployments might fit into this
> category) not pinning cores/interrupts and using poll() syscalls (need
> wakeup patch [1]) is the way to go. The scenario you're describing
> with ksoftirqd spinning on one core, and user application on another
> is not something I'd recommend, rather run your packet processing
> application on one core together with the softirq processing.

Thank you for the information.
I want to evaluate AF_XDP solution more appropriately.

William, please correct me if I'm saying something wrong here.
Or guide me if more appropriate configuration to achieve best performance is possible.

> 
> Björn
> [1] https://lore.kernel.org/bpf/1565767643-4908-1-git-send-email-magnus.karlsson@intel.com/#t

Toshiaki Makita
