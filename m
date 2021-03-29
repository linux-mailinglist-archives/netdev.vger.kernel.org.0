Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25CEF34DC29
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232011AbhC2WzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhC2WzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 18:55:15 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797EFC061762;
        Mon, 29 Mar 2021 15:55:15 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f10so10350795pgl.9;
        Mon, 29 Mar 2021 15:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ht62GGZPRnyS8dvd4NCjkjT07Q4MqTk+km0I1yZhWTY=;
        b=HwyKgNOitGx/3X7ftcJLmz7W9668uErAtDYuhHInKoBmXdsQdqtXksyArLTbW4gLfS
         Fs59KOvFP10YSWfZiW5I7mR6evMZd2chJ6sFtBl8A8cqdiP8wGkPL9nUD6nA33uiAjnt
         KTUfTi+4pvSfU2Xd59kb0BiKkZGNNZhrdnmb67HoupJmrx3LPrIrrKu/v8KuUGtypocB
         3vy1f9gPqzXdqED1429Q7k0bWWI9PMq5r/6CthXx675HN4qvbuYQ1oWaH7OncTC3863E
         PR6RXYtvj5Ee1pOKKNHIwz7hSqgp7N8+sdSw8nDig08Uv5bvhofSnEhLj8Mgza4nI5YW
         KmJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ht62GGZPRnyS8dvd4NCjkjT07Q4MqTk+km0I1yZhWTY=;
        b=GEmySfAsorGBrOCq6OaXixCCU3a2RJmxqoBqvj3BClo/nlNtN71lUWVDNtxY3myRSK
         U0lSBCe8x/kadPGRDz7IBUVG6KmkrOli2fN4OHSjMeiLu/8ufUNk6ACwnRsbCxxhSA+I
         t4ActhSa69iQ/EFTqv9cXufcEgihu1TGh9K6Q/ImCHL+Zd6E0a9g90iy29xB2ECZDzNH
         C+OGeq3a++YcM2T1rkbSsUMVvTmXSD3Pu/IfqyeFScdGLkd07k+U9zl3to7wMGtiGB8u
         5yuWBxmFtDokKGlriLePodeSgOD6o3B0WkImFysZ89xJaVHOff5pbMOmKKe2TQEzJCie
         12Fg==
X-Gm-Message-State: AOAM530i3X9OBRdIJyCP2WzRLXbkFjUphKT2kJIFv5lJ+cKO9J8qf/MU
        E/hs832oPj6Ru2IvFDYMD4w4vtdfuIXJug==
X-Google-Smtp-Source: ABdhPJxP5sTkiKIULA3WOs5VQtFR83vjMcIKFQ5KGHRaksdrTsDcy7Ml/n4MHFh3zQLZs3n+RHTQUw==
X-Received: by 2002:a63:3507:: with SMTP id c7mr1791074pga.204.1617058515010;
        Mon, 29 Mar 2021 15:55:15 -0700 (PDT)
Received: from localhost ([112.79.230.77])
        by smtp.gmail.com with ESMTPSA id s12sm17303672pgj.70.2021.03.29.15.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 15:55:14 -0700 (PDT)
Date:   Tue, 30 Mar 2021 04:25:12 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     netdev@vger.kernel.org, Vlad Buslov <vladbu@mellanox.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] net: sched: extend lifetime of new action in replace
 mode
Message-ID: <20210329225512.voaibzkfmyodcxv6@apollo>
References: <20210328064555.93365-1-memxor@gmail.com>
 <ygnhk0pqgwjb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhk0pqgwjb.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 02:35:12PM IST, Vlad Buslov wrote:
> it seems that there are two ways actions are overwritten/deleted:
>
> 1. Directly through action API, which is still serialized by rtnl lock.
>
> 2. Classifier API, which doesn't use rtnl lock anymore and can execute
> concurrently.
>
> Actions created by path 2 also have their bind count incremented which
> prevents them from being deleted by path 1 and cls API can only deleted
> them together with classifier that points to them.
>
> [...]
> So, what happens here is actions were 'deleted' concurrently (their
> tcfa_refcnt decremented by 1)? tcf_action_put_many() will decrement
> refcnt again, it will reach 0, actions get actually deleted and
> tcf_exts_validate() returns with non-error code, but exts->actions
> pointing to freed memory? Doesn't look like the patches fixes the
> described issue, unless I'm missing something.
>

Thanks for the review and comments.

You are absolutely right. This patch was totally broken. Your feedback however
was quite helpful in understanding the code. I sent a v2, please lmk if it's
correct (also with a hopefully thorough description of the problem & solution).

--
Kartikeya
