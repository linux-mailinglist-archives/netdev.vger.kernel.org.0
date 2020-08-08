Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B3B23F56F
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 02:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgHHAUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 20:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgHHAUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 20:20:10 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90BA1C061A28
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 17:02:27 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so2920310ota.10
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 17:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5V4fSeXIIf10FVBMF3ZwZcNjvm3OCHIjH9V8C29Y8lQ=;
        b=raa038CaUF9eWBraNH4WEyPuTHJSK6iOiV7k6AYrMeNgIhzFx6ZewrZSuo5lrAVEdK
         9bOtaWtNfF07d9UEYUqPA6aNkM20agULeekqUYoS5Qe3Z22dBLbZuaZdwc0zac2dFT8n
         N3xMKrgLDJwJrCyj4e9MYB3+ZJJ1gVbN1ypxreVVkfRzZh9Lwqwz7wDfTV0KYta5fshZ
         OdIZMeVdyM0/ehI67+Kizp9fRZugyLsg7B4FbHuK8BMDqZEVUpWK0PH5DX68JkBYxfMs
         aOpiQcc5HKPaKOyUagtLwMCbgtum4v9yvrQ01rY6uf9g56CM5kjZ1vx+55Z+jpg2jETd
         tMrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5V4fSeXIIf10FVBMF3ZwZcNjvm3OCHIjH9V8C29Y8lQ=;
        b=BAexhg4CVK2p/IUiwnFDpYfmZ2d5dCsrgbVgrwBuhiLUsd0Rh8C21SZfQ9SYnwWSd9
         9CwHZaNinwz+7K+FLuKWWhIFw6pU43rkxZNkKEHefytXM9G76u7yzcocnJrO9FZZgJ4A
         RQKwcuXJCpBjI8/auj7cSoiKLYVDFmp4MRbA6qT5cO3FmDYTFhAnC36XiMJiVad3jvA6
         APDhFRF37aN9BYTFctSGEbGckXGxjizCCwyRkZhxWw/xA3aPZTOIWnjBZjzrWpQOUdqx
         O8+c3R8SXwH5rgDx0pRH8NP/9MlegTs83j8Pag7CwCBaTcV7nKVopXU3jS6L2lG7SB9t
         9Bdw==
X-Gm-Message-State: AOAM530mt8lvJZYELrNMNlnZlltpqPNP0jPiOTblYMkwXKwmf4futDLG
        Jc0gin0EXf6Cr+gP+EegLXjGiqnDQYZHR/DwPnUpSg==
X-Google-Smtp-Source: ABdhPJyt2wG3ZDTNWblVENQs5ccUnTXPuZbzbj0BnXWicp6XtJM28SQrhwmJ/s4VEOh4n6cv6N5dnVLVJsMlDVkrD+Y=
X-Received: by 2002:a05:6830:237b:: with SMTP id r27mr13338417oth.352.1596844946630;
 Fri, 07 Aug 2020 17:02:26 -0700 (PDT)
MIME-Version: 1.0
References: <20200709182642.1773477-1-keescook@chromium.org>
 <20200709182642.1773477-4-keescook@chromium.org> <CANcMJZAcDAG7Dq7vo=M-SZwujj+BOKMh7wKvywHq+tEX3GDbBQ@mail.gmail.com>
 <202008071516.83432C389@keescook>
In-Reply-To: <202008071516.83432C389@keescook>
From:   John Stultz <john.stultz@linaro.org>
Date:   Fri, 7 Aug 2020 17:02:15 -0700
Message-ID: <CALAqxLXqjEN0S+eGeFA_obaunBK_+xqKbQtdQj1w+wegz-6U5w@mail.gmail.com>
Subject: Re: [PATCH v7 3/9] net/scm: Regularize compat handling of scm_detach_fds()
To:     Kees Cook <keescook@chromium.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        Tycho Andersen <tycho@tycho.ws>,
        David Laight <David.Laight@aculab.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Linux API <linux-api@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Amit Pundir <amit.pundir@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 3:18 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Fri, Aug 07, 2020 at 01:29:24PM -0700, John Stultz wrote:
> > On Thu, Jul 9, 2020 at 11:28 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > Duplicate the cleanups from commit 2618d530dd8b ("net/scm: cleanup
> > > scm_detach_fds") into the compat code.
> > >
> > > Replace open-coded __receive_sock() with a call to the helper.
> > >
> > > Move the check added in commit 1f466e1f15cf ("net: cleanly handle kernel
> > > vs user buffers for ->msg_control") to before the compat call, even
> > > though it should be impossible for an in-kernel call to also be compat.
> > >
> > > Correct the int "flags" argument to unsigned int to match fd_install()
> > > and similar APIs.
> > >
> > > Regularize any remaining differences, including a whitespace issue,
> > > a checkpatch warning, and add the check from commit 6900317f5eff ("net,
> > > scm: fix PaX detected msg_controllen overflow in scm_detach_fds") which
> > > fixed an overflow unique to 64-bit. To avoid confusion when comparing
> > > the compat handler to the native handler, just include the same check
> > > in the compat handler.
> > >
> > > Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> >
> > Hey Kees,
> >   So during the merge window (while chasing a few other regressions),
> > I noticed occasionally my Dragonboard 845c running AOSP having trouble
> > with the web browser crashing or other apps hanging, and I've bisected
> > the issue down to this change.
> >
> > Unfortunately it doesn't revert cleanly so I can't validate reverting
> > it sorts things against linus/HEAD.  Anyway, I wanted to check and see
> > if you had any other reports of similar or any ideas what might be
> > going wrong?
>
> Hi; Yes, sorry for the trouble. I had a typo in a refactor of
> SCM_RIGHTS. I suspect it'll be fixed by this:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1fa2c0a0c814fbae0eb3e79a510765225570d043
>
> Can you verify Linus's latest tree works for you? If not, there might be
> something else hiding in the corners...

Thanks so much! Yes, I just updated to Linus' latest and the issue has
disappeared!

thanks again!
-john
