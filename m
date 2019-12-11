Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221C211A649
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 09:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfLKIxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 03:53:18 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22625 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726983AbfLKIxS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 03:53:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576054396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ErN/Wg7v3eiCe0Kx9UO/6mPJH73V49FsTdeJpQaYLfg=;
        b=PPTERP/jZBI9ppL71ptLGVJrSZDALjQL70kgk2W+Uf2DwrX6szRUIGVhtvNA6yb9nQlBH4
        S9mxbydWDCLYQQ8Xg0AlSvnzAwgY3afVzRJIvo75RhB3vE3u1gvS+FeN7AsUYVoNl0hqZM
        Xj8zGk9MHwFbX7s94l5GnfMsFbzq0Hk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-naSJLOusMSq_mFQmKa3e4A-1; Wed, 11 Dec 2019 03:53:14 -0500
Received: by mail-lf1-f70.google.com with SMTP id y4so4859771lfg.1
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 00:53:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pZtJTilsJZlUcalnSJQYHRduUjW4Lu05sEgNkR0v5cc=;
        b=Ja3T0P+1Kj7D68HZzxhO9Vd+GepSGCSIPYIr1CFVrzqjj1YPjucVyAhjI5g38h4wPX
         9o4nhYPmf/EplYBmqpIh+yXlUDsTUlUAaIER/CByj6C1qz2SS9+mbuOEAMfNjNmdHLW2
         aR5c7328FhwqIpAGu4ruPpiHEGU+iGKSh37FZJnmHbRzrgqRfE9vqWrl4BLzo37T4H7f
         ylm6sgaH/6HGaI+/MPCHVYKGOKPbNmWm3AXg7pIQd5qo8luFHWbXRMDsaAJHx4VkQfv5
         z34BruAVsqaaJUi6nqDjr5Fs9MDduCp2LqR0bL0vDbUfPDSEVHsikIXKF/1wsgr+5YIz
         c5sQ==
X-Gm-Message-State: APjAAAXSsya5oDeTMs/c9UjmODh0F7UCOwTuruQ2rD1cpiwK84aGBtTl
        s6JPdtpKGlGYAHfldZ+gauPliWGHtP+xs9gbp6nFhXABwE53qavJ2ze7MyCFn2H8jm2KNK8nHJx
        saL65QEFbXSmmSJ+f
X-Received: by 2002:a2e:2201:: with SMTP id i1mr1191571lji.110.1576054392776;
        Wed, 11 Dec 2019 00:53:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqxzv9/7GEytOxrzOgMa5SPSHN1QlJE2sj9Zc1uAwuE1YS00Wxmllztzk/j/zIsSMKOfS3I0CQ==
X-Received: by 2002:a2e:2201:: with SMTP id i1mr1191555lji.110.1576054392609;
        Wed, 11 Dec 2019 00:53:12 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v26sm765021lfq.73.2019.12.11.00.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:53:11 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 9C5D318033F; Wed, 11 Dec 2019 09:53:10 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Jens Axboe <axboe@kernel.dk>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Subject: Re: iwlwifi warnings in 5.5-rc1
In-Reply-To: <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <9727368004ceef03f72d259b0779c2cf401432e1.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 09:53:10 +0100
Message-ID: <878snjgs5l.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: naSJLOusMSq_mFQmKa3e4A-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2019-12-10 at 13:46 -0700, Jens Axboe wrote:
>> Hi,
>>=20
>> Since the GRO issue got fixed, iwlwifi has worked fine for me.
>> However, on every boot, I get some warnings:
>>=20
>> ------------[ cut here ]------------
>> STA b4:75:0e:99:1f:e0 AC 2 txq pending airtime underflow: 4294967088, 20=
8
>
> Yeah, we've seen a few reports of this.

FWIW I've tried reproducing but I don't get the error with the 8265 /
8275 chip in my laptop. I've thought about sending a patch for mac80211
to just clear the tx_time_est field after calling
ieee80211_sta_update_pending_airtime() - that should prevent any errors
from double-reporting of skbs (which is what I'm guessing is going on
here). However, it kinda feels like a band-aid so I'd much rather figure
out why this particular driver/device combo cause this :)

> I guess I kinda feel responsible for this since I merged the AQL work,
> I'll take a look as soon as I can.

Sounds good, thanks!

-Toke

