Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8BF499C01
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 23:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350107AbiAXV6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 16:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453926AbiAXVbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:31:18 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD988C0AD1AE;
        Mon, 24 Jan 2022 12:20:01 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id b5so3558109qtq.11;
        Mon, 24 Jan 2022 12:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gnv2KdJcWev5DXG7Zqmo5Ay+2m+nYtTgLdGUtEWY2Fo=;
        b=ZKm4XrV0bDIIfSfrRa1cBCMem6IENGQKiz41veeGoGimaA0Rzii13gOZYfiO+KP/x5
         +K3c9M15mBOnYky1E+sVZNL7Xlq4fyAL3E3usJWu6Mj9Jp0B9SsAfSsMmPkh5M5Fe5X+
         hIV7wfy5rsIAZKTEB4OTqfq09ZKInPLMQR8aag4/stNwGFdndh6N0ZfFPHeMw96OeTHw
         v0/CDRQD6GsjS8evqiCrxi2xa0dJdfGkk/m/F6kzdLk1xwDsPtm5n8BFEZX7jBANyD+Z
         RSgfFHU5foRYa1u+9BwbI0OjQHqzWFV5PyUtL4p2bNwrHV6U1Z3bnVqhMozv9JTvrumD
         j5Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gnv2KdJcWev5DXG7Zqmo5Ay+2m+nYtTgLdGUtEWY2Fo=;
        b=F47DzfZzzN5+tEzMnP/SH9uvUFcsEoLzJDon6l4WU6dHKhIm0xNbx+++YvtxuPr2Ix
         eWD0DR6TXUN/KIEaznHDdTyRDcErUfCz18ohxZeQ5bI1oH5FTHHZyhVZrpzNI26qTGRc
         Dimf1Z0i3Bn81ivLIvFehL6rbn3HvtG2F9W6GdFPRevUfNYXwJqKYMhutGgOSObafrsJ
         HUYLz414d8lZf/sdJuQzLjk/9hQiDEuDZxeUvBakh1LWcqHKh17pQuE3mJCqVqR8EnPD
         a6b3zYVQXxqlSNWCQndcsvkxyYUt2NDMBdYSuKGy1TumNMf9ccPROJAehBKPuc6dCYq5
         F+cw==
X-Gm-Message-State: AOAM5326S9hs7PeluI2Eiznz9/atlf3y2RzVZYBBc0z3h1js8/nBox+9
        0Zsg0wgNvsfT9f1f04lu2/E=
X-Google-Smtp-Source: ABdhPJx1x3LrfGZm1OMEN8K3yQ/Ev5a2v6oVIol5yow2jgTH1jCA1UCUOJ/M2hV/mZnJDCBxN9KUvA==
X-Received: by 2002:a05:622a:120a:: with SMTP id y10mr13844793qtx.429.1643055601015;
        Mon, 24 Jan 2022 12:20:01 -0800 (PST)
Received: from localhost ([2600:1700:65a0:ab60:8937:675:3cb3:d613])
        by smtp.gmail.com with ESMTPSA id t29sm7922203qtc.47.2022.01.24.12.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 12:20:00 -0800 (PST)
Date:   Mon, 24 Jan 2022 12:19:58 -0800
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Brian Vazquez <brianvv@google.com>,
        Jeffrey Ji <jeffreyjilinux@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jeffreyji <jeffreyji@google.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
Message-ID: <Ye8J7rMiiTwNNA6T@pop-os.localdomain>
References: <20220122000301.1872828-1-jeffreyji@google.com>
 <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
 <20220124092924.0eb17027@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220124092924.0eb17027@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 09:29:24AM -0800, Jakub Kicinski wrote:
> On Mon, 24 Jan 2022 09:13:12 -0800 Brian Vazquez wrote:
> > On Fri, Jan 21, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Sat, 22 Jan 2022 00:03:01 +0000 Jeffrey Ji wrote:  
> > > > From: jeffreyji <jeffreyji@google.com>
> > > >
> > > > Increment InMacErrors counter when packet dropped due to incorrect dest
> > > > MAC addr.
> > > >
> > > > example output from nstat:
> > > > \~# nstat -z "*InMac*"
> > > > \#kernel
> > > > Ip6InMacErrors                  0                  0.0
> > > > IpExtInMacErrors                1                  0.0
> > > >
> > > > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > > > with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> > > > counter was incremented.
> > > >
> > > > Signed-off-by: jeffreyji <jeffreyji@google.com>  
> > >
> > > How about we use the new kfree_skb_reason() instead to avoid allocating
> > > per-netns memory the stats?  
> > 
> > I'm not too familiar with the new kfree_skb_reason , but my
> > understanding is that it needs either the drop_monitor  or ebpf to get
> > the reason from the tracepoint, right? This is not too different from
> > using perf tool to find where the pkt is being dropped.
> > 
> > The idea here was to have a high level metric that is easier to find
> > for users that have less expertise on using more advance tools.
> 
> That much it's understood, but it's a trade off. This drop point
> existed for 20 years, why do we need to consume extra memory now?

kfree_skb_reason() is for tracing and tracing has overhead in
production, which is higher than just a percpu counter.

What memory overhead are you talking about? We have ~37 IP related
SNMP counters, this patch merely adds 1/37 memory overhead. So, what's the
point? :-/

Thanks.
