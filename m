Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD82652633
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 19:28:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbiLTS2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 13:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLTS2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 13:28:01 -0500
Received: from mail-ua1-x936.google.com (mail-ua1-x936.google.com [IPv6:2607:f8b0:4864:20::936])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B2081DA59;
        Tue, 20 Dec 2022 10:28:00 -0800 (PST)
Received: by mail-ua1-x936.google.com with SMTP id z23so528543uae.7;
        Tue, 20 Dec 2022 10:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jIT6fF5gjfLCiNasKGkoBaNWOPI0QJSFqW2RO835jA4=;
        b=P6hHUtJo+wZUfhtWkXLr7H5eONR4z7bhH+Dd2Pu6drAyozwW4Rmg8/cKU8uE2blr6B
         LBqB/IA5soQBF/NJC9w1ZoA1WTNThXvPrSBXhGDO5adDpwfZTyNvBRcpxLR44EaKQAXr
         LMTe8WU4WxF9iwSS+ufRzydfXNyS1eqTqceEBQNsua9BdPYWt0iDRDpDuAVR6WqHtHk4
         HbBSpxSx7hz7S0VBS+iwOpnwzVKP48t2fYpiesyaxy9JLSIx9Y+JwQ1i+hwehk66oVlU
         bTFOivWkCoswK20RW4abWK/USW+wBBXiemserv92pOLn7FwgXN86lUPfCSqDOnYC81lC
         NZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jIT6fF5gjfLCiNasKGkoBaNWOPI0QJSFqW2RO835jA4=;
        b=ZOEQJMW6Q+H9u0IMJFlq/1WKMtCqgFcxKqeJX78iW3HRdgMJrYZizZgPrOtam3WCKE
         fBaj5+9NDs/UHXmP8p9UFe3rsKWC/x4oNl2rOTunzFzZ6dCc7V/7WPH5/FXLnbW2B+UW
         4m7vEcwQI5urxTTUdjDHFvgVn9uqjvH8NbhEAc4iTvzMQwYc4df7ORzNPcKHwQ5gqsTZ
         A/8uHr6V7CAL/vSsWec2SWdZPiLHD/eWUSzwcA7Y6igEqvhj0fr+3cxs30cg/lvjNNUw
         zEE4ykuFIYuNXvCXtZ7EcttOp22jIVeZJ7BsstowqoR0UyVbHgM5YLdNKfrHDYHshm2n
         d+6g==
X-Gm-Message-State: ANoB5pnjNdi9j66ozGzwtcsmFJEKHS9l/ERqvJgHH3NPi08oKSk8K2zt
        upQW5wHJ3sSJARidC2wvRg3KPh79yhQmKJAv/Sg=
X-Google-Smtp-Source: AA0mqf4cCuDAam2bj0nbK1acGmhmPmCV5Sx0C10cMjh7B1N9LbnOouKDGjfvDFI1xq5STO7LuL2meHifp9VbWAhqqPs=
X-Received: by 2002:ab0:3194:0:b0:418:f8f7:d9d7 with SMTP id
 d20-20020ab03194000000b00418f8f7d9d7mr41242563uan.116.1671560879538; Tue, 20
 Dec 2022 10:27:59 -0800 (PST)
MIME-Version: 1.0
References: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
In-Reply-To: <82b18028-7246-9af9-c992-528a0e77f6ba@linaro.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 20 Dec 2022 13:27:22 -0500
Message-ID: <CAF=yD-KEwVnH6PRyxbJZt4iGfKasadYwU_6_V+hHW2s+ZqFNcw@mail.gmail.com>
Subject: Re: kernel BUG in __skb_gso_segment
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, willemb@google.com,
        syzkaller@googlegroups.com, liuhangbin@gmail.com,
        linux-kernel@vger.kernel.org, joneslee@google.com
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

On Tue, Dec 20, 2022 at 8:21 AM Tudor Ambarus <tudor.ambarus@linaro.org> wrote:
>
> Hi,
>
> There's a bug [1] reported by syzkaller in linux-5.15.y that I'd like
> to squash. The commit in stable that introduces the bug is:
> b99c71f90978 net: skip virtio_net_hdr_set_proto if protocol already set
> The upstream commit for this is:
> 1ed1d592113959f00cc552c3b9f47ca2d157768f
>
> I discovered that in mainline this bug was squashed by the following
> commits:
> e9d3f80935b6 ("net/af_packet: make sure to pull mac header")
> dfed913e8b55 ("net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO")
>
> I'm seeking for some guidance on how to fix linux-5.15.y. From what I
> understand, the bug in stable is triggered because we end up with a
> header offset of 18, that eventually triggers the GSO crash in
> __skb_pull. If I revert the commit in culprit from linux-5.15.y, we'll
> end up with a header offset of 14, the bug is not hit and the packet is
> dropped at validate_xmit_skb() time. I'm wondering if reverting it is
> the right thing to do, as the commit is marked as a fix. Backporting the
> 2 commits from mainline is not an option as they introduce new support.
> Would such a patch be better than reverting the offending commit?

If both patches can be backported without conflicts, in this case I
think that is the preferred solution.

If the fix were obvious that would be an option. But the history for
this code indicates that it isn't. It has a history of fixes for edge
cases.

Backporting the two avoids a fork that would make backporting
additional fixes harder. The first of the two is technically not a
fix, but evidently together they are for this case. And the additional
logic and risk backported seems manageable.

Admittedly that is subjective. I can help take a closer look at a
custom fix if consensus is that is preferable.
