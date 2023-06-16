Return-Path: <netdev+bounces-11290-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 94F137326C1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 07:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 76D3E1C20F64
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 05:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63772EA4;
	Fri, 16 Jun 2023 05:47:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AFAC7C;
	Fri, 16 Jun 2023 05:47:02 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732132702;
	Thu, 15 Jun 2023 22:47:00 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-56d304e5f83so4177257b3.2;
        Thu, 15 Jun 2023 22:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686894419; x=1689486419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3t5xJL5naOb0QAJeCuO0jgaS0Ma9+Gw0t+NpBr7LyWI=;
        b=L8nZ/926OypLC+a3K0MXbnUYNNcDpj1/aajUfQOUQ9vMGxWz/F8+Jx4k6O17zHpUSF
         5fCEv+05rTXAcKE0ifDMg9qwyDiSX7J5liVSlGjDX5J3fL5E6zhgSWkvU34gVDzHcnF8
         EC7KVuufmccRfDeAlScXnlk/6XlCpxilDA9xKoB2L04KSp0xKsqJseNA9PST9ylYj9tU
         8wl/w6GRbZKpBXR9YfbLZfGiBWiFlY850jFjkbvPELw3+JTiqCLvvF/tEmObIfoc8K4b
         XEDiebpfSwzyDKhB8JRfGvmnXQMYRgv1f2aMoVT5/4BIvLjigLLal7C35KvozbY5M+ei
         Jy0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686894419; x=1689486419;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3t5xJL5naOb0QAJeCuO0jgaS0Ma9+Gw0t+NpBr7LyWI=;
        b=CRORvRghBiBGXSySxTJVsKqarir3DGZv5JD0EX//uT3hgpw2qrMe3tApnIw0/bqNxh
         0aG08zgeKpXDIhRRX70SoW09vTQ9ERAjwQVszJPvd67v/E2ym8KURp9AIoEk1pL/4B7y
         Ham5SHLsHpb+aKAWkWcNRRI9z08oRFTcT/wrlOtrSMUYO/YjuN8jaf6vpO5rHwbeOnj5
         +4j9wwUfa834XxelAOWDiD1r14Q1o1BNmwpfPF6GsfF9f4BJ/jIqKBrEAfQjpkQ2kqDe
         e6IK4VJPLBseofY0+9+OCL7u7ZZRn0HjHB/JNXpjo5ZOUm0QaAFBxvlJNtNQIDeTfYg1
         XvSA==
X-Gm-Message-State: AC+VfDyhmA8+jRBh8zFMv0IPJmWgeD86k+RNsf0o3fast2/omFKteDbn
	MPzHgQG5sO5n8A83gygyVRI=
X-Google-Smtp-Source: ACHHUZ7zYzpk9FJo31U1GDMbhBVjQtQCSiX18EHj1Dj7U8V235a4E4y0zy5oDhw02aXtOpi1gDNnYA==
X-Received: by 2002:a0d:e256:0:b0:56c:e70b:b741 with SMTP id l83-20020a0de256000000b0056ce70bb741mr836322ywe.20.1686894419613;
        Thu, 15 Jun 2023 22:46:59 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:85ec:4914:169d:547? ([2600:1700:6cf8:1240:85ec:4914:169d:547])
        by smtp.gmail.com with ESMTPSA id r126-20020a815d84000000b00565eb8af1fesm2405924ywb.132.2023.06.15.22.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jun 2023 22:46:59 -0700 (PDT)
Message-ID: <1fb38d17-619d-4cd9-30e4-624d2ee21a2b@gmail.com>
Date: Thu, 15 Jun 2023 22:46:57 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC bpf-next 3/7] bpf: implement devtx hook points
Content-Language: en-US
To: Stanislav Fomichev <sdf@google.com>, bpf@vger.kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
 kpsingh@kernel.org, haoluo@google.com, jolsa@kernel.org,
 netdev@vger.kernel.org
References: <20230612172307.3923165-1-sdf@google.com>
 <20230612172307.3923165-4-sdf@google.com>
From: Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <20230612172307.3923165-4-sdf@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/12/23 10:23, Stanislav Fomichev wrote:
..... cut .....
> +
> +__diag_push();
> +__diag_ignore_all("-Wmissing-prototypes",
> +		  "Global functions as their definitions will be in vmlinux BTF");
> +
> +/**
> + * bpf_devtx_sb_attach - Attach devtx 'packet submit' program
> + * @ifindex: netdev interface index.
> + * @prog_fd: BPF program file descriptor.
> + *
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_devtx_sb_attach(int ifindex, int prog_fd)
> +{
> +	struct net_device *netdev;
> +	int ret;
> +
> +	netdev = dev_get_by_index(current->nsproxy->net_ns, ifindex);
> +	if (!netdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&devtx_attach_lock);
> +	ret = __bpf_devtx_attach(netdev, prog_fd, "devtx_sb", &netdev->devtx_sb);
> +	mutex_unlock(&devtx_attach_lock);
> +
> +	dev_put(netdev);
> +
> +	return ret;
> +}

How about adding another detach kfunc instead of overloading
this one? It is easier to understand.

> +
> +/**
> + * bpf_devtx_cp_attach - Attach devtx 'packet complete' program
> + * @ifindex: netdev interface index.
> + * @prog_fd: BPF program file descriptor.
> + *
> + * Return:
> + * * Returns 0 on success or ``-errno`` on error.
> + */
> +__bpf_kfunc int bpf_devtx_cp_attach(int ifindex, int prog_fd)
> +{
> +	struct net_device *netdev;
> +	int ret;
> +
> +	netdev = dev_get_by_index(current->nsproxy->net_ns, ifindex);
> +	if (!netdev)
> +		return -EINVAL;
> +
> +	mutex_lock(&devtx_attach_lock);
> +	ret = __bpf_devtx_attach(netdev, prog_fd, "devtx_cp", &netdev->devtx_cp);
> +	mutex_unlock(&devtx_attach_lock);
> +
> +	dev_put(netdev);
> +
> +	return ret;
> +}
> +
> +__diag_pop();
> +
> +bool is_devtx_kfunc(u32 kfunc_id)
> +{
> +	return !!btf_id_set8_contains(&bpf_devtx_hook_ids, kfunc_id);
> +}
> +
> +void devtx_shutdown(struct net_device *netdev)
> +{
> +	mutex_lock(&devtx_attach_lock);
> +	__bpf_devtx_detach(netdev, &netdev->devtx_sb);
> +	__bpf_devtx_detach(netdev, &netdev->devtx_cp);
> +	mutex_unlock(&devtx_attach_lock);
> +}
> +
> +BTF_SET8_START(bpf_devtx_syscall_kfunc_ids)
> +BTF_ID_FLAGS(func, bpf_devtx_sb_attach)
> +BTF_ID_FLAGS(func, bpf_devtx_cp_attach)
> +BTF_SET8_END(bpf_devtx_syscall_kfunc_ids)
> +
> +static const struct btf_kfunc_id_set bpf_devtx_syscall_kfunc_set = {
> +	.owner = THIS_MODULE,
> +	.set   = &bpf_devtx_syscall_kfunc_ids,
> +};
> +
> +static int __init devtx_init(void)
> +{
> +	int ret;
> +
> +	ret = register_btf_fmodret_id_set(&bpf_devtx_hook_set);
> +	if (ret) {
> +		pr_warn("failed to register devtx hooks: %d", ret);
> +		return ret;
> +	}
> +
> +	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SYSCALL, &bpf_devtx_syscall_kfunc_set);
> +	if (ret) {
> +		pr_warn("failed to register syscall kfuncs: %d", ret);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +late_initcall(devtx_init);

