Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDCB46215D
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 21:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379028AbhK2UIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 15:08:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344895AbhK2UGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 15:06:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0153DC08EB28
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 08:38:04 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u1so38104462wru.13
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 08:38:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QmtmQkFPYJHPPdnepu7o3vhcuFiBe2ruUGoH0R8YyvU=;
        b=nJbGFc+15VGUAtCRw9OIxNRndRHVhEqn12Il71SPZElKV5jWKNKikuQVZLUSKk8n1E
         I/7yLDamgTRVbh6WatknzZLiSrqRNf3kAAnDzMguSLCgKAMBZkIk0l8Jvd+zQeBXrkqc
         GGbB0q7snX7xS7ELnxZEOCX09Fo6NVXxDw/B1/mZcCK6xnLuRFZ8G6ZcPt4SJsoXcznM
         JzZ+MpWVzhcFXlBU1IsvCGjKrTfwt3aFu1o4nVGBgWdM2/GSzUJRMm5EWgJRRKdf1IlO
         Re1vJXkdUvqY6CJAEOq4GEyvuTu38DBmqUBDQbYTPwWx9UEEMdat0DDv2MKh68GzjT4M
         8xuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QmtmQkFPYJHPPdnepu7o3vhcuFiBe2ruUGoH0R8YyvU=;
        b=LyaNKYozKIBNT35ZAdZEBF/jb75BZam/eEdKT0AC35s7hIEPOlGQTwgKu3NZMSmWtl
         vSIRGyBlFbs39534UN9A54CncPJ6pWaOf4hKdVfA/E/KMm3RPRdy/DbfBT4m86nXIlJU
         PWhCPahiMIlA856j8MKmowJV6G2y0el81chE+HcpfJ7FYBWkv6k3E2UytYZCKGs+k79c
         UIvyEjxOJEGlLP8U6RSNTXfot+d5pm16fF/VWqlSOKnq7c8WPcJrwkcwgylITZjIMhcP
         U/gWnbcWebdZ7Na9A2zhnhys0b8ocliNgkuiJD4rMK6kCyjm5Z5GyLopoVC5jkkKbNyJ
         Qcbg==
X-Gm-Message-State: AOAM533ZM2CVGz0ml0VdYvgH6+a1jmd+Guy/JbMyiaP1JqEpPavW0HW4
        wpzeAvOBtiwtQsYrzQqsin3d9fwqcdo2frE5reTxzw==
X-Google-Smtp-Source: ABdhPJz9IZl4Ovh9fliNsxw/MncvCR3SAGrUbnaNi2F3onqiDaE88AN4a65ka6fxwQOhAkgetJCvSP6GiL4iXl6GjDg=
X-Received: by 2002:adf:9b95:: with SMTP id d21mr35218346wrc.527.1638203882121;
 Mon, 29 Nov 2021 08:38:02 -0800 (PST)
MIME-Version: 1.0
References: <20211128060102.6504-1-imagedong@tencent.com> <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211129075707.47ab0ffe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 29 Nov 2021 08:37:50 -0800
Message-ID: <CANn89iJ0Txbb7wvgKSPMLhHE0X8cadayN8ULZJkEvrC8YTwkow@mail.gmail.com>
Subject: Re: [PATCH v2 net-next] net: snmp: add statistics for tcp small queue check
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     menglong8.dong@gmail.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, imagedong@tencent.com,
        ycheng@google.com, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 7:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 28 Nov 2021 14:01:02 +0800 menglong8.dong@gmail.com wrote:
> > Once tcp small queue check failed in tcp_small_queue_check(), the
> > throughput of tcp will be limited, and it's hard to distinguish
> > whether it is out of tcp congestion control.
> >
> > Add statistics of LINUX_MIB_TCPSMALLQUEUEFAILURE for this scene.
>
> Isn't this going to trigger all the time and alarm users because of the
> "Failure" in the TCPSmallQueueFailure name?  Isn't it perfectly fine
> for TCP to bake full TSQ amount of data and have it paced out onto the
> wire? What's your link speed?

Yes, I would be curious to have some instructions on how this new SNMP
variable can be used,
in a concrete case.

Like, how getting these SNMP values can translate to an action, giving
more throughput ?
