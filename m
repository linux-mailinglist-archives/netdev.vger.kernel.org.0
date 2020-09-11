Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 886AD265B56
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgIKIS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgIKISv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:18:51 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D20C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:18:50 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id j10so4785249qvk.11
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yeiTxZHkCcx6zZ/VcroXM91DjF/jL7wBn3ynIVAo6Pg=;
        b=ileaxb2Y4vF28DZsPqJhuC1Yiw1itkcRZuI0h27M1KwqRupQIPj0IKayC8qsZmGr1v
         U7HYulUuMq3Uk4PEaG6wE5urDXNVfvjvbJgAGVIaEor6bOqly2775XlVwgivT+BjO+1Q
         s5Vw33Jqt9MnXnk2kLP7zGwozZpoW2jNSlve0IvwHQgRwIkcxdX1syTR/4ppncxtDMw0
         flZH1xh8Mq2AOpPn2Yw44Hp+xRnXnTTTmQAD8aBFSkrspSDjoLdDzrizkwu/Vu79Z21x
         ZiJjReHd/To4f7IPvKFKtX5tgmdvNnWVZ73n2jsL1N1nU/ZZr7kwNaBho5QTEbpJ5K+t
         9YFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yeiTxZHkCcx6zZ/VcroXM91DjF/jL7wBn3ynIVAo6Pg=;
        b=iHHbNbgswSECTYoVDiS5tlkB14LmP0We4O/3JfaD49nbvZtuUWCfMSOZQipNulqaV3
         +Pl0hLiQo4iP+Li+C17xxvCqTMbK2yh0ZexKB5mzrM9kQGWhFku4JSTy4pEG/ZJabdpQ
         I+5r6cAGhIbMKUja0nBqnECXOuUZkKzkeXvuDo5fjif/arrBTLpiw2e9P48Iuf6aPOnT
         D1Sus1ePeAAgD1OQbqUpedIwIvkn29t9kCnITNmv9W4H062nK+3RkvDSnHGhyOkghwWW
         ozTwHwXRS68UgOXePhzK2lVyLmPtTYll9daHhF44DWBKPj5b2Mpvd3qAoECrUMeUtoyD
         6TAA==
X-Gm-Message-State: AOAM530x0D6dru/y8R2X3jpe+QVt3EthIwxad0ms7YQsVicnqHsr7+t5
        NI8ij0XgqZfdeV8uIxyJTUSVujKyRINw1CDAuXqa/w==
X-Google-Smtp-Source: ABdhPJwA4DRFhdljSWbTlsX52z0nAXDFCcrvp1oH2MLec3WIhtpIfScaFr+gruj5/XyK6Nr9yHGkp4B0Cmd+uwfG3rA=
X-Received: by 2002:a0c:cc13:: with SMTP id r19mr805512qvk.15.1599812329149;
 Fri, 11 Sep 2020 01:18:49 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000059b7205aa7f906f@google.com> <00000000000026751605aa857914@google.com>
 <CACT4Y+bUK4icp1TMfhWOj=vEXULbiUQ84RXYaKnB=3J_N3wZCQ@mail.gmail.com>
 <CAAhDqq0qcnMKdaoRnaGM6G8H1U7SAmTvX=hgEoor1=_eJff-Vw@mail.gmail.com>
 <CACT4Y+ZktT1S1oi5t+s7rrSH_dLEhyzygXdNUs7pkVPuanPXYg@mail.gmail.com> <20200911080601.GQ20687@gauss3.secunet.de>
In-Reply-To: <20200911080601.GQ20687@gauss3.secunet.de>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 11 Sep 2020 10:18:37 +0200
Message-ID: <CACT4Y+ZkUzNi10s+g1ySLn6bNnDtOHs4Ddr8XiDQrwG35hs-kA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in __xfrm6_tunnel_spi_lookup
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     B K Karthik <bkkarthik@pesu.pes.edu>,
        syzbot <syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 11, 2020 at 10:06 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Thu, Sep 10, 2020 at 10:09:50AM +0200, Dmitry Vyukov wrote:
> > On Thu, Sep 10, 2020 at 10:08 AM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> > >
> > > On Thu, Sep 10, 2020 at 1:32 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > > >
> > > > On Thu, Sep 10, 2020 at 9:20 AM Anant Thazhemadam
> > > > <anant.thazhemadam@gmail.com> wrote:
> > > > > Looks like this bug is no longer valid. I'm not sure which commit seems to have fixed it. Can this be marked as invalid or closed yet?
> > > >
> > > > You can see on the dashboard (or in mailing list archives) that B K
> > > > Karthik tested a patch for this bug in July:
> > > > https://syzkaller.appspot.com/bug?extid=72ff2fa98097767b5a27
> > > >
> > > > So perhaps that patch fixes it? Karthik, did you send it? Was it
> > > > merged? Did the commit include the syzbot Reported-by tag?
> > > >
> > >
> > > I did send it. I was taking a u32 spi value and casting it to a
> > > pointer to an IP address. Steffen Klassert
> > > <steffen.klassert@secunet.com> pointed out to me that the approach i
> > > was looking at was completely wrong.
> > > https://lkml.org/lkml/2020/7/27/361 is the conversation. hope this
> > > helps.
> >
> > +Steffen, was there any other fix merged for this?
>
> I think that was already fixed before the sysbot report came in by
> commit 8b404f46dd6a ("xfrm: interface: not xfrmi_ipv6/ipip_handler twice")

Thanks

Let's close the report then:

#syz fix: xfrm: interface: not xfrmi_ipv6/ipip_handler twice
