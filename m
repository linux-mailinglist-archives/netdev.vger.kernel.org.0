Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5303F74A5
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 13:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240442AbhHYMAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 08:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238434AbhHYMAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 08:00:14 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90FD1C061757;
        Wed, 25 Aug 2021 04:59:28 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id bq28so3964159lfb.7;
        Wed, 25 Aug 2021 04:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Sh8Hhajj0pnPnQiiu2aiUUMwiCEAyqctL4Ajg0R6YEk=;
        b=B991xy72YQIKeK0YL5CfnvOiwxExWCwzKOYLrnvKItU/etqhJMEKUz7vP9FXPGV+tN
         R835TLWh68zmwjW6AD/WIdDH9ucNKaeetxUlQEB1f1faIk6+LeE/obwFpDi27ryBN/5s
         oK41Udd/lIgQD3ZgHCMv7tDY0u1AiGAujDl1gJotGb4wI4NiGhjuQJlb6tHaIqHLSgxu
         n7dwouk7paFuajiTYIjBAHmWSGj+asfv7tTZN5hjDR29CmqHfTJePRDiXsKGO7yfsWpv
         FH/lspZH+agBQkPTOaZeuwaCVkBz7OTVMklUjSm+glte/NAt0uO12lWT+CPt+Qv9+Lut
         zsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Sh8Hhajj0pnPnQiiu2aiUUMwiCEAyqctL4Ajg0R6YEk=;
        b=sqes4Jy+Oa0rRNO4X9+sruIQ8OuhoaY5Ikq1CLu48nbtdylZM6wlMThklm2yt4ewSk
         4e1bzLlNj+UaNWicAo7bAGymAiVDygKkW5u1mnGm75U9grCQjSRYsuNf22m2E+xv8+KC
         Hq6gO6gFGG/6eEmY5cOMD///9CgbTLjFxnwQBF2hW/fmT8wiJM7TSGS8tMaNOLIDRGKE
         LTQJUPj6jwcrO/b71iEOccUsjrGUiESNm5vdPIU+Gbtqi5kGYqJrb/jNLPNJTsUmkRdo
         ZAcb6uBdrgikWKnXU181pG8V9NFvWtqw2CuHHzunzw1ifei3TOoTHEiXTG/VDihRWEsk
         S2NA==
X-Gm-Message-State: AOAM5318hc7IaD40CundDYxwr+6p9G4QvS1hVGtVWtL0OFwC/a28oyBW
        74Tbh5Xzp4d5AMVYn88Vxgd8685la8UbDs5k7U0=
X-Google-Smtp-Source: ABdhPJxKumqkjQ/ZfaCK/Nc1KFD2ooxUYCqnUe8SWu8yZCKpTaP98/h7PeQqDZDQpVbBRdfWVKdV/A==
X-Received: by 2002:a19:c350:: with SMTP id t77mr1506784lff.33.1629892766712;
        Wed, 25 Aug 2021 04:59:26 -0700 (PDT)
Received: from [10.0.0.40] (91-155-111-71.elisa-laajakaista.fi. [91.155.111.71])
        by smtp.gmail.com with ESMTPSA id k23sm2104796ljg.73.2021.08.25.04.59.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Aug 2021 04:59:26 -0700 (PDT)
Subject: Re: [PATCH] kconfig: forbid symbols that end with '_MODULE'
To:     Masahiro Yamada <masahiroy@kernel.org>,
        linux-kbuild@vger.kernel.org, arnd@arndb.de
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Kalle Valo <kvalo@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Mark Brown <broonie@kernel.org>, Takashi Iwai <tiwai@suse.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20210825041637.365171-1-masahiroy@kernel.org>
From:   =?UTF-8?Q?P=c3=a9ter_Ujfalusi?= <peter.ujfalusi@gmail.com>
Message-ID: <9df591f6-53fc-4567-8758-0eb1be4eade5@gmail.com>
Date:   Wed, 25 Aug 2021 14:59:44 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210825041637.365171-1-masahiroy@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 25/08/2021 07:16, Masahiro Yamada wrote:
> Kconfig (syncconfig) generates include/generated/autoconf.h to make
> CONFIG options available to the pre-processor.
> 
> The macros are suffixed with '_MODULE' for symbols with the value 'm'.
> 
> Here is a conflict; CONFIG_FOO=m results in '#define CONFIG_FOO_MODULE 1',
> but CONFIG_FOO_MODULE=y also results in the same define.
> 
> fixdep always assumes CONFIG_FOO_MODULE comes from CONFIG_FOO=m, so the
> dependency is not properly tracked for symbols that end with '_MODULE'.
> 
> This commit makes Kconfig error out if it finds a symbol suffixed with
> '_MODULE'. This restriction does not exist if the module feature is not
> supported (at least from the Kconfig perspective).
> 
> It detected one error:
>   error: SND_SOC_DM365_VOICE_CODEC_MODULE: symbol name must not end with '_MODULE'
> 
> Rename it to SND_SOC_DM365_VOICE_CODEC_MODULAR. Commit 147162f57515
> ("ASoC: ti: fix SND_SOC_DM365_VOICE_CODEC dependencies") added it for
> internal use. So, this renaming has no impact on users.
> 
> Remove a comment from drivers/net/wireless/intel/iwlwifi/Kconfig since
> this is a hard error now.
> 
> Add a comment to include/linux/kconfig.h in order not to worry observant
> developers.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
> 
>  drivers/net/wireless/intel/iwlwifi/Kconfig |  1 -
>  include/linux/kconfig.h                    |  3 ++
>  scripts/kconfig/parser.y                   | 40 +++++++++++++++++++++-
>  sound/soc/ti/Kconfig                       |  2 +-
>  4 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
> index 1085afbefba8..5b238243617c 100644
> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
> @@ -70,7 +70,6 @@ config IWLMVM
>  	  of the devices that use this firmware is available here:
>  	  https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware
>  
> -# don't call it _MODULE -- will confuse Kconfig/fixdep/...
>  config IWLWIFI_OPMODE_MODULAR
>  	bool
>  	default y if IWLDVM=m
> diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
> index 20d1079e92b4..54f677e742fe 100644
> --- a/include/linux/kconfig.h
> +++ b/include/linux/kconfig.h
> @@ -53,6 +53,9 @@
>   * IS_MODULE(CONFIG_FOO) evaluates to 1 if CONFIG_FOO is set to 'm', 0
>   * otherwise.  CONFIG_FOO=m results in "#define CONFIG_FOO_MODULE 1" in
>   * autoconf.h.
> + * CONFIG_FOO_MODULE=y would also result in "#define CONFIG_FOO_MODULE 1",
> + * but Kconfig forbids symbol names that end with '_MODULE', so that would
> + * not happen.
>   */
>  #define IS_MODULE(option) __is_defined(option##_MODULE)
>  
> diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
> index 2af7ce4e1531..b0f73f74ccd3 100644
> --- a/scripts/kconfig/parser.y
> +++ b/scripts/kconfig/parser.y
> @@ -475,6 +475,37 @@ assign_val:
>  
>  %%
>  
> +/*
> + * Symbols suffixed with '_MODULE' would cause a macro conflict in autoconf.h,
> + * and also confuse the interaction between syncconfig and fixdep.
> + * Error out if a symbol with the '_MODULE' suffix is found.
> + */
> +static int sym_check_name(struct symbol *sym)
> +{
> +	static const char *suffix = "_MODULE";
> +	static const size_t suffix_len = strlen("_MODULE");
> +	char *name;
> +	size_t len;
> +
> +	name = sym->name;
> +
> +	if (!name)
> +		return 0;
> +
> +	len = strlen(name);
> +
> +	if (len < suffix_len)
> +		return 0;
> +
> +	if (strcmp(name + len - suffix_len, suffix))
> +		return 0;
> +
> +	fprintf(stderr, "error: %s: symbol name must not end with '%s'\n",
> +		name, suffix);
> +
> +	return -1;
> +}
> +
>  void conf_parse(const char *name)
>  {
>  	struct symbol *sym;
> @@ -493,8 +524,15 @@ void conf_parse(const char *name)
>  
>  	if (yynerrs)
>  		exit(1);
> -	if (!modules_sym)
> +
> +	if (modules_sym) {
> +		for_all_symbols(i, sym) {
> +			if (sym_check_name(sym))
> +				yynerrs++;
> +		}
> +	} else {
>  		modules_sym = sym_find( "n" );
> +	}
>  
>  	if (!menu_has_prompt(&rootmenu)) {
>  		current_entry = &rootmenu;
> diff --git a/sound/soc/ti/Kconfig b/sound/soc/ti/Kconfig
> index 698d7bc84dcf..c56a5789056f 100644
> --- a/sound/soc/ti/Kconfig
> +++ b/sound/soc/ti/Kconfig
> @@ -211,7 +211,7 @@ config SND_SOC_DM365_VOICE_CODEC
>  	  Say Y if you want to add support for SoC On-chip voice codec
>  endchoice
>  
> -config SND_SOC_DM365_VOICE_CODEC_MODULE
> +config SND_SOC_DM365_VOICE_CODEC_MODULAR

This Kconfig option is only used to select the codecs needed for the
voice mode, I think it would be better to use something like

SND_SOC_DM365_SELECT_VOICE_CODECS ?

>  	def_tristate y
>  	depends on SND_SOC_DM365_VOICE_CODEC && SND_SOC
>  	select MFD_DAVINCI_VOICECODEC
> 

-- 
Péter
