Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5485449D775
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234428AbiA0BYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbiA0BYb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:24:31 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3DEC06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:24:30 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r10so1554052edt.1
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 17:24:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vJf2mRd+tbwdvn9tgAPFNERfpAwDkJ0uCkPclAj+Khk=;
        b=q1uD9DnJyJboF0x3lAMEI52udgGuIEKXMgo8ANvuioNsqHPd/8PQNztayhlp7aCM14
         byPPBbLOnMip9Z8KLwEWflKbufqc+JdMqWRlmQ/zUhhUOzwZHp85M4P8uX+UWw6uXG+l
         A0Cf7+zeoQX9Tw5aMH32nMI0RBK+WCNwUgOaJRsFCTQAhYKn1QSGDNw2fPrYqVb8E6CX
         PHGUwIgcrZ5rWeaIBM1dDX2AQcKD/6lMTGuS15P6Rf/sF0ZHFHueXtPIMbRozdKn37sp
         GmalM29aRWiPG5eok/zvLLBuUv2EN06csXI27CrMiwb7vNpaHTrqxmxVKhw2JxJtllZR
         NHXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vJf2mRd+tbwdvn9tgAPFNERfpAwDkJ0uCkPclAj+Khk=;
        b=npdmU8wWici0lDJhdx1fa59M/KXzrrhctLTfpW31f7o/cW4z/8hAYI0KC8MPu1AvqK
         UITg31lfcDTwCsY5R7JPg7sINCuJizjlVzgQixGyszJW35k82mrPnD5DJWI5OI2PKoaG
         eeqlxiCY6qdiKCxfjYEVsWjOf1C/peMb6zM9mRPRqahCUgHn/6Io7I+MnE4P0yhmzlP1
         JIlmrNPgny7ndy8fCNJXWr1Hmya7/6kxdeCzjI5s8ejDfWPeofXP6zebZinpqHu0Lle2
         GtGCulCFq6B9vyHdEaWKU8QzghNL9Cgf/9aVW7Wa1DZH7pb1cwXB14Dre7OPFimL/24s
         jQEA==
X-Gm-Message-State: AOAM530o8OmMnWS1iGkNgk3HZTGbspQ+fyLNTAn5hsdtmWJOJx2/v4YW
        vPTkMaV2a60ij3cWkLKR/5QtWpvAX7WXvxLNaCE=
X-Google-Smtp-Source: ABdhPJyjbeg7wlymL3E/9PovUx2fjES4BwaCwmmxx3aJLnHipPxRmzyUkp1LU6IW/YYeAAtogPJBUhouCuiJ0X2uD84=
X-Received: by 2002:a50:d0c4:: with SMTP id g4mr1598235edf.278.1643246669400;
 Wed, 26 Jan 2022 17:24:29 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
In-Reply-To: <CAM_iQpU3yK2bft7gvPkf+pEkqDUOPhkBSJH1y+rqM44bw2sNVg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 27 Jan 2022 09:23:53 +0800
Message-ID: <CAMDZJNXawPhiMYtdU_W3K5=WCj0eWKxUaoTE4NswX3NMfCSfoQ@mail.gmail.com>
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

On Thu, Jan 27, 2022 at 3:52 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Wed, Jan 26, 2022 at 6:32 AM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch allows user to select queue_mapping, range
> > from A to B. And user can use skbhash, cgroup classid
> > and cpuid to select Tx queues. Then we can load balance
> > packets from A to B queue. The range is an unsigned 16bit
> > value in decimal format.
> >
> > $ tc filter ... action skbedit queue_mapping skbhash A B
> >
> > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > is enhanced with flags:
> > * SKBEDIT_F_TXQ_SKBHASH
> > * SKBEDIT_F_TXQ_CLASSID
> > * SKBEDIT_F_TXQ_CPUID
>
> NAK.
>
> Keeping resending the same non-sense can't help anything at all.
>
> You really should just use eBPF, with eBPF code you don't even need
> to send anything to upstream, you can do whatever you want without
I know ebpf can do more things. but we can let everyone to use ebpf in
tc. For them, the
tc command is more easy to use in data center. we have talked this in
another thread.
> arguing with anyone. It is a win-win. I have no idea why you don't even
> get this after wasting so much time.
>
> Thanks.



-- 
Best regards, Tonghao
