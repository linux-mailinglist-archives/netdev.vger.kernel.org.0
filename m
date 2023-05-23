Return-Path: <netdev+bounces-4648-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1AE670DA9A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 12:32:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 713E7281579
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 10:32:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A18D4A861;
	Tue, 23 May 2023 10:32:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284911F95D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 10:32:34 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB70FD
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684837951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BnUyr8sQI0ykX2bQEqSArBLAPzKYjJ6x9XxmmftwarI=;
	b=Sweo3V9wQrRaQ0JMEzdon4Oe/gtdYOUaJb4L0O7bpHxqv3pSz2MaxgTTdy8VSZSej2MqCJ
	wzgnhfeJPrQB+f3B6FRecTuLpZU2qW81YK9YiU+1gtS1bSQ7ZifWOV1J9bWI4Ce7y0nuP7
	xFOTtkHfqc5WTxV0pA2ThWBj5WXglSk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-J9pMyCRKMU2LPVSD0GWWvQ-1; Tue, 23 May 2023 06:32:30 -0400
X-MC-Unique: J9pMyCRKMU2LPVSD0GWWvQ-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-30a938fcfb5so1139252f8f.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684837949; x=1687429949;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BnUyr8sQI0ykX2bQEqSArBLAPzKYjJ6x9XxmmftwarI=;
        b=iCGZIiI1VJX4CQ4/wVeOlzVaMPS+GtejY7oufyeaZYQEwFSln7EO6LFLWyRXPom+LK
         M1RB1sMn+dlUDeSzp1WoAOfYnfnvl7xpH63rxc9EoQDpLiykUvstPK/TBRloJc6a+QR9
         7e9rsVLXh0YbHc55gHq6/FkerGtjikqZSBzAv6OWupCgqnNqtd8bJPh6IC5PfBz6juS9
         ToR5YJu/Ay/iKscxCBUhFuiIHZEeaMMSlDFi826cj5LIp4QlaiRLoh+XAfBdqcpSsb9o
         8RVbSYCpvbhKCTFJxdp6fF6vgJ34ukyQc6xUIhP+8y4QqwPgajoHjzqd0g39pip6DDz4
         /x4Q==
X-Gm-Message-State: AC+VfDydujCpBA62Svbnxg3XPQSt8bEgsW5NJV54WD6s6avSzSuEup1V
	esAJcW/SfzvRtKZyuOw0KgQl+bg4RZz/IO0Z1X4rqReh/N5YN2BV1BrRWVtHUAij2cU7vXaRH9G
	48tKWy4LO/bX/ZaZw
X-Received: by 2002:a05:6000:1202:b0:2f7:8f62:1a45 with SMTP id e2-20020a056000120200b002f78f621a45mr10071693wrx.66.1684837949359;
        Tue, 23 May 2023 03:32:29 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NJUTeUHG8oF3ANLD0cT0nrBAyfEHEyR20ZA75gPmGsEakvK4haV5Zn+FkrWxXeL+NSnZTmg==
X-Received: by 2002:a05:6000:1202:b0:2f7:8f62:1a45 with SMTP id e2-20020a056000120200b002f78f621a45mr10071672wrx.66.1684837949010;
        Tue, 23 May 2023 03:32:29 -0700 (PDT)
Received: from localhost ([37.161.12.148])
        by smtp.gmail.com with ESMTPSA id t1-20020a5d6a41000000b003063176ef09sm10904775wrw.6.2023.05.23.03.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 03:32:28 -0700 (PDT)
Date: Tue, 23 May 2023 12:32:24 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Vladimir Nikishkin <vladimir@nikishkin.pw>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Ido Schimmel <idosch@idosch.org>, dsahern@gmail.com,
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGyWOBJ7bUUUhAbD@renaissance-vector>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder>
 <20230521124741.3bb2904c@hermes.local>
 <ZGsIhkGT4RBUTS+F@shredder>
 <20230522083216.09cc8fd7@hermes.local>
 <ZGyJ1r+A3zIhmk0/@renaissance-vector>
 <875y8je5er.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875y8je5er.fsf@laptop.lockywolf.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 05:52:30PM +0800, Vladimir Nikishkin wrote:
> 
> Andrea Claudi <aclaudi@redhat.com> writes:
> 
> > On Mon, May 22, 2023 at 08:32:16AM -0700, Stephen Hemminger wrote:
> >> On Mon, 22 May 2023 09:15:34 +0300
> >> Ido Schimmel <idosch@idosch.org> wrote:
> >> 
> >> > On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
> >> > > On Sun, 21 May 2023 22:23:25 +0300
> >> > > Ido Schimmel <idosch@idosch.org> wrote:
> >> > >   
> >> > > > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> >> > > > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> >> > > > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))  
> >> > > 
> >> > > That will not work for non json case.  It will print localbypass whether it is set or not.
> >> > > The third argument is a format string used in the print routine.  
> >> > 
> >> > Yea, replied too late...
> >> > 
> >> > Anyway, my main problem is with the JSON output. Looking at other
> >> > boolean VXLAN options, we have at least 3 different formats:
> >> > 
> >> > 1. Only print when "true" for both JSON and non-JSON output. Used for
> >> > "external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
> >> > "remcsum_tx", "remcsum_rx".
> >> > 
> >> > 2. Print when both "true" and "false" for both JSON and non-JSON output.
> >> > Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".
> >> > 
> >> > 3. Print JSON when both "true" and "false" and non-JSON only when
> >> > "false". Used for "learning".
> >> > 
> >> > I don't think we should be adding another format. We need to decide:
> >> > 
> >> > 1. What is the canonical format going forward?
> >> > 
> >> > 2. Do we change the format of existing options?
> >> > 
> >> > My preference is:
> >> > 
> >> > 1. Format 2. Can be implemented in a common helper used for all VXLAN
> >> > options.
> >> > 
> >> > 2. Yes. It makes all the boolean options consistent and avoids future
> >> > discussions such as this where a random option is used for a new option.
> >> 
> >> A fourth option is to us print_null(). The term null is confusing and people
> >> seem to avoid it.  But it is often used by python programmers as way to represent
> >> options. That would be my preferred option but others seem to disagree.
> >> 
> >> Option #2 is no good. Any printing of true/false in non-JSON output is a diveregence
> >> from the most common practice across iproute2.
> >> 
> >> That leaves #3 as the correct and best output.
> >> 
> >> FYI - The iproute2 maintainers are David Ahern and me. The kernel bits have
> >> other subsystem maintainers.
> >> 
> >
> > Just to make sure I understand correctly, this means we are printing
> > "nolocalbypass" in non-JSON output because it's the non-default
> > settings, right?
> >
> > If this is correct, then if we have another option in the future that
> > comes disabled by default, this means we are going to print it in
> > non-JSON output when enabled.
> >
> > As the primary consumer of non-JSON output are humans, I am a bit
> > concerned since a succession of enabled/noenabled options is awkward and
> > difficult to read, in my opinion.
> >
> > Wouldn't it be better to have non-JSON print out options only when
> > enabled, regardless of their default value?
> 
> Sorry, what is "enabled" and what is "disabled by default"?
> I think this is a major source of confusion.
> 
> If the option is "nolocalbypass", it is "disabled by default".
> If the option is "localbypass", it is "enabled by default".
> 
> Intuitively, it seems that everything that is "default" should be
> considered disabled, hence the actual option is "nolocalbypass", an by
> default it is disabled, and hence not printed. Its opposite requires
> explicitly adding a command-line parameter, and hence the "enabled"
> state is "nolocalbypass". I think this is the logic that Stephen is
> proposing.
>

This is indeed confusing, let me try to be more clear.

Let's start considering that we have a single place to store this info,
tb[IFLA_VXLAN_LOCALBYPASS], and this is either true or false.

So, after:

localbypass = rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]);

you expect localbypass to be true if the user does not modify it, and
you print "nolocalbypass" when instead it is changed to false. Fine.

Now, let's have another option, tb[IFLA_VXLAN_MYOPTION]. Using:

myoption = rta_getattr_u8(tb[IFLA_VXLAN_MYOPTION]);

I expect myoption to be false without user intervention, because this is
how this new option work. I'll print this out only when the user toogle
this to true.

Now, if we decide to print only what happens when the user toogle the
option with a command-line parameter, we may have:

nolocalbypass myoption nooption2 option3 nooption4 ...

which seems to me awkward and difficult to read.

Instead, printing only when true:

myoption option3

This simply says "myoption and option3 are enabled, all the rest is
disabled". It seems to me much more easier to read and understand.

> 
> -- 
> Your sincerely,
> Vladimir Nikishkin (MiEr, lockywolf)
> (Laptop)
> --
> Fastmail.
> 


