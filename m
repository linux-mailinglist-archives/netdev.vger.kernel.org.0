Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 442D4A27E9
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 22:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728176AbfH2UZm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 16:25:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727540AbfH2UZm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 16:25:42 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 766F4307D91F;
        Thu, 29 Aug 2019 20:25:41 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0331A196B2;
        Thu, 29 Aug 2019 20:25:32 +0000 (UTC)
Date:   Thu, 29 Aug 2019 22:25:30 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>, luto@amacapital.net,
        davem@davemloft.net, peterz@infradead.org, rostedt@goodmis.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next 1/3] capability: introduce CAP_BPF and
 CAP_TRACING
Message-ID: <20190829222530.3c6163ac@carbon>
In-Reply-To: <87imqfhmo2.fsf@toke.dk>
References: <20190829051253.1927291-1-ast@kernel.org>
        <87ef14iffx.fsf@toke.dk>
        <20190829172410.j36gjxt6oku5zh6s@ast-mbp.dhcp.thefacebook.com>
        <87imqfhmo2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 29 Aug 2019 20:25:41 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Aug 2019 20:05:49 +0200
Toke Høiland-Jørgensen <toke@redhat.com> wrote:

> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Aug 29, 2019 at 09:44:18AM +0200, Toke Høiland-Jørgensen wrote:  
> >> Alexei Starovoitov <ast@kernel.org> writes:
> >>   
> >> > CAP_BPF allows the following BPF operations:
> >> > - Loading all types of BPF programs
> >> > - Creating all types of BPF maps except:
> >> >    - stackmap that needs CAP_TRACING
> >> >    - devmap that needs CAP_NET_ADMIN
> >> >    - cpumap that needs CAP_SYS_ADMIN  
> >> 
> >> Why CAP_SYS_ADMIN instead of CAP_NET_ADMIN for cpumap?  
> >
> > Currently it's cap_sys_admin and I think it should stay this way
> > because it creates kthreads.  
> 
> Ah, right. I can sorta see that makes sense because of the kthreads, but
> it also means that you can use all of XDP *except* cpumap with
> CAP_NET_ADMIN+CAP_BPF. That is bound to create confusion, isn't it?
 
Hmm... I see 'cpumap' primarily as a network stack feature.  It is about
starting the network stack on a specific CPU, allocating and building
SKBs on that remote CPU.  It can only be used together with XDP_REDIRECT.
I would prefer CAP_NET_ADMIN like the devmap, to keep the XDP
capabilities consistent.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
