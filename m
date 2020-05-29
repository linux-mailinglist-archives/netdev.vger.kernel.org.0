Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444621E74D4
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 06:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgE2E01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 00:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2E0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 00:26:24 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6E07C08C5C6;
        Thu, 28 May 2020 21:26:24 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id k22so536060pls.10;
        Thu, 28 May 2020 21:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QAwruukUMW1HUOCfl1F4ET8bfY+WJbFgJ5/JcXJqvaA=;
        b=fq2Ck8j+m9qq8TSEU5itXiVwQ4Pc4MOqkC6MOO/oOSeZc2Svpp8MirtR1buvf793cr
         QjUXtAXMSAEORgbw3Z+HvPWrJvDeqdgFjwZ6v5O/IUCorNBtelETKQ3AEi1KozNq0TGv
         srysn/RqWtzCjpHEhakD/pbnX5izG+PPnlqMXPnuGm6+qvihBcAgu5ItX61kSGhbDT89
         J64nZtQm4t+a/WOXvRst0dRwDFn7IGenxGPjKPuyU9U7BGRI6ojmy5u8rZDc9XbRKJ2t
         a9aLSzWqkvA+Wd0bq2zf1UiP4YSTPKKzSpRn5iQdJRV1udRCVhccy6nHcQlGs/ozHbhr
         yfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QAwruukUMW1HUOCfl1F4ET8bfY+WJbFgJ5/JcXJqvaA=;
        b=r8gS+b3JTfVusyAP5u8Abk9fu2C4xDISMXQ1pmeD2qs79pnMWpTzkzllkMBAaVnp11
         1AL1KlSCdP/Z/qghEfqZcEE8xz0kLrof4V9+UcK68MhvFO1C+g3OqVEUvwtpX6FKcC/j
         avqGPycm/bFwiseG/zLY1Id065ydWpm2KGNEQ8ondo2uJlUCtRhXaKhpo2Ls9ga4C1C0
         pgCBR289Qgr3ZE9PSArr2S3YT0U9TnkWQ5EFINt89tuqGh2sIu1MXVfBYT6ipLlpPmIM
         1JrnGwWROCJgRADndiaR7GD8Uh2gf9njWuCKsLhLm8dMoTE8FELJH3pvMczKYHwjJ+uS
         ZVXg==
X-Gm-Message-State: AOAM531MjdM8czU5XAk5MG6f8h226nwmiPD4FETjEPH1y+GS9lOfsQoD
        H9QgCjEpQQAhJw20vR7lj5w=
X-Google-Smtp-Source: ABdhPJxcI4V0c2C+rvnJRXgn7fBIsLGzdKcctUyUi7zbOnx8hXA2tWlgp2EGGrka3Wj7cKNbqnx7Xg==
X-Received: by 2002:a17:902:b217:: with SMTP id t23mr6863300plr.183.1590726384193;
        Thu, 28 May 2020 21:26:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4a1c])
        by smtp.gmail.com with ESMTPSA id b4sm5956372pfo.140.2020.05.28.21.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 21:26:23 -0700 (PDT)
Date:   Thu, 28 May 2020 21:26:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     KP Singh <kpsingh@chromium.org>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce sleepable BPF programs
Message-ID: <20200529042620.747i342nizywycyv@ast-mbp.dhcp.thefacebook.com>
References: <20200528053334.89293-1-alexei.starovoitov@gmail.com>
 <20200528053334.89293-2-alexei.starovoitov@gmail.com>
 <20200528221227.GA217782@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200528221227.GA217782@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 12:12:27AM +0200, KP Singh wrote:
> > +			if (ret)
> > +				verbose(env, "%s() is not modifiable\n",
> > +					prog->aux->attach_func_name);
> > +		} else if (prog->aux->sleepable && prog->type == BPF_PROG_TYPE_TRACING) {
> > +			/* fentry/fexit progs can be sleepable only if they are
> > +			 * attached to ALLOW_ERROR_INJECTION or security_*() funcs.
> > +			 * LSM progs check that they are attached to bpf_lsm_*() funcs
> > +			 * which are sleepable too.
> 
> I know of one LSM hook which is not sleepable and is executed in an
> RCU callback i.e. task_free. I don't think t's a problem to run under
> SRCU for that (I tried it and it does not cause any issues).
> 
> We can add a blacklisting mechanism later for the sleepable flags or
> just the sleeping helpers (based on some of the work going on to
> whitelist functions for helper usage).

Good catch. *_task_free() are not sleepable. I'll introduce a simple
blacklist for now. Since I'm not adding actual sleeping helpers in this
patch set nothing is broken, but it will give us the base to build stuff on top.
