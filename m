Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294E56BA76A
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbjCOF5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCOF5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:57:49 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE6923A6C;
        Tue, 14 Mar 2023 22:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678859867; x=1710395867;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KZwXNx6JA/q1Po/KSWbZrXcqkAKKIzgtpZZMf0mejaw=;
  b=VKUrOpv7UIIcMSloGtUwlH72T9j0v/vOAcUxenQsxAKk1x11liVCEp/V
   /7UarOYYdJ0G/F+fjCnp7CJ8EsoFREmfACJnwtS8MeGFVr6gglXLWOXpp
   ePPHETiWboqLZUgCX1JOr+QcP6lC0Ffb7U7KcxMOqshatoKk1NU0jzHeT
   95MHZL7a0QRFQZCRbjnb9KerLgwQyw+MmO0Q5qk8Xa2Sf8AZnEsBMYiJo
   fzBvTDh5dN8Nw3CQoi+9E2nlqPjEesuBFOSFzPOMSBEIOWaOkKNI7aWTu
   NCj1+W+jXYRKcknF5A/7KLOvSboTv1w1MlshWb+/7vLlG0VWUigKkuhVy
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="365298263"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="365298263"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 22:57:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10649"; a="768385445"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="768385445"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 22:57:45 -0700
Date:   Wed, 15 Mar 2023 06:57:37 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
Message-ID: <ZBFeUazA9X9mmWiJ@localhost.localdomain>
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 08:18:24PM +0200, Andy Shevchenko wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> v6: wrapped long lines (Simon, Jakub)
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
>  1 file changed, 24 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/net/dsa/hirschmann/hellcreek_ptp.c b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> index b28baab6d56a..3e44ccb7db84 100644
> --- a/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> +++ b/drivers/net/dsa/hirschmann/hellcreek_ptp.c
> @@ -297,7 +297,8 @@ static enum led_brightness hellcreek_led_is_gm_get(struct led_classdev *ldev)
>  static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  {
>  	struct device_node *leds, *led = NULL;
> -	const char *label, *state;
> +	enum led_default_state state;
> +	const char *label;
>  	int ret = -EINVAL;
>  
>  	of_node_get(hellcreek->dev->of_node);
> @@ -318,16 +319,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  	ret = of_property_read_string(led, "label", &label);
>  	hellcreek->led_sync_good.name = ret ? "sync_good" : label;
>  
> -	ret = of_property_read_string(led, "default-state", &state);
> -	if (!ret) {
> -		if (!strcmp(state, "on"))
> -			hellcreek->led_sync_good.brightness = 1;
> -		else if (!strcmp(state, "off"))
> -			hellcreek->led_sync_good.brightness = 0;
> -		else if (!strcmp(state, "keep"))
> -			hellcreek->led_sync_good.brightness =
> -				hellcreek_get_brightness(hellcreek,
> -							 STATUS_OUT_SYNC_GOOD);
> +	state = led_init_default_state_get(of_fwnode_handle(led));
> +	switch (state) {
> +	case LEDS_DEFSTATE_ON:
> +		hellcreek->led_sync_good.brightness = 1;
> +		break;
> +	case LEDS_DEFSTATE_KEEP:
> +		hellcreek->led_sync_good.brightness =
> +			hellcreek_get_brightness(hellcreek, STATUS_OUT_SYNC_GOOD);
> +		break;
> +	default:
> +		hellcreek->led_sync_good.brightness = 0;
>  	}
>  
>  	hellcreek->led_sync_good.max_brightness = 1;
> @@ -344,16 +346,17 @@ static int hellcreek_led_setup(struct hellcreek *hellcreek)
>  	ret = of_property_read_string(led, "label", &label);
>  	hellcreek->led_is_gm.name = ret ? "is_gm" : label;
>  
> -	ret = of_property_read_string(led, "default-state", &state);
> -	if (!ret) {
> -		if (!strcmp(state, "on"))
> -			hellcreek->led_is_gm.brightness = 1;
> -		else if (!strcmp(state, "off"))
> -			hellcreek->led_is_gm.brightness = 0;
> -		else if (!strcmp(state, "keep"))
> -			hellcreek->led_is_gm.brightness =
> -				hellcreek_get_brightness(hellcreek,
> -							 STATUS_OUT_IS_GM);
> +	state = led_init_default_state_get(of_fwnode_handle(led));
> +	switch (state) {
> +	case LEDS_DEFSTATE_ON:
> +		hellcreek->led_is_gm.brightness = 1;
> +		break;
> +	case LEDS_DEFSTATE_KEEP:
> +		hellcreek->led_is_gm.brightness =
> +			hellcreek_get_brightness(hellcreek, STATUS_OUT_IS_GM);
> +		break;
> +	default:
> +		hellcreek->led_is_gm.brightness = 0;

Hi,

You have to fix implict declaration of the led_init_default_state_get().

I wonder if the code duplication here can be avoided:
static void set_led_brightness(hellcreek, led, *brightness, status)
{
	enum led_default_state state =
		led_init_default_state_get(of_fwnode_handle(led));

	switch(state) {
	case LEDS_DEFSTATE_ON:
		*brightness = 1;
		break;
	case LEDS_DEFSTATE_KEEP:
		*brightness = hellcreek_get_brightness(hellcreek, status);
		break;
	default:
		*brightness = 0;
	}
}

and call it like:
set_led_brightness(heelcreek, led, &heelcreek->...,
		   STATUS_OUT_IS_GM/SYNC_GOOD);

Only suggestion, patch looks good.

Thanks,
Michal

>  	}
>  
>  	hellcreek->led_is_gm.max_brightness = 1;
> -- 
> 2.39.2
> 
