Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA4E1410E9
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 19:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729308AbgAQSjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 13:39:08 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:36791 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726603AbgAQSjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 13:39:07 -0500
Received: by mail-ed1-f66.google.com with SMTP id j17so23184675edp.3
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 10:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XuozQrdC0twFFmLNitMzc4Oz67e2BhlDSA1V5fRGxqA=;
        b=M5CqFHUiMAVmh3aQEawzjOEmL7/Glz6QQYrQEYhD9/nIvyD1Yfv1vID5HKnLlYIORz
         3nnJwIdMWAn0m+xVLU60/VXs+1aHXXk603MlgXvkbkwO9CZYcnKpm+Cx1iyaxqZc33HF
         uB6DLYLgHWYjyHrnn4pFXXlNudpLQqxE8Bi4rSx3YYh1uCflu4iIwXl7UoAEQKL1wacE
         qam5h1c7hfDuYX6tpAtWScasviACMqWABKkvzh2aKifMC4Qb7N2EoIs5/2EYIovw1xcp
         VamtOh1X4uIvMGbDGfTrlsrgI6bx/bNpfoDWlVBrX7/LfCRvbOGOAam8KLBRsrtbVp5H
         uwdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XuozQrdC0twFFmLNitMzc4Oz67e2BhlDSA1V5fRGxqA=;
        b=lMl7mkWQFarlphC+Dr/q1U7KvtCDSNDdEDbFvooKjU7muPI0fzyMVHSwSHWgWJnykl
         nV39aI/5QgUUl0djBQK5vx2cpl/yRISHRLDFg1QRDhfHt9DNXnX+KWSB61kgbT+Qrzz3
         h1E2SekSt8umWAJQMJY8MLDL5kKxkzNtQC3RDEvCSQjyUQ2TK929okGevY8TaqmSNwHu
         3j2xw/Gy79M+jeIvJhmEy/38THfqRdEXsiCLNUOE3r9QYG3BLzy+PmfZ6T75qH8DDskv
         JYzIoPh6mA3h1RVeuE2wAhvVIUh5H3/BFqHn0CnpChZhi6uu7ZIgLU5n6taYEMwJoQVy
         1uhw==
X-Gm-Message-State: APjAAAWpHgOZs17SsVQt+RqGOmDDBRoYlxYu32ZFmSFBmUwCePlbOfjC
        LPbxmssTkcWkPnT8QrWXBPuh19J507lBwl/OywA=
X-Google-Smtp-Source: APXvYqywlH83tCWIMZo1O5BUaCgGoUVr+tMylApohFQqrXpj1NJuALtJfqYsC1/5ftVru2Z8v4VSAeC9R553wW3vh1E=
X-Received: by 2002:aa7:d4d2:: with SMTP id t18mr5199568edr.223.1579286345840;
 Fri, 17 Jan 2020 10:39:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579281705.git.pabeni@redhat.com> <749f8a12b2caf634249e7590597f0c53e5b37c7a.1579281705.git.pabeni@redhat.com>
 <e1417ad9-8c2f-7640-4bed-96aa753f28f3@gmail.com>
In-Reply-To: <e1417ad9-8c2f-7640-4bed-96aa753f28f3@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 17 Jan 2020 13:38:27 -0500
Message-ID: <CAF=yD-LzGrTzkeaZgDRTTFtx1Kh4ZLQ99w4xCLdxyHW9DXi4Bw@mail.gmail.com>
Subject: Re: [PATCH net 3/3] udp: avoid bulk memory scheduling on memory pressure.
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 12:51 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 1/17/20 9:27 AM, Paolo Abeni wrote:
> > Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
> > free even if the rx sk queue is empty") the memory allocated by
> > an almost idle system with many UDP sockets can grow a lot.
> >
> > This change addresses the issue enabling memory pressure tracking
> > for UDP and flushing the fwd allocated memory on dequeue if the
> > UDP protocol is under memory pressure.
> >
> > Note that with this patch applied, the system allocates more
> > liberally memory for UDP sockets while the total memory usage is
> > below udp_mem[1], while the vanilla kernel would allow at most a
> > single page per socket when UDP memory usage goes above udp_mem[0]
> > - see __sk_mem_raise_allocated().
> >
> > Reported-and-diagnosed-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> > Fixes: commit 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")

Thanks a lot for the quick follow-up, Paolo!

> Not a proper Fixes: tag

And to give credit where it's due: Eric diagnosed the issue.

> Frankly I would rather revert this patch, unless you show how much things were improved.

In response to your question in the cover letter, I also think that
for net the three-line revert patch is more obviously correct.

Memory pressure might be helpful in net-next with some iteration, of course.

> Where in the UDP code the forward allocations will be released while udp_memory_pressure
> is hit ?
>
> TCP has many calls to sk_mem_reclaim() and sk_mem_reclaim_partial() to try
> to gracefully exit memory pressure.
>
