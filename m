Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6072F2BBAA
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 23:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfE0VU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 17:20:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41466 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726772AbfE0VU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 17:20:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id d14so1896262pls.8
        for <netdev@vger.kernel.org>; Mon, 27 May 2019 14:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=40aJElXopBegwzQ8ePRCnoFLtpNJc5rE4Ki98H/K1kU=;
        b=NPKhxVwWIJx1LBNcBDtLUSddXV3ry9beJwFVJ2YMKrSq1tDX95FVXmKdbkjTxdZI65
         k/Ig9dYusogLBmCK5MHijRT3qmVmtwUjOLaOAtjQXrfFUIw06exZ4/dTMKIB5zh8iiFW
         gHunJ6toz742yaS/xOYA/pM+4+/bKfwphM5YufcAwCrF/0ra9kH8RzsRQZVk3Q8FZi7D
         ThtbNC/duHrziFlzWz8WqCIvla8AZItOYDe8aq/9rZMCQvUzEpr6BZ5sXr3U0NwwoozQ
         zEsdyNIatSoyweoCvhD5VCgaMa2xssIKzv92fZeqix3IpSV7gF/b92VGQMKdo9eLReQp
         o+7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=40aJElXopBegwzQ8ePRCnoFLtpNJc5rE4Ki98H/K1kU=;
        b=d3/0Y0LgXycMrNwOIg/VveRClsQEy9/8y0aUrmoD47+SI6FOluqj1RlFFY2vPssDSL
         p4YmvHE4pZGvScuFZ8j2HwkYM+oWEPL2khk6olbHIjw0+D1rqiZX1p6uT3qn0tCW9qEJ
         5qMQa0Y/rUzM8F06bvyJ39gz2nXpoylv+t0w0RMvQgHvUy1mcEVqqLAiNh6H3mA3TQBL
         yt9U8WAEfTEvaHMN6ZVf2EhpHu4hgAzhh1WUipDoQAVGByCfddwzDFTjjq8S1Kxn60ra
         +i/zfgq4Nb260lchfomjAKHu4UkU/LBY7QYpMC4deW9nIdKBrWwizcl2nkMDQ6oeWSzr
         pdCg==
X-Gm-Message-State: APjAAAXcmaNTizJouAoMASFvckAN8DzypfVM5fZ1IJ0k1qTVkMPclD8U
        blH2Ixt4NScbuXvD2KZ6w41/gg==
X-Google-Smtp-Source: APXvYqxjDmo6wDOGUSnTI0w7VelrYirVcIj/BheUlfjtmSE5nkCUUQJ1ZacRrKocZr/TJmNDzlc3cQ==
X-Received: by 2002:a17:902:324:: with SMTP id 33mr131102396pld.284.1558992028676;
        Mon, 27 May 2019 14:20:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t24sm10900074pfq.63.2019.05.27.14.20.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 May 2019 14:20:28 -0700 (PDT)
Date:   Mon, 27 May 2019 14:20:26 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] macvlan: Replace strncpy() by strscpy()
Message-ID: <20190527142026.3a07831f@hermes.lan>
In-Reply-To: <20190527183855.GA32553@embeddedor>
References: <20190527183855.GA32553@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 May 2019 13:38:55 -0500
"Gustavo A. R. Silva" <gustavo@embeddedor.com> wrote:

> The strncpy() function is being deprecated. Replace it by the safer
> strscpy() and fix the following Coverity warning:
> 
> "Calling strncpy with a maximum size argument of 16 bytes on destination
> array ifrr.ifr_ifrn.ifrn_name of size 16 bytes might leave the destination
> string unterminated."
> 
> Notice that, unlike strncpy(), strscpy() always null-terminates the
> destination string.
> 
> Addresses-Coverity-ID: 1445537 ("Buffer not null terminated")
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  drivers/net/macvlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 61550122b563..0ccabde8e9c9 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -831,7 +831,7 @@ static int macvlan_do_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	struct ifreq ifrr;
>  	int err = -EOPNOTSUPP;
>  
> -	strncpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
> +	strscpy(ifrr.ifr_name, real_dev->name, IFNAMSIZ);
>  	ifrr.ifr_ifru = ifr->ifr_ifru;
>  
>  	switch (cmd) {

Why not use strlcpy like all the other places IFNAMSIZ is copied?
