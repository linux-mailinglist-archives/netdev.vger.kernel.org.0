Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD51A2F8161
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 18:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbhAORAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 12:00:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbhAORAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 12:00:07 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9570AC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:59:27 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id d9so19394604iob.6
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 08:59:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=drJhHQp9ew4z88/zJ2LRH3Yh0LyJONVammWXyNPyGYY=;
        b=nKBfrNg43FS4hAJsO+kHl46rNUQEajP8plLOu2vZDIbPls8Zk+vSTU90+PZsrEeWKF
         1G+YX0zuShkryDvwO6YjT0/1QDS1URuUP+yGa+NXqQXGfUvoAdl2DjYYmLlDFBKt5+Bo
         d7MN4oeqjailVnqXjSvMw5qLXGJpfdEnLSyX8mnRu9Q2qaKm+mZ+d1e8I5FfsGikielc
         CEirP8Qz50fQSZ0W3dqmhtsTgO1UUGp/y+Yw37MBVxHLyd/PLwn8GuvVRO/nr4hYxE2j
         shRcD09SLbYoYd+XluGADCjM7bFnoeo3Qq21Cbv80Ug9X+P4kwQpViyCxG/9g0u8ZaYh
         5/CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=drJhHQp9ew4z88/zJ2LRH3Yh0LyJONVammWXyNPyGYY=;
        b=dfr9v/93jq2aUP+KswcmwsThRKqjzKuwc6hqGpeaEhT950A/mV/jIq7KDqOOYLxMxd
         WS5WVnKxVO5TlnRxB5WcRBN6h7X20vONbTYmUz3XO9plU8/z2nswUx8xvoGZ5lnCeomr
         40ro36jYLpFpdBqSsKNdExzQXnnp+o549JskF97LFxVVMpoPbrGgWbcOkzqxBDcyIpQl
         A4ykOE8Jr5htD7WgLiyhKKYu/i2kHA8eokyT1W3KwBbxjbxcQ36h/uxlQW/y1sGJt0X/
         dQy7EHQMgyqlpJsigRUmzZ4nq4UP1qQmQARIYaHkkQW/eqrua6tf1FwWoQL5qQvkyo0r
         sZjA==
X-Gm-Message-State: AOAM532pQZz8B0g4rL9Dyakqwo93V2h6Fwxe2Mvf4Ht2rWyIb1EICxKK
        RTVT9Dv5S7P7DNf3ODPx7RFGIkJbyvq3DjABlgk=
X-Google-Smtp-Source: ABdhPJwO/n5JCR1+Jvy/mZL4Kb9F/DslsoVk6aOEwRYdT02sNe42EAiF7ENDAA5dcmbcGWpamCY6Fbs5W3FnZKX7VQk=
X-Received: by 2002:a05:6e02:68b:: with SMTP id o11mr11660267ils.237.1610729966884;
 Fri, 15 Jan 2021 08:59:26 -0800 (PST)
MIME-Version: 1.0
References: <20210106175327.5606-1-rohitm@chelsio.com> <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com> <CAKgT0UcbYhpngJ5qtXvDGK+nqCgUqa9m3CHBT0=ZeFxCvRJSxQ@mail.gmail.com>
 <113bea13-8f7e-af0c-50de-936112a1bc48@gmail.com> <42d6d5b5-adfb-a6b6-53af-b47e939dd694@chelsio.com>
In-Reply-To: <42d6d5b5-adfb-a6b6-53af-b47e939dd694@chelsio.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 15 Jan 2021 08:59:16 -0800
Message-ID: <CAKgT0UfKENJg6QtORLc-nQD+p9-s7c9_Fw2R5g3iPsmSZfT+jQ@mail.gmail.com>
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, secdev@chelsio.com,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, andriin@fb.com,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, ap420073@gmail.com,
        Jiri Pirko <jiri@mellanox.com>, borisp@nvidia.com,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 14, 2021 at 9:39 PM rohit maheshwari <rohitm@chelsio.com> wrote:
>
>
> On 13/01/21 10:37 PM, Tariq Toukan wrote:
> >
> >
> > On 1/13/2021 5:35 AM, Alexander Duyck wrote:
> >> On Tue, Jan 12, 2021 at 6:43 PM rohit maheshwari <rohitm@chelsio.com>
> >> wrote:
> >>>
> >>>
> >>> On 07/01/21 12:47 AM, Jakub Kicinski wrote:
> >>>> On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
> >>>>> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
> >>>>> And it broke tls offload feature for the drivers, which are still
> >>>>> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
> >>>>> NETIF_F_CSUM_MASK instead.
> >>>>>
> >>>>> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM
> >>>>> is disabled")
> >>>>> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> >>>> Please use Tariq's suggestion.
> >>> HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
> >>> support only IPv4 checksum offload, TLS offload should be allowed for
> >>> that too. So I think putting a check of CSUM_MASK is enough.
> >>
> >> The issue is that there is no good software fallback if the packet
> >> arrives at the NIC and it cannot handle the IPv6 TLS offload.
> >>
> >> The problem with the earlier patch you had is that it was just
> >> dropping frames if you couldn't handle the offload and "hoping" the
> >> other end would catch it. That isn't a good practice for any offload.
> >> If you have it enabled you have to have a software fallback and in
> >> this case it sounds like you don't have that.
> >>
> >> In order to do that you would have to alter the fast path to have to
> >> check if the device is capable per packet which is really an
> >> undesirable setup as it would add considerable overhead and is open to
> >> race conditions.
> >>
> >
> > +1
> >
> > Are there really such modern devices with missing IPv6 csum
> > capabilities, or it's just a missing SW implementation in the device
> > driver?
> >
> > IMO, it sounds reasonable for this modern TLS device offload to asks
> > for a basic requirement such as IPv6 csum offload capability, to save
> > the overhead.
> >
> I agree with you, all modern devices support V6 csum, but still if we think
> logically, we can't limit TLS offload to work only if both IPV4_CSUM  and
> IPV6_CSUM are configured/supported. If there is no dependency of IPV6
> in running TLS offload with IPv4  and vice-versa, then why should there
> be any restriction as such.

The requirement is to have a software fallback for any offload that
cannot be performed by the hardware if you are going to advertise it.
So if we were to disable IPv6 checksum offload and then request TLS
offload there isn't a software fallback for the combination since the
L4 header checksum cannot be performed on the packet if we are
expecting the hardware to handle the encryption. So in such a case the
TLS offload will need to occur before software can offload the header
checksum and so the hardware offload is disabled.

The basic idea is any offload combination should be functional so that
it doesn't mangle frames or cause the receiving end to drop packets.
