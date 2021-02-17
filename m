Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E92131E211
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 23:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbhBQW2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 17:28:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233048AbhBQW20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 17:28:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D89EC0613D6
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 14:27:46 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d2so4482870edq.10
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 14:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3IM9I3UuREFmRHOZr8PZmBSuaPgKWXMfL/0dV2dXv88=;
        b=RUufMfR/U88vgEIKMQ/LDi22jwTmXQJ0ZzdLLrwjOeb2a6jxx89c5m71xViuNKTPN3
         JCiqUTrs/gSZvIeYSh2vG3o5gjoJeTry484YaIo5wXMQnTBcloj9bwlikI+MKJvl0wrr
         OgvD3I/1FL7Cwez+5fGQbNFh6+uv/eTFz5w3mi+ruOSLSKoa5DV4VrQKVsRTBR9lU4lK
         +4g84dLy60M7fk9RT+uY3qUCGCYXA9t1rMSJKBx/rVuru6kTvBbLg38bOTCR1Z6j/GQp
         zuxkVyQJDItb8GG1ENIdF5/Ghqk9jp3/rS+b5kqFcHOP+2dJYW/tMUo9hRDIyB5ZHaVb
         ODIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3IM9I3UuREFmRHOZr8PZmBSuaPgKWXMfL/0dV2dXv88=;
        b=j0kspFKkBD7QF++ddoqS7XSkf9n4jDNwYMh/sA/Ub5nzW7AUT0EI6uVYKK/TUG1fha
         uQYZQnxwFXLpohhpHEy0WD+CnnBhrLRL6AdkHcrIpZFLZccK3eCFKbPR/16O4OSqOfvP
         GqLOnZS6y1bGIoN5uY6lDEB7oYeY5ahBAMIZiyB7MMR4I0oCv8tXzvpmsyWNLhgTrSjY
         WhDmU03z4aWPUAJ5vCwGKZyhf8+kjoIv2Apoxitl4MP/kJ6kpH9mOisHcJxIX4tbuhsl
         UltH4L5BWpQLcCa/d+8aeX40bpy5sv24JBWie3h6GsdeIq/HdTS2dYGkKDhv7uSsczes
         1mTQ==
X-Gm-Message-State: AOAM533OGfqaPejLPk91mKjmn4HHIV0ydHaV9m+KWwUz1ALTLiIF/SAt
        CZAok/itFU/I1hjyITd9QP3ds9XnW2k=
X-Google-Smtp-Source: ABdhPJw8pgaADxSO/e41x69a6vySjMfCP8WuwjBjdlE8hrN5wEIcxq/3pUpKyia9Ch8f4AGPmwjygw==
X-Received: by 2002:a05:6402:208:: with SMTP id t8mr940857edv.189.1613600864151;
        Wed, 17 Feb 2021 14:27:44 -0800 (PST)
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com. [209.85.221.48])
        by smtp.gmail.com with ESMTPSA id pj27sm1594022ejb.58.2021.02.17.14.27.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Feb 2021 14:27:43 -0800 (PST)
Received: by mail-wr1-f48.google.com with SMTP id u14so289628wri.3
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 14:27:43 -0800 (PST)
X-Received: by 2002:adf:ec43:: with SMTP id w3mr1325377wrn.12.1613600862672;
 Wed, 17 Feb 2021 14:27:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
In-Reply-To: <CAHmME9qfXFZKZfO-uc7GC3xguSq99_CqrTtzmgp_984MSfNbgA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 17 Feb 2021 17:27:05 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
Message-ID: <CA+FuTSfHRtV7kP-y6ihW_BnYVmHE9Hv7jHgOdTwJhUXkd6L79w@mail.gmail.com>
Subject: Re: possible stack corruption in icmp_send (__stack_chk_fail)
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 1:12 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Netdev & Willem,
>
> I've received a report of stack corruption -- via the stack protector
> check -- in icmp_send. I was sent a vmcore, and was able to extract
> the OOPS from there. However, I've been unable to produce the bug and
> I don't see where it'd be in the code. That might point to a more
> sinister problem, or I'm simply just not seeing it. Apparently the
> reporter reproduces it every 40 or so minutes, and has seen it happen
> since at least ~5.10. Willem - I'm emailing you because it seems like
> you were making a lot of changes to the icmp code around then, and
> perhaps you have an intuition. For example, some of the error handling
> code takes a pointer to a stack buffer (_objh and such), and maybe
> that's problematic? I'm not quite sure. The vmcore, along with the
> various kernel binaries I hunted down are here:
> https://data.zx2c4.com/icmp_send-crash-e03b4a42-706a-43bf-bc40-1f15966b3216.tar.xz
> . The extracted dmesg follows below, in case you or anyone has a
> pointer. I've been staring at this for a while and don't see it.
>
> Jason

Sorry, I also don't immediately see a cause.

The _objh is a fairly standard approach to accessing skb data with
skb_header_pointer. More importantly, that codepath is in the icmp
receive path and then guarded by a socket option
(inet_sk(sk)->recverr_rfc4884), so unlikely to be exercised here.

This is an icmp send in response to a forwarded packet (assuming
__qdisc_run dequeued the packet that triggered it). The icmp send code
is quite robust against, e.g., undersized packets. But could it be
that the forwarded packet is not sensible IPv4? The skb->protocol is
inferred in wg_packet_consume_data_done->ip_tunnel_parse_protocol.

As for on-stack variable overflow, __ip_options_echo parses the
(untrusted) input to write into stack allocated icmp_param. But that
is fairly well tested, rarely touched, code by now. Perhaps relevant,
though, the opt passed is in skb->cb[], which at should probably not
be interpreted as inet_skb_parm (IPCB).

   static inline void icmp_send(struct sk_buff *skb_in, int type, int
code, __be32 info)
   {
        __icmp_send(skb_in, type, code, info, &IPCB(skb_in)->opt);
   }


A vmlinux image might help. I couldn't find one for this kernel.

Or if the kernel can be modified and this path is rarely taken,
logging the packet, e.g., with skb_dump.
