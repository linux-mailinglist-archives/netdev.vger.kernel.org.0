Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59686318ED
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfFAB6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:58:02 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37821 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFAB6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:58:02 -0400
Received: by mail-pg1-f193.google.com with SMTP id 20so4996299pgr.4;
        Fri, 31 May 2019 18:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Bp4uzKFbW2Q2AiIKe9vlcnCSzUZwAoUiozQ49FK0GpU=;
        b=nfl64ZAm73t5U3tABQTzO5dFw198xHVSrVad/eEmdOZpxMM0l3H9kK3EFNW7VHoK1i
         ORhMyk3IuCi/gMJUCOFJS+Et1KItRtHFqkLCMp6J8GRik0m8t3yhBbcsnMNMOZhOAI8c
         0LxAX6Q8PcRiYOac5rDyQMcmBQ7szSI4VF3u9AN5qv5FhtHYUBE5wZ7geOZL75VDLqca
         BQmmgo/BJ4SFy9lVBTXK8Qv7Y/7Te1C+Y9c4XlSSGDNXyy/AH08CfHN4F5sDr4Ihr1PX
         /j0FMpJX51QKJlpiX/SaXRvrEvBsn8HKOrXu1wXD6GkkbL8QT+OgVWHMbwjdk4QbimM3
         GIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Bp4uzKFbW2Q2AiIKe9vlcnCSzUZwAoUiozQ49FK0GpU=;
        b=DP5fhnskaYGqVUzRi52aBWZuICG+KRXoE7JJuMeNAPzoUn/xhNzJgEJnN9xAznzW/g
         My4sHowpkp/B+sLLNA6srn0Y3/CaYVA0l5+iBUbAJkQtkdWfX1zNYg9+lKlVLMzG3ZBL
         3wJw408thmz44qkDR29Wh9rPOrPtFrTK0kbN2k0sgT+7OjFTE87RTpfgmxKmeWCi5U+W
         h6AsH4/XqmvWwFeMFpxxyKLUvarL3N60Ah9vLS74pHWubH//KvjKcrZbVceYBmW99fq1
         BXmBENXtMQcGPvwljgpPDIFASb+BwB/A+kwNHVYCYG6oF9gxyYdfTuMYeBOQk3AXTc/p
         kssg==
X-Gm-Message-State: APjAAAWeQnj661knVNLX+76xopb5bqufe0HYMSpWXRjM0y7XQrGfv833
        vO0aSM6EPKHF3EvvLxZTeLU=
X-Google-Smtp-Source: APXvYqwFXHyAV04HloVmZRnT4v/haxFL4Cfe+/o3AV76Xc3tb+gEtXEN+PUUrpCX7nVDXhDGJRh+SQ==
X-Received: by 2002:a63:3141:: with SMTP id x62mr12923157pgx.282.1559354281437;
        Fri, 31 May 2019 18:58:01 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id j20sm4801393pff.183.2019.05.31.18.57.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 18:58:00 -0700 (PDT)
Date:   Sat, 1 Jun 2019 09:57:49 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, omosnace@redhat.com
Subject: Re: [PATCH v2] hooks: fix a missing-check bug in
 selinux_sb_eat_lsm_opts()
Message-ID: <20190601015749.GA7979@zhanggen-UX430UQ>
References: <20190531013350.GA4642@zhanggen-UX430UQ>
 <CAHC9VhTmj8b9jYMaXd=ORhBgTAWUgF=srgqAXkECe7MFkDXOmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTmj8b9jYMaXd=ORhBgTAWUgF=srgqAXkECe7MFkDXOmg@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:45:28AM -0400, Paul Moore wrote:
> On Thu, May 30, 2019 at 9:34 PM Gen Zhang <blackgod016574@gmail.com> wrote:
> >
> > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > returns NULL when fails. So 'arg' should be checked.
> >
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > Fixes: 99dbbb593fe6 ("selinux: rewrite selinux_sb_eat_lsm_opts()")
> 
> One quick note about the subject line, instead of using "hooks:" you
> should use "selinux:" since this is specific to SELinux.  If the patch
> did apply to the LSM framework as a whole, I would suggest using
> "lsm:" instead of "hooks:" as "hooks" is too ambiguous of a prefix.
> 
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 3ec702c..5a9e959 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2635,6 +2635,8 @@ static int selinux_sb_eat_lsm_opts(char *options, void **mnt_opts)
> >                                                 *q++ = c;
> >                                 }
> >                                 arg = kmemdup_nul(arg, q - arg, GFP_KERNEL);
> > +                               if (!arg)
> > +                                       return -ENOMEM;
> 
> It seems like we should also check for, and potentially free *mnt_opts
> as the selinux_add_opt() error handling does just below this change,
> yes?  If that is the case we might want to move that error handling
> code to the bottom of the function and jump there on error.
> 
> >                         }
> >                         rc = selinux_add_opt(token, arg, mnt_opts);
> >                         if (unlikely(rc)) {
> 
> -- 
> paul moore
> www.paul-moore.com
Yes, I agree with that. And I will work on this to resubmit.

Thanks
Gen
