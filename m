Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A12949D78A
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbiA0BlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:41:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiA0BlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:41:07 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8612AC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:41:06 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ka4so2287955ejc.11
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IybmeY921J8ARnjyP5iTznRrII8k/ZIAmwCiNH0PAYw=;
        b=ODNVMhmqyPtZBGHHh1G87Bn11s2VQ9+fl/12okNPQ9gDvzm4QYodS4uoBB9zdQ01/i
         J84RmhUISS6AxK5GbVtjNBCILQb6la8sz+q/18pUKjJH4I+Fcr+ellYXuDGibWTb0XXM
         9tcpqNPZtdUFpG6/5TGmXXe2Z8/bSmLGXK3NRT+uwK52MJoQ17enETE3NqpOaX1J4U0P
         roK9QPeN5L68ZZeGMH4/uwVBrm31o4ZtjA74J+cWMtay4a79FUbLtsTIJJYGkxoDvNkA
         pUXOJKxaTSAJdoewL0t3fUd158cklQIrDeVWw0V0WwsQWdc16k/xrZ36pj/mD/KwP63+
         J45g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IybmeY921J8ARnjyP5iTznRrII8k/ZIAmwCiNH0PAYw=;
        b=JTiQtlR5DlRxMtybBJVYZvq53yXoClsmOcJV9iYqHMLHmcyafw+2jDl5UcWqeLQDX4
         pFmr1OmkIVkzqc/j4ghytj98ccPbdfNAUorcmg1UdQc0bXfGiVe3QeTfMasTrIV9VMTD
         xsZLUF8OEfBO3VrCZmYgVAkH8pYpZb0qE5eGy+Hdssk8fghbOgXDTCujjl6wMMRppsE9
         kEqi0VCdmDqO+VEPhCekYpTztva4LQvR8bJrTMPbr/YIKimgVXvZleqO4Gu1SHMofpFg
         6XPSuwR6cW3V1/bJx+OGNPlom1YKFOcb8Y4wKF/V2EeVfahqz5/byGN+OxILoBarxcqM
         r0GA==
X-Gm-Message-State: AOAM530I1ttmOuRuVjIo/bGVH2ukAcPY4iVsVk71xf8oNo+vAUrw35oC
        neC+EdZU/4vEGXdLsHenEsH1kTUy6znZtXWie3s=
X-Google-Smtp-Source: ABdhPJxXRH1u8GdFvSBTsPG6ioYWAwAoJOMpp94Hzg4n5yxHYwCRy8AN2GlAavWgPSKy7CrPLG65o2mgCfr5/2eYWIo=
X-Received: by 2002:a17:906:9b87:: with SMTP id dd7mr1201553ejc.552.1643247665177;
 Wed, 26 Jan 2022 17:41:05 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
 <CAMDZJNXawPhiMYtdU_W3K5=WCj0eWKxUaoTE4NswX3NMfCSfoQ@mail.gmail.com>
In-Reply-To: <CAMDZJNXawPhiMYtdU_W3K5=WCj0eWKxUaoTE4NswX3NMfCSfoQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Jan 2022 09:40:28 +0800
Message-ID: <CAMDZJNX_DqQjSeHu3c8nEiOT3FrN3x7SQ1gL+g23iXATNddWJA@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 9:23 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Thu, Jan 27, 2022 at 3:52 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Wed, Jan 26, 2022 at 6:32 AM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > This patch allows user to select queue_mapping, range
> > > from A to B. And user can use skbhash, cgroup classid
> > > and cpuid to select Tx queues. Then we can load balance
> > > packets from A to B queue. The range is an unsigned 16bit
> > > value in decimal format.
> > >
> > > $ tc filter ... action skbedit queue_mapping skbhash A B
> > >
> > > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > > is enhanced with flags:
> > > * SKBEDIT_F_TXQ_SKBHASH
> > > * SKBEDIT_F_TXQ_CLASSID
> > > * SKBEDIT_F_TXQ_CPUID
> >
> > NAK.
> >
> > Keeping resending the same non-sense can't help anything at all.
> >
> > You really should just use eBPF, with eBPF code you don't even need
> > to send anything to upstream, you can do whatever you want without
> I know ebpf can do more things. but we can let everyone to use ebpf in
can ->can't
> tc. For them, the
> tc command is more easy to use in data center. we have talked this in
> another thread.
> > arguing with anyone. It is a win-win. I have no idea why you don't even
> > get this after wasting so much time.
> >
> > Thanks.
>
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao
