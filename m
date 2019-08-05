Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E6C82031
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbfHEP3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:29:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:41920 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728801AbfHEP3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 11:29:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id m9so36481830pls.8
        for <netdev@vger.kernel.org>; Mon, 05 Aug 2019 08:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w1v2+Tykb2sZKhqwgNej+e7eXEs7GUgVvY9aKMCM/TY=;
        b=gYwXF/mOw8ixbb+hBJk46YVPwCQUSBjs6g1XDQ3IbrzfhFcOg1SGHOQcAqESudH4GX
         3iA5dJS5aKyTkyda3K/ph5SYb00ZqQ404u3e6K1aN9F9FYYNjw5hYqEQ0qFRfnQvVXeZ
         /EjhaCqh7dZw8vvwWOycebnqWUVUXuP37diTXMVHITKqJZXN1aTpatydwabTsWsRK7CQ
         iQF4F59lio/bbIdGG4oEYGBMtWjTjiErZpEaNylLs2+q/20fB9kuC+gAjvD3tDa99jf+
         E6Q8uy+eJkUyPcPJFj0GHsUvZhqUka5E4pj2orLqJhGvS9W2zxcpRf0HF9I2B7P/o2wk
         Bbpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w1v2+Tykb2sZKhqwgNej+e7eXEs7GUgVvY9aKMCM/TY=;
        b=rLY0FB6LzAUl9u9xGmSQuQgk5xZoRM3gLk3UyL3cXvnHPcumihcc5Agn48t1Q7+XT9
         Y+V6EHsjkQDPJRTBrAR02uHkeyaP3qyg9H5qbye/fGRzDEujvg1J/SOLnEIE7z3koJ86
         jLJIsoQYD8Yi1qbx/CE5gChjqbbXnGByi7L7/lsy8U37rYGlfO+yrcP1Wc54uybee9um
         qWHc4Xg6Mb+WPfJym/me7GZMiX0bG4R5blnNJP6QACRVbEMW86o5LSsHLgFS0QT+99CV
         sQIah5seRzJJLBXxL4hrajyP2fGQLfBxMPkpt1IxkFAylahgaJ/Rhw0BfZFTqT+Rc47L
         BMkg==
X-Gm-Message-State: APjAAAVxeqjJ7wEs6YpqUp9NqgXYsPM8PUnWIQsDlBTYscR5353G0ohh
        +x5PfbAv+D7KyQLR54oa8xE=
X-Google-Smtp-Source: APXvYqx2S9bZ5W44FH/TpA4djTFPZ4LfQgNah84TNlulCa1ntTmKHxoxJ35c49xC0DbZoBTVc44MJg==
X-Received: by 2002:a17:902:324:: with SMTP id 33mr140630517pld.340.1565018977909;
        Mon, 05 Aug 2019 08:29:37 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id 22sm8217582pgl.0.2019.08.05.08.29.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 08:29:37 -0700 (PDT)
Date:   Mon, 5 Aug 2019 08:29:36 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Peter Wu <peter@lekensteyn.nl>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
Subject: Re: [PATCH] tools: bpftool: fix reading from /proc/config.gz
Message-ID: <20190805152936.GE4544@mini-arch>
References: <20190805001541.8096-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805001541.8096-1-peter@lekensteyn.nl>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/05, Peter Wu wrote:
> /proc/config has never existed as far as I can see, but /proc/config.gz
> is present on Arch Linux. Execute an external gunzip program to avoid
> linking to zlib and rework the option scanning code since a pipe is not
> seekable. This also fixes a file handle leak on some error paths.
Thanks for doing that! One question: why not link against -lz instead?
With fork/execing gunzip you're just hiding this dependency.

You can add something like this to the Makefile:
ifeq ($(feature-zlib),1)
CLFAGS += -DHAVE_ZLIB
endif

And then conditionally add support for config.gz. Thoughts?

> 
> Fixes: 4567b983f78c ("tools: bpftool: add probes for kernel configuration options")
> Cc: Quentin Monnet <quentin.monnet@netronome.com>
> Signed-off-by: Peter Wu <peter@lekensteyn.nl>
> ---
>  tools/bpf/bpftool/feature.c | 92 +++++++++++++++++++++----------------
>  1 file changed, 52 insertions(+), 40 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index d672d9086fff..e9e10f582047 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -284,34 +284,34 @@ static void probe_jit_limit(void)
>  	}
>  }
>  
> -static char *get_kernel_config_option(FILE *fd, const char *option)
> +static bool get_kernel_config_option(FILE *fd, char **buf_p, size_t *n_p,
> +				     char **value)
>  {
> -	size_t line_n = 0, optlen = strlen(option);
> -	char *res, *strval, *line = NULL;
> -	ssize_t n;
> +	char *sep;
> +	ssize_t linelen;
>  
> -	rewind(fd);
> -	while ((n = getline(&line, &line_n, fd)) > 0) {
> -		if (strncmp(line, option, optlen))
> +	while ((linelen = getline(buf_p, n_p, fd)) > 0) {
> +		char *line = *buf_p;
> +		if (strncmp(line, "CONFIG_", 7))
>  			continue;
> -		/* Check we have at least '=', value, and '\n' */
> -		if (strlen(line) < optlen + 3)
> -			continue;
> -		if (*(line + optlen) != '=')
> +
> +		sep = memchr(line, '=', linelen);
> +		if (!sep)
>  			continue;
>  
>  		/* Trim ending '\n' */
> -		line[strlen(line) - 1] = '\0';
> +		line[linelen - 1] = '\0';
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
> @@ -386,31 +386,34 @@ static void probe_kernel_image_config(void)
>  		/* test_bpf module for BPF tests */
>  		"CONFIG_TEST_BPF",
>  	};
> +	char *values[ARRAY_SIZE(options)] = { };
>  	char *value, *buf = NULL;
>  	struct utsname utsn;
>  	char path[PATH_MAX];
>  	size_t i, n;
>  	ssize_t ret;
> -	FILE *fd;
> +	FILE *fd = NULL;
> +	bool is_pipe = false;
>  
>  	if (uname(&utsn))
> -		goto no_config;
> +		goto end_parse;
>  
>  	snprintf(path, sizeof(path), "/boot/config-%s", utsn.release);
>  
>  	fd = fopen(path, "r");
>  	if (!fd && errno == ENOENT) {
> -		/* Some distributions put the config file at /proc/config, give
> -		 * it a try.
> -		 * Sometimes it is also at /proc/config.gz but we do not try
> -		 * this one for now, it would require linking against libz.
> +		/* Some distributions build with CONFIG_IKCONFIG=y and put the
> +		 * config file at /proc/config.gz. We try to invoke an external
> +		 * gzip program to avoid linking to libz.
> +		 * Hide stderr to avoid interference with the JSON output.
>  		 */
> -		fd = fopen("/proc/config", "r");
> +		fd = popen("gunzip -c /proc/config.gz 2>/dev/null", "r");
> +		is_pipe = true;
>  	}
>  	if (!fd) {
>  		p_info("skipping kernel config, can't open file: %s",
>  		       strerror(errno));
> -		goto no_config;
> +		goto end_parse;
>  	}
>  	/* Sanity checks */
>  	ret = getline(&buf, &n, fd);
> @@ -418,27 +421,36 @@ static void probe_kernel_image_config(void)
>  	if (!buf || !ret) {
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
> +	}
> +
> +	while (get_kernel_config_option(fd, &buf, &n, &value)) {
> +		for (i = 0; i < ARRAY_SIZE(options); i++) {
> +			if (values[i] || strcmp(buf, options[i]))
> +				continue;
> +
> +			values[i] = strdup(value);
> +		}
> +	}
> +
> +end_parse:
> +	if (fd) {
> +		if (is_pipe) {
> +			if (pclose(fd))
> +				p_info("failed to read /proc/config.gz");
> +		} else
> +			fclose(fd);
>  	}
>  	free(buf);
>  
>  	for (i = 0; i < ARRAY_SIZE(options); i++) {
> -		value = get_kernel_config_option(fd, options[i]);
> -		print_kernel_option(options[i], value);
> -		free(value);
> +		print_kernel_option(options[i], values[i]);
> +		free(values[i]);
>  	}
> -	fclose(fd);
> -	return;
> -
> -no_config:
> -	for (i = 0; i < ARRAY_SIZE(options); i++)
> -		print_kernel_option(options[i], NULL);
>  }
>  
>  static bool probe_bpf_syscall(const char *define_prefix)
> -- 
> 2.22.0
> 
