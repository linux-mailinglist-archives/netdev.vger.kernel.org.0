Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3CC43A438
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 22:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbhJYUSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236961AbhJYUSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 16:18:00 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C878EC09155E
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:47:18 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id i6so14283776ila.12
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/wcdlkpultptyteCFR+azF3+dEscqOT8YqwdivQDRJ4=;
        b=WOg3hWet6YZkVq6GSv3z63fZDFBEptrPL+UpCIh63sh6kUI/HAddduoMIKnVE/p17T
         O8ibikaFJ7OOukwbRPeE7BTtZ6OCtYolMDHsI99qEd1OYxowCOi1uZGKKQ/rOChiWtOr
         6/5JC6mR4W4uvOtL6fTQcJC3lHa9iuWEXDVaeyfczNwMzxl8wNvBZQtMYa1GIiGX6+Dn
         CUdPaAP1XrqKM0eYhGq4KDLZE1wa+1CXHXXmwZJeWAYjOHxJIREU2Zb9qL2YdBTqMCgZ
         RBaucdxT2M9JLLHUREEhH7lx0/VYQn4Vq6xSGLH/7XV1vpsSIegANnTk7lAKUxcFgrj7
         zgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/wcdlkpultptyteCFR+azF3+dEscqOT8YqwdivQDRJ4=;
        b=e4MvszWhsHS+AM6p3wMKVostMSP+DkbPTEnVG7qnfDGWXwKybiKslo4Xq9LYKM2WdA
         OcXDt/w8ekTMUhc9DJzahKhOFuBpfZrzZpjMdEuXvTMl8Am+fzYnwjks4j442XYh+kpX
         WLclSZlbiazmpnCpWh/oZW5lHH0TGniHeTYnc8JVHMfWYpV1uqUUzp/jzu5NAVhILl1g
         MhAAWo6TVzXDkTZudgN7G3+KwIl7S/Mm9dyd+HaFRgdlNwEDK14TeBvUVu1MmpKd/YV8
         JnP8MXmQxvjoeCxenfyveK68o9cCB74oi9LQQbGJfU9JjwSaZQSfAhQoZ4wYHg5FrIUU
         ILpQ==
X-Gm-Message-State: AOAM530gxNdNbx/j77cQAqOOFBW5nSvcPCj+9mlW9gzEAXFNmGlEwzd6
        v43q++9wnCXY90OZ7j+LrHx1/b2BKDRRlLHcUXSp4Q==
X-Google-Smtp-Source: ABdhPJwPAJVnmXZDstwZo2ShSBU0ebPXCkCVv1c/tqy6HxTfgfzgONu2j/E/xaZKALsi6mQOFMvpLETyCKIxD+pNjm0=
X-Received: by 2002:a05:6e02:1112:: with SMTP id u18mr10457911ilk.206.1635191238217;
 Mon, 25 Oct 2021 12:47:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAOhMmr7bWv_UgdkFZz89O4=WRfUFhXHH5hHEOBBfBaAR8f4Ygw@mail.gmail.com>
 <CA+h21hqrX32qBmmdcNiNkp6_QvzsX61msyJ5_g+-FFJazxLgDw@mail.gmail.com>
 <YXY15jCBCAgB88uT@d3> <CA+pv=HPyCEXvLbqpAgWutmxTmZ8TzHyxf3U3UK_KQ=ePXSigBQ@mail.gmail.com>
 <c00f22d2-6566-8911-b56b-142f6fe42b8c@metztli.com>
In-Reply-To: <c00f22d2-6566-8911-b56b-142f6fe42b8c@metztli.com>
From:   Slade Watkins <slade@sladewatkins.com>
Date:   Mon, 25 Oct 2021 15:47:07 -0400
Message-ID: <CA+pv=HOT71a5d=LJM7VLSTSKBYRVNdT-r1ZtZSdRgNK6aMF-4w@mail.gmail.com>
Subject: Re: Unsubscription Incident
To:     Metztli Information Technology <jose.r.r@metztli.com>
Cc:     Benjamin Poirier <benjamin.poirier@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lijun Pan <lijunp213@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alan Coopersmith <alan.coopersmith@oracle.com>,
        Shannon Nelson <snelson@pensando.io>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

On Mon, Oct 25, 2021 at 2:08 PM Metztli Information Technology
<jose.r.r@metztli.com> wrote:
>
>
> On 10/25/21 10:04 AM, Slade Watkins wrote:
> > On Mon, Oct 25, 2021 at 12:43 AM Benjamin Poirier
> > <benjamin.poirier@gmail.com> wrote:
> >> On 2021-10-22 18:54 +0300, Vladimir Oltean wrote:
> >>> On Fri, 22 Oct 2021 at 18:53, Lijun Pan <lijunp213@gmail.com> wrote:
> >>>> Hi,
> >>>>
> >>>>  From Oct 11, I did not receive any emails from both linux-kernel and
> >>>> netdev mailing list. Did anyone encounter the same issue? I subscribed
> >>>> again and I can receive incoming emails now. However, I figured out
> >>>> that anyone can unsubscribe your email without authentication. Maybe
> >>>> it is just a one-time issue that someone accidentally unsubscribed my
> >>>> email. But I would recommend that our admin can add one more
> >>>> authentication step before unsubscription to make the process more
> >>>> secure.
> >>>>
> >>>> Thanks,
> >>>> Lijun
> >>> Yes, the exact same thing happened to me. I got unsubscribed from all
> >>> vger mailing lists.
> >> It happened to a bunch of people on gmail:
> >> https://lore.kernel.org/netdev/1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com/t/#u
> > I can at least confirm that this didn't happen to me on my hosted
> > Gmail through Google Workspace. Could be wrong, but it seems isolated
> > to normal @gmail.com accounts.
> >
> > Best,
> >               -slade
>
> Niltze [Hello], all-
>
> Could it have something to do with the following?
>
> ---------- Forwarded message ---------
>
> From: Alan Coopersmith <alan.coopersmith@oracle.com>
> Date: Thu, Oct 21, 2021 at 12:06 PM
> Subject: [oss-security] Mailman 2.1.35 security release
> To: <oss-security@lists.openwall.com>
>
>
> Quoting from Mark Sapiro's emails at:
> https://mail.python.org/archives/list/mailman-announce@python.org/thread/IKCO6JU755AP5G5TKMBJL6IEZQTTNPDQ/
>
>  > A couple of vulnerabilities have recently been reported. Thanks to Andre
>  > Protas, Richard Cloke and Andy Nuttall of Apple for reporting these and
>  > helping with the development of a fix.
>  >
>  > CVE-2021-42096 could allow a list member to discover the list admin
>  > password.
>  >
>  > CVE-2021-42097 could allow a list member to create a successful CSRF
>  > attack against another list member enabling takeover of the members
> account.
>  >
>  > These attacks can't be carried out by non-members so may not be of
>  > concern for sites with only trusted list members.

Maybe? Are the kernel lists hosted through mailman or something based
on it that would be affected by these CVEs? It has been so long since
I last looked into it that I genuinely do not remember.

>
>
>  > I am pleased to announce the release of Mailman 2.1.35.
>  >
>  > This is a security and minor bug fix release. See the attached
>  > README.txt for details. For those who just want a patch for the security
>  > issues, see
>  > https://bazaar.launchpad.net/~mailman-coders/mailman/2.1/revision/1873.
>  > The patch is also attached to the bug reports at
>  > https://bugs.launchpad.net/mailman/+bug/1947639 and
>  > https://bugs.launchpad.net/mailman/+bug/1947640. The patch is the same
>  > on both and fixes both issues.
>  >
>  > As noted Mailman 2.1.30 was the last feature release of the Mailman 2.1
>  > branch from the GNU Mailman project. There has been some discussion as
>  > to what this means. It means there will be no more releases from the GNU
>  > Mailman project containing any new features. There may be future patch
>  > releases to address the following:
>  >
>  > i18n updates.
>  > security issues.
>  > bugs affecting operation for which no satisfactory workaround exists.
>  >
>  > Mailman 2.1.35 is the fifth such patch release.
>  >
>  > Mailman is free software for managing email mailing lists and
>  > e-newsletters. Mailman is used for all the python.org and
>  > SourceForge.net mailing lists, as well as at hundreds of other sites.
>  >
>  > For more information, please see our web site at one of:
>  >
>  > http://www.list.org
>  > https://www.gnu.org/software/mailman
>  > http://mailman.sourceforge.net/
>  >
>  > Mailman 2.1.35 can be downloaded from
>  >
>  > https://launchpad.net/mailman/2.1/
>  > https://ftp.gnu.org/gnu/mailman/
>  > https://sourceforge.net/projects/mailman/
>
>  > --
>  >        -Alan Coopersmith- alan.coopersmith@oracle.com
>  >         Oracle Solaris Engineering - https://blogs.oracle.com/alanc
>
>
> Best Professional Regards.
>
> --
> Jose R R
> http://metztli.it
> ---------------------------------------------------------------------------------------------
> Download Metztli Reiser4: Debian Bullseye w/ Linux 5.13.14 AMD64
> ---------------------------------------------------------------------------------------------
> feats ZSTD compression https://sf.net/projects/metztli-reiser4/
> ---------------------------------------------------------------------------------------------
> or SFRN 5.1.3, Metztli Reiser5 https://sf.net/projects/debian-reiser4/
> -------------------------------------------------------------------------------------------
> Official current Reiser4 resources: https://reiser4.wiki.kernel.org/

Thanks,
             -slade
