Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 110332AC769
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731113AbgKIVh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbgKIVh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:37:58 -0500
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA521C0613CF;
        Mon,  9 Nov 2020 13:37:58 -0800 (PST)
Received: by mail-oo1-xc42.google.com with SMTP id n2so2577364ooo.8;
        Mon, 09 Nov 2020 13:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CBhEbY55GvoyWLo7De/5FKMUIfW7OO/Mruol6kaIJiU=;
        b=f4s1ru9pV+ydVFEF0HvX5PScHHd8fetW1HnynSoytG7jm5zBRo28CfU989DTYRNlRV
         tIpL7Lcw43+RgE3EDRGRg7N7OUS9giGHoZAr818CA3U07bJjw0CqbXyG+WRgh/QFfeRv
         SDVXMP+qQbja4Q1zzhvftBXhrXTdswj+QrRDFwQe3k9a/JkNG/K85rMNgdXPdCy1jl0x
         VaZjQn918/8ED/gNzZxrrf4j/VtLchfUND7YQdkcclNYmlE3dAaZwnAZLihidEHWB1aL
         vGFwGtbp4N/IS7cfMoEATaSwagvx4V/HKdN+1sDgne4ZeJb7o1qbJQqxwyyV3GK1PCEr
         +g3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CBhEbY55GvoyWLo7De/5FKMUIfW7OO/Mruol6kaIJiU=;
        b=uWNiIjewzsnOfgrliQNIiGbKFDTgSJkq78VovJbyC5uXWJOuPKYyh3OokfPhqFWMx7
         FxyY8lWAZAb8j7Ive/Jdk2L2jxihMmRpDh2wwfZvDpXofyksa3sCtJgIrUh3/BhxiXT3
         EYghrhE9MJSjp4eknNhK6jFEmPs8BUKkmnCfnUwEnPz716toGv5bMLRYnZD9P2zOiKR4
         cjPZmdBoLZfvIjmKXYjf/7GwYv8w7WeTk30LhtbMUpVvuu53ze7s56kfKP/7M0kkZcLG
         EbZ8w+7FU6k5aq86VzS/kEZp93/NHbyu8omzeFEJkBQaur0+cT+/J1aso5szTVpNeKXX
         NQ6g==
X-Gm-Message-State: AOAM531jYd66DpgXsaxuWHRXFDxSriZLZ79Yk/QX7Nw344+K/45r6Ygs
        nm9NrCy6PKIQ8p5nSdr97OA=
X-Google-Smtp-Source: ABdhPJyUJIDYdtrWkHhQWE7ms4W9iXZfny2TK6qj8Va+PUGa1Z3uY/RUuW6Ws2JCvkUdPiYxC0V1DQ==
X-Received: by 2002:a4a:e93a:: with SMTP id a26mr11550726ooe.58.1604957878171;
        Mon, 09 Nov 2020 13:37:58 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b13sm1534415otp.28.2020.11.09.13.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:37:57 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:37:50 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Michal Rostecki <mrostecki@opensuse.org>,
        Wang Hai <wanghai38@huawei.com>, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andrii@kernel.org, john.fastabend@gmail.com,
        kpsingh@chromium.org, toke@redhat.com, quentin@isovalent.com,
        danieltimlee@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <5fa9b6ae893bf_8c0e20825@john-XPS-13-9370.notmuch>
In-Reply-To: <3b07c1a3-d5cf-dfb4-9184-00fca6c7d3b1@opensuse.org>
References: <20201109070410.65833-1-wanghai38@huawei.com>
 <3b07c1a3-d5cf-dfb4-9184-00fca6c7d3b1@opensuse.org>
Subject: Re: [PATCH bpf] tools: bpftool: Add missing close before bpftool net
 attach exit
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Michal Rostecki wrote:
> On 11/9/20 8:04 AM, Wang Hai wrote:
> > progfd is created by prog_parse_fd(), before 'bpftool net attach' exit,
> > it should be closed.
> > 
> > Fixes: 04949ccc273e ("tools: bpftool: add net attach command to attach XDP on interface")
> > Signed-off-by: Wang Hai <wanghai38@huawei.com>
> > ---
> >   tools/bpf/bpftool/net.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
> > index 910e7bac6e9e..3e9b40e64fb0 100644
> > --- a/tools/bpf/bpftool/net.c
> > +++ b/tools/bpf/bpftool/net.c
> > @@ -600,12 +600,14 @@ static int do_attach(int argc, char **argv)
> >   	if (err < 0) {
> >   		p_err("interface %s attach failed: %s",
> >   		      attach_type_strings[attach_type], strerror(-err));
> > +		close(progfd);
> >   		return err;
> >   	}
> >   
> >   	if (json_output)
> >   		jsonw_null(json_wtr);
> >   
> > +	close(progfd);
> >   	return 0;
> >   }
> >   
> 
> Nit - wouldn't it be better to create a `cleanup`/`out` section before 
> return and use goto, to avoid copying the `close` call?

I agree would be nicer.
