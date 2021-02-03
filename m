Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FF30DF02
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbhBCQBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:01:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234574AbhBCQAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:00:25 -0500
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD275C0613ED;
        Wed,  3 Feb 2021 07:59:44 -0800 (PST)
Received: by mail-oi1-x22e.google.com with SMTP id j25so387955oii.0;
        Wed, 03 Feb 2021 07:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RZf+jXRC1zg2Z9IRrIoFkA2eIjLbll5JFXRnUlIpiqo=;
        b=l5qlacbsZBiiWjE3i5YNFVOPRDOyZHimq0dE3QWweI+nubjBpol7VquAjt4tpFOLJ+
         LzWskexd8f8cHWVHQWZr0zIU/w00qHipp8zauEc2dDXYvMEHea14DNzSxdYXkZzZq+s9
         ZMx3Ri7En5aEN2GzKlj+HOBWLFjHlaF9VDCmubTudOv/7QQxYgn1llNdkI7fdGHloBgf
         c3OUZ2KSvakX4MnXOYOIgpJweVJfKKO/QUAJLxbvHlElP8YCDuDodn9gNCrWbxVbl5nU
         5oancH8ZGVIrMXEv6gGuB4MMTeFtViQo0nGdDZhDxU+Uyt4vYwd5Vig07ir0zpKH7DTi
         y2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RZf+jXRC1zg2Z9IRrIoFkA2eIjLbll5JFXRnUlIpiqo=;
        b=rUmvPXbI98nORMQ1hJQQjNhGi1l2vWorNE8V1Vb/WhYxnZDBwsvSu0j0O2fMcuqbu4
         vW2v/dPxfVZMnRwJ5+U0/7CuE6YwTJHcaUPo1BNlxHHNfrUuJDUEMZ2hv9QdNNXKe6mz
         xqJBNRkw/s83hjJgB5i81I1T3J9BrPf39AHp9sje6nCSLh0cOLuDQcDarrefHqpTi33P
         VpqO2RQEG8oC7rdxVYexYHre7ke+GkfJlOFoV4SFAg52LnbUGm+xNxH+MTJArxMc+kpC
         h9iNdw8M7JEDMtRo8Y1UsWZSvQHDGpruIR4jX8kjBSL7vNt9Snb4oLO1b0IS2pd2DqME
         nyow==
X-Gm-Message-State: AOAM533Nd2778jvZZNcKYyrl2Tg1+DttFBrYnNnQ86K59PNqdsgFs9PJ
        yPLsOjTpL3uNIlOWwG5HCDNj37bJd2o=
X-Google-Smtp-Source: ABdhPJysjjkgjSdMNjO3DiUorN82v5DCgntF4JhDd7uo6II3Zc/inyz7ERLS0hqIzz+STl9v9fihrA==
X-Received: by 2002:aca:a894:: with SMTP id r142mr2207439oie.62.1612367984322;
        Wed, 03 Feb 2021 07:59:44 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id u81sm511841oia.49.2021.02.03.07.59.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 07:59:43 -0800 (PST)
Subject: Re: [PATCH net-next] seg6: fool-proof the processing of SRv6 behavior
 attributes
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@cnit.it>,
        Ahmed Abdelsalam <ahabdels.dev@GMAIL.COM>
References: <20210202185648.11654-1-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6fe3beb2-4306-11cd-83ce-66072db81346@gmail.com>
Date:   Wed, 3 Feb 2021 08:59:40 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202185648.11654-1-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 11:56 AM, Andrea Mayer wrote:
> diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
> index b07f7c1c82a4..7cc50d506902 100644
> --- a/net/ipv6/seg6_local.c
> +++ b/net/ipv6/seg6_local.c
> @@ -31,6 +31,9 @@
>  #include <linux/etherdevice.h>
>  #include <linux/bpf.h>
>  
> +#define SEG6_F_ATTR(i)		BIT(i)
> +#define SEG6_LOCAL_MAX_SUPP	32
> +

SEG6_LOCAL_MAX_SUPP should not be needed; it can be derived from the type:

    BUILD_BUG_ON(BITS_PER_TYPE(unsigned long) > SEG6_LOCAL_MAX)

The use of BIT() looks fine.
