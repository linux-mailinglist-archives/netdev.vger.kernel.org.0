Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7B4F2CE7D9
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 06:56:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbgLDFzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 00:55:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbgLDFzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 00:55:52 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9A8C061A51;
        Thu,  3 Dec 2020 21:55:12 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id f9so2361855pfc.11;
        Thu, 03 Dec 2020 21:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/1OadALc5iFQns1WLD+456kpoRrFBtsFL8PSfXx560=;
        b=BoBr3TMOOwga/KailUe1iAIuMG5ZeAUavmsfKtjgmptC86o350fnDmw/s3XlHpdxma
         5FS1ScfudXT0Iva55qu8VjGOYl1OEwBxtrAAB0TVHMu7xoklc/ykH/ZXpHJzZCS9/yrW
         Y/tq9eiQ96VuvGH6QVEalAPrGA5sh+n5iTKLmWMgVQXko2wwaQH0u4wwWaJanPOLZMmj
         G0eTGr622vY/z4euZG8Qs+rCZz21YN/ih8KXJbPT1PSoL1BCeDfIInOZ4a211Tg2S9a+
         JAsBKGj0AiOAJw5LN6bVrnuSib7DIjU9v4rfiK2Tg1APrl4lcuDEB23LtIbJCo6CjXIu
         CwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/1OadALc5iFQns1WLD+456kpoRrFBtsFL8PSfXx560=;
        b=MqGxjPEkEft0PDB6lEXemM+v2HNWAYTeXOEqsJVq1DVIu78cR5tweN7frH/jfkzpDb
         7tsokZ8c1COWWsMz4bHfZcf3goNjmdKdf+ZefDy/A/Z1HFMoQ05Mr1vbR6HU7U6EM0Bd
         s7k5ccHbBFYOEggH81Ff+B4zzLo+NmqrzVWOqNU2AmAu3Z4493Tr6AVXY0iGo/CM9VaM
         +CHRHZhe64tQYXIcdFvDI/iHPVRjDnCrNYv4KxSTAQXYUppDhTignNWIU8PsbESJcktn
         IIFds1o+k0d48niogWq05z1qnbcbTeO6K6YQRBD6izm/8R1IvTVn1XqXvILJMe5FeJxv
         l2sw==
X-Gm-Message-State: AOAM5331bMirx+AVXTYUZ+F+9hzodJ80bUE56NsaTdiCy+TDZHj7Q62R
        kTcZCfaPCWC2jQ4LyKnIU+o+tJzbZVo+Yr+YpgQ=
X-Google-Smtp-Source: ABdhPJyclIFcWOpFo7Ps3i5Z6EWQuF1HxQtyzTR8HiVyfdeQZDB9AqwbfYLsNF42CrwRQ2wgUshpFRq7HeRU1FW6FfE=
X-Received: by 2002:aa7:93a7:0:b029:19d:89a6:eb13 with SMTP id
 x7-20020aa793a70000b029019d89a6eb13mr2428998pff.10.1607061312046; Thu, 03 Dec
 2020 21:55:12 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
 <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
 <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com>
 <CAM_iQpUUnsRuFs=uRA2uc8RZVakBXCA7efbs702Pj54p8Q==ig@mail.gmail.com> <CAADnVQJY=tBF028zLLq7HzQjSVwU+=1bvrKb75-zFts+36vdww@mail.gmail.com>
In-Reply-To: <CAADnVQJY=tBF028zLLq7HzQjSVwU+=1bvrKb75-zFts+36vdww@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 3 Dec 2020 21:55:00 -0800
Message-ID: <CAM_iQpU7juzuqy2T8gYQ+U_7HWc_rth304fNfKM5qW91CmE4fw@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 10:30 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Dec 3, 2020 at 10:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > On Thu, Dec 3, 2020 at 10:22 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > I guess my previous comment could be misinterpreted.
> > > Cong,
> > > please respin with changing preempt_disable to migrate_disable
> > > and adding local_bh_disable.
> >
> > I have no objection, just want to point out migrate_disable() may
> > not exist if we backport this further to -stable, this helper was
> > introduced in Feb 2020.
>
> I see. Then please split it into two patches for ease of backporting.

You mean the first patch does the same as this patch and the second
patch replaces preempt_disable() with migrate_disable(). Right?

Thanks.
