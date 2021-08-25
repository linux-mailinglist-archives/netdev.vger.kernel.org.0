Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD133F795C
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241063AbhHYPsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240346AbhHYPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 11:48:44 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB43CC061757
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 08:47:58 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id ay33so16298062qkb.10
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 08:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TyXbzbfKOZ2ktu22gQKsofdIYZHzHFuZobIG77fyCcY=;
        b=tZoh19hIzrOZ2ezahl8c9mrXstZt3Vpr49rMu41rgyeCBgPXFkQoLeyMyU6qxzt9zz
         GAujAcoL5tMX2bEjDybWDgrgBdT/w0qlcF+LgSuTeJQffaAC+bHM0LbPFmaZalsk5F3V
         BaWhgyN2NwlhU0yHbKtsziByYbs6u7KplQrweghoZiXDZwQx5lDZvTYLQugWscF9g6zw
         +6kiRXw5zH8Yee6yYcVTu1QbZZib84i8TqFL0hqKvPtlI3Ahg1OjVmaT43D4vdJiKBkx
         sYjLx2BZ8iv6EB4E7a9p6j61d82Z5/4kKRlK3rzqAnNXFKY+7G0Fk+t2x21MMLsDEJYn
         0gVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TyXbzbfKOZ2ktu22gQKsofdIYZHzHFuZobIG77fyCcY=;
        b=qadrMj1JhSkvsRwwFEFkEbLHatZQf0jyRPxDmKLJ41IcuP18sHuiPaJ7rnlnLv/upY
         +hU3cM1iHJq0KdD19bo6HFa9rZk4uUqNN0U1L7Thf3l6qtUlpQXR7/SAfdpEEBKypKCW
         jvKBjhkjbfhaieqg0DNVkzD5aglXxZVo8CvU+ZkP+ShVZLaPC0ZpdPOGsw86NfZwRlvx
         Mwe9cgw0c/mq/IMdoITA1u9xwPWmxCWO29lgvAgGM7ogBvm/lDN7ibSCKpEiFcYzmzHY
         8/VZTuO91iZ7tXZhZlY5nEJEQaY+RE/e7WwFIOrpHFvrNM7rsCoMHBaCOV9ZdkCY2cwf
         dBrg==
X-Gm-Message-State: AOAM530Hu4LgH0YVj3OHIwE17lUpESSlBNMfiiZhxewgnA89MGENF+xA
        tcDoFiaCMAb8uDgiyZl96CfnZjJQ1sMYJa5KjEkh1CA24pI=
X-Google-Smtp-Source: ABdhPJy/CFaCu4ML6Pz8FwJBDv90dUXouGQdF3bYsTK9W+GqTFd3ySKOZvJPG8bZNpADEP1dN29tjWPW0Iy7ewlvvpE=
X-Received: by 2002:a25:2cd5:: with SMTP id s204mr10547135ybs.452.1629906477320;
 Wed, 25 Aug 2021 08:47:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210825154043.247764-1-yan2228598786@gmail.com>
In-Reply-To: <20210825154043.247764-1-yan2228598786@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 08:47:46 -0700
Message-ID: <CANn89iJO8jzjFWvJ610TPmKDE8WKi8ojTr_HWXLz5g=4pdQHEA@mail.gmail.com>
Subject: Re: [PATCH] net: tcp_drop adds `reason` parameter for tracing v2
To:     Zhongya Yan <yan2228598786@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, hengqi.chen@gmail.com,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 25, 2021 at 8:41 AM Zhongya Yan <yan2228598786@gmail.com> wrote:
>
> In this version, fix and modify some code issues. Changed the reason for `tcp_drop` from an enumeration to a mask and enumeration usage in the trace output.
> By shifting `__LINE__` left by 6 bits to accommodate the `tcp_drop` call method source, 6 bits are enough to use. This allows for a more granular identification of the reason for calling `tcp_drop` without conflicts and essentially without overflow.
> Example.
> ```


...

*/
> @@ -5703,15 +5700,15 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
>                         TCP_INC_STATS(sock_net(sk), TCP_MIB_INERRS);
>                 NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNCHALLENGE);
>                 tcp_send_challenge_ack(sk, skb);
> -               goto discard;
> +               tcp_drop(sk, skb, TCP_DROP_MASK(__LINE__, TCP_VALIDATE_INCOMING));

I'd rather use a string. So that we can more easily identify _why_ the
packet was drop, without looking at the source code
of the exact kernel version to locate line number 1057

You can be sure that we will get reports in the future from users of
heavily modified kernels.
Having to download a git tree, or apply semi-private patches is a no go.

If you really want to include __FILE__ and __LINE__, these both can be
stringified and included in the report, with the help of macros.
