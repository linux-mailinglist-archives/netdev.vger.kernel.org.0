Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C495932687F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 21:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231256AbhBZUUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 15:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhBZUSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 15:18:34 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8067C061222;
        Fri, 26 Feb 2021 12:15:53 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id o22so7197312pjs.1;
        Fri, 26 Feb 2021 12:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mb+a+iPifUcMlypSO/2znNyZszUx5kqHHIYdplyNQKE=;
        b=tv+erJ3fIJqxkJRhk3AyA8tVrsaRhN1kcda8ZThAF2/2aKoyGroiN9OpEDPCSduCmM
         +qVdya9vF+GOmCjijCs5zvcEaFq5uDTbyUA6XfBImxHPUQvwC5quQobrK4BHSQLAVQK5
         //Qr2scExcx9xzdjfYElFsQLXswfq/D+PlsSBbn3YbBy1QacalTTIDV7gqGpoJj5lnJd
         HJ5NMEw339qlO82opPfzTuZkRZMwupUgdpLGfVcyPVuS6hjC4VDgU0OofFPCDSns9PsE
         J+oyR+PikcSjOjfB6mDjm7v4bJXQhz3SGAMxbM0MnXJbKW7q8mQ9xpbf2UoCuJSxACmu
         9wDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mb+a+iPifUcMlypSO/2znNyZszUx5kqHHIYdplyNQKE=;
        b=PhOQbBriq2spT1U9wkIOPoSvgUqCzBMKlDuB5vWyUI8MqDOOkFDw0RJbJcmWq3dII8
         Vf9DT/ZNKkkwuXpn61L86RpPHct6QWMrQ/jtm+xq1o/k6m+Hl2C5DtqHap2WtX8Sa+pX
         /WJN0o0w4ph7Jrcw2nLejkFvm6WWCDYJ7EaHcYvwgbuhv2dtj7HimcLUm2q1ciG/WhGn
         146kt29jVIhQS1P4rKSptZD4HIRvRUKLb84gZMb2C8cGhOR4SY7oC2qAel6L7FiGEuJ5
         29yt0e+mN3zOtGnxtp4ZfJAUZyuVJ7gbWpcKYn+R/mXT4yzQQUbz5Ggsp2yuw1JhFWXb
         EZzg==
X-Gm-Message-State: AOAM532OxfHKU93WLau0P6SqlERawzS8qFTRnYYJgjmuABRscNQ9QohB
        bmmjvNODHlhK8+00K9dgxa78EVRCxZsh6QRN4cfUaGZayfHE9w==
X-Google-Smtp-Source: ABdhPJyBhtaFW+5H3Hag4UkmWG0/rwnGcCy0YKzQCDAn1APtu1dQOnmYkbs1hMZRsKITYMf6wQB96LLiLTTHLZjgWvU=
X-Received: by 2002:a17:902:9691:b029:e3:dd4b:f6bb with SMTP id
 n17-20020a1709029691b02900e3dd4bf6bbmr4519309plp.77.1614370553485; Fri, 26
 Feb 2021 12:15:53 -0800 (PST)
MIME-Version: 1.0
References: <20210226035721.40054-1-hxseverything@gmail.com>
In-Reply-To: <20210226035721.40054-1-hxseverything@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 26 Feb 2021 12:15:42 -0800
Message-ID: <CAM_iQpUAc5sB1xzqE7RvG5pQHQeCPJx5qAz_m9LaJYZ4pKfZsQ@mail.gmail.com>
Subject: Re: [PATCH/v3] bpf: add bpf_skb_adjust_room flag BPF_F_ADJ_ROOM_ENCAP_L2_ETH
To:     Xuesen Huang <hxseverything@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, bpf <bpf@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xuesen Huang <huangxuesen@kuaishou.com>,
        Willem de Bruijn <willemb@google.com>,
        Zhiyong Cheng <chengzhiyong@kuaishou.com>,
        Li Wang <wangli09@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 25, 2021 at 7:59 PM Xuesen Huang <hxseverything@gmail.com> wrote:
> v3:
> - Fix the code format.
>
> v2:
> Suggested-by: Willem de Bruijn <willemb@google.com>
> - Add a new flag to specify the type of the inner packet.

These need to be moved after '---', otherwise it would be merged
into the final git log.

>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Xuesen Huang <huangxuesen@kuaishou.com>
> Signed-off-by: Zhiyong Cheng <chengzhiyong@kuaishou.com>
> Signed-off-by: Li Wang <wangli09@kuaishou.com>
> ---
>  include/uapi/linux/bpf.h       |  5 +++++
>  net/core/filter.c              | 11 ++++++++++-
>  tools/include/uapi/linux/bpf.h |  5 +++++
>  3 files changed, 20 insertions(+), 1 deletion(-)

As a good practice, please add a test case for this in
tools/testing/selftests/bpf/progs/test_tc_tunnel.c.

Thanks.
