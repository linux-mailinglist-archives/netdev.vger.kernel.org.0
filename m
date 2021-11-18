Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121924559D9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 12:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343831AbhKRLQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 06:16:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343832AbhKRLOi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 06:14:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637233898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aaxy5Ve1jIT4tgdcxDNfsb26ezRCU+Q+jXhOZq7K9zM=;
        b=YKOiQFzofFyUZhxkG1iE39g0jHTLSZEiXr31wVb6hfDt48z7Nhc5F1uBA6d0hGAATYxcEF
        c4W7m1pZlF4mvkKqpK+/FyWxZiwF/8QAyqKlcANrNNZrAshvrr+rjkLLqH+3FF8d/eK/Vl
        ktOxCWRbW4EIQIg/fWl+JGQyBhlwtvc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-402-vnHuVi1vMSKUHFroOY4MyA-1; Thu, 18 Nov 2021 06:11:36 -0500
X-MC-Unique: vnHuVi1vMSKUHFroOY4MyA-1
Received: by mail-ed1-f72.google.com with SMTP id y9-20020aa7c249000000b003e7bf7a1579so4969459edo.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 03:11:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Aaxy5Ve1jIT4tgdcxDNfsb26ezRCU+Q+jXhOZq7K9zM=;
        b=iu5QmnCbllWui5rUgfUMOfQN1u5FXFZxJGe1yVKO06jJAOb3QZeXi+Zpgf8q33k5+c
         Z63/nAi1cyBJnxYdvqcYuV22Bdkh0SJ8yR1vH1+IX1W6JLIj1UCvRLYE4LYWT/+oCjoV
         wjAPO8iU8RdnxZg57CtB4ZcgSSSBj7lUMVLfxrTRyuPyjhVm0C5WBefIEprkM1uV1Nm8
         Nd8oHD7G7siiSZYtC13pYfea22XAOIuiz7oY3K4ihBLtCx+OdItaqM3K5/bdenaqDeFk
         vTW7Wr4CYB88ZDA4Uj2R5yeOy6Q4uIkR235PjvZCWiJr5otV2SRuUTYluPP6DYirCDAh
         eOqg==
X-Gm-Message-State: AOAM532ZWfxZcJClWMG+GPzgalULEYdT80n6xp48Wij9tZY5j6J9q7fX
        OTlBdH3CGCgWf0oJ3iH+TjLtZ3Odo52GqbJzntzosY781rNleFPymUMjD8Qh67ixOAtwnNTQsmX
        4X6AnAO98VgF9IwXY
X-Received: by 2002:a17:907:9487:: with SMTP id dm7mr32497748ejc.2.1637233895349;
        Thu, 18 Nov 2021 03:11:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy0Rkqxhpwc3VBC06R3Z9mljj5PFByYiM7/qv8FA9zRGqY/0fJdSrA1xVLOEY8M6h3K89/gDg==
X-Received: by 2002:a17:907:9487:: with SMTP id dm7mr32497720ejc.2.1637233895154;
        Thu, 18 Nov 2021 03:11:35 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-229-135.dyn.eolo.it. [146.241.229.135])
        by smtp.gmail.com with ESMTPSA id qa31sm1159077ejc.33.2021.11.18.03.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 03:11:34 -0800 (PST)
Message-ID: <8deb249146474aff37cc574e464615cf98adb32e.camel@redhat.com>
Subject: Re: [RFC PATCH 2/2] bpf: let bpf_warn_invalid_xdp_action() report
 more info
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Date:   Thu, 18 Nov 2021 12:11:33 +0100
In-Reply-To: <20211118004852.tn2jewjm55dwwa5y@ast-mbp>
References: <cover.1636987322.git.pabeni@redhat.com>
         <c48e1392bdb0937fd33d3524e1c955a1dae66f49.1636987322.git.pabeni@redhat.com>
         <8735nxo08o.fsf@toke.dk>
         <1b9bf5f4327699c74f93c297433012400769a60f.camel@redhat.com>
         <87zgq5mjlj.fsf@toke.dk> <20211118004852.tn2jewjm55dwwa5y@ast-mbp>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1 (3.42.1-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2021-11-17 at 16:48 -0800, Alexei Starovoitov wrote:
> On Mon, Nov 15, 2021 at 06:09:28PM +0100, Toke Høiland-Jørgensen wrote:
> > Paolo Abeni <pabeni@redhat.com> writes:
> > 
> > > > > -	pr_warn_once("%s XDP return value %u, expect packet loss!\n",
> > > > > +	pr_warn_once("%s XDP return value %u on prog %d dev %s attach type %d, expect packet loss!\n",
> > > > >  		     act > act_max ? "Illegal" : "Driver unsupported",
> > > > > -		     act);
> > > > > +		     act, prog->aux->id, dev->name, prog->expected_attach_type);
> > > > 
> > > > This will only ever trigger once per reboot even if the message differs,
> > > > right? Which makes it less useful as a debugging aid; so I'm not sure if
> > > > it's really worth it with this intrusive change unless we also do
> > > > something to add a proper debugging aid (like a tracepoint)...
> > > 
> > > Yes, the idea would be to add a tracepoint there, if there is general
> > > agreement about this change.
> > > 
> > > I think this patch is needed because the WARN_ONCE splat gives
> > > implicitly information about the related driver and attach type.
> > > Replacing with a simple printk we lose them.
> > 
> > Ah, right, good point. Pointing that out in the commit message might be
> > a good idea; otherwise people may miss that ;)
> 
> Though it's quite a churn across the drivers I think extra verbosity here is justified.
> I'd only suggest to print stable things. Like prog->aux->id probably has
> little value for the person looking at the logs. That prog id is likely gone.
> If it was prog->aux->name it would be more helpful.
> Same with expected_attach_type. Why print it at all?
> tracepoint is probably good idea too.

Thanks for the feedback.

I tried to select the additional arguments to allow the user/admin
tracking down which program is causing the issue and why. I'm a
complete newbe wrt XDP, so likely my choice were naive.

I thought the id identifies the program in an unambiguous manner. I
understand the program could be unloaded meanwhile, but if that is not
the case the id should be quite useful. Perhaps we could dump both the
id and the name?

I included the attach type as different types support/allow different
actions: the same program could cause the warning or not depending on
it. If that is not useful I can drop the attach type from the next
iteration.

Thanks!

Paolo

