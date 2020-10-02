Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646A7280D75
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 08:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgJBG1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 02:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBG1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 02:27:13 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5A7C0613D0;
        Thu,  1 Oct 2020 23:27:12 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kOEWp-00F5MO-KU; Fri, 02 Oct 2020 08:26:51 +0200
Message-ID: <7bf217ced62816b1bd3404bcfe279082347fb265.camel@sipsolutions.net>
Subject: Re: WARNING in cfg80211_connect
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+5f9392825de654244975@syzkaller.appspotmail.com>,
        a@unstable.cc, b.a.t.m.a.n@lists.open-mesh.org,
        davem@davemloft.net, david@fromorbit.com, dchinner@redhat.com,
        hch@lst.de, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, mareklindner@neomailbox.ch,
        netdev@vger.kernel.org, sw@simonwunderlich.de,
        syzkaller-bugs@googlegroups.com
Date:   Fri, 02 Oct 2020 08:26:50 +0200
In-Reply-To: <0000000000000a954d05b0a89a86@google.com> (sfid-20201002_063111_703712_8FE82506)
References: <0000000000000a954d05b0a89a86@google.com>
         (sfid-20201002_063111_703712_8FE82506)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-10-01 at 21:31 -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 16d4d43595b4780daac8fcea6d042689124cb094
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Jul 20 01:38:55 2016 +0000
> 
>     xfs: split direct I/O and DAX path
> 

LOL!

Unlike in many other cases, here I don't even see why it went down that
path. You'd think that Christoph's commit should have no effect
whatsoever, but here we are with syzbot claiming a difference?

I mean, often enough it says something is "caused" by a patch because
that caused e.g. generic netlink family renumbering, or because it
emitted some other ioctl() calls or whatnot that are invalid before and
valid after some other (feature) patch (or vice versa sometimes), but
you'd think that this patch would have _zero_ userspace observable
effect?

Which I guess means that the reproduction of this bug is random, perhaps
timing related.

johannes

