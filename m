Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF067291715
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 13:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgJRLDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 07:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgJRLDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 07:03:02 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAA9C061755;
        Sun, 18 Oct 2020 04:03:01 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 10so4269085pfp.5;
        Sun, 18 Oct 2020 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oUZM90INuEFJdV0Up2OFRQw8jw3frVJvPNBYMcXmed8=;
        b=obw+JEtULb3roPlOcA+cFFa0UC8s5kFvQdUmTZSoaEFnXxrgwm+9Q1x2d0MhzEnhrH
         9klqvPIAtExFNiEtMEE4r1TRSNRuEGI3AK1r9qLcTiR0vAApRm7TG+RLu94hEYIrwJJm
         jyZcqeD4KfmoM2X0uHeRDZGGyicmV9JZM3a3ZkxTjZAJZvymZQ/DoC4UR5sDHAdMTQRE
         FpInaqQgK7eBr1faOl8KObe1oUcOdaUggyfjOTy8ai/aecSe/m9Oy8G1o4XbmlKUcY8Z
         Md7QdJN11kVGUz1LaaedYLdOyEEoFVKi3eDOeOMxC6Lh73MfjrZvhpDY/P0cLzZKatS6
         QxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oUZM90INuEFJdV0Up2OFRQw8jw3frVJvPNBYMcXmed8=;
        b=nFVhaOv7D8P1v5MOfmeKZwpZP18V77iXmH5Sn7xLrL0auct1nrrYZcKIBYLAg4q4B5
         ee8ja2FtrGnzcIvteWqUhZPnr9QSHT1FumE0srPkhMRq5xxZhjeEqRE9fQ0sNIjYQ6LU
         JkQNtOBbPUHyNR7wLllivB87pjnSRnM9MZsSU6hsuP7TT4fcnVwFDrB51MSijfrqqEtr
         rjtQAFCyGegXAoYK81QyAYe79N9lY8drqJBXrVJ9g9KwY7744QHy/Vx5+aCKRlWsgGXt
         oH0cRacdhRTN/nza0yZK1UAyb6cQMeTjaT4LYF1qvhoijwA5YmZWYNdMp0Fr2vJU6Bhd
         5aVw==
X-Gm-Message-State: AOAM5332QByvEdQ+3vHPSmDuSy3XlNKQu6HQM2hSZ7IUfnOOqR25JHbF
        MenvSSVVpvGZ54Igp27U8k4t8nQVouIZMA==
X-Google-Smtp-Source: ABdhPJy2INonU8ZdaP9f08cOUIXxHuvH6lnqRrVod5r0298JUvRURMo0iucks1P94iYuoM2kEG9rPA==
X-Received: by 2002:a65:64cc:: with SMTP id t12mr10542637pgv.106.1603018980217;
        Sun, 18 Oct 2020 04:03:00 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id 9sm7665179pjs.1.2020.10.18.04.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2020 04:02:59 -0700 (PDT)
Date:   Sun, 18 Oct 2020 20:02:53 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/7] staging: qlge: replace ql_* with qlge_* to avoid
 namespace clashes with other qlogic drivers
Message-ID: <20201018110253.GA21325@f3>
References: <20201014104306.63756-1-coiby.xu@gmail.com>
 <20201014104306.63756-2-coiby.xu@gmail.com>
 <20201015010136.GB31835@f3>
 <20201016231631.efwu5a4a5f3jnrzv@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016231631.efwu5a4a5f3jnrzv@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-17 07:16 +0800, Coiby Xu wrote:
> On Thu, Oct 15, 2020 at 10:01:36AM +0900, Benjamin Poirier wrote:
> > On 2020-10-14 18:43 +0800, Coiby Xu wrote:
> > > To avoid namespace clashes with other qlogic drivers and also for the
> > > sake of naming consistency, use the "qlge_" prefix as suggested in
> > > drivers/staging/qlge/TODO.
> > > 
> > > Suggested-by: Benjamin Poirier <benjamin.poirier@gmail.com>
> > > Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
> > > ---
> > >  drivers/staging/qlge/TODO           |    4 -
> > >  drivers/staging/qlge/qlge.h         |  190 ++--
> > >  drivers/staging/qlge/qlge_dbg.c     | 1073 ++++++++++++-----------
> > >  drivers/staging/qlge/qlge_ethtool.c |  231 ++---
> > >  drivers/staging/qlge/qlge_main.c    | 1257 +++++++++++++--------------
> > >  drivers/staging/qlge/qlge_mpi.c     |  352 ++++----
> > >  6 files changed, 1551 insertions(+), 1556 deletions(-)
> > > 
> > > diff --git a/drivers/staging/qlge/TODO b/drivers/staging/qlge/TODO
> > > index f93f7428f5d5..5ac55664c3e2 100644
> > > --- a/drivers/staging/qlge/TODO
> > > +++ b/drivers/staging/qlge/TODO
> > > @@ -28,10 +28,6 @@
> > >  * the driver has a habit of using runtime checks where compile time checks are
> > >    possible (ex. ql_free_rx_buffers(), ql_alloc_rx_buffers())
> > >  * reorder struct members to avoid holes if it doesn't impact performance
> > > -* in terms of namespace, the driver uses either qlge_, ql_ (used by
> > > -  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
> > > -  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
> > > -  prefix.
> > 
> > You only renamed ql -> qlge. The prefix needs to be added where there is
> > currently none like the second example of that text.
> 
> On second thoughts, these structs like ob_mac_iocb_req are defined in
> local headers and there is no mixed usage. So even when we want to
> build this diver and other qlogic drivers into the kernel instead of
> as separate modules, it won't lead to real problems, is it right?

Using cscope or ctags and searching for ob_mac_iocb_req will yield
ambiguous results. It might also make things more difficult if using a
debugger.

Looking at other drivers (ex. ice, mlx5), they use a prefix for their
private types, just like for their static functions, even though it's
not absolutely necessary. I think it's helpful when reading the code
because it quickly shows that it is something that was defined in the
driver, not in some subsystem.

I didn't think about it earlier but it would have been better to leave
out this renaming to a subsequent patchset, since this change is
unrelated to the debugging features.
