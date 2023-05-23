Return-Path: <netdev+bounces-4616-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2980370D94A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 11:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAF581C20BE6
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49D3F1E517;
	Tue, 23 May 2023 09:40:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3770D1DDE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 09:40:07 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 179B6121
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684834795;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gFl6oFsH7ZGZlcEt4zYWS7yBmk4ZC1FGuhh1tGqonYo=;
	b=YsKAH+DSkNW9d9N+uXLpZ3Ss056kKSjEYCzvP7RfvxOOHDt1uUM7lX3B52m+SU6pQLtNAm
	7yIG1xaH0NyYg69z7WzYu5/Pr3e8GNLncUIu90uEJqrk4Vul1ZNXmqujLlyvwbT9uZOGu7
	a2CVsL+mP156ZmFi2tbz6j1tmeyM22Q=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-299-Y2K97x79NdWm9Vux07a7VA-1; Tue, 23 May 2023 05:39:54 -0400
X-MC-Unique: Y2K97x79NdWm9Vux07a7VA-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-75aff1596d3so468824785a.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 02:39:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684834793; x=1687426793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gFl6oFsH7ZGZlcEt4zYWS7yBmk4ZC1FGuhh1tGqonYo=;
        b=Sbyl7SoZzUFyJBRAy/SLFEI/QhYqAeHH6xsAJTiPhABrYRl06dGxRpK+pGbkjQrp+k
         ScZ4509yrHCs7IYcSyAb2j2Dod+HyR5W3efPAdhaqkEePAx7ZkW+koVT2tJ4ByGZ08lE
         K0xoFRqiT6dEGZoFQqS3TNih0iSE0pSJOmPYRqJGphIOqflT0n8ycQCp5Bg5TUXCc8vT
         VoPWSC7Aw6MAhjN+ftAFNuVeO6VpUZ0VEBZvb6xzgfSavMwyf9s8SCIhovkpmavxOQy4
         VB1pI+63GfyzEpU4onOKvi7pACEPvZ29Qx6SHUzsjEK8/oAg+8l1NM/kM46STxs+t/70
         yVgA==
X-Gm-Message-State: AC+VfDzsZJelbalOiL+UR0tF3f7oexv4LTZ2rwk/qH4GkSzZt4IAdZV3
	Gom/WGPmOFFa2uoBnePctqjMxgYcJ8hKUbJnBNddRn77wKCdb+anacTB9VsOMkyZ7MOhkxIq4Ls
	+dBW45AUVO1nG3r4m
X-Received: by 2002:a05:620a:63c4:b0:75b:23a1:35ff with SMTP id pw4-20020a05620a63c400b0075b23a135ffmr3365308qkn.16.1684834793534;
        Tue, 23 May 2023 02:39:53 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5OBZM2S1tUEeJZDExghd+WewC2hRdRaF28WqCVE6vE0IbMSsQSKRfh3PrUMxNIqrTCQ0rh1Q==
X-Received: by 2002:a05:620a:63c4:b0:75b:23a1:35ff with SMTP id pw4-20020a05620a63c400b0075b23a135ffmr3365293qkn.16.1684834793307;
        Tue, 23 May 2023 02:39:53 -0700 (PDT)
Received: from localhost ([37.161.12.148])
        by smtp.gmail.com with ESMTPSA id 27-20020a05620a071b00b007594e37092esm2380819qkc.82.2023.05.23.02.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 02:39:52 -0700 (PDT)
Date: Tue, 23 May 2023 11:39:34 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: Ido Schimmel <idosch@idosch.org>,
	Vladimir Nikishkin <vladimir@nikishkin.pw>, dsahern@gmail.com,
	netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com,
	eng.alaamohamedsoliman.am@gmail.com, gnault@redhat.com,
	razor@blackwall.org, idosch@nvidia.com, liuhangbin@gmail.com,
	eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v5] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZGyJ1r+A3zIhmk0/@renaissance-vector>
References: <20230521054948.22753-1-vladimir@nikishkin.pw>
 <ZGpvrV4FGjBvqVjg@shredder>
 <20230521124741.3bb2904c@hermes.local>
 <ZGsIhkGT4RBUTS+F@shredder>
 <20230522083216.09cc8fd7@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522083216.09cc8fd7@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023 at 08:32:16AM -0700, Stephen Hemminger wrote:
> On Mon, 22 May 2023 09:15:34 +0300
> Ido Schimmel <idosch@idosch.org> wrote:
> 
> > On Sun, May 21, 2023 at 12:47:41PM -0700, Stephen Hemminger wrote:
> > > On Sun, 21 May 2023 22:23:25 +0300
> > > Ido Schimmel <idosch@idosch.org> wrote:
> > >   
> > > > +       if (tb[IFLA_VXLAN_LOCALBYPASS])
> > > > +               print_bool(PRINT_ANY, "localbypass", "localbypass ",
> > > > +                          rta_getattr_u8(tb[IFLA_VXLAN_LOCALBYPASS]))  
> > > 
> > > That will not work for non json case.  It will print localbypass whether it is set or not.
> > > The third argument is a format string used in the print routine.  
> > 
> > Yea, replied too late...
> > 
> > Anyway, my main problem is with the JSON output. Looking at other
> > boolean VXLAN options, we have at least 3 different formats:
> > 
> > 1. Only print when "true" for both JSON and non-JSON output. Used for
> > "external", "vnifilter", "proxy", "rsc", "l2miss", "l3miss",
> > "remcsum_tx", "remcsum_rx".
> > 
> > 2. Print when both "true" and "false" for both JSON and non-JSON output.
> > Used for "udp_csum", "udp_zero_csum6_tx", "udp_zero_csum6_rx".
> > 
> > 3. Print JSON when both "true" and "false" and non-JSON only when
> > "false". Used for "learning".
> > 
> > I don't think we should be adding another format. We need to decide:
> > 
> > 1. What is the canonical format going forward?
> > 
> > 2. Do we change the format of existing options?
> > 
> > My preference is:
> > 
> > 1. Format 2. Can be implemented in a common helper used for all VXLAN
> > options.
> > 
> > 2. Yes. It makes all the boolean options consistent and avoids future
> > discussions such as this where a random option is used for a new option.
> 
> A fourth option is to us print_null(). The term null is confusing and people
> seem to avoid it.  But it is often used by python programmers as way to represent
> options. That would be my preferred option but others seem to disagree.
> 
> Option #2 is no good. Any printing of true/false in non-JSON output is a diveregence
> from the most common practice across iproute2.
> 
> That leaves #3 as the correct and best output.
> 
> FYI - The iproute2 maintainers are David Ahern and me. The kernel bits have
> other subsystem maintainers.
> 

Just to make sure I understand correctly, this means we are printing
"nolocalbypass" in non-JSON output because it's the non-default
settings, right?

If this is correct, then if we have another option in the future that
comes disabled by default, this means we are going to print it in
non-JSON output when enabled.

As the primary consumer of non-JSON output are humans, I am a bit
concerned since a succession of enabled/noenabled options is awkward and
difficult to read, in my opinion.

Wouldn't it be better to have non-JSON print out options only when
enabled, regardless of their default value?


