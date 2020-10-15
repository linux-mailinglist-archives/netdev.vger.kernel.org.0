Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E3A28F38B
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgJONmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 09:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbgJONmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 09:42:49 -0400
Received: from mail-vs1-xe44.google.com (mail-vs1-xe44.google.com [IPv6:2607:f8b0:4864:20::e44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8F7C061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:42:49 -0700 (PDT)
Received: by mail-vs1-xe44.google.com with SMTP id r24so1519488vsp.8
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yhAwam6/6yJ/ArK+M28pw9dSx0XmaubY1A0wN5L+K+U=;
        b=BNVVs5xbbWu9LYJRGmiWrXSs9uQKjGXZMJ1o7cdMSFE4qNpLizorXCw0e00zmpXwpH
         CcQ2V6rQAwZOONEkg/Mtcn0FlS8sl+mN9ZvBbDf6PtBeDa3AVG8bsdJX6Qw8Qk8ObtEq
         pVS3mkz110UAJIDz49mjQ5GauBVVeY6RNEFMJjcFZCVoNHSzhGQZLtJNGrRODC3yeg/R
         BEgPwvqOIVTAoxLEQ01gaxs4QPz0IEe3KpCnna7iEVpg0ckd9zqS3J7C3ZK1fX8ZvAv0
         Yr7gsnA9AVksgJnmVt6NoZ0lhjNwBx6YzaDimb57IuFLZ7Nj8yQAhpYAFtY/YTBppWC7
         8tXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yhAwam6/6yJ/ArK+M28pw9dSx0XmaubY1A0wN5L+K+U=;
        b=C8Xc4tIYsTKbcy/UbQ//JrFztvcZCHpT9h0E1mHD4h6wWSWhI4Po1vFr/uzdiYxn9D
         ztq0gmBfWztsUxMM3BByS37zdma9FsPcHT8PpDNyG3vPv4YDpqmVC7lb4EE79aEttKqi
         SprncBMSKyskbsjxhZHl64K9CdssuaPUJKsRp8Bz682b2HfvEy6KeUrfYgPiy1zieMfz
         fEn9HM9Hr2SbFlej0rYyklwKxvyAgKji8FhOi7Dfn6iQlMUt3rJaBpJZXc+/S3qhXeEp
         sNPKmfdDjln8sotKYFHSyznopHB8hPDGQ1xCqu+sFGXkrLbfE6qj/Ai5ht3EHvclVdZK
         NzOw==
X-Gm-Message-State: AOAM532q39hVdQv7Iz9M9RQz6V+Pv88SKDIdJpveuPrDvAy6KZTXj3k5
        Vk6b1g6k8pz91oFlmniQUG09FL2NDuM=
X-Google-Smtp-Source: ABdhPJyCQOZxjsNQpIRFqBkCD04z9NV5sX6w0BjPIr1IxJFwsmBNvuCGyiK8iyS5HYs6f8G+G8wV8A==
X-Received: by 2002:a67:6b07:: with SMTP id g7mr2890887vsc.48.1602769367875;
        Thu, 15 Oct 2020 06:42:47 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id j198sm357371vsd.3.2020.10.15.06.42.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2020 06:42:46 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id d19so1507907vso.10
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 06:42:46 -0700 (PDT)
X-Received: by 2002:a05:6102:398:: with SMTP id m24mr2383271vsq.14.1602769365633;
 Thu, 15 Oct 2020 06:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
 <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
 <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
 <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com> <CAJht_EN2f=3fwjsW5GcXEAZJuJ934HFVAwxBFff-FAT17a=64w@mail.gmail.com>
In-Reply-To: <CAJht_EN2f=3fwjsW5GcXEAZJuJ934HFVAwxBFff-FAT17a=64w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 15 Oct 2020 09:42:08 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf+7fwJHBMog4wiGRmhD32qfdGVhnOarA9jpdeti822xw@mail.gmail.com>
Message-ID: <CA+FuTSf+7fwJHBMog4wiGRmhD32qfdGVhnOarA9jpdeti822xw@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 10:25 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 6:38 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2020 at 1:19 PM Willem de Bruijn
> > <willemdebruijn.kernel@gmail.com> wrote:
> > >
> > > On Wed, Oct 14, 2020 at 3:48 PM Xie He <xie.he.0141@gmail.com> wrote:
> > > >
> > > > I thought we agreed that ideally GRE devices would not have
> > > > header_ops. Currently GRE devices (in normal situations) indeed do not
> > > > use header_ops (and use ARHPHRD_IPGRE as dev->type). I think we should
> > > > keep this behavior.
> > > >
> > > > To solve the problem of the same dev->type having different
> > > > hard_header_len values which you mentioned. I think we should create a
> > > > new dev->type (ARPHRD_IPGRE_SPECIAL) for GRE devices that use
> > > > header_ops.
> > > >
> > > > Also, for collect_md, I think we should use ARHPHRD_IPGRE. I see no
> > > > reason to use ARPHRD_NONE.
> > >
> > > What does ARPHRD_IPGRE define beyond ARPHRD_NONE? And same for
> > > ARPHRD_TUNNEL variants. If they are indistinguishable, they are the
> > > same and might as well have the same label.
> >
> > It is indeed reasonable to keep devices indistinguishable to each
> > other having the same dev->type label. But I see a lot of devices in
> > the kernel without header_ops having different dev->type labels. For
> > example, ARPHRD_SLIP should be the same as ARPHRD_RAWIP. One feature
> > distinguishing these devices might be their dev->mtu.
> >
> > GRE devices may have their special dev->mtu determined by the maximum
> > IP packet size and the GRE header length.
> >
> > For ARPHRD_TUNNEL, it may also have its own dev->mtu. I also see it
> > has header_ops->parse_protocol (but it doesn't have
> > header_ops->create).
>
> Actually I think dev->type can be seen from user space. For example,
> when you type "ip link", it will display the link type for you. So I
> think it is useful to keep different dev->type labels without merging
> them even if they appear to have no difference.

Ah, indeed. These constants are matched in iproute2 in lib/ll_types.c
to string representations.

Good catch. Yes, then they have to stay as is.
