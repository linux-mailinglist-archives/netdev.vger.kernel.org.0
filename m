Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F6230FB55
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 19:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbhBDSZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 13:25:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44078 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239044AbhBDSYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 13:24:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612462999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e8TJ1d9PgMit7FzldeT8W98OjOwAQZBN5VK4XVZBszg=;
        b=aYTjkwbJqckJQIsn/u3dqxbELrIHQ1iPk+VPHXvRCFvELeT26NU70y4KgS8xLdFH68BvOM
        ZDzOGGk41cI+pmpDO8nNHu619KIU3dzKIf+esLNlVA/M6sH3j587cOxlk+ogpLZPbveWbQ
        sfdlCXrEu1xMFKADiG3Wce9wxHQx+Zc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-512-flSURSWDOi61PjQU7CcuZw-1; Thu, 04 Feb 2021 13:23:14 -0500
X-MC-Unique: flSURSWDOi61PjQU7CcuZw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A08D815722;
        Thu,  4 Feb 2021 18:23:13 +0000 (UTC)
Received: from horizon.localdomain (ovpn-113-166.rdu2.redhat.com [10.10.113.166])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 68BD55C290;
        Thu,  4 Feb 2021 18:23:13 +0000 (UTC)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id E2539C2CDA; Thu,  4 Feb 2021 15:23:10 -0300 (-03)
Date:   Thu, 4 Feb 2021 15:23:10 -0300
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
To:     wenxu <wenxu@ucloud.cn>
Cc:     i.maximets@ovn.org, netdev@vger.kernel.org
Subject: Re: [PATCH net] net/sched: cls_flower: Return invalid for unknown
 ct_state flags rules
Message-ID: <20210204182310.GN3399@horizon.localdomain>
References: <1612412244-26434-1-git-send-email-wenxu@ucloud.cn>
 <20210204133856.GH3399@horizon.localdomain>
 <ef18cecf-f3ff-28b2-c53d-049722843c6d@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef18cecf-f3ff-28b2-c53d-049722843c6d@ucloud.cn>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 11:50:53PM +0800, wenxu wrote:
> 
> 在 2021/2/4 21:38, Marcelo Ricardo Leitner 写道:
> > Hi,
> >
> > On Thu, Feb 04, 2021 at 12:17:24PM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> Reject the unknown ct_state flags of cls flower rules. This also make
> >> the userspace like ovs to probe the ct_state flags support in the
> >> kernel.
> > That's a good start but it could also do some combination sanity
> > checks, like ovs does in validate_ct_state(). For example, it does:
> >
> >       if (state && !(state & CS_TRACKED)) {
> >           ds_put_format(ds, "%s: invalid connection state: "
> >                         "If \"trk\" is unset, no other flags are set\n",
> >
> So this sanity checks maybe also need to be added in the ovs kernel modules?
> 
> The kernel datapath can work without ovs-vswitchd.

IMHO that would be nice, yes.

  Marcelo

