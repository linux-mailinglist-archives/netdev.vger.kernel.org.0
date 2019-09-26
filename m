Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4125BBF55A
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 16:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfIZO6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 10:58:45 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36951 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfIZO6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 10:58:45 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so2002264pfo.4
        for <netdev@vger.kernel.org>; Thu, 26 Sep 2019 07:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5kTYjcyX88jvZthjDTeuqGQltWz5fcSaOi42osRORYE=;
        b=IGzZxz3dpZUMfBwectUFPyYkbLDRlXvNz93l+onHHRX4RKyZgR26QXBnj+veF8Hx31
         kJ5C5PWMkLRatEJoX4XWcEhcWaIT27KGQty3kOAzIIv0eewmctnXFdORuUu3dToWxp8F
         aO60+Qu6nFYm+YTkxkCa00BfrRBg0/c/ZClOgDh6HHYA0Ogy/yPOybRgS6r3UzjtS4Y9
         Kxyguc6q2uHDrctg/+QC9IUtgn6wXDh31NrGjOAnySpWueqWWTp5dwrShw5psxu7aNDi
         lee4jnT+UyjZvwPVwvFtrfwBCh8HRVp34Fs9l0CcE8GsDC2TAntrwJu33ADrMNQDJUqr
         moxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5kTYjcyX88jvZthjDTeuqGQltWz5fcSaOi42osRORYE=;
        b=sK8DUuPUH7btQrkaSse93CLgFihFWKcoiyTKhY4vLB6yFAKEyfWKYZz2hBvdc2Heyx
         3KesVsFHSRfSkAXNcww6cC+YrTGAwLzgJyKpHPvvctRiNwThRUk7yhP+KJ163SFD9/QW
         WWJTgEtdDOgOZ+b0bDXLv8fB3qx83ipx57aMsx0nWN29CyODnc4VFbKkGlHW379fEJAR
         PuutfrBZ1oOFlCQETywTskojUKFD2y2edbGk1B/1kkhHee8TbMqvmKY8hVBea3KkcV9h
         cQjIyRrF+/vNH2Aya9TEvIP14w2av1EATtpuJ8u5KfoEzYBp6GG9Qc7DuKHdCUMjflKc
         2FKw==
X-Gm-Message-State: APjAAAUXEOQW4vFCHWJ+U2ldyfz2XNsVy82FRojsXsYctzc9ZRcVnsPF
        isN1xrvYl4ycdiZ+qRWe6jM=
X-Google-Smtp-Source: APXvYqwigA9ocasnhuH071PCaz0BfvYEuVb0mh8BjXGX0ff7IeU2vsJMHPGtxx1h/HLtT7sX6rQEYw==
X-Received: by 2002:a63:4562:: with SMTP id u34mr3779030pgk.288.1569509925031;
        Thu, 26 Sep 2019 07:58:45 -0700 (PDT)
Received: from [172.27.227.146] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id 132sm2539128pgg.52.2019.09.26.07.58.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Sep 2019 07:58:44 -0700 (PDT)
Subject: Re: [PATCH iproute2(-next) 1/1] ip: fix ip route show json output for
 multipath nexthops
To:     Julien Fortin <julien@cumulusnetworks.com>, netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com
References: <20190924223256.74017-1-julien@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <bdc66f22-9403-c0fb-196a-360f212cd854@gmail.com>
Date:   Thu, 26 Sep 2019 08:58:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190924223256.74017-1-julien@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/24/19 4:32 PM, Julien Fortin wrote:
> diff --git a/ip/iproute.c b/ip/iproute.c
> index a4533851..5d5f1551 100644
> --- a/ip/iproute.c
> +++ b/ip/iproute.c
> @@ -649,23 +649,27 @@ static void print_rta_multipath(FILE *fp, const struct rtmsg *r,
>  	int len = RTA_PAYLOAD(rta);
>  	int first = 1;
>  
> +	open_json_array(PRINT_JSON, "nexthops");
> +
>  	while (len >= sizeof(*nh)) {
>  		struct rtattr *tb[RTA_MAX + 1];
>  
>  		if (nh->rtnh_len > len)
>  			break;
>  
> +		open_json_object(NULL);
> +
>  		if (!is_json_context()) {

With the fprintf removed in favor of print_string(PRINT_FP), you should
be able to remove this is_json_context() check and remove a level of
indentation for this section.

>  			if ((r->rtm_flags & RTM_F_CLONED) &&
>  			    r->rtm_type == RTN_MULTICAST) {
>  				if (first) {
> -					fprintf(fp, "Oifs: ");
> +					print_string(PRINT_FP, NULL, "Oifs: ", NULL);
>  					first = 0;
>  				} else {
> -					fprintf(fp, " ");
> +					print_string(PRINT_FP, NULL, " ", NULL);
>  				}
>  			} else
> -				fprintf(fp, "%s\tnexthop ", _SL_);
> +				print_string(PRINT_FP, NULL, "%s\tnexthop ", _SL_);
>  		}
>  
>  		if (nh->rtnh_len > sizeof(*nh)) {
