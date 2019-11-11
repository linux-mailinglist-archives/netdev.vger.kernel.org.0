Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2BA8F6D54
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 04:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfKKDch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 22:32:37 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40809 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbfKKDcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 22:32:36 -0500
Received: by mail-lj1-f193.google.com with SMTP id q2so12142531ljg.7;
        Sun, 10 Nov 2019 19:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fjrlLOqhWKlzcoLQZLawlMPEkn3YR9OEmvuIBToqV08=;
        b=GqkVKpKphVcDj0tnMUN+GZrFtpn/Q1aN7g3pagDZzK0KbuUhrvmXvjH8EuuOQeCR4N
         ksL6RgNjcUYrSJKzZXcXNJ5InBTn2RT3cOrF4HeVrzlT7YNfHKGpuhkkZajEp26Lw1Gg
         M7YEvrurLSjcXfUM1jn7yOlBx7CyV5pQtXAq8IJM8A5RsLU/WJ+vDMVlKJAn8eeuKMo4
         aID/9niqCRRavvYCpl7LJIU3FIECwb60Wqib6oSQ0iu5at9XFR3mJ4KS3VZPQvg1bI6e
         QmKQs5hAZqJYGvGidTBPrsZwbLC7trD5c01O4Omz24dcGuQRAXwHV6l1HWvy1niWaSct
         eG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fjrlLOqhWKlzcoLQZLawlMPEkn3YR9OEmvuIBToqV08=;
        b=R9QxIp9UszLvXvSrVFr7i3CMwM7ncgzemEOtmxIFOkQBPrQFzAeAsxVjkrqLSir5sW
         huy1G9n10Xg3im+AUgLOETutvLDKFT6hg1HvMMQbkmOuMc4sdjSv6WeXdF5V4tnHpxmW
         UtSby7BqSaa4eJl0QH6TvvIlFyVzAhWRI2+8C+/uvzkJ3PtecNNbYsF3Vjy6sJFzAyTm
         CuFiN6jGu1KoXa889Pubz6GHT1smWUFLp8GCrdLuQr8beG3/ynh2Uf6u9uQ+YajYjsjq
         dYdLsR1w8Wj61wgekxlu0QwUYYG47pGBK5EWh6JmC417rpFElBu8AJ8YcFPqeutDwTa/
         /fjg==
X-Gm-Message-State: APjAAAUDLQ0LIlHhGpZMMalBqlwObmK1hFM0mCIQHfZcBZaOP1hd0D8P
        GXY9TQGkJnjISzIbj1eNNoz9gQ9RQ+Te+nveiEg=
X-Google-Smtp-Source: APXvYqzQZvfqpiP2yP0IpurIl1+pVIXGcfxcfgwkoumw49Ou1o7b7Agml9EIlKuu5CP4e+lNDWj7NLAPOkSnVwPkvSE=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr14542574ljj.243.1573443154489;
 Sun, 10 Nov 2019 19:32:34 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
In-Reply-To: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 10 Nov 2019 19:32:22 -0800
Message-ID: <CAADnVQLUsqv_zuyDfXh5q-chsGbSzBQRmFgZHd4DDF8JUauJAw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/5] Extend libbpf to support shared umems and
 Rx|Tx-only sockets
To:     Magnus Karlsson <magnus.karlsson@intel.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        William Tu <u9012063@gmail.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 9:48 AM Magnus Karlsson
<magnus.karlsson@intel.com> wrote:
>
> This patch set extends libbpf and the xdpsock sample program to
> demonstrate the shared umem mode (XDP_SHARED_UMEM) as well as Rx-only
> and Tx-only sockets. This in order for users to have an example to use
> as a blue print and also so that these modes will be exercised more
> frequently.
>
> Note that the user needs to supply an XDP program with the
> XDP_SHARED_UMEM mode that distributes the packets over the sockets
> according to some policy. There is an example supplied with the
> xdpsock program, but there is no default one in libbpf similarly to
> when XDP_SHARED_UMEM is not used. The reason for this is that I felt
> that supplying one that would work for all users in this mode is
> futile. There are just tons of ways to distribute packets, so whatever
> I come up with and build into libbpf would be wrong in most cases.
>
> This patch has been applied against commit 30ee348c1267 ("Merge branch 'bpf-libbpf-fixes'")
>
> Structure of the patch set:
>
> Patch 1: Adds shared umem support to libbpf
> Patch 2: Shared umem support and example XPD program added to xdpsock sample
> Patch 3: Adds Rx-only and Tx-only support to libbpf
> Patch 4: Uses Rx-only sockets for rxdrop and Tx-only sockets for txpush in
>          the xdpsock sample
> Patch 5: Add documentation entries for these two features

Applied. Thanks
