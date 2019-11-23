Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A091107CA1
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 04:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfKWDSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 22:18:32 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43278 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWDSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 22:18:32 -0500
Received: by mail-pg1-f195.google.com with SMTP id b1so4293705pgq.10;
        Fri, 22 Nov 2019 19:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EIlvVjEEu8LyfLcUtSvicFXJ3kCPpSv78bK99idq52o=;
        b=M4cRgRKF/sS6goR26Zy1xfAtNIVa6Tsf3Bc/yj12Rmd48/hZmjHno1e/pm9a2iNd0i
         /0tMxYms/hW4OFNi7mEbEQTRCxjtfMh03W62VQyQAC5Ng6UzQcwS5IQkb2SYrFytuMlP
         my4VylxrWYvbNayEpQeBmID9J+KAkKcRfAqD08xDu/d5Xx6G0/HUGg07vgtRdUo9RC68
         q4alNuLZKcaYDxdE7dXaqA/ujFwlMzjN9aYzIR1WURA9TxgnF6ywvXI5Nd6+az9VARBq
         qr/OMfWBoA/WXC5k3a1lm+p9zZ35WAq6GP6h7tOOpEq5O9Ju4cIe4tt4fq4hjFSYrZbf
         I8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EIlvVjEEu8LyfLcUtSvicFXJ3kCPpSv78bK99idq52o=;
        b=Ahjel0gNXsdMo5fRXZNS61pkcu1V1sE7aSXdOZsV2PEElcqngEn2IGA1+Kyf2soUv1
         72OenHDk9gMn2rBkm75H4g1vxhthh2GHU/BtYcW40NZFDM58OA7FRb49Hp3i4QI2MDSX
         PgbEtBKGPTmTExwMK6tlx9iSk8/hTvIn/S8TphTynJ+/IMkbNj3LfPOGGB8tKPvW4sRo
         ynzqasdMxONWjXJ9IMFrgNqJhkNuJDbJzTFha5fiNfaDXoLfEvP6s89J0x8l4YZMK/WN
         LUca7sTybGx0m0zf6KdLDJDClgducYtZpAdDJZ38hMM2t6gAsK7L0gqsOW+4gc9ct+Bv
         tK8A==
X-Gm-Message-State: APjAAAW+N0Qydm47jtMUODNiK1n6m9O0dRiTmZRArY8IbEBZdktEfXlO
        XR9K/lXUk5B8tLmPox4uKSiW6KZt
X-Google-Smtp-Source: APXvYqw2i5MPz0Ij7+TXjPWZPxx6iUp0U9DLzi4PVI/ASJwnHAbiI73c91w4RHtyK5eI09iFXim1Vw==
X-Received: by 2002:aa7:868c:: with SMTP id d12mr21749297pfo.189.1574479111298;
        Fri, 22 Nov 2019 19:18:31 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::2490])
        by smtp.gmail.com with ESMTPSA id u9sm8840090pfm.102.2019.11.22.19.18.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 19:18:30 -0800 (PST)
Date:   Fri, 22 Nov 2019 19:18:28 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org.com, daniel@iogearbox.net,
        yhs@fb.com, andrii.nakryiko@gmail.com, netdev@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH bpf-next v10 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191123031826.j2dj7mzto57ml6pr@ast-mbp.dhcp.thefacebook.com>
References: <cover.1574162990.git.ethercflow@gmail.com>
 <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8b1281b7405eb4b6c1f094169e6efd2c8cc95da.1574162990.git.ethercflow@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 08:27:37AM -0500, Wenbo Zhang wrote:
> When people want to identify which file system files are being opened,
> read, and written to, they can use this helper with file descriptor as
> input to achieve this goal. Other pseudo filesystems are also supported.
> 
> This requirement is mainly discussed here:
> 
>   https://github.com/iovisor/bcc/issues/237
> 
> v9->v10: addressed Andrii's feedback
> - send this patch together with the patch selftests as one patch series
> 
> v8->v9:
> - format helper description
> 
> v7->v8: addressed Alexei's feedback
> - use fget_raw instead of fdget_raw, as fdget_raw is only used inside fs/
> - ensure we're in user context which is safe fot the help to run
> - filter unmountable pseudo filesystem, because they don't have real path
> - supplement the description of this helper function
> 
> v6->v7:
> - fix missing signed-off-by line
> 
> v5->v6: addressed Andrii's feedback
> - avoid unnecessary goto end by having two explicit returns
> 
> v4->v5: addressed Andrii and Daniel's feedback
> - rename bpf_fd2path to bpf_get_file_path to be consistent with other
> helper's names
> - when fdget_raw fails, set ret to -EBADF instead of -EINVAL
> - remove fdput from fdget_raw's error path
> - use IS_ERR instead of IS_ERR_OR_NULL as d_path ether returns a pointer
> into the buffer or an error code if the path was too long
> - modify the normal path's return value to return copied string length
> including NUL
> - update this helper description's Return bits.
> 
> v3->v4: addressed Daniel's feedback
> - fix missing fdput()
> - move fd2path from kernel/bpf/trace.c to kernel/trace/bpf_trace.c
> - move fd2path's test code to another patch
> - add comment to explain why use fdget_raw instead of fdget
> 
> v2->v3: addressed Yonghong's feedback
> - remove unnecessary LOCKDOWN_BPF_READ
> - refactor error handling section for enhanced readability
> - provide a test case in tools/testing/selftests/bpf
> 
> v1->v2: addressed Daniel's feedback
> - fix backward compatibility
> - add this helper description
> - fix signed-off name
> 
> Signed-off-by: Wenbo Zhang <ethercflow@gmail.com>
...
> +BPF_CALL_3(bpf_get_file_path, char *, dst, u32, size, int, fd)
> +{
> +	struct file *f;
> +	char *p;
> +	int ret = -EBADF;
> +
> +	/* Ensure we're in user context which is safe for the helper to
> +	 * run. This helper has no business in a kthread.
> +	 */
> +	if (unlikely(in_interrupt() ||
> +		     current->flags & (PF_KTHREAD | PF_EXITING)))
> +		return -EPERM;
> +
> +	/* Use fget_raw instead of fget to support O_PATH, and it doesn't
> +	 * have any sleepable code, so it's ok to be here.
> +	 */
> +	f = fget_raw(fd);
> +	if (!f)
> +		goto error;
> +
> +	/* For unmountable pseudo filesystem, it seems to have no meaning
> +	 * to get their fake paths as they don't have path, and to be no
> +	 * way to validate this function pointer can be always safe to call
> +	 * in the current context.
> +	 */
> +	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname)
> +		return -EINVAL;
> +
> +	/* After filter unmountable pseudo filesytem, d_path won't call
> +	 * dentry->d_op->d_name(), the normally path doesn't have any
> +	 * sleepable code, and despite it uses the current macro to get
> +	 * fs_struct (current->fs), we've already ensured we're in user
> +	 * context, so it's ok to be here.
> +	 */
> +	p = d_path(&f->f_path, dst, size);
> +	if (IS_ERR(p)) {
> +		ret = PTR_ERR(p);
> +		fput(f);
> +		goto error;
> +	}
> +
> +	ret = strlen(p);
> +	memmove(dst, p, ret);
> +	dst[ret++] = '\0';
> +	fput(f);
> +	return ret;
> +
> +error:
> +	memset(dst, '0', size);
> +	return ret;
> +}

Al,

could you please review about code whether it's doing enough checks to be
called safely from preempt_disabled region?

It's been under review for many weeks and looks good from bpf pov. Essentially
tracing folks need easy way to convert FD to full path name. This feature
request first came in 2015.

Thanks!

