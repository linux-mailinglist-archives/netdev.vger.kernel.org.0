Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC33DF1DD
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 17:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237153AbhHCP4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 11:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbhHCP4L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 11:56:11 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74054C061757;
        Tue,  3 Aug 2021 08:56:00 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id u16so15720613ple.2;
        Tue, 03 Aug 2021 08:56:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ivy58r2kivR0IDLu2ysn29+/bFLlJiQgmJM5f0+1TU8=;
        b=YpvHrlLtAC/82eD1F5VPmxocamDF2v/5NUkB+nZG2kScLLhe1HmgaWo6cxJ3DD14qb
         CXx4sL+W0TNp+R6i2/Gjf9NPFOsgwDBvB1V+iqu1jxYQ6P2IU64R55QtY9x4T2bkRFXv
         6dqlrn5y3NZCjUKOO8B5nvIg45bINpE7zY4CQzGj62GrdjMcVGCpanLNuUMdzYgvgh5n
         Y100Mh+uB9ntJve6v0LYoe9Vufn+0yv3K8/3MfC8H2qf84CjVXoYLWNYFCOebIkpELUi
         D00onjRAMXrNLN95dUNsof6ZX3ne2VFN/1iK8Ml1iZZL6splVPQCHdFJ3R+4DAQhRv7Q
         U2dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ivy58r2kivR0IDLu2ysn29+/bFLlJiQgmJM5f0+1TU8=;
        b=UECw4fI03DYz5O4qreH1NdNJ2+A5INtTx0A4l5Z9z+SNt4UnCB3Xjg4KBuImJ/tIfB
         BkSnVi2w6j2Znx9KdBkGYO5SNj2281Pl/SeoCzfQ4bXqrLTCHdiBCzgvTde44mr0LJff
         aylErdfcahZpTLfDnepJ/POGAATK5L2KCDo8QJnzTr/Sf/STH+WCsBfBgw6xdbQxyE8Q
         Q+nWMKYT5xNC0FvtFRdoa/6FXkawvkzSfVZ0yxuP0QRJEUWJCEqJOmi2lVGUS7ZIxBGi
         KxCXSISIhS2+rVcau6qmx1J3HtcrVniw9bVy2jK9tE5MRPGbhOiHtMb9g89iiOhgiTNT
         /3GQ==
X-Gm-Message-State: AOAM533EFN4BdezrQP+HQUZqUcMH1NlKJI3WJOOyYe6s73YOx1hLsgBV
        TCwDd4tGSAAR2ZJfrcGHU1w=
X-Google-Smtp-Source: ABdhPJwi+PBAE9X9yHieg25vVfZDqPdndcDuK9bQP9ZkhxyH4kFOLvw+2FG9Yp3HU+c/jslReS1V1A==
X-Received: by 2002:a17:90a:d245:: with SMTP id o5mr5168127pjw.105.1628006160005;
        Tue, 03 Aug 2021 08:56:00 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id r4sm14461041pjo.46.2021.08.03.08.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 08:55:59 -0700 (PDT)
Date:   Tue, 3 Aug 2021 08:55:56 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "Keller, Jacob E" <jacob.e.keller@intel.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Message-ID: <20210803155556.GD32663@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:59:02AM +0200, Arnd Bergmann wrote:
> It may well be a lost cause, but a build fix is not the time to nail down
> that decision. The fix I proposed (with the added MAY_USE_PTP_1588_CLOCK
> symbol) is only two extra lines and leaves everything else working for the
> moment.

Well, then we'll have TWO ugly and incomprehensible Kconfig hacks,
imply and MAY_USE.

Can't we fix this once and for all?

Seriously, "imply" has been nothing but a major PITA since day one,
and all to save 22 kb.  I can't think of another subsystem which
tolerates so much pain for so little gain.

Thanks,
Richard


> I would suggest we merge that first and then raise the question
> about whether to give up on tinyfication on the summit list, there are a few
> other things that have come up that would also benefit from trying less hard,
> but if we overdo this, we can get to the point of hurting even systems that are
> otherwise still well supported (64MB MIPS/ARMv5 SoCs, small boot partitions,
> etc.).
> 
>         Arnd
