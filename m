Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6FE456536
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 22:52:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231176AbhKRVzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 16:55:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhKRVzT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 16:55:19 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDDEDC061574;
        Thu, 18 Nov 2021 13:52:18 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id n85so7365117pfd.10;
        Thu, 18 Nov 2021 13:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=wD+FHL5aMspzeDjgHTvRdxKq3VHA52l7EjEfeCzVcqM=;
        b=QVF/b5/28QoqobM2LENh94ahFKOvJmhBQae5HnUyEGEIXxXp/YfWkxPk9Uepp5K0kr
         OTICJvuwtGK7vVEtqC44d5ifq86qpwpEZ4AGJ5mekvCwjBUrRsAa7XoLeyPIf7y0HEgf
         bL88v/0D/ikTw+puorKEh/XHdTbavJuwv6dvNxFb/R9yP89TlhzgI6imi9v4/l9rPgq7
         Oao6j8A4nEgX4cTj9yvqB3clRpI8Pb4O5VdTEdbviGbfYwi4fjoNOy4SIaq5oacJFwkq
         dnFVxZGp8kvsUkOhgLuutCZqfCfAwbhF8oZQSPiMup6UQ9K8rQAMA05gTlnXwiBEiNMv
         KcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=wD+FHL5aMspzeDjgHTvRdxKq3VHA52l7EjEfeCzVcqM=;
        b=1ZUukgjV7dUQYqnBfrRVQzMp4mgyqWOGHtaDBpwT7vRTQYcxE3iVRdX2suXXZLwRK/
         wV7n9/kQ5VaUP3bvqAuXDeQifd/yQwqFtUDYHF737ahv2AhcPMzg2rOITXVKsqoXyPlO
         0UfAydB2ohOqC4BxdwqB4uM3M2rdg2BRnLx6T9Wub1vCg84Qh0+C1HoAqQ0wkUeBml53
         IJIkW8Y9GU9YqpEPCyF0tzP9ZKLpjTfv618icTJd+qYJtTpLAHKAORpTpJHNwRC+8U6V
         AhFBqwCT2GoBoylfIjQHbQ8zFaRJLlqt+FAASVER3gdkux5d5PIUOZf1iIu29b80Nhvo
         UDtg==
X-Gm-Message-State: AOAM531RUtbv+B+PgCGQlzK9ngZpQdiQY38QFJYACJbunSnYBbw4kkjB
        gqf4uJ9hyj2Bh5lS17tycNA=
X-Google-Smtp-Source: ABdhPJxBR5LGg7XILXCYEJ0Q1Ih4QFut3qEfEkaTKRUk17GqCxNab1E/vtcdWgtXdNTX1jBgIMNDfg==
X-Received: by 2002:a05:6a00:17a4:b0:49f:c0c0:3263 with SMTP id s36-20020a056a0017a400b0049fc0c03263mr59930490pfg.81.1637272338335;
        Thu, 18 Nov 2021 13:52:18 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:500::1:6926])
        by smtp.gmail.com with ESMTPSA id g21sm586608pfc.95.2021.11.18.13.52.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 13:52:17 -0800 (PST)
Date:   Thu, 18 Nov 2021 13:52:15 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Subject: Re: [RFC PATCH 2/2] bpf: let bpf_warn_invalid_xdp_action() report
 more info
Message-ID: <20211118215215.f4xnwwjhlydxjqnt@ast-mbp.dhcp.thefacebook.com>
References: <cover.1636987322.git.pabeni@redhat.com>
 <c48e1392bdb0937fd33d3524e1c955a1dae66f49.1636987322.git.pabeni@redhat.com>
 <8735nxo08o.fsf@toke.dk>
 <1b9bf5f4327699c74f93c297433012400769a60f.camel@redhat.com>
 <87zgq5mjlj.fsf@toke.dk>
 <20211118004852.tn2jewjm55dwwa5y@ast-mbp>
 <8deb249146474aff37cc574e464615cf98adb32e.camel@redhat.com>
 <87o86hel7h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87o86hel7h.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:50:58PM +0100, Toke Høiland-Jørgensen wrote:
> Paolo Abeni <pabeni@redhat.com> writes:
> 
> > Hello,
> >
> > On Wed, 2021-11-17 at 16:48 -0800, Alexei Starovoitov wrote:
> >> On Mon, Nov 15, 2021 at 06:09:28PM +0100, Toke Høiland-Jørgensen wrote:
> >> > Paolo Abeni <pabeni@redhat.com> writes:
> >> > 
> >> > > > > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> >> > > > > +	pr_warn_once("%s XDP return value %u on prog %d dev %s attach type %d, expect packet loss!\n",
> >> > > > >  		     act > act_max ? "Illegal" : "Driver unsupported",
> >> > > > > -		     act);
> >> > > > > +		     act, prog->aux->id, dev->name, prog->expected_attach_type);
> >> > > > 
> >> > > > This will only ever trigger once per reboot even if the message differs,
> >> > > > right? Which makes it less useful as a debugging aid; so I'm not sure if
> >> > > > it's really worth it with this intrusive change unless we also do
> >> > > > something to add a proper debugging aid (like a tracepoint)...
> >> > > 
> >> > > Yes, the idea would be to add a tracepoint there, if there is general
> >> > > agreement about this change.
> >> > > 
> >> > > I think this patch is needed because the WARN_ONCE splat gives
> >> > > implicitly information about the related driver and attach type.
> >> > > Replacing with a simple printk we lose them.
> >> > 
> >> > Ah, right, good point. Pointing that out in the commit message might be
> >> > a good idea; otherwise people may miss that ;)
> >> 
> >> Though it's quite a churn across the drivers I think extra verbosity here is justified.
> >> I'd only suggest to print stable things. Like prog->aux->id probably has
> >> little value for the person looking at the logs. That prog id is likely gone.
> >> If it was prog->aux->name it would be more helpful.
> >> Same with expected_attach_type. Why print it at all?
> >> tracepoint is probably good idea too.
> >
> > Thanks for the feedback.
> >
> > I tried to select the additional arguments to allow the user/admin
> > tracking down which program is causing the issue and why. I'm a
> > complete newbe wrt XDP, so likely my choice were naive.
> >
> > I thought the id identifies the program in an unambiguous manner. I
> > understand the program could be unloaded meanwhile, but if that is not
> > the case the id should be quite useful. Perhaps we could dump both the
> > id and the name?
> >
> > I included the attach type as different types support/allow different
> > actions: the same program could cause the warning or not depending on
> > it. If that is not useful I can drop the attach type from the next
> > iteration.
> 
> The attach type identifies DEVMAP and CPUMAP programs, but just printing
> it as a number probably doesn't make sense. So maybe something like:
> 
> switch(prog->expected_attach_type) {
>     case BPF_XDP_DEVMAP:
>     case BPF_XDP_CPUMAP:
>       pr_warn_once("Illegal XDP return value %u from prog %s(%d) in %s!\n",
>                    act, prog->aux_name, prog->aux->id,
>                    prog->expected_attach_type == BPF_XDP_DEVMAP ? "devmap" : "cpumap");
>       break;
>     default:
>       pr_warn_once("%s XDP return value %u on prog %s(%d) dev %s, expect packet loss!\n",
>                    act > act_max ? "Illegal" : "Driver unsupported",
>                    act, prog->aux->name, prog->aux->id, dev->name);
>       break;

imo it's an overkill for a debug message that should not be seen.
Just attach bpf probe to this function and print whatever necessary.
Keep kernel message single line and short that is easily greppable.
