Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3718048B17E
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343584AbiAKQBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243724AbiAKQBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:01:31 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D2AC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:01:31 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u8so23108726iol.5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J7odcFsD2ffntsQnWJM8fH9hLEbhboasUVJE+DSGKPQ=;
        b=cvD6UBnBZ7V/QnPGqmI+VyOzcWCKiZxLqTiU8AliS4fX+5fJNgFKX5HP5DeV/JWOIo
         fd3rULH0K5jLuQAfQ/Vnwd+Eq5BfumGXeUlR8q30VFpf/UMAi0EeM8J5vy+K+kB1vVYC
         dco6lOcn4ky+yWWkmvRq5+JL8x0y37iCUiAsBhyeLglk0goOs1n5TbSG+0ZhM3Rjr4Kp
         KeDKInWS1+qBag8xq607l2yRE8k2bboUQdOTKT+/4K6t+4hzdTW1e6S+qxoMYJYfxJEq
         TkfONkfQ/eF2ZXtBjbpFjn88/SsYzavqsr9oVRsVTQ6LMnLCXvg0LUAAc2WThvGvfmwq
         AvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J7odcFsD2ffntsQnWJM8fH9hLEbhboasUVJE+DSGKPQ=;
        b=TlRHsLjUpuaYN0AtAcgPqB7PlUeGadR4sUw0vm0K4V+Q41cJrbsVDIaG55A3mof+rc
         zD+OMuPI58222m7jMudg88W0kZ3QeZcjugmEk1RS7iy4H0rRAdK8eMOPKjoznV8LDTPs
         eV8PckdyHS06ZBYCOJQ1APvJHNH76rNtcumGYQn5JYLwS98dARp6V88ZhklmWKs1MSvn
         kpbB2Rvix8v0HeGxVGVx0ZuNiUU08iv47RJmxhFNYHkAQ3MsRDMW2m4UkS7lA0CAHNgI
         yqA6fTZbici1H9DKUC9NU0AsGPOwSGwdcU+qiK2Tz1Af0nMsX7+MDYCe1FwMwx4kPDXs
         VL6Q==
X-Gm-Message-State: AOAM532zVvRfF0JKBA8/oKgBz6m8hyhWXguCoxJ1HE/xyhh1iAaFYFkT
        JOXnITASWzkxl4UuU8vkpdw=
X-Google-Smtp-Source: ABdhPJwnvIY1cFDVo7QH+DkWexpJdnweYXPoztb5AuDAWftMbDGdguoDCXzSJhf8HRNUA0zYrXUl5Q==
X-Received: by 2002:a02:7747:: with SMTP id g68mr2648926jac.3.1641916891263;
        Tue, 11 Jan 2022 08:01:31 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d826:3ad7:a899:d318? ([2601:282:800:dc80:d826:3ad7:a899:d318])
        by smtp.googlemail.com with ESMTPSA id q6sm5994982ilv.65.2022.01.11.08.01.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:01:31 -0800 (PST)
Message-ID: <3e8fc2bd-b470-8ead-34f2-a5ef9e3ababe@gmail.com>
Date:   Tue, 11 Jan 2022 09:01:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH iproute2-next 06/11] nexthop: fix clang warning about
 timer check
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>, idosch@nvidia.com
References: <20220108204650.36185-1-sthemmin@microsoft.com>
 <20220108204650.36185-7-sthemmin@microsoft.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220108204650.36185-7-sthemmin@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/22 1:46 PM, Stephen Hemminger wrote:
> diff --git a/ip/ipnexthop.c b/ip/ipnexthop.c
> index 83a5540e771c..2c65df294587 100644
> --- a/ip/ipnexthop.c
> +++ b/ip/ipnexthop.c
> @@ -31,6 +31,8 @@ enum {
>  	IPNH_FLUSH,
>  };
>  
> +#define TIMER_MAX   (~(__u32)0 / 100)

UINT_MAX instead of "~(__u32)0)"

