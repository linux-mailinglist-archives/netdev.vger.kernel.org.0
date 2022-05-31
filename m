Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7455F539A17
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348281AbiEaXkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 19:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241462AbiEaXkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 19:40:17 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A02E4EA1F;
        Tue, 31 May 2022 16:40:14 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id i9so54811ioa.6;
        Tue, 31 May 2022 16:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=AtJsyzOUbu4GDp7o+VK71yiymtsTb77RW+MF+k9JICo=;
        b=RRi8z/yTb2PUOzcfXLioAwotBbgWJWVacW8fuxAbpsnvxRtgP+ktoIJ0YjxcdtQwXS
         hRIIDcJ7ZYS7kAeZQpe1YroaSXo18caeoaRvRMMz7DYd8mPnv6zzV+Lpn5bFdJPdir2R
         83Cz0lwXYvd/61nY3IHpabuq73sh4F5A5dXZBvcxNsbIxg9pde8PjDgb4hJKe24tf+F2
         i2vlhicPovoMUMiNM8L+PcZEJ1CvHvLF5bD6T0+mpMe8BkBa8NtUIR6wIzm5Qoby0uT3
         JIp+fFv/hJaI+aUT0NiEtDapRGbwfqS2PnIwoqftqjG1rAbNXzJUWNKbfPSfL22KfG9G
         2zkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=AtJsyzOUbu4GDp7o+VK71yiymtsTb77RW+MF+k9JICo=;
        b=FF7EgvkAjHN4T3PoRihRFoPUP/y7nIKkF4V/h0HzpHOA2jcAVm7J1G7mdlh1ghiMnL
         tNF1MSgiPwCo1MKF3OsuxHU+t4O9kgCBw6OHJLHBxOcdL1nribBf2yTaLGgkzB9jmu3C
         weSXSdWhG7VoNkozCXh6OQZ4qE+o+q6lmQ+Ep10BuqC51U/nyDe2YiPYHgvRB7/QetwT
         qTdEulpR8B03UVGHNQAvgwOuBj7oODuxy21uLv+Ls8UhOyx4br9Ocj3PTbDDUTK5CRlP
         tPTMly1VL5mxPsvg6FOrM4/kjQDWvDIYHE64wTKkplJ5j4+SKNSXACjHKOnpwaLsdoqT
         /yLA==
X-Gm-Message-State: AOAM531nQozHRUmokYo/Gp9I+xnZWo270Bl3DW5Nsmqa57djUNV6D2ft
        hZ4/7L9mhK9uiPinbx+Hbqlb9T80mmYPJA==
X-Google-Smtp-Source: ABdhPJzs+ZUNbw52nRonzmXx8I0zlnkgEThNKQXEFUZotUPOQjjMbRbhqhiYoaEJv1jt8W38B3153A==
X-Received: by 2002:a02:b796:0:b0:32e:a41e:df35 with SMTP id f22-20020a02b796000000b0032ea41edf35mr29703341jam.9.1654040412705;
        Tue, 31 May 2022 16:40:12 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id 11-20020a92c64b000000b002d1e3e3e475sm80748ill.32.2022.05.31.16.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 16:40:12 -0700 (PDT)
Date:   Tue, 31 May 2022 16:40:04 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        wangyufen <wangyufen@huawei.com>
Cc:     ast@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        daniel@iogearbox.net, lmb@cloudflare.com, davem@davemloft.net,
        kafai@fb.com, dsahern@kernel.org, kuba@kernel.org,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-ID: <6296a754d3f2b_2cd1a208d4@john.notmuch>
In-Reply-To: <878rqjm0ov.fsf@cloudflare.com>
References: <20220524075311.649153-1-wangyufen@huawei.com>
 <YpFEmCp+fm1nC23U@pop-os.localdomain>
 <3d11ae70-8c2d-b021-b173-b000dce588e0@huawei.com>
 <878rqjm0ov.fsf@cloudflare.com>
Subject: Re: [PATCH bpf-next] bpf,sockmap: fix sk->sk_forward_alloc warn_on in
 sk_stream_kill_queues
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> On Sat, May 28, 2022 at 09:54 AM +08, wangyufen wrote:
> > =E5=9C=A8 2022/5/28 5:37, Cong Wang =E5=86=99=E9=81=93:
> >> On Tue, May 24, 2022 at 03:53:11PM +0800, Wang Yufen wrote:
> >>> During TCP sockmap redirect pressure test, the following warning is=
 triggered:
> >>> WARNING: CPU: 3 PID: 2145 at net/core/stream.c:205 sk_stream_kill_q=
ueues+0xbc/0xd0
> >>> CPU: 3 PID: 2145 Comm: iperf Kdump: loaded Tainted: G        W     =
    5.10.0+ #9
> >>> Call Trace:
> >>>   inet_csk_destroy_sock+0x55/0x110
> >>>   inet_csk_listen_stop+0xbb/0x380
> >>>   tcp_close+0x41b/0x480
> >>>   inet_release+0x42/0x80
> >>>   __sock_release+0x3d/0xa0
> >>>   sock_close+0x11/0x20
> >>>   __fput+0x9d/0x240
> >>>   task_work_run+0x62/0x90
> >>>   exit_to_user_mode_prepare+0x110/0x120
> >>>   syscall_exit_to_user_mode+0x27/0x190
> >>>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>>
> >>> The reason we observed is that:
> >>> When the listener is closing, a connection may have completed the t=
hree-way
> >>> handshake but not accepted, and the client has sent some packets. T=
he child
> >>> sks in accept queue release by inet_child_forget()->inet_csk_destro=
y_sock(),
> >>> but psocks of child sks have not released.
> >>>
> >> Hm, in this scenario, how does the child socket end up in the sockma=
p?
> >> Clearly user-space does not have a chance to get an fd yet.
> >>
> >> And, how does your patch work? Since the child sock does not even in=
heirt
> >> the sock proto after clone (see the comments above tcp_bpf_clone()) =
at
> >> all?
> >>
> >> Thanks.
> >> .
> > My test cases are as follows:
> >
> > __section("sockops")
> > int bpf_sockmap(struct bpf_sock_ops *skops)
> > {
> > =C2=A0=C2=A0=C2=A0 switch (skops->op) {
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BPF_SOCK_OPS_PASSIVE_=
ESTABLISHED_CB:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 case BPF_SOCK_OPS_ACTIVE_E=
STABLISHED_CB:
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ..=
.
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bp=
f_sock_hash_update(skops, &sock_ops_map, &key, BPF_NOEXIST);
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 br=
eak;
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ...
> > }
> =

> Right, when processing the final ACK in tcp_rcv_state_process(), we
> invoke the BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB BPF callback.
> =

> This gives a chance to install sockmap sk_prot callbacks.
> =

> An accept() without ever calling accept() ;-)
> =

> [...]

LGTM as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
