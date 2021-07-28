Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860B83D860C
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 05:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234519AbhG1DR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 23:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbhG1DR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 23:17:57 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E9EC061757;
        Tue, 27 Jul 2021 20:17:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id e2-20020a17090a4a02b029016f3020d867so2210560pjh.3;
        Tue, 27 Jul 2021 20:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dsf2sGa5jV2kjDjS35k1g7HufVmqs15n/JN/JKFWpGc=;
        b=OBzTcRUKWDdskdvj6UWxZXcPANCb4hsjnev6nV+DaMluvUGdtHuyH0m+ix1Wq3SvVs
         GStjN8cTWb+wYZ6hexIrprXWt1K1I8XO+P33JhbkHxQ3nAknaE1A8kc/lCe0pyrobX7B
         fl6g3rYHXkVgw5iGNxUFtFbjGxKeQMKIp2QU6j3Dh6GazJBTUGOXC+LF5bzj0Ps4vNHT
         bSXn9Quh52Oz2/ld4lj8BDKXiiIbgKMEe7BmpVUVrbo+UPdM1DAvi8QvdX7DlqDYPI+r
         XL9t2Y44OlsKT7JyIr/Xo69Jz31UJpYFzAa45v2Zu3eLMEQqtiVcLF57yZwKcRq4CkI1
         FEuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dsf2sGa5jV2kjDjS35k1g7HufVmqs15n/JN/JKFWpGc=;
        b=ZG8+SVzJSdn+G+PijzVB5l8hMgmj0G8JFkc0Tlw27fCyTvG7xoWC8GF03Pnr8oLdUh
         YHs8rxFIkHbCxJyYrB1iKbOZWMvq4R08yLYayuF6z+RNB716aUWVoL1LSUh1m/o2SfHY
         hKT8zChWQnSEefTpyTWO0RCtaqPXNThJqV3O5PNfjOAFFndYtyEVazJokEoCxBBu5lF1
         Q48UkDX2qLJ6ZoyYah17JOVBD2JnxCrzw7gF8UMlsjPz/IXR0HUwz9UuJbKw1acvx80b
         4GG77EELEjiJAVSkUPjH9FNrt3pRUeRMUi1bNpHi16wMkn7vq25FHFawj+IlwGiDEPHj
         poyA==
X-Gm-Message-State: AOAM533hiuYwvpIRvpUa4wXYVmyI6ed3pm1miMvGxqtPOtXh6azVpE3w
        icLqze4diA9yqM1dCyZfmY7K0rhGHINa6x13xrA=
X-Google-Smtp-Source: ABdhPJyLAHiJQhIHgjAibpUxV/lgyqUQp0vfdLmMXbYjqlfERTXlN9UpptmSiLL8O5RCbACmq5O1GBxqCKYgUQhnQA8=
X-Received: by 2002:a63:dd4a:: with SMTP id g10mr26923790pgj.179.1627442276573;
 Tue, 27 Jul 2021 20:17:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210715055923.43126-1-xiyou.wangcong@gmail.com> <202107230000.B52B102@keescook>
In-Reply-To: <202107230000.B52B102@keescook>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Jul 2021 20:17:45 -0700
Message-ID: <CAM_iQpV3Qm_GTfCX1E_OC0PXu+diT9QHtPt4OYcJdyGRcA37Sw@mail.gmail.com>
Subject: Re: [Patch net-next resend v2] net: use %px to print skb address in trace_netif_receive_skb
To:     Kees Cook <keescook@chromium.org>
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 12:09 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Wed, Jul 14, 2021 at 10:59:23PM -0700, Cong Wang wrote:
> > From: Qitao Xu <qitao.xu@bytedance.com>
> >
> > The print format of skb adress in tracepoint class net_dev_template
> > is changed to %px from %p, because we want to use skb address
> > as a quick way to identify a packet.
>
> No; %p was already hashed to uniquely identify unique addresses. This
> is needlessly exposing kernel addresses with no change in utility. See
> [1] for full details on when %px is justified (almost never).

This is clearly not true. Trust us, we _did_ use %p in the beginning,
it does not work at all. See the trace below captured with %p:

<idle>-0 [012] ..s. 385.248024: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=56 <idle>-0 [012] ..s. 385.261602:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=38 <idle>-0
[012] ..s. 387.245617: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 389.293621:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=38 <idle>-0
[012] ..s. 391.277637: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 392.939159:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=60 <idle>-0
[012] .Ns. 392.939197: ip_rcv: skbaddr=000000003fa575fb <idle>-0 [012]
.Ns. 392.939286: ip_local_deliver_finish: skbaddr=000000003fa575fb
kworker/12:1-122 [012] ..s. 392.939369: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=52 kworker/12:1-122 [012] ..s.
392.939371: ip_rcv: skbaddr=000000003fa575fb kworker/12:1-122 [012]
..s. 392.939409: ip_local_deliver_finish: skbaddr=000000003fa575fb
<idle>-0 [012] ..s. 393.261605: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 395.174268:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=56 <idle>-0
[012] ..s. 395.174275: ip_rcv: skbaddr=000000003fa575fb <idle>-0 [012]
..s. 395.174284: sk_data_ready: skaddr=0000000049f7d0d9,
skbaddr=000000003fa575fb <idle>-0 [012] .Ns. 395.174337: tcp_v4_rcv:
sport=8801 dport=15884 saddr=192.168.122.139 daddr=192.168.122.1
saddrv6=::ffff:192.168.122.139 daddrv6=::ffff:192.168.122.1
state=TCP_ESTABLISHED skbaddr=000000003fa575fb <idle>-0 [012] .Ns.
395.174338: ip_local_deliver_finish: skbaddr=000000003fa575fb <idle>-0
[012] ..s. 395.245605: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 397.293632:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=38 <idle>-0
[012] ..s. 397.352766: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=56 <idle>-0 [012] ..s. 397.352771:
ip_rcv: skbaddr=000000003fa575fb <idle>-0 [012] ..s. 397.352813:
sk_data_ready: skaddr=0000000049f7d0d9, skbaddr=000000003fa575fb
<idle>-0 [012] .Ns. 397.352819: tcp_v4_rcv: sport=8801 dport=15884
saddr=192.168.122.139 daddr=192.168.122.1
saddrv6=::ffff:192.168.122.139 daddrv6=::ffff:192.168.122.1
state=TCP_ESTABLISHED skbaddr=000000003fa575fb <idle>-0 [012] .Ns.
397.352819: ip_local_deliver_finish: skbaddr=000000003fa575fb <idle>-0
[012] ..s. 399.277623: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 401.261640:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=38 <idle>-0
[012] ..s. 402.671285: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=56 <idle>-0 [012] ..s. 402.671294:
ip_rcv: skbaddr=000000003fa575fb <idle>-0 [012] ..s. 402.671344:
sk_data_ready: skaddr=0000000049f7d0d9, skbaddr=000000003fa575fb
<idle>-0 [012] .Ns. 402.671355: tcp_v4_rcv: sport=8801 dport=15884
saddr=192.168.122.139 daddr=192.168.122.1
saddrv6=::ffff:192.168.122.139 daddrv6=::ffff:192.168.122.1
state=TCP_ESTABLISHED skbaddr=000000003fa575fb <idle>-0 [012] .Ns.
402.671356: ip_local_deliver_finish: skbaddr=000000003fa575fb <idle>-0
[012] ..s. 403.245617: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 403.688075:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=52 <idle>-0
[012] ..s. 403.688080: ip_rcv: skbaddr=000000003fa575fb <idle>-0 [012]
.Ns. 403.688092: sk_data_ready: skaddr=0000000049f7d0d9,
skbaddr=000000003fa575fb <idle>-0 [012] .Ns. 403.688094: tcp_v4_rcv:
sport=8801 dport=15884 saddr=192.168.122.139 daddr=192.168.122.1
saddrv6=::ffff:192.168.122.139 daddrv6=::ffff:192.168.122.1
state=TCP_CLOSE_WAIT skbaddr=000000003fa575fb <idle>-0 [012] .Ns.
403.688095: ip_local_deliver_finish: skbaddr=000000003fa575fb nc-1044
[012] ..s. 403.688222: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=52 nc-1044 [012] ..s. 403.688222: ip_rcv:
skbaddr=000000003fa575fb nc-1044 [012] ..s. 403.688237: tcp_v4_rcv:
sport=8801 dport=15884 saddr=192.168.122.139 daddr=192.168.122.1
saddrv6=::ffff:192.168.122.139 daddrv6=::ffff:192.168.122.1
state=TCP_CLOSE skbaddr=000000003fa575fb nc-1044 [012] ..s.
403.688246: ip_local_deliver_finish: skbaddr=000000003fa575fb <idle>-0
[012] ..s. 405.293625: netif_receive_skb: dev=eth0
skbaddr=000000003fa575fb len=38 <idle>-0 [012] ..s. 407.137723:
netif_receive_skb: dev=eth0 skbaddr=000000003fa575fb len=222


>
> > Note, trace ring buffer is only accessible to privileged users,
> > it is safe to use a real kernel address here.
>
> That's not accurate either; there is a difference between uid 0 and
> kernel mode privilege levels.

Not sure how accurate we can be just to make you happy. Please
give us a pointer on the accuracy.

Thanks.
