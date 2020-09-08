Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E551261102
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729478AbgIHLzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 07:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729912AbgIHLx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 07:53:28 -0400
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDB5C061797
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 04:53:21 -0700 (PDT)
Received: by mail-vk1-xa34.google.com with SMTP id c25so3996945vkm.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 04:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iNpJDo+gqE3n8OuKKqMvnJiyfSpkNKq1np+3FoTppfI=;
        b=NxWHKqeWMlPQoU/mbjiNrhFOjTvZGeHZpM+zLLMFWigZmV0OUhk7dj7b7dt2/8OQsr
         Lkc6tWXsbifJLb0/5FvBAVKRa/CXeyVCntFwzv8bXuK7VcObRc8gkPv1v7diuZch5Sen
         rmC4nMZGvN7D5kfdt+2DUH0JgjZNXqrU4R4dAYp6Ghew9RoBazonRUVcBYEmIIccBmWs
         W9uArxhsCYeG402YhgWQpZxyphNYnFQNDQ1JaO2wqAsvi/ON/OHdB3KqUBlP8r0S7Zaj
         e5xi7OmoWilMVecuDxGlUIRV8FJez+HD7t2D8VnuKXG1OpYq+tPGLhT2WpSlMLnA9rGZ
         Bb4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iNpJDo+gqE3n8OuKKqMvnJiyfSpkNKq1np+3FoTppfI=;
        b=KuY8LEKy/OE0AxmD4mTf9xpOXmr4w8gFGn22ptDkydDxfMFs9/Q3JBr1uKsUgSC/0q
         lmUx/7qlvzOBzZbU0aG7QA/qMPtj/uHoW9+ZzHRmxftG3hfenlVUrixFAMSyZnYtPG3j
         qAA3I3mUsa1z7i7BojaeG4wj12p3LhG58PMzO9NipjsroO8kqDynA0eEFHC+5dXIoPtc
         Pk0Pzfustlxk4gj3A0wpZoNr1Yc6cflCIACYuwsz4csHAixWMBLrBOBSp/eMckqEQ8Nq
         juIS5gsVXCyZw6SHhLjwluQNnmZ5y9lO2Od3p6LOFMPhJRu/pKwXwKrOVNOKOSUunrs8
         NTzg==
X-Gm-Message-State: AOAM532dz5zTmKG3w+S8LZeuyQeneemvnqf2LB8Oe5Z1nTDBfG+x7+Qf
        zfq1M/zKZEmH1fBBzjpocKM9zN4EzKCQiA==
X-Google-Smtp-Source: ABdhPJzMWznF04T0MrzB3YvcM5K4GfFenvFzik7pLM3/nsd0Yih8Xbhal7Ty53AWNL9GOJU7cRZuiA==
X-Received: by 2002:ac5:c297:: with SMTP id h23mr14140752vkk.38.1599565998537;
        Tue, 08 Sep 2020 04:53:18 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id k4sm947508vkk.12.2020.09.08.04.53.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 04:53:17 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id l1so4964901uai.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 04:53:17 -0700 (PDT)
X-Received: by 2002:a9f:2237:: with SMTP id 52mr12620777uad.141.1599565997147;
 Tue, 08 Sep 2020 04:53:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
 <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
 <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
 <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com> <CAJht_EN7SXAex-1W49eY7q5p2UqLYvXA8D6hptJGquXdJULLcA@mail.gmail.com>
In-Reply-To: <CAJht_EN7SXAex-1W49eY7q5p2UqLYvXA8D6hptJGquXdJULLcA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 13:52:38 +0200
X-Gmail-Original-Message-ID: <CA+FuTSfgxt6uqcxy=wnOXo8HxMJ3J0HAqQNiDJBLCs22Ukb_gQ@mail.gmail.com>
Message-ID: <CA+FuTSfgxt6uqcxy=wnOXo8HxMJ3J0HAqQNiDJBLCs22Ukb_gQ@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 1:04 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 1:41 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > The intent is to bypass such validation to be able to test device
> > drivers. Note that removing that may cause someone's test to start
> > failing.
> >
> > >  So there's no point in
> > > keeping the ability to test this, either.
> >
> > I don't disagree in principle, but do note the failing tests. Bar any
> > strong reasons for change, I'd leave as is.
>
> OK. I got what you mean. You don't want to make people's test cases fail.
>
> I was recently looking at some drivers, and I felt that if af_packet.c
> could help me filter out the invalid RAW frames, I didn't need to
> check the validity of the frames myself (in the driver when
> transmitting). But now I guess I still need to check that.
>
> I feel this makes the dev_validate_header's variable-length header
> check not very useful, because drivers need to do this check again
> (when transmitting) anyway.
>
> I was thinking, after I saw dev_validate_header, that we could
> eventually make it completely take over the responsibility for a
> driver to validate the header when transmitting RAW frames. But now it
> seems we would not be able to do this.

Agreed. As is, it is mainly useful to block users who are ns_capable,
but not capable.

A third option is to move it behind a sysctl (with static_branch). Your
point is valid that there really is no need for testing of drivers against
bad packets if the data is validated directly on kernel entry.
