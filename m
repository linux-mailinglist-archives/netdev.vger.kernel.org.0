Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A7229026D
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 12:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406513AbgJPKES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 06:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406505AbgJPKER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 06:04:17 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 317FDC0613D3
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 03:04:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id s14so1451946qkg.11
        for <netdev@vger.kernel.org>; Fri, 16 Oct 2020 03:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wKROEBD/IeUL91SII+WzarWqrsdhLa/c9UmVE6mp63s=;
        b=BWppSsQwo+mAVW9LyR71BnZ83v8uSOPQ4J6TNvWzVDCjb40W/yOrRu6nqTnWPdMHTO
         O+KlWt2l/nfu3Fuu2UcO7XCuld8J4bW/q+7VGcax8ar29p5QrOZ6STUe1J4G39dqPonM
         cvuVO1X/W59l40O7dE1EiQGrJRpgGNGAdwfe9kAQL+X5mcXKOtHFOv/rJL24x6pfZZQK
         5uxUzF+E7ShV7UIRTkvw2j7/elYFrBtODEx7yx+LXbzKMBV5mSrqNXCoxoxLctqbNMRl
         QEkQCSrgQjCyZIV7yGhPbxglRyXw556xEa1iFoiqlRL8WyioG4AhxY928yZisv7ROneM
         u8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wKROEBD/IeUL91SII+WzarWqrsdhLa/c9UmVE6mp63s=;
        b=nEhPVmef33aU/FCKr5lq3U3I6w7vMirTTZEw1b6vo1Ux5T+8pSlGTqUVlChPiudQSx
         cZVIAn/OCJxksXDKbdLE1P5RiRvJjzmSAzdXIHoUoSlF1mz+9b9GzNCJsvVUoK7oOE5B
         Gc3m/SmlKsyC2tiYXZHp1YqVrRRftZAXJ7pwWwaNYokmA5xlmWFIDNH+cHYtb8sbC8e3
         nB0FmwSZ3tTfFiiTdFa1J4N7vtxsrcWeyZN+UQ55byi4HCmFmHO07VIBvz6puoKezlm3
         MyjZ9uKyMVZtNwg385nAPbvmpeeswPmZ/frvFtyyae80mY6rKZD2sTShdmo0tpdsklmj
         Z+QQ==
X-Gm-Message-State: AOAM5303OGT1BYxEvFrL5MxpM+z9xANgJUVKe2AQR2TquU2i4RiLXbFI
        HtWKVj9S+DC97TJtuGbFQzCqVSCDRESZN6YWTL90tg==
X-Google-Smtp-Source: ABdhPJwtcNBk9xTR6ZhXF5xBV+Zg7y49lWRl6s7Yrzhh2V8MBaSP+IiZFZLxjAMUaEISQjS8h3H/DyS3axByd0BMDkw=
X-Received: by 2002:a05:620a:1657:: with SMTP id c23mr3171746qko.231.1602842654929;
 Fri, 16 Oct 2020 03:04:14 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000376ecf05b1b92848@google.com> <CACT4Y+aTPCPRtJ2wJ5P58DijtG2pxXtZm6w=C838YKLKCEdSfw@mail.gmail.com>
 <20201015110203.7cffc1d4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20201015110409.66a8a054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015110409.66a8a054@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 16 Oct 2020 12:04:03 +0200
Message-ID: <CACT4Y+bO-rxU4xVAzopBod5QvJBtNBHzxxvMWnhGArjcGPokgA@mail.gmail.com>
Subject: Re: bpf-next test error: BUG: program execution failed: executor 0:
 exit status 67
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     syzbot <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 8:04 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > <syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com> wrote:
> > > >
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    e688c3db bpf: Fix register equivalence tracking.
> > > > git tree:       bpf-next
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=13d3c678500000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ea7dc57e899da16d
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=5609d37b3a926aad75b7
> > > > compiler:       gcc (GCC) 10.1.0-syz 20200507
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+5609d37b3a926aad75b7@syzkaller.appspotmail.com
> > > >
> > > > executing program
> > > > 2020/10/15 14:32:51 BUG: program execution failed: executor 0: exit status 67
> > > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > > loop exited with status 67
> > > >
> > > > iptable checkpoint filter/2: getsockopt(IPT_SO_GET_INFO) (errno 22)
> > > > loop exited with status 67
> > >
> > > +netfilter maintainers
> > >
> > > It seems one of these recent commits broke netfiler.
> > > Since syzkaller uses netfiler for sandboxing, syzbot is currently down
> > > on bpf-next and linux-next. Other trees will follow once they merge
> > > the breakage.
> >
> > Do you have this?
> >
> > d25e2e9388ed ("netfilter: restore NF_INET_NUMHOOKS")
>
> Ah, you're saying it's just linux-next and bpf-next that's down.
> I think the quoted fix will hit bpf-next in a few hours.
>
> Thanks!

Yes, stopped happening. Phew!

#syz fix: netfilter: restore NF_INET_NUMHOOKS
