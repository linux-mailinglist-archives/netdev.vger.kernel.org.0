Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FE21C468D
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 21:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgEDTBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 15:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726291AbgEDTBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 15:01:14 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12444C061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 12:01:14 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 18so5985851pfv.8
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 12:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nYFjkTQ/J9D4EU63dN0FFikbGAhF+LRtC+WCQwbW2tU=;
        b=PAODR2kWLIQCPRYqkqyIdFR4k6cxeCTcVW1YMVscR7cA4wClEqMBJy9OpZ1qHUqOSD
         7Q9ejnXg70wrUJp9Bz7sjaGojfO30MxpPoyv3mQVm1x4C/y5FRlKfiobLx8iMwGIWr75
         IbOlJj8maIV6VMRn4ekVlm2cVBkVcBPVEBI6Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nYFjkTQ/J9D4EU63dN0FFikbGAhF+LRtC+WCQwbW2tU=;
        b=kqVHrGVMW+CIJC6BWtpWqXFQBLFDbH/ifzB0QE2NEWjpLQEl8XSyOOLPT8Bd4HYlMV
         YSljYzpGv+bBXOuSXtWBRa/2GgNn8nQXe8yHOcBe6ZJyoub+mUMtAvLQIU8oHkm09nbY
         VVKlYsJT9GXFqgNT3gUhOjeHDccYJakEy89ivUcUkQcA/rBYap8BnYi9mG8pFFjly7IQ
         g2Wd4Fmz0dNwiXkO/sM5xqomjTNPlqc9MZNyNGQqCR4HdCd7hRORxzsQaK407I2EVrAR
         f49IFT6ByOPKt0jU1B7meLiRApTBlXJ0mBtJznv9/H4gTG8IFN/CWqn0NoqDL40bu1C2
         5DLw==
X-Gm-Message-State: AGi0PuYA5fnekOn9x+M4SpVDH7sDZtvYLEFb+U6l5tmygJw+1pAHn+D+
        iiATCpS+nZRs0pg4toZyMwTdTQ==
X-Google-Smtp-Source: APiQypL++aZZkzcir41Et1you9KunQZkaeZXnSeZAMZdvN+uRXbMIhhCUTrk8vcGvmD9Ym6nnNHuDA==
X-Received: by 2002:aa7:9297:: with SMTP id j23mr18213294pfa.15.1588618873424;
        Mon, 04 May 2020 12:01:13 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q21sm9348194pfg.131.2020.05.04.12.01.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 12:01:12 -0700 (PDT)
Date:   Mon, 4 May 2020 12:01:11 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrey Ignatov <rdna@fb.com>
Subject: Re: [PATCH 5/5] sysctl: pass kernel pointers to ->proc_handler
Message-ID: <202005041154.CC19F03@keescook>
References: <20200424064338.538313-1-hch@lst.de>
 <20200424064338.538313-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424064338.538313-6-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 08:43:38AM +0200, Christoph Hellwig wrote:
> Instead of having all the sysctl handlers deal with user pointers, which
> is rather hairy in terms of the BPF interaction, copy the input to and
> from  userspace in common code.  This also means that the strings are
> always NUL-terminated by the common code, making the API a little bit
> safer.
> 
> As most handler just pass through the data to one of the common handlers
> a lot of the changes are mechnical.

This is a lovely cleanup; thank you!

Tiny notes below...

> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index b6f5d459b087d..df2143e05c571 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -539,13 +539,13 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
>  	return err;
>  }
>  
> -static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
> +static ssize_t proc_sys_call_handler(struct file *filp, void __user *ubuf,
>  		size_t count, loff_t *ppos, int write)
>  {
>  	struct inode *inode = file_inode(filp);
>  	struct ctl_table_header *head = grab_header(inode);
>  	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
> -	void *new_buf = NULL;
> +	void *kbuf;
>  	ssize_t error;
>  
>  	if (IS_ERR(head))
> @@ -564,27 +564,38 @@ static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
>  	if (!table->proc_handler)
>  		goto out;
>  
> -	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, buf, &count,
> -					   ppos, &new_buf);
> +	if (write) {
> +		kbuf = memdup_user_nul(ubuf, count);
> +		if (IS_ERR(kbuf)) {
> +			error = PTR_ERR(kbuf);
> +			goto out;
> +		}
> +	} else {
> +		error = -ENOMEM;
> +		kbuf = kzalloc(count, GFP_KERNEL);
> +		if (!kbuf)
> +			goto out;
> +	}
> +
> +	error = BPF_CGROUP_RUN_PROG_SYSCTL(head, table, write, &kbuf, &count,
> +					   ppos);
>  	if (error)
> -		goto out;
> +		goto out_free_buf;
>  
>  	/* careful: calling conventions are nasty here */

Is this comment still valid after doing these cleanups?

> -	if (new_buf) {
> -		mm_segment_t old_fs;
> -
> -		old_fs = get_fs();
> -		set_fs(KERNEL_DS);
> -		error = table->proc_handler(table, write, (void __user *)new_buf,
> -					    &count, ppos);
> -		set_fs(old_fs);
> -		kfree(new_buf);
> -	} else {
> -		error = table->proc_handler(table, write, buf, &count, ppos);
> +	error = table->proc_handler(table, write, kbuf, &count, ppos);
> +	if (error)
> +		goto out_free_buf;
> +
> +	if (!write) {
> +		error = -EFAULT;
> +		if (copy_to_user(ubuf, kbuf, count))
> +			goto out_free_buf;
>  	}

Something I noticed here that existed in the original code, but might be
nice to improve while we're here is to make sure that the "count"
returned from proc_handler() cannot grow _larger_, since then we might
expose heap memory beyond the end of the allocation.

I'll send a patch for this...

>  
> -	if (!error)
> -		error = count;
> +	error = count;
> +out_free_buf:
> +	kfree(kbuf);
>  out:
>  	sysctl_head_finish(head);
>  
> [...]
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 511543d238794..e26fe7e8e19d7 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> [...]
> @@ -682,7 +661,6 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
>  		left -= proc_skip_spaces(&p);
>  
>  out_free:
> -	kfree(kbuf);
>  	if (err)
>  		return -EINVAL;

This label name isn't accurate any more... *shrug*

-- 
Kees Cook
