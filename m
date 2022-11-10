Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3CA623F94
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiKJKOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 05:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiKJKOS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 05:14:18 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F7864A2D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:14:17 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id h24so650550qta.9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MROv+ToXh8ryiyR2Mcd72J2oB24qvva8HoOx65uEfnw=;
        b=JHKz0UX3sNsW9dh+Y6UMohkj8x7TLewUFGw+aCEZs8KbhGciz8bHucdInbV9AVhAue
         IuJ16GHfz8vFwgTAv3c0LWh/rhHfoG+8DVPHhLOiMYKAs5j2cm/OvFFQBAtw+aUHv1oe
         ykvxuIwZfY1Jy35F6uQai2CUkYfPxW30crjuSTw57uWnEA35nzJD9IyxZ52U6me5vFlF
         /oami+J6UiP0CkbneAVaj6p4gzNmEYBkvK89ldTgolmdms9w9lEHSlOsDHFwzLhigp21
         PmYUNKf+yP4lPbvRdpHpgERUZSy8ESkXAMnFDMkwjXVzhJcrhcHAyGZrrhWd2KVA4NIq
         Ra7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MROv+ToXh8ryiyR2Mcd72J2oB24qvva8HoOx65uEfnw=;
        b=DyycziphkLj04CN2G1Aq6zxWm9458sVUprg9jIIYjzYt1r7ipDIvatsBBqgPbk/e/G
         i+LEzgGzn/ZF6/NAooDak9YaBGWyRiWNLg+5iktsf7XZ06EjhPytJ6skWehLittFpMfo
         1A21DlYB4Nsn86i0fnK1XlIP8yDZvyYffwuToqegtsC+3nLV4jw8leOVlEbrayEWLjS+
         alt8CfIxLE5S5y3O3q+1e/9xrFim2SYq1SwkQ31EQ94kMMppyF4QH+KQ9wIDAe9Uq3vx
         343IGA1Utf81L8BQve1oseHS0O9Y6WIGRyLwRfzW2zGVfOSwAZdLr3GIEKqoS1IqfA65
         rLvw==
X-Gm-Message-State: ACrzQf3iryHNFG/912yFBWL3M9DF3cgMuwQIIpAtyIsGTjJD1sxZC6wc
        PH8fgWy5yeWH2h6S//FmTro6UUMLMMO4+g==
X-Google-Smtp-Source: AMsMyM7xX6XV4/NJUC7wYNikzEQ9UwfGdQ0667BN5k3qvTB5qyPlnKLjD4sVrpjGaSdHR/ig76FakA==
X-Received: by 2002:ac8:5f82:0:b0:39c:dd06:ff45 with SMTP id j2-20020ac85f82000000b0039cdd06ff45mr51062498qta.93.1668075256726;
        Thu, 10 Nov 2022 02:14:16 -0800 (PST)
Received: from mail-yb1-f171.google.com (mail-yb1-f171.google.com. [209.85.219.171])
        by smtp.gmail.com with ESMTPSA id 69-20020a370c48000000b006eea4b5abcesm12295952qkm.89.2022.11.10.02.14.16
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 02:14:16 -0800 (PST)
Received: by mail-yb1-f171.google.com with SMTP id s18so1746049ybe.10
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 02:14:16 -0800 (PST)
X-Received: by 2002:a05:6902:1001:b0:6be:820d:a0de with SMTP id
 w1-20020a056902100100b006be820da0demr63814060ybt.240.1668075255736; Thu, 10
 Nov 2022 02:14:15 -0800 (PST)
MIME-Version: 1.0
References: <Y2lw4Qc1uI+Ep+2C@fedora> <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk>
 <Y2phEZKYuSmPL5B5@fedora> <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
In-Reply-To: <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 10 Nov 2022 11:13:38 +0100
X-Gmail-Original-Message-ID: <CA+FuTSe=09sAafHnLLMdc0EJrcP0+xcKCqD+rfMtdfQdSQYBDw@mail.gmail.com>
Message-ID: <CA+FuTSe=09sAafHnLLMdc0EJrcP0+xcKCqD+rfMtdfQdSQYBDw@mail.gmail.com>
Subject: Re: [PATCHSET v3 0/5] Add support for epoll min_wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 8, 2022 at 3:09 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 11/8/22 7:00 AM, Stefan Hajnoczi wrote:
> > On Mon, Nov 07, 2022 at 02:38:52PM -0700, Jens Axboe wrote:
> >> On 11/7/22 1:56 PM, Stefan Hajnoczi wrote:
> >>> Hi Jens,
> >>> NICs and storage controllers have interrupt mitigation/coalescing
> >>> mechanisms that are similar.
> >>
> >> Yep
> >>
> >>> NVMe has an Aggregation Time (timeout) and an Aggregation Threshold
> >>> (counter) value. When a completion occurs, the device waits until the
> >>> timeout or until the completion counter value is reached.
> >>>
> >>> If I've read the code correctly, min_wait is computed at the beginning
> >>> of epoll_wait(2). NVMe's Aggregation Time is computed from the first
> >>> completion.
> >>>
> >>> It makes me wonder which approach is more useful for applications. With
> >>> the Aggregation Time approach applications can control how much extra
> >>> latency is added. What do you think about that approach?
> >>
> >> We only tested the current approach, which is time noted from entry, not
> >> from when the first event arrives. I suspect the nvme approach is better
> >> suited to the hw side, the epoll timeout helps ensure that we batch
> >> within xx usec rather than xx usec + whatever the delay until the first
> >> one arrives. Which is why it's handled that way currently. That gives
> >> you a fixed batch latency.
> >
> > min_wait is fine when the goal is just maximizing throughput without any
> > latency targets.
>
> That's not true at all, I think you're in different time scales than
> this would be used for.
>
> > The min_wait approach makes it hard to set a useful upper bound on
> > latency because unlucky requests that complete early experience much
> > more latency than requests that complete later.
>
> As mentioned in the cover letter or the main patch, this is most useful
> for the medium load kind of scenarios. For high load, the min_wait time
> ends up not mattering because you will hit maxevents first anyway. For
> the testing that we did, the target was 2-300 usec, and 200 usec was
> used for the actual test. Depending on what the kind of traffic the
> server is serving, that's usually not much of a concern. From your
> reply, I'm guessing you're thinking of much higher min_wait numbers. I
> don't think those would make sense. If your rate of arrival is low
> enough that min_wait needs to be high to make a difference, then the
> load is low enough anyway that it doesn't matter. Hence I'd argue that
> it is indeed NOT hard to set a useful upper bound on latency, because
> that is very much what min_wait is.
>
> I'm happy to argue merits of one approach over another, but keep in mind
> that this particular approach was not pulled out of thin air AND it has
> actually been tested and verified successfully on a production workload.
> This isn't a hypothetical benchmark kind of setup.

Following up on the interrupt mitigation analogy. This also reminds
somewhat of SO_RCVLOWAT. That sets a lower bound on received data
before waking up a single thread.

Would it be more useful to define a minevents event count, rather than
a minwait timeout? That might give the same amount of preferred batch
size, without adding latency when unnecessary, or having to infer a
reasonable bound from expected event rate. Bounded still by the max
timeout.
