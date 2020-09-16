Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC24026CDCA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 23:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728640AbgIPVFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 17:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgIPQPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 12:15:01 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4A1C02C2B6
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 09:04:09 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z22so11100592ejl.7
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 09:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/MCv6kGzbCOa/DlsDScqqLMNRtWklF6jilIPECQzCg0=;
        b=Z9MjrknpOuPF+pqKLQzqZid8FW3zEaHnhoX5IP5NryC11gEwO7uLcWUhqVJxueC9W6
         7CyEpxmwOqnfqxe61a1+dIvuU7OnfHkNIofhb5es+kRTzdzNW0FeLmP3GTVpwKsqCAx9
         i/yxgS1SeMvI41chMQEFucT6tmbFzA5SyLmdZGcX8ThN3ccdXUQ0V2MbUttBhZ4aR/uG
         kTDaZX/9nNor4lMYTgCQTv4GahD7XgYuDxdC8I1g6Qdg9zarXeNsOCuXfRjOpkDCi5/h
         qT5Y31/7nfG6eQqQ4BRT9zXcgnZPcL68LubYbNrQEx0ABy/gIz0PExjwugqJxjUAo47o
         hPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/MCv6kGzbCOa/DlsDScqqLMNRtWklF6jilIPECQzCg0=;
        b=gXHw7ua97lBVJRHrh3VA+OG3KcW5qQ3LcEOvkPsJ9MtetDPOeqKpK0ZWQjpP73cKwt
         45UZnpiic0UvFAFSRFn6u2LyQ1LgSM6VWow7M5cFonIFVBwmDkj3mukPhfYbJGFq1H4p
         hFiYsS8qlg4Bzcy35mRmLdzci7cTrxDAlm3CDO+cuNAHBZEjxqmHkaXyrsjNMx/5KWrz
         nBfkJIi82cN8BoCQpdIQE4tMnnbmDtbq2eTNCUgisskmEHIZMPIk8O0IvpJbE9l/l+WX
         +Torw0tob7yHDd06R6vQOHh1ROAMt6nzawxB2Wv626q2n3t4W/KoJBAwwBuM7X8I4rua
         GcpA==
X-Gm-Message-State: AOAM533eOmq4sbQL9u65MZhCScPhu+KYiHrfeW0kI57dN2a+HtzGgPkK
        pLjuDf/+rQ5IhH3Dip4hgi2AWg==
X-Google-Smtp-Source: ABdhPJwnwOjURbFapQp8v5CLihCKN0iTNY+IAPC8bmYxQUARFNDKMn4DRN3DSrBLnjhBjmyMpFoO8Q==
X-Received: by 2002:a17:906:52c2:: with SMTP id w2mr26710730ejn.389.1600272247918;
        Wed, 16 Sep 2020 09:04:07 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id lc25sm13011774ejb.35.2020.09.16.09.04.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 09:04:07 -0700 (PDT)
Date:   Wed, 16 Sep 2020 19:04:04 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
        Jiri Olsa <jolsa@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Yauheni Kaliuta <yauheni.kaliuta@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200916160404.GA153139@apalos.home>
References: <20200914160355.19179-1-ilias.apalodimas@linaro.org>
 <20200915131102.GA26439@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200915131102.GA26439@willie-the-truck>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will, 

On Tue, Sep 15, 2020 at 02:11:03PM +0100, Will Deacon wrote:
[...]
> >  			continue;
> >  		}
> > -		if (ctx->image == NULL)
> > -			ctx->offset[i] = ctx->idx;
> >  		if (ret)
> >  			return ret;
> >  	}
> > +	if (ctx->image == NULL)
> > +		ctx->offset[i] = ctx->idx;
> 
> I think it would be cleared to set ctx->offset[0] before the for loop (with
> a comment about what it is) and then change the for loop to iterate from 1
> all the way to prog->len.

On a second thought while trying to code this, I'd prefer leaving it as is. 
First of all we'll have to increase ctx->idx while adding ctx->offset[0] and 
more importantly, I don't think that's a 'special' case. 
It's still the same thing i.e the start of the 1st instruction (which happens 
to be the end of prologue), the next one will be the start of the second 
instruction etc etc. 

I don't mind changing if you feel strongly about it, but I think it makese sense
as-is.

Thanks
/Ilias
> 
> Will
