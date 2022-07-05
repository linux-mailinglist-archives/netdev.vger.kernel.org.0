Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317ED56629A
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 07:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiGEFHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 01:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGEFHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 01:07:43 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AC112A8F;
        Mon,  4 Jul 2022 22:07:42 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id l11so19867262ybu.13;
        Mon, 04 Jul 2022 22:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85Cac2AwGuQr+nSyPZjD7F+MUxrJqW0I9BszYcBOBxk=;
        b=C6OeGd23/2LaqnIHQe5VAk9C0E298viyaG3NaqEMBhaL8c0/LfNlocAP7gZ8if+EZ0
         NaP9RPUHmzuGwMfC2v6/2MZYN5kK0MRaEBMmgtyRNrihK8cG9C0kaYejHbTM+oFl7IRa
         GFpBA7W74CEqwOzVLThZGMUGdAbGWUEyfLE5pXcTjZXChtxu7BzYN/8a6Fa/+HxoOWA/
         Ewua+IL5rlsd/EvKjKqag8uJxu7S5vOmkagR8WQdsZriO2vNSGWSff+wD0utmRyUXrdH
         oJbs5AkXCEgPmF7R3+7vGeXHAvp3K9IBItoa0i8NEamZyXj3E9unDFtj9djMY1yohexZ
         /mAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85Cac2AwGuQr+nSyPZjD7F+MUxrJqW0I9BszYcBOBxk=;
        b=C02awxitXGSB+9DeRzoolESgsUKhe6bAnaWe/RNi0I9WIYas6Y7lIbMfLlSCymlFD2
         H2pwECM91DvgoDvlUN5/2H6L5hd34A6TjA995igIU5Qwes32i0I7y7Sj1YaVbvw1hVpK
         r4dtZynsztZERcoTXGdpHXfwH+bXsFqCOYBSSmn+V0plWgWdJAdcTRIx7wozDOqtXsWV
         nhzxhvHxuDFBAjkT0oLz1d9VpxV70mDKuzDUfRV8J7Z3iSk+pAWvlnwxwCH08e90RvgY
         tjjyMxmKbszFuVTA79EWCWV6YPelaDJr9orqUHq5Bot2K7EYZCcDK0ll0DpwXxl+BA/C
         2wqQ==
X-Gm-Message-State: AJIora/AU8S0Ieyc25zi7Fg3mgIVLun+qcPFY0I9ga9Y8yaslS6Ria3Q
        x1WsHoNMQlttMn0BbrP03Jwbe1Yoc7Q9KvtHEbk=
X-Google-Smtp-Source: AGRyM1v6t15InRMAJe60IKrihMPmUrWrTK+mY3NFxv74jjf800k4XrcA4lBb3Hf5YytdIOiynuHMvDASghlkMvSYb94=
X-Received: by 2002:a25:b9c7:0:b0:66c:e02d:9749 with SMTP id
 y7-20020a25b9c7000000b0066ce02d9749mr36234603ybj.494.1656997661510; Mon, 04
 Jul 2022 22:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ@mail.gmail.com>
 <20220704112619.GZ16517@kadam> <YsLU6XL1HBnQR79P@kroah.com> <20220705045938.GA19781@Negi>
In-Reply-To: <20220705045938.GA19781@Negi>
From:   butt3rflyh4ck <butterflyhuangxx@gmail.com>
Date:   Tue, 5 Jul 2022 13:07:30 +0800
Message-ID: <CAFcO6XMpkzvsqCk4nB-6ZZvixpiL2nYUFat6RcPEKbcOa7dctg@mail.gmail.com>
Subject: Re: Test patch for KASAN: global-out-of-bounds Read in detach_capi_ctr
To:     Soumya Negi <soumya.negi97@gmail.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        syzbot+9d567e08d3970bfd8271@syzkaller.appspotmail.com,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable@vger.kernel.org, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch for this issue had be available upstream last year.
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1f3e2e97c003f80c4b087092b225c8787ff91e4d


Regards,
  butt3rflyh4ck.

On Tue, Jul 5, 2022 at 12:59 PM Soumya Negi <soumya.negi97@gmail.com> wrote:
>
> On Mon, Jul 04, 2022 at 01:54:17PM +0200, Greg KH wrote:
> > On Mon, Jul 04, 2022 at 02:26:19PM +0300, Dan Carpenter wrote:
> > >
> > > On Fri, Jul 01, 2022 at 06:08:29AM -0700, Soumya Negi wrote:
> > > > #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
> > > > 3f8a27f9e27bd78604c0709224cec0ec85a8b106
> > > >
> > > > --
> > > > You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> > > > To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> > > > To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/CAHH-VXdqp0ZGKyJWE76zdyKwhv104JRA8ujUY5NoYO47HC9XWQ%40mail.gmail.com.
> > >
> > > > From 3aa5aaffef64a5574cbdb3f5c985bc25b612140c Mon Sep 17 00:00:00 2001
> > > > From: Soumya Negi <soumya.negi97@gmail.com>
> > > > Date: Fri, 1 Jul 2022 04:52:17 -0700
> > > > Subject: [PATCH] isdn: capi: Add check for controller count in
> > > >  detach_capi_ctr()
> > > >
> > > > Fixes Syzbot bug:
> > > > https://syzkaller.appspot.com/bug?id=14f4820fbd379105a71fdee357b0759b90587a4e
> > > >
> > > > This patch checks whether any ISDN devices are registered before unregistering
> > > > a CAPI controller(device). Without the check, the controller struct capi_str
> > > > results in out-of-bounds access bugs to other CAPI data strucures in
> > > > detach_capri_ctr() as seen in the bug report.
> > > >
> > >
> > > This bug was already fixed by commit 1f3e2e97c003 ("isdn: cpai: check
> > > ctr->cnr to avoid array index out of bound").
> > >
> > > It just needs to be backported.  Unfortunately there was no Fixes tag so
> > > it wasn't picked up.  Also I'm not sure how backports work in netdev.
> >
> > That commit has already been backported quite a while ago and is in the
> > following releases:
> >       4.4.290 4.9.288 4.14.253 4.19.214 5.4.156 5.10.76 5.14.15 5.15
> >
>
> Thanks for letting me know. Is there a way I can check whether an open
> syzbot bug already has a fix as in this case? Right now I am thinking
> of running the reproducer on linux-next as well before starting on a
> bug.
>
> -Soumya



-- 
Active Defense Lab of Venustech
