Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC77C8BE97
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 18:30:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfHMQaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 12:30:02 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33812 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbfHMQaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 12:30:02 -0400
Received: by mail-qt1-f195.google.com with SMTP id q4so9772240qtp.1;
        Tue, 13 Aug 2019 09:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/VHUk0Na3pabcbPoafogmgyB5m9h0GsXcPdzV1TbskI=;
        b=i4VALp7bojpdMy3xzDOAj1vDaX53UAuKE36tCCVJN2dlvDCrdxLIlJWn65bn0FD5bf
         0eWaHfDB6Oteq+8jm1+ZonbboEWaI1RBmtiFWT0J+YWQY4wqtLDwN7hWK+/KugvvtKD2
         BhbLRluehQbaiBCsDsizrKzfZC4YPeHU8bKs/1LKhpp2urMcpmQ4ARS+Xpgu91vbzi2O
         9Uv0L2xic9+2FB466SuKoFecJlvsogUulOy1nyCAKTiODUyUuImyaj0PbjRlGxU/ppLu
         hCBtp1fvl3EnBKe5tJvBzcaBnsiAYNhp/SYfttsq4mwKnk9y0WdyfgV9YKGI4mKPKGtm
         QtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/VHUk0Na3pabcbPoafogmgyB5m9h0GsXcPdzV1TbskI=;
        b=aaKVJk2grHdDpDMBwTq5VlLS86eF7qZm0uBEBqLQeGYkFug9yOHKqA1oFwlJJxteoT
         g2rImKA79Rjnk9x5V3RlmQg0b32KM/jgwdyok41Ei3JNnUWnJ3iRMOu9tO9crXqzw9KA
         MpW8trNfOhDnV5zl2Sr5EDdbQIl8uqgqELj+g7IsJw1fi8+0j4wn4ksfwFemg8KMdOIO
         aA4Fvt77T/HI3tKWFZJ59z9DBza0/fD485X1QtiWukg0K9iJ27zOMd53JFLBpX6NwkEK
         bHRrwwwkL6DEgUbewB5tRoLQmnuwmKP1eGeRIrC8sE5d1ZuwdHJV2lZi1TI1o8g/WL9N
         uotg==
X-Gm-Message-State: APjAAAWXi/4St6QXvHprKNtS3jaob8HHaIu57QHUvSaDZ2mhGJ/Iy3FJ
        /wMIHA+QcTv46su+j1q08nOShg35
X-Google-Smtp-Source: APXvYqzkPAnxQdHjNRPxh4eRNT0pIuYBxvpCbb2CQNMV9PuPG0gIJD+EqFjwl3ZBn6f9YTIAFpxveA==
X-Received: by 2002:ac8:6146:: with SMTP id d6mr13084893qtm.36.1565713801506;
        Tue, 13 Aug 2019 09:30:01 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:1583:6f3d:1442:4bd6:4652])
        by smtp.gmail.com with ESMTPSA id g28sm5372051qte.46.2019.08.13.09.30.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 09:30:00 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 83F7AC1628; Tue, 13 Aug 2019 13:29:58 -0300 (-03)
Date:   Tue, 13 Aug 2019 13:29:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, davem@davemloft.net,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        yi.zhang@huawei.com
Subject: Re: [PATCH] sctp: fix memleak in sctp_send_reset_streams
Message-ID: <20190813162958.GB2870@localhost.localdomain>
References: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1565705150-17242-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 10:05:50PM +0800, zhengbin wrote:
> If the stream outq is not empty, need to kfree nstr_list.
> 
> Fixes: d570a59c5b5f ("sctp: only allow the out stream reset when the stream outq is empty")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: zhengbin <zhengbin13@huawei.com>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  net/sctp/stream.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index 2594660..e83cdaa 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -316,6 +316,7 @@ int sctp_send_reset_streams(struct sctp_association *asoc,
>  		nstr_list[i] = htons(str_list[i]);
> 
>  	if (out && !sctp_stream_outq_is_empty(stream, str_nums, nstr_list)) {
> +		kfree(nstr_list);
>  		retval = -EAGAIN;
>  		goto out;
>  	}
> --
> 2.7.4
> 
