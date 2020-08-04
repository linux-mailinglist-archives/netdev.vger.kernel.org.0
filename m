Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55C8223C23E
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 01:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgHDXk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 19:40:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgHDXk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 19:40:56 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7FAC06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 16:40:56 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d6so30493461ejr.5
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 16:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2qoTryn1TXqmiMR6itK4D2q7lhLO8x9+SankyHQSTUs=;
        b=g8reU2gEPqTXQdBBJeiT4JzGXL9tkzwA7pK8AP6PhfitP4z6zzAZN0lR3aqQC2fxAx
         0dd/wWdqRABPMptrQi7uScFfUDoOzgMif8B8tYk0udPRge9qH1lzYMFWU3UA1pO99PDd
         Ixavho53hJCkkj97GW8oCTQc07+EChwIW8vggC2Z58MgtIi2AHr4hx1tq45sbT33rXgd
         LEneku1185z1sFOTqrlL7t95zDZNXvKOvki7uVcoOFb+QsGgaMvnULYcrFLsne2IQN7k
         QjZfPEcv/IfUZoigH67LrjTY4oXotAlw7U910VQ0Ws7YregM9nI6koiP7gVSon9sYpJC
         4qeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2qoTryn1TXqmiMR6itK4D2q7lhLO8x9+SankyHQSTUs=;
        b=Kcr74BkFEzU+5keIkXQbdEQ95OKg+jNNqymKI4A1ratXNEfhuXuro5wIDVRHRKpUEh
         kVxZ7+1fc3yfLzHlCHxdtWK7LY6RTlKLgBMnolUw6UanrwAA+FOdDRfD5lvq5gLcd411
         nxwi9uQ4bsDlm78EmFNUEavzuXbll566oTe3447RcoYEabBIxfe2LDEgXqgKzNjGYTpF
         41EYNeSbNdGtBHYIRd6eyo+GoEUJ2d2hJG3jhJnofQYswXT/wFZr8iG7vX4ocp5OYAnX
         FdMckNVJmNBjtA+4rvzqzR3ntrhh9b4Yydy0w0uvVeSmRKkpK9vp0AoygdpkCvXM1MzZ
         4JVA==
X-Gm-Message-State: AOAM533M6PiM++POC0mx2puscVCiPolt7gD304dvlZ1mxCeEj+fxNqt4
        q7Mml3wKGcUgj8RJEftY6W8=
X-Google-Smtp-Source: ABdhPJyKcsZNfi0hzn+fgXT8KVf27rwWvmr6kOtTUp6TyG1p4FIBVmxpcgT/yhpazHznAUHA9DFzrA==
X-Received: by 2002:a17:906:b6c3:: with SMTP id ec3mr524840ejb.101.1596584454836;
        Tue, 04 Aug 2020 16:40:54 -0700 (PDT)
Received: from skbuf ([188.26.57.97])
        by smtp.gmail.com with ESMTPSA id u13sm268317ejc.72.2020.08.04.16.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 16:40:54 -0700 (PDT)
Date:   Wed, 5 Aug 2020 02:40:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next] ptp: only allow phase values lower than 1 period
Message-ID: <20200804234052.z54jncpjissagex5@skbuf>
References: <20200803194921.603151-1-olteanv@gmail.com>
 <20200804232335.GA27679@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200804232335.GA27679@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 04:23:35PM -0700, Richard Cochran wrote:
> On Mon, Aug 03, 2020 at 10:49:21PM +0300, Vladimir Oltean wrote:
> > @@ -218,6 +218,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >  					break;
> >  				}
> >  			}
> > +			if (perout->flags & PTP_PEROUT_PHASE) {
> > +				/*
> > +				 * The phase should be specified modulo the
> > +				 * period, therefore anything larger than 1
> > +				 * period is invalid.
> > +				 */
> > +				if (perout->phase.sec > perout->period.sec ||
> > +				    (perout->phase.sec == perout->period.sec &&
> > +				     perout->phase.nsec > perout->period.nsec)) {
> > +					err = -ERANGE;
> > +					break;
> > +				}
> 
> So if perout->period={1,0} and perout->phase={1,0} then the phase has
> wrapped 360 degrees back to zero.
> 
> Shouldn't this code catch that case as well?
> 
> So why not test for (perout->phase.nsec >= perout->period.nsec) instead?
> 
> Thanks,
> Richard

Oof, I guess this is what one would call 'brain fart'. In my mind,
checking for equality between period and phase required an extra 'if',
which I was reluctant to add (or to even think about, it seems). I
converted the nsec check to >= and it works as it should (I checked with
a modified ts2phc).

ts2phc[326.764]: config item /dev/ptp1.ts2phc.perout_phase is 1000000000
ts2phc[326.764]: config item /dev/ptp1.ts2phc.pulsewidth is 500000000
ts2phc[326.764]: PTP_PEROUT_REQUEST2 failed: Numerical result out of range

I'm sending a v2 with your change very soon.

Thanks.
-Vladimir
