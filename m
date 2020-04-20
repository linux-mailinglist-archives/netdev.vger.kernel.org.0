Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 367591B1834
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbgDTVSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgDTVSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 17:18:23 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CAFEC061A0C;
        Mon, 20 Apr 2020 14:18:22 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu11so420550pjb.1;
        Mon, 20 Apr 2020 14:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rD4w4N0eJ/tfjt2nOo1kPiXoCAMHsRlgxj04yDslYRs=;
        b=kzHaCZzX8drpVdZSnnPVhfnPKX39XGAMIiA0q15HENDe0cq/Y9D8gXW3yEmog2ubYT
         KhdaizTMFXTJXEjISbw4CQA45qGFjVcMtHi6FWFBMZTcNxFFWSoIOKaBf6BERFRzYj9R
         SuJjslTeOC0cQkesuXN5Fj4+KmOKou2DLb3pyd4TmvbD1lm4PiR4lNMovZgmpVTCcFoH
         5oTqyXiFK8XO1GiruFDUJuJGjEuhcNIBnSGautxifFMz1n+bHVSrxN0OquXRjP3M1HFe
         s7z0OST29eNf6RexT+KDuQ9pJYCPafX64EcICpudMBCPQXFN/ybD/NdRXtgy1Yo5etwy
         8PRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rD4w4N0eJ/tfjt2nOo1kPiXoCAMHsRlgxj04yDslYRs=;
        b=dwwg77qO28RKUg4xCRXi99KzjcA/3I1y2DgGfUSL63spM2JwDR8XhpE21ykkmfyzWB
         QivQYRtzWTbgyhthHDiTel6fWN6yySFMyxiwt8d7adSDfBHdOF+GC+OAc5sr98tDUMJG
         6ZlW1StT5cOxKBpb8KE/4nEooqJbFdMx/SQ/lM3vXJsaum/7Qs37hORk90CDVH6HAQn8
         U4WympOuNtOix4jB7yNSF7WZ7H585day9Wtvg/K/Rplh1A1shcFiPVBn/HKaJAgp+Hrh
         z2Edh7a/WDpNnuabBm5byVRdAExk39zOIH2Lcp+DhYkDNlkPX1N6Vn7bGPNOkQHbAzjF
         0IUg==
X-Gm-Message-State: AGi0Puax5O6e32Lq3vqsfWWvixurOXGnupBHG2SKH1yDrvSxM/tib507
        7W8KTEdA6vHuBXxa8ypcS1E=
X-Google-Smtp-Source: APiQypJigBAyfOOqMaLzbmABgjo6O1iASj/v9DXutuMgcBbVnCf+Skaxu8njJykcYQeqh4Z6tdZPdQ==
X-Received: by 2002:a17:90a:7349:: with SMTP id j9mr1592194pjs.196.1587417502082;
        Mon, 20 Apr 2020 14:18:22 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id c144sm398337pfb.172.2020.04.20.14.18.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 14:18:21 -0700 (PDT)
Date:   Mon, 20 Apr 2020 14:18:19 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Clay McClure <clay@daemons.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: cpts: Condition WARN_ON on PTP_1588_CLOCK
Message-ID: <20200420211819.GA16930@localhost>
References: <20200416085627.1882-1-clay@daemons.net>
 <6fef3a00-6c18-b775-d1b4-dfd692261bd3@ti.com>
 <20200420093610.GA28162@arctic-shiba-lx>
 <CAK8P3a36ZxNJxUS4UzrwJiMx8UrgYPkcv4X6yYw7EC4jRBbbGQ@mail.gmail.com>
 <20200420170051.GB11862@localhost>
 <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a11CqpDJzjy5QfV-ebHgRxUu8SRVTJPPmsus1O1+OL72Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 08:57:05PM +0200, Arnd Bergmann wrote:
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 172) #if IS_REACHABLE(CONFIG_PTP_1588_CLOCK)
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 173)
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 174) /**
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 175)  * ptp_clock_register() - register a PTP hardware clock driver
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 176)  *
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 177)  * @info:   Structure describing the new clock.
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 178)  * @parent: Pointer to the parent device of the new clock.
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 179)  *
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 180)  * Returns a valid pointer on success or PTR_ERR on failure.  If PHC
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 181)  * support is missing at the configuration level, this function
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 182)  * returns NULL, and drivers are expected to gracefully handle that
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 183)  * case separately.
> > d1cbfd771ce82 (Nicolas Pitre       2016-11-11 184)  */
> 
> The key here is "gracefully". The second patch from Clay just turns NULL into
>  -EOPNOTSUPP and treats the compile-time condition into a runtime error.

You are talking about the cpts driver, no?

I'm worried about ptp_clock_register(), because it does return NULL if
IS_REACHABLE(CONFIG_PTP_1588_CLOCK), and this is the "correct"
behavior ever since November 2016.

If somebody wants to change that stub to return EOPNOTSUPP, then fine,
but please have them audit the callers and submit a patch series.

Thanks,
Richard
