Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C3B4B8100
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiBPHH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:07:58 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiBPHHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:07:54 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 788631E5F0E;
        Tue, 15 Feb 2022 23:07:11 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id ay7so1518286oib.8;
        Tue, 15 Feb 2022 23:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HPnpyaqK8o0G+BDi3MOPV+BIITLVz5fggVzk9O3L6oE=;
        b=XimW3gvAMYPUVjF2IfQeAZU5JtieMUXI4Mqg4RoDikjeO02qvlF09bWWSj55zjEco4
         Dvhvaib85Rsx88hpMqfQ6o5oDVe1xRSc1E4ERx/nrJPlAHsYBcEzyGlfcm0fvNHIEWos
         bj9Es0ztCnsDrOnEWYAr0PDuAcFUkYCIJCt88bC6e32UiWW6OYfjvMHEbIlEERAo1OeO
         CvgNC9rP97nYVk3jAull0vPOXprFve6kY+Ehds3LwzHIQKFObmgdJo9NTQipUDl9CW3P
         HGTPV3BBDyeL3hofNlN5TTtU6jrdz+eGGtEPjdYxof5sZCdZBAGbzXyCepaS1tzbBaXU
         03KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HPnpyaqK8o0G+BDi3MOPV+BIITLVz5fggVzk9O3L6oE=;
        b=YzOlwS6GtjvPq186VXq0BHIU8W0cBMgnalkYgcXEqj9VJlcsZCDxzGCA4Eitrn0sai
         fwNF4K9DXCHnrY1HvIJXl3pZ66sGqvdknqCJwnwFUdZeQR0971gSmhnFUp3UsoRTJUjo
         9ZYd8WTCzS49bHh13ZOURdz4bQm0gnhySCYxg9VnjTzi14DOh8E37/Sz6sk+m9309cyh
         Ksv7xUGbwzat/3v2wLowivtmdZzbZ+/ib2o6KNblpVI1fNK8L+RpP5xHZXRkxAhmeVGz
         ib3PuiQHFX8tO6kODNiHGomGbkBzqf5cq8CUtGeqQxBpNqjY/zJl9a96ahnvI2n/3YnY
         obbQ==
X-Gm-Message-State: AOAM533Z7idjSKXw7/un+11NKqBstuG/Z70roNQ0JQ19zhhEl1yLaYXa
        9BpAOCOYY75fKDwsEYk1m97S6JjqIAiX5/JPL4K+Uy2UcqgQFxZSWG0=
X-Google-Smtp-Source: ABdhPJxmpUZAuthv1WIbH+KxBizV5tsa9Wr1R8nwhrB/TW/VTxxhAjLlL1fAxQl9anD1fQs+TeyuwIeKCbCVagOpWsE=
X-Received: by 2002:aca:1812:0:b0:2d4:426d:c9e0 with SMTP id
 h18-20020aca1812000000b002d4426dc9e0mr62879oih.129.1644994686459; Tue, 15 Feb
 2022 22:58:06 -0800 (PST)
MIME-Version: 1.0
References: <20220216050320.3222-1-kerneljasonxing@gmail.com> <CANn89i+6Hc7q-a=zh_jcTn9_GM5xP6fzv2RcHY+tneqzE3UnHw@mail.gmail.com>
In-Reply-To: <CANn89i+6Hc7q-a=zh_jcTn9_GM5xP6fzv2RcHY+tneqzE3UnHw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 16 Feb 2022 14:57:30 +0800
Message-ID: <CAL+tcoBnSDjHk_Xhd_ohQjpMu-Ns2Du4mWhUybrK6+VPXHoETQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: introduce SO_RCVBUFAUTO to let the
 rcv_buf tune automatically
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Alexander Aring <aahringo@redhat.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Florian Westphal <fw@strlen.de>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Jason Xing <xingwanli@kuaishou.com>
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

On Wed, Feb 16, 2022 at 2:25 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Feb 15, 2022 at 9:03 PM <kerneljasonxing@gmail.com> wrote:
> >
> > From: Jason Xing <xingwanli@kuaishou.com>
> >
> > Normally, user doesn't care the logic behind the kernel if they're
> > trying to set receive buffer via setsockopt. However, once the new
> > value of the receive buffer is set even though it's not smaller than
> > the initial value which is sysctl_tcp_rmem[1] implemented in
> > tcp_rcv_space_adjust(),, the server's wscale will shrink and then
> > lead to the bad bandwidth as intended.
>
> Quite confusing changelog, honestly.
>
> Users of SO_RCVBUF specifically told the kernel : I want to use _this_
> buffer size, I do not want the kernel to decide for me.
>
> Also, I think your changelog does not really explain that _if_ you set
> SO_RCVBUF to a small value before
> connect() or in general the 3WHS, the chosen wscale will be small, and
> this won't allow future 10x increase
> of the effective RWIN.
>

Yes, you hit the point really.

>
> >
> > For now, introducing a new socket option to let the receive buffer
> > grow automatically no matter what the new value is can solve
> > the bad bandwidth issue meanwhile it's not breaking the application
> > with SO_RCVBUF option set.
> >
> > Here are some numbers:
> > $ sysctl -a | grep rmem
> > net.core.rmem_default = 212992
> > net.core.rmem_max = 40880000
> > net.ipv4.tcp_rmem = 4096        425984  40880000
> >
> > Case 1
> > on the server side
> >     # iperf -s -p 5201
> > on the client side
> >     # iperf -c [client ip] -p 5201
> > It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
> > server side is 10. It's good.
> >
> > Case 2
> > on the server side
> >     #iperf -s -p 5201 -w 425984
> > on the client side
> >     # iperf -c [client ip] -p 5201
> > It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
> > wcale is 2, even though the receive buffer is not changed at all at the
> > very beginning.
> >
> > After this patch is applied, the bandwidth of case 2 is recovered to
> > 9.34 Gbits/sec as expected at the cost of consuming more memory per
> > socket.
>
> How does your patch allow wscale to increase after flow is established ?
>
> I would remove from the changelog these experimental numbers that look
> quite wrong,
> maybe copy/pasted from your prior version.
>

My fault. I should have removed this part.

> Instead I would describe why an application might want to clear the
> 'receive buffer size is locked' socket attribute.
>
> >
> > Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> > --
> > v2: suggested by Eric
> > - introduce new socket option instead of breaking the logic in SO_RCVBUF
> > - Adjust the title and description of this patch
> > link: https://lore.kernel.org/lkml/CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com/
> > ---
> >
>
> I think adding another parallel SO_RCVBUF option is not good. It is
> adding confusion (and net/core/filter.c has been unchanged)

I'll change the filter.c altogether in the next submission.

>
> Also we want CRIU to work correctly.
>
> So if you have a SO_XXXX setsockopt() call, you also need to provide
> getsockopt() implementation.
>
> I would suggest an option to clear or set SOCK_RCVBUF_LOCK,  and
> getsockopt() would return if the bit is currently set or not.
>
> Something clearly describing the intent, like SO_RCVBUF_LOCK maybe.

Just now, I found out that the latest kernel has merged a similar
patch (commit 04190bf89) about three months ago.

Is it still necessary to add another separate option to clear the
SOCK_RCVBUF_LOCK explicitly?

Thanks,
Jason
