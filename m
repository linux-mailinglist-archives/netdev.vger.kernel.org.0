Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6FC30D295
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 05:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhBCEV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 23:21:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233100AbhBCEVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 23:21:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29A2FC061573
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 20:20:22 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id e15so4021738wme.0
        for <netdev@vger.kernel.org>; Tue, 02 Feb 2021 20:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Lru0U1e0n6/hG4GHWFdO6MhwdUm0H7Y7lZSCmPUAoQI=;
        b=LcK6LY48T0RFgjVFDMsAIZNtOQUGax7+YT/kzFHcRMO4EHD9XMy0DmfuvuGENz8VHe
         6r6DoVTTO2gQ1fCMI+YEy3TVETHwv2wEegD2TK11UwCJ+XPX8vo89XG5xdI4tQUuPUi0
         MhqO/CyQCO6V9NsIbKrDr1zqshtM3Xz353CaGzXdhEVUWzSDgQuoos28wSYwdUZPqTB7
         ENcNyVi/NfOAahVQE113MAS0zQvYVULSnnLX6wAJuZWWm5jug2NdBYkpIayrZ5Dl8DNh
         4wN5Nb9xP3lnHxfQIwuSpTCEoLU987SzcdLkIcxCJbsuR4XJTJ/tTnFtv/sbtNG4Rq5H
         UlWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Lru0U1e0n6/hG4GHWFdO6MhwdUm0H7Y7lZSCmPUAoQI=;
        b=RQkjq3w6+didrxnCgNT0zP2qj/z9mhpNMakdLaeuBcSaUaXPUESpizjNOqzyojjrJf
         DAsQ+rMGl6xgNIWl3OJ2xZ1PblB4D5YNZFhiihijfhxGZ8blvLv6ss93nHY+SXpN55Mk
         aTCxTji+pjsdXLWphe2NtDOPEqYkA/NIRuMSHVLiE3W1N3BsCQWCJ5J7PetaErpeLFId
         56/hlYd1KQ+LDylqD+goZ4hA5D0gqwtvvcfPm4NwQlhD6HQTdzonsgNW6MNEMCQY1ZEV
         REMaBDFeIZCrPDWE7xbWFh2pkfLnRUh0QrlQx41ZeTbmij20CIMvk+iYc2j0xd3FuJYJ
         cdrA==
X-Gm-Message-State: AOAM531BV/zTb7PoW+wAozEarugx9xDVIfKmFQQYkGus/kn7CZ8vnR5A
        kmRvYVvkBAuMTLBImXYtEOKBtqeb5mLrx/ldLxe6fVdBSW0=
X-Google-Smtp-Source: ABdhPJz2k3SgQaIKnsTT9U6nyz6KbHpuPmZLgp0Bt7EuH23ABEbXFWhi7xPB1+QS3JaJBm3ihWpOThFxjpA6uDZzJTc=
X-Received: by 2002:a1c:b782:: with SMTP id h124mr962949wmf.67.1612326020441;
 Tue, 02 Feb 2021 20:20:20 -0800 (PST)
MIME-Version: 1.0
References: <cover.1611637639.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1611637639.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 3 Feb 2021 12:20:08 +0800
Message-ID: <CADvbK_e-+tDucpUnRWQhQqpXSDTd_kbS_hLMkHwVNjWY5bnhuw@mail.gmail.com>
Subject: Re: [PATCHv4 net-next 0/2] net: enable udp v6 sockets receiving v4
 packets with UDP GRO
To:     network dev <netdev@vger.kernel.org>
Cc:     davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Jakub,

I saw the state of this patchset is still new, should I repost it?

On Tue, Jan 26, 2021 at 1:10 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Currently, udp v6 socket can not process v4 packets with UDP GRO, as
> udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
> is called for v6 socket.
>
> This patchset is to increase it and remove the unnecessary code in
> bareudp in Patch 1/2, and improve rxrpc encap_enable by calling
> udp_tunnel_encap_enable().
>
> Xin Long (2):
>   udp: call udp_encap_enable for v6 sockets when enabling encap
>   rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
>
>  drivers/net/bareudp.c    | 6 ------
>  include/net/udp.h        | 1 +
>  include/net/udp_tunnel.h | 3 +--
>  net/ipv4/udp.c           | 6 ++++++
>  net/ipv6/udp.c           | 4 +++-
>  net/rxrpc/local_object.c | 6 +-----
>  6 files changed, 12 insertions(+), 14 deletions(-)
>
> --
> 2.1.0
>
