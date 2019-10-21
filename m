Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAFB4DF858
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 01:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbfJUXAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 19:00:32 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35304 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730276AbfJUXAc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 19:00:32 -0400
Received: by mail-pf1-f193.google.com with SMTP id 205so9363491pfw.2
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 16:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=SURSLeTSL7wuoZg4pBrgsadycsCRF2eCp03BsgMlMG0=;
        b=Meag7SAC6vW6yZS/oje7Wm85r+tkPnshrrX39endzp5QbpqHafCu2b5AXixNaxzyr2
         T0exF/nmDvNL6CK8t1HHVa/h+HdJSIQk/eVvIaVSUfJrmllzSibBHLek3MEJ+3WTpwFQ
         WNIOZv+NBWPOWfhffKEsVZc57W2r5RaQfk/xalhlm0MVkqj84GnTsmODiBjry3GbaDNR
         hEiAeZh/gdpzHD2Ky2Rdr/LbKFtZkBaOceFV/qRATTFS7WowRiOOo6AuhX77xP0w62Ul
         mjKL9ho2bijjXbK3kF5O2f3TT3ctDRA1oJf8dvFieS2zbAHUiF5n76su+tUwwvUiYTpH
         sQFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=SURSLeTSL7wuoZg4pBrgsadycsCRF2eCp03BsgMlMG0=;
        b=XEvAhQyF52+TIxozwjKn5IjqnCQaxjaB6RdV3BAt3a1Bd2NT/16yNEW2+Hz8X215+E
         VmeDEgO9LfsuF8pjgJqlAQhRCTP1fT7F+MaCC8nZhZk7kIk48kbciH8haafVBzbsxJD8
         jMCoZvVWreLq8boahs9Tt1s1baquccuuxXqM5jMRjAmD617jQK7fwp2gy6TbMjjmUzX4
         aoIoZQJ0oR+sXbmttU1qEF62Cxs7HE5reJ/9IlAiNEtfSbPS8FJ0UOfMxiS1Q1Qkj9/s
         FT+L8QcowvaEVNwNyr3CsSjXmEGDeND51kwfRcYB8Uc/QXqc5FUNtprTk/FshwucgURW
         YU9w==
X-Gm-Message-State: APjAAAXZmyf1bJM/cPC3vc8Yd3Q6qOyzPqr4gUbQdmF/FXxL/5RmQ52P
        rmU2vwWZdFVY5BP1WHvXNCWcFw==
X-Google-Smtp-Source: APXvYqxYZ2jJ5duUjyqvYuT3lNSHH1ZL2DYp2WDXFH7Aqd7Rk+5j9fUuqhsckt6C5FN5vrOBYczPCA==
X-Received: by 2002:a63:18d:: with SMTP id 135mr328237pgb.326.1571698831249;
        Mon, 21 Oct 2019 16:00:31 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id a16sm16448156pfa.53.2019.10.21.16.00.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 16:00:30 -0700 (PDT)
Date:   Mon, 21 Oct 2019 16:00:26 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        =?UTF-8?B?UmFmYcWC?= =?UTF-8?B?IE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] bnxt_en: Add support to collect crash dump via
 ethtool
Message-ID: <20191021160026.18b3491e@cakuba.netronome.com>
In-Reply-To: <CAACQVJp1R-9frrgjn6=5s_f3AGBq-fyy5CsYdAio1e=c9iLB9g@mail.gmail.com>
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
        <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com>
        <20191017122156.4d5262ac@cakuba.netronome.com>
        <CAACQVJrO_PN8LBY0ovwkdxGsyvW_gGN7C3MxnuW+jjdS_75Hhw@mail.gmail.com>
        <20191018100122.4cf12967@cakuba.netronome.com>
        <CAACQVJp1R-9frrgjn6=5s_f3AGBq-fyy5CsYdAio1e=c9iLB9g@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 10:05:18 +0530, Vasundhara Volam wrote:
> On Fri, Oct 18, 2019 at 10:31 PM Jakub Kicinski wrote:
> > On Fri, 18 Oct 2019 12:04:35 +0530, Vasundhara Volam wrote:  
> > > On Fri, Oct 18, 2019 at 12:52 AM Jakub Kicinski wrote:  
> > > > On Thu, 17 Oct 2019 17:31:22 +0530, Sheetal Tigadoli wrote:  
> > > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > > index 51c1404..1596221 100644
> > > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > > > > @@ -3311,6 +3311,23 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
> > > > >       return rc;
> > > > >  }
> > > > >
> > > > > +static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
> > > > > +{
> > > > > +     struct bnxt *bp = netdev_priv(dev);
> > > > > +
> > > > > +#ifndef CONFIG_TEE_BNXT_FW
> > > > > +     return -EOPNOTSUPP;
> > > > > +#endif  
> > > >
> > > >         if (!IS_ENABLED(...))
> > > >                 return x;
> > > >
> > > > reads better IMHO  
> > > Okay.
> > >  
> > > >
> > > > But also you seem to be breaking live dump for systems with
> > > > CONFIG_TEE_BNXT_FW=n  
> > > Yes, we are supporting set_dump only if crash dump is supported.  
> >
> > It's wrong.  
>
> Sorry not very clear. You are saying that support set_dump all the
> time and return error, if the config option is not enabled? If yes, I
> will modify the same way as it makes sense.

Yes, I think users can expect that set will work even if there is only
one dump type/flag supported. Technically implementing the set is not
required from functional perspective, however, we could imagine
software that always does a set before a get, and the set should not
fail.
