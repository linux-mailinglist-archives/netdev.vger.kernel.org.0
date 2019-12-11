Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E1811AE31
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729934AbfLKOrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:47:19 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730076AbfLKOrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:47:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576075633;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uirOhgSvjq4DT4EarKgWh3oOvWR/NL1lmoArYsaFvfU=;
        b=XYf6iYdVDT4VPrsX6WrA/nWXGMlz37X59Dzc7pxkdyXfVADN/6apgP9xak83VCzZIocjuT
        KlRxFFPJHKt2Q4jq6LzTp/B0pgDncskuUsROp/ZX2Si+yVxTohZCuhGDi+arRALBK523NH
        /JyewvcEE6RYAwuMKuXupE/Q0PnjHmw=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-ilZVaj8BN2anY2nBxxUcyw-1; Wed, 11 Dec 2019 09:47:12 -0500
Received: by mail-lj1-f197.google.com with SMTP id c24so4450627ljk.0
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:47:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DrlMxGv0pYjq5Gdk23gjEZddH1IAa/lFb9hEecJndV4=;
        b=PZr6ntTPHz//U6nzY6QiN/xkc6IZy9Whz4+9UzlqO6dHlnV+P+GWX3XMsdj6HEfLRW
         ePqDJ9WLCjtKGa6pE+yHtPEhdOiWZLPg9w1jpQPKs8vIug/oWGjfFiF1vFSG/84YsxZe
         sdlc+9Mk22PPyORI1ZbkSPeWIGBMAg8WEBTXTMLbqKuHkB3RanAK82mKWlWDJlCex5re
         HTGd7CPrLiW0VzJlXE7Har7rEoptNCWvTRNwXHQy1WRDfX4yAgf9Ka7LKaTnt96RWgLi
         mF8tNNwyPIwxLu1ZeDIwhg5v7kDeG6N/uvE3QvvYYOL3lp8gzUTrAnYBMyZaxPnblvPo
         otKw==
X-Gm-Message-State: APjAAAWeyEVZHrfAsWx1/wZpEWJS4FHPU7HwhFg0UgyArlJd4XBgibDl
        yz7r89yPRjOY/56v+ToMM2eCi0zgJR/tBIb5Fngq3Kx5Hy6hClKl+hFx1oB/2PVcviLL8fwtB+r
        zZjvTifC9KKXyLrLv
X-Received: by 2002:a2e:99d0:: with SMTP id l16mr2374138ljj.1.1576075630891;
        Wed, 11 Dec 2019 06:47:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqzV4TVbG7SBbl7pnNaA6hSPeBIeHzeUKgWyTtLqludm96u74ZEBRobOs16/al35Shb/4+N+TA==
X-Received: by 2002:a2e:99d0:: with SMTP id l16mr2374126ljj.1.1576075630705;
        Wed, 11 Dec 2019 06:47:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id c189sm1312552lfg.75.2019.12.11.06.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:47:10 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 4F04418033F; Wed, 11 Dec 2019 15:47:08 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net> <878snjgs5l.fsf@toke.dk> <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net> <875zingnzt.fsf@toke.dk> <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net> <14bbfcc8408500704c46701251546e7ff65c6fd0.camel@sipsolutions.net> <87r21bez5g.fsf@toke.dk> <b14519e81b6d2335bd0cb7dcf074f0d1a4eec707.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 15:47:08 +0100
Message-ID: <87k172gbrn.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: ilZVaj8BN2anY2nBxxUcyw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-12-11 at 15:04 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > Btw, there's *another* issue. You said in the commit log:
>> >=20
>> >     This patch does *not* include any mechanism to wake a throttled TX=
Q again,
>> >     on the assumption that this will happen anyway as a side effect of=
 whatever
>> >     freed the skb (most commonly a TX completion).
>> >=20
>> > Thinking about this some more, I'm not convinced that this assumption
>> > holds. You could have been stopped due to the global limit, and now yo=
u
>> > wake some queue but the TXQ is empty - now you should reschedule some
>> > *other* TXQ since the global limit had kicked in, not the per-TXQ limi=
t,
>> > and prevented dequeuing, no?
>>=20
>> Well if you hit the global limit that means you have 24ms worth of data
>> queued in the hardware; those should be completed in turn, and enable
>> more to be dequeued, no?
>
> Yes, but on which queues?
>
> Say you have some queues - some (Q1-Qn) got a LOT of traffic, and
> another (Q0) just has some interactive traffic.
>
> You could then end up in a situation where you have 24ms queued up on
> Q1-Qn (with n high enough to not have hit the per-queue AQL limit),
> right?
>
> Say also the last frame on Q0 was dequeued by the hardware, but the
> tx_dequeue() got NULL because of the AQL limit having been eaten up by
> all the packets on Q1-Qn.
>
> Now you'll no longer get a new dequeue attempt on Q0 (it was already
> empty last time, so no hardware reclaim to trigger new dequeues), and a
> new dequeue on the *other* queues will not do anything for this queue.

Oh, right, I see; yeah, that could probably happen. I guess we could
either kick all available queues whenever the global limit goes from
"above" to "below"; or we could remove the "return NULL" logic from
tx_dequeue() and rely on next_txq() to throttle. I think the latter is
probably simpler, but I'm a little worried that the throttling will
become too lax (because the driver can keep dequeueing in the same
scheduling round)...

-Toke

