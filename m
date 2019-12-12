Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 405E811CB7E
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 11:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728873AbfLLKz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 05:55:58 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43198 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728722AbfLLKz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 05:55:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576148157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GVuBPnfR/HUS/yWuKBmjrvaEvLDIt8r0mtmDvQvQWOM=;
        b=g8tatkdnF4c6mxO7ufHhdGvKpWyTSoS7Lb626hI/AtACLtKEn+Sh6hkORwRGwcEzHPOxQQ
        5rteGgVKnZ30qxK4LjICNHEly4zpN0jVl2HWgjeOLeJDGsF8bWkHN4X8hg8aAtD+WspocQ
        XzbPgCDq2YCcsuBe/AB0Gqawn9Pb8dQ=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-ShmickerNjmLrJ6Ey_zjsA-1; Thu, 12 Dec 2019 05:55:56 -0500
X-MC-Unique: ShmickerNjmLrJ6Ey_zjsA-1
Received: by mail-lf1-f70.google.com with SMTP id c16so485379lfm.10
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 02:55:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=GVuBPnfR/HUS/yWuKBmjrvaEvLDIt8r0mtmDvQvQWOM=;
        b=Wgm6RYxiJ46BE13M5yW3cH3Ad4UFx53BxINJyk7KWx9pTgf6tE0iziE8gdW2O1D2su
         8TdJ7nAic7u0rnzvtOsJQ/VE/NYbXjxAYG6NCQhMwKm3eEqO08M8SHr3Mg0z5fhMCf1P
         n0TVrydpiSr1xHhORnmVvzs/HG1ZPrnyNRflMq9iHzrDpl/rnVadkjACWlV6ZDyZGkzl
         B8M3x+DztNnXj5Dz66IkHZEMagleYlBTZ66xR+T2zkvIVPSqFY5OH08wLMoQK/Y2370u
         v/COCUg7aqJn+NR+Pt0bZN9rmLyAyRskl/igXfDS6B1jw3U++wqCuX7OamasN2d1XPK0
         eKNA==
X-Gm-Message-State: APjAAAVXsYYOyuvetVA1F1CCOPKc5fy372IddeyK/5dBeHnpapQ3/B7O
        HXGBzvNRlM/K4LyLAK0yWaArMT39sYHp8NHOvLjMncRWdvpM5CM3rmiZGpdXhBAcW+8T3rg3R8T
        rFIUKvy1+Afr7TOY6
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr5586819ljc.27.1576148154768;
        Thu, 12 Dec 2019 02:55:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqzQulJb9cL64aWnAVkDEjCXAkMtslsz6volfbLipNj/bndQRMaE4qy42O8bTfWr0N4Tt16Qug==
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr5586810ljc.27.1576148154561;
        Thu, 12 Dec 2019 02:55:54 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v26sm2783102lfq.73.2019.12.12.02.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 02:55:53 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7FE311819EA; Thu, 12 Dec 2019 11:55:52 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Steve French <smfrench@gmail.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <5d82fa60fa8170c6a41e87650785ba008da11826.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net> <87o8wfeyx5.fsf@toke.dk> <e65574ac1bb414c9feb3d51e5cbd643c2907b221.camel@sipsolutions.net> <87d0cugbe5.fsf@toke.dk> <5d82fa60fa8170c6a41e87650785ba008da11826.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Dec 2019 11:55:52 +0100
Message-ID: <87sglpert3.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-12-11 at 15:55 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Johannes Berg <johannes@sipsolutions.net> writes:
>>=20
>> > On Wed, 2019-12-11 at 15:09 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wr=
ote:
>> > > If we're doing this on a per-driver basis, let's make it a proper
>> > > NL80211_EXT_FEATURE and expose it to userspace; that way users can at
>> > > least discover if it's supported on their device. I can send a patch
>> > > adding that...
>> >=20
>> > Sure. Just didn't get to that yet, but if you want to send a patch
>> > that's very welcome. I have to run out now, will be back in the evening
>> > at most.
>>=20
>> Patch here (for those not following linux-wireless):
>> https://patchwork.kernel.org/project/linux-wireless/list/?series=3D215107
>
> Thanks!
>
> Maybe I should roll that into a single patch so it's actually easier to
> apply as a bugfix while keeping ath10k on AQL for 5.5, otherwise it
> could be argued that the ath10k patch is a feature for -next ...

Yeah, good point. Since it seems I'm sending a v2 anyway, I'll combine
the two for that...

-Toke

