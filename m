Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E805930A83A
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 14:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbhBANDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 08:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhBAND0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 08:03:26 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5FDC06174A
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 05:02:46 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id i8so7768040ejc.7
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 05:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7qAbV6oUrrXRW0nHMvAV2zgiUZjRhKKn8XeLL14fYIA=;
        b=tN9UyHd8GT6u+fHOCHA8tcqUDd/fHwo/xfdL/sftzEF6xUPMtTMNDpkdVOrypwfOLi
         DyrW1natkHJTpkKe6UzmLUB9zz0HvED7DHkQ1RRpvyY+CMRbJgjmGr0nB9bZ7IVCYQyH
         yjd+jycyFIKjZ2cyOhfqEzR/5dqnk/JHHUKAGQMiVlVBGTTl4beRbG7DHMSPJO/JVIJ6
         VgMGfY56A4oQ0P1s/Lq/bvISFQ4hss71DkDSgu5QEYa5OHrxl/pjNnk8SY9hHY1lJeWe
         jtazEIN9ucyZtasRUl9bSQgP7OczJiuq47Oj+Hu5Dj3ZSOrH0qUaR3D3IlkIgI/1ShLg
         553g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7qAbV6oUrrXRW0nHMvAV2zgiUZjRhKKn8XeLL14fYIA=;
        b=MVYxUxOJwZZNT6EId0jG4Gy5R/bAXrWSAfGaJ4f9w0VDulQ+Vvym5KoiXSMNWZiuOE
         6BFr28F/PqDreRpJnnukkKD7L6Tp1HWcA+aOSNpebNa5AH6IIps+ZZcSJF0rprP5TxHp
         NzfE/OOt4vbTsqu8AhduURUVX22hGG5qOuiEw9twM8mtKp7C74sf99qfPfmmbisfSh1S
         sESYSaWoM/yYJf7qDAzH5S16XYktnFKLh/9jgo2yjmrPn4BeWY+MNekR4YbSnVTdTi30
         b1XyilDyr0kQrTSH+38/TrkcIRFiDmQKw+3zXGtHJIWnDR6y5Qw0tXbo57AbLKNoJU0E
         2Lug==
X-Gm-Message-State: AOAM532OJeXlbEcncYgk8wbT1H5W2pC+I+h2oB6zGXnY6odcbfpJX+1Z
        wHrOn9W3Qp6SEibaGKaV1d9/PdCxwam2gfji
X-Google-Smtp-Source: ABdhPJzS8SWM7K6mkqQyqZBMh5QtjMQSKVaiiHwmKdc0VXwu2nW3XkR2kVO1nwTFpkV+FajtchQYnw==
X-Received: by 2002:a17:906:4050:: with SMTP id y16mr17354870ejj.43.1612184564774;
        Mon, 01 Feb 2021 05:02:44 -0800 (PST)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id l17sm7988831ejc.60.2021.02.01.05.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 05:02:44 -0800 (PST)
Date:   Mon, 1 Feb 2021 14:02:43 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        oss-drivers@netronome.com, Baowen Zheng <baowen.zheng@corigine.com>
Subject: Re: [PATCH net-next v2] net/sched: act_police: add support for
 packet-per-second policing
Message-ID: <20210201130242.GC25935@netronome.com>
References: <20210129102856.6225-1-simon.horman@netronome.com>
 <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVnd9s6rpNOSNLTBHzLH7BtKvdZmWMhZdFps8udfCyikQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong,

On Fri, Jan 29, 2021 at 03:04:51PM -0800, Cong Wang wrote:
> On Fri, Jan 29, 2021 at 2:29 AM Simon Horman <simon.horman@netronome.com> wrote:
> > +/**
> > + * psched_ratecfg_precompute__() - Pre-compute values for reciprocal division
> > + * @rate:   Rate to compute reciprocal division values of
> > + * @mult:   Multiplier for reciprocal division
> > + * @shift:  Shift for reciprocal division
> > + *
> > + * The multiplier and shift for reciprocal division by rate are stored
> > + * in mult and shift.
> > + *
> > + * The deal here is to replace a divide by a reciprocal one
> > + * in fast path (a reciprocal divide is a multiply and a shift)
> > + *
> > + * Normal formula would be :
> > + *  time_in_ns = (NSEC_PER_SEC * len) / rate_bps
> > + *
> > + * We compute mult/shift to use instead :
> > + *  time_in_ns = (len * mult) >> shift;
> > + *
> > + * We try to get the highest possible mult value for accuracy,
> > + * but have to make sure no overflows will ever happen.
> > + *
> > + * reciprocal_value() is not used here it doesn't handle 64-bit values.
> > + */
> > +static void psched_ratecfg_precompute__(u64 rate, u32 *mult, u8 *shift)
> 
> Am I the only one who thinks "foo__()" is an odd name? We usually use
> "__foo()" for helper or unlocked version of "foo()".

Sorry, I will fix that.

> And, you probably want to move the function doc to its exported variant
> instead, right?

Would something like this incremental change your concerns?

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 44991ea726fc..63cb69df4240 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1325,14 +1325,7 @@ void dev_shutdown(struct net_device *dev)
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
 
-/**
- * psched_ratecfg_precompute__() - Pre-compute values for reciprocal division
- * @rate:   Rate to compute reciprocal division values of
- * @mult:   Multiplier for reciprocal division
- * @shift:  Shift for reciprocal division
- *
- * The multiplier and shift for reciprocal division by rate are stored
- * in mult and shift.
+/* Pre-compute values for reciprocol division for a rate limit.
  *
  * The deal here is to replace a divide by a reciprocal one
  * in fast path (a reciprocal divide is a multiply and a shift)
@@ -1348,7 +1341,7 @@ void dev_shutdown(struct net_device *dev)
  *
  * reciprocal_value() is not used here it doesn't handle 64-bit values.
  */
-static void psched_ratecfg_precompute__(u64 rate, u32 *mult, u8 *shift)
+static void __psched_ratecfg_precompute(u64 rate, u32 *mult, u8 *shift)
 {
 	u64 factor = NSEC_PER_SEC;
 
@@ -1367,6 +1360,15 @@ static void psched_ratecfg_precompute__(u64 rate, u32 *mult, u8 *shift)
 	}
 }
 
+/**
+ * psched_ratecfg_precompute() - Pre-compute values for byte rate limiting
+ * @r:      Byte-per-second rate struct to store configuration in
+ * @conf:   Rate specification
+ * @rate64: Rate in bytes-per-second
+ *
+ * Pre-compute configuration, including values for reciprocal division,
+ * for a byte-per-second rate limit.
+ */
 void psched_ratecfg_precompute(struct psched_ratecfg *r,
 			       const struct tc_ratespec *conf,
 			       u64 rate64)
@@ -1375,14 +1377,22 @@ void psched_ratecfg_precompute(struct psched_ratecfg *r,
 	r->overhead = conf->overhead;
 	r->rate_bytes_ps = max_t(u64, conf->rate, rate64);
 	r->linklayer = (conf->linklayer & TC_LINKLAYER_MASK);
-	psched_ratecfg_precompute__(r->rate_bytes_ps, &r->mult, &r->shift);
+	__psched_ratecfg_precompute(r->rate_bytes_ps, &r->mult, &r->shift);
 }
 EXPORT_SYMBOL(psched_ratecfg_precompute);
 
+/**
+ * psched_ppscfg_precompute() - Pre-compute values for packet rate limiting
+ * @r:         Packet-per-second rate struct to store configuration in
+ * @pktrate64: Rate in packets-per-second
+ *
+ * Pre-compute configuration, including values for reciprocal division,
+ * for a packet-per-second rate limit.
+ */
 void psched_ppscfg_precompute(struct psched_pktrate *r, u64 pktrate64)
 {
 	r->rate_pkts_ps = pktrate64;
-	psched_ratecfg_precompute__(r->rate_pkts_ps, &r->mult, &r->shift);
+	__psched_ratecfg_precompute(r->rate_pkts_ps, &r->mult, &r->shift);
 }
 EXPORT_SYMBOL(psched_ppscfg_precompute);
 
