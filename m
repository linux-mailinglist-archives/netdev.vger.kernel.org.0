Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8799A311C4
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfEaPzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:55:40 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40187 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727030AbfEaPzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:55:36 -0400
Received: by mail-lj1-f195.google.com with SMTP id q62so10098122ljq.7
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 08:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RVcOaYatOpeo1CRV+hYtc16/sImBcgmxdJUqU74IXf0=;
        b=RPZh76moKr55vlOhT6KnMQNS2x36jsAOlxZc9yNKyxBw0/CnSaJqQXxPo8wQogqSrH
         xvmcd8R/2F0tPP/2ihZ1+29FSCm9nEmo6aw5HY8bzked4RIQPKJuQOkb+A/GhtgtIj5a
         aLWdXP2tDDewNDPoZfQNbPfPMJRAtol/Hsyp/gqT51L1Anjn5GoDMPRjuY6Sc09LcwlO
         n4vSZg3ld4ZHB+BWhlysxicuNc0AlznR6JfJ4CZMe6EOFOQnF/TJRQYeJKzSXA7tqj9a
         Jpm9h6pr7EN7xwZSsvAaiJ12eb5JuE2TSUY+75Sh0GRQZQCe1qpwgP9inI/9WD2YWaC2
         8PbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RVcOaYatOpeo1CRV+hYtc16/sImBcgmxdJUqU74IXf0=;
        b=QsE7yAf62L8O3b3mv3BMn6PK8aW4tCTpXnltawcD8lq3YDzrHb8P1JGdDShbZLpoIV
         nOtvF6j3zGuJmCFe6lc8PmpECg2B2/EBDNtPS822PkoFLPi7rqTX9d7vpXRMN1tQkE8Q
         aWcPGlLBDKh8YDakUdLsYGRCwY2ShsQk/vtJZoicVIQIjg8mjim1Y7hrA0l2NzJO9JyU
         n+Cs6c9jO8Fa6bavPB5ViAHTsXw0sS1HQFu4LcUDRI/C5HDuabSes8c3pJxEfDSwQL3z
         PgJxpw0F4JmEXbPoxqExkt2RqEteSzc7P9IJ1Sft6PPdRCfkvXhhNDuI74NxBMSowOr5
         jIaw==
X-Gm-Message-State: APjAAAWwrQG9rloulwDtzAKGgsFAeJdCJl4kVSl45oStl3Zo5dvCJQwH
        JNRmpeUphuLn86e7W6fAjX86T+JY2EAFBAgoQop1rm8WEQ==
X-Google-Smtp-Source: APXvYqzr2MCUTgiueRQHjiAeFx7vxTXPmGHbdykoMlbeOPTpRuJBL1Ru1ZFTbbOjFttwWXo6DFPAaxt9JHVyrRBUZds=
X-Received: by 2002:a2e:9a97:: with SMTP id p23mr6347647lji.160.1559318134012;
 Fri, 31 May 2019 08:55:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190530080602.GA3600@zhanggen-UX430UQ> <CAFqZXNtX1R1VDFxm7Jco3BZ=pVnNiHU3-C=d8MhCVV1XSUQ8bw@mail.gmail.com>
 <20190530085438.GA2862@zhanggen-UX430UQ>
In-Reply-To: <20190530085438.GA2862@zhanggen-UX430UQ>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 31 May 2019 11:55:23 -0400
Message-ID: <CAHC9VhSwzD652qKUy7qrRJ=zy-NZtKRGc7H4NZurzUcK4OgFZA@mail.gmail.com>
Subject: Re: [PATCH v2] hooks: fix a missing-check bug in selinux_add_mnt_opt()
To:     Gen Zhang <blackgod016574@gmail.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, ccross@android.com,
        selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 4:55 AM Gen Zhang <blackgod016574@gmail.com> wrote:
>
> In selinux_add_mnt_opt(), 'val' is allcoted by kmemdup_nul(). It returns
> NULL when fails. So 'val' should be checked.
>
> Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> Fixes: 757cbe597fe8 ("LSM: new method: ->sb_add_mnt_opt()")

Previous comments regarding "selinux:" instead of "hooks:" apply here as well.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 3ec702c..4797c63 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -1052,8 +1052,11 @@ static int selinux_add_mnt_opt(const char *option, const char *val, int len,
>         if (token == Opt_error)
>                 return -EINVAL;
>
> -       if (token != Opt_seclabel)
> -               val = kmemdup_nul(val, len, GFP_KERNEL);
> +       if (token != Opt_seclabel) {
> +                       val = kmemdup_nul(val, len, GFP_KERNEL);
> +                       if (!val)
> +                               return -ENOMEM;

It looks like this code is only ever called by NFS, which will
eventually clean up mnt_opts via security_free_mnt_opts(), but since
the selinux_add_opt() error handler below cleans up mnt_opts it might
be safer to do the same here in case this function is called multiple
times to add multiple options.

> +       }
>         rc = selinux_add_opt(token, val, mnt_opts);
>         if (unlikely(rc)) {
>                 kfree(val);

-- 
paul moore
www.paul-moore.com
