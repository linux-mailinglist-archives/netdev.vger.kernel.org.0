Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7CF87E0C
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 17:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436616AbfHIPcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 11:32:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38751 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436608AbfHIPcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 11:32:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id z14so8804240pga.5
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 08:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=z8obxCtqYi0AJWakTgLoiNjwfUmlWSuBvnJW1CvZOqw=;
        b=OPmRFYQxrJPZJm2/Oy786eOt570EfhKt8L9pPhIHA+nKkwk8fPVrIEc55oAHgNhkC8
         lWDHAnRzTD/WPovc7OGwHf2LeYCY8nhzKYpO+rZ7x7UvtQ735N7qAZwKcsX4WyoIsSLU
         GQerOm2wR32WgZwK3C58rYOqGXUQKeYo5X9VbTqOXkG8RnZKnAqo/yPsY7cCOjTkkVRm
         4gcfA00OrWpv3pkQg4SDxAmsfWan0RrY4JtJOBDM2EyzVg6Yr9Q6FyGP2Um8rRG/EJML
         qrCBCXYHit2guFlHBm2eq9y5FRhoF2yCopkDF9+YK7ZbXsCWjB629xWi5wQ0xtjzTtxo
         U+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=z8obxCtqYi0AJWakTgLoiNjwfUmlWSuBvnJW1CvZOqw=;
        b=rusMbQepIErVD2qHZHHIWRLfmnEsUgPz6jh2bxZxd+IW5UgiLdrDWY02slMfISBI94
         7JTcYuOnvmyOZlFNAycaMtaR58vHgj0UCm/jTw2zlXNMdPRN7cu2Zh70mptDDg0UXUMG
         XsqCRDED3/KGGanaQts67275ayxiXKH3JJUuWN6Ovi4NN3ANrGG1j0Dss7f9KKpv+5GP
         BG/cAprRXvdSfRD9zDiXtPfrdVOpEENQay2bkGBB7etNO2IPbj73joZWLn/Gfwk23ph8
         K+L5pm72K/NKMBo7XbfLcaQsApfUHc1x1CYTOqxtwUH5YqugWfvC7HAtYcE84JHHlSOV
         0J6w==
X-Gm-Message-State: APjAAAWqz1Tcw1kFatRw6/eBu8+BZzQ8l6cB6XPDQrvJPjbqnlGxZDsT
        UGjQJFs3bEwSSyyKWpTndjUlTw==
X-Google-Smtp-Source: APXvYqzgkqz3cduqaUHqyWdvPdTNy6bZqY6qn5l6Sp0hAKr8kZlrPSUg93DRvqEyopFjEzRQLqCUOQ==
X-Received: by 2002:a62:2784:: with SMTP id n126mr22405505pfn.61.1565364732006;
        Fri, 09 Aug 2019 08:32:12 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id t7sm100393089pfh.101.2019.08.09.08.32.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 08:32:11 -0700 (PDT)
Date:   Fri, 9 Aug 2019 08:32:10 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH v3] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190809153210.GD2820@mini-arch>
References: <20190809003911.7852-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809003911.7852-1-peter@lekensteyn.nl>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/09, Peter Wu wrote:
> /proc/config has never existed as far as I can see, but /proc/config.gz
> is present on Arch Linux. Add support for decompressing config.gz using
> zlib which is a mandatory dependency of libelf. Replace existing stdio
> functions with gzFile operations since the latter transparently handles
> uncompressed and gzip-compressed files.
> 
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  v3: replace popen(gunzip) by linking directly to zlib. Reword commit
>      message, remove "Fixes" line. (this patch)
>  v2: fix style (reorder vars as reverse xmas tree, rename function,
>      braces), fallback to /proc/config.gz if uname() fails.
>      https://lkml.kernel.org/r/20190806010702.3303-1-peter@lekensteyn.nl
>  v1: https://lkml.kernel.org/r/20190805001541.8096-1-peter@lekensteyn.nl
> 
> Hi,
> 
> Thanks to Jakub for observing that zlib is already used by libelf, this
> simplifies the patch tremendously as the same API can be used for both
> compressed and uncompressed files. No special case exists anymore for
> fclose/pclose.
> 
> According to configure.ac in elfutils, zlib is mandatory, so I just
> assume it to be available. For simplicity I also silently assume lines
> to be less than 4096 characters. If that is not the case, then lines
> will appear truncated, but that should not be an issue for the
> CONFIG_xyz lines that we are scanning for.
> 
> Jakub requested the handle leak fix to be posted separately against the
> bpf tree, but since the whole code is rewritten I am not sure if it is
> worth it. It is an unusual edge case: /boot/config-$(uname -r) could be
> opened, but starts with unexpected data.
> 
> Kind regards,
> Peter
> ---
>  tools/bpf/bpftool/Makefile  |   2 +-
>  tools/bpf/bpftool/feature.c | 105 ++++++++++++++++++------------------
>  2 files changed, 54 insertions(+), 53 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index a7afea4dec47..078bd0dcfba5 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -52,7 +52,7 @@ ifneq ($(EXTRA_LDFLAGS),)
>  LDFLAGS += $(EXTRA_LDFLAGS)
>  endif
>  
> -LIBS = -lelf $(LIBBPF)
> +LIBS = -lelf -lz $(LIBBPF)
You're saying in the commit description that bpftool already links
against -lz (via -lelf), but then explicitly add -lz here, why?

>  INSTALL ?= install
>  RM ?= rm -f
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index d672d9086fff..03bdc5b3ac49 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -14,6 +14,7 @@
>  
>  #include <bpf.h>
>  #include <libbpf.h>
> +#include <zlib.h>
>  
>  #include "main.h"
>  
> @@ -284,34 +285,32 @@ static void probe_jit_limit(void)
>  	}
>  }
>  
> -static char *get_kernel_config_option(FILE *fd, const char *option)
> +static bool read_next_kernel_config_option(gzFile file, char *buf, size_t n,
> +					   char **value)
>  {
> -	size_t line_n = 0, optlen = strlen(option);
> -	char *res, *strval, *line = NULL;
> -	ssize_t n;
> +	char *sep;
>  
> -	rewind(fd);
> -	while ((n = getline(&line, &line_n, fd)) > 0) {
> -		if (strncmp(line, option, optlen))
> +	while (gzgets(file, buf, n)) {
> +		if (strncmp(buf, "CONFIG_", 7))
>  			continue;
> -		/* Check we have at least '=', value, and '\n' */
> -		if (strlen(line) < optlen + 3)
> -			continue;
> -		if (*(line + optlen) != '=')
> +
> +		sep = strchr(buf, '=');
> +		if (!sep)
>  			continue;
>  
>  		/* Trim ending '\n' */
> -		line[strlen(line) - 1] = '\0';
> +		buf[strlen(buf) - 1] = '\0';
> +
> +		/* Split on '=' and ensure that a value is present. */
> +		*sep = '\0';
> +		if (!sep[1])
> +			continue;
>  
> -		/* Copy and return config option value */
> -		strval = line + optlen + 1;
> -		res = strdup(strval);
> -		free(line);
> -		return res;
> +		*value = sep + 1;
> +		return true;
>  	}
> -	free(line);
>  
> -	return NULL;
> +	return false;
>  }
>  
>  static void probe_kernel_image_config(void)
> @@ -386,59 +385,61 @@ static void probe_kernel_image_config(void)
>  		/* test_bpf module for BPF tests */
>  		"CONFIG_TEST_BPF",
>  	};
> -	char *value, *buf = NULL;
> +	char *values[ARRAY_SIZE(options)] = { };
>  	struct utsname utsn;
>  	char path[PATH_MAX];
> -	size_t i, n;
> -	ssize_t ret;
> -	FILE *fd;
> +	gzFile file = NULL;
> +	char buf[4096];
> +	char *value;
> +	size_t i;
>  
> -	if (uname(&utsn))
> -		goto no_config;
> +	if (!uname(&utsn)) {
> +		snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
>  
> -	snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
> +		/* gzopen also accepts uncompressed files. */
> +		file = gzopen(path, "r");
> +	}
>  
> -	fd = fopen(path, "r");
> -	if (!fd && errno == ENOENT) {
> -		/* Some distributions put the config file at /proc/config, give
> -		 * it a try.
> -		 * Sometimes it is also at /proc/config.gz but we do not try
> -		 * this one for now, it would require linking against libz.
> +	if (!file) {
> +		/* Some distributions build with CONFIG_IKCONFIG=y and put the
> +		 * config file at /proc/config.gz.
>  		 */
> -		fd = fopen("/proc/config", "r");
> +		file = gzopen("/proc/config.gz", "r");
>  	}
> -	if (!fd) {
> +	if (!file) {
>  		p_info("skipping kernel config, can't open file: %s",
>  		       strerror(errno));
> -		goto no_config;
> +		goto end_parse;
>  	}
>  	/* Sanity checks */
> -	ret = getline(&buf, &n, fd);
> -	ret = getline(&buf, &n, fd);
> -	if (!buf || !ret) {
> +	if (!gzgets(file, buf, sizeof(buf)) ||
> +	    !gzgets(file, buf, sizeof(buf))) {
>  		p_info("skipping kernel config, can't read from file: %s",
>  		       strerror(errno));
> -		free(buf);
> -		goto no_config;
> +		goto end_parse;
>  	}
>  	if (strcmp(buf, "# Automatically generated file; DO NOT EDIT.\n")) {
>  		p_info("skipping kernel config, can't find correct file");
> -		free(buf);
> -		goto no_config;
> +		goto end_parse;
>  	}
> -	free(buf);
>  
> -	for (i = 0; i < ARRAY_SIZE(options); i++) {
> -		value = get_kernel_config_option(fd, options[i]);
> -		print_kernel_option(options[i], value);
> -		free(value);
> +	while (read_next_kernel_config_option(file, buf, sizeof(buf), &value)) {
> +		for (i = 0; i < ARRAY_SIZE(options); i++) {
> +			if (values[i] || strcmp(buf, options[i]))
> +				continue;
> +
> +			values[i] = strdup(value);
> +		}
>  	}
> -	fclose(fd);
> -	return;
>  
> -no_config:
> -	for (i = 0; i < ARRAY_SIZE(options); i++)
> -		print_kernel_option(options[i], NULL);
> +end_parse:
> +	if (file)
> +		gzclose(file);
> +
> +	for (i = 0; i < ARRAY_SIZE(options); i++) {
> +		print_kernel_option(options[i], values[i]);
> +		free(values[i]);
> +	}
>  }
>  
>  static bool probe_bpf_syscall(const char *define_prefix)
> -- 
> 2.22.0
> 
