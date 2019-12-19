Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E6127004
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 22:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbfLSVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 16:52:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40373 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfLSVwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 16:52:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id q8so4034548pfh.7;
        Thu, 19 Dec 2019 13:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=19fYY21FdcsllCjYCHnTW3qaemgvQSO5gcp3lm+v4d4=;
        b=lRELkidiNOrjVf+yuaCXSyKcjdOyNozmT6LeEzQFYTvJ0C9EI6bGW4hd5pge9dsgIS
         8vR8OE0cQ8G8mpPHSGrB5aGSBKkR+QfDugpa3ggSJad9JJ6i3v2IQ/KUp6Lk+cjf8MB+
         Jjy6ZDtSoHHClzUYy7y25O14ZH1bfgtbjEMNeMPIW/SVi8MaOwNwX1QMnCiVftzwQYkd
         OeLNHlvN6QdNOSm4H9jy4T/YkRoTaP30UIjDTOUNHBzy4ctQCybPOOjkFjaEyMKhuoIB
         n1P/SSLhAy2EAkgIxuUi6izoAWSUXsMkr2td3lFBbsv47ibGWZuYEk+P0HIwCeBrTxp/
         hivg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=19fYY21FdcsllCjYCHnTW3qaemgvQSO5gcp3lm+v4d4=;
        b=HfmDT4oTWWBPPY1Dm3OiW2SQbC4qQgraFM2Qij8zfig8DWO9bUUCqV54AUwla8Bb0q
         no/yhIm3VpeeZn2WQlA9mcDeNOrP6dmprnnvBU55LVHhnKQ49FUEB83ahqfSt03PLz3x
         IaqSgtI1KfvkjAlIyv3l4lzF2xgwRcpwlQdpFTal/uMYBhXTQrMyfW7EqiS/Lb74TI0J
         l8zJKjuQu53tqQUWco92A01ZFpqoxqQQ+CMg2OKLzU2WMZdCGDkZtlXIon2KwvyaWKfI
         JNIGLAOrdLQM9oqiFoZdWsrG+3Co5aqOcn9U3lsM+fItH8J0hzC7rbkAvirKBKvfupXM
         kMGA==
X-Gm-Message-State: APjAAAWrr4axSQ6s3n93Fbsyc3PzJ2UgpoWYxHR3YtTvQOwU30ukd11f
        e2h8fEtcMKRgUFepxSIK2TQ=
X-Google-Smtp-Source: APXvYqz4kPLWNA6sykT74GBZtA3xnT9mo4FylbrLhgBOkKCQy+VSqvZWF5ZuIoOIpNyD5fBEOg+IEQ==
X-Received: by 2002:a62:788a:: with SMTP id t132mr12210438pfc.134.1576792324771;
        Thu, 19 Dec 2019 13:52:04 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::b180])
        by smtp.gmail.com with ESMTPSA id t137sm8510340pgb.40.2019.12.19.13.52.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 13:52:03 -0800 (PST)
Date:   Thu, 19 Dec 2019 13:52:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edwin Peer <epeer@juniper.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Y Song <ys114321@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Message-ID: <20191219215200.3qvg52jjy63i6tly@ast-mbp.dhcp.thefacebook.com>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
 <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
 <20191219154704.GC4198@linux-9.fritz.box>
 <CEA84064-FF2B-4AA7-84EE-B768D6ABC077@juniper.net>
 <20191219192645.5tbvxlhuugstokxf@ast-mbp.dhcp.thefacebook.com>
 <9A7BE6FA-92FD-411F-BF8C-80484F1B0FBA@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9A7BE6FA-92FD-411F-BF8C-80484F1B0FBA@juniper.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 08:06:21PM +0000, Edwin Peer wrote:
> On 12/19/19, 11:26, "Alexei Starovoitov" <alexei.starovoitov@gmail.com> wrote:
> 
> > On Thu, Dec 19, 2019 at 05:05:42PM +0000, Edwin Peer wrote:
> >> On 12/19/19, 07:47, "Daniel Borkmann" <daniel@iogearbox.net> wrote:
> >> 
> >> >  What about CAP_BPF?
> >> 
> >> What is the status of this? It might solve some of the problems, but it is still puts testing
> >> BPF outside reach of normal users.
> >    
> > why?
> > I think CAP_BPF is solving exactly what you're trying to achieve.
> 
> I'm trying to provide access to BPF testing infrastructure for unprivileged
> users (assuming it can be done in a safe way, which I'm as yet unsure of).
> CAP_BPF is not the same thing, because at least some kind of root
> intervention is required to attain CAP_BPF in the first place.

yes and test infra can bet setup with CAP_BPF.
The desire of testing frameworks to work without root was one of the main
motivations for us to work on CAP_BPF.

> > Whether bpf_clone_redirect() is such helper is still tbd. Unpriv user can flood netdevs
> > without any bpf.
>    
> True, but presumably such would still be subject to administrator
> controlled QoS and firewall policy? Also unprivileged users presumably
> can't create arbitrary packets coming from spoofed IPs / MACs, which I
> believe requires CAP_NET_RAW?
>  
> >> Are there other helpers of concern that come immediately to mind? A first stab might
> >> add these to the list in the verifier that require privilege. This has the drawback that
> >> programs that actually need this kind of functionality are beyond the test framework.
> >    
> >   So far majority of programs require root-only verifier features. The programs are
> >   getting more complex and benefit the most from testing. Relaxing test_run for unpriv
> >   progs is imo very narrow use case. I'd rather use CAP_BPF.
>     
> The more elaborate proposal called for mocking these aspects for
> testing, which could conceivably resolve this? That said, I see an
> incremental path to this, adding such as needed. The narrowness
> of the use case really depends on exactly what you're trying to do.
> Something in XDP, for example, has very little kernel dependencies
> (possibly none that would be affected here) and represents an entire
> class of use cases that could have unprivileged testing be supported.

I'm looking at public and non-public XDP progs and none of them are verifiable
as unpriv. I don't think it's a good idea to build infra for toy programs.
