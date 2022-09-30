Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010FE5F0FE6
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 18:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232135AbiI3Q1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 12:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbiI3Q1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 12:27:05 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DEA14E77B
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:27:03 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id s14so7667992wro.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 09:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6G1w7rleyZqUvL2CNwMdqEOX+vKWh0uG8GbS6llGVCg=;
        b=bQEqCIzF1tPLK+ONdPDtTEQGoUqBYenM2qd7Kp+iHWeXN9ECqy+1tl4llEWmubzhNO
         tOJkMHGvUZEfh66+jJvQIaukdumR+IxnIeXGB8qL2j36iVnIv7JV17HZxxF5w462hTgz
         y6F6itSGxcUHEHxrk8CknVPXInKcAPyp9qJwCwf+/ea8KXGqTWYsqLNIfJov+OdKaV1w
         PtQRkE/B8TFYmaqnjOSnj0TSdy+kqEH03bjahcDGwMvYaCGHRzLwc+aa9kEnmjVUPEfo
         ijet0UafijqcXo8tpC8+1JUlgMQ+OrIV/ki/koVdLmh+zpnvey0FjtWSdmPkDc2Of7zw
         Bklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6G1w7rleyZqUvL2CNwMdqEOX+vKWh0uG8GbS6llGVCg=;
        b=N9uZP/SbkSDncFjmIoQ63/yMq9qNTAspUanQM6lGQAn1qCSiwuNoae6AqPJKeu/RqA
         V+hJpKj4Vt75vx7lzTRBxToWIpq36FlsW1P2h9boDoi8s5CoXHT9Qn+BJlc6TEQme9hB
         k1WfVWAJHlqC1Gqbt1+w56xS5T7qMe33UB44n81HCYV8CLUVbvYKTL5KmisO7vqLEgn6
         /OYnxasvkypuRSqM/POGuvQhtOvqZ/lKg9jT7R9ysPhGhLr5K5RuHpQZuNOJ6CKvkuav
         AwmHoRrvPpbVXZ4mM/p8C0tgmrZkwTTG/1TqkODxGN23tkuSXRUHfnoN4a/+3Whylg4V
         GvAA==
X-Gm-Message-State: ACrzQf1OGq6Mfg657+ai+hmDe2wVy16U1KViQ07aJ8PnOCVEYQTFpF/1
        GFT9y9XAGODEtDN8+HPYIYMqbA==
X-Google-Smtp-Source: AMsMyM6ayqcfd0Q//6v/OwWOkLbzIAl3QtqboHlsDLG6xcMHCS0KuWtutlxTEtXeKef4jt11I9RX5w==
X-Received: by 2002:adf:9cd0:0:b0:22a:7cea:d3c3 with SMTP id h16-20020adf9cd0000000b0022a7cead3c3mr6771605wre.196.1664555221581;
        Fri, 30 Sep 2022 09:27:01 -0700 (PDT)
Received: from [192.168.178.32] ([51.155.200.13])
        by smtp.gmail.com with ESMTPSA id bd16-20020a05600c1f1000b003a4efb794d7sm2519778wmb.36.2022.09.30.09.26.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 09:26:59 -0700 (PDT)
Message-ID: <83307f48-bef0-bff8-e3b5-f8df7a592678@isovalent.com>
Date:   Fri, 30 Sep 2022 17:26:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [bpf-next v7 1/3] bpftool: Add auto_attach for bpf prog
 load|loadall
Content-Language: en-GB
To:     Wang Yufen <wangyufen@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
References: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
From:   Quentin Monnet <quentin@isovalent.com>
In-Reply-To: <1664277676-2228-1-git-send-email-wangyufen@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue Sep 27 2022 12:21:14 GMT+0100 ~ Wang Yufen <wangyufen@huawei.com>
> Add auto_attach optional to support one-step load-attach-pin_link.

Nit: Now "autoattach" instead of "auto_attach". Same in commit title.

> 
> For example,
>    $ bpftool prog loadall test.o /sys/fs/bpf/test autoattach
> 
>    $ bpftool link
>    26: tracing  name test1  tag f0da7d0058c00236  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 55B  memlock 4096B  map_ids 3
>    	btf_id 55
>    28: kprobe  name test3  tag 002ef1bef0723833  gpl
>    	loaded_at 2022-09-09T21:39:49+0800  uid 0
>    	xlated 88B  jited 56B  memlock 4096B  map_ids 3
>    	btf_id 55
>    57: tracepoint  name oncpu  tag 7aa55dfbdcb78941  gpl
>    	loaded_at 2022-09-09T21:41:32+0800  uid 0
>    	xlated 456B  jited 265B  memlock 4096B  map_ids 17,13,14,15
>    	btf_id 82
> 
>    $ bpftool link
>    1: tracing  prog 26
>    	prog_type tracing  attach_type trace_fentry
>    3: perf_event  prog 28
>    10: perf_event  prog 57
> 
> The autoattach optional can support tracepoints, k(ret)probes,
> u(ret)probes.
> 
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
> ---
> v6 -> v7: add info msg print and update doc for the skip program
> v5 -> v6: skip the programs not supporting auto-attach,
> 	  and change optional name from "auto_attach" to "autoattach"
> v4 -> v5: some formatting nits of doc
> v3 -> v4: rename functions, update doc, bash and do_help()
> v2 -> v3: switch to extend prog load command instead of extend perf
> v2: https://patchwork.kernel.org/project/netdevbpf/patch/20220824033837.458197-1-weiyongjun1@huawei.com/
> v1: https://patchwork.kernel.org/project/netdevbpf/patch/20220816151725.153343-1-weiyongjun1@huawei.com/
>  tools/bpf/bpftool/prog.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 79 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index c81362a..84eced8 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1453,6 +1453,72 @@ static int do_run(int argc, char **argv)
>  	return ret;
>  }
>  
> +static int
> +auto_attach_program(struct bpf_program *prog, const char *path)
> +{
> +	struct bpf_link *link;
> +	int err;
> +
> +	link = bpf_program__attach(prog);
> +	if (!link)
> +		return -1;
> +
> +	err = bpf_link__pin(link, path);
> +	if (err) {
> +		bpf_link__destroy(link);
> +		return err;
> +	}
> +	return 0;
> +}
> +
> +static int pathname_concat(const char *path, const char *name, char *buf)
> +{
> +	int len;
> +
> +	len = snprintf(buf, PATH_MAX, "%s/%s", path, name);
> +	if (len < 0)
> +		return -EINVAL;
> +	if (len >= PATH_MAX)
> +		return -ENAMETOOLONG;
> +
> +	return 0;
> +}
> +
> +static int
> +auto_attach_programs(struct bpf_object *obj, const char *path)
> +{
> +	struct bpf_program *prog;
> +	char buf[PATH_MAX];
> +	int err;
> +
> +	bpf_object__for_each_program(prog, obj) {
> +		err = pathname_concat(path, bpf_program__name(prog), buf);
> +		if (err)
> +			goto err_unpin_programs;
> +
> +		err = auto_attach_program(prog, buf);
> +		if (!err)
> +			continue;
> +		if (errno == EOPNOTSUPP)
> +			p_info("Program %s does not support autoattach",
> +			       bpf_program__name(prog));
> +		else
> +			goto err_unpin_programs
With this code, if auto-attach fails, then we skip this program and move
on to the next. That's an improvement, but in that case the program
won't remain loaded in the kernel after bpftool exits. My suggestion in
my previous message (sorry if it was not clear) was to fall back to
regular pinning in that case (bpf_obj_pin()), along with the p_info()
message, so we can have the program pinned but not attached and let the
user know. If regular pinning fails as well, then we should unpin all
and error out, for consistency with bpf_object__pin_programs().

And in that case, the (errno == EOPNOTSUPP) with fallback to regular
pinning could maybe be moved into auto_attach_program(), so that
auto-attaching single programs can use the fallback too?

Thanks,
Quentin
