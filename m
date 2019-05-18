Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C730722470
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729481AbfERSTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 14:19:47 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:39466 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727380AbfERSTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 14:19:47 -0400
Received: by mail-yb1-f195.google.com with SMTP id a3so794809ybr.6
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 11:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZXf6eTW/D9KxZmWzXNhg+M6jwam9QsxO2o7O+sjwG9E=;
        b=KOaTd4IlfWUxNaXLskFHyVq7H0i8lpdWSIVPFopEIKFaXwrey0kvlfn85PJsPO8OF3
         PtxSVFPse9lrU6IEvprl54kO+RTm/Cn0o1tuLJQ+tiB+tq/KWnMPZ9adFTDixWYlJBKi
         Bg4NB8E7bfZRGvhsKQA9XRAV4ejI9EElokasQB9HCMVDJypzbD0AhQvLu0Z5aunRKrkL
         xFXWZoyCrFlDNXfW0Q5kMqWc9HAwkGpYK0dKeSda18nvSExfMtjVXOYcTmobNsi63WXt
         OxNqQyQ4HOqR61dxIDq5QJfm14YybWGQYxJCWP51+ux3mnTEvvQsnqwisox+qkM3KS+U
         iqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZXf6eTW/D9KxZmWzXNhg+M6jwam9QsxO2o7O+sjwG9E=;
        b=oe9xiIqOYhPy3+SPUHxmQ+RSOB17oiL5c22QtP3hA74aej5LoaZgK5yu/xY09Kh1Mm
         Js+4wjFGMRlXWxKqGMPSFTJ8EvDnXDzYS8vDx9uNBckO6Wiuf3eT9+WC3tQ9pmgARioZ
         HmzKMLhoE+YZrH+H/W1BvsclhHvhw1XG81hXGblt8aBYlkfQxXyK16orrK8GAunir2j/
         MnY6IywKcbh4X7RtNgK8cMftMcdpb2h9Dh7ZQfudCsaitePt+nwp9mG8Q7fqD43N1UE/
         aiAII1Q2LNJGw1yypYuJh8TUpwL0EkkHwO7haWeartlw6P+wjxCECvSZX5FXBEBBnyCT
         1LzQ==
X-Gm-Message-State: APjAAAXhY7i1xzr5SUULUltCBCsxUlw5ok9sH1VVBFarbvm/R80Y5rl0
        4958BL1E5B4PyHgs+h+MIZTLd21M
X-Google-Smtp-Source: APXvYqx/i8UuIslDbTvgS1hXQ5nElpe0XgkEvF/Bp9Sux0gArgzC0E1+V9U2mcC/bY7Rnk1pwKbs+w==
X-Received: by 2002:a25:cd84:: with SMTP id d126mr27006767ybf.98.1558203585607;
        Sat, 18 May 2019 11:19:45 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id h194sm3692106ywa.9.2019.05.18.11.19.44
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 18 May 2019 11:19:44 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id p134so3995595ybc.4
        for <netdev@vger.kernel.org>; Sat, 18 May 2019 11:19:44 -0700 (PDT)
X-Received: by 2002:a25:f509:: with SMTP id a9mr31918634ybe.391.1558203584001;
 Sat, 18 May 2019 11:19:44 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000014e65905892486ab@google.com> <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
In-Reply-To: <CA+FuTSeM5qzyf_D+70Xe5k=3d+dYp2WyVZC-YM=K4=9kCCst6A@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 18 May 2019 14:19:07 -0400
X-Gmail-Original-Message-ID: <CA+FuTSct1p1tYAWdsWOgQT7AHoFbdgoT=gA1tQ3nii_85k9bFA@mail.gmail.com>
Message-ID: <CA+FuTSct1p1tYAWdsWOgQT7AHoFbdgoT=gA1tQ3nii_85k9bFA@mail.gmail.com>
Subject: Re: INFO: trying to register non-static key in rhashtable_walk_enter
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     syzbot <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>, jon.maloy@ericsson.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        tipc-discussion@lists.sourceforge.net,
        Ying Xue <ying.xue@windriver.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>, hujunwei4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 18, 2019 at 2:09 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, May 18, 2019 at 3:34 AM syzbot
> <syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    510e2ced ipv6: fix src addr routing with the exception table
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=15b7e608a00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=82f0809e8f0a8c87
> > dashboard link: https://syzkaller.appspot.com/bug?extid=1e8114b61079bfe9cbc5
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+1e8114b61079bfe9cbc5@syzkaller.appspotmail.com
> >
> > INFO: trying to register non-static key.
> > the code is fine but needs lockdep annotation.
>
> All these five rhashtable_walk_enter probably have the same root cause.
>
> Bisected to commit 7e27e8d6130c (" tipc: switch order of device
> registration to fix a crash"). Reverting that fixes it.
>
> Before the commit, tipc_init succeeds. After the commit it fails at
> register_pernet_subsys(&tipc_net_ops) due to error in
>
>   tipc_init_net
>     tipc_topsrv_start
>       tipc_topsrv_create_listener
>         sock_create_kern
>
> On a related note, in tipc_topsrv_start srv is also not freed on later
> error paths.

and tipc_topsrv_stop is not called in tipc_init_net on later error paths.
