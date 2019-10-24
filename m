Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D332E3910
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 18:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407807AbfJXQ7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 12:59:33 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:43341 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405976AbfJXQ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 12:59:33 -0400
Received: by mail-il1-f196.google.com with SMTP id t5so23036603ilh.10;
        Thu, 24 Oct 2019 09:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=J6cIyEOWdjlCo3WxpSxbJw4O5SIfcJm1CPBXanfu+xM=;
        b=Ptq8nTS5o6TzUrMm9MB8ANO2yHy34z0C/j40+jeauPrMK1ui+Cj2l1U2REFdPofCO3
         guMvB27Jbh8fe5GXqQn9wi4fKIsXcUxN6NoWnKS+xTeXyzHe2oxGZOLLHYrp6W/mly5L
         NhTfWY1NJtjptXbxh9vTVVT8RDuDJ1Qsu9B/HR+xp3YOPuIVI2PCTwEm5R87MnTlRyYY
         9v+d9sazNvxqJVnTrGgfHS7nXqN35yq++KIxc+jadIxA4Xb0LPPQcFDFsBP0pDbG9ya/
         gGL7WakmpSkwzLJh2fphhZNLx+agJQXWL9oFUedrf5dy8mRAOu6Z3UsNMAuCZPBK1Fum
         mHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=J6cIyEOWdjlCo3WxpSxbJw4O5SIfcJm1CPBXanfu+xM=;
        b=mTc6pIu6y3JP0Q8sxmlTUibHy6/2nLrWNFIN7ReOSRWda5+GFUm1JApoHTfcPQ3DBA
         GmwW7YNsaIsVwz1vNLcLv3wyURQfN2VnwhbBWEEYiugm0E5d3r7XlL4pGEim0UgtJ37b
         o9mcksf4S3k20ujyUlTthoaqfKpidDhpwkFs953RP83s7/Mr2kHJIgzK9e7Q4K1WIQWF
         4qZ44mfGcb5aOZBU+iSJtvDDPSmhc7fwE2y4g6+AEo2t2NZgqss+gKtz/BvNbJurexhn
         W4NgQ1rYbNnYwZfRMcPtmPdLE9Qqk4kV/u7LNB6/1yEAqhwA6B1u4J9aHlSp1GVtw+qJ
         aCCg==
X-Gm-Message-State: APjAAAXWgk3oLGL7dRhkzicvzo2C75AHhVvkEYUE8I2gMfASqwUWcuMd
        L+GHWMuZyq7LHFZC1ilDLH0=
X-Google-Smtp-Source: APXvYqyRHcHwApDP3qZCLoIWShsLsHHVj943atq34QEfH7qMjbYAvVAfDNDHQCguOw/3shGV+BrKgg==
X-Received: by 2002:a92:ccd0:: with SMTP id u16mr47017799ilq.296.1571936372309;
        Thu, 24 Oct 2019 09:59:32 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id d6sm7527320iop.34.2019.10.24.09.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 09:59:31 -0700 (PDT)
Date:   Thu, 24 Oct 2019 09:59:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        kernel-team@cloudflare.com
Message-ID: <5db1d86ad61ae_5c282ada047205c0a8@john-XPS-13-9370.notmuch>
In-Reply-To: <20191022113730.29303-2-jakub@cloudflare.com>
References: <20191022113730.29303-1-jakub@cloudflare.com>
 <20191022113730.29303-2-jakub@cloudflare.com>
Subject: RE: [RFC bpf-next 1/5] bpf, sockmap: Let BPF helpers use lookup
 operation on SOCKMAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> Don't require the BPF helpers that need to access SOCKMAP maps to live in
> the sock_map module. Expose SOCKMAP lookup to all kernel-land.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/sock_map.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index eb114ee419b6..facacc296e6c 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -271,7 +271,9 @@ static struct sock *__sock_map_lookup_elem(struct bpf_map *map, u32 key)
>  
>  static void *sock_map_lookup(struct bpf_map *map, void *key)
>  {
> -	return ERR_PTR(-EOPNOTSUPP);
> +	u32 index = *(u32 *)key;
> +
> +	return __sock_map_lookup_elem(map, index);
>  }
>  
>  static int __sock_map_delete(struct bpf_stab *stab, struct sock *sk_test,
> -- 
> 2.20.1
> 

OK, I'm looking into the latest BTF bits to see if we can do something
more useful here to keep the type information when the lookup is done so
the sock can be feed from sk_lookup and actually read.

As this series stands after the lookup its just an opaque ptr_to_map_value
right?
