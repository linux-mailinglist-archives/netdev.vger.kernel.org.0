Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52358B0CEF
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 12:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730936AbfILKb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 06:31:26 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34521 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730807AbfILKb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 06:31:26 -0400
Received: by mail-lj1-f195.google.com with SMTP id h2so16567762ljk.1
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 03:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rTmkD5KTVMdiYgEvfiUQj5kRCGRO4iDK/OarW4jajJk=;
        b=QYPgC8HzZreIkg5Ai5zGrp2X+kT1eNuxnSBKLLmCEBMVFQTRO6tMvnUQ2vht4Gh0vc
         jRn84I+4+NEyPTx+2FBvAvlCXNCE9jlq4SuMkmdikIsLdPkcou+xhlV3QEa6U7LoJtZq
         nahv2l4Aok364JIynB6445e/uhpVPdw5SZveE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rTmkD5KTVMdiYgEvfiUQj5kRCGRO4iDK/OarW4jajJk=;
        b=UQb5ACn8RztZSQiHKregickoJ01dU5vzvAzV1tMyyfabnJzWXch1Y+Zonl7ZyrN+ch
         PAJcDoLFxoriBsFEyQWD4TJ5eawt7/Cf7A041bvtByh/Mgf40esjw1G3qrPjTgBTApC/
         4UJciptT54AkQ+3R5Fryg/txQdL1dcCWShWIe1xQTRGxUXnSSOVt2Ug8GG3JmarFIpoz
         XVvN9r4q+4pQpNhAbZCnM/8VEJQ2c5nw/9Bop9IPto2ez/iA1ynvwgjZUzoMvoOgh3zZ
         j957Cr2YI0RFCORusK9gj9rBzKv06CYUYyodIXjEYw+5R7fckyxWu3knVPQeyXkFtW+l
         Fa8Q==
X-Gm-Message-State: APjAAAVp2I4RvzaL2KhvTtaXxT4RCGoFs9iSOWVAoVz1Rp74Sah9TpA/
        keMixCsI/M5Ybe7l2QY/7ceT9pMM6RJgqw==
X-Google-Smtp-Source: APXvYqxGd6Wk9JTTVLhTi9hOkZTPXBE5ALBOtXcRm/g+8x0wk2wX3q4U3QzysFSmTNsg/2Eo2jjnbw==
X-Received: by 2002:a2e:9114:: with SMTP id m20mr2027951ljg.103.1568284284092;
        Thu, 12 Sep 2019 03:31:24 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id c21sm2494895lff.61.2019.09.12.03.31.22
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Sep 2019 03:31:23 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id y5so12262684lji.4
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 03:31:22 -0700 (PDT)
X-Received: by 2002:a2e:3c14:: with SMTP id j20mr2841967lja.84.1568284282545;
 Thu, 12 Sep 2019 03:31:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190911183445.32547-1-xiyou.wangcong@gmail.com>
 <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com> <CAM_iQpVP6qVbWmV+kA8UGXG6r1LJftyV32UjUbqryGrX5Ud8Nw@mail.gmail.com>
In-Reply-To: <CAM_iQpVP6qVbWmV+kA8UGXG6r1LJftyV32UjUbqryGrX5Ud8Nw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 12 Sep 2019 11:31:06 +0100
X-Gmail-Original-Message-ID: <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
Message-ID: <CAHk-=whO37+O-mohvMODnD57ppCsK3Bcv8oHzSBvmwJbsT54cA@mail.gmail.com>
Subject: Re: [Patch net] sch_sfb: fix a crash in sfb_destroy()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 12, 2019 at 2:10 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Sep 11, 2019 at 2:36 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > It seems a similar fix would be needed in net/sched/sch_dsmark.c ?
> >
>
> Yeah, or just add a NULL check in dsmark_destroy().

Well, this was why one of my suggestions was to just make
"qdisc_put()" be happy with a NULL pointer (or even an ERR_PTR()).

That would have fixed not just sfb, but also dsmark with a single patch.

We tend to have that kind of pattern in a lot of places, where we can
free unallocated structures (end ERR_PTR() pointers) withour errors,
so that

  destroy_fn(alloc_fn());

is defined to always work, even when alloc_fn() returns NULL or an
error. That, and allowing the "it was never allocated at all" case (as
long as it's initialized to NULL, of course) tends to make various
error cases simpler.

The obvious one is kfree(kmalloc()), of course, but we've done it in
other places too. So you find things like

  void i2c_unregister_device(struct i2c_client *client)
  {
        if (IS_ERR_OR_NULL(client))
                return;

in various subsystems and drivers. So one of my suggestions was to
just do that to qdisc_put().

It depends on what you want to do, of course. Do you want to make sure
each user is being very careful? Or do you want to make the interfaces
easy to use without _having_ to be careful? There are arguments both
ways, but we've tended to move more towards a "easy to use" model than
the "be careful" one.

               Linus
