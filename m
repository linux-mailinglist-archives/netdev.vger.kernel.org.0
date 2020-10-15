Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1336428EB27
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 04:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730522AbgJOCY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 22:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726575AbgJOCY6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 22:24:58 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7D0C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 19:24:58 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id p3so616923pjd.0
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 19:24:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oNjJ2kOh6SghAjq7R9LGgXZ0vvoE/AmbehryQlQt4OU=;
        b=IUlYUmlQQQz21lXgDeUygJLkIDPLbLnHzrcWUxHbWCPWV/aFunWm1xc9K9m0bpO7KG
         iKOW9TPVtdCiD9ExPJAR45IzzE3QEG5RAGcDCh8708q8oCxbu2I19aNJH/0wOLIrK/yV
         4c9EPqg8sQ0jXVYto2kcor7JdJ8HyCEjQbe5ql0YmJ0GYTyyzzJIAVX3ezkLtPsU0adn
         xNtUVKziawf5WARQmIl58g9xaxda8iTi4N2sNiNoztSBxviCoh4yBVmcRQjcmaFVeGLi
         gVFk3JiVlzy+r/pIsFbYCSg5TY7keBwxDWlqQVy78fLg2MDVciKqoJJm8YJuS2qNSVkQ
         ZjoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oNjJ2kOh6SghAjq7R9LGgXZ0vvoE/AmbehryQlQt4OU=;
        b=Yxhk8Uj8dqatSGc3T+t5NDs69kSxzUWTaLGb86zewbQfkaJx21j/yianuhJm9gDx5G
         i4bPztpT48Y7Q3xXRSZP3ZgNXC/2zwVwMFbDHaeRQC9QwTn1scecOvgJJw5+sTrxdBkM
         034plNdvufBK4El346dZNyfyZvt1fJgh6C2Ve1Es9dPFaQ5wlbUEVKkGh8DkqyD0T+U2
         rmDvus6CU8YyeLBYqGv/iQvsgMv3zipro77m5TW+LuupdzHcNuE+QCwfQzIn75L5D1Rh
         2sCXlm7+eJzrPQdDqBv06GMYKGmHG8bhtuazP0fxxvO3kxeDGOQCB1/QtAF/PJqQJOaX
         ZrHg==
X-Gm-Message-State: AOAM530BtK87QvMHVUEBBNIUll5hwo6fAYWYCU5NDSA4n6NnKmaTim4O
        F3APU8gy+1i8oStDLEx+XEVZ/BZfjcHXbBM1EaI=
X-Google-Smtp-Source: ABdhPJyrgbn1PqKS/VKsX1Qx8iZmlk4YU/kns8nfh0L2bH7D6UUQXc5rap355NgKtkp99CQwfgenY7kVCIKtIgLEQ5A=
X-Received: by 2002:a17:902:9694:b029:d2:1b52:f46 with SMTP id
 n20-20020a1709029694b02900d21b520f46mr1936037plp.78.1602728697512; Wed, 14
 Oct 2020 19:24:57 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com>
 <CA+FuTSfeTWBpOp+ZCBMBQPqcPUAhZcAv2unwMLqgGt_x_PkrqA@mail.gmail.com>
 <CAJht_EM7KW1+sXpv2PZXwJuECuzDS7knEGGA9k6hogoPSDgW_g@mail.gmail.com>
 <CA+FuTScUwbuxJ-bed+5s_KVXMTj_com+K438hM61zaOp9Muvkg@mail.gmail.com>
 <CAJht_ENhobjCkQmKBB6DtZkx599F3dQyHA4i43=SDSzNkWPLgQ@mail.gmail.com>
 <CA+FuTSd=54S48QXk3-3CBeSdj8L3DAnRRE6LLmeXaN1kUq-_ww@mail.gmail.com> <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com>
In-Reply-To: <CAJht_EPFCTjv6JAMWFgCdgYpwfEVYB9_r0HaiKUTwekEiPnoDg@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 14 Oct 2020 19:24:46 -0700
Message-ID: <CAJht_EN2f=3fwjsW5GcXEAZJuJ934HFVAwxBFff-FAT17a=64w@mail.gmail.com>
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

On Wed, Oct 14, 2020 at 6:38 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Wed, Oct 14, 2020 at 1:19 PM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Wed, Oct 14, 2020 at 3:48 PM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > I thought we agreed that ideally GRE devices would not have
> > > header_ops. Currently GRE devices (in normal situations) indeed do not
> > > use header_ops (and use ARHPHRD_IPGRE as dev->type). I think we should
> > > keep this behavior.
> > >
> > > To solve the problem of the same dev->type having different
> > > hard_header_len values which you mentioned. I think we should create a
> > > new dev->type (ARPHRD_IPGRE_SPECIAL) for GRE devices that use
> > > header_ops.
> > >
> > > Also, for collect_md, I think we should use ARHPHRD_IPGRE. I see no
> > > reason to use ARPHRD_NONE.
> >
> > What does ARPHRD_IPGRE define beyond ARPHRD_NONE? And same for
> > ARPHRD_TUNNEL variants. If they are indistinguishable, they are the
> > same and might as well have the same label.
>
> It is indeed reasonable to keep devices indistinguishable to each
> other having the same dev->type label. But I see a lot of devices in
> the kernel without header_ops having different dev->type labels. For
> example, ARPHRD_SLIP should be the same as ARPHRD_RAWIP. One feature
> distinguishing these devices might be their dev->mtu.
>
> GRE devices may have their special dev->mtu determined by the maximum
> IP packet size and the GRE header length.
>
> For ARPHRD_TUNNEL, it may also have its own dev->mtu. I also see it
> has header_ops->parse_protocol (but it doesn't have
> header_ops->create).

Actually I think dev->type can be seen from user space. For example,
when you type "ip link", it will display the link type for you. So I
think it is useful to keep different dev->type labels without merging
them even if they appear to have no difference.
