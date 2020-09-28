Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD227A565
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 04:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgI1CWD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 22:22:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbgI1CWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 22:22:02 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACEDC0613CF
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 19:22:02 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id i1so8449526edv.2
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 19:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vOX5Sd+xpTPA9/G3a3HyLwKA39unA0IaH2aJ/ahSQ48=;
        b=qWrMSVm6zYmVaFJcTErsVXateVeWWiDTida+WlvUE+uTdTpqtnEDoAS5/Fab3urTai
         zVC/L+EmWCWMmZZLXmcfTTewmXUlNJHZKMHMlOXI21wFMAIiCPKQBsVcXWBOuIWdkSJw
         wRjVb0qNA/Wr0py5s32t6cT2qH4mMisal2HMbwAzd587SjYazqjs730xTKftVO/LuVh8
         z5SqJGPe6Z6FkYdOzbDRlTuU8q6aT+KfFqcKMNC6Uq0DHawFoME2NoXJCWrpEwOSakwj
         aqz4/eyirVDPTcjNHeg2KSOdgmBn2yafu/pWbZ8fXwYjpOa4lrAz9lroe+Wfwt0jlbYj
         xUug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vOX5Sd+xpTPA9/G3a3HyLwKA39unA0IaH2aJ/ahSQ48=;
        b=YR9LcVnIR3gfcoogdleKeSAOxX5ZaddIjBi6SvZKF3+RZR8FZSP/flXj28zkPhdHIo
         aUKZe5gcdjXvIr0TRGDIhZ438oOHkuh6USJ2XtkJaYyXcPhYad/X58ZIqgG3htepOOkr
         ihSrmGmdriZZMdKcGuJiuFoF1N5Z7F7TslJQLHcY9x37sa49L9WxWlSflaG6GRqkoeuk
         3cZFm+5yhrrnt6GdSY11NfNMpAwEAizygmZaRKNoalUmRQBtZfC7ulHqcwAUfGAqpbWI
         myWKLQ1wqSXSNB43saHM7ZwdcvtehMIPqquzTLzGA7bLe6KTLEDIi+aek1h0bRQs5u93
         nqHA==
X-Gm-Message-State: AOAM531jfX/ZvjYLAxy1l7m5278Z7XnnSOB7yTROLSgp3pSgoXewlgz+
        bP6vhCGFd5EYYkPgdiCfXTHNyUE10G/F0xyGVowE
X-Google-Smtp-Source: ABdhPJzsqAtfa9f1NG8hfvEATJbi9eEwRIg9uIFPEmWBfP9DD88yDxmZdKhWH6XK21EL7PJHsV83fl/LkgW6hEmDjDQ=
X-Received: by 2002:a05:6402:1805:: with SMTP id g5mr13063002edy.135.1601259720569;
 Sun, 27 Sep 2020 19:22:00 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009fc91605afd40d89@google.com> <20200925030759.GA17939@gondor.apana.org.au>
In-Reply-To: <20200925030759.GA17939@gondor.apana.org.au>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 27 Sep 2020 22:21:48 -0400
Message-ID: <CAHC9VhQjfqAaPnsT20T8zsT1kGHk3LRU1fqL8kNxiKsQ_E6TWQ@mail.gmail.com>
Subject: Re: KASAN: stack-out-of-bounds Read in xfrm_selector_match (2)
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com, James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 11:08 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Mon, Sep 21, 2020 at 07:56:20AM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    eb5f95f1 Merge tag 's390-5.9-6' of git://git.kernel.org/pu..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13996ad5900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ffe85b197a57c180
> > dashboard link: https://syzkaller.appspot.com/bug?extid=577fbac3145a6eb2e7a5
> > compiler:       gcc (GCC) 10.1.0-syz 20200507
> >
> > Unfortunately, I don't have any reproducer for this issue yet.
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+577fbac3145a6eb2e7a5@syzkaller.appspotmail.com
> >
> > ==================================================================
> > BUG: KASAN: stack-out-of-bounds in xfrm_flowi_dport include/net/xfrm.h:877 [inline]
> > BUG: KASAN: stack-out-of-bounds in __xfrm6_selector_match net/xfrm/xfrm_policy.c:216 [inline]
> > BUG: KASAN: stack-out-of-bounds in xfrm_selector_match+0xf36/0xf60 net/xfrm/xfrm_policy.c:229
> > Read of size 2 at addr ffffc9001914f55c by task syz-executor.4/15633
> >
> > CPU: 0 PID: 15633 Comm: syz-executor.4 Not tainted 5.9.0-rc5-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x198/0x1fd lib/dump_stack.c:118
> >  print_address_description.constprop.0.cold+0x5/0x497 mm/kasan/report.c:383
> >  __kasan_report mm/kasan/report.c:513 [inline]
> >  kasan_report.cold+0x1f/0x37 mm/kasan/report.c:530
> >  xfrm_flowi_dport include/net/xfrm.h:877 [inline]
>
> This one goes back more than ten years.  This patch should fix
> it.
>
> ---8<---
> The struct flowi must never be interpreted by itself as its size
> depends on the address family.  Therefore it must always be grouped
> with its original family value.
>
> In this particular instance, the original family value is lost in
> the function xfrm_state_find.  Therefore we get a bogus read when
> it's coupled with the wrong family which would occur with inter-
> family xfrm states.
>
> This patch fixes it by keeping the original family value.
>
> Note that the same bug could potentially occur in LSM through
> the xfrm_state_pol_flow_match hook.  I checked the current code
> there and it seems to be safe for now as only secid is used which
> is part of struct flowi_common.  But that API should be changed
> so that so that we don't get new bugs in the future.  We could
> do that by replacing fl with just secid or adding a family field.

I'm thinking it might be better to pass the family along with the flow
instead of passing just the secid (less worry of passing an incorrect
secid that way).  Let me see if I can cobble together a quick patch
for testing before bed ...

-- 
paul moore
www.paul-moore.com
