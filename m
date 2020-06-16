Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D52A1FBB7D
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 18:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgFPQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 12:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732223AbgFPQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 12:19:11 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF6FC0613EF
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:19:10 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m2so16364146otr.12
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 09:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fiWLJlRK7hIrVJhqrA73kDSLrIv9Ym+IMHSkrLmFVXs=;
        b=W/psw7rJjjj0igh5USfHJFwAvdGtWgwMOOIfoxPkytUdSSQAdFOH/bfQIqrUsIOuzv
         a9Vl2sPr7U6gMv9WtD5uCoRamUoj0WIOZ/n0nICz5buDFIt1jLDFuvkvAOZuebZGPj4r
         Jn2sggqqK9sb1MI3Um3GNHKq17xFRhWCG166HdQLYSHMEk2FY5ACBBZ5hN2lGun81Qyi
         GJENDCD6oY3Wj4DPdEsHzNRbtcAkvwi4zjzLFGU1+ft+jy2FY0geCnqGSH6Q4MrxLAjz
         HCQPdEi04N1sqR64Sbg1vccPjTualudux+UTkyybTF1we4OWenyu+uqGY2pczphBKFNF
         WhEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fiWLJlRK7hIrVJhqrA73kDSLrIv9Ym+IMHSkrLmFVXs=;
        b=PiqMofqK1W7l8p71xV+rL7xSK+qcHjK5H94HfyuZQEuv9M8wLDUdWArAjIBhUsSo1I
         KR/5+b2eQQ3k+SPbY2liqjKm/HJXwZdACu/fNoD553bElpdStfqh1kINwmgo19FQz2RF
         GJkkZItyuiI3+3pHcq3vlw4yhv+X9utgmwEL1JZyoCaVFZA7EgQR5XuouTYmmAg1B5S9
         adusTWVUfkfwKRjP1wzbVrelIkZd0C/jXOL0L/54Y38LVk/dtvmDX4BYKRUJ7/uJOgwP
         /FyNXHiuRkWlfRSXO30ztFOj70W5Io+RhAsa6fz5bgfMF6jUlJe/6JxHTJWRRRuNxQfj
         SKwQ==
X-Gm-Message-State: AOAM532pgqvodXTrztVZDhIRuFK2aRfNIpV+z6G9X8R5fhwVq4MEJgfc
        /iVvqGW1FH8K3o+pGMu4IFHHWg==
X-Google-Smtp-Source: ABdhPJwJLUo+s/3zvXyuzd5xR5zRDZ7iEWewkVzWg80Un1dA516CGEOvT/txqHhK+aWdjAw3vd97RA==
X-Received: by 2002:a05:6830:1d1:: with SMTP id r17mr3101139ota.19.1592324348502;
        Tue, 16 Jun 2020 09:19:08 -0700 (PDT)
Received: from cisco ([2601:282:902:b340:f5b5:cc36:51c:a840])
        by smtp.gmail.com with ESMTPSA id k84sm4256949oia.3.2020.06.16.09.19.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 09:19:07 -0700 (PDT)
Date:   Tue, 16 Jun 2020 10:18:59 -0600
From:   Tycho Andersen <tycho@tycho.ws>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian@brauner.io>,
        "David S. Miller" <davem@davemloft.net>,
        Christoph Hellwig <hch@lst.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Matt Denton <mpdenton@google.com>,
        Jann Horn <jannh@google.com>, Chris Palmer <palmer@google.com>,
        Robert Sesek <rsesek@google.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, Shuah Khan <shuah@kernel.org>,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 10/11] seccomp: Switch addfd to Extensible Argument
 ioctl
Message-ID: <20200616161859.GL2893648@cisco>
References: <20200616032524.460144-1-keescook@chromium.org>
 <20200616032524.460144-11-keescook@chromium.org>
 <20200616145546.GH2893648@cisco>
 <202006160904.A30F2C5B9E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202006160904.A30F2C5B9E@keescook>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 09:05:29AM -0700, Kees Cook wrote:
> On Tue, Jun 16, 2020 at 08:55:46AM -0600, Tycho Andersen wrote:
> > On Mon, Jun 15, 2020 at 08:25:23PM -0700, Kees Cook wrote:
> > > This patch is based on discussions[1] with Sargun Dhillon, Christian
> > > Brauner, and David Laight. Instead of building size into the addfd
> > > structure, make it a function of the ioctl command (which is how sizes are
> > > normally passed to ioctls). To support forward and backward compatibility,
> > > just mask out the direction and size, and match everything. The size (and
> > > any future direction) checks are done along with copy_struct_from_user()
> > > logic. Also update the selftests to check size bounds.
> > > 
> > > [1] https://lore.kernel.org/lkml/20200612104629.GA15814@ircssh-2.c.rugged-nimbus-611.internal
> > > 
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  include/uapi/linux/seccomp.h                  |  2 -
> > >  kernel/seccomp.c                              | 21 ++++++----
> > >  tools/testing/selftests/seccomp/seccomp_bpf.c | 40 ++++++++++++++++---
> > >  3 files changed, 49 insertions(+), 14 deletions(-)
> > > 
> > > diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
> > > index c347160378e5..473a61695ac3 100644
> > > --- a/include/uapi/linux/seccomp.h
> > > +++ b/include/uapi/linux/seccomp.h
> > > @@ -118,7 +118,6 @@ struct seccomp_notif_resp {
> > >  
> > >  /**
> > >   * struct seccomp_notif_addfd
> > > - * @size: The size of the seccomp_notif_addfd structure
> > >   * @id: The ID of the seccomp notification
> > >   * @flags: SECCOMP_ADDFD_FLAG_*
> > >   * @srcfd: The local fd number
> > > @@ -126,7 +125,6 @@ struct seccomp_notif_resp {
> > >   * @newfd_flags: The O_* flags the remote FD should have applied
> > >   */
> > >  struct seccomp_notif_addfd {
> > > -	__u64 size;
> > 
> > Huh? Won't this break builds?
> 
> Only if they use addfd without this patch? :) Are you saying I should
> collapse this patch into the main addfd and test patches?

Oh, derp, I see :) Yeah, maybe that would be good.

Tycho
