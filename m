Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25722E629C
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 14:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfJ0NNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 09:13:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37184 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725807AbfJ0NN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 09:13:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id p13so3976866pll.4;
        Sun, 27 Oct 2019 06:13:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p+aqi33c3i0iwwc+rdP+8Mpk3gPREiJrR1SlFD0cqFo=;
        b=q3gTNAyvseBpajLivg8X6DBJANjXQeTO8YOND03IU3FrdDbaDe5zIyd8EjFMUmvLXa
         U0ke2SO0mmRgUrsNzdKWrjxk3L9/kaerxHB+VHnXUeXX5R7uEEw3Rudym5+0EipD388X
         UNFd+pSMtk8I/IjBsavC6xPBjlDNxJqxd/bYJJ3wt4dBLAvVhxVS2a4uBLqZ4yI2GSoQ
         5lu9ozF16oSZKgRSPBFORwDXRgeY3cfxk9nP0+yZCv6Xl7dhwKnahe1mSGnydK9A9F4C
         miiiliXlJialhbr4LtVdgHTTp7WcRv1/dVrmOQfwoaXCoR4V+sAJ0Kko31hc4lT9/q4h
         C5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=p+aqi33c3i0iwwc+rdP+8Mpk3gPREiJrR1SlFD0cqFo=;
        b=OiBDa1Def25ZmWcnZi312EQL7jVpxdrWVxnBnKgKV4y3/Ccss7DjmbtZL6y41sS5gc
         yO95NPt5JlekRYMRRQGR8qZD6sExjDXFHLHlRFxOxFAhTwY5YnVq0LAwj2aDD+LsibRV
         S9Lk20LUoOk6u7i/9n2qTV1dXSBGnS26Mattf/ZGcs9x2+huycZciyOWqOHdwpkkILeA
         NskiIQl9WGbECvHiHng7DjHPpEl1QkKkW7Nyn1JspO568IOiCfvn73LzsbIDLzl90ews
         oPCbt3uxIxS6yOQaW8roWoIQkAKocTDUqVpTZ2JtLjl8DRDyR2pyhAvac0fapDMz2viu
         49YA==
X-Gm-Message-State: APjAAAXsdu1o6okYhxbaCiUsYhfhZoNCwtC1lFQ9pfTi+8ik8liZwlIN
        gakuFZ6S50sYjPJcphEjqVZ1iawf
X-Google-Smtp-Source: APXvYqwj7bScUydnifqb9MGtYOYEMXcqQBLjXZp9e4k9rI6wl7QZ9WHNqGBgJY+ZjjbBImfNxtxGlw==
X-Received: by 2002:a17:902:524:: with SMTP id 33mr14412753plf.123.1572182008999;
        Sun, 27 Oct 2019 06:13:28 -0700 (PDT)
Received: from [192.168.1.9] (i223-218-245-204.s42.a013.ap.plala.or.jp. [223.218.245.204])
        by smtp.googlemail.com with ESMTPSA id d127sm2456205pfc.28.2019.10.27.06.13.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Oct 2019 06:13:28 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
 <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
 <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch>
 <87h840oese.fsf@toke.dk>
Message-ID: <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com>
Date:   Sun, 27 Oct 2019 22:13:23 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <87h840oese.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/23 (水) 2:45:05, Toke Høiland-Jørgensen wrote:
> John Fastabend <john.fastabend@gmail.com> writes:
> 
>> I think for sysadmins in general (not OVS) use case I would work
>> with Jesper and Toke. They seem to be working on this specific
>> problem.
> 
> We're definitely thinking about how we can make "XDP magically speeds up
> my network stack" a reality, if that's what you mean. Not that we have
> arrived at anything specific yet...
> 
> And yeah, I'd also be happy to discuss what it would take to make a
> native XDP implementation of the OVS datapath; including what (if
> anything) is missing from the current XDP feature set to make this
> feasible. I must admit that I'm not quite clear on why that wasn't the
> approach picked for the first attempt to speed up OVS using XDP...

Here's some history from William Tu et al.
https://linuxplumbersconf.org/event/2/contributions/107/

Although his aim was not to speed up OVS but to add kernel-independent 
datapath, his experience shows full OVS support by eBPF is very difficult.
Later I discussed this xdp_flow approach with William and we find value 
performance-wise in such a way of partial offloading to XDP. TC is one 
of ways to achieve the partial offloading.

Toshiaki Makita
