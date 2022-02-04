Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E697A4A9E94
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 19:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377341AbiBDSEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 13:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377333AbiBDSEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 13:04:14 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE761C061714
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:04:13 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id f10so14121151lfu.8
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 10:04:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wDIfU+3j6l9b6/ovcWV/E/t6nT7MPi/Dpj3iliQZvS8=;
        b=PtACesbQANcJiSPoCcS2TtD2G8NYUkkm94xTzV2ZiJ/bbrCunMW9W2Yk98YJXdy2FV
         ydmVl5OUsqr8HFTzlX7a8Itl0l229BbpkA1m+xWdVe8tSV4YUA6F9fYj8n0lVpKHxlJ/
         LTI+sgt5/b0+NewpZ/rnT5enHtYmnkyZcguZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wDIfU+3j6l9b6/ovcWV/E/t6nT7MPi/Dpj3iliQZvS8=;
        b=LcO3SE9x7BTXvAjh56CDWekSLlCyM9KEYk8mBRfxCRVqfreEmyzd7aSyq3od1dM7VG
         0cp6c+sEG0bsi0R744lW0W0Jru64gTOz+xIZXOh8sklQ0ax08ZO5jjj70nd+ORYuL+9T
         4rUR48cCGskkBlrSfkYV/sRqkYs0UHCkrbuEn2oYKAe56x0FjwiQuSiCOVRUlTQvRnzl
         r7Ck2IApixYHx12b33amO02wvideI0zbrl3WEMZ+EYdYMAmdYNjnUe82tnizG0fPuad0
         +mgG4wkXmkF6QvRKlcWthNbCBjoD58oFSoDCOK7pHtJjfbhn59279rBsQI6ytrr6wCQ5
         itHw==
X-Gm-Message-State: AOAM532QYjoj8BQuF+wetbFeVtqsRUEWLphImhvmMOTV9Pak6Iebi1RG
        5Q3k/zhxrjknTzMeMWhQMMnn6BWmakJUyo5J9SslQw==
X-Google-Smtp-Source: ABdhPJxPPcFJ1hEChC6Sw9O6YbieC8Al+NDIcxdGqh1pD3KyJUnGiHDDRwAIDMe7Of1XypSN2arDpNDRdthnI1w+7Rs=
X-Received: by 2002:a05:6512:db:: with SMTP id c27mr78808lfp.582.1643997851848;
 Fri, 04 Feb 2022 10:04:11 -0800 (PST)
MIME-Version: 1.0
References: <1643933373-6590-1-git-send-email-jdamato@fastly.com> <87fsoybuno.fsf@toke.dk>
In-Reply-To: <87fsoybuno.fsf@toke.dk>
From:   Joe Damato <jdamato@fastly.com>
Date:   Fri, 4 Feb 2022 10:04:00 -0800
Message-ID: <CALALjgyAwkiB+Q8LXLeq+EkOx4izjUN0GRmtf_e2LEdLxJgTDw@mail.gmail.com>
Subject: Re: [net-next v4 00/11] page_pool: Add page_pool stat counters
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 5:58 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> Joe Damato <jdamato@fastly.com> writes:
>
> > Greetings:
> >
> > Welcome to v4.
> >
> > This revision changes stats to be per-cpu and per-pool after getting
> > feedback from Ilias, Tariq, and Jesper.
>
> FYI, Jesper is on holiday until the 12th, so it may be be a little while
> until he gets back to you on this :)

Thanks for letting me know.

I've queued some changes per Ilias' feedback for the v5, but perhaps I
should hold off on submitting those until Jesper has returned and has
a chance to take a look at this revision.

Thanks,
Joe
