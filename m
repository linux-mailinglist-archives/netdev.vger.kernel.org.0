Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8F661EA50B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 15:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbgFANf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 09:35:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgFANf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 09:35:28 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94044C061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 06:35:27 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r9so10706869wmh.2
        for <netdev@vger.kernel.org>; Mon, 01 Jun 2020 06:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wzwcAhpymW0aerReRp3ixwuRx2i45sNcmG39WHT19X4=;
        b=PQ3wdtNI+2CvS9PW6sH4mhDYJEABY8IT6UbTY6/R6GpswYnKKaigKJ9i7scG2gD6Ya
         h7zzeMeZjHv7gqzDMXZAhAe3pT+K1SEVLqK1/dn1HfyMgZ6RSqkQQdZAvr5URrc16eHF
         ZvjVw4lku15jL3wEqq+9vvYr26lSdas7E+TLH5BNqWTrkKuV+xq0YYGDlWV5bJisOpD4
         AnWbLO+FBGJtOJKhYpxP28SYsj+oCHa6bJs++f/uztwMaXeP2sD3FJXetUlupgbaRVB8
         K4JLBRzyTfXz3szVZM8/RaeeGgBNUeMxYHGlkZLXI3i2QuLZhKowVmCWPUeYEZ8zXhDl
         4wFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzwcAhpymW0aerReRp3ixwuRx2i45sNcmG39WHT19X4=;
        b=JwV5FMyxJh5D45FPr9Ajk/BEyk9VOPDtWfdPppXZPRoj1oO7/ES+HXCWa8PQbsHa4h
         MMxINTPNeHjXcdiSQ/78XqzuFBHySj2vzkTEhkJemTdsJk+6sLWGR873B/n2RGkZgzEc
         NRUfKgeSdERacdodDslOcwAoNJIfYGepLQ4s5vr1BzvkmGlH87oxBUkJRGFSPs2ulekW
         9M4PM4hrhO3XCyqxqsrpVjuFd8mQ7s1EovXUBh7mxxcWuga34FkjAKCg3ZkvlyR+6ORa
         JeMEybzkAAgeF68wuK/EyL+mAeos14lT3OhoNLgW8J/LKP+sk681SqEoWzDCxJzj7AqH
         evOw==
X-Gm-Message-State: AOAM532oxJkfUe8czu2FNHEst27mc1A+Z0H4v0VP81o8KXl4yv7PhVzj
        zCCvqx1ZjO0MAb58zSPdpnkskA==
X-Google-Smtp-Source: ABdhPJy6nv86M3sYqE7Ym7z/IMMmMrkgrrj4XeARpW7E6g+JrDyZyFAI/QNf+BT8RxOxNfOltLJ9Gg==
X-Received: by 2002:a1c:b155:: with SMTP id a82mr3527265wmf.46.1591018526334;
        Mon, 01 Jun 2020 06:35:26 -0700 (PDT)
Received: from localhost (ip-78-102-58-167.net.upcbroadband.cz. [78.102.58.167])
        by smtp.gmail.com with ESMTPSA id h5sm21484131wrw.85.2020.06.01.06.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 06:35:25 -0700 (PDT)
Date:   Mon, 1 Jun 2020 15:35:24 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Petr Machata <petrm@mellanox.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [RFC PATCH net-next 0/3] TC: Introduce qevents
Message-ID: <20200601133524.GP2282@nanopsycho>
References: <cover.1590512901.git.petrm@mellanox.com>
 <CAM_iQpW8NcZy=ayJ49iY-pCix+HFusTfoOpoD_oMOR6+LeGy1g@mail.gmail.com>
 <877dwxvgzk.fsf@mellanox.com>
 <CAM_iQpX2LMkuWw3xY==LgqpcFs8G01BKz=f4LimN4wmQW55GMQ@mail.gmail.com>
 <87wo4wtmnx.fsf@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo4wtmnx.fsf@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 28, 2020 at 11:48:50AM CEST, petrm@mellanox.com wrote:
>
>Cong Wang <xiyou.wangcong@gmail.com> writes:
>
>> On Wed, May 27, 2020 at 2:56 AM Petr Machata <petrm@mellanox.com> wrote:
>>>
>>>
>>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>>>
>>> > On Tue, May 26, 2020 at 10:11 AM Petr Machata <petrm@mellanox.com> wrote:
>>> >>
>>> >> The Spectrum hardware allows execution of one of several actions as a
>>> >> result of queue management events: tail-dropping, early-dropping, marking a
>>> >> packet, or passing a configured latency threshold or buffer size. Such
>>> >> packets can be mirrored, trapped, or sampled.
>>> >>
>>> >> Modeling the action to be taken as simply a TC action is very attractive,
>>> >> but it is not obvious where to put these actions. At least with ECN marking
>>> >> one could imagine a tree of qdiscs and classifiers that effectively
>>> >> accomplishes this task, albeit in an impractically complex manner. But
>>> >> there is just no way to match on dropped-ness of a packet, let alone
>>> >> dropped-ness due to a particular reason.
>>> >>
>>> >> To allow configuring user-defined actions as a result of inner workings of
>>> >> a qdisc, this patch set introduces a concept of qevents. Those are attach
>>> >> points for TC blocks, where filters can be put that are executed as the
>>> >> packet hits well-defined points in the qdisc algorithms. The attached
>>> >> blocks can be shared, in a manner similar to clsact ingress and egress
>>> >> blocks, arbitrary classifiers with arbitrary actions can be put on them,
>>> >> etc.
>>> >
>>> > This concept does not fit well into qdisc, essentially you still want to
>>> > install filters (and actions) somewhere on qdisc, but currently all filters
>>> > are executed at enqueue, basically you want to execute them at other
>>> > pre-defined locations too, for example early drop.
>>> >
>>> > So, perhaps adding a "position" in tc filter is better? Something like:
>>> >
>>> > tc qdisc add dev x root handle 1: ... # same as before
>>> > tc filter add dev x parent 1:0 position early_drop matchall action....
>>>
>>> Position would just be a chain index.
>>
>> Why? By position, I mean a place where we _execute_ tc filters on
>> a qdisc, currently there is only "enqueue". I don't see how this is
>> close to a chain which is basically a group of filters.
>
>OK, I misunderstood what you mean.
>
>So you propose to have further division within the block? To have sort
>of namespaces within blocks or chains, where depending on the context,
>only filters in the corresponding namespace are executed?

Please take the block as a whole entity. It has one entry ->chain0
processing. The gotos to other chains should be contained within the
block.

Please don't divide the block. If you want to process the block from a
different entry point, please process it as a whole.


>
>>>
>>> > And obviously default position must be "enqueue". Makes sense?
>>>
>>> Chain 0.
>>>
>>> So if I understand the proposal correctly: a qdisc has a classification
>>> block (cl_ops->tcf_block). Qevents then reference a chain on that
>>> classification block.
>>
>> No, I am suggesting to replace your qevents with position, because
>> as I said it does not fit well there.
>>
>>>
>>> If the above is correct, I disagree that this is a better model. RED
>>> does not need to classify anything, modelling this as a classification
>>> block is wrong. It should be another block. (Also shareable, because as
>>> an operator you likely want to treat all, say, early drops the same, and
>>> therefore to add just one rule for all 128 or so of your qdiscs.)
>>
>> You can still choose not to classify anything by using matchall. No
>> one is saying you have to do classification.
>
>The point here is filter reuse, not classification.
>
>> If you want to jump to a block, you can just use a goto action like
>
>I don't think you can jump to a block. You can jump to a chain within
>the same block.

Correct.

entrypoint->
   block X
     chain 0
     chain A
     chain B
     chain ...

There's no goto/jump out of the block.

>
>> normal. So your above example can be replaced with:
>>
>> # tc qdisc add dev eth0 root handle 1: \
>>         red limit 500K avpkt 1K
>>
>> # tc filter add dev eth0 parent 1:0 position early_drop matchall \
>>    action goto chain 10
>>
>> # tc chain add dev eth0 index 10 ...
>>
>> See the difference?
