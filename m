Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C1D28EA43
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 03:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388121AbgJOBiQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 21:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728457AbgJOBiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 21:38:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E5BC061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 18:38:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e7so937915pfn.12
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 18:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xjoHR5NS3Y93BCcsCt4qk3hGdCPN6rf1CQt1k7IZuw0=;
        b=AMldrin15KtRqK6rJijDdX1hCHhDUzKlzV7QycUc+VRRk6oQePslk/GuyGKNTRasD6
         r0dC6k6THGNARZ2qDFd8vmAnJMchciOIYHVb05thZF9d+ThZbD2dnhgZt28KI+8jVoZq
         9Ts4Ol9kdwaozuigXd4S6uZlsNXbfUNYHmrMSjgnZ1dqDvz7NnyYa2H353+8Kh8q0KUG
         LZjIwLaqvOmsY1XLijrG/LJBBseyVYjZlpGtN0kUO0O9IgzGcjw+wx0yzZncqrO4ZAiC
         e+X0vYEMARkVaYVNqxAwZEkzoWZLgfkRjKrq2v08y+P5jzjGq7tJ9Jfjj5yg8ppQgNvg
         Btdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xjoHR5NS3Y93BCcsCt4qk3hGdCPN6rf1CQt1k7IZuw0=;
        b=fS72JvlmV3GitFBkGGrZo/NC7/kb7yYQfCuplkvEcLZF7buIEe17Nkz008qpEpJJoZ
         iFKg8g8xQbHs2HMnYppTsU5TXzP9d8nXXK86QOoq4k5Qadgph6uzvjuwSpI3vQ393FJ1
         dyf5i1fwIPL157oGojDPHGp3vHbB7x2RMhjCMi8qCMS1Ke1z7k1k4qWPSeehLfUfb1Y5
         nK3R5ejgjKEin83mSQzsT3ldgSjc+eyg++t9z0D9iALIHQPKgGiqVuWgHKLB51N19Xqv
         Md3BHuZETtUPpx4oQobbRqG0PvUBq76sRm4KSEjUdBmPTrA0C4GWGg3yloOmpBOGWanQ
         HSTA==
X-Gm-Message-State: AOAM532rNtkivKtVShO3dsOOmVDr9HD+LbKpA/CVRJh1Qyh5yF+CT3yJ
        XFSbTE0jzrxAzkI0H5QMgUIqmTRnZlxFjnLm10s=
X-Google-Smtp-Source: ABdhPJwqlMGAfbUl+/kKPwb3ny5a//C8ZldYINnMG1bEN3imaldPjZXgL0M86DPGcyx/N2ZzdRrrTSUaYB4lloK+/V4=
X-Received: by 2002:a63:7347:: with SMTP id d7mr1464934pgn.63.1602725895219;
 Wed, 14 Oct 2020 18:38:15 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
 <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com> <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
In-Reply-To: <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 14 Oct 2020 18:38:04 -0700
Message-ID: <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 1:19 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 3:48 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > I thought we agreed that ideally GRE devices would not have
> > header_ops. Currently GRE devices (in normal situations) indeed do not
> > use header_ops (and use ARHPHRD_IPGRE as dev->type). I think we should
> > keep this behavior.
> >
> > To solve the problem of the same dev->type having different
> > hard_header_len values which you mentioned. I think we should create a
> > new dev->type (ARPHRD_IPGRE_SPECIAL) for GRE devices that use
> > header_ops.
> >
> > Also, for collect_md, I think we should use ARHPHRD_IPGRE. I see no
> > reason to use ARPHRD_NONE.
>
> What does ARPHRD_IPGRE define beyond ARPHRD_NONE? And same for
> ARPHRD_TUNNEL variants. If they are indistinguishable, they are the
> same and might as well have the same label.

It is indeed reasonable to keep devices indistinguishable to each
other having the same dev->type label. But I see a lot of devices in
the kernel without header_ops having different dev->type labels. For
example, ARPHRD_SLIP should be the same as ARPHRD_RAWIP. One feature
distinguishing these devices might be their dev->mtu.

GRE devices may have their special dev->mtu determined by the maximum
IP packet size and the GRE header length.

For ARPHRD_TUNNEL, it may also have its own dev->mtu. I also see it
has header_ops->parse_protocol (but it doesn't have
header_ops->create).
