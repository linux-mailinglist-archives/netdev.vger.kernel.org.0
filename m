Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC54B809D
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 07:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbiBPGZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 01:25:26 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiBPGZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 01:25:25 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB561D1793
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 22:25:09 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id e140so2988371ybh.9
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 22:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PF60trGTwto+G7FK7KYiFR5q+c9AYVK17+VWNcK7qFA=;
        b=CVeoJoRFtyPTieVAqzhRJI9uCBlv2cAsoTo9f6L1KFm/XI1BBDdawqJqhnapwnGN7x
         CrWgXqUu11eVpXZpwBWWKQa1je4W/YN8lvBifzIzAtjEjj7igUtiYaoXTEK2wsIN1IPM
         qB7EUrmOGX1POXWRk7Bk5iyeispWLytE2G++4+Ypwc67+CYn2dqJ5058i0lDF0QmJdN8
         EDoofx6NLfA45iOeCH4yPHf5CC3ViI216hJJ3susQcaGspi7YoQLhg6AqpnBIo/xKNmt
         Dth8rNMLFJEDbhnPVxCElDtdu43wTp9sgsey0LL4jsXcUtkEHnGo2lLNGfznzBRcfaO0
         m9mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PF60trGTwto+G7FK7KYiFR5q+c9AYVK17+VWNcK7qFA=;
        b=kGK8VoI0e+btsWsZ4+7shRRXdIfXwVc1sEFzel93p3dZf8wW0PFz4Q87CGWpGpSvoO
         IFHfq7WoWgcW74bumSu7z19Oy6CaejeSPtEWEJqo7gqy9O3Uk2fioewPn3+meN5K2ANd
         YbHEXNW5SqybdHBrQa8DJvJqgqdLMojkZwSiWeohLHk/IjbB1cV0cUtItV3gVmGgMIV+
         RqzCL/fBT6tn3oQvVyrQLP5LFP+iweEJ2VvQLag4gAGeC/vPftiXY2cY9IXT6J89Ju2b
         JVnWXGMCSXzRNYXcZrFTTQnshyu5AJSGNsKh4tHuq048lbvB6/ubBRysGddBaNSO+ViL
         J/VA==
X-Gm-Message-State: AOAM530YZGO0akbhCSB1ZUjx4z0TFO3JoSmFnGyzwfK/FmeIaa5MhAMz
        W0S8NcPRUIFtkJW0oIRebT7J8evQ6wMd0HWQNFUvzw==
X-Google-Smtp-Source: ABdhPJynAeAmgmRPW+V1S0j1QGe6ldhjYB54wvC7i3FRdnJzWd1P6SPZx8zi7cLfDcfpBM3EQ7Wmu6HzbawhPIipehY=
X-Received: by 2002:a81:347:0:b0:2d2:bca7:fe7f with SMTP id
 68-20020a810347000000b002d2bca7fe7fmr1070261ywd.467.1644992708711; Tue, 15
 Feb 2022 22:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20220216050320.3222-1-kerneljasonxing@gmail.com>
In-Reply-To: <20220216050320.3222-1-kerneljasonxing@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 22:24:57 -0800
Message-ID: <CANn89i+6Hc7q-a=zh_jcTn9_GM5xP6fzv2RcHY+tneqzE3UnHw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: introduce SO_RCVBUFAUTO to let the
 rcv_buf tune automatically
To:     Jason Xing <kerneljasonxing@gmail.com>
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
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 9:03 PM <kerneljasonxing@gmail.com> wrote:
>
> From: Jason Xing <xingwanli@kuaishou.com>
>
> Normally, user doesn't care the logic behind the kernel if they're
> trying to set receive buffer via setsockopt. However, once the new
> value of the receive buffer is set even though it's not smaller than
> the initial value which is sysctl_tcp_rmem[1] implemented in
> tcp_rcv_space_adjust(),, the server's wscale will shrink and then
> lead to the bad bandwidth as intended.

Quite confusing changelog, honestly.

Users of SO_RCVBUF specifically told the kernel : I want to use _this_
buffer size, I do not want the kernel to decide for me.

Also, I think your changelog does not really explain that _if_ you set
SO_RCVBUF to a small value before
connect() or in general the 3WHS, the chosen wscale will be small, and
this won't allow future 10x increase
of the effective RWIN.


>
> For now, introducing a new socket option to let the receive buffer
> grow automatically no matter what the new value is can solve
> the bad bandwidth issue meanwhile it's not breaking the application
> with SO_RCVBUF option set.
>
> Here are some numbers:
> $ sysctl -a | grep rmem
> net.core.rmem_default = 212992
> net.core.rmem_max = 40880000
> net.ipv4.tcp_rmem = 4096        425984  40880000
>
> Case 1
> on the server side
>     # iperf -s -p 5201
> on the client side
>     # iperf -c [client ip] -p 5201
> It turns out that the bandwidth is 9.34 Gbits/sec while the wscale of
> server side is 10. It's good.
>
> Case 2
> on the server side
>     #iperf -s -p 5201 -w 425984
> on the client side
>     # iperf -c [client ip] -p 5201
> It turns out that the bandwidth is reduced to 2.73 Gbits/sec while the
> wcale is 2, even though the receive buffer is not changed at all at the
> very beginning.
>
> After this patch is applied, the bandwidth of case 2 is recovered to
> 9.34 Gbits/sec as expected at the cost of consuming more memory per
> socket.

How does your patch allow wscale to increase after flow is established ?

I would remove from the changelog these experimental numbers that look
quite wrong,
maybe copy/pasted from your prior version.

Instead I would describe why an application might want to clear the
'receive buffer size is locked' socket attribute.

>
> Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
> --
> v2: suggested by Eric
> - introduce new socket option instead of breaking the logic in SO_RCVBUF
> - Adjust the title and description of this patch
> link: https://lore.kernel.org/lkml/CANn89iL8vOUOH9bZaiA-cKcms+PotuKCxv7LpVx3RF0dDDSnmg@mail.gmail.com/
> ---
>

I think adding another parallel SO_RCVBUF option is not good. It is
adding confusion (and net/core/filter.c has been unchanged)

Also we want CRIU to work correctly.

So if you have a SO_XXXX setsockopt() call, you also need to provide
getsockopt() implementation.

I would suggest an option to clear or set SOCK_RCVBUF_LOCK,  and
getsockopt() would return if the bit is currently set or not.

Something clearly describing the intent, like SO_RCVBUF_LOCK maybe.
