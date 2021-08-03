Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980F3DF249
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbhHCQPt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:15:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbhHCQP3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:15:29 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58227C06179E;
        Tue,  3 Aug 2021 09:14:38 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id t3so22221283plg.9;
        Tue, 03 Aug 2021 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=E9dbUJDad8OiM9R3ggYpWCXMN+1fcOESzDIg2KJQygw=;
        b=DXb1TeufSEOKzA1N8WwwJgNTA95J9va75S/3IZ1UmG4lb1BCe1SX7mW2nTIWgWHvIp
         haLoj13+rka/QsRm9dtIcjP3Q6ICjbi0VZwwEsWARisrhmKJKhku4HKRLDmzksA7GB7J
         BiIVSAo2zCKyiv8NDcS8PslY1pq4GMKTDEkxn/TQimOqOvh8vwDDNzPKXhZCd47F3mDA
         fQYVucAuQP8buLmOP6fkGFNCVwzG7vWWO+ZBSq2jROFSTVzGRAquHYkBgmuTK6V7UEKU
         4zhc48KTyOpUSjn8skQ6LWN8uWfELZ9eYOwXg0cFWLhGun8NamGjNOX6GDp9NNCy5Gt+
         Qfzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=E9dbUJDad8OiM9R3ggYpWCXMN+1fcOESzDIg2KJQygw=;
        b=V8sUqOGVqVa5DKJJhvIiV2GgDbI/zNAfgqo7XKyp8wSwMOT7eFOYwGdFT63Hlq2ZBp
         fGkAykB/l1aojtCViGWAD2W4C9UbXMc+Ag7nGlJ7wavnyi+Zp+HM7tDG8oddik3u/iIa
         RQWSd/SnerRXRLE6RZMuOjepHOyqo1eedP8Lm3oZNrswf3zS3XiANcAOTc8svli06NAC
         I/EcLRPNjmmgZIhWUcBt8KiD/3Ip0YAwIfNzOwuGFUwhUmzVBPDTa9XCER1vqVu1fuuu
         9q9s3MhVWJ/ZtkWPEs14Z4e4LndI1YicgUpbR1BQfiZWoj6KL0IYF8UildXQsVP7Y+co
         7VhQ==
X-Gm-Message-State: AOAM533sJ6VlvH4KZ7CuDpq+EGqLGjgyJ/ZJ1kN7fnWk77XdSWTyMrMI
        2BVN2wIiEl6KnHOU5kd7Qcg=
X-Google-Smtp-Source: ABdhPJxVcHpsP99XpPOvvXRfpcDZM8Dnodn7xITd7SwrzdMcSWsPw5ipwGU/7tr/vJQZGRcWCj6LPA==
X-Received: by 2002:aa7:99c1:0:b029:39a:56d1:6d43 with SMTP id v1-20020aa799c10000b029039a56d16d43mr22828297pfi.58.1628007277881;
        Tue, 03 Aug 2021 09:14:37 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:2163:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id t8sm18482127pgh.18.2021.08.03.09.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:14:37 -0700 (PDT)
Date:   Tue, 3 Aug 2021 09:14:34 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Nicolas Pitre <nico@fluxnic.net>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
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
Message-ID: <20210803161434.GE32663@hoboy.vegasvil.org>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210803155556.GD32663@hoboy.vegasvil.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:55:56AM -0700, Richard Cochran wrote:
> On Tue, Aug 03, 2021 at 08:59:02AM +0200, Arnd Bergmann wrote:
> > It may well be a lost cause, but a build fix is not the time to nail down
> > that decision. The fix I proposed (with the added MAY_USE_PTP_1588_CLOCK
> > symbol) is only two extra lines and leaves everything else working for the
> > moment.
> 
> Well, then we'll have TWO ugly and incomprehensible Kconfig hacks,
> imply and MAY_USE.
> 
> Can't we fix this once and for all?
> 
> Seriously, "imply" has been nothing but a major PITA since day one,
> and all to save 22 kb.  I can't think of another subsystem which
> tolerates so much pain for so little gain.

Here is what I want to have, in accordance with the KISS principle:

config PTP_1588_CLOCK
	bool "PTP clock support"
	select NET
	select POSIX_TIMERS
	select PPS
	select NET_PTP_CLASSIFY

# driver variant 1:

config ACME_MAC
	select PTP_1588_CLOCK

# driver variant 2:

config ACME_MAC

config ACME_MAC_PTP
	depends on ACME_MAC
	select PTP_1588_CLOCK

Hm?	

Thanks,
Richard
