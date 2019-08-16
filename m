Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D943B90936
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 22:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727660AbfHPUKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 16:10:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726527AbfHPUKw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Aug 2019 16:10:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id EBDA554F66;
        Fri, 16 Aug 2019 20:10:51 +0000 (UTC)
Received: from carbon (ovpn-200-29.brq.redhat.com [10.40.200.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAE3D84D14;
        Fri, 16 Aug 2019 20:10:27 +0000 (UTC)
Date:   Fri, 16 Aug 2019 22:10:25 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, andrii.nakryiko@gmail.com,
        kernel-team@fb.com, Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Rostecki <mrostecki@opensuse.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sargun Dhillon <sargun@sargun.me>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] libbpf: relicense bpf_helpers.h and
 bpf_endian.h
Message-ID: <20190816221025.239e9e94@carbon>
In-Reply-To: <20190816171529.GA20099@kroah.com>
References: <20190816054543.2215626-1-andriin@fb.com>
        <20190816141001.4a879101@carbon>
        <23a87525-acf5-7a7e-b7b6-3c47b9760eeb@iogearbox.net>
        <20190816171529.GA20099@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 16 Aug 2019 20:10:52 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 19:15:29 +0200
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Fri, Aug 16, 2019 at 05:29:27PM +0200, Daniel Borkmann wrote:
> > On 8/16/19 2:10 PM, Jesper Dangaard Brouer wrote:  
> > > On Thu, 15 Aug 2019 22:45:43 -0700
> > > Andrii Nakryiko <andriin@fb.com> wrote:
> > >   
> > > > bpf_helpers.h and bpf_endian.h contain useful macros and BPF helper
> > > > definitions essential to almost every BPF program. Which makes them
> > > > useful not just for selftests. To be able to expose them as part of
> > > > libbpf, though, we need them to be dual-licensed as LGPL-2.1 OR
> > > > BSD-2-Clause. This patch updates licensing of those two files.  
> > > 
> > > I've already ACKed this, and is fine with (LGPL-2.1 OR BSD-2-Clause).
> > > 
> > > I just want to understand, why "BSD-2-Clause" and not "Apache-2.0" ?
> > > 
> > > The original argument was that this needed to be compatible with
> > > "Apache-2.0", then why not simply add this in the "OR" ?  
> > 
> > It's use is discouraged in the kernel tree, see also LICENSES/dual/Apache-2.0 (below) and
> > statement wrt compatibility from https://www.apache.org/licenses/GPL-compatibility.html:
> > 
> >   Valid-License-Identifier: Apache-2.0
> >   SPDX-URL: https://spdx.org/licenses/Apache-2.0.html
> >   Usage-Guide:
> >     Do NOT use. The Apache-2.0 is not GPL2 compatible. [...]  

You didn't quote the continuation from LICENSES/dual/Apache-2.0

Usage-Guide:
  Do NOT use. The Apache-2.0 is not GPL2 compatible. It may only be used
  for dual-licensed files where the other license is GPL2 compatible.
  If you end up using this it MUST be used together with a GPL2 compatible
  license using "OR".

The way I read it, is that you can use it with "OR", like:
 SPDX-License-Identifier: GPL-2.0 OR Apache-2.0

> That is correct, don't use Apache-2 code in the kernel please.  Even as
> a dual-license, it's a total mess.

Good, I just wanted to understand why.  

> Having this be BSD-2 is actually better, as it should be fine to use
> with Apache 2 code, right?

Yes, that is also my understanding. And it better be as this is needed,
as we want libbpf to be used by https://github.com/iovisor/bcc/ which
is Apache-2.0.

> Jesper, do you know of any license that BSD-2 is not compatible with
> that is needed?

No.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer
