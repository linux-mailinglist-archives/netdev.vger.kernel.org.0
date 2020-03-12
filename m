Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E673F1838D1
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCLSjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:39:21 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43084 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgCLSjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:39:21 -0400
Received: by mail-wr1-f67.google.com with SMTP id b2so2598666wrj.10
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y0ZCWlS3yLmJMb+ofnT38Ty+2TiaE9d36FZc9DTR+KQ=;
        b=f1ehBLAMmur073GBWLUKYN9ejmR+BhlHD5gAz3HPYBwxLb28vay05g/F00Oa9TQ9Zi
         lSr9CCmkVJ8iZW8XTQjW3rJAFPRWAtY5Lw/Hzrr0gxuuUaC1vjCVKpUBr2anqufol3jM
         MfN/7Sfq5ogdDydXvTFjZneNfHUpQJeSc3baVt2BP8tG+88bNhhwyfFMWJlLYsI6x08P
         gthjfMKHbpHy0XcMm3JMWIgDUNGGqF0/haKUjROv+78dKezFLonFWSTO5fTCOSyC3y2y
         jZrSXVZnPEa3Fn5HbFfhs6iptggG7nIzwuMr4qtskVxBFhw1PO5FdcLPBLJwVKXJ31Ca
         qepQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y0ZCWlS3yLmJMb+ofnT38Ty+2TiaE9d36FZc9DTR+KQ=;
        b=J1AYkO32mfSwmN9llxYaOiKqhpkJoX3MZO0EG57+8mZYfU7E3HWWcY7Wq6d05cIjRI
         ZyqgYI8Uc8owlKtSZwtJA2iwhOlOHZu2pQnRDKBRXGA25qQWt+QMm2saFCD4UI/9ieNM
         qPPKEDFZIb+peiSaipaxmdDCT1RtzAibZcKsvV1KiPBtMHsd/O+jrZvR6YDgOcNuL+lh
         mbvF0bwuxgLB4LauYnwvIhkuwuvx55hDo/NOnNE2d2UQpR8TvrkNfPmWW7Nzg3H5ZTio
         Q7WqhBwpDcohNEv/KJVa3NJlh/4agSzWtA43cU/01xLb7HmLmVvjNR6fxF7I1jxiKyD9
         TRtw==
X-Gm-Message-State: ANhLgQ2iX60NKCIcSXhRoke2zO/sMAKNZKaqveQiJLDi9OSzS2MInYkr
        s5krEuOz/D2mMYfsUAviDOaO0SS7/+s=
X-Google-Smtp-Source: ADFU+vuoDBq0mANVI/ETrZ1VuSvWqY9q/xSZ5wMjyGZWU47Zg+/2quR3tLVvRE8N8khWfHLN7LfJfA==
X-Received: by 2002:adf:b317:: with SMTP id j23mr12440570wrd.413.1584038359099;
        Thu, 12 Mar 2020 11:39:19 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id 9sm13518165wmo.38.2020.03.12.11.39.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 11:39:18 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/2] tools: bpftool: allow all prog/map handles
 for pinning objects
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20200312182555.945-1-quentin@isovalent.com>
 <20200312182555.945-2-quentin@isovalent.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <c1e31b68-203c-9cc8-77fa-f65f9fac97f0@isovalent.com>
Date:   Thu, 12 Mar 2020 18:39:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312182555.945-2-quentin@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-12 18:25 UTC+0000 ~ Quentin Monnet <quentin@isovalent.com>
> Documentation and interactive help for bpftool have always explained
> that the regular handles for programs (id|name|tag|pinned) and maps
> (id|name|pinned) can be passed to the utility when attempting to pin
> objects (bpftool prog pin PROG / bpftool map pin MAP).
> 
> THIS IS A LIE!! The tool actually accepts only ids, as the parsing is
> done in do_pin_any() in common.c instead of reusing the parsing
> functions that have long been generic for program and map handles.
> 
> Instead of fixing the doc, fix the code. It is trivial to reuse the
> generic parsing, and to simplify do_pin_any() in the process.
> 
> Do not accept to pin multiple objects at the same time with
> prog_parse_fds() or map_parse_fds() (this would require a more complex
> syntax for passing multiple sysfs paths and validating that they
> correspond to the number of e.g. programs we find for a given name or
> tag).
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/common.c | 39 +++++---------------------------------
>  tools/bpf/bpftool/main.h   |  2 +-
>  tools/bpf/bpftool/map.c    |  2 +-
>  tools/bpf/bpftool/prog.c   |  2 +-
>  4 files changed, 8 insertions(+), 37 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index b75b8ec5469c..92e51a62bd72 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -211,44 +211,15 @@ int do_pin_fd(int fd, const char *name)
>  	return err;
>  }
>  
> -int do_pin_any(int argc, char **argv, int (*get_fd_by_id)(__u32))
> +int do_pin_any(int argc, char **argv, int (*get_fd)(int *, char ***))
>  {
> -	unsigned int id;
> -	char *endptr;
> -	int err;
>  	int fd;
>  
> -	if (argc < 3) {
> -		p_err("too few arguments, id ID and FILE path is required");
> -		return -1;
> -	} else if (argc > 3) {
> -		p_err("too many arguments");
> -		return -1;
> -	}
> -
> -	if (!is_prefix(*argv, "id")) {
> -		p_err("expected 'id' got %s", *argv);
> -		return -1;
> -	}
> -	NEXT_ARG();
> -
> -	id = strtoul(*argv, &endptr, 0);
> -	if (*endptr) {
> -		p_err("can't parse %s as ID", *argv);
> -		return -1;
> -	}
> -	NEXT_ARG();
> -
> -	fd = get_fd_by_id(id);
> -	if (fd < 0) {
> -		p_err("can't open object by id (%u): %s", id, strerror(errno));
> -		return -1;
> -	}
> -
> -	err = do_pin_fd(fd, *argv);
> +	fd = get_fd(&argc, &argv);
> +	if (fd < 0)
> +		return fd;
>  
> -	close(fd);
> -	return err;
> +	return do_pin_fd(fd, *argv);

Looks like someone trimmed too much and forgot to close his fd. Will
send v2.

>  }
>  
