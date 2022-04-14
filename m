Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BFA5015EA
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 17:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346222AbiDNO0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 10:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348131AbiDNOCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 10:02:18 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB8FAE4F;
        Thu, 14 Apr 2022 06:58:48 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z12so6495563edl.2;
        Thu, 14 Apr 2022 06:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hNy9y1b65287PSbSI4vGYvbgs90ln0eXu+3fCm9FcOI=;
        b=Au05tlXgQtSXjltxV1n2izruU5VhEEdX23KtSYxE3VRKNwwOjHeYAoNWWwVSMFqzZl
         NMaXkWm4DPxbdnRBSvk3w8t/2I+N3wiEzH845zEa9fOmF1dB8tadMr4RIzhTdkmd5yYa
         Y6rvC3n0PfygYTIR2xlJpF4I2Bv5Nkeky8V+UKh0Gh9Q/hQGDM+Er336xNoDsU4v79V2
         qeLLBc0zfjWa9q1cGuyd3zNAqNrTxCPefK7/9+6oGC4COfvVzV69qX3JyFfHR5Q9QvJJ
         cv5hUPRhzxzvixQFazN0/WKJKSYDeP11pQf+HN4O+32TDufXvMrEIWhVBYiBLMIm7D18
         HOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hNy9y1b65287PSbSI4vGYvbgs90ln0eXu+3fCm9FcOI=;
        b=XUN7Ato6+faGgTpybkIqIb8kK3xHoB5MwXrMMr59vWywPHMV82fBm1E0M9npDIqd7G
         2b3G33x4KiLrrQoi9ndartQ1jhtwugERu/DDlwz1/DyE7fg5f+gAHZtTyvzwWwcoAF5S
         lXRvFsbDjkAGjs3S8S/6/9p1MSfGFEnkYzfVn8tW6xkgszM0oT6xu06BekuuFVZJsrdD
         FoikSxE5liqCPh9SfSGEZoCI1HRWxn/wqyxD3t1OiGVggdBC8AoMZtwHtkLUyCl1J812
         LGuB/9rNnM+XRHuniowYunbdCXf5umDrbRuCoIEscO7N5hJB/Ya+RvAmU8N1SgQYuMWD
         eYVQ==
X-Gm-Message-State: AOAM533SH87fkphY43GmcMR4RAV/KcfU28XRmfr1bHkiCwhbwRJbd7cl
        ryyQnp59wrqJANx2h2tVhK4AhVb3wmlYG+YTlYo=
X-Google-Smtp-Source: ABdhPJw1Izwwu7QrkxLza5DfvwsqFA7uDebw064P9fsqmJNP/c17tncJ7IroL7GD7fmwsU/wq9bJ2XjxdpAlT9XHFOg=
X-Received: by 2002:a05:6402:2788:b0:41b:c871:715b with SMTP id
 b8-20020a056402278800b0041bc871715bmr3148078ede.53.1649944726651; Thu, 14 Apr
 2022 06:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220409120901.267526-1-dzm91@hust.edu.cn> <YlQbqnYP/jcYinvz@hovoldconsulting.com>
In-Reply-To: <YlQbqnYP/jcYinvz@hovoldconsulting.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Thu, 14 Apr 2022 21:58:20 +0800
Message-ID: <CAD-N9QV=tRxcRH_bD7-3X4sLKYBu4LYDk5tTfUAaX2JDd7nLTg@mail.gmail.com>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
To:     Johan Hovold <johan@kernel.org>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        linux-usb@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
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

On Mon, Apr 11, 2022 at 8:14 PM Johan Hovold <johan@kernel.org> wrote:
>
> On Sat, Apr 09, 2022 at 08:09:00PM +0800, Dongliang Mu wrote:
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> > with ctx. However, in the unbind function - cdc_ncm_unbind,
> > it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> > a dangling pointer. The following ioctl operation will trigger
> > the UAF in the function cdc_ncm_set_dgram_size.
> >
> > Fix this by setting dev->data[0] as zero.
>
> This sounds like a poor band-aid. Please explain how this prevent the
> ioctl() from racing with unbind().

You mean the following thread interlaving?

ioctl                                unbind
                                cdc_ncm_free(ctx);
dev->data[0]
                                 dev->data[0] = 0;

It seems this will still trigger UAF. Maybe we need to add mutex to
prevent this. But I am not sure.

>
> Johan
>
> > ==================================================================
> > BUG: KASAN: use-after-free in cdc_ncm_set_dgram_size+0xc91/0xde0
> > Read of size 8 at addr ffff8880755210b0 by task dhcpcd/3174
> >
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
> >  print_report mm/kasan/report.c:429 [inline]
> >  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
> >  cdc_ncm_set_dgram_size+0xc91/0xde0 drivers/net/usb/cdc_ncm.c:608
> >  cdc_ncm_change_mtu+0x10c/0x140 drivers/net/usb/cdc_ncm.c:798
> >  __dev_set_mtu net/core/dev.c:8519 [inline]
> >  dev_set_mtu_ext+0x352/0x5b0 net/core/dev.c:8572
> >  dev_set_mtu+0x8e/0x120 net/core/dev.c:8596
> >  dev_ifsioc+0xb87/0x1090 net/core/dev_ioctl.c:332
> >  dev_ioctl+0x1b9/0xe30 net/core/dev_ioctl.c:586
> >  sock_do_ioctl+0x15a/0x230 net/socket.c:1136
> >  sock_ioctl+0x2f1/0x640 net/socket.c:1239
> >  vfs_ioctl fs/ioctl.c:51 [inline]
> >  __do_sys_ioctl fs/ioctl.c:870 [inline]
> >  __se_sys_ioctl fs/ioctl.c:856 [inline]
> >  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0x80 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > RIP: 0033:0x7f00859e70e7
> > RSP: 002b:00007ffedd503dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > RAX: ffffffffffffffda RBX: 00007f00858f96c8 RCX: 00007f00859e70e7
> > RDX: 00007ffedd513fc8 RSI: 0000000000008922 RDI: 0000000000000018
> > RBP: 00007ffedd524178 R08: 00007ffedd513f88 R09: 00007ffedd513f38
> > R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007ffedd513fc8 R14: 0000000000000028 R15: 0000000000008922
> >  </TASK>
>
> > Reported-by: syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com
> > Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> > ---
> >  drivers/net/usb/cdc_ncm.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> > index 15f91d691bba..9fc2df9f0b63 100644
> > --- a/drivers/net/usb/cdc_ncm.c
> > +++ b/drivers/net/usb/cdc_ncm.c
> > @@ -1019,6 +1019,7 @@ void cdc_ncm_unbind(struct usbnet *dev, struct usb_interface *intf)
> >
> >       usb_set_intfdata(intf, NULL);
> >       cdc_ncm_free(ctx);
> > +     dev->data[0] = 0;
> >  }
> >  EXPORT_SYMBOL_GPL(cdc_ncm_unbind);
