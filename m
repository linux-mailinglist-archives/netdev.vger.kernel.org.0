Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 262FF11AD02
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729877AbfLKOFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:05:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729686AbfLKOFF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:05:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576073104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=StIwrr6DiPVKFPlnlboJLDOKadEa6n2fz2fdl4s30Mo=;
        b=KloWcJzxNpTbGWkzxgV/Vlu43XIVCVxJqsWdBZfZw+OdRPsJ7ReUdcF3QLcFPf5w4QJyQ0
        W1cRx9+LFLO+vDZuaiFvfLkdmEl7etOsv78thcxYgjyNpMqTTGWBJbBBKobUPuvqXCxMP3
        Uz7HFopCg6RyMbUwOdfqMtL7IkRNEos=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-93-nNMRCQ3NOuWHR_4Yjt4IRA-1; Wed, 11 Dec 2019 09:05:02 -0500
Received: by mail-lf1-f70.google.com with SMTP id a11so5055054lff.12
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:05:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=rXYd5E3GGY67cV6y2ES2WF64lJpRnllNrekC9v/TCy0=;
        b=FSYMEtLsYM55wpIoeP4veHCXuhJdHmJEmIiLljZLapzJHPBVGN9/MtpESqBRIhRDyZ
         PgOcIWOcMBZzuKmKbCLNPbRpSw8ZytvkpkSS3KLrRSO8VJU485dzQBw+to/Q8IbPI/u/
         6lLhsoU3TGolVuxJTdZG3jz6tqo7kqyOBh6ZnC+iTIwUUAUHDwd+qBNivDji2DDLyqMw
         SCNzs0tyD3pJ95/v9dPQUpTInqpQaekuZaXrba3hjnglhTLg/6ebWGIMRuQCZukPRBNH
         Rx+TAa5REE7iUDx8NVIS2yaQ4p5yUeWBTKu/8vUKIuK4uCn46R1m+WUPDju1StuxU0Gd
         Y4Hg==
X-Gm-Message-State: APjAAAWebJdxQYyGn6EjrPqRiJrr5WiB1KktKcONgUmmsgf7Khq6d24R
        2SJBzyryLjnM8wLv40PSk9xTCiDRiSLHBPVlty9VS6aQ8Tu6FxgziZqdPy449Whi2T7sWtl8pTB
        7+3b+l9riCKI0JEyx
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr2168408ljp.22.1576073101105;
        Wed, 11 Dec 2019 06:05:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqxnPP5sggaD4AQ3op+KNXfSHW0erfYVnF+khRRz45HXniArvp0gpfieBpJJzB4ogPT5qbBV9A==
X-Received: by 2002:a05:651c:327:: with SMTP id b7mr2168398ljp.22.1576073100955;
        Wed, 11 Dec 2019 06:05:00 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id z13sm1247604ljh.21.2019.12.11.06.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:05:00 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8623318033F; Wed, 11 Dec 2019 15:04:59 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <14bbfcc8408500704c46701251546e7ff65c6fd0.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net> <878snjgs5l.fsf@toke.dk> <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net> <875zingnzt.fsf@toke.dk> <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net> <14bbfcc8408500704c46701251546e7ff65c6fd0.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 15:04:59 +0100
Message-ID: <87r21bez5g.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: nNMRCQ3NOuWHR_4Yjt4IRA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> Btw, there's *another* issue. You said in the commit log:
>
>     This patch does *not* include any mechanism to wake a throttled TXQ a=
gain,
>     on the assumption that this will happen anyway as a side effect of wh=
atever
>     freed the skb (most commonly a TX completion).
>
> Thinking about this some more, I'm not convinced that this assumption
> holds. You could have been stopped due to the global limit, and now you
> wake some queue but the TXQ is empty - now you should reschedule some
> *other* TXQ since the global limit had kicked in, not the per-TXQ limit,
> and prevented dequeuing, no?

Well if you hit the global limit that means you have 24ms worth of data
queued in the hardware; those should be completed in turn, and enable
more to be dequeued, no?

-Toke

