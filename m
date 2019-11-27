Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA44610B334
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbfK0Q1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:27:06 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:40087 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726514AbfK0Q1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:27:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id ep1so10241992pjb.7
        for <netdev@vger.kernel.org>; Wed, 27 Nov 2019 08:27:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4ByurB3uoftNyPJxjg/pSE8HCA7AZ3lTy5lSUA2KW7Y=;
        b=kCYVJDHh9cGfWUw83DLpNyFKv0jWeuQ5l7Q+2za2z4YWcUGPVRtWvAW6SSlXyEljK4
         msHxl2JkG4w3j6igppemE5Nc6G0zJC56TsrrArjR9QLKMAR9PISMBRumsNp0oX3IwyPB
         lvtHJb4/bNFcF04mQopUVl6D9pup2xNBfxWMPMpAPX6337P4ZymX+igVsegcY6zkzKfC
         xqSgujTBqevWleJGQpJ+PPZ3V2Pnd8gcZnHT2NDJpy6CvSrZJcV4TiAlg1/wOmDA77Nz
         SMEnn0oxMFtjnjdMfQEfyiGmOTdvUp7YQeTeawSNsOTmwSwUFZREEcZvJmyhIocD66c+
         x00A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4ByurB3uoftNyPJxjg/pSE8HCA7AZ3lTy5lSUA2KW7Y=;
        b=AyFQFc8vx3v3gOIbMbbUZKViHtuCUx3KycTNnb6Bhrf+3pIPL92rkHjE7hpvPnExqM
         WLVy3hckxrnzVq5qIhH0R7VaTJpNLWInnaqP/JjISjAEcq5bNJeklF9sjlqr1aRzwUaB
         HbNE7AVeXZ/uCH6ISxv5RDp1fmqvdwG8idVP1Q3NQdiF/zEoic89X+T1BbTtE0L6m43K
         8uIIy1Drk3Y+Zt0vKlCAaHZPJOlceQyi0CUX2A1vQAJ+b68QHQmw++op7fm53HUOJD5e
         NwYbiO/dxtcYfCv0aUQdLRClMzc/mHviIEeQRk2gc6y+I7NnDhXVf1UwrMi3Lie7DCUX
         RaCA==
X-Gm-Message-State: APjAAAV5lDDIAudGAmEv3e6H2ipr1XQT9ckXxcoow5WoHn3LdNrFH7Rq
        7yO3UJ+9JGMgpAt0rE8KSUpAEQ==
X-Google-Smtp-Source: APXvYqxp4T93/VXLqJNIlxzJVxfykqTTUZXednnjdSQV+nodrBzYcEThf4CP0uGDOeqMrXvrp4e6eQ==
X-Received: by 2002:a17:902:a718:: with SMTP id w24mr5127139plq.268.1574872024452;
        Wed, 27 Nov 2019 08:27:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 81sm764800pfx.73.2019.11.27.08.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Nov 2019 08:27:04 -0800 (PST)
Date:   Wed, 27 Nov 2019 08:26:55 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Maciej Zenczykowski <maze@google.com>, netdev@vger.kernel.org,
        Leslie Monis <lesliemonis@gmail.com>
Subject: Re: [PATCH iproute2] tc: fix warning in q_pie.c
Message-ID: <20191127082655.2e914675@hermes.lan>
In-Reply-To: <20191127052059.162120-1-brianvv@google.com>
References: <20191127052059.162120-1-brianvv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Nov 2019 21:20:59 -0800
Brian Vazquez <brianvv@google.com> wrote:

> Warning was:
> q_pie.c:202:22: error: implicit conversion from 'unsigned long' to
> 'double'
> 
> Fixes: 492ec9558b30 ("tc: pie: change maximum integer value of tc_pie_xstats->prob")
> Cc: Leslie Monis <lesliemonis@gmail.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tc/q_pie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tc/q_pie.c b/tc/q_pie.c
> index 40982f96..52ba7256 100644
> --- a/tc/q_pie.c
> +++ b/tc/q_pie.c
> @@ -199,7 +199,7 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
>  	st = RTA_DATA(xstats);
>  	/*prob is returned as a fracion of maximum integer value */
>  	fprintf(f, "prob %f delay %uus avg_dq_rate %u\n",
> -		(double)st->prob / UINT64_MAX, st->delay,
> +		(double)st->prob / (double)UINT64_MAX, st->delay,
>  		st->avg_dq_rate);
>  	fprintf(f, "pkts_in %u overlimit %u dropped %u maxq %u ecn_mark %u\n",
>  		st->packets_in, st->overlimit, st->dropped, st->maxq,

What compiler is this?
The type seems correct already.  The type of double / unsigned long is double.
And the conversion may give different answer.
