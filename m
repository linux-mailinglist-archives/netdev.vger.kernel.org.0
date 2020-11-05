Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE3AD2A7851
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 08:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729862AbgKEHvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 02:51:37 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54620 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726428AbgKEHvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 02:51:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604562695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yU86QuRtKM/Y4Zax6/FrQ+FteR5iy4SKvVc7zhtqlso=;
        b=hr+K2FCtBU8X6Rvpn8+MCTKmtbtjPCTpVVjvWZ8dwM2x0bA0MZQosHBqOf1tCLuvdueo/m
        BAYJNxWyCzG/pYMc3rczboqvwIHqJYZyecWymNzh+UCPUvX8zCzynOHJhYaamM9Xl95d+l
        WNVlFhWzSDXPqfzfdUE3rwsqM+CWi/c=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-555-NmYqgeL1MTKcLjp6rtJSbA-1; Thu, 05 Nov 2020 02:51:33 -0500
X-MC-Unique: NmYqgeL1MTKcLjp6rtJSbA-1
Received: by mail-pg1-f197.google.com with SMTP id 19so694001pgq.18
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 23:51:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yU86QuRtKM/Y4Zax6/FrQ+FteR5iy4SKvVc7zhtqlso=;
        b=Z7aUCVr/3JQIYCHOgsJIvJNbr6NRJ5xVJFfQNhlDM1oU1c7GRfv9A/j17bvlB8Ztso
         dbXg3zo5wSvaTVmVxhR6irdDPbAiWYZQn2T8CocUcwSfr066Zl8qAehNngKdLEHvT3D3
         Pvy1aWpNG+2WYOpeH6U9iSsLDhgVzT26mP53HdFdm7NiW6f2DBdwmPpchzzLHcI05A/h
         efcOZgLYWU9sqkBgtqA0ZYdMTM2QsKKafaOhZCd3GCCKyJKkQ3P8jlJDqTwhuymWvqxk
         F11Dr+wQxpLwdB5ehxZc+7MGD0TuvBhJKjZ3XmiFm8xcGQpGd1GkkkxAgnnrcTUjRgbD
         RsPw==
X-Gm-Message-State: AOAM531QQ6dY/wx1qYqMY05s78fcFCTB8gkAYEiRIXOf+LYt+WMuIoJK
        LHJNjhE4HYaCP0kOdGaHoz7a8YVdfUJIZNFzo6wRy76+BzyiLGLaTtf0I73DEOrqYdA5BPho+s3
        rgVMYxz5RLskzljo=
X-Received: by 2002:a17:90a:e615:: with SMTP id j21mr1259849pjy.74.1604562691824;
        Wed, 04 Nov 2020 23:51:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGErN0He0ayVgMptA2UKPsEQ+8WueFaNLhZW36R+noif9dB7stfieUy4IT40CPGUE5ukpy2w==
X-Received: by 2002:a17:90a:e615:: with SMTP id j21mr1259786pjy.74.1604562691579;
        Wed, 04 Nov 2020 23:51:31 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id k8sm1179051pgi.39.2020.11.04.23.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 23:51:30 -0800 (PST)
Date:   Thu, 5 Nov 2020 15:51:21 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
Message-ID: <20201105075121.GV2408@dhcp-12-153.nay.redhat.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
 <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 07:33:40PM -0700, David Ahern wrote:
> On 11/4/20 1:22 AM, Hangbin Liu wrote:
> > If we move this #ifdef HAVE_LIBBPF to bpf_legacy.c, we need to rename
> > them all. With current patch, we limit all the legacy functions in bpf_legacy
> > and doesn't mix them with libbpf.h. What do you think?
> 
> Let's rename conflicts with a prefix -- like legacy. In fact, those
> iproute2_ functions names could use the legacy_ prefix as well.
> 

Sorry, when trying to rename the functions. I just found another issue.
Even we fix the conflicts right now. What if libbpf add new functions
and we got another conflict in future? There are too much bpf functions
in bpf_legacy.c which would have more risks for naming conflicts..

With bpf_libbpf.c, there are less functions and has less risk for naming
conflicts. So I think it maybe better to not include libbpf.h in bpf_legacy.c.
What do you think?

Thanks
Hangbin

