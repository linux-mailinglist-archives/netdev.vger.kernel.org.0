Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0245411A8CA
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 11:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfLKKXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 05:23:09 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:26736 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727469AbfLKKXJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 05:23:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576059787;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hM1lsKszqVVW7xdJguXodLHtzH+CDtVuMqOIlsaB+gI=;
        b=R5Qf+fcLtOP6YE0P424/8Y0Selqy/xlEk9ZQNl0rAN+Rr8cT3pfUu1i8UL+7U7LIpKvuvs
        vObXoEmCzWCwCGGEC5fDdNdyJa/S2tmgrhOc5jUWw3sMKD0ixxiiWjqPLQuQ3QhxY7fdg9
        aUOGOUuYmbbGJYahxFgrQon8xqVEEw0=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-mFTuokqIPAGGIVB84mtUGg-1; Wed, 11 Dec 2019 05:23:06 -0500
Received: by mail-lf1-f71.google.com with SMTP id d6so2807526lfl.3
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 02:23:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xtky7BBHwRXTXA6G0HOwZ/5cGWXqDvl3mPuhDaTdQGc=;
        b=sj94mm/c51/COdVPgUPAATw3M3zdzajhXRABWyebIpC+XDGjLT1SUFglBUnhpriCab
         mpCTdgsDJB7w6SzKgxHWGXkE9zf8yGC+khhjmVJTzEPZse06W893E8bUfiAv/ErIPAxV
         25tGD8jG5Uh0biQrkhgbT7djEQzK+gr7Y1mNe0meq9o+ByfjSKRRfyFlTQRPksmx500l
         PLvkLzCS/6+fXPXaEKdv0JnHDfTXxiH3R7bbhUaHasqmYyvLnlIm/jnD+qepBQvrSEmg
         +i/EhSXmgneR6JdwAsBO0VT8bAaNsTFzoYyjKh6DDpt8rTf17ZNPpeS2362CzXwYO8M3
         kwaA==
X-Gm-Message-State: APjAAAXXuZEyB/5Iu0R0BoxxPw8ZLcOIzBYj0A5nHvtQ/lFc6ZDxjQMu
        unndwlTtVew7uq4/fqhsOrEpBtS0V8wnzJiH+j2kpPJFe/ZfNzw12FuV953zsDuHBt3+0fpUENq
        ZO3GbAfy+Mwz05sIR
X-Received: by 2002:a05:651c:112c:: with SMTP id e12mr1524258ljo.169.1576059783758;
        Wed, 11 Dec 2019 02:23:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxqJDm3LCJOvpYWrqQko1RdnmT5mm9x9VwK6WfbjT4PSSxVY1TNatidj+Kqr9o5xXlTc4z+5w==
X-Received: by 2002:a05:651c:112c:: with SMTP id e12mr1524250ljo.169.1576059783585;
        Wed, 11 Dec 2019 02:23:03 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id b17sm861754ljd.5.2019.12.11.02.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 02:23:02 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0D2E518033F; Wed, 11 Dec 2019 11:23:02 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net> <878snjgs5l.fsf@toke.dk> <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 11:23:02 +0100
Message-ID: <875zingnzt.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: mFTuokqIPAGGIVB84mtUGg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-12-11 at 09:53 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
>> > > Hi,
>> > >=20
>> > > Since the GRO issue got fixed, iwlwifi has worked fine for me.
>> > > However, on every boot, I get some warnings:
>> > >=20
>> > > ------------[ cut here ]------------
>> > > STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088=
, 208
>> >=20
>> > Yeah, we've seen a few reports of this.
>>=20
>> FWIW I've tried reproducing but I don't get the error with the 8265 /
>> 8275 chip in my laptop. I've thought about sending a patch for mac80211
>> to just clear the tx_time_est field after calling
>> ieee80211_sta_update_pending_airtime() - that should prevent any errors
>> from double-reporting of skbs (which is what I'm guessing is going on
>> here).
>
> It does feel like it, but I'm not sure how that'd be possible?
>
> OK, I talked with Emmanuel and I think it's the GSO path - it'll end up
> with skb_clone() and then report both of them back.

Right, figured it was something like that; just couldn't find the place
in the driver where it did that from my cursory browsing.

> Regardless, I think I'll probably have to disable AQL and make it more
> opt-in for the driver - I found a bunch of other issues ...

Issues like what? Making it opt-in was going to be my backup plan; I was
kinda hoping we could work out any issues so it would be a "no harm"
kind of thing that could be left as always-on. Maybe that was a bit too
optimistic; but it's also a pain having to keep track of which drivers
have which features/fixes...

-Toke

