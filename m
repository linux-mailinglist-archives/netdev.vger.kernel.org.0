Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE8625A1D
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 23:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbfEUVn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 17:43:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33793 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727525AbfEUVn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 17:43:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so176977pgt.1;
        Tue, 21 May 2019 14:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e7IKvyivpndLhr4yI3VpbyOaZKIBT4zTT+7VEzq4/yg=;
        b=RTh7zDv9ySF4qF7LWS+cwTOhCwHO5zR779oCHDbwI9D1YTzO8vo0ZLAvIhSGrouFqA
         8+Uog6NRFZPdzwFuJzg07cQc582DJe67ocOk7Zi0h17KTC48SgIFpoDBf/NhdaAO81nr
         qOp9sZnXRMU+LVk6MmLojAfzW/9d4Bwdujg1ziINY+H5Dfn9QPgdAguR0WK6ozcmwD36
         NeTD9LNwz51pW0wEKunht8NuVihGEpO+nFtviNbK7Lnx8UlLzcjXk16CAGQlCo94E7d4
         InnByzySabp62mQsB3iRyUYNBnGWPtGZXt3RzNER/fB7CeHlBl1hbnY81nEUGQ2CWbMP
         218g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e7IKvyivpndLhr4yI3VpbyOaZKIBT4zTT+7VEzq4/yg=;
        b=hP8tV0R8zl4oSluGSNQP0ppwRezBL61dsRvrJgc/XSvix2d4t6x+UZMebNB6lNzdoP
         iJkc5XYDdFmrk+MvCxm/1dqAEnRRwWOaig3FtVXbzF7zgYC1nHbHpO0BOJFGnaBW0mlU
         RU+eJ5HQMbDdSsxP0hOzyN3NSkD/A6RnDOFn9IQfQXzx+ye6MG+BdMfsDUp7SESqSTDa
         VwNE0xy/0NoIk7FrA8g4Ma7rS342tNsPIcdbWauqsLyOee71QMhv6OhGcby3p8nYotwm
         VVEc+PMz53dtRsiEFmyeK58y9kYw1+8W1sZdJXPijTfOn13/br6IdV+Kaf8dflmH1SFN
         1KGA==
X-Gm-Message-State: APjAAAXU8qhGZYntftH77IfYR/0nLru7tCHKqkiOK6OudZBoeWsX/KlL
        U6wV1AFPV4ivx4OabdApX/A=
X-Google-Smtp-Source: APXvYqyXCHh8uXQFP3KQv0j0ixsVq6rBqUAMPDz8rLx8VFeIluYAifcXl8GKq0dYSta6Z3il8XawEg==
X-Received: by 2002:a62:62c1:: with SMTP id w184mr89353146pfb.95.1558475008888;
        Tue, 21 May 2019 14:43:28 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:1eff])
        by smtp.gmail.com with ESMTPSA id q125sm36497281pfq.62.2019.05.21.14.43.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 14:43:28 -0700 (PDT)
Date:   Tue, 21 May 2019 14:43:26 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190521214325.rr7emn5z3b7wqiiy@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521173618.2ebe8c1f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521173618.2ebe8c1f@gandalf.local.home>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 05:36:18PM -0400, Steven Rostedt wrote:
> On Tue, 21 May 2019 13:55:34 -0700
> Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> 
> > > The reasons for these patches is because I cannot do the same with the existing
> > > implementation.  Yes, I can do some of it or use some workarounds to accomplish
> > > kind of the same thing, but at the expense of not being able to do what I need
> > > to do but rather do some kind of best effort alternative.  That is not the goal
> > > here.  
> > 
> > what you call 'workaround' other people call 'feature'.
> > The kernel community doesn't accept extra code into the kernel
> > when user space can do the same.
> 
> If that was really true, all file systems would be implemented on
> FUSE ;-)
> 
> I was just at a technical conference that was not Linux focused, and I
> talked to a lot of admins that said they would love to have Dtrace
> scripts working on Linux unmodified.
> 
> I need to start getting more familiar with the workings of eBPF and
> then look at what Dtrace has to see where something like this can be
> achieved, but right now just NACKing patches outright isn't being
> helpful. If you are not happy with this direction, I would love to see
> conversations where Kris shows you exactly what is required (from a
> feature perspective, not an implementation one) and we come up with a
> solution.

Steve,
sounds like you've missed all prior threads.
The feedback was given to Kris it was very clear:
implement dtrace the same way as bpftrace is working with bpf.
No changes are necessary to dtrace scripts
and no kernel changes are necessary.

