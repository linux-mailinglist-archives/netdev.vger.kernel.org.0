Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3C24010B4
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237736AbhIEP6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:58:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIEP6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:58:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630857451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ALsSmxCI7zZzOlsgFfP2jF6WBrBi9RCCJjNwkZ0c/3s=;
        b=HbmKQ/IY83JWXQ2DlBSppysfTXKSMD3e2idIk2mKFyq+Xe8xewoN+qjVIZ2C8g/DxrckGM
        2JPUb73aS6w8VgecNi0pBytxrtnXUuZJarNKPsa3fpEAWFWaatgBt4DttWMntWyB3SYBtq
        m59x43kKbOTo0Jd9asV5jYCvNnk/7Ro=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-541-eFAKYslmOzSnWoZJ-EW0Ow-1; Sun, 05 Sep 2021 11:57:30 -0400
X-MC-Unique: eFAKYslmOzSnWoZJ-EW0Ow-1
Received: by mail-wm1-f70.google.com with SMTP id y24-20020a7bcd98000000b002eb50db2b62so2171889wmj.5
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:57:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ALsSmxCI7zZzOlsgFfP2jF6WBrBi9RCCJjNwkZ0c/3s=;
        b=iiOT2Hw4d7uimNSallv+AwkuAzHWSm3Yv024/ggcPMVA8MgbUdBn1TA6lpBmM/CDGE
         dhvDfIPeYy77x51tZv9Cje9dpvrUDS8AdItfb7esCoS4QgHY6yjNr+r9RSYtHRrL1XW0
         Ah6zjFLDp7jsJwVD6Ns/2DzpkjatZhRiDxfySlIFi7WpIZdlXml10PVBT/U4eubmyY+T
         lWGbuzElOrjTMqZ/lwK71pkl/fZryZIDp/eDnAQAP1XD2B1NuR73LQZLOnCkLuSCW9t/
         jJNHhcgXn5/hZN0Cv5vTh6iz7FKGgCM8gnlorQI1TG285uXk8vbjXSSfjl9gXYmlU3n6
         M3IA==
X-Gm-Message-State: AOAM530pRsfc7oI2zvE1c6wnYtUfS3C9P/wJbMnfjDYEeJ19xLapVEBy
        nCN37t+t6zCM943dNTiB2Kmv7MGGehnQvkx51rr9TLHYNVql4uUNKV+EknwQiuKEK52vbm2HdQT
        ajCgyRXfTZspxhq/N
X-Received: by 2002:adf:f991:: with SMTP id f17mr9015614wrr.56.1630857449029;
        Sun, 05 Sep 2021 08:57:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwwnpG4c6ej4zR69bwXXhKihUsDCsR3fnY/KHrXw5h/ma0hALUo9/kK5Sd32+gteCqNYbS8Og==
X-Received: by 2002:adf:f991:: with SMTP id f17mr9015590wrr.56.1630857448836;
        Sun, 05 Sep 2021 08:57:28 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id u16sm5501569wmc.41.2021.09.05.08.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 08:57:28 -0700 (PDT)
Date:   Sun, 5 Sep 2021 11:57:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     jasowang@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
        parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, joe@perches.com, robin.murphy@arm.com,
        will@kernel.org, john.garry@huawei.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 03/13] file: Export receive_fd() to modules
Message-ID: <20210905115642-mutt-send-email-mst@kernel.org>
References: <20210831103634.33-1-xieyongji@bytedance.com>
 <20210831103634.33-4-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210831103634.33-4-xieyongji@bytedance.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 06:36:24PM +0800, Xie Yongji wrote:
> Export receive_fd() so that some modules can use
> it to pass file descriptor between processes without
> missing any security stuffs.
> 
> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

This needs some acks from fs devels.
Viro?


> ---
>  fs/file.c            | 6 ++++++
>  include/linux/file.h | 7 +++----
>  2 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/file.c b/fs/file.c
> index 86dc9956af32..210e540672aa 100644
> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -1134,6 +1134,12 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
>  	return new_fd;
>  }
>  
> +int receive_fd(struct file *file, unsigned int o_flags)
> +{
> +	return __receive_fd(file, NULL, o_flags);
> +}
> +EXPORT_SYMBOL_GPL(receive_fd);
> +
>  static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
>  {
>  	int err = -EBADF;
> diff --git a/include/linux/file.h b/include/linux/file.h
> index 2de2e4613d7b..51e830b4fe3a 100644
> --- a/include/linux/file.h
> +++ b/include/linux/file.h
> @@ -94,6 +94,9 @@ extern void fd_install(unsigned int fd, struct file *file);
>  
>  extern int __receive_fd(struct file *file, int __user *ufd,
>  			unsigned int o_flags);
> +
> +extern int receive_fd(struct file *file, unsigned int o_flags);
> +
>  static inline int receive_fd_user(struct file *file, int __user *ufd,
>  				  unsigned int o_flags)
>  {
> @@ -101,10 +104,6 @@ static inline int receive_fd_user(struct file *file, int __user *ufd,
>  		return -EFAULT;
>  	return __receive_fd(file, ufd, o_flags);
>  }
> -static inline int receive_fd(struct file *file, unsigned int o_flags)
> -{
> -	return __receive_fd(file, NULL, o_flags);
> -}
>  int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags);
>  
>  extern void flush_delayed_fput(void);
> -- 
> 2.11.0

