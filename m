Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390103D503F
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 23:51:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhGYVKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 17:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhGYVKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Jul 2021 17:10:52 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD499C061757;
        Sun, 25 Jul 2021 14:51:21 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hb6so13362606ejc.8;
        Sun, 25 Jul 2021 14:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kFFpVV/YF+QL4JQFeELRHZFZz7qvosg04j6ZnFdvTeU=;
        b=khzUHGhCGsGSD3KyIdvGqupNwkL50ImtEIJM1wX76Ngs0jiT2NDsCjiPD+DJ4n5Uxk
         Vx1UFIaSN9xN7lrtvhdRuw4AoZqc9T3xqv+eQz1+KX9cLasxSqzpZtAcR9rhPVgPwPYd
         i2FO9L4cYPy6dbhd8NQfeVHJeielBxcHFYTZAERBUH0KBBBmYHeN2TJ3qRiXR9yWBrmp
         hgdvy44H9RdhB+GLRz87/xvmkVykIzob7wkbaA2JnSbrUCqyDBrrWlNWqeTKj3mzAx8b
         FRJrNbwbQkpkkIucNsaLOLwQfLBVhcnrkGUVcLKyijTvWACcxJLax6JDvVk5ro/qOQz1
         H27Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kFFpVV/YF+QL4JQFeELRHZFZz7qvosg04j6ZnFdvTeU=;
        b=g1u6Jl0TWBCljJPYTZC4zzKYZE11z75gjOpy+FJxvEWJX8LNKZoHWUcHzfcmT3Yrio
         cHZnzst2xt2tLPotJBt3/nuE6yYC8FpvXxqc0GSVuSjn+B+bbzLIMn0kzEamNWWBpuuT
         YP1WQSzHgBWdb9ivh14NO9zheiRGnMzPBTk4KVHq9vfccl5CzoBuTSBgrWuX0Hup1335
         Vcw80qtoajHbFdDZkfJLEEG2NI/oevpU7U35kkFsvjVW5Zkyt1YSJ+oA0PfdCc1SiRUT
         QsNiEpnmp7ZU5xVNOk2Iog/iskBm8NFzE66i0QybX7rMxcauwuuRA/6mCM3FDRgVkHEh
         c3JQ==
X-Gm-Message-State: AOAM531sJLcQkb/qpi0+VJOtVdnsJX41E8Z1AaQkGfz/pz98d2sL/ly1
        ib+JGq2bZPS4mV/MJqrzbvvxieCUaQ5/V9/bm+o=
X-Google-Smtp-Source: ABdhPJzvm01A0bsNE0cJ0/+LnHjhgn585tTLQpFf/N5biMmWi4+J0wwYuAhpycqE1rO8SyjY/8Mg/4xUJO8NWBhw6wo=
X-Received: by 2002:a17:907:9719:: with SMTP id jg25mr14198373ejc.362.1627249880289;
 Sun, 25 Jul 2021 14:51:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-4-martin.blumenstingl@googlemail.com> <27d8246ef3c9755b3e6e908188ca36f7b0fab3fc.camel@sipsolutions.net>
In-Reply-To: <27d8246ef3c9755b3e6e908188ca36f7b0fab3fc.camel@sipsolutions.net>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Sun, 25 Jul 2021 23:51:09 +0200
Message-ID: <CAFBinCAzoPmtvH1Wn9dY4pFsERQ5N+0xXRG=UB1eEGe_qTf+6w@mail.gmail.com>
Subject: Re: [PATCH RFC v1 3/7] rtw88: Use rtw_iterate_stas where the iterator
 reads or writes registers
To:     Johannes Berg <johannes@sipsolutions.net>, pkshih@realtek.com
Cc:     linux-wireless@vger.kernel.org, tony0620emma@gmail.com,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Content-Type: multipart/mixed; boundary="00000000000013706305c7f9a3d5"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000013706305c7f9a3d5
Content-Type: text/plain; charset="UTF-8"

Hi Johannes, Hi Ping-Ke,

On Mon, Jul 19, 2021 at 8:36 AM Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Sat, 2021-07-17 at 22:40 +0200, Martin Blumenstingl wrote:
> >
> > --- a/drivers/net/wireless/realtek/rtw88/mac80211.c
> > +++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
> > @@ -721,7 +721,7 @@ static void rtw_ra_mask_info_update(struct rtw_dev *rtwdev,
> >       br_data.rtwdev = rtwdev;
> >       br_data.vif = vif;
> >       br_data.mask = mask;
> > -     rtw_iterate_stas_atomic(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
> > +     rtw_iterate_stas(rtwdev, rtw_ra_mask_info_update_iter, &br_data);
>
> And then you pretty much immediately break that invariant here, namely
> that you're calling this within the set_bitrate_mask() method called by
> mac80211.
you are right, I was not aware of this

> That's not actually fundamentally broken today, but it does *severely*
> restrict what we can do in mac80211 wrt. locking, and I really don't
> want to keep the dozen or so locks forever, this needs simplification
> because clearly we don't even know what should be under what lock.
To me it's also not clear what the goal of the whole locking is.
The lock in ieee80211_iterate_stations_atomic is obviously for the
mac80211-internal state-machine
But I *believe* that there's a second purpose (rtw88 specific) -
here's my understanding of that part:
- rtw_sta_info contains a "mac_id" which is an identifier for a
specific station used by the rtw88 driver and is shared with the
firmware
- rtw_ops_sta_{add,remove} uses rtwdev->mutex to protect the rtw88
side of this "mac_id" identifier
- (for some reason rtw_update_sta_info doesn't use rtwdev->mutex)

So now I am wondering if the ieee80211_iterate_stations_atomic lock is
also used to protect any modifications to rtw_sta_info.
Ping-Ke, I am wondering if the attached patch (untested - to better
demonstrate what I want to say) would:
- allow us to move the register write outside of
ieee80211_iterate_stations_atomic
- mean we can keep ieee80211_iterate_stations_atomic (instead of the
non-atomic variant)
- protect the code managing the "mac_id" with rtwdev->mutex consistently

> The other cases look OK, it's being called from outside contexts
> (wowlan, etc.)
Thanks for reviewing this Johannes!


Best regards,
Martin

--00000000000013706305c7f9a3d5
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="rtw_update_sta_info-outside-rtw_iterate_stas_atomic.patch"
Content-Disposition: attachment; 
	filename="rtw_update_sta_info-outside-rtw_iterate_stas_atomic.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_krjqed3y0>
X-Attachment-Id: f_krjqed3y0

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFjODAyMTEu
YyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFjODAyMTEuYwppbmRleCA3
NjUwYTFjYTBlOWUuLmJlMzljNmQwZWUzMSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9tYWM4MDIxMS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3Jl
YWx0ZWsvcnR3ODgvbWFjODAyMTEuYwpAQCAtNjg5LDYgKzY4OSw4IEBAIHN0cnVjdCBydHdfaXRl
cl9iaXRyYXRlX21hc2tfZGF0YSB7CiAJc3RydWN0IHJ0d19kZXYgKnJ0d2RldjsKIAlzdHJ1Y3Qg
aWVlZTgwMjExX3ZpZiAqdmlmOwogCWNvbnN0IHN0cnVjdCBjZmc4MDIxMV9iaXRyYXRlX21hc2sg
Km1hc2s7CisJdW5zaWduZWQgaW50IG51bV9zaTsKKwlzdHJ1Y3QgcnR3X3N0YV9pbmZvICpzaVtS
VFdfTUFYX01BQ19JRF9OVU1dOwogfTsKIAogc3RhdGljIHZvaWQgcnR3X3JhX21hc2tfaW5mb191
cGRhdGVfaXRlcih2b2lkICpkYXRhLCBzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhKQpAQCAtNzA5
LDcgKzcxMSw4IEBAIHN0YXRpYyB2b2lkIHJ0d19yYV9tYXNrX2luZm9fdXBkYXRlX2l0ZXIodm9p
ZCAqZGF0YSwgc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSkKIAl9CiAKIAlzaS0+dXNlX2NmZ19t
YXNrID0gdHJ1ZTsKLQlydHdfdXBkYXRlX3N0YV9pbmZvKGJyX2RhdGEtPnJ0d2Rldiwgc2kpOwor
CisJYnJfZGF0YS0+c2lbYnJfZGF0YS0+bnVtX3NpKytdID0gc2k7CiB9CiAKIHN0YXRpYyB2b2lk
IHJ0d19yYV9tYXNrX2luZm9fdXBkYXRlKHN0cnVjdCBydHdfZGV2ICpydHdkZXYsCkBAIC03MTcs
MTEgKzcyMCwyMCBAQCBzdGF0aWMgdm9pZCBydHdfcmFfbWFza19pbmZvX3VwZGF0ZShzdHJ1Y3Qg
cnR3X2RldiAqcnR3ZGV2LAogCQkJCSAgICBjb25zdCBzdHJ1Y3QgY2ZnODAyMTFfYml0cmF0ZV9t
YXNrICptYXNrKQogewogCXN0cnVjdCBydHdfaXRlcl9iaXRyYXRlX21hc2tfZGF0YSBicl9kYXRh
OworCXVuc2lnbmVkIGludCBpOworCisJbXV0ZXhfbG9jaygmcnR3ZGV2LT5tdXRleCk7CiAKIAli
cl9kYXRhLnJ0d2RldiA9IHJ0d2RldjsKIAlicl9kYXRhLnZpZiA9IHZpZjsKIAlicl9kYXRhLm1h
c2sgPSBtYXNrOwotCXJ0d19pdGVyYXRlX3N0YXMocnR3ZGV2LCBydHdfcmFfbWFza19pbmZvX3Vw
ZGF0ZV9pdGVyLCAmYnJfZGF0YSk7CisJYnJfZGF0YS5udW1fc2kgPSAwOworCXJ0d19pdGVyYXRl
X3N0YXNfYXRvbWljKHJ0d2RldiwgcnR3X3JhX21hc2tfaW5mb191cGRhdGVfaXRlciwgJmJyX2Rh
dGEpOworCisJZm9yIChpID0gMDsgaSA8IGJyX2RhdGEubnVtX3NpOyBpKyspCisJCXJ0d191cGRh
dGVfc3RhX2luZm8ocnR3ZGV2LCBicl9kYXRhLnNpW2ldKTsKKworCW11dGV4X3VubG9jaygmcnR3
ZGV2LT5tdXRleCk7CiB9CiAKIHN0YXRpYyBpbnQgcnR3X29wc19zZXRfYml0cmF0ZV9tYXNrKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LAo=
--00000000000013706305c7f9a3d5--
