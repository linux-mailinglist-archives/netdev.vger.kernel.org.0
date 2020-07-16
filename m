Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96371222E28
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbgGPVtd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgGPVtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 17:49:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE58BC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:49:31 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n26so8337861ejx.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 14:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sCPWn3yNfTqdSd6LjmmcOoLqgnMwrzKjDVqBVhJnkYE=;
        b=tfF/8viFsZXXnnU5v7qe4WlHm8Qeylw2LzOj51Z8KUDNqNC8Ft500niwg70zfzpzkf
         ssLModQUngysPu51I7F4rfpv4BZ/LvJM4eeYyd5OszIU1xEi0klFPD7xBbH2eVSfxfJy
         +rh/UdsM8se7uKYtu1kiNd/53icKS+kmAMi7ZMaJEtnkGCCmeSNZ3aSeLz5YNUqTySkH
         k1kLefR+qmuS/4ygx2TiyGS0ElMBkkpSZPZkaxr7fsMt05nxV4061pPJrxuB8ybp8RiI
         Ars7BDd24Tet1uD8HOjQvTi+Uy+G2SKjFdnovwqWEiHnTRsaqaodQAitZ9qFlXZLwPTZ
         5baQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sCPWn3yNfTqdSd6LjmmcOoLqgnMwrzKjDVqBVhJnkYE=;
        b=onIIREYAIlsX1XxjtK+OG77eD4+KhJ6VDfN8hHqjs/qauuV+ke6MEfznrU1Ge3JVVW
         GlZqSd+XPU4+GhqzEynK8QrOFG6iCnS9SGvfOBG3ZDndylbIb/2I7s7bFiz8KyKamN1I
         F8bk0f7zTf2BQgRAf/OZ8i8yv3Xuve/a5eA91/fSUzI9ROS6ypxWWCz2CxF8jFn4F3pu
         N9BsBXE6/Bt7s1MxLspvcpw/SPp/QQk3Df4OE0DE2WBvSi7UE6u7rTCOv9vrbjS80Kbl
         E3EDSPT3mTRxIcw6lqT5hn/7jaNBJpSHK9ErK/MylcBN3C+8psoyeDJSpUdaVwW+79kn
         4big==
X-Gm-Message-State: AOAM533JpXmqveGIujJGSb9bXgE93j7xj3LopO10pVXa+u0nGRvneq/j
        PUz5gfKRtuFq+zJhJSVhwdGU6MjX
X-Google-Smtp-Source: ABdhPJyJDBkV8ap4ZvzZCmWqQBkZOBXdIbesBH6qpXJf1ErFA2xoisWkLoyfRhLC0ch1lXtJdhdvKg==
X-Received: by 2002:a17:906:fac1:: with SMTP id lu1mr5937925ejb.427.1594936170150;
        Thu, 16 Jul 2020 14:49:30 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id g21sm6363051edu.2.2020.07.16.14.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 14:49:29 -0700 (PDT)
Date:   Fri, 17 Jul 2020 00:49:27 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, yangbo.lu@nxp.com,
        xiaoliang.yang_1@nxp.com, po.liu@nxp.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 1/3] ptp: add ability to configure duty cycle
 for periodic output
Message-ID: <20200716214927.s4uu36twwegarznm@skbuf>
References: <20200716212032.1024188-1-olteanv@gmail.com>
 <20200716212032.1024188-2-olteanv@gmail.com>
 <56860b5e-95ff-ae59-a20d-9873af44de67@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56860b5e-95ff-ae59-a20d-9873af44de67@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 02:36:45PM -0700, Jacob Keller wrote:
> 
> 
> On 7/16/2020 2:20 PM, Vladimir Oltean wrote:
> > There are external event timestampers (PHCs with support for
> > PTP_EXTTS_REQUEST) that timestamp both event edges.
> > 
> > When those edges are very close (such as in the case of a short pulse),
> > there is a chance that the collected timestamp might be of the rising,
> > or of the falling edge, we never know.
> > 
> > There are also PHCs capable of generating periodic output with a
> > configurable duty cycle. This is good news, because we can space the
> > rising and falling edge out enough in time, that the risks to overrun
> > the 1-entry timestamp FIFO of the extts PHC are lower (example: the
> > perout PHC can be configured for a period of 1 second, and an "on" time
> > of 0.5 seconds, resulting in a duty cycle of 50%).
> > 
> > A flag is introduced for signaling that an on time is present in the
> > perout request structure, for preserving compatibility. Logically
> > speaking, the duty cycle cannot exceed 100% and the PTP core checks for
> > this.
> 
> I was thinking whether it made sense to support over 50% since in theory
> you could change start time and the duty cycle to specify the shifted
> wave over? but I guess it doesn't really make much of a difference to
> support all the way up to 100%.
> 

Only if you also support polarity, and we don't support polarity. It's
always high first, then low.

   +------+  +------+  +------+  +------+  +------+  +------+  +------+
   |      |  |      |  |      |  |      |  |      |  |      |  |      |
 --+      +--+      +--+      +--+      +--+      +--+      +--+      +

 +---------+---------+---------+---------+---------+---------+--------->
 period=10                                                          time
 phase=2
 on = 7

There's no other way to obtain this signal which has a duty cycle > 50%
by specifying a duty cycle < 50%.

> > 
> > PHC drivers that don't support this flag emit a periodic output of an
> > unspecified duty cycle, same as before.
> > 
> > The duty cycle is encoded as an "on" time, similar to the "start" and
> > "period" times, and reuses the reserved space while preserving overall
> > binary layout.
> > 
> > Pahole reported before:
> > 
> > struct ptp_perout_request {
> >         struct ptp_clock_time start;                     /*     0    16 */
> >         struct ptp_clock_time period;                    /*    16    16 */
> >         unsigned int               index;                /*    32     4 */
> >         unsigned int               flags;                /*    36     4 */
> >         unsigned int               rsv[4];               /*    40    16 */
> > 
> >         /* size: 56, cachelines: 1, members: 5 */
> >         /* last cacheline: 56 bytes */
> > };
> > 
> > And now:
> > 
> > struct ptp_perout_request {
> >         struct ptp_clock_time start;                     /*     0    16 */
> >         struct ptp_clock_time period;                    /*    16    16 */
> >         unsigned int               index;                /*    32     4 */
> >         unsigned int               flags;                /*    36     4 */
> >         union {
> >                 struct ptp_clock_time on;                /*    40    16 */
> >                 unsigned int       rsv[4];               /*    40    16 */
> >         };                                               /*    40    16 */
> > 
> >         /* size: 56, cachelines: 1, members: 5 */
> >         /* last cacheline: 56 bytes */
> > };
> > 
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  drivers/ptp/ptp_chardev.c      | 33 +++++++++++++++++++++++++++------
> >  include/uapi/linux/ptp_clock.h | 17 ++++++++++++++---
> >  2 files changed, 41 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> > index 375cd6e4aade..e0e6f85966e1 100644
> > --- a/drivers/ptp/ptp_chardev.c
> > +++ b/drivers/ptp/ptp_chardev.c
> > @@ -191,12 +191,33 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
> >  			err = -EFAULT;
> >  			break;
> >  		}
> > -		if (((req.perout.flags & ~PTP_PEROUT_VALID_FLAGS) ||
> > -			req.perout.rsv[0] || req.perout.rsv[1] ||
> > -			req.perout.rsv[2] || req.perout.rsv[3]) &&
> > -			cmd == PTP_PEROUT_REQUEST2) {
> > -			err = -EINVAL;
> > -			break;
> > +		if (cmd == PTP_PEROUT_REQUEST2) {
> > +			struct ptp_perout_request *perout = &req.perout;
> > +
> > +			if (perout->flags & ~PTP_PEROUT_VALID_FLAGS) {
> > +				err = -EINVAL;
> > +				break;
> > +			}
> > +			/*
> > +			 * The "on" field has undefined meaning if
> > +			 * PTP_PEROUT_DUTY_CYCLE isn't set, we must still treat
> > +			 * it as reserved, which must be set to zero.
> > +			 */
> > +			if (!(perout->flags & PTP_PEROUT_DUTY_CYCLE) &&
> > +			    (perout->rsv[0] || perout->rsv[1] ||
> > +			     perout->rsv[2] || perout->rsv[3])) {
> > +				err = -EINVAL;
> > +				break;
> > +			}
> > +			if (perout->flags & PTP_PEROUT_DUTY_CYCLE) {
> > +				/* The duty cycle must be subunitary. */
> 
> I'm sure this means "smaller than the period" but I can't help thinking
> just spelling that out would be clearer.
> 

Duty cycle is by definition a fraction. In my example above, on/period
is 70%, or 0.7. So it is not incorrect to say that the duty cycle is
subunitary. The alternative phrasing would be that the on time must be
lower than the period, and I've used that already in the header file. I
was just trying to avoid repetition.

> > +				if (perout->on.sec > perout->period.sec ||
> > +				    (perout->on.sec == perout->period.sec &&
> > +				     perout->on.nsec > perout->period.nsec)) {
> > +					err = -ERANGE;
> > +					break;
> > +				}
> > +			}
> >  		} else if (cmd == PTP_PEROUT_REQUEST) {
> >  			req.perout.flags &= PTP_PEROUT_V1_VALID_FLAGS;
> >  			req.perout.rsv[0] = 0;
> > diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
> > index ff070aa64278..1d2841155f7d 100644
> > --- a/include/uapi/linux/ptp_clock.h
> > +++ b/include/uapi/linux/ptp_clock.h
> > @@ -53,12 +53,14 @@
> >  /*
> >   * Bits of the ptp_perout_request.flags field:
> >   */
> > -#define PTP_PEROUT_ONE_SHOT (1<<0)
> > +#define PTP_PEROUT_ONE_SHOT		(1<<0)
> > +#define PTP_PEROUT_DUTY_CYCLE		(1<<1)
> >  
> >  /*
> >   * flag fields valid for the new PTP_PEROUT_REQUEST2 ioctl.
> >   */
> > -#define PTP_PEROUT_VALID_FLAGS	(PTP_PEROUT_ONE_SHOT)
> > +#define PTP_PEROUT_VALID_FLAGS		(PTP_PEROUT_ONE_SHOT | \
> > +					 PTP_PEROUT_DUTY_CYCLE)
> >  
> >  /*
> >   * No flags are valid for the original PTP_PEROUT_REQUEST ioctl
> > @@ -105,7 +107,16 @@ struct ptp_perout_request {
> >  	struct ptp_clock_time period; /* Desired period, zero means disable. */
> >  	unsigned int index;           /* Which channel to configure. */
> >  	unsigned int flags;
> > -	unsigned int rsv[4];          /* Reserved for future use. */
> > +	union {
> > +		/*
> > +		 * The "on" time of the signal.
> > +		 * Must be lower than the period.
> > +		 * Valid only if (flags & PTP_PEROUT_DUTY_CYCLE) is set.
> > +		 */
> > +		struct ptp_clock_time on;
> > +		/* Reserved for future use. */
> > +		unsigned int rsv[4];
> > +	};
> 
> Hmmm. So the idea is that if PTP_PEROUT_DUTY_CYCLE is not set, then we
> keep this as reserved and then if it *is* set we allow it to be the "on"
> time?
> 
> Is it possible for us to still use the reserved bits for another
> purpose? Or should we just remove it entirely and leave only the "on"
> timestamp. Any future extension would by definition *have* to be
> exclusive with PTP_PEROUT_DUTY_CYCLE if it wants to use these reserved
> fields anyways...
> 

You're right about the mutual exclusion, but I can't predict the future
and I don't know if the reserved field is going to be practically useful
or not.

There is one subtlety though, and that is that we have been exposing to
user space, previously, a structure with a field named "rsv" in it. So,
application writers may have been accessing that "rsv" field, to memset
it to zero, for instance. It wouldn't be nice if it disappeared, it
would break their code.

> >  };
> >  
> >  #define PTP_MAX_SAMPLES 25 /* Maximum allowed offset measurement samples. */
> > 

Thanks,
-Vladimir
