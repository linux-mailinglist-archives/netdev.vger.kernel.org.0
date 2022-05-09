Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C36A520315
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239405AbiEIREk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239344AbiEIREj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:04:39 -0400
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382772CDE3
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:00:44 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-2f7c57ee6feso152004927b3.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 10:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kCewcUbzeYNqE0+hqHYuhMjpHMtNV/WepL6MKy7YJ9E=;
        b=QjDJIk+XqAGWQrvJvJ4vrAMkic9zdG0PbwGaUV2dXVKVyKfHxDatVFnN5bQWEYJGMi
         Et7UWdnTJa1/dnnRSTh/RM2pFqMHs5VFOcEhPsTo54b25yc8TAqyM/HNk0bYriaiHquc
         BWzWtql3OKa1Fy3tRxzLiLmW0aH6AbyV4IIaJ5SgDTvwpKNDTqk6xnnMvTqm7ZgCmFOr
         H3U7BA3KOla/WrKvMY2mkjISfigXSccRPEsTy6jqGGzkcP507opdg/+CH8jk29OqAKSn
         mhMX6kq0Cxqz3XGTqT3sLBhDi7tyzzgm2Ktmm++aruQ/IIN6e6N4707P4M2XlcgcYH8+
         lamw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kCewcUbzeYNqE0+hqHYuhMjpHMtNV/WepL6MKy7YJ9E=;
        b=wDbxMtKc2xkCsme3lQvX+0EsXxfHc3uHOYJBgre7EgT6UC7mGIlzqgfUeZa060Rswc
         Ioyaxb9tIuDN8xKhfUzyRU1Qwi8bm7BpR/y0NC3gg1PBdtPiwCXNutV5MGVKsUXgWyBM
         LbiRcYhgwWiUIe6zhpIT9YeBfU1y6bhFqdkdyh/0vZPURP9ga8nS5MVF0pD8xBnYypOV
         VVpnN3WfdHR9njnI5NcIOpDkuu2VpoOGrlHsv+R/Mf5dzFFYJiXdomqKiFdfohT53Hv5
         yUrvet2Ha+IQrP812eORVPAwPvD70po1CEe0eee17QXnway3jAdiM6AJlblp663Al8un
         22gg==
X-Gm-Message-State: AOAM533Ss3aunVbuMKuBmHlApBhuMooZfRxk5qXv8QZJiDixZKTe08PN
        D2tMrs+0HkEK4IcUAOwGHGHB/g2uckHjr/Dlb+aaVgBhzUr+D3EL
X-Google-Smtp-Source: ABdhPJyo/2bq10sAcOayNdRksKnI5RvDo+NzQTs9aXWxsEFyh5wQQfy3xoxP4kjnnE7SFGLWxnB9ENbv9UKAyXnq0cE=
X-Received: by 2002:a81:234b:0:b0:2f8:4082:bbd3 with SMTP id
 j72-20020a81234b000000b002f84082bbd3mr15011585ywj.47.1652115642552; Mon, 09
 May 2022 10:00:42 -0700 (PDT)
MIME-Version: 1.0
References: <06dc7df0afd344fc9aa656896e761d37@AcuMS.aculab.com>
In-Reply-To: <06dc7df0afd344fc9aa656896e761d37@AcuMS.aculab.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 10:00:31 -0700
Message-ID: <CANn89iLUUKCG0FbRU=xC2Snm3aQcMikEFwFv=DSTt_Ti7VvJsg@mail.gmail.com>
Subject: Re: High packet rate udp receive
To:     David Laight <David.Laight@aculab.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 9:55 AM David Laight <David.Laight@aculab.com> wrote:
>
> I'm testing some high channel count RTP (UDP audio).
> When I get much over 250000 receive packets/second the
> network receive softint processing seems to overload
> one cpu and then packets are silently discarded somewhere.
>
> I (probably) can see all the packets in /sys/class/net/em2/statistics/rx_packets
> but the counts from 'netstat -s' are a lot lower.
>
> The packets are destined for a lot of UDP sockets - each gets 50/sec.
> These can't be 'connected' because the source address is allowed to change.
> For testing the source IP is pretty fixed.
> But I've not tried to look for the actual bottleneck.
>
> Are we stuck with one cpu doing all the ethernet, IP and UDP
> receive processing?

RPS can help, if your NIC has a single queue.

Please look at Documentation/networking/scaling.rst for details.

You might have to tune the number of cpus you want to be able to
process these packets.

> (and the end of transmit reaping).
> Or is there a way to get another cpu to do some of the work?
>
> Since this is UDP things like gro can't help.
> We do have to handle very large numbers of packets.
>
> Would a multi-queue ethernet adapter help?

Might be, at least by having a more efficient bus.

> This system has a BCM5720 (tg3 driver) which I don't think is multi-Q.
>
> OTOH I've also had issues with a similar packet rate on an intel
> nic that would be multi-q because the interrupt mitigation logic
> is completely broken for high packet rates.
> Only increasing the ring size to 4096 stopped it dropping packets.
>
>         David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
>
