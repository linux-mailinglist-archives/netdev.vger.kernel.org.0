Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C228389D98
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhETGUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhETGUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:20:44 -0400
Received: from zeniv-ca.linux.org.uk (zeniv-ca.linux.org.uk [IPv6:2607:5300:60:148a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71335C061574;
        Wed, 19 May 2021 23:19:23 -0700 (PDT)
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94 #2 (Red Hat Linux))
        id 1ljc1B-00GTlF-Uy; Thu, 20 May 2021 06:18:50 +0000
Date:   Thu, 20 May 2021 06:18:49 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, axboe@kernel.dk, bcrl@kvack.org,
        corbet@lwn.net, mika.penttila@nextfour.com,
        dan.carpenter@oracle.com, joro@8bytes.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/12] file: Export receive_fd() to modules
Message-ID: <YKX/SUq53GDtq84t@zeniv-ca.linux.org.uk>
References: <20210517095513.850-1-xieyongji@bytedance.com>
 <20210517095513.850-3-xieyongji@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517095513.850-3-xieyongji@bytedance.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 05:55:03PM +0800, Xie Yongji wrote:
> Export receive_fd() so that some modules can use
> it to pass file descriptor between processes without
> missing any security stuffs.

Which tree is that against?  Because in mainline this won't even build, let
alone work.

> --- a/fs/file.c
> +++ b/fs/file.c
> @@ -1135,6 +1135,12 @@ int __receive_fd(int fd, struct file *file, int __user *ufd, unsigned int o_flag
>  	return new_fd;
>  }
>  
> +int receive_fd(struct file *file, unsigned int o_flags)
> +{
> +	return __receive_fd(-1, file, NULL, o_flags);
> +}
> +EXPORT_SYMBOL_GPL(receive_fd);

fs/file.c:1097:int __receive_fd(struct file *file, int __user *ufd, unsigned int o_flags)

