Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC01B720C
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 12:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbgDXKci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 06:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbgDXKch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 06:32:37 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A29C09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:32:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k13so10159224wrw.7
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 03:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FlSRg4R034VGkFyyrPRIqqiT+aUgDWYSvfqbtdlqGKk=;
        b=bgNTcnjAiirIp60isoSXfn3EdJKntRuuhnZgt8UCHZGKoKPqtSfcIMDwrHV/WtOgNx
         IBOmpKJh9XfADTrCtRc5/VfH57d03FeJgZhAR5k2chiBOoq4MzozERiebg8ZP+Ev02Xj
         NdosiSQVKbWe8Qeir+ADrv70PCEsF7xwvmlBtm/14aPjlVGvPOpt0vT6fJrds7GLhxmk
         olLh6r1a+8DzuW+rJD2QHbQCAHltKVXWqaCFyL0BDvbWdjAz6pgdgTklePSWzGWnBmcX
         Wb6hyIp2Oin1ituFAqQTR8vJz3iDUZ+cD1ktjwQhQ1oghG0H/bVu/yuruydP2+SCq/+w
         +85g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FlSRg4R034VGkFyyrPRIqqiT+aUgDWYSvfqbtdlqGKk=;
        b=kceJHkE5n6tEKU7JeUhqB7MciHYhQhuVkJsCvrIwIwkmjOXOhrfPzwggRuCq79wk09
         bTq7SIo5raxwT2fDo4B3cr7vNsJaxyBd6LkKFzfpp6HH8VSYtD11ZPq12mV6NYqELW4U
         zcpU1/R5QOW3zb4bdQy6X2sRuRF7zeRheacFH57/gfPj9V8Kpa0oG+XOxlvlNL8qdp0X
         peTP6eFiYp2ZJWCxI7nnOCC0KcdrHW+LJHXcpXY6Ku/3ANZ94dMCtYjZSdfifHa1XScj
         yBoy7LM89jxMXWKfkVy5P0miAASg9aHIVMC3fRWOyrl7aKQPiyOBqu9nKAzrm3YIcihR
         oKxg==
X-Gm-Message-State: AGi0PuZA0hee8MUBxLmlA00itcEw7XVQ4CLvuygfDJUaoE8OHBQr8UdX
        oBXPA3kHrwhqR/BdlsCkC+dwrA==
X-Google-Smtp-Source: APiQypJCxOwtkrCHrgHvVr5RUZzMxfZZXWWm92azNEv8l+V1C92xLEpikUxDtKXGuz/Zh1LPXEazzA==
X-Received: by 2002:adf:a345:: with SMTP id d5mr9788826wrb.23.1587724355782;
        Fri, 24 Apr 2020 03:32:35 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.185.129])
        by smtp.gmail.com with ESMTPSA id g74sm2284245wme.44.2020.04.24.03.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2020 03:32:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 08/10] bpftool: add bpf_link show and pin support
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com
References: <20200424053505.4111226-1-andriin@fb.com>
 <20200424053505.4111226-9-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <3a5f1d73-f9f5-a640-6f15-d5202549d467@isovalent.com>
Date:   Fri, 24 Apr 2020 11:32:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424053505.4111226-9-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Add `bpftool link show` and `bpftool link pin` commands.
> 
> Example plain output for `link show` (with showing pinned paths):
> 
> [vmuser@archvm bpf]$ sudo ~/local/linux/tools/bpf/bpftool/bpftool -f link
> 1: tracing  prog 12
>         prog_type tracing  attach_type fentry
>         pinned /sys/fs/bpf/my_test_link
>         pinned /sys/fs/bpf/my_test_link2
> 2: tracing  prog 13
>         prog_type tracing  attach_type fentry
> 3: tracing  prog 14
>         prog_type tracing  attach_type fentry
> 4: tracing  prog 15
>         prog_type tracing  attach_type fentry
> 5: tracing  prog 16
>         prog_type tracing  attach_type fentry
> 6: tracing  prog 17
>         prog_type tracing  attach_type fentry
> 7: raw_tracepoint  prog 21
>         tp 'sys_enter'
> 8: cgroup  prog 25
>         cgroup_id 584  attach_type egress
> 9: cgroup  prog 25
>         cgroup_id 599  attach_type egress
> 10: cgroup  prog 25
>         cgroup_id 614  attach_type egress
> 11: cgroup  prog 25
>         cgroup_id 629  attach_type egress
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/bpf/bpftool/common.c |   2 +
>  tools/bpf/bpftool/link.c   | 402 +++++++++++++++++++++++++++++++++++++
>  tools/bpf/bpftool/main.c   |   6 +-
>  tools/bpf/bpftool/main.h   |   5 +
>  4 files changed, 414 insertions(+), 1 deletion(-)
>  create mode 100644 tools/bpf/bpftool/link.c
> 
> diff --git a/tools/bpf/bpftool/common.c b/tools/bpf/bpftool/common.c
> index f2223dbdfb0a..c47bdc65de8e 100644
> --- a/tools/bpf/bpftool/common.c
> +++ b/tools/bpf/bpftool/common.c
> @@ -262,6 +262,8 @@ int get_fd_type(int fd)
>  		return BPF_OBJ_MAP;
>  	else if (strstr(buf, "bpf-prog"))
>  		return BPF_OBJ_PROG;
> +	else if (strstr(buf, "bpf-link"))
> +		return BPF_OBJ_LINK;
>  
>  	return BPF_OBJ_UNKNOWN;
>  }
> diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
> new file mode 100644
> index 000000000000..d5dcf9e46536
> --- /dev/null
> +++ b/tools/bpf/bpftool/link.c

[...]

> +
> +static int link_parse_fd(int *argc, char ***argv)
> +{
> +	int *fds = NULL;
> +	int nb_fds, fd;
> +
> +	fds = malloc(sizeof(int));
> +	if (!fds) {
> +		p_err("mem alloc failed");
> +		return -1;
> +	}
> +	nb_fds = link_parse_fds(argc, argv, &fds);
> +	if (nb_fds != 1) {
> +		if (nb_fds > 1) {
> +			p_err("several links match this handle");

Can this ever happen? "bpftool prog show" has this because "name" or
"tag" can match multiple programs. But "id" and "pinned" for link should
not, as far as I understand.

> +			while (nb_fds--)
> +				close(fds[nb_fds]);
> +		}
> +		fd = -1;
> +		goto exit_free;
> +	}
> +
> +	fd = fds[0];
> +exit_free:
> +	free(fds);
> +	return fd;
> +}
> +
> +static void
> +show_link_header_json(struct bpf_link_info *info, json_writer_t *wtr)
> +{
> +	jsonw_uint_field(wtr, "id", info->id);
> +	if (info->type < ARRAY_SIZE(link_type_name))
> +		jsonw_string_field(wtr, "type", link_type_name[info->type]);
> +	else
> +		jsonw_uint_field(wtr, "type", info->type);
> +
> +	jsonw_uint_field(json_wtr, "prog_id", info->prog_id);
> +}
> +
> +static int get_prog_info(int prog_id, struct bpf_prog_info *info)
> +{
> +	__u32 len = sizeof(*info);
> +	int err, prog_fd;
> +
> +	prog_fd = bpf_prog_get_fd_by_id(prog_id);
> +	if (prog_fd < 0)
> +		return prog_fd;
> +
> +	memset(info, 0, sizeof(*info));
> +	err = bpf_obj_get_info_by_fd(prog_fd, info, &len);
> +	if (err) {
> +		p_err("can't get prog info: %s", strerror(errno));
> +		close(prog_fd);
> +		return err;

Nit: you could "return err;" at the end of the function, and remove the
"close()" and "return" from this if block.

> +	}
> +
> +	close(prog_fd);
> +	return 0;
> +}
> +

[...]

> +
> +static int do_show_subset(int argc, char **argv)
> +{
> +	int *fds = NULL;
> +	int nb_fds, i;
> +	int err = -1;
> +
> +	fds = malloc(sizeof(int));
> +	if (!fds) {
> +		p_err("mem alloc failed");
> +		return -1;
> +	}
> +	nb_fds = link_parse_fds(&argc, &argv, &fds);
> +	if (nb_fds < 1)
> +		goto exit_free;
> +
> +	if (json_output && nb_fds > 1)
> +		jsonw_start_array(json_wtr);	/* root array */
> +	for (i = 0; i < nb_fds; i++) {
> +		err = do_show_link(fds[i]);
> +		if (err) {
> +			for (; i + 1 < nb_fds; i++)
> +				close(fds[i]);
> +			break;
> +		}
> +	}
> +	if (json_output && nb_fds > 1)
> +		jsonw_end_array(json_wtr);	/* root array */
> +
> +exit_free:
> +	free(fds);
> +	return err;
> +}
> +
> +static int do_show(int argc, char **argv)
> +{
> +	__u32 id = 0;
> +	int err;
> +	int fd;
> +
> +	if (show_pinned)
> +		build_pinned_obj_table(&link_table, BPF_OBJ_LINK);
> +
> +	if (argc == 2)
> +		return do_show_subset(argc, argv);

I understand the "_subset" aspect was taken from prog.c. But it was
added there (ec2025095cf6) because "bpftool prog show <name|tag>" can
match several programs, and the array with fds would be reallocated as
required while parsing names/tags.

I do not think that by restricting the selection on "id" or "pinned",
you can get more than one link at a time. So we can probably avoid
juggling with fd arrays for link_parse_fd() / link_parse_fds() and show
just the single relevant link.
