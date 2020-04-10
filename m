Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD691A4B94
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 23:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgDJVbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 17:31:43 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39192 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDJVbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 17:31:43 -0400
Received: by mail-pf1-f194.google.com with SMTP id k15so1548524pfh.6;
        Fri, 10 Apr 2020 14:31:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BNYIUDo9ygHd8iexiVyua9HrBrjiBvjwwyQMTSq8t/8=;
        b=H5RybE4IilGkAzz1x1zIk83EC99f0glNA2hazAI1sSwxlhV/EKbWWGnbgz7ndQ0L5c
         7Y0WkdIsLzCDxm1RI9ELdLphaINP8LGM0VW5EH9ZuDYIsH0lEURNwSGmGDxlpH8YG5Sv
         n/pad8CpG+LUVM02tNdtIwl2CDl785BhLBpeCEZlStLO8VNo+KyfoUagGhlkcq5P6jld
         fVcUyYR8rP0lf3SDKNG8CACo+S1u5glsQFU7Ns2Ddckx9vP3U9S23nsi+pZgEgXBDIKc
         MSoUwBlkFF5L0d/vkNlCZJF9YnlZvEvh+Hv9MYyuy1MiilqJDYtXqhBGgLZvY/XM6zR4
         kvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BNYIUDo9ygHd8iexiVyua9HrBrjiBvjwwyQMTSq8t/8=;
        b=akZy9/xSVV0P30x9ANCYVk8WXlHdyxSXrbyCGZ3F3mE82/pVm84G6TCWTLRRtlYDC6
         JgNqxe804czYFPJRlW7ygw6QWjVJTd+BhI7f4tp2jp+v4/MqAS/1MEUviYEaJAUldbJC
         XRymq0uWP+DY7aIThwNZovHw8z5e20gnGPaayiUmnNy/pr+nti9/gF0uObPB4CAJk+uY
         yFulcjy4m0AbZUQrIpG5KeEMAROWiB577tfYqYRNFD8ZNi06UIZ9yUN8PX2y7NYIW+cH
         +fcleoTbH9UBoJmj7D8VEAgqIGZ/FnQyGZUxU7gcOptyTkn83pNcE8akmDOMtx6YMRp2
         TNFA==
X-Gm-Message-State: AGi0PuZtKx4XGqHTCO1mIszxAXEygEhY2AYm7HtGiAaNtVkI8nS7nohe
        ZI3AgZF70OG2gjr04gb71WnaClld
X-Google-Smtp-Source: APiQypKwRP/heng+W7DCmkd853MtwBhdFhSnrUuvcO8H1Zhe2nHd3xWutMwJvHpReULjBiDqxBlFhw==
X-Received: by 2002:a62:7594:: with SMTP id q142mr6934401pfc.104.1586554301892;
        Fri, 10 Apr 2020 14:31:41 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:5315])
        by smtp.gmail.com with ESMTPSA id 7sm2429049pga.15.2020.04.10.14.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 14:31:41 -0700 (PDT)
Date:   Fri, 10 Apr 2020 14:31:38 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [RFC PATCH bpf-next 08/16] bpf: add task and task/file targets
Message-ID: <20200410213138.xwn2b7t6np44v5ls@ast-mbp>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232529.2676060-1-yhs@fb.com>
 <20200410032223.esp46oxtpegextxn@ast-mbp.dhcp.thefacebook.com>
 <d40f0a39-093f-2ed2-d5d0-b97947f0093f@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d40f0a39-093f-2ed2-d5d0-b97947f0093f@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 11:19:10PM -0700, Yonghong Song wrote:
> 
> 
> On 4/9/20 8:22 PM, Alexei Starovoitov wrote:
> > On Wed, Apr 08, 2020 at 04:25:29PM -0700, Yonghong Song wrote:
> > > +
> > > +	spin_lock(&files->file_lock);
> > > +	for (; sfd < files_fdtable(files)->max_fds; sfd++) {
> > > +		struct file *f;
> > > +
> > > +		f = fcheck_files(files, sfd);
> > > +		if (!f)
> > > +			continue;
> > > +
> > > +		*fd = sfd;
> > > +		get_file(f);
> > > +		spin_unlock(&files->file_lock);
> > > +		return f;
> > > +	}
> > > +
> > > +	/* the current task is done, go to the next task */
> > > +	spin_unlock(&files->file_lock);
> > > +	put_files_struct(files);
> > 
> > I think spin_lock is unnecessary.
> > It's similarly unnecessary in bpf_task_fd_query().
> > Take a look at proc_readfd_common() in fs/proc/fd.c.
> > It only needs rcu_read_lock() to iterate fd array.
> 
> I see. I was looking at function seq_show() at fs/proc/fd.c,
> 
> ...
>                 spin_lock(&files->file_lock);
>                 file = fcheck_files(files, fd);
>                 if (file) {
>                         struct fdtable *fdt = files_fdtable(files);
> 
>                         f_flags = file->f_flags;
>                         if (close_on_exec(fd, fdt))
>                                 f_flags |= O_CLOEXEC;
> 
>                         get_file(file);
>                         ret = 0;
>                 }
>                 spin_unlock(&files->file_lock);
>                 put_files_struct(files);
> ...
> 
> I guess here spin_lock is needed due to close_on_exec().

Right. fdr->close_on_exec array is not rcu protected and needs that spin_lock.

> Will use rcu_read_lock() mechanism then.

Thanks!
