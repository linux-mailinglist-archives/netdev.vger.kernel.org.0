Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEFC03D5858
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbhGZKbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbhGZKbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 06:31:17 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0493C061757;
        Mon, 26 Jul 2021 04:11:45 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r17so14750758lfe.2;
        Mon, 26 Jul 2021 04:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n6bJSXqmcuKJfAgVqQXN6el/oURcZ0UU9SDbTUMNCAM=;
        b=g0xMMZ/KPNpXWtAf3Vg1zFQ0eLd6TQvlY3jGoDtGSvZsBNagZf8KHfo3ktl6kgkENs
         OMCazNSxkroLdVQONm97uoPloWGucMNkqcQ3MUaNVv6oAO7JRsI8jx+IB7reM2R4e5+l
         7OxQsX4wUVvpU5ndlams6jhHu+YyMtRCFEn7qWupmUz9IleoQvxRtALdr9Z++fiaxGEd
         Uz1b+INwfoyN9B6y2vbuAVma+AYt0kyk91IaprJIRS7qokct3U15VuNL/dxP3Eeftixg
         Av8hLhGU66i8wMkQg3NamgOLeCcTgVNdZGlBdfWI5CgnQnS1eeVnwfEEIy7X5VRouUDF
         eAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n6bJSXqmcuKJfAgVqQXN6el/oURcZ0UU9SDbTUMNCAM=;
        b=COQt/Il8QFhDmtzVJQ4tx09ICdujUMCyZLI/OiCqunRfbJ/cSrMguImwKuxrZRSz+P
         6nwS5Wcs8q+Ritmns+lvnbj7jeXrzjKaYr4YcCW9bS3pL/vWV0WO9cHsHXgwadGr+wYe
         LKCZ5i2P+/4CKuC1OFd86x0+GngZ6LaDBvqPm6qha7VvV0dm/gbOkYKl0xX+boAlqZcq
         gixpwUxp5cKUNWwOFYxHyvWEri/HG4bv1ptOr466E0OsWpfnVzTiDc/f4ZjKzE4s88aY
         YBB59CbwbmA8J6JdWDOIVGqRg7yP0CXq56NaG2SDFBN9CN6KkgkYbhnsOxGYY7cG8SDE
         nKRQ==
X-Gm-Message-State: AOAM532pRju4p17zOz8U5qSEIABcFfzrbR1vAssOED9UCzV9LwMsErfm
        z1LgAN9K9CchUdDx9hD6UOk=
X-Google-Smtp-Source: ABdhPJzdwv+HmcbqytJU0HH8+7k/WPlg+x1ObKdecgnmut1qbxCfWJ5Gg57D3WDolyh9m7MNNn/hRg==
X-Received: by 2002:ac2:52b4:: with SMTP id r20mr13193991lfm.104.1627297903256;
        Mon, 26 Jul 2021 04:11:43 -0700 (PDT)
Received: from localhost.localdomain ([46.61.204.59])
        by smtp.gmail.com with ESMTPSA id bt12sm2450642lfb.14.2021.07.26.04.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 04:11:43 -0700 (PDT)
Date:   Mon, 26 Jul 2021 14:11:40 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     paul@paul-moore.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] net: cipso: fix warnings in netlbl_cipsov4_add_std
Message-ID: <20210726141140.24e8db78@gmail.com>
In-Reply-To: <53de0ccd1aa3fffa6bce2a2ae7a5ca07e0af6d3a.1625900431.git.paskripkin@gmail.com>
References: <cover.1625900431.git.paskripkin@gmail.com>
        <53de0ccd1aa3fffa6bce2a2ae7a5ca07e0af6d3a.1625900431.git.paskripkin@gmail.com>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 10 Jul 2021 10:03:13 +0300
Pavel Skripkin <paskripkin@gmail.com> wrote:

> Syzbot reported warning in netlbl_cipsov4_add(). The
> problem was in too big doi_def->map.std->lvl.local_size
> passed to kcalloc(). Since this value comes from userpace there is
> no need to warn if value is not correct.
> 
> The same problem may occur with other kcalloc() calls in
> this function, so, I've added __GFP_NOWARN flag to all
> kcalloc() calls there.
> 
> Reported-and-tested-by:
> syzbot+cdd51ee2e6b0b2e18c0d@syzkaller.appspotmail.com Fixes:
> 96cb8e3313c7 ("[NetLabel]: CIPSOv4 and Unlabeled packet integration")
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com> ---
>  net/netlabel/netlabel_cipso_v4.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/netlabel/netlabel_cipso_v4.c
> b/net/netlabel/netlabel_cipso_v4.c index 4f50a64315cf..50f40943c815
> 100644 --- a/net/netlabel/netlabel_cipso_v4.c
> +++ b/net/netlabel/netlabel_cipso_v4.c
> @@ -187,14 +187,14 @@ static int netlbl_cipsov4_add_std(struct
> genl_info *info, }
>  	doi_def->map.std->lvl.local =
> kcalloc(doi_def->map.std->lvl.local_size, sizeof(u32),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL |
> __GFP_NOWARN); if (doi_def->map.std->lvl.local == NULL) {
>  		ret_val = -ENOMEM;
>  		goto add_std_failure;
>  	}
>  	doi_def->map.std->lvl.cipso =
> kcalloc(doi_def->map.std->lvl.cipso_size, sizeof(u32),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL |
> __GFP_NOWARN); if (doi_def->map.std->lvl.cipso == NULL) {
>  		ret_val = -ENOMEM;
>  		goto add_std_failure;
> @@ -263,7 +263,7 @@ static int netlbl_cipsov4_add_std(struct
> genl_info *info, doi_def->map.std->cat.local = kcalloc(
>  					      doi_def->map.std->cat.local_size,
>  					      sizeof(u32),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL |
> __GFP_NOWARN); if (doi_def->map.std->cat.local == NULL) {
>  			ret_val = -ENOMEM;
>  			goto add_std_failure;
> @@ -271,7 +271,7 @@ static int netlbl_cipsov4_add_std(struct
> genl_info *info, doi_def->map.std->cat.cipso = kcalloc(
>  					      doi_def->map.std->cat.cipso_size,
>  					      sizeof(u32),
> -					      GFP_KERNEL);
> +					      GFP_KERNEL |
> __GFP_NOWARN); if (doi_def->map.std->cat.cipso == NULL) {
>  			ret_val = -ENOMEM;
>  			goto add_std_failure;


Hi, net developers!

Is this patch merged somewhere? I've checked net tree and Paul Moore
tree on https://git.kernel.org/, but didn't find it. Did I miss it
somewhere? If not, it's just a gentle ping :)

Btw: maybe I should send it as separete patch, since 2/2 in this
series is invalid as already in-tree?


 
With regards,
Pavel Skripkin

