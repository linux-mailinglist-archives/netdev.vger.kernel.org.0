Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CE43B33B8
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 18:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbhFXQSW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 12:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbhFXQSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 12:18:21 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E806FC061574;
        Thu, 24 Jun 2021 09:16:01 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id s17-20020a17090a8811b029016e89654f93so6239959pjn.1;
        Thu, 24 Jun 2021 09:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZiDQnFW1mi3okwHaS+e+SImAJ13yTfe8NvkJt2OVSpU=;
        b=jwsAfKyVrpVBMxgh2LcwXgPb2LsA+daQ0Pfiz2wGhvFO2HUYH2Awk/AKFmHmbxCQWr
         Gwooxo97rcqJRQnkz8/FnEGD3soF26WXeJd+0SNODs7i+vU1SEpTSVXQhCP1DVqFt9Gx
         4f+wFR+Cw7KXqfiEFQI5Zeb3Q+NHhDFkgUnKhVWGV4KxE6YbOfhQSUnZ8MEHeTF7bW+n
         yk7tSFOdD/5x9ur1Cm6WxDLMHfilrsFbJUv1li2CH6JTH+T/KOMw8nunoVSMUhWrw2gL
         igKIKZ7sfyxDbj7A/r0h4XF2xPvch5HtjaYv9LfdfSh/Clkw10oWOJgWHvsXqIa8aw8Y
         K4BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZiDQnFW1mi3okwHaS+e+SImAJ13yTfe8NvkJt2OVSpU=;
        b=IFHIfnkZ4x+D1xkJKuYypQMqxqkKUoiDAQPSFSBQq2orpAdPK3256HoNCb+R5fahnp
         onhq87dwSI8yHYQirHGagPRUnhTmywBkb4xtWTGjKgpKgov4iHuO26oARCKmYUfuoe7a
         nbmnkPA25JflRjRYqhMuJm2KoyxoTz+yicArvkXQ4Lqkuxu1bzXD5IHjIY1A4es2hDl/
         n15BPlrXzMigIAo5mt+naD33wSeNuvoVxo7/Eyu/aNb9Jm0QmMse52hH4fu8sziq66Nz
         KeUfMpliYhkCtkl17gDeYG/e/1o2K2l7Q7+VyqMMphByjDH6qIG7ZQVWiR+maNa1pvUv
         VjCw==
X-Gm-Message-State: AOAM5315NYrwwr8rFlvcsKryp7Cw1gkYYoPsOsPVOFuPegLc+0gLqPSM
        m8qYAx8JBK7trK1woAXmTaQzTaNrkQs=
X-Google-Smtp-Source: ABdhPJyWK22OqMv1lrNcxYGWDs16Ewo9gHHXpG+JsqbmIHeiSbZtxwtjiAl+gyT0Tc6kOq5rarIk/g==
X-Received: by 2002:a17:90b:1bcb:: with SMTP id oa11mr6104216pjb.29.1624551361524;
        Thu, 24 Jun 2021 09:16:01 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z6sm2906628pgs.24.2021.06.24.09.16.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 09:16:01 -0700 (PDT)
Date:   Thu, 24 Jun 2021 09:15:58 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] ptp: idt82p33: implement double dco time
 correction
Message-ID: <20210624161558.GD15473@hoboy.vegasvil.org>
References: <1624459585-31233-1-git-send-email-min.li.xe@renesas.com>
 <1624459585-31233-2-git-send-email-min.li.xe@renesas.com>
 <20210624034343.GB6853@hoboy.vegasvil.org>
 <OS3PR01MB659335F4857D1FD1E8977C24BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3PR01MB659335F4857D1FD1E8977C24BA079@OS3PR01MB6593.jpnprd01.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 02:40:52PM +0000, Min Li wrote:
> > What happens if user space makes a new adjustment before this completes?
> > 
> > After all, some PTP profiles update the clock several times per second.
> > 
> > Thanks,
> > Richard
> 
> Hi Richard
> 
> In that case, adjtime would simply return without doing anything as in

This is not what user space expects.

Thanks,
Richard
