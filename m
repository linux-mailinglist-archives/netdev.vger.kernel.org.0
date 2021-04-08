Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A781358F7D
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbhDHVxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhDHVw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 17:52:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9D7C061760
        for <netdev@vger.kernel.org>; Thu,  8 Apr 2021 14:52:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ot17-20020a17090b3b51b0290109c9ac3c34so3931103pjb.4
        for <netdev@vger.kernel.org>; Thu, 08 Apr 2021 14:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oxZjP8Fy4uwceT34YLMHl/zu6zPqT0r8gzHKbQMomG8=;
        b=qBVrrwWQyXCuZU5P8412lXCIiMjz2gWnZQMpmMQGBONbvVbrSGRgSwSduQUI24iF5o
         exn61eogomc1uczxIopD9miTNHUCjd6W3kNxRMLy11Dj0iQdG0PcJUNogLJ4xA2fKZuh
         IFYazXbFQNFnAlfxD9582vjWptP2W9LtaW3X8vpIXPupwKTpQ1w5B7WHM5WHPIUIu7Yt
         c621V19HfC0Ru8e6vTe1aQejOCvpLP3H8+pf4/99iTgBNYUWNHSJk6XbTo5PZdTFS3j6
         Mz1vo0EXnmgrRnwjc/tOSquaSRkvxpKcbmMTs26mRyL+4iLUdCICcvjtkWs6aDjsySsF
         sgAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oxZjP8Fy4uwceT34YLMHl/zu6zPqT0r8gzHKbQMomG8=;
        b=bJDj3RRULcn+07W9pkllK4gScfGLth+Pix5AKVb1U95Y9i2BMjfiDhqN22PSU4/OT4
         JvkabWu8BAa87CPU/E5FaXS9A4xdq83KzXc9uSGfFbO4RxgNQKD0VqyHvygRmZlvrape
         aZKp6/dTdOK5hs973WIpm27LAlTo2mrN9lTQQpGlpyNYx6qZQWm8DILV/VRjbFTJob8r
         mbpijeLKxluqIj05aW5J/X0lic/RJzbiZp/+dTU8ZdpYH7RpD3IunJlNNTMGHvYjA+46
         k7c5yMp0O+NdFBjA8BK0qvg9fWGmnzVS9E/rCJ114khKwzT1nNq3kD+137nbvngV8xMN
         cFxA==
X-Gm-Message-State: AOAM530yeYMClp1FKqubwJ+SvHHxNmkECcwI/S3iL1f43ghlW+IDHU8W
        qwaZua6/BXZGKgx7YPtFz8G0zbN//qwAXyyt7wlzuP6f9vA=
X-Google-Smtp-Source: ABdhPJwkLkEAfmp6Wvss+Yjq7Eq5+Zo8GSVTG+tbFIa1Ym16kHbspd+up5dQSLXzOIIrWIf38dMqpXQ8c7lZows3pkU=
X-Received: by 2002:a17:902:8347:b029:e7:4a2d:6589 with SMTP id
 z7-20020a1709028347b02900e74a2d6589mr10052954pln.64.1617918764189; Thu, 08
 Apr 2021 14:52:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210407153604.1680079-1-vladbu@nvidia.com> <20210407153604.1680079-3-vladbu@nvidia.com>
 <CAM_iQpXEGs-Sq-SjNrewEyQJ7p2-KUxL5-eUvWs0XTKGoh7BsQ@mail.gmail.com> <ygnhsg419pw7.fsf@nvidia.com>
In-Reply-To: <ygnhsg419pw7.fsf@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 8 Apr 2021 14:52:32 -0700
Message-ID: <CAM_iQpUD_Fv8tLQXyoKYeC3pxXFmqMOZR1v4V6E7EKgUQpEm1g@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net: sched: fix action overwrite reference counting
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 8, 2021 at 12:50 AM Vlad Buslov <vladbu@nvidia.com> wrote:
>
>
> On Thu 08 Apr 2021 at 02:50, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > In my last comments, I actually meant whether we can avoid this
> > 'init_res[]' array. Since here you want to check whether an action
> > returned by tcf_action_init_1() is a new one or an existing one, how
> > about checking its refcnt? Something like:
> >
> >   act = tcf_action_init_1(...);
> >   if (IS_ERR(act)) {
> >     err = PTR_ERR(act);
> >     goto err;
> >   }
> >   if (refcount_read(&act->tcfa_refcnt) == 1) {
> >     // we know this is a newly allocated one
> >   }
> >
> > Thanks.
>
> Hmm, I don't think this would work in general case. Consider following
> cases:
>
> 1. Action existed during init as filter action(refcnt=1), init overwrote
> it setting refcnt=2, by the time we got to checking tcfa_refcnt filter
> has been deleted (refcnt=1) so code will incorrectly assume that it has
> created the action.
>
> 2. We need this check in tcf_action_add() to release the refcnt in case
> of overwriting existing actions, but by that time actions are already
> accessible though idr, so even in case when new action has been created
> (refcnt=1) it could already been referenced by concurrently created
> filter (refcnt=2).

Hmm, I nearly forgot RTNL is lifted for some cases along TC filter
and action control paths... It seems we have no better way to work
around this.

Thanks.
