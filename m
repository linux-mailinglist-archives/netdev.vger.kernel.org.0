Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE92C126DEF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 20:26:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727097AbfLST0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 14:26:51 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:40889 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727006AbfLST0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 14:26:50 -0500
Received: by mail-pj1-f68.google.com with SMTP id bg7so2500254pjb.5;
        Thu, 19 Dec 2019 11:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DftQt3RvHQyNwWIgNSKTLfN/c3SX0qQWX26ozRGzZp0=;
        b=mtP4SWQnCQIayG+skanJOLqxzsX5SSz+dtlLgRE45niiPKGC3mbAWOiMX/6Lc4b4ih
         6bbi/asmpm4IKS0VqlltlPDuYq/EQ4zXQ8WHXS//ZnpEcMm7SDr33/LYuWQTR0PU1aGW
         hNE8Fng6+SSoD7sjs3qAsVeSxis8dkD1pmo5mi/hTFVjfRWaWN4eRA0ZzrkJFKhduVXl
         xprpHFEO4tzdah2P63fPndyxTa6g8J0ENULJXOzIXkkUmLbX40htOxvPZvHOHEpbWQI/
         MEHZnu8BZFSWIVlyi+S025B/eGwJduS3rfWh0aLGiRNGSk5pMFwY8kZmZxZYjMblC/I0
         x2yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=DftQt3RvHQyNwWIgNSKTLfN/c3SX0qQWX26ozRGzZp0=;
        b=BwiOespQBqVXdduSmgDaifB8/l/BvQZ2KtX2d0EyzRG8CS2d/nwp/pYlcj5GEJzpfR
         Vt+dqSqF5PrgSvXM5EFGOOzqtHdyDZAl5TAx1d9xIPVIA9ZpGhQcmV84pdERamGcOHjn
         m8SlXJyEZTG3fCUS32nzjdmhX96boT0N60xlkDXIf0+pkhc7KwIGoINd0UpkFkVagb27
         yYPtfp2YSqolNGBrOR2ZP2/2M2UCHIEWFbxmmRJ5fDfc/+XPjRrkoiqayMB7uYTvTZ4d
         MEDjdyOWp5GMG+PUExc85eAAMfToy3TEd4SO+8f60ieu91RA02RgMRUjBLENLCS/iF2E
         cRGA==
X-Gm-Message-State: APjAAAXWjRaS1Rl05/erSsJWZQCY1UzA+WTPblSy46RcMJqbrg/5EelG
        JFk2aUvOV80q2EA1rWveDc8=
X-Google-Smtp-Source: APXvYqxpl6RI/gMFNC+0gg2n47wEEeL4nKp6Q4ecO7bz3MFfwfHS9pRZNNDkxLKesrspcS9uUN+U5g==
X-Received: by 2002:a17:90a:22e7:: with SMTP id s94mr11758225pjc.12.1576783609833;
        Thu, 19 Dec 2019 11:26:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::6b48])
        by smtp.gmail.com with ESMTPSA id v19sm7603526pju.27.2019.12.19.11.26.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Dec 2019 11:26:48 -0800 (PST)
Date:   Thu, 19 Dec 2019 11:26:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edwin Peer <epeer@juniper.net>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Y Song <ys114321@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 0/2] unprivileged BPF_PROG_TEST_RUN
Message-ID: <20191219192645.5tbvxlhuugstokxf@ast-mbp.dhcp.thefacebook.com>
References: <20191219013534.125342-1-epeer@juniper.net>
 <CAH3MdRUTcd7rjum12HBtrQ_nmyx0LvdOokZmA1YuhP2WtGfJqA@mail.gmail.com>
 <69266F42-6D0B-4F0B-805C-414880AC253D@juniper.net>
 <20191219154704.GC4198@linux-9.fritz.box>
 <CEA84064-FF2B-4AA7-84EE-B768D6ABC077@juniper.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEA84064-FF2B-4AA7-84EE-B768D6ABC077@juniper.net>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 05:05:42PM +0000, Edwin Peer wrote:
> On 12/19/19, 07:47, "Daniel Borkmann" <daniel@iogearbox.net> wrote:
> 
> >  What about CAP_BPF?
> 
> What is the status of this? It might solve some of the problems, but it is still puts testing
> BPF outside reach of normal users.

why?
I think CAP_BPF is solving exactly what you're trying to achieve.
Use CAP_BPF to load _any_ program type and use prog_test_run to run it.
While discussing CAP_BPF during plumbers conf we realized that the kernel doesn't need
to check CAP_BPF for prog_test_run. It's user supplied data. No security risk. Though
the kernel needs to make sure that dangerous helpers are not used for prog_test_run.
Whether bpf_clone_redirect() is such helper is still tbd. Unpriv user can flood netdevs
without any bpf.

> > IIRC, there are also other issues e.g. you could abuse the test interface as a packet
> >  generator (bpf_clone_redirect) which is not something fully unpriv should be doing.
> 
> Good point. I suspect solutions exist - I'm trying to ascertain if they are worth pursuing
> or if the idea of unprivileged testing is a complete non-starter to begin with.
> 
> Are there other helpers of concern that come immediately to mind? A first stab might
> add these to the list in the verifier that require privilege. This has the drawback that
> programs that actually need this kind of functionality are beyond the test framework.

So far majority of programs require root-only verifier features. The programs are
getting more complex and benefit the most from testing. Relaxing test_run for unpriv
progs is imo very narrow use case. I'd rather use CAP_BPF.

