Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E346A14FEC2
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 19:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgBBS1r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 13:27:47 -0500
Received: from mail-oi1-f172.google.com ([209.85.167.172]:40857 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbgBBS1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 13:27:47 -0500
Received: by mail-oi1-f172.google.com with SMTP id a142so12605106oii.7;
        Sun, 02 Feb 2020 10:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PKuFxkZDnS9TKxCrpDD9+C0ZzYsE3eaSO23EVA/7rvU=;
        b=NGaUVBMRSTasyEQmZjrfw0txkYepNe6+VLyEh4NAcISkiKq3tLf4/l7VM/6J6LJrQT
         L5dbk7n2wTUuzf1s8OYSSZOgRZ+cnkaAzE+nE0BVk0+drYJvH8YUhP3KMz2NzyQ7eeLY
         54oF53IHHWd+GmKUcEQcmpolVmkR6N2Doi/RXsNUCbUGCWMf2XxYnkvAnDenD8mOdMKZ
         KojQRJQ/lC9gySeGNsowk0N1fFsA6JgCozF+9zAPIwxomIjjoucmhBHBCiuMUZlYfGCc
         p8qiER6ugrlGOCAKbn/spkRqCt40BtVfxLKzVT557tb7teYigq7Rxo/AK6LS14I4NV/r
         8FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PKuFxkZDnS9TKxCrpDD9+C0ZzYsE3eaSO23EVA/7rvU=;
        b=d4oPCR/b55CEXz5BT0mvgW1MY8iptYqkM5ws/sLu4V8mywNgLRfY8ZvcoVxM/eN7C8
         K995RtdbhDnk4p7ANRjo6S7S/F3URTfUiXNh4fNUES/n274b/cEWuJI4dBmd4ba3o3nM
         NDDCif2xByyjan2DFTXwFb7uun6qdF2M/u6nSAoThYIBfv95iGISKUAxAe9rgNrk5WsU
         WrS8bw3dllpm0xrZfPjaLfac4OuDhdM84rDh+zg3KF9cmCYzY+1gSI/RrUBk4AofxUIq
         pQCaoRzUzuivyQtpbI6TIAflSFAwldjqtqNQtYALkFBSCOjlVIiIUgw2IhcjgQVgavGW
         JwvA==
X-Gm-Message-State: APjAAAVwfoV+mWSZTD2KLgeMC3W+JoNL0mU3asAKTpwWI/KZUgM+7kR7
        nBlF3xvmPMbaUDp7XhnBNvmxMZDCbEYpk0rWp9AXAyh1Zvk=
X-Google-Smtp-Source: APXvYqyv7e0uzHpUVsQM3CLJes5VcTyb539BUOOKIoVUu71InW03gL7NYNFBbjOlLrEpbgvO4vEHxJLmyIDclOwiS9s=
X-Received: by 2002:aca:cf07:: with SMTP id f7mr3152983oig.5.1580668065145;
 Sun, 02 Feb 2020 10:27:45 -0800 (PST)
MIME-Version: 1.0
References: <20200131205216.22213-1-xiyou.wangcong@gmail.com>
 <20200131205216.22213-4-xiyou.wangcong@gmail.com> <20200131220807.GJ795@breakpoint.cc>
 <CAM_iQpVVgkP8u_9ez-2fmrJDdKoFwAxGcbE3Mmk3=7cv4W_QJQ@mail.gmail.com>
 <20200131233659.GM795@breakpoint.cc> <CAM_iQpWbejoFPbFDSfUtvhFbU3DjhV6NAkPQ+-mirY_QEMHxkA@mail.gmail.com>
 <20200202061611.GN795@breakpoint.cc>
In-Reply-To: <20200202061611.GN795@breakpoint.cc>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 2 Feb 2020 10:27:34 -0800
Message-ID: <CAM_iQpXC9FnisZwLwWHQEbi-She3HywO5SJAxSS1cf_Pntn-6Q@mail.gmail.com>
Subject: Re: [Patch nf 3/3] xt_hashlimit: limit the max size of hashtable
To:     Florian Westphal <fw@strlen.de>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 1, 2020 at 10:16 PM Florian Westphal <fw@strlen.de> wrote:
>
> Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > > In order to prevent breaking userspace, perhaps make it so that the
> > > kernel caps cfg.max at twice that value?  Would allow storing up to
> > > 16777216 addresses with an average chain depth of 16 (which is quite
> > > large).  We could increase the max limit in case someone presents a use
> > > case.
> > >
> >
> > Not sure if I understand this, I don't see how cap'ing cfg->max could
> > help prevent breaking user-space? Are you suggesting to cap it with
> > HASHLIMIT_MAX_SIZE too? Something like below?
> >
> > +       if (cfg->max > 2 * HASHLIMIT_MAX_SIZE)
> > +               cfg->max = 2 * HASHLIMIT_MAX_SIZE;
> >
>
> Yes, thats what I meant, cap the user-provided value to something thats
> going to be less of a problem.
>
> But now that I read it, the "2 *" part looks really silly, so I suggst
> to go with " > FOO_MAX", else its not a maximum value after all.

Ok, so here is what I have now:


+#define HASHLIMIT_MAX_SIZE 1048576
+
 static int hashlimit_mt_check_common(const struct xt_mtchk_param *par,
                                     struct xt_hashlimit_htable **hinfo,
                                     struct hashlimit_cfg3 *cfg,
@@ -847,6 +849,14 @@ static int hashlimit_mt_check_common(const struct
xt_mtchk_param *par,

        if (cfg->gc_interval == 0 || cfg->expire == 0)
                return -EINVAL;
+       if (cfg->size > HASHLIMIT_MAX_SIZE) {
+               cfg->size = HASHLIMIT_MAX_SIZE;
+               pr_info_ratelimited("size too large, truncated to
%u\n", cfg->size);
+       }
+       if (cfg->max > HASHLIMIT_MAX_SIZE) {
+               cfg->max = HASHLIMIT_MAX_SIZE;
+               pr_info_ratelimited("max too large, truncated to
%u\n", cfg->max);
+       }

Please let me know if it is still different with your suggestion.

Thanks!
