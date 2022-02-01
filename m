Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4960A4A66DC
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiBAVPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:15:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:22109 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbiBAVPj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Feb 2022 16:15:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643750139; x=1675286139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=V6UNNGT36Y8N/uQHYkgX9304xNVEGsA++QCmcgUkFP4=;
  b=Mfwu2kqjNvZ0EkMZ0FnkK497ftKWenFzm/0s3oC9AZs/DLG/v4JvL6NW
   Fqee5wr5LSRvc+Ee/UxY/S1kw/dOuqK/xiGeUQn/afiQXuL0H6aN5G4G+
   vXgCXJZt7YVDdUvYV3wqgYbSE/U1FiDo9zTJ1QC1ZA9XNe4ffjcl6MJiK
   OFLVb3HCGjufO+ephBJnDZQ6FX0xIlE2WkHHfwPkWsaNXgCgSuu9viNF7
   Pf7z9LW2hnIA7T8bt6MwDIqmGczEW4JfLJkOMqprU4CTEyuFutwoT7LSy
   bqFcBgeaQKmEK/wpjQQ23WJY7nMrKjh0qh/qJFF9O9vfFVHay0RMv/nSb
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10245"; a="245390790"
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="245390790"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 13:15:38 -0800
X-IronPort-AV: E=Sophos;i="5.88,334,1635231600"; 
   d="scan'208";a="565734271"
Received: from mdroper-desk1.fm.intel.com (HELO mdroper-desk1.amr.corp.intel.com) ([10.1.27.134])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2022 13:15:37 -0800
Date:   Tue, 1 Feb 2022 13:15:36 -0800
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
Subject: Re: [Intel-gfx] [PATCH v2 06/11] drm/i915: Use str_on_off()
Message-ID: <Yfmi+KzZwKbG50tB@mdroper-desk1.amr.corp.intel.com>
References: <20220126093951.1470898-1-lucas.demarchi@intel.com>
 <20220126093951.1470898-7-lucas.demarchi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220126093951.1470898-7-lucas.demarchi@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 01:39:46AM -0800, Lucas De Marchi wrote:
> Remove the local onoff() implementation and adopt the
> str_on_off() from linux/string_helpers.h.
> 
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
> Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Acked-by: Jani Nikula <jani.nikula@intel.com>

Reviewed-by: Matt Roper <matthew.d.roper@intel.com>

> ---
>  drivers/gpu/drm/i915/display/g4x_dp.c              | 6 ++++--
>  drivers/gpu/drm/i915/display/intel_display.c       | 7 ++++---
>  drivers/gpu/drm/i915/display/intel_display_trace.h | 3 ++-
>  drivers/gpu/drm/i915/display/intel_dpll.c          | 3 ++-
>  drivers/gpu/drm/i915/display/intel_dpll_mgr.c      | 7 +++++--
>  drivers/gpu/drm/i915/display/intel_fdi.c           | 8 +++++---
>  drivers/gpu/drm/i915/display/vlv_dsi_pll.c         | 3 ++-
>  drivers/gpu/drm/i915/gt/intel_rc6.c                | 5 +++--
>  drivers/gpu/drm/i915/i915_utils.h                  | 5 -----
>  drivers/gpu/drm/i915/vlv_suspend.c                 | 3 ++-
>  10 files changed, 29 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/g4x_dp.c b/drivers/gpu/drm/i915/display/g4x_dp.c
> index f37677df6ebf..3e729bff1232 100644
> --- a/drivers/gpu/drm/i915/display/g4x_dp.c
> +++ b/drivers/gpu/drm/i915/display/g4x_dp.c
> @@ -5,6 +5,8 @@
>   * DisplayPort support for G4x,ILK,SNB,IVB,VLV,CHV (HSW+ handled by the DDI code).
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include "g4x_dp.h"
>  #include "intel_audio.h"
>  #include "intel_backlight.h"
> @@ -191,7 +193,7 @@ static void assert_dp_port(struct intel_dp *intel_dp, bool state)
>  	I915_STATE_WARN(cur_state != state,
>  			"[ENCODER:%d:%s] state assertion failure (expected %s, current %s)\n",
>  			dig_port->base.base.base.id, dig_port->base.base.name,
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  #define assert_dp_port_disabled(d) assert_dp_port((d), false)
>  
> @@ -201,7 +203,7 @@ static void assert_edp_pll(struct drm_i915_private *dev_priv, bool state)
>  
>  	I915_STATE_WARN(cur_state != state,
>  			"eDP PLL state assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  #define assert_edp_pll_enabled(d) assert_edp_pll((d), true)
>  #define assert_edp_pll_disabled(d) assert_edp_pll((d), false)
> diff --git a/drivers/gpu/drm/i915/display/intel_display.c b/drivers/gpu/drm/i915/display/intel_display.c
> index 8920bdb53b7b..49f994f36fce 100644
> --- a/drivers/gpu/drm/i915/display/intel_display.c
> +++ b/drivers/gpu/drm/i915/display/intel_display.c
> @@ -377,7 +377,7 @@ static void wait_for_pipe_scanline_moving(struct intel_crtc *crtc, bool state)
>  	if (wait_for(pipe_scanline_is_moving(dev_priv, pipe) == state, 100))
>  		drm_err(&dev_priv->drm,
>  			"pipe %c scanline %s wait timed out\n",
> -			pipe_name(pipe), onoff(state));
> +			pipe_name(pipe), str_on_off(state));
>  }
>  
>  static void intel_wait_for_pipe_scanline_stopped(struct intel_crtc *crtc)
> @@ -435,7 +435,7 @@ void assert_transcoder(struct drm_i915_private *dev_priv,
>  	I915_STATE_WARN(cur_state != state,
>  			"transcoder %s assertion failure (expected %s, current %s)\n",
>  			transcoder_name(cpu_transcoder),
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  static void assert_plane(struct intel_plane *plane, bool state)
> @@ -447,7 +447,8 @@ static void assert_plane(struct intel_plane *plane, bool state)
>  
>  	I915_STATE_WARN(cur_state != state,
>  			"%s assertion failure (expected %s, current %s)\n",
> -			plane->base.name, onoff(state), onoff(cur_state));
> +			plane->base.name, str_on_off(state),
> +			str_on_off(cur_state));
>  }
>  
>  #define assert_plane_enabled(p) assert_plane(p, true)
> diff --git a/drivers/gpu/drm/i915/display/intel_display_trace.h b/drivers/gpu/drm/i915/display/intel_display_trace.h
> index dcdd242fffd9..2dd5a4b7f5d8 100644
> --- a/drivers/gpu/drm/i915/display/intel_display_trace.h
> +++ b/drivers/gpu/drm/i915/display/intel_display_trace.h
> @@ -9,6 +9,7 @@
>  #if !defined(__INTEL_DISPLAY_TRACE_H__) || defined(TRACE_HEADER_MULTI_READ)
>  #define __INTEL_DISPLAY_TRACE_H__
>  
> +#include <linux/string_helpers.h>
>  #include <linux/types.h>
>  #include <linux/tracepoint.h>
>  
> @@ -161,7 +162,7 @@ TRACE_EVENT(intel_memory_cxsr,
>  			   ),
>  
>  	    TP_printk("%s->%s, pipe A: frame=%u, scanline=%u, pipe B: frame=%u, scanline=%u, pipe C: frame=%u, scanline=%u",
> -		      onoff(__entry->old), onoff(__entry->new),
> +		      str_on_off(__entry->old), str_on_off(__entry->new),
>  		      __entry->frame[PIPE_A], __entry->scanline[PIPE_A],
>  		      __entry->frame[PIPE_B], __entry->scanline[PIPE_B],
>  		      __entry->frame[PIPE_C], __entry->scanline[PIPE_C])
> diff --git a/drivers/gpu/drm/i915/display/intel_dpll.c b/drivers/gpu/drm/i915/display/intel_dpll.c
> index 1ce0c171f4fb..1c401fd09eef 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpll.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpll.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/string_helpers.h>
>  
>  #include "intel_crtc.h"
>  #include "intel_de.h"
> @@ -1933,7 +1934,7 @@ static void assert_pll(struct drm_i915_private *dev_priv,
>  	cur_state = intel_de_read(dev_priv, DPLL(pipe)) & DPLL_VCO_ENABLE;
>  	I915_STATE_WARN(cur_state != state,
>  			"PLL state assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  void assert_pll_enabled(struct drm_i915_private *i915, enum pipe pipe)
> diff --git a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> index 6723c3de5a80..a787995c0f79 100644
> --- a/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> +++ b/drivers/gpu/drm/i915/display/intel_dpll_mgr.c
> @@ -21,6 +21,8 @@
>   * DEALINGS IN THE SOFTWARE.
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include "intel_de.h"
>  #include "intel_display_types.h"
>  #include "intel_dpio_phy.h"
> @@ -178,13 +180,14 @@ void assert_shared_dpll(struct drm_i915_private *dev_priv,
>  	struct intel_dpll_hw_state hw_state;
>  
>  	if (drm_WARN(&dev_priv->drm, !pll,
> -		     "asserting DPLL %s with no DPLL\n", onoff(state)))
> +		     "asserting DPLL %s with no DPLL\n", str_on_off(state)))
>  		return;
>  
>  	cur_state = intel_dpll_get_hw_state(dev_priv, pll, &hw_state);
>  	I915_STATE_WARN(cur_state != state,
>  	     "%s assertion failure (expected %s, current %s)\n",
> -			pll->info->name, onoff(state), onoff(cur_state));
> +			pll->info->name, str_on_off(state),
> +			str_on_off(cur_state));
>  }
>  
>  static enum tc_port icl_pll_id_to_tc_port(enum intel_dpll_id id)
> diff --git a/drivers/gpu/drm/i915/display/intel_fdi.c b/drivers/gpu/drm/i915/display/intel_fdi.c
> index 3d6e22923601..0fd2941313aa 100644
> --- a/drivers/gpu/drm/i915/display/intel_fdi.c
> +++ b/drivers/gpu/drm/i915/display/intel_fdi.c
> @@ -3,6 +3,8 @@
>   * Copyright © 2020 Intel Corporation
>   */
>  
> +#include <linux/string_helpers.h>
> +
>  #include "intel_atomic.h"
>  #include "intel_crtc.h"
>  #include "intel_ddi.h"
> @@ -29,7 +31,7 @@ static void assert_fdi_tx(struct drm_i915_private *dev_priv,
>  	}
>  	I915_STATE_WARN(cur_state != state,
>  			"FDI TX state assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  void assert_fdi_tx_enabled(struct drm_i915_private *i915, enum pipe pipe)
> @@ -50,7 +52,7 @@ static void assert_fdi_rx(struct drm_i915_private *dev_priv,
>  	cur_state = intel_de_read(dev_priv, FDI_RX_CTL(pipe)) & FDI_RX_ENABLE;
>  	I915_STATE_WARN(cur_state != state,
>  			"FDI RX state assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  void assert_fdi_rx_enabled(struct drm_i915_private *i915, enum pipe pipe)
> @@ -88,7 +90,7 @@ static void assert_fdi_rx_pll(struct drm_i915_private *i915,
>  	cur_state = intel_de_read(i915, FDI_RX_CTL(pipe)) & FDI_RX_PLL_ENABLE;
>  	I915_STATE_WARN(cur_state != state,
>  			"FDI RX PLL assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  void assert_fdi_rx_pll_enabled(struct drm_i915_private *i915, enum pipe pipe)
> diff --git a/drivers/gpu/drm/i915/display/vlv_dsi_pll.c b/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
> index 1b81797dd02e..7f9c0a7c3446 100644
> --- a/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
> +++ b/drivers/gpu/drm/i915/display/vlv_dsi_pll.c
> @@ -26,6 +26,7 @@
>   */
>  
>  #include <linux/kernel.h>
> +#include <linux/string_helpers.h>
>  
>  #include "i915_drv.h"
>  #include "intel_de.h"
> @@ -580,7 +581,7 @@ static void assert_dsi_pll(struct drm_i915_private *i915, bool state)
>  
>  	I915_STATE_WARN(cur_state != state,
>  			"DSI PLL state assertion failure (expected %s, current %s)\n",
> -			onoff(state), onoff(cur_state));
> +			str_on_off(state), str_on_off(cur_state));
>  }
>  
>  void assert_dsi_pll_enabled(struct drm_i915_private *i915)
> diff --git a/drivers/gpu/drm/i915/gt/intel_rc6.c b/drivers/gpu/drm/i915/gt/intel_rc6.c
> index bb0d6e363f5d..cde83e382ebe 100644
> --- a/drivers/gpu/drm/i915/gt/intel_rc6.c
> +++ b/drivers/gpu/drm/i915/gt/intel_rc6.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/pm_runtime.h>
> +#include <linux/string_helpers.h>
>  
>  #include "i915_drv.h"
>  #include "i915_vgpu.h"
> @@ -428,8 +429,8 @@ static bool bxt_check_bios_rc6_setup(struct intel_rc6 *rc6)
>  	rc_sw_target >>= RC_SW_TARGET_STATE_SHIFT;
>  	drm_dbg(&i915->drm, "BIOS enabled RC states: "
>  			 "HW_CTRL %s HW_RC6 %s SW_TARGET_STATE %x\n",
> -			 onoff(rc_ctl & GEN6_RC_CTL_HW_ENABLE),
> -			 onoff(rc_ctl & GEN6_RC_CTL_RC6_ENABLE),
> +			 str_on_off(rc_ctl & GEN6_RC_CTL_HW_ENABLE),
> +			 str_on_off(rc_ctl & GEN6_RC_CTL_RC6_ENABLE),
>  			 rc_sw_target);
>  
>  	if (!(intel_uncore_read(uncore, RC6_LOCATION) & RC6_CTX_IN_DRAM)) {
> diff --git a/drivers/gpu/drm/i915/i915_utils.h b/drivers/gpu/drm/i915/i915_utils.h
> index 6d26920d0632..3ff9611ff81c 100644
> --- a/drivers/gpu/drm/i915/i915_utils.h
> +++ b/drivers/gpu/drm/i915/i915_utils.h
> @@ -400,11 +400,6 @@ wait_remaining_ms_from_jiffies(unsigned long timestamp_jiffies, int to_wait_ms)
>  #define MBps(x) KBps(1000 * (x))
>  #define GBps(x) ((u64)1000 * MBps((x)))
>  
> -static inline const char *onoff(bool v)
> -{
> -	return v ? "on" : "off";
> -}
> -
>  void add_taint_for_CI(struct drm_i915_private *i915, unsigned int taint);
>  static inline void __add_taint_for_CI(unsigned int taint)
>  {
> diff --git a/drivers/gpu/drm/i915/vlv_suspend.c b/drivers/gpu/drm/i915/vlv_suspend.c
> index 23adb64d640a..a49a7da57d5a 100644
> --- a/drivers/gpu/drm/i915/vlv_suspend.c
> +++ b/drivers/gpu/drm/i915/vlv_suspend.c
> @@ -3,6 +3,7 @@
>   * Copyright © 2020 Intel Corporation
>   */
>  
> +#include <linux/string_helpers.h>
>  #include <linux/kernel.h>
>  
>  #include <drm/drm_print.h>
> @@ -373,7 +374,7 @@ static void vlv_wait_for_gt_wells(struct drm_i915_private *dev_priv,
>  	if (vlv_wait_for_pw_status(dev_priv, mask, val))
>  		drm_dbg(&dev_priv->drm,
>  			"timeout waiting for GT wells to go %s\n",
> -			onoff(wait_for_on));
> +			str_on_off(wait_for_on));
>  }
>  
>  static void vlv_check_no_gt_access(struct drm_i915_private *i915)
> -- 
> 2.34.1
> 

-- 
Matt Roper
Graphics Software Engineer
VTT-OSGC Platform Enablement
Intel Corporation
(916) 356-2795
