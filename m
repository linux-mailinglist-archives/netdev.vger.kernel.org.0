Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E27E113C31
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 08:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfLEHTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 02:19:04 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40870 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbfLEHTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 02:19:04 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so1165824pfh.7;
        Wed, 04 Dec 2019 23:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2BLGKExrpBAycq4rS/IUkDgYPAZI8XigtD5QZVnS6MU=;
        b=BuT9I5w8et4kk7zZsItsXJEYL5hNnNoy4Qqo5jiIRAGRD8IwbzKjHT6dpJMGLDOPjJ
         bRVSKUp1ZVQF4hzvViD8uT6+by4YprtO5+KkY3XGSSfOH5Xgzs7VDERKsEh9Q6N3pJ8g
         qwmPwbZEugt6Z9AgDBwYNpRdKNwPbIJ+fnQovbJUh+6jp/xGXlzw9YtV5wwnjd2hDGns
         NipB7xRJScWwnahiTRgzKYLbjq4Ix1H0wO1reesaRYeIcFqLvgdx7YTMYFegSpu7ofzf
         +JpI5fYP+4MNNIOSk2h5qzsP/f6LNnkPNgGCNRMJ9CH++aeo0CV8W496/UgewD0EHpH0
         DoxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2BLGKExrpBAycq4rS/IUkDgYPAZI8XigtD5QZVnS6MU=;
        b=PRHQnz5iAt24aXUSA3gLGcES0v6dYVqrW5yR2Syp5HKbvy7Z2SEu4fimFsImlIEiry
         aKfjlMF8jE2+ZAbKBq1ZP6gXwnlHTG4qIATY3aBI63ZbGn2LrQybaoavVSenqzFYG5b4
         HoiequY3mqUDye5qItRmZb9TfbTGcPBEe8UegPHs52JJv4g1nlwHWte3DOgFa3mZjmgS
         jeSfulMsZljnklLS12W3l5WBsPiGGjXEdvwTgI1lblWbZy8f0Z+JK8++1UYw4VGYj1zH
         XVqV3yMzoX4H8Z25TKpY9fXnLo0Zs25Xmr78mRAhEYwIW0VQW6cVeq4C0aq42tcHURaj
         S0hg==
X-Gm-Message-State: APjAAAVhnIHe20/7Ta6xLhlKxp3v9p7bS6lLQeV/ygyMZWkIlcnKWO5p
        nxdFbwpiqy39xbPse/sRxck=
X-Google-Smtp-Source: APXvYqxCrmLp5RDt4yCyICdWYQMr045uNotlZBAVxH3qA9CoJkB9oAjth/2+6ZcBPEqTgTPHGAYm1Q==
X-Received: by 2002:a63:4d12:: with SMTP id a18mr7673450pgb.451.1575530343250;
        Wed, 04 Dec 2019 23:19:03 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::f3d1])
        by smtp.gmail.com with ESMTPSA id m5sm8908484pjl.30.2019.12.04.23.19.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 23:19:02 -0800 (PST)
Date:   Wed, 4 Dec 2019 23:19:00 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        yhs@fb.com, andrii.nakryiko@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v11 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Message-ID: <20191205071858.entnj2c27n44kwit@ast-mbp.dhcp.thefacebook.com>
References: <cover.1575517685.git.ethercflow@gmail.com>
 <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afe4deb020b781c76e9df8403a744f88a8725cd2.1575517685.git.ethercflow@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 11:20:35PM -0500, Wenbo Zhang wrote:
>  
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
> +		     current->flags & (PF_KTHREAD | PF_EXITING))) {
> +		ret = -EPERM;
> +		goto error;
> +	}
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
> +	if (f->f_path.dentry->d_op && f->f_path.dentry->d_op->d_dname) {
> +		ret = -EINVAL;
> +		fput(f);
> +		goto error;
> +	}
> +
> +	/* After filter unmountable pseudo filesytem, d_path won't call
> +	 * dentry->d_op->d_name(), the normally path doesn't have any
> +	 * sleepable code, and despite it uses the current macro to get
> +	 * fs_struct (current->fs), we've already ensured we're in user
> +	 * context, so it's ok to be here.
> +	 */
> +	p = d_path(&f->f_path, dst, size);

Above 'if's are not enough to make sure that it won't dead lock.
Allowing it in tracing_func_proto() means that it's available to kprobe too.
Hence deadlock is possible. Please see previous email thread.
This helper is safe in tracepoint+bpf only.

