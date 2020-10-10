Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F6B28A406
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgJJW4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731590AbgJJTyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:54:09 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6D3EC05BD0E;
        Sat, 10 Oct 2020 06:22:36 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id r10so9676838pgb.10;
        Sat, 10 Oct 2020 06:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iPYmzILO99gWQ7KmTRCw8HqpXWlZMMEv9MgwDntuYfI=;
        b=Gw8bu7YbCE7B1Uazh09OPacu+3M9+9er0UlkwZG3KBiuR21iWSsVfiPxnmhBVUj5Ka
         bUH4RJPVe3EXtdlNv9f9Ymiaafh0Rb0A32U1Z2Vvcm1I7R/4rNqNwzzz6II3xe42bA+R
         jnEKchK2eQOmusHphedK8luW/CNukfLM3YDJ7XTcFDJVbh/rohI80LmVzkUBhKFzKCAr
         cHbxY0P8x9gQZ+XzrGNQK8QXlw7ujPRC/LOZMnMqpT97op87oRjecDtToQ2HoOyB01TH
         1zGe/hWa77lcPqdUmpdWemQ0XypVB5x8pNpsRcW5eHDelCOnGrc7F03lgKSeo6dZJwL2
         n+2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iPYmzILO99gWQ7KmTRCw8HqpXWlZMMEv9MgwDntuYfI=;
        b=IyanyqnmTCMKB4RqbQSFHPjDGVvmzphtNi714G7xbuBqtTJl8J/hGsc5qRph0VDM/g
         FwyN/ZEBAQ56D12UXd4gvrfn8DKlc0jhjUZTMKj4iV1GRokdpQmlt3bGTgCmIq0MwgLN
         syOLWwcs0J0adkKtdyKUsBLB39o2EP4R7CNOMfM0OD1aoQXjdSl24GpmhmjXt0bQoI92
         0ex1RLfOxjbbA124Czs7C4NqONbb1Ft+7/dS/HJbODVjPX+aZSLB5bxVd52EDakerF9x
         kB2yNgFonVqw28/IQgGZ0S2x1KLI2ib5mm8+ZXxYq2aGEh0sOJtpMmaax0lNkbOPgNKu
         7teg==
X-Gm-Message-State: AOAM530/8sElxmpvTdtvaTSjJpG6JfMIitdfdJxerMMBHswrQmCiROLj
        7lFUBznVS34TrESMfm6Fw2Q=
X-Google-Smtp-Source: ABdhPJyibHMnihiC0574sNDxXNrOcHiaAMIMFa3z4Ekl5pG/R2BSC8trht8IPOHPY1KSgB3OhyKv7A==
X-Received: by 2002:a17:90a:dd46:: with SMTP id u6mr10740023pjv.67.1602336156275;
        Sat, 10 Oct 2020 06:22:36 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id in6sm14805090pjb.42.2020.10.10.06.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2020 06:22:35 -0700 (PDT)
Date:   Sat, 10 Oct 2020 22:22:30 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     devel@driverdev.osuosl.org, Shung-Hsi Yu <shung-hsi.yu@suse.com>,
        Manish Chopra <manishc@marvell.com>,
        "supporter:QLOGIC QLGE 10Gb ETHERNET DRIVER" 
        <GR-Linux-NIC-Dev@marvell.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:QLOGIC QLGE 10Gb ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 2/6] staging: qlge: coredump via devlink health
 reporter
Message-ID: <20201010132230.GA17351@f3>
References: <20201008115808.91850-1-coiby.xu@gmail.com>
 <20201008115808.91850-3-coiby.xu@gmail.com>
 <20201010074809.GB14495@f3>
 <20201010100258.px2go6nugsfbwoq7@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201010100258.px2go6nugsfbwoq7@Rk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-10 18:02 +0800, Coiby Xu wrote:
[...]
> > > +	do {                                                           \
> > > +		err = fill_seg_(fmsg, &dump->seg_hdr, dump->seg_regs); \
> > > +		if (err) {					       \
> > > +			kvfree(dump);                                  \
> > > +			return err;				       \
> > > +		}                                                      \
> > > +	} while (0)
> > > +
> > > +static int qlge_reporter_coredump(struct devlink_health_reporter *reporter,
> > > +				  struct devlink_fmsg *fmsg, void *priv_ctx,
> > > +				  struct netlink_ext_ack *extack)
> > > +{
> > > +	int err = 0;
> > > +
> > > +	struct qlge_devlink *dev = devlink_health_reporter_priv(reporter);
> > 
> > Please name this variable ql_devlink, like in qlge_probe().
> 
> I happened to find the following text in drivers/staging/qlge/TODO
> > * in terms of namespace, the driver uses either qlge_, ql_ (used by
> >  other qlogic drivers, with clashes, ex: ql_sem_spinlock) or nothing (with
> >  clashes, ex: struct ob_mac_iocb_req). Rename everything to use the "qlge_"
> >  prefix.

This comment applies to global identifiers, not local variables.

> 
> So I will adopt qlge_ instead. Besides I prefer qlge_dl to ql_devlink.

Up to you but personally, I think ql_devlink is better. In any case,
"dev" is too general and often used for struct net_device pointers
instead.
