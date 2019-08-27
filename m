Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 484019DC9A
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 06:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfH0E2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 00:28:35 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39998 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfH0E2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 00:28:35 -0400
Received: by mail-pf1-f194.google.com with SMTP id w16so13238887pfn.7
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 21:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=NqnHiYzJ4BYHQyPtsFv76OWt51CQNuhNKxcO+CYF0/Q=;
        b=0gANrULXITVolM+u2dtYOM8TFZ80AkCVCfOJf9XjEYmgwTVs3esGJpNGhDMoSac4NF
         Pa9XitC35PQhEzcE4/WEEsnmGsZPZJI87xSPzRj3rMsAZpTLsPtDTpNmo+BVbege2jWI
         uOl512NSQQyoYqHPqNbLbkfbucCIJfL3xN4bruMAPaBUk5gYC2oZPg5DSlRV0EDrlmdh
         rNnK7md9VtZ4tNDOfq97k7/dTz2/JSJPCOyqzsObwcMte9M2oOWBbEM/lUTd3j67QuAS
         kyH1DzTMxIRpT+SnUUfDEz8cGH4gN7Qb2PEczy2EoiOFBaW0BCqYYm0jDnw7fUoSX7LR
         U3HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=NqnHiYzJ4BYHQyPtsFv76OWt51CQNuhNKxcO+CYF0/Q=;
        b=SWKQnBRozvCJjGv6v9Txk3wmlAlaEdfbrDdIeROAGLd36ySYfk8mrI1ubLij4Ig5/N
         9n1iQqjng+rDeHEJ7Ae8C7eKOh9u7aAlrGffGBFGd/l91xm5cRm5i9XhmpARxtbglJJ3
         STlXYkBfjJTOoAplwIrOo6RnMCxuV4OCl7cwDSO08IybUR/muvEUwjJvbjoNPPeqa+vK
         R0Kbfm1NLkOS5QkqeBSJ2niieuItQvjaRTecVKzX6TKwcRCyJR+X61EXh8hDjG6k6nmg
         u5M7bDmpC3SomKKfaX/QjHwrNRcISBZXVDF+WYlr0uUPhdCLU/aZWfuEyK83mxKtI9TS
         es4g==
X-Gm-Message-State: APjAAAUQuapHK96jTkDnpAPh3GssKNcbwsriTpb7pt4RiRm8BgqYDcsF
        UXFRuT/wLZzsanXSJPMQ/xt2d4OFgtU=
X-Google-Smtp-Source: APXvYqwawMjFjBKnSpfeHqZ43m5z6NQdpXegndNnsUH2ifZ/fRf8I6xlsRx+ruHxuuR6V0EeF1dZoA==
X-Received: by 2002:a63:cc14:: with SMTP id x20mr19780512pgf.142.1566880114397;
        Mon, 26 Aug 2019 21:28:34 -0700 (PDT)
Received: from cakuba.netronome.com (c-71-204-185-212.hsd1.ca.comcast.net. [71.204.185.212])
        by smtp.gmail.com with ESMTPSA id m4sm12737459pgs.71.2019.08.26.21.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 21:28:34 -0700 (PDT)
Date:   Mon, 26 Aug 2019 21:28:19 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Shannon Nelson <snelson@pensando.io>, netdev@vger.kernel.org,
        davem@davemloft.net
Subject: Re: [PATCH v5 net-next 02/18] ionic: Add hardware init and device
 commands
Message-ID: <20190826212809.7bf85333@cakuba.netronome.com>
In-Reply-To: <20190827022628.GD13411@lunn.ch>
References: <20190826213339.56909-1-snelson@pensando.io>
        <20190826213339.56909-3-snelson@pensando.io>
        <20190827022628.GD13411@lunn.ch>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 04:26:28 +0200, Andrew Lunn wrote:
> > +int ionic_identify(struct ionic *ionic)
> > +{
> > +	struct ionic_identity *ident = &ionic->ident;
> > +	struct ionic_dev *idev = &ionic->idev;
> > +	size_t sz;
> > +	int err;
> > +
> > +	memset(ident, 0, sizeof(*ident));
> > +
> > +	ident->drv.os_type = cpu_to_le32(IONIC_OS_TYPE_LINUX);
> > +	ident->drv.os_dist = 0;
> > +	strncpy(ident->drv.os_dist_str, utsname()->release,
> > +		sizeof(ident->drv.os_dist_str) - 1);
> > +	ident->drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
> > +	strncpy(ident->drv.kernel_ver_str, utsname()->version,
> > +		sizeof(ident->drv.kernel_ver_str) - 1);
> > +	strncpy(ident->drv.driver_ver_str, IONIC_DRV_VERSION,
> > +		sizeof(ident->drv.driver_ver_str) - 1);
> > +
> > +	mutex_lock(&ionic->dev_cmd_lock);
> > +  
> 
> I don't know about others, but from a privacy prospective, i'm not so
> happy about this. This is a smart NIC. It could be reporting back to
> Mothership pensando with this information?
> 
> I would be happier if there was a privacy statement, right here,
> saying what this information is used for, and an agreement it is not
> used for anything else. If that gets violated, you can then only blame
> yourself when we ripe this out and hard code it to static values.

FWIW seems like a fair ask to me..
