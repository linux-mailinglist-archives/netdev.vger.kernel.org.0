Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53571284B36
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 13:58:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726232AbgJFL6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 07:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726105AbgJFL6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 07:58:30 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F903C061755
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 04:58:29 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id h74so1620418vkh.6
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 04:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pz8AeeVxKpZa4XGo5SKtXcEDCfIi6kkgPZ59A1EdUnY=;
        b=A9Ugw8qixRyVlD5gu9wzq4blnlsNIlxTyDImdUZLrPtYxtkNRSsNQ0Qkxtkgtcb8d+
         bAIWJ1WWpAPEKK2C2AEvJELRubDVRFWm8l3fcL2Ngl5l0pt6MC6hQ0ION+IY7vinlS3i
         ++3ZQN2IvhjL8Ns+dBkNtSXY2fS4BTbObltiQrvrnNrC31KC3rRVukbeAy0hbAQEK898
         6nshqgh87rOIusnna7GmZJmui8PzUTSmcpZwNkUJcrtRUMJ5bGEG6A9N/mGqj0EudqL1
         IK3nq/MFLB/ROYb2Lmqw3sSqGYX+eehO/7kV1VUESdnHmZSWAIokuBQ/rEZ4pnl+qGdl
         2zCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pz8AeeVxKpZa4XGo5SKtXcEDCfIi6kkgPZ59A1EdUnY=;
        b=Bx7Aj0QjxnNnrHA++Q9TaNLxkGEQCaASA/Lia4ubwDur8uVj0hdt4aqnTVmTEDegCB
         y3YdDDbkuqRl/SSpPBRLSI7KBfoxj6XW8T4LROfajlBZVRAX2p8zKBsdLzgTY7eMoiEs
         DfJWR5VkqMsEB/e7MQSW1jAuL5M8XSVBlKpA2tx4kfYzfy6/LRsTtC3w7Y1CHbNkd8BJ
         rlI3urc4Tu1m+vGgZ9NhotfUCb41tgez715rlMfbEzaUVmsE3Wxl7wmPBeD/v8SPr7F9
         WJu+aTTYY/IiYGdgQkZtuy7kSknZ6r7RUqiErphYK7ZAyCMrlJhkRZz1aP1TGbrNl13T
         amLw==
X-Gm-Message-State: AOAM532rIsrA5jzHoutLMAKZMnmu0UPWfytiqMqxleAsP7c4CzCOT5on
        JiiDJhzFTMlCWPW2xIpPKGitM6O4sTk=
X-Google-Smtp-Source: ABdhPJzjjWxuVQqj5NqE2NI3swjPo1qjJT+KKYBnkJ/4H8F10gCuwC03bB1QB1ls/lncNohSjS/iwg==
X-Received: by 2002:a1f:2508:: with SMTP id l8mr2231528vkl.20.1601985508175;
        Tue, 06 Oct 2020 04:58:28 -0700 (PDT)
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com. [209.85.217.43])
        by smtp.gmail.com with ESMTPSA id o22sm368313vsr.12.2020.10.06.04.58.27
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Oct 2020 04:58:27 -0700 (PDT)
Received: by mail-vs1-f43.google.com with SMTP id 5so5940937vsu.5
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 04:58:27 -0700 (PDT)
X-Received: by 2002:a67:684e:: with SMTP id d75mr2793797vsc.28.1601985506872;
 Tue, 06 Oct 2020 04:58:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201005144838.851988-1-vladimir.oltean@nxp.com>
 <bcf0a19d-a8c9-a9a2-7bcf-a97205aa4d05@intel.com> <CA+FuTScXC+t_sETOTCvjrALCmq3y4mrcX8CxyFBcLyJk3XH4Rg@mail.gmail.com>
 <20201006114322.aq276lij2ovhdtts@skbuf>
In-Reply-To: <20201006114322.aq276lij2ovhdtts@skbuf>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 6 Oct 2020 07:57:51 -0400
X-Gmail-Original-Message-ID: <CA+FuTScxef=wytuNXgRuFFYMOZk_VzVSG9jvstuT2uAgK43v5Q@mail.gmail.com>
Message-ID: <CA+FuTScxef=wytuNXgRuFFYMOZk_VzVSG9jvstuT2uAgK43v5Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: always dump full packets with skb_dump
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 6, 2020 at 7:43 AM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Tue, Oct 06, 2020 at 07:30:13AM -0400, Willem de Bruijn wrote:
> > skb_dump is called from skb_warn_bad_offload and netdev_rx_csum_fault.
> > Previously when these were triggered, a few example bad packets were
> > sufficient to debug the issue.
>
> Yes, and it's only netdev_rx_csum_fault that matters, because
> skb_warn_bad_offload calls with full_pkt=false anyway.
>
> During the times when I had netdev_rx_csum_fault triggered, it was
> pretty bad anyway. I don't think that full_pkt getting unset after 5
> skbs made too big of a difference.
>
> > A full dump can add a lot of data to the kernel log, so I limited to
> > what is strictly needed.
>
> Yes, well my expectation is that other people are using skb_dump for
> debugging, even beyond those 2 callers in the mainline kernel. And when
> they want to dump with full_pkt=true, they really want to dump with
> full_pkt=true.

Sure, that makes sense.
