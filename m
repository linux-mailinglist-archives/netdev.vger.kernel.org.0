Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDEFA33ACE
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbfFCWJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:09:01 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:32808 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfFCWJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:09:01 -0400
Received: by mail-lf1-f66.google.com with SMTP id y17so14820330lfe.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KcMRXd21hP8UmZkIG2RNnfnlH3SL7cuLE0q0RRkiu6s=;
        b=VKJfnpAi1elHGrQJDGOtM/gN/DHi+Ci3IGMyX3NflK3rCh5QLlasviFfYvd5Z1n0Ll
         sfT8j+rkJXOwV+YDS4o331naQ3mO3WKL+3uzZCCq+E1Ng8/lfuiakuEj6quDz1FceLdp
         VfWqSDxDiyG7NS9ZHVwM7jMRPxBMvAPlMmUAa+1zKBWuFKfkWh+WvFe7roZu+S9re1MR
         3mC8jy0LYvW2rqnw21AMOZdU5BlpaR9WphB1XPicbMYHATdnNswhzKRw/tq3nf2r/7OW
         3pfIOyj1vzv7RlvQMgzQll2YOArCb8xfux5xgJZAvw7K6GU8R2M0+JaSP0/ZEshAzMpu
         KasQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KcMRXd21hP8UmZkIG2RNnfnlH3SL7cuLE0q0RRkiu6s=;
        b=PbdVb6gv5ik7OCC1hMqbb6j/bd1HppKD7fVn0yN5smrLryd4s9rJDplOVBBJnJRxPE
         6gsFUOwCML+ZKstvfxJcDAi2S0STgyBL6VqKsFYK9TLeoOOCgmiKipIXpjryk4OWbVSw
         5O8pWPsaCLqCEyDxAsVfIhh/mdJ3JjVob+l9454SsACHR2dQLZNOLnywVgQPz7KiRvAs
         2df54NQRY02wdj7VxhapkH8vdjbKh6yN/90elKsMiR9abNL71+MFMx50IfPUUOogvIkh
         840gfbjuiXEJz0o9nztVw/swbRGZjXiTSvcMxdwSCqrRQM6Jyd0yh3YObfswYkeM0f6w
         U5RA==
X-Gm-Message-State: APjAAAWvO3gbIIhOfvNBOHfT9IaIpXQ7ArRzXpXYp57hDYl30hhVco3v
        fPBqDKMHvIZqokrd7ZkUVQ55T+37nNPsgKdbjjSvKvxwwg==
X-Google-Smtp-Source: APXvYqzBxyQVJ38l2yQR8Z55mFmcEnbrYjFwFo/PW/t0ZGSpit+8SCjtd4FFxwH9Ik99pI6puP1BvcBqmSMmUGqMVew=
X-Received: by 2002:ac2:4358:: with SMTP id o24mr14377637lfl.13.1559596567285;
 Mon, 03 Jun 2019 14:16:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190601021526.GA8264@zhanggen-UX430UQ> <CAFqZXNvBpmxNYjZx6YcH5Q-u4Tkwhfyzu_8VmEe8O7r9CCsvNg@mail.gmail.com>
In-Reply-To: <CAFqZXNvBpmxNYjZx6YcH5Q-u4Tkwhfyzu_8VmEe8O7r9CCsvNg@mail.gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 3 Jun 2019 17:15:56 -0400
Message-ID: <CAHC9VhQdr0uOe0X0vLN9fOe7zDJ8bnX4fDLSTmjAGJymCyQ+zg@mail.gmail.com>
Subject: Re: [PATCH v3] selinux: lsm: fix a missing-check bug in selinux_sb_eat_lsm_opts()
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:23 AM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> On Sat, Jun 1, 2019 at 4:15 AM Gen Zhang <blackgod016574@gmail.com> wrote:
> > In selinux_sb_eat_lsm_opts(), 'arg' is allocated by kmemdup_nul(). It
> > returns NULL when fails. So 'arg' should be checked. And 'mnt_opts'
> > should be freed when error.
> >
> > Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
> > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> It looks like you're new to the kernel development community, so let
> me give you a bit of friendly advice for the future :)
>
> You don't need to repost the patch when people give you
> Acked-by/Reviewed-by/Tested-by (unless there is a different reason to
> respin/repost the patches). The maintainer goes over the replies when
> applying the final patch and adds Acked-by/Reviewed-by/... on his/her
> own.
>
> If you *do* need to respin a path for which you have received A/R/T,
> then you need to distinguish between two cases:
> 1. Only trivial changes to the patch (only fixed typos, edited commit
> message, removed empty line, etc. - for example, v1 -> v2 of this
> patch falls into this category) - in this case you can collect the
> A/R/T yourself and add them to the new version. This saves the
> maintainer and the reviewers from redundant work, since the patch is
> still semantically the same and the A/R/T from the last version still
> apply.
> 2. Non-trivial changes to the patch (as is the case for this patch) -
> in this case your patch needs to be reviewed again and you should
> disregard all A/R/T from the previous version. You can easily piss
> someone off if you add their Reviewed-by to a patch they haven't
> actually reviewed, so be careful ;-)

I want to stress Ondrej's last point.  Carrying over an
Acked-by/Reviewed-by/Tested-by tag if you make anything more than the
most trivial change in a patch is *very* bad, and will likely result
in a loss of trust between you and the maintainer.  If you are unsure,
drop the A/R/T tag, there is *much* less harm in asking someone to
re-review a patch than falsely tagging a patch as reviewed by someone
when you have made substantial changes.

I suspect you may have already read the
Documentation/process/submitting-patches.rst file, but if you haven't
it is worth reading.  It covers many of the things that are discussed
elsewhere.

If you aren't already, you should get in the habit of doing the
following for each patch you post to the mailing list:
1. Make sure it compiles cleanly, or at least doesn't introduce any
new compiler warnings/errors.
2. Run ./scripts/checkpatch.pl and fix as many problems as you can; a
patch can still be accepted with checkpatch warnings/errors (and some
maintainers might dislike some of checkpatch's decisions), but it
helps a lot if you can fix all those.
3. At the very least make sure your kernel changes boot, if you can,
run the associated subsystem's test (if they have one) to verify that
there are no regressions (the SELinux kernel test suite is here:
https://github.com/SELinuxProject/selinux-testsuite)

Lastly, when in doubt, you can always ask the mailing list; the
SELinux list is a pretty friendly place :)

-- 
paul moore
www.paul-moore.com
