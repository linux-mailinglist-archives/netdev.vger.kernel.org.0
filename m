Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40270415FB6
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 15:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240199AbhIWN2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 09:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231380AbhIWN2O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 09:28:14 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83BEC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:26:42 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id jo30so4102454qvb.3
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 06:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9vmvvKRAS7NpUlt1DuSs0hb//b8mUrLzrOsGgl9wMkI=;
        b=VIHcNbv0hz2AybEw3dC1zuOdROMUnuMyXeYS3HUzZGoYP/HIBn7jhYNFBqGU+zO/ud
         RDbUxblZ4+g+v7qEypyn26lIjfIOp5nuCCdiG74tPm57ELjNUYIcQYFNfBALSXp8Bv52
         XVDdVxpxSQUjgeURSH/CKe1o7Gn+J8DVCy3lMnl7bNMdHeG8+KlrhkcYrGCTNtISVNw6
         kb71hOoZbA72MY1AioLVeH9MswuXNzlFyGF3NtkR1HRabNHyfPUP+6j4ZhZamX8EbEpU
         fPqXCDwFJfZnIE5W0wyZE5XhTbwOQ6GqMwcNjd7QGta9g8XdqRgySAA4AvMakLII86Ia
         TIbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9vmvvKRAS7NpUlt1DuSs0hb//b8mUrLzrOsGgl9wMkI=;
        b=Of8HxZPGn3hTXztgEuUkzGD8HL77X/KxuTDKxk0vZNEsl8F5i/pzo/YEQ0zgZ9S3Je
         b4triDbGBxrZHLGzq0LE0l8OaQrLzBnpvfVvdfw1629PckrLfi59bS8ES28XO+2FJSSk
         l0+aatojGx4OnX/JOYrm1xj665XwbctNyQeSTzg6P3FufP6MeCopsxPc+XudrIuJOIlQ
         gcKWRiDx4aF/O/IM6UWnKWhEc2JystXsOxcnPgTykBa0JLEuhwdtLzci/Jcih8tZhWpu
         6YX43yrM3Wy2v3uIIj7jfPe7haf548vy2A7a7JVQ+J1E4n6hm75DRPT5oBVL8a/+PM9g
         LD9g==
X-Gm-Message-State: AOAM531hvxWgSHBRhry/GpvISAtwPfrRhZ3m4JNXhzgNBSDNSmbIG28v
        e/sE7MtZ6ZmX4z0FwhhojqMtQXuPAOdzgA==
X-Google-Smtp-Source: ABdhPJymJPIxp5kWUrTAZqD+8kS2Jn4lxz6aMaQQn7pzif0ArPOxbvl2Adiim0aBmuTJzLSYmi2SXQ==
X-Received: by 2002:ad4:472c:: with SMTP id l12mr4099459qvz.1.1632403601848;
        Thu, 23 Sep 2021 06:26:41 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id f83sm4207727qke.79.2021.09.23.06.26.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 06:26:41 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 0/2] net:sched: Introduce tc flower2
 classifier based on PANDA parser in kernel
To:     John Fastabend <john.fastabend@gmail.com>,
        Tom Herbert <tom@sipanda.io>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Felipe Magno de Almeida <felipe@sipanda.io>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>, paulb@nvidia.com,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20210916200041.810-1-felipe@expertise.dev>
 <CAM_iQpUkdz_EjiuPRF_qKBp_ZHok_c8+pr4skCWGs_QTeLWpwA@mail.gmail.com>
 <YUq1Ez1g8nBvA8Ad@nanopsycho>
 <CAOuuhY8KA99mV7qBHwX79xP31tqtc9EggSNZ-=j4Z+awJUosdQ@mail.gmail.com>
 <20210922154929.GA31100@corigine.com>
 <CAOuuhY9NPy+cEkBx3B=74A6ef0xfT_YFLASEOB4uvRn=W-tB5A@mail.gmail.com>
 <20210922180022.GA2168@corigine.com>
 <CAOuuhY9oGRgFn_D3TSwvAsMmAnahuPyws8uEZoPtpPiZwJ2GFw@mail.gmail.com>
 <614ba2e362c8e_b07c2208b0@john-XPS-13-9370.notmuch>
 <CAOuuhY_Z63qeWhJpqbvXyk3pK+sc5=7MfOpMju94pSjtsqyuOg@mail.gmail.com>
 <614bd85690919_b58b72085d@john-XPS-13-9370.notmuch>
 <CAOuuhY-ujF_EPm6qeHAfgs6O0_-yyfZLMryYx4pS=Yd1XLor+A@mail.gmail.com>
 <614bf3bc4850_b9b1a208e2@john-XPS-13-9370.notmuch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <e88e7925-db6b-97a3-bf30-aa2b286ab625@mojatatu.com>
Date:   Thu, 23 Sep 2021 09:26:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <614bf3bc4850_b9b1a208e2@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geez, I missed all the fun ;->

On 2021-09-22 11:25 p.m., John Fastabend wrote:
> Tom Herbert wrote:
>> On Wed, Sep 22, 2021, 6:29 PM John Fastabend <john.fastabend@gmail.com>
>> wrote:

[..]

>> John,
>>
>> Please look at patch log, there are number of problems that have come up
>> flow dissector over the years. Most of this is related to inherent
>> inflexibility, limitations, missing support for fairly basic protocols, and
>> there's a lot of information loss because of the fixed monolithic data
>> structures. I've said it many times: skb_flow_dissect is the function we
>> love to hate. Maybe it's arguable, bit I claim it's 2000 lines of spaghetti
>> code. I don't think there's anyone to blame for that, this was a
>> consequence of evolving very useful feature that isn't really amenable to
>> being written in sequence of imperative instructions (if you recall it used
>> to be even worse with something like 20 goto's scattered about that defied
>> any semblance of logical program flow :-) ).
> 
> OK, but if thats the goal then shouldn't this series target replacing the
> flow_dissector code directly? I don't see any edits to ./net/core.
> 

Agreed, replacement of flow dissector should be a focus. Jiri's
suggestion of a followup patch which shows how the rest of the consumers
of flow dissector could be made to use PANDA is a good idea.

IMO (correct me if i am wrong Tom), flower2 was merely intended to
illustrate how one would use PANDA i.e there are already two patches
of which the first one is essentially PANDA...
IOW,  it is just flower but with flow dissector replaced by PANDA.

>>
>> The equivalent code in PANDA is far simpler, extensible, and maintainable
>> and there are opportunities for context aware optimizations that achieve
>> higher performance (we'll post performance numbers showing that shortly).
>> It's also portable to different environments both SW and HW.
> 
> If so replace flow_dissector then I think and lets debate that.
> 
> My first question as a flow dissector replacement would be the BPF
> flow dissector was intended to solve the generic parsing problem.

> Why would Panda be better? My assumption here is that BPF should
> solve the generic parsing problem, but as we noted isn't very
> friendly to HW offload. So we jumped immediately into HW offload
> space. If the problem is tc_flower is not flexible enough
> couldn't we make tc_flower use the BPF dissector? That should
> still allow tc flower to do its offload above the sw BPF dissector
> to hardware just fine.
> 
> I guess my first level question is why did BPF flow dissector
> program not solve the SW generic parsing problem. I read the commit
> messages and didn't find the answer.
> 

Sorry, you cant replace/flowdissector/BPF such that flower can
consume it;-> You are going to face a huge path explosion with the 
verifier due to the required branching and then resort to all
kinds of speacial-cased acrobatics.
See some samples of XDP code going from trying to parse basic TCP 
options to resorting to tricking the verifier.
For shits and giggles, as they say in Eastern Canada, try to do
IPV6 full parsing with BPF (and handle all the variable length
fields).
Generally:
BPF is good for specific smaller parsing tasks; the ebpf flow dissector
hook should be trivial to add to PANDA. And despite PANDA being able
to generate EBPF - I would still say it depends on the depth of the
parse tree to be sensible to use eBPF.

Earlier in the thread you said a couple of things that caught my
attention:

 > I don't think P4 or Panda should be in-kernel. The kernel has a BPF
 > parser that can do arbitrary protocol parsing today. I don't see
 > a reason to add another thing on the chance a hardware offload
 > might come around. Anyways P4/Panda can compile to the BPF parser
 > or flower if they want and do their DSL magic on top. And sure
 > we might want to improve the clang backends, the existing flower
 > classifier, and BPF verifier.
 >
 >
 > Vendors have the ability to code up arbitrary hints today. They just
 > haven't open sourced it or made it widely available. I don't see how
 > a 'tc' interface would help with this. I suspect most hardware could
 > prepend hints or put other arbitrary data in the descriptor or elsewhere.
 > The compelling reason to open source it is missing.

Please, please _lets not_ encourage vendors to continue
keep things proprietary!
Statements like "I don't think P4 or Panda should be in-kernel..."
are just too strong.
Instead lets focus on how we can make P4 and other hardware offloads
work in conjunction with the kernel (instead of totally bypassing
it which is what vendors are doing enmasse already). There are
billions of $ invested in these ASICs and lets welcome them into
our world. It serves and helps grow the Linux community better.
The efforts of switchdev and tc offloading have proven it is possible.
Vendors (and i am going to call out Broadcom on the switching side here)
are not partaking because they see it as an economical advantage not to
partake.

We have learnt a lot technically since switchdev/tc offloads happened.
So it is doable.
The first rule is: In order to get h/w offload to work lets also have
digitally equivalent implementation in s/w.


cheers,
jamal
