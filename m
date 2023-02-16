Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2EE8699519
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjBPNEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbjBPNEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:04:13 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40DC48E26
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:04:02 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id x4so2077947ybp.1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 05:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l2PxVW51MqlyUBfenO0c8Evl2BEtNypum0JIz2lRRxE=;
        b=BBH+ZWcNWslWLKxcemSOxLHZqesBUcVEHPgngpFIkTF0wehBf5sayJMjFgMqaUtPxr
         Ruylks8NWot3ZSg7qbtSAovCRRLYt8/umIKWgoyYcYCUS0ltdfVD0oB6Zgayhd2P2QMM
         Pez7/c7CzpKRAJDx/5ao2V1xX7HKce62XdBWHghh9AJ7Y+nLCRGlJjL4bpjn3/Hk68io
         GBs29LEWu8pIbrjam0RtBz6UpSmTBI5r7kFbok2X9DGssyiW3exPe8KqJ8MoVps8eb36
         +RMUJ1HefRkuhju0m8/gGeorSB9Hs4q/YN7N9Jpaqar39k1j40OUVbogvozgEOh19P5c
         adgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l2PxVW51MqlyUBfenO0c8Evl2BEtNypum0JIz2lRRxE=;
        b=sN5RTUDJKwYm8N18QkZz8qZJZgd7gSbdBUv0GsC2LjQxiOjwBeXVPErI5Fw6H7swo5
         7yrhXfM+9g4MN76CN3xV3EuhDFgjgDwpYX7T9xdZfdIy84d7NhD2Qaul2Byw0EFwVf7/
         LqrbJbGWW0cJ+BOjghzH+ABh2aGKt/04wB4UGqSwBt4VYJ3FEXo0PB8bUHtLaNPToh45
         60HMoyfPRRQ4xcBFnCvEFx4wkudbCkQuDCgo0qejUxHijLLYZNO+mahKwHv7wsOCOm4t
         6NVavGe0kcEZ6trjfPdSCON2fQ4DC9jOq1iKOSuHwCK6v/U3D/PgKvCyvks9MB1S6TRl
         A5tA==
X-Gm-Message-State: AO0yUKUwCPcJQCA647JpXiT7H76YYXnQz4THBv16sY2oQYy+ftrlifKC
        hZr08ZfOUc0pVzepozMNoCMXVtBNSlRk4rijm5VoFbsKer6fZ7Z5PDE=
X-Google-Smtp-Source: AK7set+c7eA/ibc58A1rNwKcj/qYAYkqXmMsX0UZjvujv1AIP6fK3IOsE0kRV68vQ05WGnGufAAB6AIvzl9j2eLvR8I=
X-Received: by 2002:a5b:505:0:b0:927:aeef:106f with SMTP id
 o5-20020a5b0505000000b00927aeef106fmr852207ybp.667.1676552641691; Thu, 16 Feb
 2023 05:04:01 -0800 (PST)
MIME-Version: 1.0
References: <20230216124340.875338-1-jakub@cloudflare.com>
In-Reply-To: <20230216124340.875338-1-jakub@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 16 Feb 2023 14:03:50 +0100
Message-ID: <CANn89i+9xvtxdH1mT7tv5XXJjsDayRic=ecM30=qt_fnxuuc2Q@mail.gmail.com>
Subject: Re: [PATCH net] selftests/net: Interpret UDP_GRO cmsg data as an int value
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 1:43 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Data passed to user-space with a (SOL_UDP, UDP_GRO) cmsg carries an
> int (see udp_cmsg_recv), not a u16 value, as strace confirms:
>
>   recvmsg(8, {msg_name=...,
>               msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
>               msg_iovlen=1,
>               msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
>                             cmsg_level=SOL_UDP,
>                             cmsg_type=0x68}],    <-- UDP_GRO
>                             msg_controllen=24,
>                             msg_flags=0}, 0) = 11200
>
> Interpreting the data as an u16 value won't work on big-endian platforms.
> Since it is too late to back out of this API decision [1], fix the test.
>
> [1]: https://lore.kernel.org/netdev/20230131174601.203127-1-jakub@cloudflare.com/
>
> Fixes: 3327a9c46352 ("selftests: add functionals test for UDP GRO")
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  tools/testing/selftests/net/udpgso_bench_rx.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
> index 4058c7451e70..f35a924d4a30 100644
> --- a/tools/testing/selftests/net/udpgso_bench_rx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_rx.c
> @@ -214,11 +214,10 @@ static void do_verify_udp(const char *data, int len)
>
>  static int recv_msg(int fd, char *buf, int len, int *gso_size)
>  {
> -       char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
> +       char control[CMSG_SPACE(sizeof(int))] = {0};
>         struct msghdr msg = {0};
>         struct iovec iov = {0};
>         struct cmsghdr *cmsg;
> -       uint16_t *gsosizeptr;
>         int ret;
>
>         iov.iov_base = buf;
> @@ -237,8 +236,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
>                      cmsg = CMSG_NXTHDR(&msg, cmsg)) {
>                         if (cmsg->cmsg_level == SOL_UDP
>                             && cmsg->cmsg_type == UDP_GRO) {
> -                               gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
> -                               *gso_size = *gsosizeptr;
> +                               *gso_size = *(int *)CMSG_DATA(cmsg);
>                                 break;
>                         }
>                 }
> --
> 2.39.1
>

Yes, it seems user space often do not bother verifying cmsg->cmsg_len
against CMSG_LEN(sizeof(expected type))
(such sanity tests could be added to many of our selftests)

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
