Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A10284AF1
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726060AbgJFLax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgJFLax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:30:53 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5025C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 04:30:52 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id h2so556039vso.10
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 04:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2av8CIeJ1tjw+CJ315Srm02NP2c8fTtKuMf2KV4sEek=;
        b=B4pkG+HOwHikbZlypMnpD05EWj8JVCmUwW/CxET9qptgsl6y6pS9CDTOj01KxVM1Bz
         LORmecRPYD11YDACooSnykS01QR+T3pCwSlRMFbFmS0AWRrM7rRHP/nW5NqI8cJGWTxs
         jovkUb/piqyO/i8EobDFd6z0BPeY92ve+2pFod8zd9uXZsqKQr/+0RCA5F8/ABmKTmTh
         /E9vQcv83lWkYmNIIKaJUrSzWY+FF1Y5SpS2ZxHOFYk94YaPweA0gM40P7pa+unu3M+0
         jmc8eSwMp2qJXQBkHcc19njxvmPDaMOP+YgRVVZLlJBVl/eDtukjXKSQXomihca9KLOs
         u/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2av8CIeJ1tjw+CJ315Srm02NP2c8fTtKuMf2KV4sEek=;
        b=BtmKiUdVCN/NuK85szy8a6Og6+NNyRwBVDiapBPmbobVki/XopiGT8JIScmb8FS04u
         QScKShj3OWzpwMV/BJRbT1X3eRj7nj6TtjdPmmUOE0DzsRXAgA8lNfnsUFvQBS56Cfsi
         mqFOB16c69r4t4lSNjIY80fgZgpJzvVSa5xozH11jJgloaKG5gOgntjzq5khKqtG7CXD
         wQy070Wa8IshftDKpiRkCODOcX+XgR74/QIDgChoT6CkeE+XE6BZhm+g00lNiq8jubGj
         rHLVZ5FCJmw7sVjuy5ZwkDnzPXMpNqKK+pvMxq2NsSu6Qa0MT9dfwzYods8CLgBjZ1is
         d6AA==
X-Gm-Message-State: AOAM530k6zVry0fscgdVis1W95R2qPOi6V+sl0W1/3jLzLvPS6S6HPJ5
        99vF/0to5UAnleTcREVSWRjiYqOrk50=
X-Google-Smtp-Source: ABdhPJweNaM8Gw1EI3JOPD99xfgjr2uPzRyGZqXfRTHU1/VCmQCNYyBzYz50hESdUx3w6lHyq2HrEg==
X-Received: by 2002:a67:fd7a:: with SMTP id h26mr2644167vsa.27.1601983851239;
        Tue, 06 Oct 2020 04:30:51 -0700 (PDT)
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com. [209.85.217.49])
        by smtp.gmail.com with ESMTPSA id w201sm424307vke.47.2020.10.06.04.30.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 04:30:50 -0700 (PDT)
Received: by mail-vs1-f49.google.com with SMTP id a16so5887639vsp.12
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 04:30:49 -0700 (PDT)
X-Received: by 2002:a67:fb96:: with SMTP id n22mr1817038vsr.13.1601983848871;
 Tue, 06 Oct 2020 04:30:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201005144838.851988-1-vladimir.oltean@nxp.com> <bcf0a19d-a8c9-a9a2-7bcf-a97205aa4d05@intel.com>
In-Reply-To: <bcf0a19d-a8c9-a9a2-7bcf-a97205aa4d05@intel.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 6 Oct 2020 07:30:13 -0400
X-Gmail-Original-Message-ID: <CA+FuTScXC+t_sETOTCvjrALCmq3y4mrcX8CxyFBcLyJk3XH4Rg@mail.gmail.com>
Message-ID: <CA+FuTScXC+t_sETOTCvjrALCmq3y4mrcX8CxyFBcLyJk3XH4Rg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: always dump full packets with skb_dump
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 5, 2020 at 8:25 PM Jacob Keller <jacob.e.keller@intel.com> wrote:
>
>
>
> On 10/5/2020 7:48 AM, Vladimir Oltean wrote:
> > Currently skb_dump has a restriction to only dump full packet for the
> > first 5 socket buffers, then only headers will be printed. Remove this
> > arbitrary and confusing restriction, which is only documented vaguely
> > ("up to") in the comments above the prototype.
> >
>
> So, this limitation appeared very clearly in the original commit,
> 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")..
>
> Searching the netdev list, that patch links back to this one as the
> original idea:
>
> https://patchwork.ozlabs.org/project/netdev/patch/20181121021309.6595-2-xiyou.wangcong@gmail.com/
>
> I can't find any further justification on that limit. I suppose the
> primary reasoning being if you somehow call this function in a loop this
> would avoid dumping the entire packet over and over?

Not in a loop per se, but indeed to avoid unbounded writing to the kernel log.

skb_dump is called from skb_warn_bad_offload and netdev_rx_csum_fault.
Previously when these were triggered, a few example bad packets were
sufficient to debug the issue.

A full dump can add a lot of data to the kernel log, so I limited to
what is strictly needed.
