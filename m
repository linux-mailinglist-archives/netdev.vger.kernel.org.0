Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5336A48B179
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 17:00:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245745AbiAKQAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 11:00:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243724AbiAKQAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 11:00:31 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE7DC06173F
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:00:30 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id 2so10769112ilj.4
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 08:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Hy9t060FciVBY+fi9yd+UvqG/rTK89P2OSLI5hQnuoI=;
        b=qY9iV5lYaD4sgM9pdMgyWSODhRzE+VjSSvTigzZFn4INYhP0kCcXqoXxOADFHB5DNq
         9MXKn/oL0a/yuZ1djsbIm/iZvRof4vm9642kBWkaImlGqspniXel+0GvfGlOJG3fB9Nt
         2iEDWKKNE83w7I3lz51S0foX+BCkCBAMA4CMciXWL477DDUQK4akoLgBBEWq+JahhsXq
         Zm0Lx2V8z1mLdJlH4WaAWMw9uvXlmnTCUgUDNrexN2hgtdg8tE3Yo8RwmgcnMppZoD9A
         vDEMy/0MnpvZ6P1+Avj3R/T5hGbqJ4r6DhGzNg+wFx8DjFLoAMIRi2CUf4XhHiAOeEIQ
         UYLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Hy9t060FciVBY+fi9yd+UvqG/rTK89P2OSLI5hQnuoI=;
        b=yoCwcBVOZxotscc5sT8ElkV/+vf5vZOgYc1qIFsiPJ+2gqJoidoBKsMvbNyUW18aHD
         srU33ovg7NcyBCzkVPreFBx11WZ/o/sbSTX40uQ3ynikpp7Kzui1johcbwY+NJ5as+/R
         gw+aWZvARN2QhrBMcT/ie8Vzk0vDwSQoJd2RBwMvhCD6sDS5PXMIOegYr7IPjJccex09
         nbWKG/0FSAbvUp7StdnJAPteepHT9YmnF6vcLgHwO4DtW8GDszmSDmcS+cOSfpmRIeXy
         A85anQgaUOEbRV2Xaj0sQQn2bi5Nli2+sThghZwIoLZqM8hYAW9JaNwaKIoWSDNdQf1A
         a5lA==
X-Gm-Message-State: AOAM532PDpDqBOiqDIe5/UezJAcvrN1+pBtbgH0HivPlDqSusLFQslaS
        ptQiZ6mcX0jTemYUzjsxQf0=
X-Google-Smtp-Source: ABdhPJw7B6QHacel+3tvbk5x4Pwt/c3Zsso0q/e9WWml8gr6/7rlsUJjPJbQ/GE7XsmSpQIMjvw6ag==
X-Received: by 2002:a05:6e02:20e6:: with SMTP id q6mr2687498ilv.301.1641916830214;
        Tue, 11 Jan 2022 08:00:30 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:d826:3ad7:a899:d318? ([2601:282:800:dc80:d826:3ad7:a899:d318])
        by smtp.googlemail.com with ESMTPSA id g6sm3759455iow.34.2022.01.11.08.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jan 2022 08:00:29 -0800 (PST)
Message-ID: <a0f12df2-c914-0840-fd68-86c7de7a08b4@gmail.com>
Date:   Tue, 11 Jan 2022 09:00:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH iproute2-next 05/11] flower: fix clang warnings
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     Stephen Hemminger <sthemmin@microsoft.com>
References: <20220108204650.36185-1-sthemmin@microsoft.com>
 <20220108204650.36185-6-sthemmin@microsoft.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220108204650.36185-6-sthemmin@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/8/22 1:46 PM, Stephen Hemminger wrote:
> @@ -1925,10 +1925,17 @@ static int __mask_bits(char *addr, size_t len)
>  	return bits;
>  }
>  
> -static void flower_print_eth_addr(char *name, struct rtattr *addr_attr,
> +static void flower_print_string(const char *name, const char *value)
> +{
> +	print_nl();
> +	print_string(PRINT_JSON, name, NULL, value);
> +	print_string(PRINT_FP, NULL, "  %s", name);
> +	print_string(PRINT_FP, NULL, " %s", value);
> +}
> +

The last 3 lines could be a generic print_string_name_value function
under lib.


> @@ -2237,16 +2235,20 @@ static void flower_print_ct_mark(struct rtattr *attr,
>  	print_masked_u32("ct_mark", attr, mask_attr, true);
>  }
>  
> -static void flower_print_key_id(const char *name, struct rtattr *attr)
> +static void flower_print_uint(const char *name, unsigned int val)
>  {
> -	SPRINT_BUF(namefrm);
> +	print_nl();
> +	print_uint(PRINT_JSON, name, NULL, val);
> +	print_string(PRINT_FP, NULL, "  %s", name);
> +	print_uint(PRINT_FP, NULL, " %%u", val);

s/%%u/%u/ ?

Same here the last 3 lines could be a lib function.

