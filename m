Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E1DE221674
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 22:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgGOUoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 16:44:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgGOUoL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 16:44:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD37C061755;
        Wed, 15 Jul 2020 13:44:10 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k71so3685651pje.0;
        Wed, 15 Jul 2020 13:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=b9wGmkyoU9s5dIOAj0k6t8DcKYUAHntZJnHE7gCVBcA=;
        b=VrRIXYaaGYQRUhjnzZUdAES35q+bkdSkH0eXl8wI4m2w4KkWvDCR46B7wgAB6ZGHvC
         3Yb5K6D45ODuMXfO0Egrz+FzKjMRMv7GcGZdXrwuSJurBQT/1fe0C1bmt2yuHxeCwnWU
         7weYp32nrMfgOTIVSsqBmxFFbk+Eb30cyL8AhqMt/XFH6TYEdgw1QTL3JQxa5Z/1coN8
         IDk95ZYN1VwbMLKcM5oPZ1j9Ph6GfoE+o9vkwMM8yMTaWBIU7YP97WeFLyxyFG/u1CGB
         L7fEJFujERsWtoycwGyuYg6lZf0AHkVdcpPuQZZdb92lAhvtcCQJDgBIMVKFxq0TZ98P
         WS9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=b9wGmkyoU9s5dIOAj0k6t8DcKYUAHntZJnHE7gCVBcA=;
        b=q+hftw5bs9pQC+8ws4pttvKa5/lp6l2saV7Gni99QLQ5kFv15NdZ9Q0FcZxFotBbRt
         PqpgF/DThL4AYTTYXUyIhsBgNIg1bfrTtDSsK3zmXwZ25NZHD3IDp3smvgE5MUlfZHlf
         0KfaBFASREQcEsIhQ3sq3USs8ImN6fQ4pjiDcgVmTQXSf/pG4bCi5IqdbrvzVFjBETnU
         ZoWPwx9B4ArTMJxdn/A6vVHJ1m3o3cZOiNtSfDwyWvP3stu+3rroTKT8pWyreB3tEpTo
         0ywH8+9WHrKzTYy7as2eTUK09DHAHIZHbrCDQx0m9cHNspoC0OaOp7pWnVuOYI696Cbu
         kUpA==
X-Gm-Message-State: AOAM531H6doFb6XgP8/WX4cGbRVKOwxurBAIL3YBYjgZ2okJGttsfn9V
        fGPe2hlVrUJY35sVRrWSioU=
X-Google-Smtp-Source: ABdhPJxX/VPbjWIO3ObZylsx0MWauG1RuAI/3nz7R7py4ut5zTM+/Rt6+Ecsyx+Uqli6bBXRqGVZJw==
X-Received: by 2002:a17:902:a60d:: with SMTP id u13mr1054443plq.46.1594845850378;
        Wed, 15 Jul 2020 13:44:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:96f0])
        by smtp.gmail.com with ESMTPSA id r16sm2860202pfh.64.2020.07.15.13.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 13:44:09 -0700 (PDT)
Date:   Wed, 15 Jul 2020 13:44:06 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/6] bpf: support attaching freplace programs
 to multiple attach points
Message-ID: <20200715204406.vt64vgvzsbr6kolm@ast-mbp.dhcp.thefacebook.com>
References: <159481853923.454654.12184603524310603480.stgit@toke.dk>
 <159481854255.454654.15065796817034016611.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <159481854255.454654.15065796817034016611.stgit@toke.dk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 03:09:02PM +0200, Toke Høiland-Jørgensen wrote:
>  
> +	if (tgt_prog_fd) {
> +		/* For now we only allow new targets for BPF_PROG_TYPE_EXT */
> +		if (prog->type != BPF_PROG_TYPE_EXT ||
> +		    !btf_id) {
> +			err = -EINVAL;
> +			goto out_put_prog;
> +		}
> +		tgt_prog = bpf_prog_get(tgt_prog_fd);
> +		if (IS_ERR(tgt_prog)) {
> +			err = PTR_ERR(tgt_prog);
> +			tgt_prog = NULL;
> +			goto out_put_prog;
> +		}
> +
> +	} else if (btf_id) {
> +		err = -EINVAL;
> +		goto out_put_prog;
> +	} else {
> +		btf_id = prog->aux->attach_btf_id;
> +		tgt_prog = prog->aux->linked_prog;
> +		if (tgt_prog)
> +			bpf_prog_inc(tgt_prog); /* we call bpf_prog_put() on link release */

so the first prog_load cmd will beholding the first target prog?
This is complete non starter.
You didn't mention such decision anywhere.
The first ext prog will attach to the first dispatcher xdp prog,
then that ext prog will multi attach to second dispatcher xdp prog and
the first dispatcher prog will live in the kernel forever.
That's not what we discussed back in April.

> +	}
> +	err = bpf_check_attach_target(NULL, prog, tgt_prog, btf_id,
> +				      &fmodel, &addr, NULL, NULL);

This is a second check for btf id match?
What's the point? The first one was done at load time.
When tgt_prog_fd/tgt_btf_id are zero there is no need to recheck.

I really hope I'm misreading these patches, because they look very raw.
