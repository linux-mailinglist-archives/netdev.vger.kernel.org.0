Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EA9215DF2
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgGFSHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbgGFSHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:07:09 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81419C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:07:09 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m22so8370964pgv.9
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9uwQy4/tC+lLX+MBnk9iZjkpDMyb0sfwbddjhXtzuog=;
        b=ykNUKrZNO/GYkVLM6mhfBPuu6hyiVFGNL9lkp3i1UeSFjfvkyBfEltHrUqysvHFmBM
         FKPtbzSMNN0K8UBLlkivTwLF5uf5k4xL5R5mf959ilaPn9/a/gXE4Bcy8/OFaUc25xGP
         tWMDKxLhESt0shMqhe6j+5/urXTwEgPIZezsJrQLqVfCzzoDaoHBvK6UZzuC6pW3Fg9d
         UpsV9I76ksvq06Wj1b5VuMXSlic1nK3oCKrBHcJcQxqHvDIT0/g9hq5/icnSTJm7pfht
         25iswk5xn019KItloAihGAz2yOkSc6UZK2qCVDnEFpqetgK+uw11llH8KrqfOWSJvqW9
         VADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9uwQy4/tC+lLX+MBnk9iZjkpDMyb0sfwbddjhXtzuog=;
        b=tr9HGN34WsCjQPUh6Vnorc/1thTLcWdfptioCU1M78Tp91215qAZuI4rOYOOIv/v3N
         VqiGteRezylrUb3jYuMY5NazMWzI+V/1ZH3m54mWPGObQTaskQrbKbii5LT2GjhwFepP
         Z/iN6SrCrSmcuywqiyZAmRHtQfMUi9PJQSyK/xcD+8yxmVGqYRxQTHk2dkqT26Ea5KrU
         lMfBj+6pPEcUC6J/URNNdop7DShyYYTXSr3jxkcW6D9l0CRj4gsdh/np0FpwA8F2y4vS
         MMr5oD+YY1EV/kHyuLaoAHnQvbqEgmVP8xeRuZPiQrAFS7dZFyWjZOwzaxQYOEqS6UJD
         S/GQ==
X-Gm-Message-State: AOAM53170oVXghn7+oilc1xYxUtn1e9mavmR+K5BnpWaGk97AMkbEUhx
        b97m6XJ4ckoFOPOhw3y0GsH+cw==
X-Google-Smtp-Source: ABdhPJxcdxM9vSUod0eYj9tLOI1GYL9PnmPpG1mDkEOW9W3FCFHrWWjpuQhZqJx1TaHoUSvMACHw0A==
X-Received: by 2002:a62:7e90:: with SMTP id z138mr43607263pfc.292.1594058829073;
        Mon, 06 Jul 2020 11:07:09 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n11sm19443951pgm.1.2020.07.06.11.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:07:08 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:07:05 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dmitry Yakunin <zeil@yandex-team.ru>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next v2] lib: fix checking of returned file
 handle size for cgroup
Message-ID: <20200706110705.2d5feb99@hermes.lan>
In-Reply-To: <20200705161812.45560-1-zeil@yandex-team.ru>
References: <20200705161812.45560-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Jul 2020 19:18:12 +0300
Dmitry Yakunin <zeil@yandex-team.ru> wrote:

> Before this patch check is happened only in case when we try to find
> cgroup at cgroup2 mount point.
> 
> v2:
>   - add Fixes line before Signed-off-by (David Ahern)
> 
> Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")
> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  lib/fs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/fs.c b/lib/fs.c
> index e265fc0..4b90a70 100644
> --- a/lib/fs.c
> +++ b/lib/fs.c
> @@ -148,10 +148,10 @@ __u64 get_cgroup2_id(const char *path)
>  					strerror(errno));
>  			goto out;
>  		}
> -		if (fhp->handle_bytes != sizeof(__u64)) {
> -			fprintf(stderr, "Invalid size of cgroup2 ID\n");
> -			goto out;
> -		}
> +	}
> +	if (fhp->handle_bytes != sizeof(__u64)) {
> +		fprintf(stderr, "Invalid size of cgroup2 ID\n");
> +		goto out;
>  	}
>  
>  	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));

Applied, thanks.
