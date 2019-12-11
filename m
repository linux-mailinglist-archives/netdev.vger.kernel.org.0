Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1211AE77
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 15:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729742AbfLKOzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 09:55:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29755 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729435AbfLKOzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 09:55:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576076121;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/xRV6BaNRtqgbV4uBsZ9UxoINqOvZn7cXzR7XnrwTAM=;
        b=a47CfTUgW4nhJSJUlY0eDS9Ci60xQotpTl3QEJXZ72iIpI76OmhgfqdUpI6MWne5DolWM6
        lJ9zT0/czIOVdpmhGK2xjD3leJfSL+t932lCzg34sOj+/9B4G5KTB7i/yv2OOqglWS4wC+
        Dk24/t39X8vtHVF1vkJ/83Q0eBI+ckw=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-rhFqRgX0Mt-8SoAliaRxmg-1; Wed, 11 Dec 2019 09:55:17 -0500
Received: by mail-lj1-f200.google.com with SMTP id z23so4453249ljk.21
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 06:55:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=9ucwElWdgkQaEklwem1iDH2kvuF3LSBSdbIgBouf/AM=;
        b=VpjEC1GF7PcCcC7dRe6BYzHQECZfClJSuagjmy4qe/PznL0BN0XjeELqXqlXnFSNvO
         v4GMCvsWNVC0rvk4q7u2TqvxTyMsVpWwzBaEi3Ll0tO5d7AY62wN/5NOv8fWzuE6UcvV
         MpfpshZV+65TuxNeJ0udCZvXHViHVdiopPhbD7j8QcVXEoG4kcfazwXWIuYR39bdpdUe
         L8zfdXts3ld8/fzezkx+rjlQdYfItoeRwunV3okolqHJ8HSwLUEBDX6GwIzRX0LyYR0L
         eDYAQFqP0O4p3FQP9RpMzbKjZgdf470OHKpK1IWe3OLaDVLjQ3o9X/rgkqM40VcEq+jY
         A7XQ==
X-Gm-Message-State: APjAAAXJdz//jPQx6AcKS7qCU94ILFKcdKfRXT+1Zu8ouG6cIguZDWBy
        mKiLh8Bw2Q9p+Oo9ANfJ7hogQXSZYbGTmdQ9SU4wxvqwozUrDf0wQ8Au2vkBYN+0VkpEIzSa0Mf
        UUSBgcMz5EBzoN73+
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr2122642ljk.30.1576076115912;
        Wed, 11 Dec 2019 06:55:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqz6Nr+91aIAs23LlUXWGoq9CZxbo/71kgTRBTc7tB10BzoTuzW+r9oMxAtPOzr8tsV54UPBpg==
X-Received: by 2002:a2e:9f52:: with SMTP id v18mr2122628ljk.30.1576076115767;
        Wed, 11 Dec 2019 06:55:15 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e12sm1324145ljj.17.2019.12.11.06.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 06:55:15 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 896F318033F; Wed, 11 Dec 2019 15:55:14 +0100 (CET)
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
In-Reply-To: <e65574ac1bb414c9feb3d51e5cbd643c2907b221.camel@sipsolutions.net>
References: <ceb74ea2-6a1b-4cef-8749-db21a2ee4311@kernel.dk> <d4a48cbdc4b0db7b07b8776a1ee70b140e8a9bbf.camel@sipsolutions.net> <87o8wfeyx5.fsf@toke.dk> <e65574ac1bb414c9feb3d51e5cbd643c2907b221.camel@sipsolutions.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 11 Dec 2019 15:55:14 +0100
Message-ID: <87d0cugbe5.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: rhFqRgX0Mt-8SoAliaRxmg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2019-12-11 at 15:09 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
>>=20
>> If we're doing this on a per-driver basis, let's make it a proper
>> NL80211_EXT_FEATURE and expose it to userspace; that way users can at
>> least discover if it's supported on their device. I can send a patch
>> adding that...
>
> Sure. Just didn't get to that yet, but if you want to send a patch
> that's very welcome. I have to run out now, will be back in the evening
> at most.

Patch here (for those not following linux-wireless):
https://patchwork.kernel.org/project/linux-wireless/list/?series=3D215107

>> Maybe we should untangle this from airtime_flags completely, since if we
>> just use the flags people could conceivably end up disabling it by
>> mistake, couldn't they?
>
> Yes, that sounds like a good plan, now I was wondering why it's there
> anyway.

Convenience, I think :)

-Toke

