Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA6B131300
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 14:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgAFNe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 08:34:29 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26117 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726173AbgAFNe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 08:34:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578317667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+Dkkujyfe/gezec8u0wxy79DdORx+9S3fm+dMwU0Eyc=;
        b=czrQ/W3Qg6A+M+4fflyh18n8Dtsai8RfrUAuQdiDS1TQpn6TpqQCm5JYCbjkKC2D/QjYnR
        0vrulv6BggK0T340kmevRMSeF2hrsqUnk0bSqM1OqPepRZLxupcq8Qd2D36yFKLN2LHSf8
        8dNeJeAZcYrsiBce4tOVTqrP74r9uK8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-408-DeT5B3oaO6CCDJ628-nuag-1; Mon, 06 Jan 2020 08:34:25 -0500
X-MC-Unique: DeT5B3oaO6CCDJ628-nuag-1
Received: by mail-wm1-f69.google.com with SMTP id h130so2854032wme.7
        for <netdev@vger.kernel.org>; Mon, 06 Jan 2020 05:34:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+Dkkujyfe/gezec8u0wxy79DdORx+9S3fm+dMwU0Eyc=;
        b=cAWoJk+DOlhfRlVRN35DrGmKR3bhdOfaETjUtkQ5JZpJ1gT4NwsYITMSQNBW60pI1U
         9ZVdZABGb8siZ+JHTpGdT6DK+QXWqa3zAiQOTZGGTm6gxHfWJces+T0RheA2yD1l6y/a
         5weqrxQG3HnM0L/acqk6tHlbxkidMOoN/fX7dXWKUptt7yvcxkMGul8hFh6sXVclgUes
         NGtIlV4OefxnKC/33Rcju4/iWEZMg+f6NGZp07vqZooCiI0wkUYw9ncUYsTxxERdjION
         NmeA0WQIbhWhRD1wYm9l9oOM9cKMaRLrSbDsscx1yWHrFemEM136Rn3VYWB0y5wIegnm
         IZuA==
X-Gm-Message-State: APjAAAUO5timLlYUE/CDd+Ovopl04B77Ljs+zTWFDJIu6r9gvb1I/yb7
        u28avni1x8sPfo2HR2LTcWICKK2nsDnhvnHAPjBAW9vdM23N3KnQca2awSBeNTktBMyua4cCGSp
        80y8h7SuSxyE7gYAw
X-Received: by 2002:adf:f508:: with SMTP id q8mr27908553wro.334.1578317663890;
        Mon, 06 Jan 2020 05:34:23 -0800 (PST)
X-Google-Smtp-Source: APXvYqxm40NiLw1TYjidTWCotGayLqivBaOTg5hEb2NN8tw0Sw35bt3Zm76Owu+8ubw6JUQgXScAiA==
X-Received: by 2002:adf:f508:: with SMTP id q8mr27908539wro.334.1578317663728;
        Mon, 06 Jan 2020 05:34:23 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q68sm24387041wme.14.2020.01.06.05.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 05:34:23 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id A0E54180ADA; Mon,  6 Jan 2020 14:34:22 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kan Yan <kyan@google.com>, Justin Capella <justincapella@gmail.com>
Cc:     Stephen Oberholtzer <stevie@qrpff.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: PROBLEM: Wireless networking goes down on Acer C720P Chromebook (bisected)
In-Reply-To: <CA+iem5uPaYmZr=+kdHopm1Yo9dgyL98k7KfV6uYx_yH22FSGag@mail.gmail.com>
References: <CAD_xR9eDL+9jzjYxPXJjS7U58ypCPWHYzrk0C3_vt-w26FZeAQ@mail.gmail.com> <1762437703fd150bb535ee488c78c830f107a531.camel@sipsolutions.net> <CAD_xR9eh=CAYeQZ3Vp9Yj9h3ifMu2exy0ihaXyE+736tJrPVLA@mail.gmail.com> <CAMrEMU-QF8HCTMFhzHd0w2f132iA4GLUXHmBPGnuetPqkz=U7A@mail.gmail.com> <CA+iem5uPaYmZr=+kdHopm1Yo9dgyL98k7KfV6uYx_yH22FSGag@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 06 Jan 2020 14:34:22 +0100
Message-ID: <87tv58k8td.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kan Yan <kyan@google.com> writes:

>> I ran a ping, and saw this:
>>
>> - pings coming back in <5ms
>> - re-enable AQL (echo 7 | tee airtime_flags)
>> - pings stop coming back immediately
>> - some seconds later, disable AQL again (echo 3 | tee airtime_flags)
>> - immediate *flood* of ping replies registered, with times 16000ms,
>> 15000ms, 14000ms, .. down to 1000ms, 15ms, then stabilizing sub-5ms
>> - According to the icmp_seq values, all 28 requests were replied to,
>> and their replies were delivered in-order
>>
>> This certainly looks like a missing TX queue restart to me?
> I don't think TX queue restart is "missing", the TX queue should get
> restarted when the pending frames is completed and returned to the
> host driver. However, It looks like there is some issue with the
> deficit refill logic in ath9k, and the TX queue got blocked due to the
> negative deficit.

s/deficit refill/packet freeing/. I.e., there's an issue with the ath9k
driver either stomping on the tx_time_est field in the cb, or it's not
reporting back all freed TX skbs properly, so the AQL Q depth doesn't go
back down.

The large negative deficit is just because the queue is being blocked by
AQL, so it won't get its deficit refilled (and it keeps decreasing as RX
packets are being accounted).

All this being said, given the fact that ath9k definitely doesn't need
AQL, I think it's probably not worth it to try to find out exactly what
is causing this, and instead just leave AQL off for that driver?

(As an aside, this definitely disproves my initial "AQL should be benign
for drivers that don't need it" hypothesis. Guess that was way too
optimistic anyway ;))

-Toke

