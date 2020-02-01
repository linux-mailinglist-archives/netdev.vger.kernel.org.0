Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FB814FA86
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 21:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726469AbgBAUcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 15:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:56206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgBAUcm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 15:32:42 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0DE1205F4;
        Sat,  1 Feb 2020 20:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580589162;
        bh=ba9UrxP7GLLxyT2daazVv8aKC8ApTSnGTPNb3F4oOsY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SpyAUui0o6sQDMmfV8m4MliwNz6h6Ig1J4IoSaE/moeAIGw3zIFOpGEE4xoCfQ+RA
         7G0aCoM/MYveRJMPc741507S5gn5lj7CFhb3pVnWgKv5vZJuH8eL1AJR2Z9oGp+RnX
         kcmLS8uz3VXoMkIHeWypNvV8z1l77aRJbMYEuerg=
Date:   Sat, 1 Feb 2020 12:32:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] cls_rsvp: fix rsvp_policy
Message-ID: <20200201123240.04f871d3@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAM_iQpUYOLkZu9hn9+_XbMDTY5Q0aOq6qLrDt9PD0zh8kNPw1A@mail.gmail.com>
References: <20200131232704.161648-1-edumazet@google.com>
        <CAM_iQpUYOLkZu9hn9+_XbMDTY5Q0aOq6qLrDt9PD0zh8kNPw1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Feb 2020 11:21:55 -0800, Cong Wang wrote:
> On Fri, Jan 31, 2020 at 3:27 PM 'Eric Dumazet' via syzkaller
> <syzkaller@googlegroups.com> wrote:
> >
> > NLA_BINARY can be confusing, since .len value represents
> > the max size of the blob.
> >
> > cls_rsvp really wants user space to provide long enough data
> > for TCA_RSVP_DST and TCA_RSVP_SRC attributes.  
> 
> To clarify: for NLA_UNSPEC (0), len is the minimum length.

Nice clarification, that makes the patch obvious.

Looks like we have NLA_MIN_LEN now, from Wireguard, but I understand
for backports it's easier to stick to the original way of handling 
this.

Applied, thank you!

