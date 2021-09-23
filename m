Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF05841555D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 04:05:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238876AbhIWCHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 22:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238832AbhIWCHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 22:07:11 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2297C061574;
        Wed, 22 Sep 2021 19:05:40 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id l6so2991932plh.9;
        Wed, 22 Sep 2021 19:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=25/K6IHNQ8vrEpZbcXpenMo4mHxaIzsW78v7ge5900c=;
        b=jgDixe+kcBVyKy7DS2mKqHTFvi/g1nc/mLfI4NTBv2BC8MLCvkvJoZNUA4e0sXQJGk
         AR1ShcuCtByCj5fFP6VJq4x+hkD2uJXrPuo8lpP2hrmHF/ps6q1WBS+Q18Ye3s2JlgRV
         Z1eC6RGAmGwE31ySjnyunJDfkxsWCOk7jiGZMZizAoYbVo6zd8MalmDnISp2uovAgjaR
         W9jVqMvh9EsskYU8wvdf8Hawi0gm8xD5ddZj4E5F/My5ULlzwh7N6l18u6D14u9k7/2g
         6IV1jyFLs1IcjeISh0fn15yptZ9PT+UeHNe9vkmEI1brGkEZ0FrO43w0Hw0y9I+ncOGn
         cJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=25/K6IHNQ8vrEpZbcXpenMo4mHxaIzsW78v7ge5900c=;
        b=bHgCLUQcDVLyeDLyQk3FcKN0/VBkzbMMf9QzUftHfldfoz0d80GN1Es07jHgHIO/jv
         Mckyo19LzetREyqWJyfICM+qEKcKNsshmeC1nHdfAhJmOpKzQWqo1yS9Q2hwHSqOJUlN
         gaF4zcuyani7CcYMNTWXl/VScKnRjTyDcKLcU55GqYm8qYsskMnsKYDCnR+y4Wcsg7Uj
         BZYL6lmiMZ4rOlqdWKEQ/VvN+0k3fAAfDKVWjN85rTIwOLxtE2NU9A7shaXYVV0lBXdd
         xTd98ksW+LTQCiVifu9oqU8Q7ImqX7DUbkzqV4vyCU/hUWHwYlNX7eA2RxU8JGw6wWYW
         ea+A==
X-Gm-Message-State: AOAM531dP3MHYLgU+6OfuQ+1Vk9D/DG/WqTFgWUC21tp8YsWeIL1nLXz
        A5yZD8aEa1FtiRQjRSKUvG69e6IJfNjELzkWIjc=
X-Google-Smtp-Source: ABdhPJz3NyXZ+EqTkv7EFpVKBAbBCzdfqLkdj+r7WYpPCswBaaNPzLsZYgqyfSpcwmLNNjEnSIPzQg367M95tSAYAks=
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr2459193pjh.62.1632362740215;
 Wed, 22 Sep 2021 19:05:40 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
 <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com>
 <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com> <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
In-Reply-To: <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Sep 2021 19:05:29 -0700
Message-ID: <CAADnVQJSjbQC1wWAf_Js9h47iMge7O3L8zmYh7Mu8j4psMBf7g@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 6:49 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> At the same time Toke mentioned that he has a prototype of suck skb map.

This is such an embarrassing typo :) Sorry Toke. s/suck/such/ in above.
