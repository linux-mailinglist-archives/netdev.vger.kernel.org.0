Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6C020EBD5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 05:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgF3DJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 23:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727826AbgF3DJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 23:09:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8D8C061755;
        Mon, 29 Jun 2020 20:09:13 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id y18so7892643plr.4;
        Mon, 29 Jun 2020 20:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yIL3pkgO7uguBS0Jchh/RFoabjs9MnJHyOUQXijWmz0=;
        b=gd2p+7jm+EwIpMpUiiFHKh7ffy7TwZWNYBJfguNNhwmbRCJOMNsrUy+0hqMrT7WEpr
         edSr4OPpyxau1NUygY81zODg6zTmWG5QqWcud5RYqDVLxe7N0C5JKPKSBsgaFql0guUT
         8sjFZTFqgFzbckuWxyi3j93H5qr1F5Nj2XNXsaPRhltuEL1X1q60YNtGzGxqHUQM6qMq
         bP12SU9uU5UH/WL5apgoJcwMrVwIz3V+ARnNPWm3He6jdTdKZ3372tde0B/AF/g3Eou+
         xTiYmhh7bfAt4R9ap4rDrjI0BO3A4JU9iKQgoGZHwEoxluDYDXaD1WB0CcMw5uD+7lts
         2MXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yIL3pkgO7uguBS0Jchh/RFoabjs9MnJHyOUQXijWmz0=;
        b=iWVMeniM3RwGZaqDUk4r6mR9askgEGkbfY2fYc4JBUOfREdGo3yLeKa9j8NTaXw+ej
         xODcKglJ3ymp+ybkBQJkcSmZVIg+MRYeUWAa0M3bnqny3zsl1XAih80Om4/R45LjV6Tc
         Fu2ULw0345N75meHW6R72iXROOT1uxMErhDcpfdyzODp43rigVxtcfZvQgQlZK/AacUF
         p3CyuxoMyna73FToBNTXQKDd7elF0FKDuU3cSJl5kJpZSgsU8mnizKYm15ziS6WFqpiO
         kgcmGjtJEOHntSBXQpr9hLDAUvSd9hqcg8RXbYgIW2NjvzcOOmKOfES8UJ7tV+eQb1tZ
         B1ug==
X-Gm-Message-State: AOAM531GmsF+4g8DTHzKNSvOqvw4VJmODjO3ewpf42S3Ne7Tx66L6h8o
        6oSEhEowci3viJ/7mPXybp8=
X-Google-Smtp-Source: ABdhPJyrmHljxjXHTh3KGBLamDCoAN2P0O74c3j86Mq4H69p3BsFkiju3uI2R9htartSnYma6qasXQ==
X-Received: by 2002:a17:90a:a68:: with SMTP id o95mr5530237pjo.64.1593486553103;
        Mon, 29 Jun 2020 20:09:13 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:140c])
        by smtp.gmail.com with ESMTPSA id s15sm899659pfm.129.2020.06.29.20.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2020 20:09:12 -0700 (PDT)
Date:   Mon, 29 Jun 2020 20:09:10 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, andrii.nakryiko@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH bpf-next] libbpf: make bpf_endian co-exist with vmlinux.h
Message-ID: <20200630030910.p7xnbnywofvzcr7r@ast-mbp.dhcp.thefacebook.com>
References: <20200630020539.787781-1-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200630020539.787781-1-andriin@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 07:05:38PM -0700, Andrii Nakryiko wrote:
> Copy over few #defines from UAPI swab.h header to make all the rest of
> bpf_endian.h work and not rely on any extra headers. This way it can be used
> both with linux header includes, as well with a vmlinux.h. This has been
> a frequent complaint from users, that need this header.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/bpf_endian.h | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/bpf/bpf_endian.h b/tools/lib/bpf/bpf_endian.h
> index fbe28008450f..a4be8a70845c 100644
> --- a/tools/lib/bpf/bpf_endian.h
> +++ b/tools/lib/bpf/bpf_endian.h
> @@ -2,8 +2,26 @@
>  #ifndef __BPF_ENDIAN__
>  #define __BPF_ENDIAN__
>  
> -#include <linux/stddef.h>
> -#include <linux/swab.h>
> +/* copied from include/uapi/linux/swab.h */

You cannot just copy due to different licenses.
