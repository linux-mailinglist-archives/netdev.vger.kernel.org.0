Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733DE40C9ED
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 18:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhIOQUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 12:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhIOQT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 12:19:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5296C061574;
        Wed, 15 Sep 2021 09:18:38 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v2so1937142plp.8;
        Wed, 15 Sep 2021 09:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SsCbbjCE5kc+uLnSb51SXUB7ypUOWvKsCSrL5lvcgQ8=;
        b=GIsq/FYQe4F/a1QmYNRlvr8tJhKlgZv0D2SF70g4rcR/zVleGw5cZft3zKIzt6LXtP
         kyRXw3NHsoKzDoYetZFAxE8HgC/hL0qdAANnz7hL5QDfOxwK+s63XHIFpjkRbhULQhk3
         eFF/7EFY4IO/keXur3HZztRSvONt6p/x2yWw474NFFaDLkZmBIXm9YOzYRtKcWqNIyM2
         RNNozxb6xT7HaJB0XBt4j+FkeXPW5IevR8uEN3gVfuDatqw4CnwYzsT0dE8SENPy6IIF
         9mQs/1J7N9rqcMLD9gZUHi9DBNqtG6kouXvqmbwmkJiOlp1wKilashUuBMKbe4S6mcLy
         mXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SsCbbjCE5kc+uLnSb51SXUB7ypUOWvKsCSrL5lvcgQ8=;
        b=eVkb/FweMtJMZrOAa5mXv2GPrLx9YFsuBq/+8POrc6X/2ypTDqiKQ5xiAllCcNvbZ7
         uF2b2/ajaXeigpw4BRphLaSWxy0K8MIzUXCpgbTpfPjos88Qx6avpvo/5Sy14+qSANyT
         1J9/RKsyKAOfZH10e/CN+7RCkfFDnoinHLz3vqTV0580eEqWKYtIAC0zfVlzK0I0eB7n
         iYg4uwaJgO5IW9vy9MMBdTr4tqpRfhwUA5jqr4yB7Cx7TULjGiWzwUeJ5vkGnSnRa8fP
         DqdnzYkpSuURTvQibDrw4k94bmc4HNQwHcpZHjuWNzptgOeyIo709opZv1wuNivmnTZN
         dhwg==
X-Gm-Message-State: AOAM532ZYKgOjTlNiknyEMCQmmrwl/0FAI/Jh1F7xHkaaeerDDpQla3A
        zuZofGOxYWWvx1zI4O2KN81/2OvKVi8=
X-Google-Smtp-Source: ABdhPJyZKviwTMkAiQ8aHbELOEmY+f4QewLJ2xDoDJkojbJJOojyV0IAStCTApS3OTCx0hDiFCfCWg==
X-Received: by 2002:a17:90b:4a84:: with SMTP id lp4mr9488294pjb.34.1631722718094;
        Wed, 15 Sep 2021 09:18:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:7b03])
        by smtp.gmail.com with ESMTPSA id d22sm326039pfv.196.2021.09.15.09.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 09:18:37 -0700 (PDT)
Date:   Wed, 15 Sep 2021 09:18:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/10] bpf: btf: Introduce helpers for
 dynamic BTF set registration
Message-ID: <20210915161835.xipxa324own7s6ya@ast-mbp.dhcp.thefacebook.com>
References: <20210915050943.679062-1-memxor@gmail.com>
 <20210915050943.679062-4-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210915050943.679062-4-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 10:39:36AM +0530, Kumar Kartikeya Dwivedi wrote:
> This adds helpers for registering btf_id_set from modules and the
> check_kfunc_call callback that can be used to look them up.
> 
> With in kernel sets, the way this is supposed to work is, in kernel
> callback looks up within the in-kernel kfunc whitelist, and then defers
> to the dynamic BTF set lookup if it doesn't find the BTF id. If there is
> no in-kernel BTF id set, this callback can be used directly.
> 
> Also fix includes for btf.h and bpfptr.h so that they can included in
> isolation. This is in preparation for their usage in tcp_bbr, tcp_cubic
> and tcp_dctcp modules in the next patch.
> 
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  include/linux/bpfptr.h |  1 +
>  include/linux/btf.h    | 32 ++++++++++++++++++++++++++
>  kernel/bpf/btf.c       | 51 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 84 insertions(+)
> 
> diff --git a/include/linux/bpfptr.h b/include/linux/bpfptr.h
> index 546e27fc6d46..46e1757d06a3 100644
> --- a/include/linux/bpfptr.h
> +++ b/include/linux/bpfptr.h
> @@ -3,6 +3,7 @@
>  #ifndef _LINUX_BPFPTR_H
>  #define _LINUX_BPFPTR_H
>  
> +#include <linux/mm.h>

Could you explain what this is for?

>  #include <linux/sockptr.h>
