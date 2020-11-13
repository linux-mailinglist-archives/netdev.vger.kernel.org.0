Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88A02B17B7
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 10:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKMJCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 04:02:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:28796 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726160AbgKMJCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 04:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605258152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=f3wfP3kxofuVsruhI2zT5MMo+kDwOOpdbwEJ1OIOgxw=;
        b=TA87uX68PvdIR9U77D4vJPE+VySTVnfpruerp8NnuP70S+GPIW3UHglTbcbqOJypFjrb2a
        t4IgxDDvNaglWL/jIA+3ldWEwuh8gUANKWVShR5GbZE5paHygU6Urmd+Imf3R5y7YfjkwW
        JE4FAfTC6GdfBAYn40tximw+qu7X45A=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-Iiq5Rh9lMPWFYwaVOQ_pKg-1; Fri, 13 Nov 2020 04:02:30 -0500
X-MC-Unique: Iiq5Rh9lMPWFYwaVOQ_pKg-1
Received: by mail-wm1-f72.google.com with SMTP id a130so4937893wmf.0
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 01:02:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f3wfP3kxofuVsruhI2zT5MMo+kDwOOpdbwEJ1OIOgxw=;
        b=s7BKmfQje/xImbzpjy5RitZLAHv0X5toK0VT5Iw9dg1/4EAuPSEUDQ1z85n0wFPybz
         srSFYM5x5vjzbR4OctXxIQNqjUx25Mh94fVoqJHqXoky/KOSrDbb+y4kgbjKFMfyLy1r
         pMhg6X0U9c9TbkiO++DaYULVX5O1YUT5YX/jUZT0t2GJlIl+5jYpC55zj9EfpO8xSCu5
         zx6mTdm/fQ0W3H5Azclv6YsbTxO64twhIWV3zNFIOQweqtXtpv7PYOB+pSoJUSb/IBD/
         ULaJ78ttsDR/s1P++ES1+FUcitAMh/Pe6OhHFKihuWf9zIE6mYOm9eGLFQS3nsNimoiw
         uVeQ==
X-Gm-Message-State: AOAM530egFsqjZoDBqdlMziUJ1GI4H91OM6kATMmK5ra39WNqhbrE9/A
        8YfLM2CmrkduzPseUf4xAYW+M9UIZAX7Oo0fWv883FTC4ODKtCAzMBYaYgNQJXWbNJsJkPI7x6Z
        vqplsld3O+TDzj/w9
X-Received: by 2002:adf:8465:: with SMTP id 92mr2007983wrf.50.1605258148674;
        Fri, 13 Nov 2020 01:02:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxw5dpQCpn8i0VqqtoOH7Wg3KMU1Nqz+OwHCyG+xh9hp2qTrmyJNR4Mn0b3DOc88e3YjlkMCg==
X-Received: by 2002:adf:8465:: with SMTP id 92mr2007953wrf.50.1605258148457;
        Fri, 13 Nov 2020 01:02:28 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n15sm10356701wrq.48.2020.11.13.01.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 01:02:27 -0800 (PST)
Date:   Fri, 13 Nov 2020 10:02:25 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Russell Strong <russell@strong.id.au>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: DSCP in IPv4 routing
Message-ID: <20201113090225.GA25425@linux.home>
References: <20201113120637.39c45f3f@192-168-1-16.tpgi.com.au>
 <20201112193656.73621cd5@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112193656.73621cd5@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 07:36:56PM -0800, Stephen Hemminger wrote:
> On Fri, 13 Nov 2020 12:06:37 +1000
> Russell Strong <russell@strong.id.au> wrote:
> 
> > diff --git a/include/uapi/linux/in_route.h
> > b/include/uapi/linux/in_route.h index 0cc2c23b47f8..db5d236b9c50 100644
> > --- a/include/uapi/linux/in_route.h
> > +++ b/include/uapi/linux/in_route.h
> > @@ -28,6 +28,6 @@
> >  
> >  #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
> >  
> > -#define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
> > +#define RT_TOS(tos)	((tos)&IPTOS_DS_MASK)
> >  
> 
> Changing behavior of existing header files risks breaking applications.
> 
> > diff --git a/net/ipv4/fib_rules.c b/net/ipv4/fib_rules.c
> > index ce54a30c2ef1..1499105d1efd 100644
> > --- a/net/ipv4/fib_rules.c
> > +++ b/net/ipv4/fib_rules.c
> > @@ -229,7 +229,7 @@ static int fib4_rule_configure(struct fib_rule
> > *rule, struct sk_buff *skb, int err = -EINVAL;
> >  	struct fib4_rule *rule4 = (struct fib4_rule *) rule;
> >  
> > -	if (frh->tos & ~IPTOS_TOS_MASK) {
> > +	if (frh->tos & ~IPTOS_RT_MASK) {
> 
> This needs to be behind a sysctl and the default has to be to keep
> the old behavior

Can't we just define a new DSCP mask and replace the users of TOS one
by one? In most cases DSCP just makes the 3 highest bits available,
which souldn't change existing behaviours. We just need to pay
attention to the ECN bit that'd be masked out by DSCP but not by old
TOS. However, ECN has been supported for a long time, so most usages of
TOS already clear both ECN bits.

Let's not add a new sysctl if not necessary and, in any case, let's not
change macros blindly.

