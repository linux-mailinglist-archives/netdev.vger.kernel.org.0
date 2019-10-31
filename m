Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6939DEA840
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 01:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfJaAc7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 20:32:59 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46226 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfJaAc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 20:32:59 -0400
Received: by mail-pf1-f193.google.com with SMTP id 193so1637289pfc.13;
        Wed, 30 Oct 2019 17:32:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wbfAXjBUjBtrdeFqTT7UQ9DyVnBAOEw1DiLo4LACvwg=;
        b=jDLQliPhVfZgs2ncJC9rh1Pu8x5xoHwGHP1N106Jo1ygCGxslG/iHFWQmgGTeamfr2
         7sFBqAdP0eqFgg5ijv3RdM+dSBz7k82vCrgOJ2dZ9kZ0ECfHR4QWHKSJnYQVeBBclb1T
         O3oAkn4i5fGsKbo3TIpU8wirE8I5u1FX62vRM7JSUvAaVrRLTDG98FvxOcoIMzLYyLzE
         Djt0v2d/0bkjxxThb31pIGLYyb5gnzL54kC91q9r8TtcbmRO5l4fI/vkbxzOaaQshjPX
         6ifVQB8BYLhb/jR8RI53KYoKXzXP0n6c+R3NHEvGNyTmcrutrUXCKBARzZJs4Q51+FPu
         lTKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wbfAXjBUjBtrdeFqTT7UQ9DyVnBAOEw1DiLo4LACvwg=;
        b=L1MzKQY53bfHzD4FFjWgePgF6NSr9tpN/Lta/XUktKlJ9POzh6qZQ3e382kYacSsvT
         amZ5kfsaiKtbNrsrikhOPgm2bdgkA7WsWcGBliuR9r1WfLX378MvR3hGFTKL83HKPP55
         WpwYPz29WSPw/6QBx4SFYLW2iBgDb8mCxvYF+oE/Eg0YCQmvT19/zh3WCdL7oR6p93rw
         hdQIauDdD2HNbazE49qLBTZsYZB0kwDv7UH/WctFZH0kUCzKBhbnUIZk49cW2zJBLcFj
         vgiKdVecx8DeHzH9A8KOsYaSaLJ3ql2AYGj4r/fadQOw1TR1OsT/6shjk76e/+bNNVtZ
         4C9Q==
X-Gm-Message-State: APjAAAXBRCvTSiTsWH7m2YGD/T0OvHfVobwwyVCGCH41eTKp8HVf/gQN
        EYcJEE+QKPhvYUkEOdlZK1E=
X-Google-Smtp-Source: APXvYqx6qzd8OotMhQdog5hVrvR36Wb3AHvJChwqFzs1LFREb4/S/+XC4+xu7gwDRST82rPquZ0/QQ==
X-Received: by 2002:a63:c74e:: with SMTP id v14mr2720065pgg.334.1572481978348;
        Wed, 30 Oct 2019 17:32:58 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id z25sm1100305pfa.88.2019.10.30.17.32.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 17:32:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     David Miller <davem@davemloft.net>, toke@redhat.com
Cc:     john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        jakub.kicinski@netronome.com, hawk@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, pshelar@ovn.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, u9012063@gmail.com,
        sdf@fomichev.me
References: <87h840oese.fsf@toke.dk>
 <282d61fe-7178-ebf1-e0da-bdc3fb724e4b@gmail.com> <87wocqrz2v.fsf@toke.dk>
 <20191027.121727.1776345635168200501.davem@davemloft.net>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <09817958-e331-63e9-efbf-05341623a006@gmail.com>
Date:   Thu, 31 Oct 2019 09:32:51 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20191027.121727.1776345635168200501.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/28 4:17, David Miller wrote:
> From: Toke Høiland-Jørgensen <toke@redhat.com>
> Date: Sun, 27 Oct 2019 16:24:24 +0100
> 
>> The results in the paper also shows somewhat disappointing performance
>> for the eBPF implementation, but that is not too surprising given that
>> it's implemented as a TC eBPF hook, not an XDP program. I seem to recall
>> that this was also one of the things puzzling to me back when this was
>> presented...
> 
> Also, no attempt was made to dyanamically optimize the data structures
> and code generated in response to features actually used.
> 
> That's the big error.
> 
> The full OVS key is huge, OVS is really quite a monster.
> 
> But people don't use the entire key, nor do they use the totality of
> the data paths.
> 
> So just doing a 1-to-1 translation of the OVS datapath into BPF makes
> absolutely no sense whatsoever and it is guaranteed to have worse
> performance.

Agree that 1-to-1 translation would result in worse performance.
What I'm doing now is just supporting subset of keys, only very basic ones.
This does not accelerate all usages so dynamic program generation certainly
has value. What is difficult is that basically flow insertion is triggered
by datapath packet reception and it causes latency spike. Going through
bpf verifier on each new flow packet reception on datapath does not look
feasible so we need to come up with something to avoid this.

Toshiaki Makita
