Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25218322CB6
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 15:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbhBWOrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 09:47:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32159 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232553AbhBWOrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 09:47:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614091574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kp43ReK6Bbto6WMF4BKD7QH88weYYK7A/bjDK0aUHLg=;
        b=Ph6zf+xAa3HgZOfRKyVPDjFfZ8alhYSVBDaXdIAIktv4VsQDx+RniWZnZawfvdXMF0m5Tf
        fwXxu+xJSLhYOG2KXWvDiyP4wwKJBRlEr/Q9PnnOTmOUsQYfn6UUSf1Is7DD0jvJiA5GIl
        mnj35gW5qF2+do+F8eS0HHBjmKTsBYE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-APiljNKtMo6l-K6sN8vfXA-1; Tue, 23 Feb 2021 09:45:46 -0500
X-MC-Unique: APiljNKtMo6l-K6sN8vfXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3BDB09A3CA;
        Tue, 23 Feb 2021 14:43:58 +0000 (UTC)
Received: from carbon (unknown [10.36.110.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 16B3970476;
        Tue, 23 Feb 2021 14:43:28 +0000 (UTC)
Date:   Tue, 23 Feb 2021 15:43:27 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>, brouer@redhat.com
Subject: Re: [PATCH bpf-next] bpf: fix missing * in bpf.h
Message-ID: <20210223154327.6011b5ee@carbon>
In-Reply-To: <20210223124554.1375051-1-liuhangbin@gmail.com>
References: <20210223124554.1375051-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Feb 2021 20:45:54 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> Commit 34b2021cc616 ("bpf: Add BPF-helper for MTU checking") lost a *
> in bpf.h. This will make bpf_helpers_doc.py stop building
> bpf_helper_defs.h immediately after bpf_check_mtu, which will affect
> future add functions.
> 
> Fixes: 34b2021cc616 ("bpf: Add BPF-helper for MTU checking")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/uapi/linux/bpf.h       | 2 +-
>  tools/include/uapi/linux/bpf.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks for fixing that!

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

I though I had already fix that, but I must have missed or reintroduced
this, when I rolling back broken ideas in V13.

I usually run this command to check the man-page (before submitting):

 ./scripts/bpf_helpers_doc.py | rst2man | man -l -


> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 4c24daa43bac..46248f8e024b 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3850,7 +3850,7 @@ union bpf_attr {
>   *
>   * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>   *	Description
> -
> + *
>   *		Check ctx packet size against exceeding MTU of net device (based
>   *		on *ifindex*).  This helper will likely be used in combination
>   *		with helpers that adjust/change the packet size.
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4c24daa43bac..46248f8e024b 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3850,7 +3850,7 @@ union bpf_attr {
>   *
>   * long bpf_check_mtu(void *ctx, u32 ifindex, u32 *mtu_len, s32 len_diff, u64 flags)
>   *	Description
> -
> + *
>   *		Check ctx packet size against exceeding MTU of net device (based
>   *		on *ifindex*).  This helper will likely be used in combination
>   *		with helpers that adjust/change the packet size.



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

