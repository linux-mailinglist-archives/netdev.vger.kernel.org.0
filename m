Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAA94000CF
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 15:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244232AbhICNzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 09:55:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235443AbhICNzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 09:55:36 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374F0C061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 06:54:36 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id y144so5820410qkb.6
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 06:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Fi9bNLDhSuf32Na/ilvZJ4ae0s2j/usTZf0dw8/hLEs=;
        b=pmHbQ5Mn3UmHmoieMtB/idwHiyIJ/qWcga1CEO7VM8yN6DTMhOdWuxmMLmr7f3ulot
         9xa3EiDcgBBe5SG+6flLW5+EWMdG346NDC2JvRVk3I2oPIq6U6iAQHKmburFcLWbztA9
         teAP57HdjeuO5BB+Hn0MYMJFBNeRIhrEiqVV/EZRDoZ3oYmUkGO8Agvg/VwB27Xpm+O4
         FsbFYuV/ojdvYvh4DrTKGKRQO8LNIzVIq54N0fB5vaBgCBvyP71kIWuMs8fnqmHqeAmy
         BT5OaAuNA/k8bn2omaL4vaLWTLApap+2N0mL9I5f+L71tmEMLe+j/dqNU3sE9I4amk65
         fTdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Fi9bNLDhSuf32Na/ilvZJ4ae0s2j/usTZf0dw8/hLEs=;
        b=A9McvVYLUwLnXqhL6QQC0PZZ5w5TWUJwUrC7A3d0sYF7GysbdSB8SNM80ncOWGN3AX
         dyqLYEPjdRgQR7kfd1glfV0s8Q/3a19zTAHQnobA4QOGfw6r0xCC1uVD3jUuxJAxdeHL
         eYFFmG4qmyRKy4hBREVqsh6WjuPqVSFAdMH+jZFYLo1xSnzSzbKAG9e04zJ31fbGKPDk
         D72WSTrx80WqlDGLiQi9AiNWUaNvvdSmGE4i2bJpZLRXSVerq3e8nbibCQVdOQcM6z8U
         20HZfaJX26wPOUUPy1pQtcbcOIOgWL9PzlswN8uGros/n4L+k0O/g3NpE/dESunuT+ya
         9Rpg==
X-Gm-Message-State: AOAM531NMclkgQwggANXSshjoogYyY2F7U7bWByTCM448srACIN9lZcl
        wvGDTX2AB4l7ss0X4djZcP9yu4yM8P9QIJC+7vWN22lAg3o=
X-Google-Smtp-Source: ABdhPJwKHNN2e/CCoHNAB3qBS+SCJJM47AZBBCTp96Qx9iyrbjCnSAtN3eTTxYBw+PJW0LJK+Yynd/IG4pUCNoZuIfk=
X-Received: by 2002:a05:620a:11ab:: with SMTP id c11mr3519888qkk.169.1630677275288;
 Fri, 03 Sep 2021 06:54:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAAP7ucKuS9p_hkR5gMWiM984Hvt09iNQEt32tCFDCT5p0fqg4Q@mail.gmail.com>
 <c0e14605e9bc650aca26b8c3920e9aba@codeaurora.org> <CAAP7ucK7EeBPJHt9XFp7bd5cGXtH5w2VGgh3yD7OA9SYd5JkJw@mail.gmail.com>
 <77b850933d9af8ddbc21f5908ca0764d@codeaurora.org> <CAAP7ucJRbg58Yqcx-qFFUuu=_=3Ss1HE1ZW4XGrm0KsSXnwdmA@mail.gmail.com>
 <13972ac97ffe7a10fd85fe03dc84dc02@codeaurora.org> <87bl6aqrat.fsf@miraculix.mork.no>
 <CAAP7ucLDFPMG08syrcnKKrX-+MS4_-tpPzZSfMOD6_7G-zq4gQ@mail.gmail.com>
 <2c2d1204842f457bb0d0b2c4cd58847d@codeaurora.org> <87sfzlplr2.fsf@miraculix.mork.no>
 <394353d6f31303c64b0d26bc5268aca7@codeaurora.org> <CAGRyCJEekOwNwdtzMoW7LYGzDDcaoDdc-n5L+rJ9LgfbckFzXQ@mail.gmail.com>
 <7aac9ee90376e4757e5f2ebc4948ebed@codeaurora.org> <87tujtamk5.fsf@miraculix.mork.no>
In-Reply-To: <87tujtamk5.fsf@miraculix.mork.no>
From:   Daniele Palmas <dnlplm@gmail.com>
Date:   Fri, 3 Sep 2021 15:55:00 +0200
Message-ID: <CAGRyCJGCT5GgFQOCb01zotGBpC66-r2X7EVru-S04i=Sgw9CSA@mail.gmail.com>
Subject: Re: RMNET QMAP data aggregation with size greater than 16384
To:     =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Aleksander Morgado <aleksander@aleksander.es>,
        Network Development <netdev@vger.kernel.org>,
        Sean Tranchetti <stranche@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Il giorno ven 13 ago 2021 alle ore 08:25 Bj=C3=B8rn Mork <bjorn@mork.no> ha=
 scritto:
>
> subashab@codeaurora.org writes:
>
> >> Just an heads-up that when I proposed that urb size there were doubts
> >> about the value (see
> >> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992=
-1-dnlplm@gmail.com/#2523774
> >> and
> >> https://patchwork.ozlabs.org/project/netdev/patch/20200909091302.20992=
-1-dnlplm@gmail.com/#2523958):
> >> it is true that this time you are setting the size just when qmap is
> >> enabled, but I think that Carl's comment about low-cat chipsets could
> >> still apply.
> >> Thanks,
> >> Daniele
> >>
> >
> > Thanks for bringing this up.
> >
> > Looks like a tunable would be needed to satisfy all users.
> > Perhaps we can use 32k as default in mux and passthrough mode but
> > allow for changes
> > there if needed through a sysfs.
>
> Sounds reasonable to me.
>

I have done a bit of testing both with qmi_wwann qmap implementation
and rmnet, so far everything seems to be working fine.

Thanks,
Daniele

>
>
> Bj=C3=B8rn
