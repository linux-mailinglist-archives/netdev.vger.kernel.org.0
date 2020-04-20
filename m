Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5471B0E7D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgDTOfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726895AbgDTOfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:35:06 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9939C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:35:05 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e26so11303193wmk.5
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UEw5qMFq4cVjMq2x+pE+pPAKxHl7/Fo99ajH/2UuCbg=;
        b=07e6cN6wp/AGEBRp4hdx6qKG+Ypal2HbmfQBcXN3uWMnkF9C/u06Z7k6hXTrZaArZz
         2JmrrKztQB/AzVZCeYwQwt4vjEDkcPLdr51WGwzgEQ7fxVo3EjO9VZtF5lrfLYkQRUz+
         ComVBHW3oO1HlgLTecxMlm3/7OSp1MiPTc5HB5BwqmXh2bcivd0j2Su3aT8SaQ6gheNV
         speHGQR6+q9Y1oIDPftwGrWxPKNkLDpvebVQ628bOJprTc35pXqdObb7g6KbpJhG7e94
         A4yOylvhPKRaALEXz0cITChWlqj3NRtKLcAIadKM92pvDUhtun6kCBJTPRZb6OJ1YAZ9
         GRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UEw5qMFq4cVjMq2x+pE+pPAKxHl7/Fo99ajH/2UuCbg=;
        b=JTewKtOmYxIhY+oOyRiEhJSkJze633GTsbE8dP8qOTMy4rH38miTN3kYSHJJybcD3m
         WqVd0gzzYfr1ssuiQEeJLA+IvyDM0Vcw/AHJ4zTtduww5gi8GBOZ/Go/lRTXu3F0ylj1
         3CQ9nHq9LEZfOlFJdXUadXZZBPe7pVdj8Yx78kNTmC0rd3R5PeX357pfJIfiRLAxYHmM
         bJX332BOFtln0oy3odJ4pj4n1MS1DG4J+1Rxj/taARXhChSQK0mmcyCdQWZMAaD5Qftr
         Ptd1vI/q6remGXhmZrY+/cUjJ46o+jsY3zFwwKSs3UIutWEvGHehnsw5onHIlWi0sC2F
         oKrg==
X-Gm-Message-State: AGi0PuY5/iMOrpPUBY5lrlPFaanhJVYLmhhypDylg5kJvIHVl9LBOVWX
        HiVTr44MBQ20QwieYuStOLdnVA==
X-Google-Smtp-Source: APiQypJqC04Q3QZHkrdFHvWPWAKcesiNp7WxA0gKE3OeH/F0+0zcP6Jug8vsbZ0/xdD8O0mtO5dYyA==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr17094869wmi.182.1587393304537;
        Mon, 20 Apr 2020 07:35:04 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id v1sm1525818wrv.19.2020.04.20.07.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:35:03 -0700 (PDT)
Date:   Mon, 20 Apr 2020 16:35:02 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v2] team: fix hang in team_mode_get()
Message-ID: <20200420143502.GO6581@nanopsycho.orion>
References: <20200420131145.20146-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420131145.20146-1-ap420073@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Apr 20, 2020 at 03:11:45PM CEST, ap420073@gmail.com wrote:

[...]


>diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
>index 4004f98e50d9..4f1ccbafb961 100644
>--- a/drivers/net/team/team.c
>+++ b/drivers/net/team/team.c
>@@ -465,8 +465,11 @@ EXPORT_SYMBOL(team_mode_unregister);
> 
> static const struct team_mode *team_mode_get(const char *kind)
> {
>-	struct team_mode_item *mitem;
> 	const struct team_mode *mode = NULL;
>+	struct team_mode_item *mitem;

Remove this unrelated move from the patch.


>+
>+	if (!try_module_get(THIS_MODULE))
>+		return NULL;
> 
> 	spin_lock(&mode_list_lock);
> 	mitem = __find_mode(kind);
>@@ -483,6 +486,7 @@ static const struct team_mode *team_mode_get(const char *kind)
> 	}
> 
> 	spin_unlock(&mode_list_lock);
>+	module_put(THIS_MODULE);
> 	return mode;
> }
> 
>-- 
>2.17.1
>
