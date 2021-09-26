Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F38418A11
	for <lists+netdev@lfdr.de>; Sun, 26 Sep 2021 17:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhIZP4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Sep 2021 11:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbhIZP4R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Sep 2021 11:56:17 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A03C061570
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 08:54:41 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c20so14466232qtb.2
        for <netdev@vger.kernel.org>; Sun, 26 Sep 2021 08:54:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QtiMO1WEND0L9Ix9pH2ws2tSteU0UR4l0hF6El3rWz0=;
        b=5UmggbFagPRMd1x4d7mCDHLbfFcRIzLd7aLWloFV26Cxma3uu6Olwe6QySTSP5lm0s
         18zVI6Ju5Jczg5K5lX547gAvv3Ewm5miESz1e6HGYL13QSadRX9oBzodJpvUNWCErOwI
         FiHcoUowMcajPXiCDH8varsdJF5a7O+qS1cbI/ZBWYUip2i98WqqGR5Zd1s5oYbwAHch
         dXc+q/CXQVHgr8w0Mw/msz0B4yO0su9dpizwl/wBdJP3l3DqoElaZmaP8kdRBAeT8T5k
         L2xZ0UJ7cvzvJR3HrQpCjI1sCcEH3uiP1LI7abTm+wdguD27999Cp08C+DvyuMljZ7m4
         s2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QtiMO1WEND0L9Ix9pH2ws2tSteU0UR4l0hF6El3rWz0=;
        b=waqCx2uobaihiTRetm3ULUbLZKIUFKTUx4Gj+cj51JifheJ1ftSaMeZWRpHu3LZG8y
         9rcW1SuQObmYDJeKEShIbZdg3NwKcFRwH6MBKlk2SuMkdJD+Z9U9CwG5Wlyx7mgOgImq
         UNyK/JU15yiGdgbHBVsz/1jBOvgh/Og5QU+q5oAjJHIGVSlA7uMMk7cZDRdkkrhbRyJU
         2Xuhvyk62jpmpP8KJq4elH4FkE6vIelhdc4aeYniIDIK+9tFrb1cxzVnoocShqvFeqmw
         Y6AfSOplj8YOaH8ED2Ybp7ME6EoOGZ+LQeV+bxczhtOKRPFXD4pFICcYES/NXdgUR6F0
         QPIw==
X-Gm-Message-State: AOAM531cKhR9qSLj6zMB6Tywe9tmDut1UmR3cmSkdMCSU+Io3HEdlCcb
        RAiC2H5AcYq1a74Kz5kFZlbCPA==
X-Google-Smtp-Source: ABdhPJywWKSy5VWUy+F34mjPf9W8PIrBElAWzOjd33agEjTBCewe+53A3ttn71rFCt+rF8W7gpFikQ==
X-Received: by 2002:ac8:4d48:: with SMTP id x8mr14087954qtv.415.1632671680874;
        Sun, 26 Sep 2021 08:54:40 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id b79sm11325412qkc.0.2021.09.26.08.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Sep 2021 08:54:39 -0700 (PDT)
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
 <e88e7925-db6b-97a3-bf30-aa2b286ab625@mojatatu.com>
 <614d4c2954b0_dc7fd208aa@john-XPS-13-9370.notmuch>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <1268af91-11c9-2fad-b04e-bf1fb220468b@mojatatu.com>
Date:   Sun, 26 Sep 2021 11:54:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <614d4c2954b0_dc7fd208aa@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-09-23 11:55 p.m., John Fastabend wrote:
> Jamal Hadi Salim wrote:

[..]

> 
>> Generally:
>> BPF is good for specific smaller parsing tasks; the ebpf flow dissector
>> hook should be trivial to add to PANDA. And despite PANDA being able
>> to generate EBPF - I would still say it depends on the depth of the
>> parse tree to be sensible to use eBPF.
> 
> Going to disagree. I'm fairly confident we could write a BPF
> program to do the flow disection. Anyways we can always improve
> the verifier as needed and this helps lots of things not
> just this bit. Also flow dissector will be loaded once at early
> boot most likely so we can allow it to take a bit longer or
> pre-verify it. Just ideas.
> 

With current status quo, it is challenging to achieve that
goal. Challenge is complexity and not so much instruction count.
In particular: If you include the parser as part of your eBPF
program you will reduce the amount of what the rest of your program
can do; depending how big the parse tree is, you may have no space
left at all for extra logic (even with tailcalls etc).

Changes to the eBPF core + verifier will certainly help - but
that remains to be seen. Hopefully the next patch set Felipe posts
would also have PANDA output for eBPF - then lets see what magic
you say can be added on top ;->

Note: I am not against ebpf, just where the fit is needs discussion.
For h/w interfacing, thats a totally different ballgame altogether
(tc is a good fit).

cheers,
jamal
