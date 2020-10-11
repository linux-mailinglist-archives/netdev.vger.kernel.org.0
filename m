Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6980328AA98
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 23:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgJKVHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 17:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387398AbgJKVHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 17:07:06 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BAEC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:07:06 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id a8so1949796vkm.2
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=unLtx3U31PmPL9EcC2G/nCnL4SquZXjbFdTnalX6AD8=;
        b=m6ECP9lLetHMqv1Gjb0tvz89uJJyyjru/VDl5CE3XvZaHQYBOXZez8VbM+vP/C7jNj
         bNL3JpP0re02eTFbgvjHw6tu+EuKp6+VDORcvuOD1qLMGJtK7lSJCnpamL6QRotElS4M
         h7nPsR4UzjKuV3tZldKxv5TZckMSIclbd71Qo/lvu4Mo/eiE3GNXfpvRiumEmA0Yi53q
         Kv6y04e4k9C80eN7w/w/AQwkoOS5B2hHhlYnCNzX8ljQZOl05u/jrl/dndz9mC0k3IgQ
         BwYyVGIqhq4WWOaQQgfzFOvESf9DVHHuxDLC9TJvoQdnfQAZ+y9va235k1vq355tPZOg
         aLxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=unLtx3U31PmPL9EcC2G/nCnL4SquZXjbFdTnalX6AD8=;
        b=nX/IqB/6tu0biTs2HdbOMIgJUDYUBM1IiwPrLwD+MuezoJrrbS01UKIFF+bkAAhVmN
         N487U/QwrnRZ16vyMqGHA/RQrTPecv5CSDC5fY770Aa25cLfWRPdu9xMB8PrT2lHERcQ
         AW77FcPz3WpkoDmS7GQasTWNegYli2FHuUvmW2wGWM2eiysiLY7/iOiyqI4Tq9HXgcGB
         mznUfUDgB5P74RFqk1qdmmrlA5SAublICu9iKTwF5QgF/1ESiCyxtG0H/Yz/sOVYjsUO
         ZxGtiFU51ez/KG79feVMD7wSVZOtfrsVk4bC2suW/NUsJ3UoAN6pSWxeZj/3wKkLgDLJ
         HBGw==
X-Gm-Message-State: AOAM533eWB1JaRwgdfSG0fiL6LrkZVI811Rt92OacBBV9hjC/rCoGpoT
        AZfAdKd1DYXe/aISy850WrVeVbc71l8=
X-Google-Smtp-Source: ABdhPJz6dwlU9JzBTl7iq0k64n44GLZprjH9DzZee+I6QxUkJlmWLjJnBcO5Bexp9bLHhvK5v4CU+A==
X-Received: by 2002:a1f:9381:: with SMTP id v123mr11515674vkd.20.1602450425239;
        Sun, 11 Oct 2020 14:07:05 -0700 (PDT)
Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com. [209.85.222.53])
        by smtp.gmail.com with ESMTPSA id u139sm1906454vsc.34.2020.10.11.14.07.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Oct 2020 14:07:04 -0700 (PDT)
Received: by mail-ua1-f53.google.com with SMTP id c7so4851613uaq.4
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 14:07:04 -0700 (PDT)
X-Received: by 2002:ab0:c11:: with SMTP id a17mr11771850uak.141.1602450423611;
 Sun, 11 Oct 2020 14:07:03 -0700 (PDT)
MIME-Version: 1.0
References: <20201011191129.991-1-xiyou.wangcong@gmail.com> <CAJht_EP5LWUadxwMpdsRAhUrjaUHpi-1QO5N28r7Sqtp4Qxjpw@mail.gmail.com>
In-Reply-To: <CAJht_EP5LWUadxwMpdsRAhUrjaUHpi-1QO5N28r7Sqtp4Qxjpw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 11 Oct 2020 17:06:27 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe7QxHUJfyh3Wr3nb+dG=mrE5MCETCdSiVu9ZCXnFqAag@mail.gmail.com>
Message-ID: <CA+FuTSe7QxHUJfyh3Wr3nb+dG=mrE5MCETCdSiVu9ZCXnFqAag@mail.gmail.com>
Subject: Re: [Patch net v2] ip_gre: set dev->hard_header_len and
 dev->needed_headroom properly
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+4a2c52677a8a1aa283cb@syzkaller.appspotmail.com>,
        William Tu <u9012063@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 4:42 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sun, Oct 11, 2020 at 12:11 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > GRE tunnel has its own header_ops, ipgre_header_ops, and sets it
> > conditionally. When it is set, it assumes the outer IP header is
> > already created before ipgre_xmit().
> >
> > This is not true when we send packets through a raw packet socket,
> > where L2 headers are supposed to be constructed by user. Packet
> > socket calls dev_validate_header() to validate the header. But
> > GRE tunnel does not set dev->hard_header_len, so that check can
> > be simply bypassed, therefore uninit memory could be passed down
> > to ipgre_xmit(). Similar for dev->needed_headroom.
> >
> > dev->hard_header_len is supposed to be the length of the header
> > created by dev->header_ops->create(), so it should be used whenever
> > header_ops is set, and dev->needed_headroom should be used when it
> > is not set.
>
> Hi, thanks for attempting to fix this tunnel. Are we still considering
> removing header_ops->create?
>
> As said in my email sent previously today, I want to remove
> header_ops->create because 1) this keeps the un-exposed headers of GRE
> devices consistent with those of GRETAP devices, and 2) I think the
> GRE header (and the headers before the GRE header) is not actually the
> L2 header of the tunnel (the Wikipedia page for "Generic Routing
> Encapsulation" doesn't consider this protocol to be at L2 either).
>
> I'm not sure if you still agree to remove header_ops->create. Do you
> still agree but think it'd be better to do that in a separate patch?
>
> Removing header_ops->create would simplify the fixing of the issue you
> are trying to fix, too, because that way we would no longer need to
> use header_ops or hard_header_len. Also, I'm worried that changing
> hard_header_len (or needed_headroom) in ipgre_link_update would have
> racing issues. If we remove header_ops, we no longer need to use
> hard_header_len and we can just set needed_headroom to the maximum
> value, so that we no longer need to update them in ipgre_link_update.

Our messages crossed.

It seems there are legacy expectations that sendto/recvfrom packet
sockets allow writing/reading the outer IP address, as of commit
6a5f44d7a048 ("[IPV4] ip_gre: sendto/recvfrom NBMA address"). That is
the express purpose of that commit.

The behavior is inconsistent with other tunnels, as you also point
out, and probably only rarely used if at all. I would love to get rid
of it, but given that we cannot be certain that it is unused, I'm afraid
that we have to continue to support this special case.
