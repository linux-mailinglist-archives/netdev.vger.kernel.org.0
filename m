Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 176052CDDAD
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 19:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502043AbgLCSap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 13:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729423AbgLCSao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 13:30:44 -0500
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30396C061A4E;
        Thu,  3 Dec 2020 10:30:04 -0800 (PST)
Received: by mail-lj1-x22f.google.com with SMTP id s9so3607372ljo.11;
        Thu, 03 Dec 2020 10:30:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sMwK3ZOQpBBR+jqN/fy3oLVwK9deN2BlgOG2mDZy5bw=;
        b=Y8cROf4XqOcHQouA77T+cNpcibubaISN2yIBjSBYxZQlik4UeS3fUHF5SpmXlzXJw6
         SDW2jrj7Ij9XhnyiWO6tKRgfaYlJGypnvxUjNIR4EeZBQdTNhEPqt3iu5Pgw0J+2gjdr
         E3ZsWbDQgFETXwpFtq5yn/Fqdbdxgz/h7V+VWrjtWptuuTWtZ8eUOC8Z2GXMbUhH4w0S
         V0+7Sh0T29PoMG1YsZPiHlMp9HLWTA9gY2M+456dl3h3uHXhHgcgaQqDkPglddgkmd68
         KJC5N20MsiubXV61evhtf5hFvqG73VY87ZvRz3C+gsNIb1D1Tm9vCd33+l110p64jNxo
         2N+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sMwK3ZOQpBBR+jqN/fy3oLVwK9deN2BlgOG2mDZy5bw=;
        b=XEYQtC09HtQTgYuS1y7yoIzarCYVA28rlcI08SAZPBdvfyt8/jQbzJzBFpuUUXI7iw
         yDLygEo8BGrPjET+QcIDTDTjFLEOxOFCK8WZAmvEUxsnv7LejLNrRJV8rU0I1baHlD4C
         7Q72WKDcf19SYQMjHkD39c4/kQkPz+V3wHSsvid17/YnBfqgn9eDHwzj+KNH4flvtTXG
         ipmjH05djduZ9jTF3TvyUonOQofWcpj6tFp6Xprr+rMbr1yUPikcK2T/zT6vdarCHps4
         gmvOMSUNC+wOl1mcd7OY4ayXsV+xZVby+7kJ7egE71BZXF9FZc8BrNFJYeU2SMIYCIRD
         UPig==
X-Gm-Message-State: AOAM532IWOZCnrOWM7cmUdIe9WEjT1Tmzp28t442TSnj5Y64wnZICIuy
        ySK6pE2osZxvjBkuCZUio+xRn7Ft6A2VzB3jPFizO73N
X-Google-Smtp-Source: ABdhPJy5APB4VLAU4mO63YBpg7FoREaqc9fnCi0kuh4B5d8SOZc7VRW9cmLWMuSMRLtYBljGQbLXvfbETHQTpa93EJE=
X-Received: by 2002:a05:651c:10cc:: with SMTP id l12mr1809165ljn.51.1607020202650;
 Thu, 03 Dec 2020 10:30:02 -0800 (PST)
MIME-Version: 1.0
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
 <20201202171032.029b1cd8@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAM_iQpWfv59MoEJES1O=FhA4YsrB2nNGGaKzDmqcmXQXzc8gow@mail.gmail.com>
 <CAADnVQK74XFuK6ybYeqdw1qNt2ZDi-HbrgMxeem46Uh-76sX7Q@mail.gmail.com>
 <CAADnVQ+tRAKn4KR_k9eU-fG3iQhivzwn6d2BDGnX_44MTBrkJg@mail.gmail.com> <CAM_iQpUUnsRuFs=uRA2uc8RZVakBXCA7efbs702Pj54p8Q==ig@mail.gmail.com>
In-Reply-To: <CAM_iQpUUnsRuFs=uRA2uc8RZVakBXCA7efbs702Pj54p8Q==ig@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Dec 2020 10:29:51 -0800
Message-ID: <CAADnVQJY=tBF028zLLq7HzQjSVwU+=1bvrKb75-zFts+36vdww@mail.gmail.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 3, 2020 at 10:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Dec 3, 2020 at 10:22 AM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > I guess my previous comment could be misinterpreted.
> > Cong,
> > please respin with changing preempt_disable to migrate_disable
> > and adding local_bh_disable.
>
> I have no objection, just want to point out migrate_disable() may
> not exist if we backport this further to -stable, this helper was
> introduced in Feb 2020.

I see. Then please split it into two patches for ease of backporting.
