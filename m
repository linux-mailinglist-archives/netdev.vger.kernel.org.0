Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC213532A7
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 07:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbhDCFIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 01:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhDCFIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 01:08:52 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A18C0613E6;
        Fri,  2 Apr 2021 22:08:50 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id i6so4734317pgs.1;
        Fri, 02 Apr 2021 22:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Ep2ctAJZrlZ4JQpMH97/kZTnvRC4wb/3fpwXdswd1g=;
        b=Uq4Gxznst7aCVH+mFL4q/hJDqQ1gbPq0euM4aoktP7WtuDlPz1mUuWUKRWzLmA8YF7
         LOCfyuPwmWxzBolsiW8qUHm5P1BUlUOUP/2kSqMrsDrGoYvj9jJmA3NuM2tu3lGy5eqA
         TCJRVtBfx3FPBirrypDoVMKTfunpfz3XIJNupN1VUZ7m+JigArTeXspsj2YtS/T4VLwK
         WccjKvrQNVWWelL02saO6RbDs3GWP65nTOWQ1e6dp+8+yl25RmdwISojfjrgPACyXOpF
         WIp0J1ucMjukWyd26kYiHd3K//poubhK+gDIOw+8ON4159hJmRmIhQcLczKtLKsM6SZW
         sjQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Ep2ctAJZrlZ4JQpMH97/kZTnvRC4wb/3fpwXdswd1g=;
        b=EP7pS8tfLcE2VI5CQN4RIGU4JM/INXPZ1aFO2X2OWGDiu8KTJi10Izm4LRqH7wn1f3
         EtWvnvq5hntPCTSkAJCknV4/Y4P43PuYowLH44/uPygZDRINZD9YoKyuV0vxzIFuP/D6
         /J6YoB4NMSxAq+OLZswyRIMkTTWqt6ZW5DMlD9W3fX3ci60OkjTtIBvZP/woOxI0V9bp
         UCSw3MJI3uUeuoW7xcRoIPW9sSa31ot4sGn8tHmBbb4BWsfNZdkeoFeLbyv5S5O8DZz8
         R4/VuN9IYQqt3B4iUU/+6E8jF67JBWf8ku59L7kfUUgbjgRziS4fPcTJliag/YaR+N9g
         hK6g==
X-Gm-Message-State: AOAM532Mm34/at3AdsV7mLxpMThRHfXbBW+Ac0kPStqS1WzVVH2DgTEr
        LO+wAPB/S7RBvl87xwMuHFmWWf8l9LmMuwJABTs=
X-Google-Smtp-Source: ABdhPJyZAnYKz8wFKwoc7GgLFJDhZj7zXQLhaZlpl4+zmbhg4+w0YLq6DLXcW+Iw8IhE9rXO108LGnQ2mHFCRfhdZG0=
X-Received: by 2002:a63:2ec7:: with SMTP id u190mr14570991pgu.18.1617426529274;
 Fri, 02 Apr 2021 22:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20210331023237.41094-1-xiyou.wangcong@gmail.com>
 <20210331023237.41094-12-xiyou.wangcong@gmail.com> <6065619aa26d1_938bb2085e@john-XPS-13-9370.notmuch>
In-Reply-To: <6065619aa26d1_938bb2085e@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Fri, 2 Apr 2021 22:08:38 -0700
Message-ID: <CAM_iQpVG3Sd=jA4jdt6HFRr8rKn7DRdWRyHBd9O3q0DuubMsRg@mail.gmail.com>
Subject: Re: [Patch bpf-next v8 11/16] udp: implement ->read_sock() for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 11:01 PM John Fastabend
<john.fastabend@gmail.com> wrote:
> This 'else if' is always true if above is false right? Would be
> impler and clearer IMO as,
>
>                if (used <= 0) {
>                         if (!copied)
>                                 copied = used;
>                         break;
>                }
>                copied += used;
>
> I don't see anyway for used to be great than  skb->len.

Yes, slightly better. Please feel free to submit a patch by yourself,
like always your patches are welcome.

Please also remember to submit a patch to address the name
TCP_ESTABLISHED, or literally any code you feel uncomfortable
with. I am actually comfortable with what they are, hence not
motivated to make a change.

BTW, please try to group your reviews in one round, it is
completely a waste of time to address your review one during
each update.

On my side, I need to adjust the cover letter, rebase the
whole patchset, and manually add your ACK's. On your side,
you have to read this again and again. On other people side,
they just see more than a dozen patches flooding in the mailing
list again and again. In the end, everyone's time is wasted, this
can be avoided if you just try to group as many reviews as possible
together. I certainly do not mind waiting for more time just to get
more reviews in one round.

And please do not give any ACK unless you are comfortable with
the whole patchset, because otherwise I have to add it manually.
It is not too late to give one single ACK to the whole patchset once
you are comfortable with everything. This would save some traffic
in the mailing list too.

Thanks!
