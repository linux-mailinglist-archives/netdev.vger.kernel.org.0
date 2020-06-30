Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04EA210087
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 01:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgF3XlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 19:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgF3XlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 19:41:20 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4B4FC061755;
        Tue, 30 Jun 2020 16:41:20 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id o22so5148692pjw.2;
        Tue, 30 Jun 2020 16:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=546eyQZzdn5dQ5fv+SxUu0FgZG591hjvbFsj/UlLnBo=;
        b=lnz2fqgGhmgGVgtoRUETlZRJHWPONNa+KVRMofgll+5Xz2UGVIuL3lg1xcaTipGfIa
         NIYgkgN457aNQRntT5cK41WgPo8f0ZYIymmXx01EQhQhdHNixVegl7VMDqPfkypeOoPs
         Aa3TMAxQSh/xGrhHPp56KJo63MP8UbU7RTUhhQQVwxZceCEUGzqJmDhZZTqLRRqPpjbC
         As1xxPkfQ+/QYvxbSL3mNSy7bfMPQrT10B7SYZi/n8BUHTH7e/bUz1brvk3mZpfEyJkg
         RMqmIlroIG8zpevGr5/EN4r8cfQmz/wP8if6CXvoMPgUCZL5VnohGqyICnY1wQglhu9t
         RycQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=546eyQZzdn5dQ5fv+SxUu0FgZG591hjvbFsj/UlLnBo=;
        b=BphZ1ndaXMz/dTkIjDuRyBk2f1GP74YiW2yHk9wZa1ZZ8esH0sbVkBgCHR3zQ1oksE
         VgIzs4rl8BOBnDrzrpNwEZgJqxCFRKXV8OZiWyWpeK9HyNuvDFVn4rXEx1diXNZrnq1p
         jGi6Jrr94qAmp70mpZ+/ZdC+YCMH7ouIvzaEQ/hGOtN+4wX82rD+EsYizTWb7WV2QvOa
         QGC428N2GO2f9/7gNql617RsAeMN1kNiEAt6BRcpWRx66nmbUtwY3AywtHQRZWP7XQMy
         pNDRa9eg5YomVQ3rg+BEojMCRqjJXoHeKhwuFolGM3BcxES3wvDhphSOBOoMkXKE6HAJ
         DSRA==
X-Gm-Message-State: AOAM532oTdCBx3JUrW0SehnCaoQLekvKilzGP8d0sbkMUcFPohzm0hUQ
        Ku1OEybfy+AaT/KGVTjcIjg=
X-Google-Smtp-Source: ABdhPJyxWh+/D3J665jbjoRLmIrHsRP+/hFmZwcwsbrJ1l1YbnPNB+2q+Ip3swgXEpwJZq2RFXutpw==
X-Received: by 2002:a17:90b:94f:: with SMTP id dw15mr13087287pjb.209.1593560480189;
        Tue, 30 Jun 2020 16:41:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:e083])
        by smtp.gmail.com with ESMTPSA id c27sm3380300pfj.163.2020.06.30.16.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 16:41:19 -0700 (PDT)
Date:   Tue, 30 Jun 2020 16:41:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, paulmck@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 bpf-next 2/5] bpf: Introduce sleepable BPF programs
Message-ID: <20200630234117.arqmjpbivy5fhhmk@ast-mbp.dhcp.thefacebook.com>
References: <20200630043343.53195-1-alexei.starovoitov@gmail.com>
 <20200630043343.53195-3-alexei.starovoitov@gmail.com>
 <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0c6b6a6-7b82-e620-8ced-8a1acfaf6f6d@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 01, 2020 at 01:26:44AM +0200, Daniel Borkmann wrote:
> On 6/30/20 6:33 AM, Alexei Starovoitov wrote:
> [...]
> > +/* list of non-sleepable kernel functions that are otherwise
> > + * available to attach by bpf_lsm or fmod_ret progs.
> > + */
> > +static int check_sleepable_blacklist(unsigned long addr)
> > +{
> > +#ifdef CONFIG_BPF_LSM
> > +	if (addr == (long)bpf_lsm_task_free)
> > +		return -EINVAL;
> > +#endif
> > +#ifdef CONFIG_SECURITY
> > +	if (addr == (long)security_task_free)
> > +		return -EINVAL;
> > +#endif
> > +	return 0;
> > +}
> 
> Would be nice to have some sort of generic function annotation to describe
> that code cannot sleep inside of it, and then filter based on that. Anyway,
> is above from manual code inspection?

yep. all manual. I don't think there is a way to automate it.
At least I cannot think of one.

> What about others like security_sock_rcv_skb() for example which could be
> bh_lock_sock()'ed (or, generally hooks running in softirq context)?

ahh. it's in running in bh at that point? then it should be added to blacklist.

The rough idea I had is to try all lsm_* and security_* hooks with all
debug kernel flags and see which ones will complain. Then add them to blacklist.
Unfortunately I'm completely swamped and cannot promise to do that
in the coming months.
So either we wait for somebody to do due diligence or land it knowing
that blacklist is incomplete and fix it up one by one.
I think the folks who're waiting on sleepable work would prefer the latter.
I'm fine whichever way.
