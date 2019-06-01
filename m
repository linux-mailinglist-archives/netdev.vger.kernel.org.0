Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7B93318E8
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727034AbfFABy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:54:59 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37128 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFABy7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:54:59 -0400
Received: by mail-pl1-f195.google.com with SMTP id e7so4210959pln.4;
        Fri, 31 May 2019 18:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uS+vkMtqLwlIIErU0XBgxFsO/mgm3Z3e/UEBQvk7P8o=;
        b=SLIlcpF/RkF/lfru9fMPLVo34LGp6B4XeEx1g4Lg4HJtqxO5Aja6HUn9uQgx611RkX
         isnsTKvJMlYVOCP4kwvm+HPblCUpsvNA7wRaWwxqkxVKpB2X23uSoMuXlByZv/Hct1TG
         aT9nqdC/bcDgcIPQHQ2tqJcXYY7gkersU7cC76wvqiS6aIuHmkXCCCx+blwCixi2NUA/
         HMPT2W+zvwZXbJ7HNP13J41zO4SGnt9YSzGbdlbp66sUmYEF892q3DsWenZVebCNt4dL
         vBAk0h2oupbJyLwf7LBwoNlNS2gIryySrMebXuAGW/T3FYbcqMhuAUVlEjocVS1Ivt/C
         yPOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uS+vkMtqLwlIIErU0XBgxFsO/mgm3Z3e/UEBQvk7P8o=;
        b=ZUca1MxvksfElbArQMceZEgL0pEaM+r/pKNXuveDUaeMBuZNTpz9zfLnynk4yeadfc
         A8snaqj8Oghbw7CO6aYIDGVHd/9lmNka5Lsb88SJohMwOAv7Uvvvr0/7R8bj6AiPJ/Zs
         kReC3PVD4+RihBgpFDTYmtqN5XqJ7v6RGK8qGOc4dldniEnp4ezDRAUrYEgHuROxveqf
         dJwYAm4rr/uh6UMOtKFBbk4wN8EJnjxMnE0wvY0imknAZPQoaD8HHjFofzJulXClLNth
         cmwB8+obDcYknfeInzrd8RcUsF+C92N4UqVfM/+oqNGJ+boWsTYQBK/rv1f0cUiAWfxB
         hIBA==
X-Gm-Message-State: APjAAAX93JclN/enxHDNeiYj5dIoXSvXqJDpm5uJyXDv8Fq6t0oeyAWu
        CFA5BgwB2yWAcqT575UAU94=
X-Google-Smtp-Source: APXvYqyUxXtqiMXf43Nasi77WVM6izDgKinuUHnegJHnYh7EszBuC9IqxPnp5EESnDUDEZ24MZooXg==
X-Received: by 2002:a17:902:205:: with SMTP id 5mr12386264plc.165.1559354098463;
        Fri, 31 May 2019 18:54:58 -0700 (PDT)
Received: from zhanggen-UX430UQ ([66.42.35.75])
        by smtp.gmail.com with ESMTPSA id y16sm12198928pfo.133.2019.05.31.18.54.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 18:54:57 -0700 (PDT)
Date:   Sat, 1 Jun 2019 09:54:42 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, ccross@android.com,
        selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] hooks: fix a missing-check bug in
 selinux_add_mnt_opt()
Message-ID: <20190601015442.GA7832@zhanggen-UX430UQ>
References: <20190530080602.GA3600@zhanggen-UX430UQ>
 <CAFqZXNtX1R1VDFxm7Jco3BZ=pVnNiHU3-C=d8MhCVV1XSUQ8bw@mail.gmail.com>
 <20190530085438.GA2862@zhanggen-UX430UQ>
 <CAHC9VhSwzD652qKUy7qrRJ=zy-NZtKRGc7H4NZurzUcK4OgFZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhSwzD652qKUy7qrRJ=zy-NZtKRGc7H4NZurzUcK4OgFZA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 11:55:23AM -0400, Paul Moore wrote:
> On Thu, May 30, 2019 at 4:55 AM Gen Zhang <blackgod016574@gmail.com> wrote:
> >
> > In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
> > NULL when fails. So 'val' should be checked.
> >
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > Fixes: 757cbe597fe8 ("LSM: new method: ->sb_add_mnt_opt()")
> 
> Previous comments regarding "selinux:" instead of "hooks:" apply here as well.
> 
Thanks for your comments, Paul. I will make some changes.
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 3ec702c..4797c63 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -1052,8 +1052,11 @@ static int selinux_add_mnt_opt(const char *option, const char *val, int len,
> >         if (token == Opt_error)
> >                 return -EINVAL;
> >
> > -       if (token != Opt_seclabel)
> > -               val = kmemdup_nul(val, len, GFP_KERNEL);
> > +       if (token != Opt_seclabel) {
> > +                       val = kmemdup_nul(val, len, GFP_KERNEL);
> > +                       if (!val)
> > +                               return -ENOMEM;
> 
> It looks like this code is only ever called by NFS, which will
> eventually clean up mnt_opts via security_free_mnt_opts(), but since
> the selinux_add_opt() error handler below cleans up mnt_opts it might
> be safer to do the same here in case this function is called multiple
> times to add multiple options.
> 
> > +       }
> >         rc = selinux_add_opt(token, val, mnt_opts);
> >         if (unlikely(rc)) {
> >                 kfree(val);
> 
> -- 
> paul moore
> www.paul-moore.com
Thanks
Gen
