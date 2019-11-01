Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0A2EEBBC1
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 02:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbfKABlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 21:41:24 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43433 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbfKABlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 21:41:24 -0400
Received: by mail-lf1-f68.google.com with SMTP id j5so6132756lfh.10
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 18:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=28+bcFJYoJEnQTy+zZ2g/vNa2JUR4mv8q+aNelx1izA=;
        b=Jd2djWZT0/u9l71/nxHOhW6qzkErlZkrin+bZLqV3+OsC8RriKIjYuGozQ+JhrbIBQ
         5/rAIZj8rgfTibqqZqScbKPFHbDio8rlFW2unpbbP6alNS/OelFfDdfgcbv4W96eGqii
         mEMM4WD9kuC6HtgLZENWb5Gst1X7S5NyDcBiz9z19ViMlqFv+rjz60aogjfG9Cn9KKWH
         YIkdDQWLGljElQS8614e5jdFWxdafuL3Kcms7UV/38Ar9lW3vzsiSb5eHGYp1d1MDMOF
         Ay4XKe/SbDfuhOAOgwxkecc5ikctTSdOLIlDy/lqrk1J/MR2KYwMZN5iCJN+m3L+LOPe
         bOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=28+bcFJYoJEnQTy+zZ2g/vNa2JUR4mv8q+aNelx1izA=;
        b=aJml4r3+G6w7+nxR8IcZVCCrW4mw77Mkpn6zZTydj/qbEZ1WA8QGgoXU6RxHAo4OTp
         6/R4SyAThxV61tObgPjjNzw1dgxjOq7zdRtM0VTU/VCXauzlgwCo/M7/boCy+Y6/ZVfr
         cPOTRshwNqHm4DX0a0EGdMQ7dGoSJnRSv1fd0T2M2Nf0bMNjmkR694BZJ3Fk9zMfLThG
         evgBlydiL/H5FX17rtVcUJB1ZGhe176ODtwp36pcMhFTWIIK06PirMyUlNr0diLe4LUI
         FljVCQDSGLPBB9lQSLIlVvpMf9WbdPIc7JZEjMMQgrve1cQw2hQwCgtpYVovbfM7v+rA
         lv5Q==
X-Gm-Message-State: APjAAAWu8qkTOa3xcDHr88zHDlXxwwVko/gr7mm9CIvTSKX/JsKeqYaL
        ZpgzJGptduocLwL1301ACKfMoA==
X-Google-Smtp-Source: APXvYqy4K6BL9EY7AWIU4qqZykE10/6Du6BufIygn+JxjoCmJ6DC6uivddDrUirdI2OofJux0ZTYpQ==
X-Received: by 2002:ac2:46d7:: with SMTP id p23mr5484232lfo.104.1572572480575;
        Thu, 31 Oct 2019 18:41:20 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id v21sm1916783lfe.68.2019.10.31.18.41.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 18:41:20 -0700 (PDT)
Date:   Thu, 31 Oct 2019 18:41:11 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        oss-drivers@netronome.com, borisp@mellanox.com,
        aviadye@mellanox.com, daniel@iogearbox.net,
        syzbot+f8495bff23a879a6d0bd@syzkaller.appspotmail.com,
        syzbot+6f50c99e8f6194bf363f@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@kernel.org>,
        herbert@gondor.apana.org.au, glider@google.com,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH net] net/tls: fix sk_msg trim on fallback to copy mode
Message-ID: <20191031184111.535232f5@cakuba.netronome.com>
In-Reply-To: <20191031152444.773c183b@cakuba.netronome.com>
References: <20191030160542.30295-1-jakub.kicinski@netronome.com>
        <5dbb5ac1c208d_4c722b0ec06125c0cc@john-XPS-13-9370.notmuch>
        <20191031152444.773c183b@cakuba.netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 31 Oct 2019 15:24:44 -0700, Jakub Kicinski wrote:
> diff --git a/net/core/skmsg.c b/net/core/skmsg.c
> index cf390e0aa73d..c2b0f9cb589c 100644
> --- a/net/core/skmsg.c
> +++ b/net/core/skmsg.c
> @@ -261,25 +261,29 @@ void sk_msg_trim(struct sock *sk, struct sk_msg *msg, int len)
>         msg->sg.size = len;
>         while (msg->sg.data[i].length &&
>                trim >= msg->sg.data[i].length) {
> +               bool move_curr = msg->sg.curr == i;
> +
>                 trim -= msg->sg.data[i].length;
>                 sk_msg_free_elem(sk, msg, i, true);
>                 sk_msg_iter_var_prev(i);
> +               if (move_curr) {
> +                       msg->sg.curr = i;
> +                       msg->sg.copybreak = msg->sg.data[i].length;
> +               }
>                 if (!trim)
>                         goto out;
>         }

Thinking about this in between builds that is clearly nonsensical,
sorry. But I'd feel a little better if we merged a full fix instead of
just fixing the simple case for now :( Maybe I can produce a working
patch based on your description..
