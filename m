Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B951F14FBFD
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 07:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgBBGQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 01:16:14 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55060 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726132AbgBBGQO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 01:16:14 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iy8YF-0004rp-J9; Sun, 02 Feb 2020 07:16:11 +0100
Date:   Sun, 2 Feb 2020 07:16:11 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
Message-ID: <20200202061611.GN795@breakpoint.cc>
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com>
 <20200131220807.GJ795@breakpoint.cc>
 <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
 <20200131233659.GM795@breakpoint.cc>
 <CAM_iQpWbejoFPbFDSfUtvhFbU3DjhV6NAkPQ+-mirY_QEMHxkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpWbejoFPbFDSfUtvhFbU3DjhV6NAkPQ+-mirY_QEMHxkA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > In order to prevent breaking userspace, perhaps make it so that the
> > kernel caps cfg.max at twice that value?  Would allow storing up to
> > 16777216 addresses with an average chain depth of 16 (which is quite
> > large).  We could increase the max limit in case someone presents a use
> > case.
> >
> 
> Not sure if I understand this, I don't see how cap'ing cfg->max could
> help prevent breaking user-space? Are you suggesting to cap it with
> HASHLIMIT_MAX_SIZE too? Something like below?
> 
> +       if (cfg->max > 2 * HASHLIMIT_MAX_SIZE)
> +               cfg->max = 2 * HASHLIMIT_MAX_SIZE;
> 

Yes, thats what I meant, cap the user-provided value to something thats
going to be less of a problem.

But now that I read it, the "2 *" part looks really silly, so I suggst
to go with " > FOO_MAX", else its not a maximum value after all.
