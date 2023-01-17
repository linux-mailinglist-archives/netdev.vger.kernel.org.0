Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F10D266DBAB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236319AbjAQK6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236270AbjAQK5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:57:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50D1B46D
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673953028;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=by59vt5O5/2ncqP/Kv4PzZ4BmzN7ElBU1lTkP73FTaM=;
        b=V9s9s2gSO2W7/vKh9qM1WtgvLDFRFEaOMLMSPls8r8uvhmZEduMNwDNsTyJWaSLZJd73TA
        GIZ31CNX0O4vj/T9k3MRYRcpeLVqWfiB6Z7YvbXmjasPLoJp1YACZt+zz319smpQRTQNtB
        9bL7SaDow/3ckZpxWjdKChg4SGK1Q9o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-377-uPOD0vqKPfG_4vngDlKRgw-1; Tue, 17 Jan 2023 05:57:07 -0500
X-MC-Unique: uPOD0vqKPfG_4vngDlKRgw-1
Received: by mail-qv1-f71.google.com with SMTP id nk14-20020a056214350e00b0053472f03fedso6058873qvb.17
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 02:57:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=by59vt5O5/2ncqP/Kv4PzZ4BmzN7ElBU1lTkP73FTaM=;
        b=kKuQ0S9DsfZzywrVrAkZ85yz/P6GfgBpYyZFNb/3vN2a926hdELtzw3+Z6FHZvqmws
         /pRh+46fPPYMrnY8OhGvT48anY32cdTzwVHVMZ/ZPB68oNe3l5Ogxd/3fVG0y/dH1jCf
         P5VJWGZuw4LzIb0ohnt14DP8kDC99z8TI1K2EDNn9UekL6MfoeJH8ZvGH1/cypy0gHm2
         +s++MVU9+QyoywU81cJkxgG7pZK0+/7yveuGzrWeybAOtBv7rybX+dWNrj8WlGr75Pt5
         zKYpKNLwTXTH/fAgtEQx4vhQ0qn0MICdI5AD2V49dvohcMNZLQpaLHVuTEzyubW4dGMm
         bMhw==
X-Gm-Message-State: AFqh2kpKhPB1Qg1jn2JbzevP4jUL0jDlGqtg+m1BC5r8rOdeDp/I3K3+
        +X461NurvLgrVYTzvpes6cy2rwOfLKKmSlSv4H0cOoHaGuA2ccH9c66JZuBIBUq801CAchPJTGA
        5GawN2ASjMHqNe6F+
X-Received: by 2002:ac8:5ed6:0:b0:3ab:9974:3a06 with SMTP id s22-20020ac85ed6000000b003ab99743a06mr2649853qtx.38.1673953026921;
        Tue, 17 Jan 2023 02:57:06 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsyS3YQ0mL/Cg7vTG+14PzeoCsb2FtDDQK/2T5Kec1K+WgHWObQ7z18H1diY6X1bdngCQ6FkQ==
X-Received: by 2002:ac8:5ed6:0:b0:3ab:9974:3a06 with SMTP id s22-20020ac85ed6000000b003ab99743a06mr2649840qtx.38.1673953026682;
        Tue, 17 Jan 2023 02:57:06 -0800 (PST)
Received: from debian (2a01cb058918ce00e96a110028ee7c10.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:e96a:1100:28ee:7c10])
        by smtp.gmail.com with ESMTPSA id w6-20020a05620a424600b00705be892191sm15560639qko.56.2023.01.17.02.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 02:57:06 -0800 (PST)
Date:   Tue, 17 Jan 2023 11:57:02 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        saeed@kernel.org, tparkin@katalix.com,
        Cong Wang <cong.wang@bytedance.com>,
        syzbot+52866e24647f9a23403f@syzkaller.appspotmail.com,
        syzbot+94cc2a66fc228b23f360@syzkaller.appspotmail.com,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>
Subject: Re: [Patch net v3 2/2] l2tp: close all race conditions in
 l2tp_tunnel_register()
Message-ID: <Y8Z+/mH8Jv2Y3M6V@debian>
References: <20230114030137.672706-1-xiyou.wangcong@gmail.com>
 <20230114030137.672706-3-xiyou.wangcong@gmail.com>
 <CANn89i+scj506yqh4YYAf5PQspbpqxym+YDiaXZTPaODM4_ANA@mail.gmail.com>
 <CANn89iJ1FZvtyHgXC69YEVirg0B5moKM1eDLSU1skLQV0PNrGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJ1FZvtyHgXC69YEVirg0B5moKM1eDLSU1skLQV0PNrGw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 09:10:20AM +0100, Eric Dumazet wrote:
> On Tue, Jan 17, 2023 at 9:08 AM Eric Dumazet <edumazet@google.com> wrote:
> > On Sat, Jan 14, 2023 at 4:01 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >  int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
> > >                        struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
> > >  {
> > > @@ -1482,21 +1480,16 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
> > >         }
> > >
> > >         sk = sock->sk;
> > > +       lock_sock(sk);
> > >         write_lock_bh(&sk->sk_callback_lock);
> > >         ret = l2tp_validate_socket(sk, net, tunnel->encap);
> > > -       if (ret < 0)
> > > +       if (ret < 0) {
> >
> > I think we need to write_unlock_bh(&sk->sk_callback_lock)
> > before release_sock(), or risk lockdep reports.
> >
> 
> Any objection if I propose :
> 
> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
> index b6554e32bb12ae7813cc06c01e4d1380af667375..03608d3ded4b83d1e59e064e482f54cffcdf5240
> 100644
> --- a/net/l2tp/l2tp_core.c
> +++ b/net/l2tp/l2tp_core.c
> @@ -1483,10 +1483,8 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
>         lock_sock(sk);
>         write_lock_bh(&sk->sk_callback_lock);
>         ret = l2tp_validate_socket(sk, net, tunnel->encap);
> -       if (ret < 0) {
> -               release_sock(sk);
> +       if (ret < 0)
>                 goto err_inval_sock;
> -       }
>         rcu_assign_sk_user_data(sk, tunnel);
>         write_unlock_bh(&sk->sk_callback_lock);
> 
> @@ -1523,6 +1521,7 @@ int l2tp_tunnel_register(struct l2tp_tunnel
> *tunnel, struct net *net,
> 
>  err_inval_sock:
>         write_unlock_bh(&sk->sk_callback_lock);
> +       release_sock(sk);
> 
>         if (tunnel->fd < 0)
>                 sock_release(sock);

Indeed, that looks more correct.
Thanks!

