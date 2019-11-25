Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 933E81094AE
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfKYUgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 15:36:08 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36051 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfKYUgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 15:36:07 -0500
Received: by mail-pl1-f196.google.com with SMTP id d7so7016100pls.3;
        Mon, 25 Nov 2019 12:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XSnSIY6xjxSfde1RnO3cmDWd4Me9KNe3WCylyeEuEU0=;
        b=FSd5qao4ODfMH1QPmKyaauCTmV2Vxi5JJ7VkoFfa2+uM3EXjhJgMrE8EZzsrMUGxfV
         oAEa6/W1wFMub8WkFu14vnSI3K05kOiU9Kj+pygXDj/Idb/8teEuS8f8634CIem8EDpv
         2v8JucM7IiMkIFV5uwQi3g5Mh2CYeXrs87d89xXG93vgc/6A8klpcw5BdLjC9Z2FP+yB
         CX7xNGPL5SKQIpMrYgM5vXpqQpQ4BQIrKoKer5DMq+2C2EiU2rIYHYtBU5vFEE4Nae4R
         dQu1fRDAgk7X1WKD8W9+EvyIBKWu+4l9BD2ZtVZxyW9ByktJoxJHLs6P2fZXoRPaN23G
         +9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XSnSIY6xjxSfde1RnO3cmDWd4Me9KNe3WCylyeEuEU0=;
        b=LtBOp5F7FrkrSj3wL0RuQ78UB4vhy36phqyI26xUPecRtIajhkD8nFLk8njlfcVD5h
         gKkl3cxp5wQPenZw1Ygz/C8BAiPC+vtXvdJqco0OgaLKKuKY127Z3oIjTyLhyi8UdBzW
         Wg5Mry4Uwkrb8PSyiL3YLaNj8Aew0ODpIjnpWRPJqZjGZEtTXWfOR8B/Elw0vwS55W2r
         z9YB338zcHOfqywiGvARhLdhQ9SRnd2dBq2T/lJ+JJ3vNSB8nBHxtTk40JqMoi7Qb6tG
         DG5/0JRktQ7ddG1DtXzMVlIsbNNuF3HCUkbjWD8WXB5FZ0BloN+zZs/LPRZx7AWIsuUF
         q/BA==
X-Gm-Message-State: APjAAAXp9HzDsxmT7+ABYlG8YIPkeiQTVjfajzVhrES7OhohxIDY6lRI
        VoyZgp9oDCKPgfjIfADVDx0=
X-Google-Smtp-Source: APXvYqzySfYf+NEsSvCzYMGL06x+R+Ugqe5tv7Wpk9/7nRrPfypB0d5+LGDo5SqE8ZQkLWW/En0lhA==
X-Received: by 2002:a17:902:868f:: with SMTP id g15mr29898735plo.294.1574714167105;
        Mon, 25 Nov 2019 12:36:07 -0800 (PST)
Received: from localhost (74-95-46-65-Oregon.hfc.comcastbusiness.net. [74.95.46.65])
        by smtp.gmail.com with ESMTPSA id i3sm9353820pfd.154.2019.11.25.12.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Nov 2019 12:36:06 -0800 (PST)
Date:   Mon, 25 Nov 2019 12:36:05 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Message-ID: <5ddc3b355840f_2b082aba75a825b46@john-XPS-13-9370.notmuch>
In-Reply-To: <20191123220835.1237773-1-andriin@fb.com>
References: <20191123220835.1237773-1-andriin@fb.com>
Subject: RE: [PATCH bpf-next] mm: implement no-MMU variant of
 vmalloc_user_node_flags
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> To fix build with !CONFIG_MMU, implement it for no-MMU configurations as well.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Fixes: fc9702273e2e ("bpf: Add mmap() support for BPF_MAP_TYPE_ARRAY")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  mm/nommu.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 99b7ec318824..7de592058ab4 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -155,11 +155,11 @@ void *__vmalloc_node_flags(unsigned long size, int node, gfp_t flags)
>  	return __vmalloc(size, flags, PAGE_KERNEL);
>  }
>  
> -void *vmalloc_user(unsigned long size)
> +static void *__vmalloc_user_flags(unsigned long size, gfp_t flags)
>  {
>  	void *ret;
>  
> -	ret = __vmalloc(size, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
> +	ret = __vmalloc(size, flags, PAGE_KERNEL);
>  	if (ret) {
>  		struct vm_area_struct *vma;
>  
> @@ -172,8 +172,19 @@ void *vmalloc_user(unsigned long size)
>  
>  	return ret;
>  }
> +
> +void *vmalloc_user(unsigned long size)
> +{
> +	return __vmalloc_user_flags(size, GFP_KERNEL | __GFP_ZERO);
> +}
>  EXPORT_SYMBOL(vmalloc_user);
>  
> +void *vmalloc_user_node_flags(unsigned long size, int node, gfp_t flags)
> +{
> +	return __vmalloc_user_flags(size, flags | __GFP_ZERO);
> +}
> +EXPORT_SYMBOL(vmalloc_user_node_flags);
> +

Hi Andrii, my first reaction was that it seemed not ideal to just ignore
the node value like this but everything I came up with was uglier. I
guess only user is BPF at the moment so it should be fine.

Acked-by: John Fastabend <john.fastabend@gmail.com>
