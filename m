Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D984010AA
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhIEPy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbhIEPyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:54:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4044C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 08:53:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id e21so8115064ejz.12
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:53:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8/rHObnVcA+CHkGC0ScxYD7AHQulA6jGTXzVzfO0V9c=;
        b=M4z7ylVOA1TJkPqkMMOtlDKvXL+W3NsOH+5gUtFLcfHEAjY4kTpKmmWLXfhL39hDLq
         RtPGvb/CMY9yis3oYBf4zCfp2rVNeyTa2fQgUDjWcVP18ZcYJUH5W80M7HwN5plBchea
         OeOGW7x0TDD1BesYaFSEsCHZd+NoYm2uBfLLSGR7Xbm2vm2LM6e4eSQOuMkI6I/pwnlI
         UIAxfxEuth25GMaQ5/ojOhShqwnqxS+NBtzgBhg7p2EM4pKa0osKaIiDLwpb0tJ3PdhK
         NObb4qWJC07Sttwdm5+GHVdjkArjNlFfN98pJwd9yYg76SXIpZNgF7OGdxSbDA3brD4q
         j2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8/rHObnVcA+CHkGC0ScxYD7AHQulA6jGTXzVzfO0V9c=;
        b=GyHeKSj0pr35yd+tDvvsCBk7NKaX8MkPe6bDsc94dgo9oteQQdDZowqBPYL7Gas5fi
         13h8Jmtw71YOpkdQN3W1W1ROKxsDFAulNxiNsc1HVumI9Jljod4R0JaRpK3ySMHCh4Dq
         dHskj3J5KEeu6lHPZ7bGSFUGmziyEiLuZ05hslhznwajn2yNG3I0hO7Rh87NpDnqY0Id
         zqRsLeCuhTdVmIxItxbExpCj9LWr46UFkGAAPTJbFatcoLVf/vo3vlihRIn9vbPF3D/q
         QuE1mwqpVel72Sj+4wUjuIY8q4EYC5UVwaKZtJLDCsnhs9vspGJt+2z8ch1Wsewvg+YB
         6SXA==
X-Gm-Message-State: AOAM532lxmLk+NulA8qfWAm2Y5A19gXczUBo4nqHla8gXqWHYLlmXwWN
        jEhL/uLHhU8zlzcWqubkMTOLgEF+pm17iK0HpnT4hReo
X-Google-Smtp-Source: ABdhPJzbEhhIR6nGbGIXbiOZHNb7YO/xSWYDyU5PbfpTFyohLBhoJFFuWIK1AFidFyADRTVZnEgZpzLgSsejfiKFl6A=
X-Received: by 2002:a17:906:3e10:: with SMTP id k16mr9424765eji.116.1630857199155;
 Sun, 05 Sep 2021 08:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210902193447.94039-1-willemdebruijn.kernel@gmail.com>
 <20210902193447.94039-2-willemdebruijn.kernel@gmail.com> <CAKgT0UdhaUp0jcNZSzMu=_OezwqKNHP47u0n_XUkpO_SbSV8hA@mail.gmail.com>
 <CA+FuTSfaN-wLzVq1UQhwiPgH=PKdcW+kz1PDxgfrLAnjWf8CKA@mail.gmail.com>
 <CAKgT0UdtqJ+ECyDs1dv7ha4Bq12XaGiOQ6uvja5cy06dDR5ziw@mail.gmail.com>
 <CA+FuTSfpmGHC76GAVVS2qazfLykVZ=mM+33pRHpj-yyM3nqhXA@mail.gmail.com>
 <CAKgT0UdiYRHrSUGb9qDJ-GGMBj53P1L4KHSV7tv+omA5FjRZNQ@mail.gmail.com>
 <CA+FuTSf-83bDVzmB757ha99DS=O-KjSFVSn15Y6Vq5Yh9yx2wA@mail.gmail.com>
 <CAKgT0Uf6YrDtvEfL02-P7A3Q_V32MWZ-tV7B=xtkY0ZzxEo9yg@mail.gmail.com>
 <CA+FuTSeHAd4ouwYd9tL2FHa1YdB3aLznOTnAJt+PShnr+Zd7yw@mail.gmail.com>
 <CAKgT0Ucx+i6prW5n95dYRF=+7hz2pzNDpQfwwUY607MyQh1gGg@mail.gmail.com>
 <CA+FuTSdwF7h5S7TZAwujPWhPqar6_q-37nT_syWHA+pmYm68aw@mail.gmail.com>
 <CAKgT0Ud5ZFQ3Jv4DAFftf6OkhJe5UxEcuVTJs-9HYk8ptCt9Uw@mail.gmail.com>
 <CA+FuTScCp7EB4bLfrTADia5pOfDwsLNxN0pkWjLN_+CefYNTkg@mail.gmail.com>
 <CAKgT0UecD+EmPRyWEghf8M_qrv8JN4iojqv2eZc-VD_OZDzB-g@mail.gmail.com>
 <CA+FuTSdTjtgTZj6n9QtCEYWwip7M7kgKS=ybNOjiE3mzuCzsew@mail.gmail.com>
 <CAKgT0UeSpzLTkzDQh-zX9fcW9059NeKNbkJBJL1PD9ztdpSGVA@mail.gmail.com> <CA+FuTSfO6OWv1_gfdNub9UXfkpx=gjg0KBg7mibxj8nkpERc1g@mail.gmail.com>
In-Reply-To: <CA+FuTSfO6OWv1_gfdNub9UXfkpx=gjg0KBg7mibxj8nkpERc1g@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 5 Sep 2021 08:53:08 -0700
Message-ID: <CAKgT0UeH3aTnMKqzmtqfWrtmkW6cB=Mk6OSJi0FvmDEbmNAd+Q@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only if CHECKSUM_PARTIAL
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 5, 2021 at 8:24 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sat, Sep 4, 2021 at 7:47 PM Alexander Duyck
> <alexander.duyck@gmail.com> wrote:

<snip>

> > You can do it since you have essentially already written half the code.. :)
>
> Sent, but only the ipv4 patch.
>
> I actually do not see an equivalent skb_pull path in ip6_gre.c. Will
> take a closer look later, but don't have time for that now.
>
> https://patchwork.kernel.org/project/netdevbpf/patch/20210905152109.1805619-1-willemdebruijn.kernel@gmail.com/

So does that mean that commit 9cf448c200ba ("ip6_gre: add validation
for csum_start") is adding overhead that doesn't really address
anything, and is introducing false positives? If so, should we just
revert it?

Thanks,

- Alex
