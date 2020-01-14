Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9D113B2FE
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 20:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbgANTaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 14:30:30 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:28975 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANTa3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 14:30:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579030228; x=1610566228;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kERWQcPBD6U7cttKEBKCe+VLCzWuIvbuKzU3wI+3unU=;
  b=scxTRtqwvDG4gt1n++qHyLf4X19Tko65fdiRcC7WpWD5MVHiQtJtdnzo
   OThiQrtjSpn3uQIfrrGpeWVu2SectF68SmPqGQr1KFv8quvJLK4imwmNJ
   kX9anqxYP/n5V+uRG0u9NzjlsGPPJshzWE9wFIQmGnkWCFhsuPnEyPSx/
   I=;
IronPort-SDR: 1XWTl0ZFPeAlOX/4U8kY6SYcBuV6mXXPHzXHV+KPO++vV8ZqU64Zy3g8i6YkQ3MNzJ1c7HsLNp
 881qx3hEFFTA==
X-IronPort-AV: E=Sophos;i="5.70,319,1574121600"; 
   d="scan'208";a="18710229"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-807d4a99.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 14 Jan 2020 19:30:15 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-807d4a99.us-east-1.amazon.com (Postfix) with ESMTPS id F0146A29E9;
        Tue, 14 Jan 2020 19:30:07 +0000 (UTC)
Received: from EX13D10UWB004.ant.amazon.com (10.43.161.121) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 14 Jan 2020 19:29:52 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D10UWB004.ant.amazon.com (10.43.161.121) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Tue, 14 Jan 2020 19:29:52 +0000
Received: from dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com
 (172.22.96.68) by mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP
 Server id 15.0.1367.3 via Frontend Transport; Tue, 14 Jan 2020 19:29:52 +0000
Received: by dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com (Postfix, from userid 4335130)
        id 2E01D40E7F; Tue, 14 Jan 2020 19:29:52 +0000 (UTC)
Date:   Tue, 14 Jan 2020 19:29:52 +0000
From:   Anchal Agarwal <anchalag@amazon.com>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
CC:     Peter Zijlstra <peterz@infradead.org>,
        "Singh, Balbir" <sblbir@amazon.com>,
        "Valentin, Eduardo" <eduval@amazon.com>,
        "boris.ostrovsky@oracle.com" <boris.ostrovsky@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "sstabellini@kernel.org" <sstabellini@kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "x86@kernel.org" <x86@kernel.org>,
        "roger.pau@citrix.com" <roger.pau@citrix.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "Kamata, Munehisa" <kamatam@amazon.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "konrad.wilk@oracle.co" <konrad.wilk@oracle.co>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "fllinden@amaozn.com" <fllinden@amaozn.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        <anchalag@amazon.com>
Subject: Re: [RFC PATCH V2 11/11] x86: tsc: avoid system instability in
 hibernation
Message-ID: <20200114192952.GA26755@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
References: <20200107234526.GA19034@dev-dsk-anchalag-2a-9c2d1d96.us-west-2.amazon.com>
 <20200108105011.GY2827@hirez.programming.kicks-ass.net>
 <20200110153520.GC8214@u40b0340c692b58f6553c.ant.amazon.com>
 <20200113101609.GT2844@hirez.programming.kicks-ass.net>
 <857b42b2e86b2ae09a23f488daada3b1b2836116.camel@amazon.com>
 <20200113124247.GG2827@hirez.programming.kicks-ass.net>
 <CAJZ5v0jv+5aLY3N4wFSitu61o9S8tJWEWGGn1Xyw-P82_TwFdQ@mail.gmail.com>
 <CAJZ5v0imNbbch=NWAdgVKf_hjwRrEiWAL8SFNwe6rW_SjgYzrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAJZ5v0imNbbch=NWAdgVKf_hjwRrEiWAL8SFNwe6rW_SjgYzrw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 12:30:02AM +0100, Rafael J. Wysocki wrote:
> On Mon, Jan 13, 2020 at 10:50 PM Rafael J. Wysocki <rafael@kernel.org> wrote:
> >
> > On Mon, Jan 13, 2020 at 1:43 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Mon, Jan 13, 2020 at 11:43:18AM +0000, Singh, Balbir wrote:
> > > > For your original comment, just wanted to clarify the following:
> > > >
> > > > 1. After hibernation, the machine can be resumed on a different but compatible
> > > > host (these are VM images hibernated)
> > > > 2. This means the clock between host1 and host2 can/will be different
> > > >
> > > > In your comments are you making the assumption that the host(s) is/are the
> > > > same? Just checking the assumptions being made and being on the same page with
> > > > them.
> > >
> > > I would expect this to be the same problem we have as regular suspend,
> > > after power off the TSC will have been reset, so resume will have to
> > > somehow bridge that gap. I've no idea if/how it does that.
> >
> > In general, this is done by timekeeping_resume() and the only special
> > thing done for the TSC appears to be the tsc_verify_tsc_adjust(true)
> > call in tsc_resume().
> 
> And I forgot about tsc_restore_sched_clock_state() that gets called
> via restore_processor_state() on x86, before calling
> timekeeping_resume().
>
In this case tsc_verify_tsc_adjust(true) this does nothing as
feature bit X86_FEATURE_TSC_ADJUST is not available to guest. 
I am no expert in this area, but could this be messing things up?

Thanks,
Anchal
