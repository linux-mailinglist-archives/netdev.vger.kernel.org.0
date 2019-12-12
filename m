Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6976A11CB71
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728865AbfLLKz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:55:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45806 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728784AbfLLKz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:55:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576148125;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tViCQG3lsrEoLFHJxHOiQKzVD2qVe3ldyRDKWpQIP6E=;
        b=Hbdl9RLKT1tnmLsW4VH95+R7tETzjynAnkGxAs9CUlwkzLETAcMoS55HX6je0aSWtJbu8x
        q8Fu2agwCUqw+c5f8mCILQ3GmzGv4Z3KFGsGiiJ8HAbkkL+iH8Oe1uTA6kcZTWYixHU8l0
        +Lcwd0o+mlNGCvMeuGO5JzPRIVrzxSg=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-70i_D3gZNpmx9W3ub80mqA-1; Thu, 12 Dec 2019 05:55:24 -0500
X-MC-Unique: 70i_D3gZNpmx9W3ub80mqA-1
Received: by mail-lf1-f72.google.com with SMTP id a11so480710lff.12
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 02:55:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=tViCQG3lsrEoLFHJxHOiQKzVD2qVe3ldyRDKWpQIP6E=;
        b=PAeAClN19cn0feH9nTQ3ewSMu8sL9PqK2QhrROthDqpVLQAe9W7kOcrXFnLrPRZnK5
         HrNSnza7xGyo/U9jrMMR32OENLjRvH1+mHPkELebCgIrjcuUB8ExnweLEWeErUtexUVA
         fvsdpirEcrS99XcKplnM40M1VwVtmRC5BfNqPwGagHCn6HyXCX/Z1gtO06G7zeuBTb12
         BD4PqstfuCl6Od1DZobjOygLxtHF2eUa6kYTjy9REGxIqEMPo7Oqy5DAXiIUbwtJnT6l
         NR75YL9/nPCSV3Lvg7SLSUAewjZpxAo8vN4hrlgAgUrljAiO3NmBIWfjnRpIu8UACJn6
         O9bw==
X-Gm-Message-State: APjAAAX359x63xOgOMjA3cB+O39eAa+if24bdF/GvETSclClv7EDNaUA
        LfAMSHIHfLWMKy2TaO/bjHT/LJJpUqKGmEQXShVeLwLJScNH96a/dAvmOQ3R1/PSckYLlY+zSso
        EB1xvPRM/GbExoEP1
X-Received: by 2002:ac2:5088:: with SMTP id f8mr5221539lfm.163.1576148122892;
        Thu, 12 Dec 2019 02:55:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwrQLxv9HuKyygd+IzL7zmMbMbX/4g6UlQhyF2/5QjIA9HBx51WjxChDUCOaA3NDttDiXpI1Q==
X-Received: by 2002:ac2:5088:: with SMTP id f8mr5221531lfm.163.1576148122650;
        Thu, 12 Dec 2019 02:55:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id u19sm2795521ljk.75.2019.12.12.02.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 02:55:21 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 77DC11819EA; Thu, 12 Dec 2019 11:55:19 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <3ca2be96898e9d30c27b2411148d201318e413f2.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net> <878snjgs5l.fsf@toke.dk> <3420d73e667b01ec64bf0cc9da6232b41e862860.camel@sipsolutions.net> <875zingnzt.fsf@toke.dk> <bfab4987668990ea8d86a98f3e87c3fa31403745.camel@sipsolutions.net> <87tv67ez9p.fsf@toke.dk> <3ca2be96898e9d30c27b2411148d201318e413f2.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Dec 2019 11:55:19 +0100
Message-ID: <87v9qleru0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-12-11 at 15:02 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>> > 2) GSO/TSO like what we have - it's not really clear how to handle it.
>> >    The airtime estimate will shoot *way* up (64kB frame) once that fra=
me
>> >    enters, and then ... should it "trickle back down" as the generated=
=20
>> >    parts are transmitted? But then the driver needs to split up the
>> >    airtime estimate? Or should it just go back down entirely? On the
>> >    first frame? That might overshoot. On the last frame? Opposite
>> >    problem ...
>>=20
>> Well, ideally it would be divided out over the component packets; but
>> yeah, who is going to do that?
>
> I'm not even sure we *can* do this easily - do we know up-front how many
> packets this will expand to? We should know, but it might not be so easy
> given the abstraction layers. We could guess and if it's wrong just set
> it to 0 on any remaining ones.

I was thinking about a scheme where we re-defined the value in the cb to
be a "time per byte" value, that we could just multiply by the packet
length; that would make it trivial to do partial reporting. Not sure
it's quite workable in practice, though; it would be hard to avoid
rounding errors, and there's also the additional headers when splitting
a packet, so the lengths don't necessarily add up.

>> I think reporting it on the first packet
>> would be the safest if we had to choose.=20
>
> Agree.
>
>> Also, ideally we would want the GSO/TSO mechanism to lower the size
>> of the superpackets at lower rates (does it?). At higher rates this
>> matters less...
>
> Well TCP does limit (pacing shift) the amount of outstanding data, so if
> it's _really_ slow I guess it will also limit the size of the
> superpackets?

Yeah, I *think* it does... :)

> It's really just an artifact of our software implementation that we
> report the SKBs back as used with partial content. Maybe we shouldn't
> even do that, since they weren't generated by mac80211 in the first
> place, and only report the original skb or something.

Hmm, yeah, was wondering how that works, actually. I assumed you send
the whole thing to the hardware as one superpacket? But if so how do you
get the completion events back? Or are you splitting it in the driver
just before you send it to the hardware?

>> > 3) I'm not quite convinced that all drivers report the TX rate
>> >    completely correctly in the status, some don't even use this path
>> >    but the ieee80211_tx_status_ext() which doesn't update the rate.
>> >=20
>> > 4) Probably most importantly, this is completely broken with HE because
>> >    there's currently no way to report HE rates in the TX status at all!
>> >    I just worked around that in our driver for 'iw' reporting purposes
>> >    by implementing the rate reporting in the sta_statistics callback,
>> >    but that data won't be used by the airtime estimates.
>>=20
>> Hmm, yeah, both of those are good points. I guess I just kinda assumed
>> that the drivers were already doing the right thing there... :)
>
> I'm not really sure I want to rely on this - this was never really
> needed *functionally*, just from a *statistics* point of view (e.g. "iw
> link" or such).

Right, I see. Well I guess now that we're turning this on one driver at
a time, we can ensure that the driver provides sufficiently accurate
rate information as part of that.

BTW, since we're discussing this in the context of iwlwifi: do you have
any data as to how much benefit AQL would be for that? I.e., do the
Intel devices tend to buffer a lot of data in hardware/firmware?

>> > Now, (1) probably doesn't matter, the estimates don't need to be that
>> > accurate. (2) I'm not sure how to solve; (3) and (4) could both be
>> > solved by having some mechanism of the rate scaling to tell us what the
>> > current rate is whenever it updates, rather than relying on the
>> > last_rate. Really we should do that much more, and even phase out
>> > last_rate entirely, it's a stupid concept.
>>=20
>> Yes, that last bit would be good!
>
> We already partially have this, we have a 'get best rate' or so callback
> in the rate scaling, we'd just have to extend it to the driver ops for
> offloaded rate scaling.
>
> Ideally, it'd be a function call from the rate scaling to mac80211 so we
> don't have to call a function every time we need the value, but the rate
> scaling just calls us whenever it updates. This would even work with
> iwlwifi's offloaded algorithm - it notifies the host on all changes.

Yup, this makes sense, and would be easy to integrate with Minstrel as
well, I think. We already have ieee80211_sta_set_expected_throughput(),
so maybe expanding that? It just provides a single number now, but we
could change it to set the full rate info instead?

-Toke

