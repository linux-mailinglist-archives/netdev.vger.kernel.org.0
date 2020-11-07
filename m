Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB6892AA4B7
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 12:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgKGLhR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 06:37:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:35290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbgKGLhQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 06:37:16 -0500
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14A99208E4;
        Sat,  7 Nov 2020 11:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604749036;
        bh=em/e3f6NhTAui/ah/wEifBq4OE2XCU15IP8+VcTiWVs=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jRSsphlTQyEzMj4nfh5g4ew+wZPbj31JGlG4r3HK5Q8La8GFsxmDTs2cB0i7/Bc9K
         8jA8X1oBRlgjIxuEeSE1AKSYBP4ACGXgmenAdmEFH5p6o1Hm4PFEZC3S1vQCfrHQNi
         3m3PQGcPniJrRZZNAeFbnECp1TCzCQ/3LrFXcGos=
Received: by mail-wr1-f52.google.com with SMTP id x7so3928512wrl.3;
        Sat, 07 Nov 2020 03:37:16 -0800 (PST)
X-Gm-Message-State: AOAM531UrmbR1msyfUI/Ux09+I4hWGGtDLCqrhSOidsdM1v05z9LxR8b
        3xVEkBt/AqgoXwGObQvKrbGNkT2/+OPM3grsoWA=
X-Google-Smtp-Source: ABdhPJyLadVdWsa5ywE5T33VXoMWYPFLyp87yJGDnlr/93XXJ85G8lrPDWIxa/SAWuGTOhN8DkhGHxSthyGmE98lcF0=
X-Received: by 2002:a5d:5261:: with SMTP id l1mr8115522wrc.105.1604749034668;
 Sat, 07 Nov 2020 03:37:14 -0800 (PST)
MIME-Version: 1.0
References: <20201026213040.3889546-1-arnd@kernel.org> <20201026213040.3889546-8-arnd@kernel.org>
 <87tuu7ohbo.fsf@codeaurora.org> <47b04bd1da38a2356546284eb3576156899965de.camel@sipsolutions.net>
 <87tuu1fma5.fsf@codeaurora.org>
In-Reply-To: <87tuu1fma5.fsf@codeaurora.org>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sat, 7 Nov 2020 12:36:58 +0100
X-Gmail-Original-Message-ID: <CAK8P3a1nqFus4Kf_RhmLZCfyhA+dd8eExbm7scmtQq9YnMw_Kg@mail.gmail.com>
Message-ID: <CAK8P3a1nqFus4Kf_RhmLZCfyhA+dd8eExbm7scmtQq9YnMw_Kg@mail.gmail.com>
Subject: Re: [PATCH net-next 08/11] ath9k: work around false-positive gcc warning
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 7, 2020 at 12:21 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
> > On Mon, 2020-11-02 at 18:26 +0200, Kalle Valo wrote:
> >> Arnd Bergmann <arnd@kernel.org> writes:
> >> Isn't there a better way to handle this? I really would not want
> >> checking for GCC versions become a common approach in drivers.
> >>
> >> I even think that using memcpy() always is better than the ugly ifdef.
> >
> > If you put memcpy() always somebody will surely go and clean it up to
> > use ether_addr_copy() soon ...
>
> I can always add a comment and hope that the cleanup people read
> comments :) I did that now in the pending branch:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=25cfc077bd7a798d1aa527ad2aa9932bb3284376
>
> Does that look ok? I prefer that over the ifdef.

Fine with me. My original reason for the compiler version check
was that we can eventually restore the previous version once the
compiler is fixed for long enough that all broken compilers are
too old to build the kernel, in maybe six years from now at the
current rate of deprecating old compilers.

       Arnd
