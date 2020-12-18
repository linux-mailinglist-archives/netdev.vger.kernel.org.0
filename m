Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033602DE9A5
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 20:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729338AbgLRTPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 14:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727881AbgLRTPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 14:15:14 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BB6C0617B0;
        Fri, 18 Dec 2020 11:14:22 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id y4so2890151ybn.3;
        Fri, 18 Dec 2020 11:14:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x6gblIrOYfmLC3L9/1H3UYvolaQbmyZXMp4kXyPeBbg=;
        b=eTIo8M2G5mdZYETUbFXcH8hSfhhtfQ12yPvGqHrpzmjfNIks5yOMj4pZEfBrS8x8I5
         OerRDemBh3t3LUxy4SdKjw8prbBrL4n/Qbf6WIBy7fhJN2Ll4/naHTv5UrC5f/AyrdOg
         qVtQxoCVOAcCShoNG+SoFZXEPnYABHWy9uphmgwW/cMrMQ8d/HuebTNIUYsr1AajzlNK
         KgPaha7xeQrTrJ4wwU+b4ugviC/sb+a/F3sDZRYLaJvgYazroK7kUh8kv4VN6WfT1eqk
         SEBJEiHeXnMpOhFkdK6vg6BkvLyxpedTi/ZoQDups4sot7eBCFJ06yprNlHr4tgDldNB
         k6VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x6gblIrOYfmLC3L9/1H3UYvolaQbmyZXMp4kXyPeBbg=;
        b=uVn7xQVp0ZYne+ktEH5eVWGm1YfMrq40ymZAwESLLiNuwumStWloWBTQ8TNCH287OE
         996PqiCqa9ED9sndhySWwRWvpiO1MQO7yyoa+0ftkPX4gYa4fKSWthtVscTIBlsDWvbP
         4p8EfllYTx4iPMbix9JRirvUxYe18RaEeOXJaXQyNGDM4RPZqWMQLdTADy2YCYSLYFfC
         lIev8zZV8xGGup0H3UlQIaqnSwb+3osXsw+Luzg3qcRBaOKSZ6UdgrBNCXCeOaqaWrtJ
         Tu/3MdjDlgBwp9raVzc7f6S4y8Cvl6XXOx6CRAyiTp5xGkKB5+I7o7v2DzUvYBKtFcFe
         YKTw==
X-Gm-Message-State: AOAM5334ZbnovBn78InY93CEOnOfGCViGa6+L3gAlT4Bzj8BOVIwo2Vj
        MfKTnmHJBNXiI5vvKGHmU1pBehnAe+liFmzRgxI=
X-Google-Smtp-Source: ABdhPJzN28qhtnjg9jBr/nxWhZfWYgk/WdoL/s9+haXcV0n84rg5TRzISPy95HLIJnuuWOHGGyOFR3TdAyXDU/aG/iA=
X-Received: by 2002:a25:e804:: with SMTP id k4mr7524005ybd.230.1608318861743;
 Fri, 18 Dec 2020 11:14:21 -0800 (PST)
MIME-Version: 1.0
References: <20201214201118.148126-1-xiyou.wangcong@gmail.com>
 <20201214201118.148126-3-xiyou.wangcong@gmail.com> <CAEf4BzZa15kMT+xEO9ZBmS-1=E85+k02zeddx+a_N_9+MOLhkQ@mail.gmail.com>
 <CAM_iQpVR_owLgZp1tYJyfWco-s4ov_ytL6iisg3NmtyPBdbO2Q@mail.gmail.com>
 <CAEf4BzbyHHDrECCEjrSC3A5X39qb_WZaU_3_qNONP+vHAcUzuQ@mail.gmail.com>
 <CAM_iQpVBPRJ+t3HPryh-1eKxV-=2CmxW9T3OyO6-_sQVLskQVQ@mail.gmail.com>
 <CAEf4BzY4fdGieUbuAc4ttzfavBeGtE2a0rDmVfqpmZ6h6_dHiQ@mail.gmail.com>
 <CAM_iQpVsR=K344msuREEmidwXOeeZ=tdj4zpkrSX5yXz6VhijA@mail.gmail.com> <CAM_iQpXOts4YFsfaZYKiL-8u=v=0_vQ+DjML8g_JD0jPfz9kpw@mail.gmail.com>
In-Reply-To: <CAM_iQpXOts4YFsfaZYKiL-8u=v=0_vQ+DjML8g_JD0jPfz9kpw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 18 Dec 2020 11:14:10 -0800
Message-ID: <CAEf4BzYjdEjrEyo=sRsSMFBvBqYqW82TeVKAtqN=McSWDSfVvg@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 2/5] bpf: introduce timeout map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 17, 2020 at 1:14 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Dec 16, 2020 at 10:29 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Dec 16, 2020 at 10:35 AM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > > Minimize duplication of the code, no one said copy/paste all the code.
> > > But memory bloat is a real problem and should be justification enough
> > > to at least consider other options.
> >
> > Sure, I have no problem with this. The question is how do we balance?
> > Is rewriting 200 lines of code to save 8 bytes of each entry acceptable?
> > What about rewriting 2000 lines of code? Do people prefer to review 200
> > or 2000 (or whatever number) lines of code? Or people just want a
> > minimal change for easier reviews?
>
> No worry any more. I manage to find some way to reuse the existing

I never worried. But I'm glad you figured it out.

> members, that is lru_node. So the end result is putting gc stuff into
> the union with lru_node without increasing the size of htab_elem.
> And of course, without duplicating/refactoring regular htab code.
>
> Thanks.
