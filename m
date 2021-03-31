Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF234FBC7
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234441AbhCaIiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234460AbhCaIiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:38:07 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A9F9C061574;
        Wed, 31 Mar 2021 01:38:07 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id k8so4544105pgf.4;
        Wed, 31 Mar 2021 01:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rVfOGwc7N0VJCdVKF46G/HWJiscqeO0qIVu0S3Sqog8=;
        b=W7u1XW/Y1n/3m5M9kyOUgiFLjtU1GP3707wLT8VU+B32QrPwc2TI7TbbloiDrIqj9K
         PTmrYPvRKY2lpyGGTRfba4DTFRFAPsIariAOAzjGZ/eFkJaoBij6fHDtekFukexA6Lxk
         nQQaxQ8LzUNBq0dWTxZJEpvfueau9Pc0XvrEeBdE1gM84m+++bsiN4m3zZCCj+E/EG1D
         HgbPcCePNZ+tOcUtCZHHfYGkCNojo5yQHT3GmoWDidPVkCS/FKL7hbbZEmIM6Aorv70E
         bjgBM/cIX+k4qTNV4TusEeJG53sdT5hKPeK0P0VOHqlgX2+CE5g4OOIQsRZtiPlKrR57
         VDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rVfOGwc7N0VJCdVKF46G/HWJiscqeO0qIVu0S3Sqog8=;
        b=HzIekjT8hm7nPNZEKaQW1zXB3XytmJ1qq7P0AZwHy562TP/sCFPvMUtIQK5AhiuHzv
         1Xfkh6dEBTe+ZlOYs2UXbF2x1B4OwKpYt7ApAtUC1VyvSYtBYY2Y6XV6dTWVzsIpOtVD
         6uigymCWMdbW4+TSXVlC5fCVNuh6QWvNlkFDxK6wNDQOfZPklT4bRdBs8cZ7fCpmzcL1
         Gb3O4Z2wMBBO1zWHyQg+ehnN6Iw6GOajlRXJy8tGInj+HlF6mtlOhMhU7lMFROihyctz
         XF6wO58YYh9h9I6Uq2fP3GKhBjlWS3X0YEMwfqoesC6r+1kGz/oUPhrrRA+5YoaR+jD8
         6byA==
X-Gm-Message-State: AOAM533zhN7GsKgZNbG+7h9xG7oKWRmCDpuLL3swL4euYYqUMlkwLXXH
        OanyxV4j5yQ5Bdrk4lQhPv8=
X-Google-Smtp-Source: ABdhPJwbOv3NtKi9yNSPaoLkIs8pbRDWSG541Yp7vBBElHIzg+0t5N+pAs8SZuq07rrqDQw7f9bNbg==
X-Received: by 2002:a63:c4f:: with SMTP id 15mr2179066pgm.379.1617179886832;
        Wed, 31 Mar 2021 01:38:06 -0700 (PDT)
Received: from localhost ([47.8.37.177])
        by smtp.gmail.com with ESMTPSA id j3sm1480659pfi.74.2021.03.31.01.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 01:38:06 -0700 (PDT)
Date:   Wed, 31 Mar 2021 14:08:00 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Vlad Buslov <vladbu@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH v2 1/1] net: sched: bump refcount for new action in ACT
 replace mode
Message-ID: <20210331083800.b3b2ewfgxklo76ri@apollo>
References: <20210329225322.143135-1-memxor@gmail.com>
 <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVAo+Zxus-FC59xzwcmbS7UOi6F8kNMzsrEVrBY2YRtNA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 10:10:45AM IST, Cong Wang wrote:
> On Mon, Mar 29, 2021 at 3:55 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> > diff --git a/net/sched/act_api.c b/net/sched/act_api.c
> > index b919826939e0..43cceb924976 100644
> > --- a/net/sched/act_api.c
> > +++ b/net/sched/act_api.c
> > @@ -1042,6 +1042,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
> >         if (err != ACT_P_CREATED)
> >                 module_put(a_o->owner);
> >
> > +       if (!bind && ovr && err == ACT_P_CREATED)
> > +               refcount_set(&a->tcfa_refcnt, 2);
> > +
>
> Hmm, if we set the refcnt to 2 here, how could tcf_action_destroy()
> destroy them when we rollback from a failure in the middle of the loop
> in tcf_action_init()?
>

You are right, it wouldn't. I sent a new version with a fix. PTAL.

> Thanks.

--
Kartikeya
