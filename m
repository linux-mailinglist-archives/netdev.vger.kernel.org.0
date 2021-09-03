Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66A6400800
	for <lists+netdev@lfdr.de>; Sat,  4 Sep 2021 00:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbhICWxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 18:53:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236029AbhICWxa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 18:53:30 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3F45C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 15:52:29 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id t35so548209qtc.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 15:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mI8sPf7AVUEAQSF+8mD4PVZdiD6r3q2N74aRnv1PFwY=;
        b=MMhMZJ9h6pjHycQyIrLHh4tb9bOk3AbnSQygw6QKOukBU4Dr520/Fj4koEGwRcSIf0
         2LYrX5GYi+ZiyYKf6471/cQQHAiYuzEFEH49Dl/nqjeibAlYO2+kQJwaWsv7LIWj6qi+
         gFdxV2P8NKScG2L5hOzdSxCjcnGSgA8lNZjHxzzXaTc8bfbhY6H9LMwnEMVnjxAbJSp8
         SSgg9b5F0nI6AidVJ7p8mT6zpAzKav6V6Zzjt41lgaoHwTATTE8k+4PO3iTkaACH4O7x
         V6nN7B8UyVeSVmYSqZTGn1nW+5TlzWzKU5Ik14sBwkKOPItWhZYd+kIiTCXIaNSxGzNR
         XEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mI8sPf7AVUEAQSF+8mD4PVZdiD6r3q2N74aRnv1PFwY=;
        b=L/ejGli1Jw7NL5KE/SeQP41AdpJ/xWUpL9ArX/jUboo7prmNi0gQfXn0SCFy+oMU/E
         LB0cmfYM9q25ded5n7zPHdsGapmYqSh2bTZGFKhkZm8wbkArBewQdyosAqUOlBifLurg
         fFstb288YbHsaqGGitkcGHgzSGHj4m+yO1zl88bNXNeAZEAl2ibX+CHD3+SVZ/ffGVNX
         3yjWen+iQRmhpWqLBTk1aAL384KdFNHy51YRaFn4x9IIHyDLAf3YmUV730BWHb+esgn5
         +grf6TP64GHazDOnFq3ytkqsE3qjOol60l2dRINexEqptlkND87ix52OkipgYO0K1/l1
         dgbQ==
X-Gm-Message-State: AOAM531GiBzr2eHEizrLHfRHrdSfnE6/v03zCHKFJjo2mZm4Z3ekjnsu
        1vT8WKNEznTgEgWTN8HLWGLjYw==
X-Google-Smtp-Source: ABdhPJzDUlGLdzKunbCDjAUffzo73Bg+nnywfqO8ufzDbdzNXCoTs/RdEYggFdUg82+nc+YWp3KIAw==
X-Received: by 2002:ac8:5247:: with SMTP id y7mr1259182qtn.289.1630709549143;
        Fri, 03 Sep 2021 15:52:29 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id 102sm515499qtc.62.2021.09.03.15.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 15:52:28 -0700 (PDT)
Subject: Re: [PATCH net-next] net/sched: cls_flower: Add orig_ethtype
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Boris Sukholitko <boris.sukholitko@broadcom.com>,
        netdev@vger.kernel.org, Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        tom Herbert <tom@sipanda.io>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        Pedro Tammela <pctammela@mojatatu.com>
References: <20210830080800.18591-1-boris.sukholitko@broadcom.com>
 <b05f2736-fa76-4071-3d52-92ac765ca405@mojatatu.com>
 <20210831120440.GA4641@noodle>
 <b400f8c6-8bd8-2617-0a4f-7c707809da7d@mojatatu.com>
 <YTBz0zitSUrd0Qd1@shredder>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <71aef436-0103-8ee2-427c-34dad10d0b0e@mojatatu.com>
Date:   Fri, 3 Sep 2021 18:52:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTBz0zitSUrd0Qd1@shredder>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-09-02 2:48 a.m., Ido Schimmel wrote:
> On Tue, Aug 31, 2021 at 09:18:16AM -0400, Jamal Hadi Salim wrote:
>> You have _not_ been unlucky - it is a design issue with flow dissector
>> and the wrapping around flower. Just waiting to happen for more
>> other use cases..
> 
> I agree. I think the fundamental problem is that flower does not set
> 'FLOW_DISSECTOR_F_STOP_AT_ENCAP' and simply lets the flow dissector
> parse as deep as possible. For example, 'dst_ip' will match on the
> inner most destination IP which is not intuitive and probably different
> than what most hardware implementations do.
> 
> This behavior is also very error prone because it means that if the
> kernel learns to dissect a new tunnel protocol, filters can be suddenly
> broken (match on outer field now matches on inner field).
> 

indeed, lots of ambiguity with multiple appearing headers of the same
type (eg ethernet/ethernet/ethernet or ip/ip/udp/vxlan/ip/...).

> I don't think that changing the default behavior is a solution as it can
> break user space. Maybe adding a 'stop_encap' flag to flower that user
> space will have to set?


Yes, this would work for the case of one simple rule that Boris posted
(small addition to user space).
For the rest of the data he was trying to match (ip headers) further
parsing would be needed before matching.
Unfortunately,  there is a lot of _ambiguity_ in those kind of
scenarios. Today's approach in TC is you pop some header then advance
the packet cursor - and the next rule picks up where the first one left 
off (i.e something like action "pppoe pop" would be needed).
The suggestion i made to Boris was to make it parse everything pppoe has
to offer in one rule - but that would not be advancing any skb data
pointers and would possibly require that one extra change i suggested
to set protocol to tp->protocol; such an approach is probably closest
to what hardware would do (i.e parse everything you need then match).
I am not sure which approach is less intrusive; imo, the challenge here
is perhaps the flow dissector is getting messy as a generic parser.
Maybe Tom and co can post patches for Panda which handles these
issues much more smoothly... Tom?

On your point on the hardware: interesting, guess I never thought of
possible inconsistencies. IIUC, as it stands today the software version
may end up having very different result than a supposedly equivalent
hw offload.
Would it make sense to make the hardware parsing also programmable
from software so there is consistency?

cheers,
jamal
