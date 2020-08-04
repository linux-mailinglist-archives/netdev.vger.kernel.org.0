Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0EB823C1C1
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 23:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgHDV6u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 17:58:50 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:37488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728052AbgHDV6t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 17:58:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596578328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kBOKJp8w9KZXZuz53OUDNEXh+d4eCdFrJ20ncB3veo8=;
        b=b1QsIG/QVtQOkn4M7M2iKIg1Sy/sbsnP206MdiKwgyfNFYXcju5UVk4b+4weBgJ6Zp/GP+
        T6xOutvq4JHM3YrWyhF3/uy/ccKabSeyjaJj9ZHC/x2m2SasDNUvpHaldxYLWuzUv3QsqH
        xcguSKJHsTUP9++qcGNCqolJP/34+ec=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-5AV7SC3ANV6U9ZNH25nRiA-1; Tue, 04 Aug 2020 17:58:39 -0400
X-MC-Unique: 5AV7SC3ANV6U9ZNH25nRiA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7483E1DE1;
        Tue,  4 Aug 2020 21:58:36 +0000 (UTC)
Received: from localhost.localdomain (ovpn-113-133.rdu2.redhat.com [10.10.113.133])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9845272E48;
        Tue,  4 Aug 2020 21:58:34 +0000 (UTC)
Date:   Tue, 4 Aug 2020 17:58:32 -0400
From:   Neil Horman <nhorman@redhat.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     izabela.bakollari@gmail.com, Neil Horman <nhorman@tuxdriver.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        David Miller <davem@davemloft.net>
Subject: Re: [Linux-kernel-mentees] [PATCHv2 net-next] dropwatch: Support
 monitoring of dropped frames
Message-ID: <20200804215832.GB72184@localhost.localdomain>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
 <20200804160908.46193-1-izabela.bakollari@gmail.com>
 <CAM_iQpV-AfX_=o0=ZhU2QzV_pmyWs8RKV0yyMuxFgwFAPwpnXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpV-AfX_=o0=ZhU2QzV_pmyWs8RKV0yyMuxFgwFAPwpnXw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 02:28:28PM -0700, Cong Wang wrote:
> On Tue, Aug 4, 2020 at 9:14 AM <izabela.bakollari@gmail.com> wrote:
> >
> > From: Izabela Bakollari <izabela.bakollari@gmail.com>
> >
> > Dropwatch is a utility that monitors dropped frames by having userspace
> > record them over the dropwatch protocol over a file. This augument
> > allows live monitoring of dropped frames using tools like tcpdump.
> >
> > With this feature, dropwatch allows two additional commands (start and
> > stop interface) which allows the assignment of a net_device to the
> > dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> > and receive them on the assigned interface, allowing tools like tcpdump
> > to monitor for them.
> >
> > With this feature, create a dummy ethernet interface (ip link add dev
> > dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> > these new commands, and then monitor dropped frames in real time by
> > running tcpdump -i dummy0.
> 
> drop monitor is already able to send dropped packets to user-space,
> and wireshark already catches up with this feature:
> 
> https://code.wireshark.org/review/gitweb?p=wireshark.git;a=commitdiff;h=a94a860c0644ec3b8a129fd243674a2e376ce1c8
> 
> So what you propose here seems pretty much a duplicate?
> 
I had asked Izabela to implement this feature as an alternative approach to
doing live capture of dropped packets, as part of the Linux foundation
mentorship program.  I'm supportive of this additional feature as the added code
is fairly minimal, and allows for the use of other user space packet monitoring
tools without additional code changes (i.e. tcpdump/snort/etc can now monitor
dropped packets without the need to augment those tools with netlink capture
code.

Best
Neil 
> Thanks.
> _______________________________________________
> Linux-kernel-mentees mailing list
> Linux-kernel-mentees@lists.linuxfoundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/linux-kernel-mentees
> 

