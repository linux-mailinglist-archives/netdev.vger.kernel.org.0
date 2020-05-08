Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0B7F1CAE54
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 15:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729511AbgEHNIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 09:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728556AbgEHNIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 09:08:51 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45362C05BD43;
        Fri,  8 May 2020 06:08:51 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id x17so1772640wrt.5;
        Fri, 08 May 2020 06:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fzVBitGbGs6c9vSFlRa8yyVPwH/mTWCu5Nt0AL3hOL8=;
        b=Qa61DywqFbLV0WLEZ8qPfW6fmbNb5o8K76MIqacgRZbUYASTn/yfK6gvzHhf6ZFgA2
         yVfH/u/GW6+JVKo08ceC+7gzZsxJtwzcJTE1kNZtP2xOh9UcQDnjvsypJJuuJ8cYWlJ/
         bF6UFZOM67NG/fOsIBU2u6tAgYc9VNAG1p58u7YA0KNsU/c626PSPE4D9RjZzt171OTZ
         LiNqs2JTLPX07p+s5/padAsUvkG+AYZJ7K1n+0wW6D+1n2m47ni1rlN+K3gTMPIq+cEV
         +PH9aXciDFdTazV99Y8fqp8Gs8IGYD0mXT3ngKt+tbc2oYM2+u5xNbLx3lTuRaw8dIsJ
         xGKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fzVBitGbGs6c9vSFlRa8yyVPwH/mTWCu5Nt0AL3hOL8=;
        b=HnPkoSg0IVDr9yUplHReUVPk+cMKfr+GtsdM24dwf0JhvoEoFB2EYoVBq3pxcA4Rq1
         dqPIWGsyNFYo2KhRVAQIq7HXOHQgymE300l2hTJu6xDqcU6s1G1lVjKMZi99pciddQlO
         H7pC2FbZiavec4KpMjAXoIrWOZElA2GCFM0aYRUsY7CFIev00cKrgM67xnn8BG7gK7ta
         Y60bCoeP+VCsKnUJ7QORLB3Qn+Y79DuwB+W6pj5BoBoNHtfOFtxNoEAZYksJLztQ2hJ3
         ZRc4AnL0ztAJ28kCbtJ7zNWfBpEPI3ID+7PKvMSgfbeqHAFDlnB5UmX/vqTWZd1OdgiC
         bUpg==
X-Gm-Message-State: AGi0Pub5a6t71m9YQrRFNiCKRZcDDfy+7K8Ggi34eydb4qK7F4M8xw3R
        x9aWGHvV46hH2V3WPLokvE+JXm+g9f6anLRXRoI=
X-Google-Smtp-Source: APiQypK5JWV/0lunuRXSm9bmWF8GTMrH8ZZtDEZCWSihlQms/jeatRDrLMdpIpchZGyScCDmrXjd8Js6R/z8ZjqMjjM=
X-Received: by 2002:adf:e910:: with SMTP id f16mr2812017wrm.176.1588943329981;
 Fri, 08 May 2020 06:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200507104252.544114-1-bjorn.topel@gmail.com>
 <20200507104252.544114-11-bjorn.topel@gmail.com> <40eb57c7-9c47-87dc-bda9-5a1729352c43@mellanox.com>
 <3c42954a-8bb3-85b1-8740-a096b0a76a98@intel.com> <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
In-Reply-To: <cf65cc80-f16a-5b76-5577-57c55e952a52@mellanox.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 8 May 2020 15:08:38 +0200
Message-ID: <CAJ+HfNiU8jyNMC1VMCgqGqz76Q8G1Pui09==TO8Qi73Y_2xViQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 10/14] mlx5, xsk: migrate to new MEM_TYPE_XSK_BUFF_POOL
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 at 15:01, Maxim Mikityanskiy <maximmi@mellanox.com> wrot=
e:
>
> On 2020-05-08 15:27, Bj=C3=B6rn T=C3=B6pel wrote:
> > On 2020-05-08 13:55, Maxim Mikityanskiy wrote:
> >> On 2020-05-07 13:42, Bj=C3=B6rn T=C3=B6pel wrote:
> >>> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>>
> >>> Use the new MEM_TYPE_XSK_BUFF_POOL API in lieu of MEM_TYPE_ZERO_COPY =
in
> >>> mlx5e. It allows to drop a lot of code from the driver (which is now
> >>> common in AF_XDP core and was related to XSK RX frame allocation, DMA
> >>> mapping, etc.) and slightly improve performance.
> >>>
> >>> rfc->v1: Put back the sanity check for XSK params, use XSK API to get
> >>>           the total headroom size. (Maxim)
> >>>
> >>> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >>> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> >>
> >> I did some functional and performance tests.
> >>
> >> Unfortunately, something is wrong with the traffic: I get zeros in
> >> XDP_TX, XDP_PASS and XSK instead of packet data. I set DEBUG_HEXDUMP
> >> in xdpsock, and it shows the packets of the correct length, but all
> >> bytes are 0 after these patches. It might be wrong xdp_buff pointers,
> >> however, I still have to investigate it. Bj=C3=B6rn, does it also affe=
ct
> >> Intel drivers, or is it Mellanox-specific?
> >>
> >
> > Are you getting zeros for TX, PASS *and* in xdpsock (REDIRECT:ed
> > packets), or just TX and PASS?
>
> Yes, in all modes: XDP_TX, XDP_PASS and XDP_REDIRECT to XSK (xdpsock).
>
> > No, I get correct packet data for AF_XDP zero-copy XDP_REDIRECT,
> > XDP_PASS, and XDP_TX for Intel.
>
> Hmm, weird - with the new API I expected the same behavior on all
> drivers. Thanks for the information, I'll know that I need to look in
> mlx5 code to find the issue.
>

All zeros hints that you're probably putting in the wrong DMA address somew=
here.

> >> For performance, I got +1.0..+1.2 Mpps on RX. TX performance got
> >> better after Bj=C3=B6rn inlined the relevant UMEM functions, however, =
there
> >> is still a slight decrease compared to the old code. I'll try to find
> >> the possible reason, but the good thing is that it's not significant
> >> anymore.
> >>
> >
> > Ok, so for Rx mlx5 it's the same as for i40e. Good! :-)
> >
> > How much decrease on Tx?
>
> ~0.8 Mpps (was 3.1 before you inlined the functions).
>

Thanks. Still a bit much. What does perf say?


Bj=C3=B6rn
