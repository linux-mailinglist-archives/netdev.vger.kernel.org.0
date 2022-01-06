Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3C2485F9F
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 05:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbiAFEUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 23:20:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232566AbiAFEUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 23:20:18 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF17C061201
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 20:20:18 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id k69so3992726ybf.1
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 20:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GsGW9DNhuNH7p1O6NbP2cuAbbWSM892ZOKia8JCPAi8=;
        b=lzpi7Ju74QWO7pv+/u1i3BlgRd+Kn7CiOpCzX92ZpVYszKhJTBWgXNibg0U78zMjGT
         wCFoPGQ449w1EouFhgNb+Afjn2hq16mWdUsbwF3sW+9UJWyhlfkvayuoYAhSMP8fSU/8
         wTQN7RqyNB52H88cee6C1Dk1srhlSrWcGXlqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GsGW9DNhuNH7p1O6NbP2cuAbbWSM892ZOKia8JCPAi8=;
        b=pobCQhiRtleKhinqyNXoBKCISX0z388TZEOdWPxCc/PO/O1y5uX/uV90ARfw9vlasV
         kJRlaAMEFGpkSe6H6vxbozNTiw8LtPovsw1++edKO9QHUYtBHenAlQQ0U29mHOD0fPCe
         QkqZHUj5u5tNtSn7Iq96cJZWxmKUjSqkd48L7IcR7NtNoOHc13CuphN1P0JrbOOMcrOY
         Vu7tIQYxvr1UCC/i6YP+doRzP4kimNYTXNkrbHMvLFHo3hvLxMwPFVMzASb6U3cAJ1sP
         ObkgZLJuH/ckChke6tF45FdTT6YJyB8VT9AMalAJwLSMZWVFQ5an+FsBkL9TjPAcgUEL
         phgg==
X-Gm-Message-State: AOAM531V+COE/OMbyjDSEW85BgjCMc4sW7IECCCOj6VkDEOY2LcDpsTr
        Uxb4mtmVsYAx+trS+MMeYTs9ms9MXyX4+P/Rj/wM2Q==
X-Google-Smtp-Source: ABdhPJz1JjVsZk6MYEBez9UAq5bXpvg3c6tBynFT3QBqv7f/JrewkZqfyidl4N7dTj4EnydJIA7hqgWrwy7h+eopH2c=
X-Received: by 2002:a25:3b10:: with SMTP id i16mr54228168yba.292.1641442817468;
 Wed, 05 Jan 2022 20:20:17 -0800 (PST)
MIME-Version: 1.0
References: <20220104003722.73982-1-ivan@cloudflare.com> <20220103164443.53b7b8d5@hermes.local>
 <CANn89i+bLN4=mHxQoWg88_MTaFRkn9FAeCy9dn3b9W+x=jowRQ@mail.gmail.com>
In-Reply-To: <CANn89i+bLN4=mHxQoWg88_MTaFRkn9FAeCy9dn3b9W+x=jowRQ@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 5 Jan 2022 20:20:06 -0800
Message-ID: <CABWYdi2oapjDMSJb+8T7BXMM6h+ftCQCSpPPePXaS3MyS4hD+w@mail.gmail.com>
Subject: Re: [PATCH net] tcp: note that tcp_rmem[1] has a limited range
To:     Eric Dumazet <edumazet@google.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 4, 2022 at 12:33 AM Eric Dumazet <edumazet@google.com> wrote:
> I guess you have to define what is the initial window.

What I mean here is the first window after scaling is allowed, so the
one that appears in the first non-SYN ACK.

> There seems to be a confusion between rcv_ssthresh and sk_rcvbuf
>
> If you want to document what is rcv_ssthresh and how it relates to sk_rcvbuf,
> you probably need more than few lines in Documentation/networking/ip-sysctl.rst

I can't say I fully understand how buffer sizes grow and how
rcv_ssthresh and sk_rcvbuf interact to document this properly.

All I want is to document the fact that no matter what you punch into
sysctls, you'll end up with an initial scaled window (defined above)
that's no higher than 64k. Let me know if this is incorrect and if
there's a way we can put this into words without going into too much
detail.

> Please do not. We set this sysctl to 0.5 MB
> DRS is known to have quantization artifacts.

Where can I read more about the quantization artifacts you mentioned?
