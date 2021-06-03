Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC499399B0F
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbhFCGyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 02:54:06 -0400
Received: from mail-pg1-f173.google.com ([209.85.215.173]:41809 "EHLO
        mail-pg1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhFCGyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 02:54:06 -0400
Received: by mail-pg1-f173.google.com with SMTP id r1so4382703pgk.8
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 23:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9XycJN3Z2QtVixsKYzXsAVtV+JUFSqzqxdmsTE6pZCI=;
        b=otXLMBqu9C8yMIXKbfphbBHyfaTFlz3vlpDEPayJFgkJUv9VNDa79NiokwsBSDf4fk
         DPipM34ggkYjMNOtORMJH07mxBssA22x516QiVJYHCEBsBlWaBcEH/5hCGzJA6eKubYx
         HFYImtha2nhYF3xMkdnvOc1nYnNHo/Z00E89AHVSmGhQjnkq66IhdO/k48dulhuCekqv
         truftPEvH+JhXCBwdwbXY8sslu4nfJ/BlO0xtRpsptXgbjuJ1t0hlo103Yp0WAD2BKNQ
         /l/7uUZKc6a9xQiYyb0FBwUz1+flkxsLa41mBcePBZ2Sd26/C3FfGzFy0FbIVGnZjlzS
         aWmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9XycJN3Z2QtVixsKYzXsAVtV+JUFSqzqxdmsTE6pZCI=;
        b=Pcmm99nvMvNm4DnSUEmN83LZkz4p3W3Wb7LGkBH/AaxI4+F002ZFcM8ksTRBt6WtoT
         b05xGRqmrOzy+0JtZIlVQGcUvVZO9PyZ0ElIaNlCKybA3Co7DwpyOxHU10GrE3V+yzDQ
         OzngoOjQ8pj5WlmiEYX+4QI22yUF78mRtEosfQhkf2VGBlOaC9oebM2iLlCI3D4l9trd
         tlvlJhNiPb9+E4yCQ3gg3bow5bgFNojIZctlQnI1/K4sERqJifbl3Zsp5QmTSLEt7bGg
         klc6OiUcDYLlHa4abxVA2F5HAtyKUgK5KiXmV+FnDefy8Yuek4t0J4HpWkOrcJNLH7OT
         Wnrw==
X-Gm-Message-State: AOAM531lyW1Df5H+/gZWd88Sh9K+F7073TLPTLES3ZH9UiFCqxhxB7eq
        kRSd0qoa5FA4d8JmumbkZMQsvA8F5n5aUvIPQYAH5Q==
X-Google-Smtp-Source: ABdhPJyVRv4/kE+k4Aslrczm9l9JWwwxVSFmtu93acoC82cCmhfKylDQuArKPQ0jhEspi/aURX7WZnwAkODihAfEXZw=
X-Received: by 2002:a63:1906:: with SMTP id z6mr37475603pgl.173.1622703070195;
 Wed, 02 Jun 2021 23:51:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210601080538.71036-1-johannes@sipsolutions.net>
 <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
 <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com>
 <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
 <CAMZdPi8Ca3YRaVWGL6Fjd7yfowQcX2V2RYNDNm-2kQdEZ-Z1Bw@mail.gmail.com> <17fd0311eb8b51e6d23fce8b7eb23e3d2581cf54.camel@sipsolutions.net>
In-Reply-To: <17fd0311eb8b51e6d23fce8b7eb23e3d2581cf54.camel@sipsolutions.net>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Thu, 3 Jun 2021 09:00:27 +0200
Message-ID: <CAMZdPi8RQ7580nTLHf+GYavU3CTME76P86haB8VCdVjXxrgqLA@mail.gmail.com>
Subject: Re: [RFC 3/4] wwan: add interface creation support
To:     Johannes Berg <johannes@sipsolutions.net>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Jun 2021 at 10:29, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Wed, 2021-06-02 at 08:52 +0200, Loic Poulain wrote:
> >
> > OK no prob ;-), are you going to resubmit something or do you want I
> > take care of this?
>
> I just respun a v2, but I'm still not able to test any of this (I'm in a
> completely different group than Chetan, just have been helping/advising
> them, so I don't even have their HW).
>
> So if you want to take over at some point and are able to test it, I'd
> much appreciate it.

Thanks for this work, yes I can try testing this with mhi_net.

Chetan, would you be able to test that as well? basically with the two
kernel series (Johannes, Sergey) applied on top of your IOSM one + the
iproute2 changes for the userspace side (Sergey), that should work,
but let us know if any issues.

Regards,
Loic
