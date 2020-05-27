Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8DB41E3DC6
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 11:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgE0JnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 05:43:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728033AbgE0JnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 05:43:03 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0382DC061A0F
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:43:03 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id h3so806194ilh.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 02:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aVqzR27AIqxwzI3AHjWSCEF4CV2hGa90eHUS5tjJUOI=;
        b=ZiRvdO8dF+rEfzYc1rit6aQ/5D+xJvHDFWrlWlUXQu3AB13d4pT8CeYxOuXVo0GLPl
         dBYfuSM30SLtnzyS6GqFlFgeCai7AfV8F15dmUKNmNM7WOdAnd/m0u82ZPILdYCcrY85
         /YBq6ij7cPZ8II3HA19JecZSNZdEOHKrx4py54bhL7DpStP2a/ige5GfRgs4ASEUfR6s
         N7rO9caA2oANaX4Kb6UFUHy3LMdvB5VXp4AnPT9R50bPlLEd/HZQSp1THwXvlxhjv9vg
         sriIO2YVmd/6iLxirNeVakrLHO5+UkkaoOGOaxj1OCmVZkpPXLqz2zi9gRc2TJUDKJwm
         NCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aVqzR27AIqxwzI3AHjWSCEF4CV2hGa90eHUS5tjJUOI=;
        b=bbCK52US/STtWA7rD7v0WuF5M85YWkJbsHVA+CyU2nGYa8/KDu9Yve9pKGLhwdmbLq
         1vo1CutLIuIL44YuiHvz/4DT5A28YqcJZ9bfNslypF2a1dZGTVgjhxp1RGRDVlNQMKaX
         C90mj9l32wO6oTAkkciQrra+LYhejRwIF05YyZUKOj2io94qykvwEL45r3/bEL0h2y99
         yuhh4N3Js09MR0c7SF5pjR7+BTWhV/2gUhYgYUqz/RSnA5CZOwzGq0LnodpLjqkg8CmI
         LnADE8j3ajo7LmZ1XBHJcqq8Hj+98GfAe2+8cUnRSgy80H53CYYQdNcPtbD2MNy3OUJQ
         pR9A==
X-Gm-Message-State: AOAM533BIVpzebxMfyC/ysp0CXWlmawapBqYDPOyT9Q+H7NTVsOtMqAI
        3PCVc/FEE45RwcImCfB0j98qsgU8ghiJpzAz0R96aw==
X-Google-Smtp-Source: ABdhPJxeTIpbj1RF6bc4MPPMw8lxn30BBF60nQ56iZpKolBkc2/ClaNe+nUoDJv3UwC3H2O8yJWZ/wFVlJV3SzJ/AdI=
X-Received: by 2002:a92:9f4b:: with SMTP id u72mr4902611ili.273.1590572582163;
 Wed, 27 May 2020 02:43:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200519120748.115833-1-brambonne@google.com> <CAKD1Yr2T2S__ZpPOwvwcUqbm=60E9OGODD7RXq+dUFAGQkWPWA@mail.gmail.com>
 <CABWXKLxGwWdYhzuUPFukUZ4F7=yHsYg+BJBi=OViyc42WSfKJg@mail.gmail.com>
 <20200520.113349.506785638582427245.davem@davemloft.net> <CABWXKLxQYEMu9sDu+5RF+xfqGERUH19nq7hxukcohgxr43uRuQ@mail.gmail.com>
In-Reply-To: <CABWXKLxQYEMu9sDu+5RF+xfqGERUH19nq7hxukcohgxr43uRuQ@mail.gmail.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 27 May 2020 18:42:50 +0900
Message-ID: <CAKD1Yr2JaH_5+wzqz3jaY9QPo9F1+vyVZh2=KY0VBMKH9shBbg@mail.gmail.com>
Subject: Re: [PATCH] ipv6: Add IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC mode
To:     =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Linux NetDev <netdev@vger.kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 6:30 PM Bram Bonn=C3=A9 <brambonne@google.com> wrot=
e:
> Thanks David. I was able to test the behavior of changing the MAC
> while connected to a network. It does not seem to trigger address
> generation, leaving the link-local address intact.
>
> Do we know about any scenarios (apart from dev reconfiguration) that
> would trigger address generation? My understanding based on the code
> is that any other scenario would add an additional link-local address,
> rather than removing the old one.

I don't think the stack ever regenerates link-local addresses after
the first one. I think the question was what happens to global
addresses if the MAC address is changed and then an RA is received.
Will the stack create a new global IFA_F_STABLE_PRIVACY address, such
that there are now two stable privacy addresses on the same interface?

That seems strange, but still, I suppose you could say that the user
got what they asked for. They configured IPv6 addressing that is "as
stable as the MAC address", and then they changed the MAC address,
and, well, they got a new IPv6 address. Is there anything in RFC 7217
that prohibits or discourages this? If not, maybe it's fine.

Perhaps you can add a test for what happens by adding a test case here:

https://cs.android.com/android/platform/superproject/+/master:kernel/tests/=
net/test/multinetwork_test.py;l=3D796

I think you'll need to do that anyway in order to use this on Android.
