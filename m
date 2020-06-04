Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07BB91EE8CE
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 18:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgFDQrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 12:47:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54453 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728587AbgFDQrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 12:47:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591289257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Ar15+z0tlu8GE0Wg5KZSeq2GZEzeqWT+aUmm+wx7x4=;
        b=JKDlcDidL2Gw8r+tRUM3Q1eDKDdgbwOHBOW+NFJWNDo2S2UHrwVUFtcBllNb1uqXQPWiFj
        mjgwom8Px1AZNOAVZP6vEXTxij7e4+Y1OKg8hZJzN4rLxAPOwmI19135gmq9PLP7JUSX1C
        b4UqU9gz6EdGUTanr84/QSQPYNuvTi4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-X1YOkOV6OlqrVF6jr_Psbw-1; Thu, 04 Jun 2020 12:47:35 -0400
X-MC-Unique: X1YOkOV6OlqrVF6jr_Psbw-1
Received: by mail-wm1-f69.google.com with SMTP id y202so1972524wmd.0
        for <netdev@vger.kernel.org>; Thu, 04 Jun 2020 09:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Ar15+z0tlu8GE0Wg5KZSeq2GZEzeqWT+aUmm+wx7x4=;
        b=jxjwZCJFnTPYWm7qQX/qQx09ksQnpo1QgsY1WIfeRnBbjIB2+rXh2aPEa9+IuL0Lqi
         rn2nWg+enOYc4edl/iqfh4QVpK1PFeXR+wJ+uus6NsCSA0llrQW778SUmK44e3BhKS9i
         sv9OrDB7KhGiKIXe6BqlRhWfvpi4VahQaz4z0MHLyh24A0dPH9JZ19/8dSW/oZ2cxoak
         ndg4A9Oy/tYguILi5vqprJBqFTl8hpz2qx3ennc+9v4XldbvkH/kjCo3nqf11GXGV9u3
         L+zYvTbMukDPXiSPSQUljTOrRRQrqGer0wj3w0Ug65hiptG8qm+yrAq0I9W29lNt0tHE
         jazw==
X-Gm-Message-State: AOAM532eeO0NlvfV9uz0d5/eiJztCMYiP3cwURkObgJnf3OnBKAhCAKI
        PmYxdMLTstQ/NqpITQoqXzRlAPs/j8fwXLXgxQNrOSGytK2LSxUKWH0wQpyxLwF7T9I3FvQpQG+
        CyIO0AzkpwG76q3o6
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr5209774wrq.218.1591289254184;
        Thu, 04 Jun 2020 09:47:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/oB1XkJnvn++j/58MNAY5P5qdvPGtsdrzBj0W/ri36XSP6zrbEREeugPFE4b1qeLilItQwQ==
X-Received: by 2002:a5d:40d0:: with SMTP id b16mr5209770wrq.218.1591289254041;
        Thu, 04 Jun 2020 09:47:34 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id v6sm118202wrf.61.2020.06.04.09.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2020 09:47:33 -0700 (PDT)
Date:   Thu, 4 Jun 2020 12:47:31 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200604124703-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
 <20200604054516-mutt-send-email-mst@kernel.org>
 <20200604150335.GG23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200604150335.GG23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 04, 2020 at 04:03:35PM +0100, Al Viro wrote:
> On Thu, Jun 04, 2020 at 06:10:23AM -0400, Michael S. Tsirkin wrote:
> 
> > 	stac()
> > 	for (i = 0; i < 64; ++i) {
> > 	 get_user(flags, desc[i].flags)
> unsafe_get_user(), please.
> > 	 smp_rmb()
> > 	 if (!(flags & VALID))
> > 		break;
> > 	 copy_from_user(&adesc[i], desc + i, sizeof adesc[i]);
> ... and that would raw_copy_from_user() (or unsafe_copy_from_user(),
> for wrapper that would take a label to bugger off to)
> > 	}
> > 	clac()

Absolutely, that's all just pseudo-code.

-- 
MST

