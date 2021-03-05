Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AC832E258
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCEGi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbhCEGiZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:38:25 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF00DC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 22:38:24 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id 133so830194ybd.5
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vysTjqZSTQjTU0H70ChtUfzPoo2MuqPEeEzUbFwyFbQ=;
        b=V9vEZgMi8Sykwu7lbyM46NxrRGUElSOFBbXRDHDVGXsRmUuMSDGv5Sp0iDk+9q17nh
         9AihKABX8NngwlxnoKrJTKOGGG3/oEQ8uEU0hxy8UJIdbFBO2NvqcVzMjcJghlS5YsyN
         EHOjpm1f3tRrQT8hy/u129UKpdQt+VpN3sXEf8q+8JHK/60ECyX2NfNwGjfAMmosQWZ7
         CfJwdoiMWDR/Lt6PVo6FTsCjtxKC3iMBZzMDDRJSrxsXed4niq8QG9glv3BYdkCifqXZ
         X2wgoaD+5Sx1FXA977pyYSq2tz3VORL3No/Mlazdu0nOduTSNwiZKrTrqaWecy+EzqtX
         3ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vysTjqZSTQjTU0H70ChtUfzPoo2MuqPEeEzUbFwyFbQ=;
        b=o6It5M8+yCBdY60YgQY3cL0SfejVZO2v9ZFmEUJO6Sac5RGsZKiaCiJdXaymMgghOl
         G+SOsNp0wCmplZmZRTCgLwdZbE0S0ciueupifJ0y+1zhtO6mEBRLAQoB0Wik53CLFgB4
         oMXoYJjxheT3kEs607ARnSd1R9BB0EJb9j73H9gCNuVc+jzYHRuscde+Ndv4v9RYIGwy
         BypIeNJkGsIzAavLFMoKvSxDDOHXPRT+M5GiZ731w3kjfoB+0xCVMyPR7wSXnpEHzm6W
         mdxpNuodiefjBdxLN/o29mnQj5nlRZBVFFEE/5kW8SoGZ/hAtCzKy+khzPQlOiID2+n8
         b0lQ==
X-Gm-Message-State: AOAM530mm5hD8lCRLboOZLfp92AJWNzT6IB42qDz1Kk70BY+208RQqH+
        nevBsFOfgXEaJA/DGLXiCNHGtMuTEFu4m3vvVBuJlg==
X-Google-Smtp-Source: ABdhPJx5qFE29NNO9j5475+f4MojyleTrEisXv0WLkTpXUFX2kYQwPPmmBJwGbn4L2okcFzZtsU+IuiOnz1SKT0otRM=
X-Received: by 2002:a25:1d88:: with SMTP id d130mr12217712ybd.446.1614926303689;
 Thu, 04 Mar 2021 22:38:23 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
 <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
 <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
 <CANn89iLBi=2VzpiUBZPHaPHCeqqoFE-JmB0KAsf-vxaPvkvcxA@mail.gmail.com>
 <20210304152709.4e91bd8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iJKH37CMUuq66nERZQoMHFp+yuTe=yqxm1kf+RQ1RfHzw@mail.gmail.com> <CANn89iK_MORZmk4waXn3vfHYDZfz4AdqfQ5hrEr0Pwo8DMZG4w@mail.gmail.com>
In-Reply-To: <CANn89iK_MORZmk4waXn3vfHYDZfz4AdqfQ5hrEr0Pwo8DMZG4w@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 5 Mar 2021 07:38:11 +0100
Message-ID: <CANn89i+6jnMVuNqAi8pYXCCXTXgVJfWJDtuXFtVFRBO-0sz4dw@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 6:33 AM Eric Dumazet <edumazet@google.com> wrote:

> Actually this might be a good thing : We now resend the whole data in
> a TSO packet, now
> we call the standard rtx queue mechanism, instead of sending only one MSS
>
> I will look at other test failures today (Friday) before submitting a
> patch series officially.
>

Well, there is also this part to sort out.

WARN_ON(tp->retrans_out != 0);

in tcp_fastretrans_alert()
