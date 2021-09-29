Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5465241CDA8
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 22:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346820AbhI2U7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 16:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346814AbhI2U7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 16:59:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61725C061766;
        Wed, 29 Sep 2021 13:57:59 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id rm6-20020a17090b3ec600b0019ece2bdd20so3018617pjb.1;
        Wed, 29 Sep 2021 13:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uuv012X9QP66aLKBFKUSvigF4hVX/EMIbUUZ6Wm9ThE=;
        b=QhNPLtw65YMvy2mrqajEF01CyVKSll0La0y0yQDDDnqHwhsNfGYUcA+x8oX2vXPnSZ
         SY29t4c++w1HNYTq64PGotoK79TRWmOPbLYFZoLFV9oYvrcTKN7z5qLHre8pdCQ2oVJy
         2wPk1nEICjPCALUfbC5MxtHD8E8cwTX0PYdub41h7Rxo/81ZmcrSHeNjN3S4ile4VgBg
         bl1bIH0QqH/cAfXvBXP+iH3hJ+cP+Qf/uk6f0dlRU1V/GqawZtRm7lSoOcUX3aAspHyY
         pVNojYrpwOsomWgltXLtf461gby8iRgIV4KTk5ALcALNDCssT8bHgYHTWv1ow4qRjM8O
         AwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uuv012X9QP66aLKBFKUSvigF4hVX/EMIbUUZ6Wm9ThE=;
        b=2i5zciVKQma1bdIppVhq4YTs1UrYz7VS7xKO+A/hcF1HPyHIqEZp6EDgiEzMSoV925
         Cf/ETbL/wzI5IQY4XBBtRHNX/YQGbtPk+4aznIv7HC6Jp4fSkkCYjYmh9hb/eQNWEtJM
         LPjyG8vvfpTCHQD10N+xhi1GpnErK6PpSQi+b8NuM4fMP3Kuq0Z73hDnFOtOHL7C8wE9
         kkwVSO9Jxv661jT8E9XuqPhDRB3MVuOyRUTJW47MljB7G/xisBQi3WAra/Bd8HRi4mmC
         ohxdphTHc0tV37948LUCuIkMihHbJE5WzvxZ2MBildccnsvCcmsCWFFWhmtycUfjtted
         Rmog==
X-Gm-Message-State: AOAM53357lTPd+nAiiJD8RW6OM8v700IQ7qH0CilpZ+7KVdi4XN3ajAU
        VjlS41iK4kSfJOKHXBRv4Aze5xzJlP77KUPt2YE=
X-Google-Smtp-Source: ABdhPJwocTgkBLViVZ3xqdqJqUZ6zVVqC7p+KlmZhWBO8LNx0BvRCzILFlTvm/1lknrQsvtn88oysXbNGZMLfFbNfo8=
X-Received: by 2002:a17:902:bb95:b0:13e:6924:30e5 with SMTP id
 m21-20020a170902bb9500b0013e692430e5mr555019pls.20.1632949078934; Wed, 29 Sep
 2021 13:57:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
 <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
 <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com>
 <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com> <CAM_iQpVaVvaEn2ORfyZQ-FN56pCdE4YPa0r2E+VgyZzvEP31cQ@mail.gmail.com>
In-Reply-To: <CAM_iQpVaVvaEn2ORfyZQ-FN56pCdE4YPa0r2E+VgyZzvEP31cQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 29 Sep 2021 13:57:48 -0700
Message-ID: <CAADnVQJX8OpXhQ66jVSN1ws8tav5R8yCERr6eaS9POA+QhRx-A@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 10:40 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > That's why approaching the goal with more generic ambitions was requested.
>
> This goal has nothing to do with my goal, I am pretty sure we have
> a lot of queues in networking, here I am only interested in Qdisc for
> sure. If you need queues in any other place, it is your job, not mine.

Now it's yours.
Applying queuing discipline to non-skb context may be not your target
but it's a reasonable and practical request to have.
