Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80C14C81BB
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 04:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbiCADo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 22:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbiCADo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 22:44:57 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4458F61A1F;
        Mon, 28 Feb 2022 19:44:17 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id d19so17114928ioc.8;
        Mon, 28 Feb 2022 19:44:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Vn+PVVoXKoUHPCXcRLpX+JrNULpiUavqMcZhXHY9RqY=;
        b=SBTqOQMCWs98AYaN0Qm+mIHtdyqugOlQKaCcmQq6sAdCK3KIOUizjR2zLILpjHYyZM
         2+NLpK/imqnPvwznXCJM7dUr9t6M8u/qvsfOvjaYDUyHED8uvMh5tSDkjVByapdyu5Av
         JJ7aoEYLpoI2x2U/w3bMg/hpSrbe0x438o0e1uctBNmB9Px9Pp64NtI+D0Lq7x0rNWzU
         VpTp6Z4WbkJRUgeBaRYU3rwmEpn+M/W8EET2E8hM4twiT/+qFWk/IIHNtwHdNP19h5j1
         bco+fpcX1oapsVo/bp3iazSfqKNIU3dGn6iBrbiSa3svsWnxGDLHwrqnin+mNUt0FiYg
         WbbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Vn+PVVoXKoUHPCXcRLpX+JrNULpiUavqMcZhXHY9RqY=;
        b=nuFhHxijJiLO85yc2i5zgt6ibHwipkJZc+Xo/EEpubAj0FPkSfm8G6wZwjWSWpfItO
         Y+/qC50empd1agkvOXRKByErrKfwXrNI3LK/2H1HfK7V0Zqj1tYBuKl6ELD8JpoV/eY1
         y08sE49odLeBnTqrrzbIvGUUYCGpkNfDO7uOi/B1NIiUovON8LULMsFG95Hxwg2BM6+A
         57WhDOfNFnBfLJqFiH2qffk6xeoTFruJCvtrejByyuD0oEalnUHTyImHD0MB2pB5q9zj
         zvuE8ldA4uWy4DVPSvkJKOxO3JLXHBn+YuHVsr60QEjXmRrDlEq3N5qlSr16YpHWjW46
         J/2A==
X-Gm-Message-State: AOAM530hqtOyPw/neLy+n5JGZB4ra0JUMZIxj1xJj++feU77+vsU/lBW
        bUyW73JYPXVMm/6q7Sdi/pZYf/7TC8U3WA==
X-Google-Smtp-Source: ABdhPJz7hjad9HXmOIERw9WyOvpJmxUuFOa1r+SJOXgozLOv3Fwi7RXrznYRZRgEChrQgLwXXjbVOA==
X-Received: by 2002:a05:6638:d52:b0:314:d4d9:f8e4 with SMTP id d18-20020a0566380d5200b00314d4d9f8e4mr19086526jak.139.1646106256662;
        Mon, 28 Feb 2022 19:44:16 -0800 (PST)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id l3-20020a056e020e4300b002c242b778a5sm7060174ilk.74.2022.02.28.19.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 19:44:16 -0800 (PST)
Date:   Mon, 28 Feb 2022 19:44:08 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     wangyufen <wangyufen@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        bpf@vger.kernel.org, edumazet@google.com, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org
Message-ID: <621d96888e266_8c479208da@john.notmuch>
In-Reply-To: <43776e3f-08c0-5d1a-1c2b-dd6084a6de33@huawei.com>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-2-wangyufen@huawei.com>
 <YhvPKB8O7ml5JSHQ@pop-os.localdomain>
 <43776e3f-08c0-5d1a-1c2b-dd6084a6de33@huawei.com>
Subject: Re: [PATCH bpf-next 1/4] bpf, sockmap: Fix memleak in
 sk_psock_queue_msg
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

wangyufen wrote:
> =

> =E5=9C=A8 2022/2/28 3:21, Cong Wang =E5=86=99=E9=81=93:
> > On Fri, Feb 25, 2022 at 09:49:26AM +0800, Wang Yufen wrote:
> >> If tcp_bpf_sendmsg is running during a tear down operation we may en=
queue
> >> data on the ingress msg queue while tear down is trying to free it.
> >>
> >>   sk1 (redirect sk2)                         sk2
> >>   -------------------                      ---------------
> >> tcp_bpf_sendmsg()
> >>   tcp_bpf_send_verdict()
> >>    tcp_bpf_sendmsg_redir()
> >>     bpf_tcp_ingress()
> >>                                            sock_map_close()
> >>                                             lock_sock()
> >>      lock_sock() ... blocking
> >>                                             sk_psock_stop
> >>                                              sk_psock_clear_state(ps=
ock, SK_PSOCK_TX_ENABLED);
> >>                                             release_sock(sk);
> >>      lock_sock()	=

> >>      sk_mem_charge()
> >>      get_page()
> >>      sk_psock_queue_msg()
> >>       sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED);
> >>        drop_sk_msg()
> >>      release_sock()
> >>
> >> While drop_sk_msg(), the msg has charged memory form sk by sk_mem_ch=
arge
> >> and has sg pages need to put. To fix we use sk_msg_free() and then k=
fee()
> >> msg.
> >>
> > What about the other code path? That is, sk_psock_skb_ingress_enqueue=
().
> > I don't see skmsg is charged there.
> =

> sk_psock_skb_ingress_self() | sk_psock_skb_ingress()
>  =C2=A0=C2=A0 skb_set_owner_r()
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sk_mem_charge()
>  =C2=A0=C2=A0 sk_psock_skb_ingress_enqueue()
> =

> The other code path skmsg is charged by skb_set_owner_r()->sk_mem_charg=
e()
> =

> >
> > Thanks.
> > .

I walked that code and fix LGTM as well.

Acked-by: John Fastabend <john.fastabend@gmail.com>=
