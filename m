Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4397326919F
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 18:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgINQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 12:33:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgINQCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 12:02:21 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107F8C06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:02:06 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id t10so267933wrv.1
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 09:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=n6LtCGvrAXE3QiE4qfJQGgn89kMaY1QEsIyHXiYtTTc=;
        b=uMO0rA52/BJZa3hesvspLsRNPKOgvDHB48G3FFPOnOTHBvO/7rzHvbZH+I+ezWRfER
         gGgQ5y/XC6V89t9/Cnj0yTvVFYqa6YvbsNVA/4QPyivhzcUj6JdwA3IZpyMJrpBO6EFj
         RIXJMmdGYuChKvDCXMTRC6UAL3aHZHAi4LIWcQ/UYrymAp9TxuevXWznP3BcpYb6mpu4
         BhL9hIZUOeg/xF6oeIJr/pByUK6pVGXKdkctS3rVaFPczGwl5CmdAhihkzkrSDzQHasD
         Cv9ebamJkPytXiJLcbdH3bmbaAa1hgqXzVeH4C3gixvhKmpVX10AZXpvmHt3fxzpriPk
         nDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=n6LtCGvrAXE3QiE4qfJQGgn89kMaY1QEsIyHXiYtTTc=;
        b=ciF6gWAgsKxZFzLfU+og8YCqpgI3KURLqBvpr/5o5YlAmzd0R7KIFQVb/dSBEUeQzj
         64oYNgq1yzTH4/g8MlCIudk806i+crI/IDFGtBi32BTAnUPJFvE6fdrYImzBHDXR3ODY
         3+fIYd4bj1iRt0mjaTBfYXUdxdaDddEJj1s7xCsPfUgBAMJnCVwCRPLSxzjgg2TW8lNW
         KGyzq/1ropNTou5T8wLp7Bzzh1fWyGdZjy/nD0pmVRe3l/tb9gh7ob9vz6vkbL/So/Wy
         k4v1pShNeZCc4wc9C+fECspbQFHCjerbJ2xY1S7sXgQMI964QIg68Uv1B2C1nV+9rJ4g
         Y/sA==
X-Gm-Message-State: AOAM5336BKmRTXOsxpA+rPYBKjuDpi/R9iwD53x5L04O36WwdwT2iN/8
        nV8YJibt4v5LTY/6aPKvfI38hg==
X-Google-Smtp-Source: ABdhPJxrxx4pHXAatCaTpLx0Z01e1J3C6ex7zab4CjGtNT/uGp91v/25pIPlvN+Y7kD/f3mo80j7AA==
X-Received: by 2002:a5d:4c90:: with SMTP id z16mr17678413wrs.170.1600099324621;
        Mon, 14 Sep 2020 09:02:04 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id v204sm20508924wmg.20.2020.09.14.09.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 09:02:04 -0700 (PDT)
Date:   Mon, 14 Sep 2020 19:02:00 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     bpf@vger.kernel.org, ardb@kernel.org, naresh.kamboju@linaro.org,
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
Subject: Re: [PATCH] arm64: bpf: Fix branch offset in JIT
Message-ID: <20200914160200.GA19026@apalos.home>
References: <20200914083622.116554-1-ilias.apalodimas@linaro.org>
 <20200914122042.GA24441@willie-the-truck>
 <20200914123504.GA124316@apalos.home>
 <20200914132350.GA126552@apalos.home>
 <20200914140114.GG24441@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200914140114.GG24441@willie-the-truck>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Will,

On Mon, Sep 14, 2020 at 03:01:15PM +0100, Will Deacon wrote:
> Hi Ilias,
> 

[...]

> > > > 
> > > > No Fixes: tag?
> > > 
> > > I'll re-spin and apply one 
> > > 
> > Any suggestion on any Fixes I should apply? The original code was 'correct' and
> > broke only when bounded loops and their self-tests were introduced.
> 
> Ouch, that's pretty bad as it means nobody is regression testing BPF on
> arm64 with mainline. Damn.

That might not be entirely true. Since offset is a pointer, there's a chance
(and a pretty high one according to my reproducer) that the offset[-1] value 
happens to be 0. In that case the tests will pass fine. I can reproduce the bug
approximately 1 every 6-7 passes here.

I'll send a v2 shortly fixing the tags and adding a few comments on the code,
which will hopefully make future reading easier.

Cheers
/Ilias
