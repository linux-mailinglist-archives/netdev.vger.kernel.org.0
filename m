Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4AC167BFD
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbgBUL2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:28:09 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55240 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgBUL2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 06:28:08 -0500
Received: by mail-wm1-f67.google.com with SMTP id n3so1375463wmk.4
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 03:28:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XfJAkw0oKSRIfu+CzP7ADRPQK+3Hycv3Z524tdVT02I=;
        b=sA4eFuwdRasTPPOjjTh5Nea+GJ93zj95dsLaobA43VzJnKjvtrDnHwEzCGu3taiFGX
         jrPWRN5ZFzqg6KhWyCwQfN97vID3Mqjwt5/H8ub/6qBFykUp5DpSjTJsG5IBwcQzGBSI
         wBwqWjq1WabePKuDQS/FMyyfFubKK2O2XlSlYm8H6cWPuSO4lxIXH6jegWrzKJG/RHUn
         pZPriThbpDrb3tXg8u7X9180HsYO9gxVk2u6vRQheaFLOCUhvyXgGbUo9lJ0WSd2ETyw
         hLzcnvxr6vuiRik+nLfZFcCuR85tyun08tWSN6k8QNCmyevV1X/F8cYPFFOmke2ZBVTG
         9Cjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XfJAkw0oKSRIfu+CzP7ADRPQK+3Hycv3Z524tdVT02I=;
        b=hTIwWSWroeNSXnorJg9WO2sfqD2mHHriEA4GQS0x3XU6T1qhgEPyKCxFFeYdCLA2Qk
         ckpFiN47e2KcsN3NxAdiTNnZ23jyyR3H9FCZR9VntjuzWgia6FT1rM8b1DYw9+x9tyLE
         ugzjdE1dOOyq57JstGRJsDs5/W3m7ulRSRnvOM+Otksrf01YUQYdplz9PycTe50la/Bd
         KbZpQMl651TA3mRiUcy0uO96i0IaGV2poAPPjRSs0Phtn6Lx4d4isbuZ5bIdDEo9cFjy
         MO50oFRq1P8yJ19Z67c9dzivXdW8zZ4bjt60fiJ4GSKgv7CWxqnn4TMfofgTamkrLvpf
         A0Lw==
X-Gm-Message-State: APjAAAW3GgbVHeBbVzwYn8V/w//4h3y+F+r3udBYCYcT+98wy3RfKXHQ
        kO/8ignx0zG0wQ1+XNIbMW2tWg==
X-Google-Smtp-Source: APXvYqxt7KQwWZYBGLDAAAOpntcSKgwBxQmYrfFYrpTbwf50CqUQqRrQQBHZ11kHaQe0YllhJKklvQ==
X-Received: by 2002:a05:600c:4105:: with SMTP id j5mr3386773wmi.28.1582284486438;
        Fri, 21 Feb 2020 03:28:06 -0800 (PST)
Received: from [192.168.1.23] ([91.143.66.155])
        by smtp.gmail.com with ESMTPSA id a13sm3591025wrp.93.2020.02.21.03.28.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 03:28:05 -0800 (PST)
Subject: Re: [PATCH bpf-next v2 2/5] bpftool: Make probes which emit dmesg
 warnings optional
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200221031702.25292-1-mrostecki@opensuse.org>
 <20200221031702.25292-3-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <7ab56bb6-0ddb-2c3c-d116-fc01feddba5e@isovalent.com>
Date:   Fri, 21 Feb 2020 11:28:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200221031702.25292-3-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-21 04:16 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Probes related to bpf_probe_write_user and bpf_trace_printk helpers emit
> dmesg warnings which might be confusing for people running bpftool on
> production environments. This change filters them out by default and
> introduces the new positional argument "full" which enables all
> available probes.
> 
> Signed-off-by: Michal Rostecki <mrostecki@opensuse.org>
> ---
>   tools/bpf/bpftool/feature.c | 80 +++++++++++++++++++++++++++++++++----
>   1 file changed, 73 insertions(+), 7 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/feature.c b/tools/bpf/bpftool/feature.c
> index 345e4a2b4f53..0731804b8160 100644
> --- a/tools/bpf/bpftool/feature.c
> +++ b/tools/bpf/bpftool/feature.c
> @@ -3,6 +3,7 @@
>   
>   #include <ctype.h>
>   #include <errno.h>
> +#include <regex.h>
>   #include <string.h>
>   #include <unistd.h>
>   #include <net/if.h>
> @@ -22,6 +23,9 @@
>   # define PROC_SUPER_MAGIC	0x9fa0
>   #endif
>   
> +/* Regex pattern for filtering out probes which emit dmesg warnings */
> +#define FILTER_OUT_PATTERN "(trace|write_user)"

"trace" sounds too generic. If filters are applied again to prog and map 
types in the future (as you had in v1), this would catch tracepoint and 
raw_tracepoint program types and stack_trace map type. Or if new helpers 
with "trace" in their name are added, we skip them too. Can we use 
something more specific, probably "trace_printk"?

> +
>   enum probe_component {
>   	COMPONENT_UNSPEC,
>   	COMPONENT_KERNEL,
> @@ -57,6 +61,35 @@ static void uppercase(char *str, size_t len)
>   		str[i] = toupper(str[i]);
>   }
>   
> +/* Filtering utility functions */
> +
> +static bool
> +check_filters(const char *name, regex_t *filter_out)
> +{
> +	char err_buf[100];
> +	int ret;
> +
> +	/* Do not probe if filter_out was defined and string matches against the
> +	 * pattern.
> +	 */
> +	if (filter_out) {
> +		ret = regexec(filter_out, name, 0, NULL, 0);
> +		switch (ret) {
> +		case 0:
> +			return false;
> +		case REG_NOMATCH:
> +			break;
> +		default:
> +			regerror(ret, filter_out, err_buf, ARRAY_SIZE(err_buf));
> +			p_err("could not match regex: %s", err_buf);
> +			free(filter_out);
> +			exit(1);
> +		}
> +	}
> +
> +	return true;
> +}
> +
>   /* Printing utility functions */
>   
>   static void
> @@ -515,7 +548,8 @@ probe_map_type(enum bpf_map_type map_type, const char *define_prefix,
>   
>   static void
>   probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
> -			   const char *define_prefix, __u32 ifindex)
> +			   const char *define_prefix, regex_t *filter_out,
> +			   __u32 ifindex)
>   {
>   	const char *ptype_name = prog_type_name[prog_type];
>   	char feat_name[128];
> @@ -542,6 +576,9 @@ probe_helpers_for_progtype(enum bpf_prog_type prog_type, bool supported_type,
>   	}
>   
>   	for (id = 1; id < ARRAY_SIZE(helper_name); id++) {
> +		if (!check_filters(helper_name[id], filter_out))
> +			continue;
> +
>   		if (!supported_type)
>   			res = false;
>   		else
> @@ -634,7 +671,8 @@ section_program_types(bool *supported_types, const char *define_prefix,
>   			    define_prefix);
>   
>   	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
> -		probe_prog_type(i, supported_types, define_prefix, ifindex);
> +		probe_prog_type(i, supported_types, define_prefix,
> +				ifindex);

Splitting the line here is not desirable, probably some leftover after 
rolling back on changes?

>   
>   	print_end_section();
>   }
> @@ -655,7 +693,8 @@ static void section_map_types(const char *define_prefix, __u32 ifindex)
>   }
>   
>   static void
> -section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
> +section_helpers(bool *supported_types, const char *define_prefix,
> +		regex_t *filter_out, __u32 ifindex)
>   {
>   	unsigned int i;
>   
> @@ -681,7 +720,7 @@ section_helpers(bool *supported_types, const char *define_prefix, __u32 ifindex)
>   		       define_prefix);
>   	for (i = BPF_PROG_TYPE_UNSPEC + 1; i < ARRAY_SIZE(prog_type_name); i++)
>   		probe_helpers_for_progtype(i, supported_types[i],
> -					   define_prefix, ifindex);
> +					   define_prefix, filter_out, ifindex);
>   
>   	print_end_section();
>   }
> @@ -701,8 +740,13 @@ static int do_probe(int argc, char **argv)
>   	enum probe_component target = COMPONENT_UNSPEC;
>   	const char *define_prefix = NULL;
>   	bool supported_types[128] = {};
> +	regex_t *filter_out = NULL;
> +	bool full_mode = false;
> +	char regerror_buf[100];
>   	__u32 ifindex = 0;
>   	char *ifname;
> +	int reg_ret;
> +	int ret = 0;
>   
>   	/* Detection assumes user has sufficient privileges (CAP_SYS_ADMIN).
>   	 * Let's approximate, and restrict usage to root user only.
> @@ -740,6 +784,9 @@ static int do_probe(int argc, char **argv)
>   				      strerror(errno));
>   				return -1;
>   			}
> +		} else if (is_prefix(*argv, "full")) {
> +			full_mode = true;
> +			NEXT_ARG();
>   		} else if (is_prefix(*argv, "macros") && !define_prefix) {
>   			define_prefix = "";
>   			NEXT_ARG();
> @@ -764,6 +811,22 @@ static int do_probe(int argc, char **argv)
>   		}
>   	}
>   
> +	/* If full mode is not acivated, filter out probes which emit dmesg

Typo: acivated

> +	 * messages.
> +	 */
> +	if (!full_mode) {
> +		filter_out = malloc(sizeof(regex_t));

filter_out is not free()-d on the different error paths in the function. 
You would probably have to `goto cleanup` from several other locations.

> +		reg_ret = regcomp(filter_out, FILTER_OUT_PATTERN, REG_EXTENDED);
> +		if (reg_ret) {
> +			regerror(reg_ret, filter_out, regerror_buf,
> +				 ARRAY_SIZE(regerror_buf));
> +			p_err("could not compile regex: %s",
> +			      regerror_buf);
> +			ret = -1;
> +			goto cleanup;
> +		}
> +	}
> +
>   	if (json_output) {
>   		define_prefix = NULL;
>   		jsonw_start_object(json_wtr);
> @@ -775,7 +838,7 @@ static int do_probe(int argc, char **argv)
>   		goto exit_close_json;
>   	section_program_types(supported_types, define_prefix, ifindex);
>   	section_map_types(define_prefix, ifindex);
> -	section_helpers(supported_types, define_prefix, ifindex);
> +	section_helpers(supported_types, define_prefix, filter_out, ifindex);
>   	section_misc(define_prefix, ifindex);
>   
>   exit_close_json:
> @@ -783,7 +846,10 @@ static int do_probe(int argc, char **argv)
>   		/* End root object */
>   		jsonw_end_object(json_wtr);
>   
> -	return 0;
> +cleanup:
> +	free(filter_out);
> +
> +	return ret;
>   }
>   
>   static int do_help(int argc, char **argv)
> @@ -794,7 +860,7 @@ static int do_help(int argc, char **argv)
>   	}
>   
>   	fprintf(stderr,
> -		"Usage: %s %s probe [COMPONENT] [macros [prefix PREFIX]]\n"
> +		"Usage: %s %s probe [COMPONENT] [full] [macros [prefix PREFIX]]\n"
>   		"       %s %s help\n"
>   		"\n"
>   		"       COMPONENT := { kernel | dev NAME }\n"
> 

Thanks for the patch! While I understand you want to keep the changes 
you have done to use regex, I do not really think they bring much in 
this version of the patch. As we only want to filter out two specific 
helpers, it seems to me that it would be much simpler to just compare 
helper names instead of introducing regular expressions that are not 
used otherwise. What do you think?

Quentin
