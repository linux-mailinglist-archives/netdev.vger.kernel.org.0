Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E398A217870
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 21:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgGGT6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 15:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728197AbgGGT6W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 15:58:22 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C7BDC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 12:58:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id o11so46588845wrv.9
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 12:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZBBaGQUZVhYoN/MI5LJRdBYtJiaCMh33BPZ2WN2cHlw=;
        b=GpQTAwgzNvAAJeFroRcO0OkegGLAUhnt69TTt9FP/nvqSbsYCoFI1IvecwoM1NPeR/
         RWj7AhWRY2fWSxilcN51unj6cLPYnLIPX7Wc41O+9KXh0staCTcSVcJazvqpwf71s4Ps
         RH9Bf1yjrXhYcU/PBzPxldjQGTY36AJJBfzmlixXF6OXCIP092ltF0aSi1maVUxqdMi1
         NmMReaV/hbAQH5zsGiA7hsNqEMR3tWFt2dPCc/JS1Q46Z5CaN07A3v9fp6+6ms+1Qxsb
         pVDrGeMJHtw1GDVqXhy87UYvWdu0xlqai3tg9DQyxI6a+bQ4RX7YHOsysZk3h+ZgK+xh
         wyPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZBBaGQUZVhYoN/MI5LJRdBYtJiaCMh33BPZ2WN2cHlw=;
        b=GssGl4/PDn6+jnl2+1lFjfyvko3v9HjmPZrzICL3wk7aY/NFt0fTBTexHyT7bPl13b
         oGSgIM1SLGqupumlDbU6pFuzCv6OFzXhIEFIrlb/HyOGwL65SGancuvrRpdyL36Q+WWc
         T/Uhz3vOxitf78gycJtWhNl6mZvVFndh38xmD/ncS65z614N24CvrtNavnvOzEO2dyMx
         FROUY6oIN+4VYM2N2kz7xm0ODYZIBp7s/OmKN+CEViGtZVovP4+tBjz4VgjTb/YlthVG
         Gw4E2jnIiQIKWWl43VXCagZ/kt7ml60EA30PEhjKgdgqHKt7feUIKLjKhvXEn6hvkrx4
         Nn5A==
X-Gm-Message-State: AOAM532PY0oyn048rFaVA53IEzjQYb5dXFlOcAzYmcrEmAlWdiix/02+
        SpR0i5u5EbfqlgzXLWh/RAk9ekyctvFCRBv2Gr7jDz6K
X-Google-Smtp-Source: ABdhPJzfn0HyRzxGXzAwippgb1uw+DhfYJX70DwjwXk8B71oER6lmd0AQXLiEQmFK+I4Hwosw1X+7dUyxjsNO8S0ENI=
X-Received: by 2002:adf:f5ce:: with SMTP id k14mr52847001wrp.234.1594151901265;
 Tue, 07 Jul 2020 12:58:21 -0700 (PDT)
MIME-Version: 1.0
References: <57ec206296ac8049d51755667b69aa0e978e3d6e.1594058552.git.lucien.xin@gmail.com>
 <20200707172408.GA22308@katalix.com>
In-Reply-To: <20200707172408.GA22308@katalix.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 8 Jul 2020 04:08:09 +0800
Message-ID: <CADvbK_eGefF8ZZE74=GenWknj-ws4y6D95jji5e-FiRt36m-nA@mail.gmail.com>
Subject: Re: [PATCH net] l2tp: remove skb_dst_set() from l2tp_xmit_skb()
To:     James Chapman <jchapman@katalix.com>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 1:24 AM James Chapman <jchapman@katalix.com> wrote:
>
> On  Tue, Jul 07, 2020 at 02:02:32 +0800, Xin Long wrote:
> > In the tx path of l2tp, l2tp_xmit_skb() calls skb_dst_set() to set
> > skb's dst. However, it will eventually call inet6_csk_xmit() or
> > ip_queue_xmit() where skb's dst will be overwritten by:
> >
> >    skb_dst_set_noref(skb, dst);
> >
> > without releasing the old dst in skb. Then it causes dst/dev refcnt leak:
> >
> >   unregister_netdevice: waiting for eth0 to become free. Usage count = 1
> >
> > This can be reproduced by simply running:
> >
> >   # modprobe l2tp_eth && modprobe l2tp_ip
> >   # sh ./tools/testing/selftests/net/l2tp.sh
> >
> > So before going to inet6_csk_xmit() or ip_queue_xmit(), skb's dst
> > should be dropped. This patch is to fix it by removing skb_dst_set()
> > from l2tp_xmit_skb() and moving skb_dst_drop() into l2tp_xmit_core().
> >
> > Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
> > Reported-by: Hangbin Liu <liuhangbin@gmail.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  net/l2tp/l2tp_core.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> >
> > diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> > index fcb53ed..df133c24 100644
> > --- a/net/l2tp/l2tp_core.c
> > +++ b/net/l2tp/l2tp_core.c
> > @@ -1028,6 +1028,7 @@ static void l2tp_xmit_core(struct l2tp_session *session, struct sk_buff *skb,
> >
> >       /* Queue the packet to IP for output */
> >       skb->ignore_df = 1;
> > +     skb_dst_drop(skb);
> >  #if IS_ENABLED(CONFIG_IPV6)
> >       if (l2tp_sk_is_v6(tunnel->sock))
> >               error = inet6_csk_xmit(tunnel->sock, skb, NULL);
> > @@ -1099,10 +1100,6 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
> >               goto out_unlock;
> >       }
> >
> > -     /* Get routing info from the tunnel socket */
> > -     skb_dst_drop(skb);
> > -     skb_dst_set(skb, sk_dst_check(sk, 0));
> > -
> >       inet = inet_sk(sk);
> >       fl = &inet->cork.fl;
> >       switch (tunnel->encap) {
> > --
> > 2.1.0
> >
>
> This patch doesn't seem right.

Hi James,
>
> For ipv4, the skb dst is used by skb_rtable. In ip_queue_xmit, if
> skb_rtable returns a route, it follows the packet_routed label and
> skb_dst_set_noref isn't done. Your patch is forcing every ipv4 l2tp
> packet to be routed, which isn't what we want.
Without this patch,
it does skb_dst_drop() in l2tp_xmit_skb(),
then do:
skb_dst_set(skb, sk_dst_check(sk, 0));

With this patch:
it does skb_dst_drop() in l2tp_xmit_core()

then in ip_queue_xmit(), it will do:
rt = (struct rtable *)__sk_dst_check(sk, 0);
skb_dst_set_noref(skb, &rt->dst);

so I don't think this patch drops any useful dst for ipv4.

>
> I ran l2tp.sh and found that the issue happens only for l2tp tests
> that use IPv6 IPSec in a routed topology.
>
> Perhaps the real problem is that l2tp shouldn't be using
> inet6_csk_xmit and should instead use ip6_xmit?
>
> Please hold off on applying this patch while I look into it.
