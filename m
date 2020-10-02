Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D628151A
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 16:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388116AbgJBO3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 10:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgJBO3h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 10:29:37 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487B3C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 07:29:37 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id a17so204743pju.1
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 07:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fcxCkiSjvbY+yKfLz7AdF0gJGV28srIrMcWeXXsq5W0=;
        b=W1p/6XP+6E2QHYIXlI96NsbrilZTO6aQbRNgCjKHcIg7VvHtEQ2IOOTHsJ29Tc/Z81
         05O6mE5uuNj0Xwwh4dtn4q4cRVAXK9SYD72sHH8A0mQFkzZKpAf+IUHN1Pt6tbeKxX9R
         28hWOb5uZLiY5fG+exkOFpDOjEgHhnrMUjwUMUtPSmEPqPWuTvEDT34Jk3TlbZyGOEf7
         aXH7CZaFEhfdZDVlUg0MNx+2ffYzDyf4ZQYBsxp8vAW6xVwUjDLBurTROZEiTGX7Xokl
         CZTVsOnAhtUxvH5cJHfiip02JGUCpCz4/Kq6M5KR3f5a8wOHqxK5Ff6wsvrIvK2xiyEB
         Jq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fcxCkiSjvbY+yKfLz7AdF0gJGV28srIrMcWeXXsq5W0=;
        b=Tbk/p+kzc6QRSXFKLl5zOhnyerSqF1s6wL2iRlum0JnRhqwyf3H3HHnPnTG//4Djbz
         fcoGEvOcjz0l/QB7DW439uSnYRkSnyqH7RSYPLZ0jXiTZ6YoTvbrh4o29Lqj0OJeOuvH
         Fe60Jgh2FMhTWP0xKuUfM4tCKE18ppFviTJpuB8sN0NPt5asKeYHgv/esNCZxzSgyrL7
         5qGQfJAyaHk11W7A6YowlWGltxwJpWJ/t4c4U7BKyoHyJ+r3cpBDjLVlf3uCciRm4w79
         dCjI8j1B0YUgXpNvxx1dEzCVpXMIh3lSsRbH0gUqbNru8B/wscoPHyQpycDgGiA7wVFD
         75mQ==
X-Gm-Message-State: AOAM530tD+mxMoY+EyElsRraFYvp4YRSwx8Rl6HkVi07qtEUkYnnzL9F
        nuG+ya+QEjJgrxtxSpWCXGI=
X-Google-Smtp-Source: ABdhPJwQfvCi9VgLMwVCBsZ6HsvU2A+/wyLnzib3s+dmp4ukZrz3aFQRhSTPcG8zpDZ878BxMbGCAw==
X-Received: by 2002:a17:90a:17cd:: with SMTP id q71mr3103170pja.52.1601648976843;
        Fri, 02 Oct 2020 07:29:36 -0700 (PDT)
Received: from Davids-MacBook-Pro.local (c-24-23-181-79.hsd1.ca.comcast.net. [24.23.181.79])
        by smtp.googlemail.com with ESMTPSA id r6sm2303806pfq.11.2020.10.02.07.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 07:29:36 -0700 (PDT)
Subject: Re: [PATCH] genl: ctrl: print op -> policy idx mapping
To:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>
References: <20201002102609.224150-1-johannes@sipsolutions.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <248a5646-9dc8-c640-e334-31e9d50495e8@gmail.com>
Date:   Fri, 2 Oct 2020 07:29:35 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201002102609.224150-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/2/20 3:26 AM, Johannes Berg wrote:
> diff --git a/genl/ctrl.c b/genl/ctrl.c
> index 68099fe97f1a..c62212b40fa3 100644
> --- a/genl/ctrl.c
> +++ b/genl/ctrl.c
> @@ -162,6 +162,16 @@ static int print_ctrl(struct rtnl_ctrl_data *ctrl,
>  		__u32 *ma = RTA_DATA(tb[CTRL_ATTR_MAXATTR]);
>  		fprintf(fp, " max attribs: %d ",*ma);
>  	}
> +	if (tb[CTRL_ATTR_OP_POLICY]) {
> +		const struct rtattr *pos;
> +
> +		rtattr_for_each_nested(pos, tb[CTRL_ATTR_OP_POLICY]) {
> +			__u32 *v = RTA_DATA(pos);
> +
> +			fprintf(fp, " op %d has policy %d",
> +				pos->rta_type, *v);

did you look at pretty printing the op and type? I suspect only numbers
are going to cause a lot of staring at header files while counting to
decipher number to text.

