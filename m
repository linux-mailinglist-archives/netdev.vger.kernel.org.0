Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF8745F2378
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 15:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiJBN7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Oct 2022 09:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbiJBN7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Oct 2022 09:59:51 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE14F267B
        for <netdev@vger.kernel.org>; Sun,  2 Oct 2022 06:59:49 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id k11-20020a4ab28b000000b0047659ccfc28so5264917ooo.8
        for <netdev@vger.kernel.org>; Sun, 02 Oct 2022 06:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ipRZ6txDUXHEM9s9oxk01eMmGPNHbKtgxie+vCNZH8U=;
        b=Y8DCs2e6dRMd/JXY8e5ek7Ynd/kfdxRsBMVzea/0ZaMO9tyMkHSbVpNBl0W0Qh2r70
         m3u7E7RBwYCPoUmrdsXl6UI92zj5BLnUsfAn/d/KXOcbFh1LuCFCUUO7aAHB46+AeK2S
         Ma1mG2lZ1QdCGXrRCAH3/RObTosxuZ622PORqBD509FZ1AOT1EiWLhVkV+z756BnrFpX
         MrjFGPyyygc0ITbKTnGJh/4fO0f8KML5KdllcrK0tQ/9+x1PUNVMDWsZ8q2iRqXhJxam
         EVpK9keIEniTvQzM4193dRKCUMloqs+1X1JszUbx7F6WVG805OR/IbvJH5BRCv3eSq0X
         gEWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ipRZ6txDUXHEM9s9oxk01eMmGPNHbKtgxie+vCNZH8U=;
        b=0ljMcRbiM6TbYn9NaQL8xY1lfMmF4a3+1D1KQHZPIEpFhW+auGN0RRssn9LjAm7LNK
         Qh/fEBIisNwVAjXs0OokcEsLLTpiWFagkrcBUjhkjaepjLu76dF+F5+ZxxM1rDZ31dBv
         zuQJqYROaehywdOmeOE0r950Z1roZJZODb74B47VNDBED0xlLuSYlR5PXTCqXM9D6ME5
         GqtwUGkMiWSP6N4cADV1hPK/+4gbbaI4reDQgrR829FITB74/7QxfB3LOZ36284POiAN
         p2aKph3WQ5UJ2u6rYrWpgZzlWTk6Z6H0qUEB7PrNVR3ApUEabPBLfwJxRatk073nEfcO
         0l2g==
X-Gm-Message-State: ACrzQf0w6jIlKYim1Mr8/TRbIM5Q5Eok3K52kAHvGANdX/600h7a8QM3
        PZnnSCMv23w++S/TMIa/or0/EbXc5GGjQ8E/+BnpWw==
X-Google-Smtp-Source: AMsMyM6JZ3XrdrjSXj7zI0gV7u2wdHG2n76h56TRbzjbqPRteIKveRYu1UjjAF0WHOUXDPZ90WZ6Unh2/uNIurmHP4c=
X-Received: by 2002:a9d:2a7:0:b0:65a:c6a3:1d0e with SMTP id
 36-20020a9d02a7000000b0065ac6a31d0emr6635644otl.223.1664719189274; Sun, 02
 Oct 2022 06:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220927212306.823862-1-kuba@kernel.org> <a3dbb76a-5ee8-5445-26f1-c805a81c4b22@blackwall.org>
 <20220928072155.600569db@kernel.org> <CAM0EoMmWEme2avjNY88LTPLUSLqvt2L47zB-XnKnSdsarmZf-A@mail.gmail.com>
 <c3033346-100d-3ec6-0e89-c623fc7b742d@blackwall.org> <CAM0EoMnpSMydZvQgLXzoqAHTe0=xx6zPEaP1482qHhrTWGH_YQ@mail.gmail.com>
 <4f8b1dec-82c8-b63f-befe-b2179449042d@blackwall.org> <CAM0EoMn09qMjpHV5dHEaMDBCuRBVt6qbcTToXCeqCQ-+-7UJeQ@mail.gmail.com>
 <8de025b0-01d8-2d28-4c6a-052758f7c737@blackwall.org>
In-Reply-To: <8de025b0-01d8-2d28-4c6a-052758f7c737@blackwall.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sun, 2 Oct 2022 09:59:37 -0400
Message-ID: <CAM0EoM=D5YmMTrmNORcVCbAMVFcq=id_v+FSv-UqR1rT2B0xjg@mail.gmail.com>
Subject: Re: [PATCH net-next] docs: netlink: clarify the historical baggage of
 Netlink flags
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Guillaume Nault <gnault@redhat.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 30, 2022 at 2:19 PM Nikolay Aleksandrov <razor@blackwall.org> wrote:
>
> On 30/09/2022 19:36, Jamal Hadi Salim wrote:
> > On Fri, Sep 30, 2022 at 10:34 AM Nikolay Aleksandrov
> > <razor@blackwall.org> wrote:

[..]

> > You only have one object type though per netlink request i.e you
> > dont have in the same message fdb and mdb objects?
> >
>
> Yep, it is object-type and family- specific, as is the call itself.
>

Ok, so that makes it easier.

[..]

> > Isnt it sufficient to indicate what objects need to be deleted based on presence
> > of TLVs or the service header for that object?
> >
>
> That was my initial proposal for the fdbs. :)  When flush attribute was present it would
> act on it (and filter based on embedded filters). The only non-intuitive part was that it
> happened through SETLINK (changelink), which is a bit strange for a delete op.
>
> >>> Really NLM_F_ROOT and _MATCH are sufficient. The filtering expression is
> >>> the challenge.
> >>
> >> NLM_F_ROOT isn't usable for a DEL expression because its bit is already used by NLM_F_NONREC
> >> and it wouldn't be nice to change meaning of the bit based on the subsystem. NLM_F_MATCH's bit
> >> actually matches NLM_F_BULK :)
> >>
> >
> > Ouch. Ok, it got messy over time i guess. We probably should have
> > spent more time
> > discussing NLM_F_NONREC since it has a single user with very specific
> > need and it
> > got imposed on all.
> > I get your point - i am still not sure if a global flag is the right answer.
> >
>
> Personally, I prefer the complete netlink approach (tlvs describing the operation and filters).
> In the end the flag was close enough, I kept all of the family specific code the same just the entry
> point was different and other families could use it as a modifier to their del commands.
>

BTW, it seems that nftables is an outlier. You should still be able to
use NLM_F_ROOT
acronmy for DELETE.
act_api uses NLM_F_ROOT on delete to flush the whole table of actions. My
git-archealogy-foo says since 2005. NLM_F_NONREC was added in 2017.
So you really should just be able to use NLM_F_ROOT to check for Delete
of the whole table and TLV specific to service to filter further.

> >>
> >> Sometime back I played with a different idea - expressing the filters with the existing TLV objects
> >> so whatever can be specified by user-space can also be used as a filter (also for filtering
> >> dump requests) with some introspection. The lua idea sounds nice though.
> >
> > So what is the content of the TLV in that case?
>
> My first approach, which wasn't using bpf, used the tlv type to define specific filters on the various
> types, incl. binary (which at the time was only an exact match, could be improved though). BPF w/ btf
> would be the obvious choice these days.
>

The filter TLVs are good because the rest of the world can use them.
The challenge is experessability. Like you say above,
exact match is easy; inet diag has its own DSL to describe things which could
be easily extended. A solution like a Lua script is second best and of course
not to rule out ebpf - but that requires more skills.

> > I think ebpf may work with some acrobatics. We did try classical ebpf and it was
> > messy. Note for scaling, this is not just about Delete and Get but
> > also for generated
> > events, where one can send to the kernel a filter so they dont see a broadcast
>
> Yeah, I remember CL having scaling issues in some user-space software that was snooping
> netlink messages and that's the reason I looked into filtering at that time.
>

They are related problems. When you have 1000s of potential events it
just doesnt scale.
My idea was to specify a filter to select a subset and then open
multiple sockets
each specifying a different filter subset.

cheers,
jamal
