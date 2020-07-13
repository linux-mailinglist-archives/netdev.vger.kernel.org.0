Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524CB21E032
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:52:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgGMSv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:51:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59316 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726321AbgGMSvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:51:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594666314;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type;
        bh=NE8QstdkXBadVczE5994Oj7CCPjqHJwH5n+BVES8+JQ=;
        b=JhCqJmV5rxof6ZsrCIKT4hWdtsZ/AMK7Ae4tzShS7uwxJuSkN8vEVGblK40M3sbS2LmJaN
        5UqP53LLwUGmBbESQZ+FNJg5gQLb3NmUTf0lOHtvMu8MOPKwXZWVkQIUsZx6xVWA8Jd87l
        hF17bF8CyGiOR/iD9naiGycfGvqlZEQ=
Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com
 [209.85.161.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-DSmZJrZAPHCiPD7mOyC4Aw-1; Mon, 13 Jul 2020 14:51:52 -0400
X-MC-Unique: DSmZJrZAPHCiPD7mOyC4Aw-1
Received: by mail-oo1-f70.google.com with SMTP id m6so9682372oop.2
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 11:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NE8QstdkXBadVczE5994Oj7CCPjqHJwH5n+BVES8+JQ=;
        b=ck0Fxc5tWfXMGwKNc65cF8jae0DxI/nXrh7hek71+UHcqtz745IR5tZYFXhImxV3gf
         exgBN2BIYcC1cG8FsM/PyiY4BGRk24zh2RrrBh5602bTaORtcLQ5FeWYRQ0D0sjiHt/q
         QA1pSp9mykiGakOC13xYDVZKcJwbt2MUIBQ0x1Chhf02NL8bZnRvvby8Y9B4adggl4K4
         WnbYaK+7GNV8s33RJ3LU9n+VlU0hJvF1UmXOVzunassdtZgqoyI4YwDMYB9eTTQ050qp
         OMmz63V01nbKWWb+fytg4SAIsbNiezoVSGZnZ8+RPXM1iGqJ8S27KIqu7itczzst9nUN
         XMkQ==
X-Gm-Message-State: AOAM530jrrj3w9l2BYaBLdBFnx09/4+nhXD/MNZ7qQ7ChWrOnJq3r2vl
        jKD3ol3W9tYmhPg0HcnsL34K26eTBLWOP7j/cdV4adNUztUZMBI89z0XgpMiIvmAqTtER5nmxco
        tEGjnjnFsdVBJpRmidZYA86S+VHxrpB1l
X-Received: by 2002:aca:d546:: with SMTP id m67mr739974oig.5.1594666311352;
        Mon, 13 Jul 2020 11:51:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzOZUefhQPS3xPvL9Y2ictlsrs5HVSdMrxPA5gkw5o0+VPaZbgsMPD4+ZdGp4vhU7x1pAnQFPkWAtNDKnt68r0=
X-Received: by 2002:aca:d546:: with SMTP id m67mr739961oig.5.1594666311041;
 Mon, 13 Jul 2020 11:51:51 -0700 (PDT)
MIME-Version: 1.0
From:   Jarod Wilson <jarod@redhat.com>
Date:   Mon, 13 Jul 2020 14:51:39 -0400
Message-ID: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
Subject: [RFC] bonding driver terminology change proposal
To:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of an effort to help enact social change, Red Hat is
committing to efforts to eliminate any problematic terminology from
any of the software that it ships and supports. Front and center for
me personally in that effort is the bonding driver's use of the terms
master and slave, and to a lesser extent, bond and bonding, due to
bondage being another term for slavery. Most people in computer
science understand these terms aren't intended to be offensive or
oppressive, and have well understood meanings in computing, but
nonetheless, they still present an open wound, and a barrier for
participation and inclusion to some.

To start out with, I'd like to attempt to eliminate as much of the use
of master and slave in the bonding driver as possible. For the most
part, I think this can be done without breaking UAPI, but may require
changes to anything accessing bond info via proc or sysfs.

My initial thought was to rename master to aggregator and slaves to
ports, but... that gets really messy with the existing 802.3ad bonding
code using both extensively already. I've given thought to a number of
other possible combinations, but the one that I'm liking the most is
master -> bundle and slave -> cable, for a number of reasons. I'd
considered cable and wire, as a cable is a grouping of individual
wires, but we're grouping together cables, really -- each bonded
ethernet interface has a cable connected, so a bundle of cables makes
sense visually and figuratively. Additionally, it's a swap made easier
in the codebase by master and bundle and slave and cable having the
same number of characters, respectively. Granted though, "bundle"
doesn't suggest "runs the show" the way "master" or something like
maybe "director" or "parent" does, but those lack the visual aspect
present with a bundle of cables. Using parent/child could work too
though, it's perhaps closer to the master/slave terminology currently
in use as far as literal meaning.

So... Thoughts?

For reference, a work-in-progress adaptation from master/slave to
bundle/cable has a diffstat that is currently summarized as:

 37 files changed, 2607 insertions(+), 2571 deletions(-)

-- 
Jarod Wilson
jarod@redhat.com

