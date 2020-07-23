Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EA522A71D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 07:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgGWFzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 01:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbgGWFzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 01:55:22 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901B1C0619DC;
        Wed, 22 Jul 2020 22:55:22 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id w2so2507084pgg.10;
        Wed, 22 Jul 2020 22:55:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=etSFHncgg7r4mzGjmHt/9kGqiemZafuATTVFbIBTcFY=;
        b=Q4IHV0nXh9SbmnWEKPn83HGJ1Z4tgKqIyB/e2fCbJqe3M22dTGrWizItChLKQaj/P5
         NVxm9g2XljfQY+LsWzKZPwEN0Xg9fXOoCPPOEkWOcolrMKGvQBibRdGpzPcVUHNEUIiP
         4gZMqcju8OsyljV40eJg0WGlJa3BcPi5LVe+pPWymrtrCUSWor2H6gethkDVX80dFxTP
         0vNU6T1z6JnV+JpJ9j/SFGB7xXS50JBLnBDxJHMe9nS6mVBERTXx7UD4GausIlaxA+hQ
         97ARxLycfWwT7biqyxeKLaAUpDS1V8xvQuBE8QMYZv3xOGnQvhfSUB+k5oPdJJ1JPgBy
         s+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=etSFHncgg7r4mzGjmHt/9kGqiemZafuATTVFbIBTcFY=;
        b=B8rFYzY7I7fJGz8K8mX4fG7pUux8YK+fE+pX/UO/xfbtRhZyOaDhKx6Hac0TyQgZ59
         qaOhXz/WX/46wDoCOYRiZrqaf0K1gLrniHorVcINjho3fKuli7zHcGf+Ht2DkoQDO2mH
         gwEaaCfCkWQ9OE6kBPXs7JDwZNwyJkx1U4Z2f6q0Avn37p80A5XvKf+AinyPMQpZ2Ozz
         nWg2gdcaLBA1g0BzaQQFGYpVR5pmkOl+waH65pVjEoLmoy4dKD/7RK2lIS93DeVXLD7N
         hascjU31BxXPg3G1LtWuzRuqxV5P7efB5tBQuh1iZkqMUEK1CnPXjsV5rgv3umxDNl8I
         yNSA==
X-Gm-Message-State: AOAM533KezotoHysmG+JP2LBnw3G+ZjTpYQnj7j7/j7WoPXlo8CZjYfI
        Q7czwW9lV/zf45X2eeVXztk=
X-Google-Smtp-Source: ABdhPJwchaE7ldo73CSHbrS4ei8c2gGAwybeV4GQ0H5YOtWzMzh1pidGnm9KWKEvRQpvZoOMkJ410Q==
X-Received: by 2002:a63:df56:: with SMTP id h22mr2815814pgj.140.1595483722008;
        Wed, 22 Jul 2020 22:55:22 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:6cd6])
        by smtp.gmail.com with ESMTPSA id a3sm1540743pgd.73.2020.07.22.22.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 22:55:20 -0700 (PDT)
Date:   Wed, 22 Jul 2020 22:55:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kernel-team@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        brouer@redhat.com, peterz@infradead.org
Subject: Re: [PATCH v4 bpf-next 2/4] bpf: fail PERF_EVENT_IOC_SET_BPF when
 bpf_get_[stack|stackid] cannot work
Message-ID: <20200723055518.onydx7uhmzomt7ud@ast-mbp.dhcp.thefacebook.com>
References: <20200722184210.4078256-1-songliubraving@fb.com>
 <20200722184210.4078256-3-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722184210.4078256-3-songliubraving@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:42:08AM -0700, Song Liu wrote:
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 856d98c36f562..f77d009fcce95 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -9544,6 +9544,24 @@ static int perf_event_set_bpf_handler(struct perf_event *event, u32 prog_fd)
>  	if (IS_ERR(prog))
>  		return PTR_ERR(prog);
>  
> +	if (event->attr.precise_ip &&
> +	    prog->call_get_stack &&
> +	    (!(event->attr.sample_type & __PERF_SAMPLE_CALLCHAIN_EARLY) ||
> +	     event->attr.exclude_callchain_kernel ||
> +	     event->attr.exclude_callchain_user)) {
> +		/*
> +		 * On perf_event with precise_ip, calling bpf_get_stack()
> +		 * may trigger unwinder warnings and occasional crashes.
> +		 * bpf_get_[stack|stackid] works around this issue by using
> +		 * callchain attached to perf_sample_data. If the
> +		 * perf_event does not full (kernel and user) callchain
> +		 * attached to perf_sample_data, do not allow attaching BPF
> +		 * program that calls bpf_get_[stack|stackid].
> +		 */
> +		bpf_prog_put(prog);
> +		return -EINVAL;

I suspect this will be a common error. bpftrace and others will be hitting
this issue and would need to fix how they do perf_event_open.
But EINVAL is too ambiguous and sys_perf_event_open has no ability to
return a string.
So how about we pick some different errno here to make future debugging
a bit less painful?
May be EBADFD or EPROTO or EPROTOTYPE ?
I think anything would be better than EINVAL.
