Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6FCB17A04
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 15:11:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfEHNLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 09:11:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:1677 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbfEHNLi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 May 2019 09:11:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 May 2019 06:11:37 -0700
X-ExtLoop1: 1
Received: from smile.fi.intel.com (HELO smile) ([10.237.72.86])
  by orsmga001.jf.intel.com with ESMTP; 08 May 2019 06:11:29 -0700
Received: from andy by smile with local (Exim 4.92)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1hOMM4-0000is-79; Wed, 08 May 2019 16:11:28 +0300
Date:   Wed, 8 May 2019 16:11:28 +0300
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-tegra@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-mtd@lists.infradead.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, alsa-devel@alsa-project.org,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Message-ID: <20190508131128.GL9224@smile.fi.intel.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
 <20190508112842.11654-5-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508112842.11654-5-alexandru.ardelean@analog.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 08, 2019 at 02:28:29PM +0300, Alexandru Ardelean wrote:
> This change re-introduces `match_string()` as a macro that uses
> ARRAY_SIZE() to compute the size of the array.
> The macro is added in all the places that do
> `match_string(_a, ARRAY_SIZE(_a), s)`, since the change is pretty
> straightforward.

Can you split include/linux/ change from the rest?

> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/clk/bcm/clk-bcm2835.c                    | 4 +---
>  drivers/gpio/gpiolib-of.c                        | 2 +-
>  drivers/gpu/drm/i915/intel_pipe_crc.c            | 2 +-
>  drivers/mfd/omap-usb-host.c                      | 2 +-
>  drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c | 2 +-
>  drivers/pci/pcie/aer.c                           | 2 +-
>  drivers/usb/common/common.c                      | 4 ++--
>  drivers/usb/typec/class.c                        | 8 +++-----
>  drivers/usb/typec/tps6598x.c                     | 2 +-
>  drivers/vfio/vfio.c                              | 4 +---
>  include/linux/string.h                           | 9 +++++++++
>  sound/firewire/oxfw/oxfw.c                       | 2 +-
>  sound/soc/codecs/max98088.c                      | 2 +-
>  sound/soc/codecs/max98095.c                      | 2 +-
>  14 files changed, 25 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/clk/bcm/clk-bcm2835.c b/drivers/clk/bcm/clk-bcm2835.c
> index a775f6a1f717..1ab388590ead 100644
> --- a/drivers/clk/bcm/clk-bcm2835.c
> +++ b/drivers/clk/bcm/clk-bcm2835.c
> @@ -1390,9 +1390,7 @@ static struct clk_hw *bcm2835_register_clock(struct bcm2835_cprman *cprman,
>  	for (i = 0; i < data->num_mux_parents; i++) {
>  		parents[i] = data->parents[i];
>  
> -		ret = __match_string(cprman_parent_names,
> -				     ARRAY_SIZE(cprman_parent_names),
> -				     parents[i]);
> +		ret = match_string(cprman_parent_names, parents[i]);
>  		if (ret >= 0)
>  			parents[i] = cprman->real_parent_names[ret];
>  	}
> diff --git a/drivers/gpio/gpiolib-of.c b/drivers/gpio/gpiolib-of.c
> index 27d6f04ab58e..71e886869d78 100644
> --- a/drivers/gpio/gpiolib-of.c
> +++ b/drivers/gpio/gpiolib-of.c
> @@ -279,7 +279,7 @@ static struct gpio_desc *of_find_regulator_gpio(struct device *dev, const char *
>  	if (!con_id)
>  		return ERR_PTR(-ENOENT);
>  
> -	i = __match_string(whitelist, ARRAY_SIZE(whitelist), con_id);
> +	i = match_string(whitelist, con_id);
>  	if (i < 0)
>  		return ERR_PTR(-ENOENT);
>  
> diff --git a/drivers/gpu/drm/i915/intel_pipe_crc.c b/drivers/gpu/drm/i915/intel_pipe_crc.c
> index 286fad1f0e08..6fc4f3d3d1f6 100644
> --- a/drivers/gpu/drm/i915/intel_pipe_crc.c
> +++ b/drivers/gpu/drm/i915/intel_pipe_crc.c
> @@ -449,7 +449,7 @@ display_crc_ctl_parse_source(const char *buf, enum intel_pipe_crc_source *s)
>  		return 0;
>  	}
>  
> -	i = __match_string(pipe_crc_sources, ARRAY_SIZE(pipe_crc_sources), buf);
> +	i = match_string(pipe_crc_sources, buf);
>  	if (i < 0)
>  		return i;
>  
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 9aaacb5bdb26..53dff34c0afc 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -509,7 +509,7 @@ static int usbhs_omap_get_dt_pdata(struct device *dev,
>  			continue;
>  
>  		/* get 'enum usbhs_omap_port_mode' from port mode string */
> -		ret = __match_string(port_modes, ARRAY_SIZE(port_modes), mode);
> +		ret = match_string(port_modes, mode);
>  		if (ret < 0) {
>  			dev_warn(dev, "Invalid port%d-mode \"%s\" in device tree\n",
>  					i, mode);
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> index 59ce3ff35553..778b4dfd8b75 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c
> @@ -667,7 +667,7 @@ iwl_dbgfs_bt_force_ant_write(struct iwl_mvm *mvm, char *buf,
>  	};
>  	int ret, bt_force_ant_mode;
>  
> -	ret = __match_string(modes_str, ARRAY_SIZE(modes_str), buf);
> +	ret = match_string(modes_str, buf);
>  	if (ret < 0)
>  		return ret;
>  
> diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
> index 41a0773a1cbc..2278caba109c 100644
> --- a/drivers/pci/pcie/aer.c
> +++ b/drivers/pci/pcie/aer.c
> @@ -203,7 +203,7 @@ void pcie_ecrc_get_policy(char *str)
>  {
>  	int i;
>  
> -	i = __match_string(ecrc_policy_str, ARRAY_SIZE(ecrc_policy_str), str);
> +	i = match_string(ecrc_policy_str, str);
>  	if (i < 0)
>  		return;
>  
> diff --git a/drivers/usb/common/common.c b/drivers/usb/common/common.c
> index bca0c404c6ca..5a651d311d38 100644
> --- a/drivers/usb/common/common.c
> +++ b/drivers/usb/common/common.c
> @@ -68,7 +68,7 @@ enum usb_device_speed usb_get_maximum_speed(struct device *dev)
>  	if (ret < 0)
>  		return USB_SPEED_UNKNOWN;
>  
> -	ret = __match_string(speed_names, ARRAY_SIZE(speed_names), maximum_speed);
> +	ret = match_string(speed_names, maximum_speed);
>  
>  	return (ret < 0) ? USB_SPEED_UNKNOWN : ret;
>  }
> @@ -106,7 +106,7 @@ static enum usb_dr_mode usb_get_dr_mode_from_string(const char *str)
>  {
>  	int ret;
>  
> -	ret = __match_string(usb_dr_modes, ARRAY_SIZE(usb_dr_modes), str);
> +	ret = match_string(usb_dr_modes, str);
>  	return (ret < 0) ? USB_DR_MODE_UNKNOWN : ret;
>  }
>  
> diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
> index 4abc5a76ec51..38ac776cba8a 100644
> --- a/drivers/usb/typec/class.c
> +++ b/drivers/usb/typec/class.c
> @@ -1409,8 +1409,7 @@ EXPORT_SYMBOL_GPL(typec_set_pwr_opmode);
>   */
>  int typec_find_port_power_role(const char *name)
>  {
> -	return __match_string(typec_port_power_roles,
> -			      ARRAY_SIZE(typec_port_power_roles), name);
> +	return match_string(typec_port_power_roles, name);
>  }
>  EXPORT_SYMBOL_GPL(typec_find_port_power_role);
>  
> @@ -1424,7 +1423,7 @@ EXPORT_SYMBOL_GPL(typec_find_port_power_role);
>   */
>  int typec_find_power_role(const char *name)
>  {
> -	return __match_string(typec_roles, ARRAY_SIZE(typec_roles), name);
> +	return match_string(typec_roles, name);
>  }
>  EXPORT_SYMBOL_GPL(typec_find_power_role);
>  
> @@ -1438,8 +1437,7 @@ EXPORT_SYMBOL_GPL(typec_find_power_role);
>   */
>  int typec_find_port_data_role(const char *name)
>  {
> -	return __match_string(typec_port_data_roles,
> -			      ARRAY_SIZE(typec_port_data_roles), name);
> +	return match_string(typec_port_data_roles, name);
>  }
>  EXPORT_SYMBOL_GPL(typec_find_port_data_role);
>  
> diff --git a/drivers/usb/typec/tps6598x.c b/drivers/usb/typec/tps6598x.c
> index 0389e4391faf..0c4e47868590 100644
> --- a/drivers/usb/typec/tps6598x.c
> +++ b/drivers/usb/typec/tps6598x.c
> @@ -423,7 +423,7 @@ static int tps6598x_check_mode(struct tps6598x *tps)
>  	if (ret)
>  		return ret;
>  
> -	switch (__match_string(modes, ARRAY_SIZE(modes), mode)) {
> +	switch (match_string(modes, mode)) {
>  	case TPS_MODE_APP:
>  		return 0;
>  	case TPS_MODE_BOOT:
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index b31585ecf48f..fe8283d3781b 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -637,9 +637,7 @@ static bool vfio_dev_whitelisted(struct device *dev, struct device_driver *drv)
>  			return true;
>  	}
>  
> -	return __match_string(vfio_driver_whitelist,
> -			      ARRAY_SIZE(vfio_driver_whitelist),
> -			      drv->name) >= 0;
> +	return match_string(vfio_driver_whitelist, drv->name) >= 0;
>  }
>  
>  /*
> diff --git a/include/linux/string.h b/include/linux/string.h
> index 531d04308ff9..07e9f89088df 100644
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -194,6 +194,15 @@ static inline int strtobool(const char *s, bool *res)
>  int __match_string(const char * const *array, size_t n, const char *string);
>  int __sysfs_match_string(const char * const *array, size_t n, const char *s);
>  
> +/**
> + * match_string - matches given string in an array
> + * @_a: array of strings
> + * @_s: string to match with
> + *
> + * Helper for __match_string(). Calculates the size of @a automatically.
> + */
> +#define match_string(_a, _s) __match_string(_a, ARRAY_SIZE(_a), _s)
> +
>  /**
>   * sysfs_match_string - matches given string in an array
>   * @_a: array of strings
> diff --git a/sound/firewire/oxfw/oxfw.c b/sound/firewire/oxfw/oxfw.c
> index 9ec5316f3bb5..433fc84c4f90 100644
> --- a/sound/firewire/oxfw/oxfw.c
> +++ b/sound/firewire/oxfw/oxfw.c
> @@ -57,7 +57,7 @@ static bool detect_loud_models(struct fw_unit *unit)
>  	if (err < 0)
>  		return false;
>  
> -	return __match_string(models, ARRAY_SIZE(models), model) >= 0;
> +	return match_string(models, model) >= 0;
>  }
>  
>  static int name_card(struct snd_oxfw *oxfw)
> diff --git a/sound/soc/codecs/max98088.c b/sound/soc/codecs/max98088.c
> index 3ef743075bda..911ffe84c37e 100644
> --- a/sound/soc/codecs/max98088.c
> +++ b/sound/soc/codecs/max98088.c
> @@ -1405,7 +1405,7 @@ static int max98088_get_channel(struct snd_soc_component *component, const char
>  {
>  	int ret;
>  
> -	ret = __match_string(eq_mode_name, ARRAY_SIZE(eq_mode_name), name);
> +	ret = match_string(eq_mode_name, name);
>  	if (ret < 0)
>  		dev_err(component->dev, "Bad EQ channel name '%s'\n", name);
>  	return ret;
> diff --git a/sound/soc/codecs/max98095.c b/sound/soc/codecs/max98095.c
> index cd69916d5dcb..d182d45d0c83 100644
> --- a/sound/soc/codecs/max98095.c
> +++ b/sound/soc/codecs/max98095.c
> @@ -1636,7 +1636,7 @@ static int max98095_get_bq_channel(struct snd_soc_component *component,
>  {
>  	int ret;
>  
> -	ret = __match_string(bq_mode_name, ARRAY_SIZE(bq_mode_name), name);
> +	ret = match_string(bq_mode_name, name);
>  	if (ret < 0)
>  		dev_err(component->dev, "Bad biquad channel name '%s'\n", name);
>  	return ret;
> -- 
> 2.17.1
> 

-- 
With Best Regards,
Andy Shevchenko


