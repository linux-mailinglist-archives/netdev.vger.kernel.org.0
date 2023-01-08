Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782F26612EC
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 02:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjAHBeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Jan 2023 20:34:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjAHBeo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Jan 2023 20:34:44 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 229273633E
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 17:34:43 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id bg13-20020a05600c3c8d00b003d9712b29d2so6343254wmb.2
        for <netdev@vger.kernel.org>; Sat, 07 Jan 2023 17:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nt8bf7yY2IA0nhwlnQJ7DuxvVX3dIEzslwGHOn83FJo=;
        b=CS2UnOpOHf41jr69bJneaWCGkc8bk32YP0s5iK4rEO0z+NR20cpaMGNGx+ftFR4c8e
         Y1dVMxrTUwLMLPZrDukwtYMsE+Shzn9eMPEYDe+cD5BmLzxV3NICUI36LHwOsn1hX3DK
         +2OJic1oF4odTJ15gsbB7TfvacN8oX1iwnAaBFpcn9zbP/FtnpqoftUQ4FRr1kxJrCdX
         JhdgyNpPGxD/6xGFcWcjSP+hmEH8tNJXXXLAN/BqBiLIGRZ8Kk/gG/8izubxx35IecE/
         N0rwdUiysbBAm2oj858eukW2Ala14qlJ+n0WspOsqKtk0/8S9PSzyvKMaYFSM2GVFJzW
         rXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nt8bf7yY2IA0nhwlnQJ7DuxvVX3dIEzslwGHOn83FJo=;
        b=poZaAmmJWa3oBqB+jf46wqq9RVe1+xw9YGguNGEUrQ78K0YxM6q+qM0IVQcyAWiF/P
         jVGF/Ale/xLMgY1yaRReekOmdyUOYZ6ON1grCGZTN7Kuv97kL3YOp14xlYjsGyu9vujh
         2obG78qIPuTvob9pWMKWFRaZkOh751VrVjA3lMFkrelgjq16XwresW+z547txmwfdDle
         ahSQfP94cxytkOYyNijNdpczRs8gIck0ColuEWZDlwjN4aaZwBONgGd2OraQGkmJP/QQ
         KGZp0EL26by0AheXmrtVPbMadv47iPkm4oPAOAk6FwWaJKcSkV3uwd7T1euvF8jmVEnG
         KRCw==
X-Gm-Message-State: AFqh2krKSkGHP4AYgO9bc4rUdhBVIt25cUtBjSopdEWlL3TuDIuhuwkQ
        RDoT0MLw/9yPDZqNUXIre867y3pAsbsWzQlURjfpzQ==
X-Google-Smtp-Source: AMrXdXu18jMQ566qkDjxqWcKsWO1kZvjAfxTKcA3J0VYERPSPKNK4p4VC0MLRdmYP3+hj9t4CxeB8XkMYa2uiHhmpnc=
X-Received: by 2002:a7b:c5d6:0:b0:3cf:70a0:f689 with SMTP id
 n22-20020a7bc5d6000000b003cf70a0f689mr2997475wmk.161.1673141681640; Sat, 07
 Jan 2023 17:34:41 -0800 (PST)
MIME-Version: 1.0
References: <20230107035923.363-1-cuiyunhui@bytedance.com> <Y7nP5PAGxWZ+2GHN@pop-os.localdomain>
In-Reply-To: <Y7nP5PAGxWZ+2GHN@pop-os.localdomain>
From:   =?UTF-8?B?6L+Q6L6J5bSU?= <cuiyunhui@bytedance.com>
Date:   Sun, 8 Jan 2023 09:34:30 +0800
Message-ID: <CAEEQ3wm3iZ1e3w=-Q_C19LbGsR_iDhWc_M-0KfmbPwUzqNVE=g@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3] sock: add tracepoint for send recv length
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     rostedt@goodmis.org, mhiramat@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kuniyu@amazon.com, duanxiongchun@bytedance.com,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 8, 2023 at 4:03 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:

>
> Thanks for the numbers, they help a lot.
>
> Acked-by: Cong Wang <cong.wang@bytedance.com>
>
> A few minor issues below.

Ok, Thanks for your suggestion, I'll update these on v4.

> > +
> > +     TP_printk("sk address = %p, family = %s protocol = %s, length = %d, error = %d, flags = 0x%x",
> > +                     __entry->sk,
> > +                     show_family_name(__entry->family),
> > +                     show_inet_protocol_name(__entry->protocol),
> > +                     __entry->length,
> > +                     __entry->error, __entry->flags)
>
> Please align and pack those parameters properly.

OK, thanks.

> > +
> > +DEFINE_EVENT(sock_msg_length, sock_recvmsg_length,
> > +     TP_PROTO(struct sock *sk, __u16 family, __u16 protocol, int ret,
> > +              int flags),
> > +
> > +     TP_ARGS(sk, family, protocol, ret, flags)
> > +);
>
> It might be a better idea to remove "msg" from the tracepoint names, in
> case of any confusion with "sendpage". So
> s/sock_sendmsg_length/sock_send_length/ ?

OK, I'll rename both to sock_send_length/sock_recv_length.


> > -     return INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> > +     int ret = INDIRECT_CALL_INET(sock->ops->recvmsg, inet6_recvmsg,
> >                                 inet_recvmsg, sock, msg, msg_data_left(msg),
> >                                 flags);
>
> Please adjust the indentations properly.

Roger that!

Thanks,
Yunhui
