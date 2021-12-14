Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF16C473D65
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 08:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhLNHFr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 02:05:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhLNHFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 02:05:46 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93553C061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 23:05:46 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id z6so17054846pfe.7
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 23:05:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u9uJx6Yzs8VAbaAVVWgb3c7raYuZyWdXpq+qPzpYeZM=;
        b=Y902Ahq4o+Npt/dUrRkpBbcRT1bmljFp51/i3oPcGlXJnJK0PhKJX5yQ3f1r9oaTY3
         63IgklBVpGUo8EV/WJeEfGD8UDZI17HHrx6WTahkqndWYAD+tl/V+PXNJ+9rZjMopQhw
         mqSCgdxe/1fFY1aX0trqSTX62HRVMPvQ3qmJaoZevziFRcZj7igLkY/AQ4twp2YUhI5y
         y2AWFMxffDJZx9Ewy7w9BKfWe+/MZJt6uNuTPE1YQOd0xBtAOd1f6C3bb6z65vyfpfpX
         hCQdjonogxPVWUY+5WAPOpSqxw3D6BPAgNoTUmmIc2KXwWSlwjykpoEgntMBrQD5QRWC
         BWUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u9uJx6Yzs8VAbaAVVWgb3c7raYuZyWdXpq+qPzpYeZM=;
        b=OmMBZSI4cfGQBMVKsZmfhnnfMnliK57uYrFA7nL+QkdF7AjodPku/i4qXZxrXsDcmW
         42HC4ZXz4HPwQW907sElXJvKJRFty5atJXiLNxr9Nkk7XXeeIuSV9Nv4ySuZtT3bi798
         X3m5uTX57S9LFMbgVOPJQDj0BjDS3GoPxd7ygcRgzjhLhAhQZP4mwThZ5pQuKYnCQwA1
         GKm5zs2w8qPVOdjaDwk+F6gE7Rxp6K4604UNuNilMSe2CR74IDWN1jGUqvtGD+bLYATV
         oenP0USgsI7NQ3IABIUA+TyVAILyWLYDOXHwnCinXfWoNZKdCQUORueUK+sqMtoNFhbc
         z7hA==
X-Gm-Message-State: AOAM530MSQGLrFH0G2/lEIypcd+CWnJsRBCqr+UNxqN5e+u7JxsX4ESS
        dB/a/XN5MiGRj0HKDhanM5/evg==
X-Google-Smtp-Source: ABdhPJz65bi9c7M0fZgffgbxVusSpsiNlfIGYC1wjPy5i0UuQiVHxioVmPTqUEQV+R+LXxo5SjqWTw==
X-Received: by 2002:a05:6a00:22c3:b0:4b6:197:ae5a with SMTP id f3-20020a056a0022c300b004b60197ae5amr1474920pfj.42.1639465545684;
        Mon, 13 Dec 2021 23:05:45 -0800 (PST)
Received: from leoy-ThinkPad-X240s ([134.195.101.46])
        by smtp.gmail.com with ESMTPSA id fw21sm1238200pjb.25.2021.12.13.23.05.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 23:05:45 -0800 (PST)
Date:   Tue, 14 Dec 2021 15:05:34 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Balbir Singh <bsingharora@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mike Leach <mike.leach@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, coresight@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, codalist@coda.cs.cmu.edu,
        linux-audit@redhat.com
Subject: Re: [PATCH v2 4/7] connector/cn_proc: Use task_is_in_init_pid_ns()
Message-ID: <20211214070534.GA1721898@leoy-ThinkPad-X240s>
References: <20211208083320.472503-1-leo.yan@linaro.org>
 <20211208083320.472503-5-leo.yan@linaro.org>
 <YbgyiIZDDaOB93Em@balbir-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbgyiIZDDaOB93Em@balbir-desktop>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 04:58:32PM +1100, Balbir Singh wrote:
> On Wed, Dec 08, 2021 at 04:33:17PM +0800, Leo Yan wrote:
> > This patch replaces open code with task_is_in_init_pid_ns() to check if
> > a task is in root PID namespace.
> > 
> > Signed-off-by: Leo Yan <leo.yan@linaro.org>
> > ---
> >  drivers/connector/cn_proc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
> > index 646ad385e490..ccac1c453080 100644
> > --- a/drivers/connector/cn_proc.c
> > +++ b/drivers/connector/cn_proc.c
> > @@ -358,7 +358,7 @@ static void cn_proc_mcast_ctl(struct cn_msg *msg,
> >  	 * other namespaces.
> >  	 */
> >  	if ((current_user_ns() != &init_user_ns) ||
> > -	    (task_active_pid_ns(current) != &init_pid_ns))
> > +	    !task_is_in_init_pid_ns(current))
> >  		return;
> >
> 
> Sounds like there might scope for other wrappers - is_current_in_user_init_ns()

Indeed, for new wrapper is_current_in_user_init_ns(), I searched kernel
and located there have multiple places use open code.  If no one works
on this refactoring, I will send a new patchset for it separately.

> Acked-by: Balbir Singh <bsingharora@gmail.com>

Thank you for review, Balbir!  Also thanks review from Leon and
Suzuki.

Leo
