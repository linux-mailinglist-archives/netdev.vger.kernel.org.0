Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5198325F605
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 11:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgIGJGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 05:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbgIGJGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 05:06:13 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E79C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 02:06:13 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id a16so6966033vsp.12
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3oRTx/EEw7OvkP6TqTj990KKl+YkLOb6ElATdVMgf+c=;
        b=ca/oRwxvnOIcH5J4vfm1v0v+QoBEOoIldZVZh7YMa3WP1dtN77B3B+K7IlXxmTHeMQ
         qxbxI6EGosDBjKPZXRvSeZDDQwptN8R3Gbxf7e5ReVyVIfzXB2BO95B+cr94ZG0Qh/1P
         bufJ3LftknpuZXaBuflAmHJZHdD4DNUIF53MIdqR+rDExN5l7h/CXX2m6jTJ/dJtd75v
         5xSQOdXdoPCEUbZpbzaNA74ow4J0rtRf9gqde/k9H1NzfV9PHmQWsEKtFFZU9GAVEdk/
         z4/IOTWFLfv0kmLVLl3bX4P2zuUYQMCZ7M6kBXQJu/BMR8qSylkIxhKNlBVtdG8+mfZc
         zrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3oRTx/EEw7OvkP6TqTj990KKl+YkLOb6ElATdVMgf+c=;
        b=o8gu3wEDTcDxBYrpP2gbSQQk1RInZaNB2N7JwaoiCX/HRY3VJKEKIED6ivqxqtUwkD
         CcMExbIf9nIU1sQdSf6PG3N20tqZsC1OV16Lk+vwTTnQ3TGhg4+4UGdw2NrkLrGHi1xN
         gFNS+w+FQK/qPt2ure9m/vZMaPYdJz8/B/Ag4hUbtmhNAkQJNb/iPeU43KyJTDlhGt5S
         vj/jM6flUB1+DhUHUt095BjNH6zJxmhge5M0fg8hbdXBo4JLbQ2LHupBXJMbzz0+mBQT
         SW5ItbPYJRnDXQCEWzwQvm8ZoSOscTMG5iTEl415Bu6jTDxJceJlRbupbVs+hMGkLPN7
         msOw==
X-Gm-Message-State: AOAM531ObGK603A6lAv4TzZcFUBPGarLYAPGUoFYRJgMSMvlGR0q3prO
        uIIngpXx/WdNITVF5sYWimkTj+l4ivYGfA==
X-Google-Smtp-Source: ABdhPJzM7AXNtUKeg5NEs6fye0w3f3mDmjyI66fYFVtg/mQtVlP29kv1z4xnRYnt+tRRA5QaIn75DQ==
X-Received: by 2002:a67:8882:: with SMTP id k124mr11128914vsd.27.1599469571325;
        Mon, 07 Sep 2020 02:06:11 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id s70sm32053vss.9.2020.09.07.02.06.10
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 02:06:10 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id i22so3392140uat.8
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 02:06:10 -0700 (PDT)
X-Received: by 2002:ab0:24cd:: with SMTP id k13mr10181505uan.92.1599469569684;
 Mon, 07 Sep 2020 02:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
In-Reply-To: <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 7 Sep 2020 11:05:31 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
Message-ID: <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
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

On Sun, Sep 6, 2020 at 1:21 AM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Sat, Sep 5, 2020 at 3:24 PM Xie He <xie.he.0141@gmail.com> wrote:
> >
> > Hi Willem,
> >
> > I have a question about the function dev_validate_header used in
> > af_packet.c. Can you help me? Thanks!
> >
> > I see when the length of the data is smaller than hard_header_len, and
> > when the user is "capable" enough, the function will accept it and pad
> > it with 0s, without validating the header with header_ops->validate.
> >
> > But I think if the driver is able to accept variable-length LL
> > headers, shouldn't we just pass the data to header_ops->validate and
> > let it check the header's validity, and then just pass the validated
> > data to the driver for transmission?
> >
> > Why when the user is "capable" enough, can it bypass the
> > header_ops->validate check? And why do we need to pad the data with
> > 0s? Won't this make the driver confused about the real length of the
> > data?
>
> Oh. I just realized that the padding of zeros won't actually make the
> data longer. The padded zeros are not part of the data so the length
> of the data is kept unchanged. The padding is probably because some
> weird drivers are expecting this. (What drivers are them? Can we fix
> them?)
>
> I can also understand now the ability of a "capable" user to bypass
> the header_ops->validate check. It is probably for testing purposes.
> (Does this mean the root user will always bypass this check?)

Apologies for the delay.

The commit that introduced the code probably summarizes state better
than I would write off the cuff:

"
commit 2793a23aacbd754dbbb5cb75093deb7e4103bace
Author: Willem de Bruijn <willemb@google.com>
Date:   Wed Mar 9 21:58:32 2016 -0500

    net: validate variable length ll headers

    Netdevice parameter hard_header_len is variously interpreted both as
    an upper and lower bound on link layer header length. The field is
    used as upper bound when reserving room at allocation, as lower bound
    when validating user input in PF_PACKET.

    Clarify the definition to be maximum header length. For validation
    of untrusted headers, add an optional validate member to header_ops.

    Allow bypassing of validation by passing CAP_SYS_RAWIO, for instance
    for deliberate testing of corrupt input. In this case, pad trailing
    bytes, as some device drivers expect completely initialized headers.

    See also http://comments.gmane.org/gmane.linux.network/401064

    Signed-off-by: Willem de Bruijn <willemb@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
"

The CAP_SYS_RAWIO exception indeed was requested to be able to
purposely test devices against bad inputs. The gmane link
unfortunately no longer works, but this was the discussion thread:
https://www.mail-archive.com/netdev@vger.kernel.org/msg99920.html

It zeroes the packet up max_header_len to ensure that an unintentional
short packet will at least not result in reading undefined data. Now
that the dust has settled around the min_header_len/max_header_len
changes, maybe now is a good time to revisit removing that
CAP_SYS_RAWIO loophole.
