Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 342032D5F08
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 16:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389987AbgLJPHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 10:07:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728583AbgLJPHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 10:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607612757;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khxT6pUMdR2mxgS2Mi2C6ZZ45vuS7ItaY0pGKhuziXM=;
        b=iqjhh9AaZJtxWLoWROGmHXuGmqVUMoF4K8w28MgReqJULN3LrQS4QNOZvCQGLBWctebEoD
        yvPD5HildOQALrwzf2eeVQYTuayEm1NcbL3eqL00CgXAi2EI7K8I3/L6+KdPsgDx+C+9BD
        pwflA1WIpU2z8h9HtHdURhmmVV3ffd4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-218-xPOlaioRMhmHHEIqEPoAtQ-1; Thu, 10 Dec 2020 10:05:55 -0500
X-MC-Unique: xPOlaioRMhmHHEIqEPoAtQ-1
Received: by mail-wr1-f72.google.com with SMTP id r11so2025102wrs.23
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 07:05:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=khxT6pUMdR2mxgS2Mi2C6ZZ45vuS7ItaY0pGKhuziXM=;
        b=gsWcalpypQdQgv74pwjr5ejxeYREcBcaFW1rgH11GohmWdIVw2ylH2Dr30RzPCW9Q7
         AZgWO9L14OBEYF3hBbbxpq7M4oC5NKddPzLJUgBOgLT8WuS8Atv7Et/r6esHWd4rhNAX
         N3vWdwSr3jaRqOIDG00hKaUtQWhMenUELs4q8T7ZV4Pmdbc8o8zgSelYGzxtkEh/yCnA
         0m9tBY0beL/DSejmt/T7hTApZ+lDrClpVGUwIhleaKzFwy2yaC+2mA6yVgAweimZokBl
         ooo9rVL82AGyx6fQ+Gu+oIUvEpF2y9S/UEoDgusSTdnjifDxnuAitn71BBhirADhgsFw
         N12Q==
X-Gm-Message-State: AOAM533cjQOQuRL2a/mkXodulHc/eaF43QuiGrFHrKLL/Lre9TDjtoIp
        YCCkhbZWXduaJMhw/1nZg8k1XPpj20FaVKK4crMSrttYF5reC1q5XChVIyOUK2hkjSsf1CswA+U
        CfqpFAxngNSlzTuuN
X-Received: by 2002:a1c:2ecc:: with SMTP id u195mr8721302wmu.27.1607612754110;
        Thu, 10 Dec 2020 07:05:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7WiFSWbCg5G0joZN2ownFDmDy9om4yBZOlOZTjl+C6iRbxwARnV65pX4O2qI2SaD/pK5juA==
X-Received: by 2002:a1c:2ecc:: with SMTP id u195mr8721285wmu.27.1607612753914;
        Thu, 10 Dec 2020 07:05:53 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z64sm9227720wme.10.2020.12.10.07.05.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 07:05:53 -0800 (PST)
Date:   Thu, 10 Dec 2020 16:05:51 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v3 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201210150551.GB15778@linux.home>
References: <20201204163656.1623-1-tparkin@katalix.com>
 <20201204163656.1623-2-tparkin@katalix.com>
 <20201207162228.GA28888@linux.home>
 <20201210144623.GA4413@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210144623.GA4413@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 02:46:23PM +0000, Tom Parkin wrote:
> On  Mon, Dec 07, 2020 at 17:22:28 +0100, Guillaume Nault wrote:
> > On Fri, Dec 04, 2020 at 04:36:55PM +0000, Tom Parkin wrote:
> > > +		case PPPIOCBRIDGECHAN:
> > > +			if (get_user(unit, p))
> > > +				break;
> > > +			err = -ENXIO;
> > > +			pn = ppp_pernet(current->nsproxy->net_ns);
> > > +			spin_lock_bh(&pn->all_channels_lock);
> > > +			pchb = ppp_find_channel(pn, unit);
> > > +			/* Hold a reference to prevent pchb being freed while
> > > +			 * we establish the bridge.
> > > +			 */
> > > +			if (pchb)
> > > +				refcount_inc(&pchb->file.refcnt);
> > 
> > The !pchb case isn't handled. With this code, if ppp_find_channel()
> > returns NULL, ppp_bridge_channels() will crash when trying to lock
> > pchb->upl.
> 
> Bleh :-(
> 
> Apologies for this.  I have stepped up my tests for "unhappy" code
> paths, and I'll try to run syzkaller at a v4 prior to re-submitting.

No problem, sorry for not having spotted the problem in your previous
version. BTW, note that net-next is probably about to close.

> > > +			spin_unlock_bh(&pn->all_channels_lock);
> > > +			err = ppp_bridge_channels(pch, pchb);
> > > +			/* Drop earlier refcount now bridge establishment is complete */
> > > +			if (refcount_dec_and_test(&pchb->file.refcnt))
> > > +				ppp_destroy_channel(pchb);
> > > +			break;
> > > +
> > 
> > The rest looks good to me.
> 
> Thanks!


