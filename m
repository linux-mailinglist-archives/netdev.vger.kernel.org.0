Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFAF52A4933
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 16:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728449AbgKCPRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 10:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728377AbgKCPQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 10:16:13 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A504C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 07:16:13 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id 184so22639236lfd.6
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 07:16:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=446w+zeX8SvDmYZkfoBaMcX0Juw1voeAh5futcRnM4g=;
        b=d7uO7GPNiTsDCOB19uKeZ5REHup17yx/8t4p3DBafabGmKCmQrI327oKtnQOtI6ANR
         +B0UqNQssLuom3G+uJvlL2inoB69IOv3BL9OE5KF2CO8L3WuGUvTan6oZcWKoy+UDr5P
         Aia+rqzjXCkzz/jz6sgkXbBf7fI2G/GIwrcGzTAyVm2ZdtgtgMDyEgwMuSN4Qd0D+z5j
         kFtNbD3csaf64Vy4gcqVnusLpb/n0gveyYLE6CaCRf5jQ2HeDpoeEKa+28DHZXV/eb/V
         eTV7zx5r/lcPLhixaMqr/35j8whgtYsET4NscWDvFVzwZS9w3T/x03cgey7ThhjyMWlb
         U6Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=446w+zeX8SvDmYZkfoBaMcX0Juw1voeAh5futcRnM4g=;
        b=Ye90Qpb+m5SRSEACVw1NLVsZskPVQ09wzfhd4/tDWwuoS0LOaaNw9vgZGoGIu3PA66
         /rsuDU1j3WQJnNMpXvH2clYgcPYQJx73uyf/odUeJiPFuKs71qsuAVQnwdQGjFAtTyh0
         Tb2LocStjNd7wTm7Oj/Iorj+e8AzAkMgKl/rfFSsAR/1aX/TR/sRDC/kIS5kky4oEeE9
         EQuJteGGV6uMoLah+5cdIymeCzu7nOj3COH1uP+JxuZ1t8OLFLoSaJ+uQrDLM4Lef/Ok
         WCWqbQZ4Bq6bYATp57hPG5Om9VrcFSxSpfpPl4IANaT1dusQCcICATIQOYy86Z82VOz8
         StUw==
X-Gm-Message-State: AOAM5337lTon/V71LjvQfLbA/7XNCufdEEZSRq19eF3IUVSuc9kpWyhC
        M5N8ACp3zI8q991Vd7fFUGpkDR5VDlZ8WmEwAdo=
X-Google-Smtp-Source: ABdhPJymcyUV1EMwpfq7XeDWDjWxnOljQ/XO81DOHNcOdIL5QZyOOcs91EhqQIRNWWAu/eyBBvfZy75mz8npzNKcyag=
X-Received: by 2002:a19:6619:: with SMTP id a25mr3072867lfc.186.1604416571620;
 Tue, 03 Nov 2020 07:16:11 -0800 (PST)
MIME-Version: 1.0
References: <20201103023217.27685-1-ajderossi@gmail.com> <20201103120839.GA10834@gondor.apana.org.au>
In-Reply-To: <20201103120839.GA10834@gondor.apana.org.au>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Tue, 3 Nov 2020 07:16:00 -0800
Message-ID: <CAKkLME25zc21fvc_fatae-Lmzzr2sQfbNkqWSENGfoHa4rJpoQ@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: Pass template address family to xfrm_state_look_at
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 4:08 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Mon, Nov 02, 2020 at 06:32:19PM -0800, Anthony DeRossi wrote:
> > This fixes a regression where valid selectors are incorrectly skipped
> > when xfrm_state_find is called with a non-matching address family (e.g.
> > when using IPv6-in-IPv4 ESP in transport mode).
>
> Why are we even allowing v6-over-v4 in transport mode? Isn't that
> the whole point of BEET mode?

I'm not sure. This is the outgoing policy that strongSwan creates for
an IPv6-in-IPv4 tunnel when compression is enabled:

src fd02::/16 dst fd02::2/128
        dir out priority 326271 ptype main
        tmpl src 10.0.0.8 dst 192.168.1.231
                proto comp spi 0x0000d00e reqid 1 mode tunnel
        tmpl src 0.0.0.0 dst 0.0.0.0
                proto esp spi 0xc543e950 reqid 1 mode transport

After your patch, outgoing IPv6 packets fail to match the associated state:

src 10.0.0.8 dst 192.168.1.231
        proto esp spi 0xc543e950 reqid 1 mode transport
        replay-window 0
        auth-trunc hmac(sha256)
0x143b570f59b23eaa560905f19a922451c6dfa5694ba2e45e1b065bb1863421aa 128
        enc cbc(aes) 0x526ed144ca087125ce30e36c8f20d972
        encap type espinudp sport 4501 dport 4500 addr 0.0.0.0
        anti-replay context: seq 0x0, oseq 0x0, bitmap 0x00000000
        sel src 0.0.0.0/0 dst 0.0.0.0/0

Is this an invalid configuration?

Anthony
