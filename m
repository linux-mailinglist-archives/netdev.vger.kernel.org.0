Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4596322DBA
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233165AbhBWPmh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:42:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbhBWPmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:42:32 -0500
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7E9C061574
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:41:49 -0800 (PST)
Received: by mail-vk1-xa33.google.com with SMTP id k1so3734991vkb.11
        for <netdev@vger.kernel.org>; Tue, 23 Feb 2021 07:41:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0DEppTwUNJEF+OCirzrug9sI+JQzDn51E/NiJtDrFU8=;
        b=RSRLxOtXjwisLh8ICrmPJXENQiLqSQyNaawsYE3jlVUbeS9mkHG2VjVf0UtkEzgo99
         bOqLEusOLPtLIL8NLQflSademhzBR/Qw5YHT3U0pgrbaBatKjZMqnDTuX/fq7Uvk3t7F
         ouHATSdiun4yfBcUSEhUPYKry11OKJcfX0ww1BO9wWfJabHaVOLs52Z3okXoR1ug0x3X
         h+lJj+5xTQ9l9rmgHqAj597LWUdQLqbPQZq/B+LZbkhiMNAiR0bCjw5y9O/9EN8y1KLk
         KOk9uj21VDpoaboNzhrOL3HbMfvQn7huTD2jT7nmMTRs3FpWb3MSwiCLZuR5v4ap6bx5
         c8+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0DEppTwUNJEF+OCirzrug9sI+JQzDn51E/NiJtDrFU8=;
        b=Dl1hb2OJI8S06jvP08ZgE/WiEVhJSwjPqAJOSMvHswK2DpS8wH33YxlhQMBRXd2V12
         h8mRTLs8vLDweAsTKjNuqLFJ2Fh5PMYrnZmaL9+VeqFMkaJHvzF2C7B4ZlgXztjmUy7z
         F5oeqAMM/WNDyThUgfoFP8MhZoCpr9jiDIuFTN3Ny6h7OGnJMuXdIpftis4eRDG9SBKG
         G+RldC34Tmr5FO/ladMr3gNXt9SD23/OfWmlCNZaQyLotg37xP6qltDBKekXygnztkfc
         kC/Mz1x2sdb+GYOwKonf+7uDN40JGCUOwQPJT9irXB+Yc2hUfC3Nhx5CNSY83rUGYEHg
         7nSQ==
X-Gm-Message-State: AOAM533nmdF3ggMRqVylcBaI3aJwkA0ZXI+tiBbyknqWEr+q3xC7gjk/
        jqgC7w/8qLE9cnQB3L4CBa0fwD1jhEz42IaGbFnytA==
X-Google-Smtp-Source: ABdhPJyXJVMoD2zKkIX+vU1OpHRF98xw2mSb1Bo1yzFcuADCzc+frb5qWaf4WRnHWMWB1S0lOnXgMW7Qina41d1o08I=
X-Received: by 2002:a1f:abcf:: with SMTP id u198mr1458319vke.19.1614094908207;
 Tue, 23 Feb 2021 07:41:48 -0800 (PST)
MIME-Version: 1.0
References: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
In-Reply-To: <35A4DDAA-7E8D-43CB-A1F5-D1E46A4ED42E@gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 23 Feb 2021 10:41:31 -0500
Message-ID: <CADVnQy=G=GU1USyEcGA_faJg5L-wLO6jS4EUocrVsjqkaGbvYw@mail.gmail.com>
Subject: Re: TCP stall issue
To:     Gil Pedersen <kanongil@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 5:13 AM Gil Pedersen <kanongil@gmail.com> wrote:
>
> Hi,
>
> I am investigating a TCP stall that can occur when sending to an Android =
device (kernel 4.9.148) from an Ubuntu server running kernel 5.11.0.
>
> The issue seems to be that RACK is not applied when a D-SACK (with SACK) =
is received on the server after an RTO re-transmission (CA_Loss state). Her=
e the re-transmitted segment is considered to be already delivered and loss=
 undo logic is applied. Then nothing is re-transmitted until the next RTO, =
where the next segment is sent and the same thing happens again. The causes=
 the retransmitted segments to be delivered at a rate of ~1 per second, so =
a burst loss of eg. 20 segments cause a 20+ second stall. I would expect RA=
CK to kick in long before this happens.
>
> Note the D-SACK should not be considered spurious, as the TSecr value mat=
ches the re-transmission TSval.
>
> Also, the Android receiver is definitely sending strange D-SACKs that doe=
s not properly advance the ACK number to include received segments. However=
, I can't control it and need to fix it on the server by quickly re-transmi=
tting the segments. The connection itself is functional. If the client make=
s a request to the server in this state, it can respond and the client will=
 receive any segments sent in reply.
>
> I can see from counters that TcpExtTCPLossUndo & TcpExtTCPSackFailures ar=
e incremented on the server when this happens.
> The issue appears both with F-RTO enabled and disabled. Also appears both=
 with BBR and RENO.
>
> Any idea of why this happens, or suggestions on how to debug the issue fu=
rther?
>
> /Gil

Thanks for the detailed report! It sounds like you have a trace. Can
you please attach (or post the URL of) a binary tcpdump .pcap trace
that illustrates the problem, to make sure we can understand and
reproduce the issue?

thanks,
neal
