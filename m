Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF684A66F9
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiBAVXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:23:38 -0500
Received: from mga14.intel.com ([192.55.52.115]:4207 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229513AbiBAVXh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 16:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643750617; x=1675286617;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=IW7c6JlxfTUwLpLHT1vGdzYi4KXkjnbl+DcCDOPZDUA=;
  b=QQULpo/YtYzNbCCakcqRagjs1YIr2F9OmAnfv8klfNAWy8jDc7coEznY
   Jsxp8y9/keCiOGo20ioVyz5QyShoHN5xVeeNTBon2HHApTXaFBP9FTDzt
   Gr8vZIj3CvHDySqgVA6Q2ZTHifkS8pAPWVUyQtWTCSIiTj7Ivji3HmjNe
   G93sUHpTA8+TvWAKRvylzWRwWc1PvCxPhswk4TIDFznr0AL8i8zbkJ5gF
   8GJNPsAgkWnkLiP9ot3zSwD1GVVhOjmVh7VbvaRfAXm2KzA8d+kafuuZo
   Q8+l/qmVZ08MKJwTFdnzL289H1v6ckzTd8woR8CwuF2D8UJCRSQaUdE2f
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="248017253"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="248017253"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 13:23:37 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="771246576"
Received: from mdroper-desk1.fm.intel.com (HELO mdroper-desk1.amr.corp.intel.com) ([10.1.27.134])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 13:23:37 -0800
Date:   Tue, 1 Feb 2022 13:23:36 -0800
From:   Matt Roper <matthew.d.roper@intel.com>
To:     Lucas De Marchi <lucas.demarchi@intel.com>
Cc:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
        linux-security-module@vger.kernel.org,
        nouveau@lists.freedesktop.org, netdev@vger.kernel.org,
        Emma Anholt <emma@anholt.net>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Leo Li <sunpeng.li@amd.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [Intel-gfx] [PATCH v2 04/11] drm/i915: Use str_enable_disable()
Message-ID: <Yfmk2F0WxOlroZ2V@mdroper-desk1.amr.corp.intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-5-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126093951.1470898-5-lucas.demarchi@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 01:39:44AM -0800, Lucas De Marchi wrote:
> Remove the local enabledisable() implementation and adopt the
> str_enable_disable() from linux/string_helpers.h.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Acked-by: Jani Nikula <jani.nikula@intel.com>

There's an open-coded version of this in display/intel_pps.c,
intel_pps_backlight_power().  Up to you whether you squash it into this
patch or convert it as a follow-up.  Either way.

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>


> ---
>  drivers/gpu/drm/i915/display/intel_ddi.c           | 4 +++-
>  drivers/gpu/drm/i915/display/intel_display_power.c | 4 +++-
>  drivers/gpu/drm/i915/display/intel_dp.c            | 8 ++++----
>  drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c          | 3 ++-
>  drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c          | 4 +++-
>  drivers/gpu/drm/i915/i915_utils.h                  | 5 -----
>  6 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_ddi.c b/drivers/gpu/drm/i915/display/intel_ddi.c
> index 2f20abc5122d..4b35a8597632 100644
> --- a/drivers/gpu/drm/i915/display/intel_ddi.c
> +++ b/drivers/gpu/drm/i915/display/intel_ddi.c
> @@ -25,6 +25,8 @@
>   *
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include <drm/drm_privacy_screen_consumer.h>
>  #include <drm/drm_scdc_helper.h>
>  
> @@ -2152,7 +2154,7 @@ static void intel_dp_sink_set_msa_timing_par_ignore_state(struct intel_dp *intel
>  			       enable ? DP_MSA_TIMING_PAR_IGNORE_EN : 0) <= 0)
>  		drm_dbg_kms(&i915->drm,
>  			    "Failed to %s MSA_TIMING_PAR_IGNORE in the sink\n",
> -			    enabledisable(enable));
> +			    str_enable_disable(enable));
>  }
>  
>  static void intel_dp_sink_set_fec_ready(struct intel_dp *intel_dp,
> diff --git a/drivers/gpu/drm/i915/display/intel_display_power.c b/drivers/gpu/drm/i915/display/intel_display_power.c
> index 369317805d24..1f77cb9edddf 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_power.c
> +++ b/drivers/gpu/drm/i915/display/intel_display_power.c
> @@ -3,6 +3,8 @@
>   * Copyright © 2019 Intel Corporation
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include "i915_drv.h"
>  #include "i915_irq.h"
>  #include "intel_cdclk.h"
> @@ -5302,7 +5304,7 @@ static void gen9_dbuf_slice_set(struct drm_i915_private *dev_priv,
>  	state = intel_de_read(dev_priv, reg) & DBUF_POWER_STATE;
>  	drm_WARN(&dev_priv->drm, enable != state,
>  		 "DBuf slice %d power %s timeout!\n",
> -		 slice, enabledisable(enable));
> +		 slice, str_enable_disable(enable));
>  }
>  
>  void gen9_dbuf_slices_update(struct drm_i915_private *dev_priv,
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 62c1535d696d..933fc316ea53 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -1987,7 +1987,7 @@ void intel_dp_sink_set_decompression_state(struct intel_dp *intel_dp,
>  	if (ret < 0)
>  		drm_dbg_kms(&i915->drm,
>  			    "Failed to %s sink decompression state\n",
> -			    enabledisable(enable));
> +			    str_enable_disable(enable));
>  }
>  
>  static void
> @@ -2463,7 +2463,7 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
>  	if (drm_dp_dpcd_writeb(&intel_dp->aux,
>  			       DP_PROTOCOL_CONVERTER_CONTROL_0, tmp) != 1)
>  		drm_dbg_kms(&i915->drm, "Failed to %s protocol converter HDMI mode\n",
> -			    enabledisable(intel_dp->has_hdmi_sink));
> +			    str_enable_disable(intel_dp->has_hdmi_sink));
>  
>  	tmp = crtc_state->output_format == INTEL_OUTPUT_FORMAT_YCBCR444 &&
>  		intel_dp->dfp.ycbcr_444_to_420 ? DP_CONVERSION_TO_YCBCR420_ENABLE : 0;
> @@ -2472,7 +2472,7 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
>  			       DP_PROTOCOL_CONVERTER_CONTROL_1, tmp) != 1)
>  		drm_dbg_kms(&i915->drm,
>  			    "Failed to %s protocol converter YCbCr 4:2:0 conversion mode\n",
> -			    enabledisable(intel_dp->dfp.ycbcr_444_to_420));
> +			    str_enable_disable(intel_dp->dfp.ycbcr_444_to_420));
>  
>  	tmp = 0;
>  	if (intel_dp->dfp.rgb_to_ycbcr) {
> @@ -2510,7 +2510,7 @@ void intel_dp_configure_protocol_converter(struct intel_dp *intel_dp,
>  	if (drm_dp_pcon_convert_rgb_to_ycbcr(&intel_dp->aux, tmp) < 0)
>  		drm_dbg_kms(&i915->drm,
>  			   "Failed to %s protocol converter RGB->YCbCr conversion mode\n",
> -			   enabledisable(tmp));
> +			   str_enable_disable(tmp));
>  }
>  
>  
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> index de89d40abd38..31c3c3bceb95 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_ct.c
> @@ -6,6 +6,7 @@
>  #include <linux/circ_buf.h>
>  #include <linux/ktime.h>
>  #include <linux/time64.h>
> +#include <linux/string_helpers.h>
>  #include <linux/timekeeping.h>
>  
>  #include "i915_drv.h"
> @@ -170,7 +171,7 @@ static int ct_control_enable(struct intel_guc_ct *ct, bool enable)
>  				     GUC_CTB_CONTROL_ENABLE : GUC_CTB_CONTROL_DISABLE);
>  	if (unlikely(err))
>  		CT_PROBE_ERROR(ct, "Failed to control/%s CTB (%pe)\n",
> -			       enabledisable(enable), ERR_PTR(err));
> +			       str_enable_disable(enable), ERR_PTR(err));
>  
>  	return err;
>  }
> diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
> index fc805d466d99..f8fc90ea71e7 100644
> --- a/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
> +++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_rc.c
> @@ -3,6 +3,8 @@
>   * Copyright © 2021 Intel Corporation
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include "intel_guc_rc.h"
>  #include "gt/intel_gt.h"
>  #include "i915_drv.h"
> @@ -59,7 +61,7 @@ static int __guc_rc_control(struct intel_guc *guc, bool enable)
>  	ret = guc_action_control_gucrc(guc, enable);
>  	if (ret) {
>  		drm_err(drm, "Failed to %s GuC RC (%pe)\n",
> -			enabledisable(enable), ERR_PTR(ret));
> +			str_enable_disable(enable), ERR_PTR(ret));
>  		return ret;
>  	}
>  
> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
> index c62b64012369..06aac2be49ee 100644
> --- a/drivers/gpu/drm/i915/i915_utils.h
> +++ b/drivers/gpu/drm/i915/i915_utils.h
> @@ -404,11 +404,6 @@ static inline const char *onoff(bool v)
>  	return v ? "on" : "off";
>  }
>  
> -static inline const char *enabledisable(bool v)
> -{
> -	return v ? "enable" : "disable";
> -}
> -
>  static inline const char *enableddisabled(bool v)
>  {
>  	return v ? "enabled" : "disabled";
> -- 
> 2.34.1
> 

-- 
Matt Roper
Graphics Software Engineer
VTT-OSGC Platform Enablement
Intel Corporation
(916) 356-2795
