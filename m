Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7278F3D840F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 01:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbhG0XbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 19:31:09 -0400
Received: from mail-pl1-f177.google.com ([209.85.214.177]:35355 "EHLO
        mail-pl1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbhG0XbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 19:31:08 -0400
Received: by mail-pl1-f177.google.com with SMTP id f13so440557plj.2;
        Tue, 27 Jul 2021 16:31:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cfNumURh2GjYDfPowtmTPayG3eiC6vg99u71kmeqTyM=;
        b=P4HQ5+Qmq+0csMAsEg9nhirA44nQPKj6isxmK94eq8Gdqr/TXHQADqlWvUzrCr0eHG
         5mC/8fdAp1zsISBAQmzzkYoKjXQAp2GE+CaXd+HOc4C0lktHXgdg8Dc+lnOhNxGzCnPN
         Eg0TAB05T+5Y18lYA8ofHhhbm2GpQIGbewxLzcoa/l8mVrU2cDE1FgH2YKDzZHPwJVIw
         IlNeLO+omVC2/s6HtnGZSDrqd7rPF6zVC9Eq1ZfVBEN8LCsKsmWFzQG5198eNHMRl/lT
         Ufde+Y27nYfDbp+jzayTCfNynJVzQCvUU+P7fJKRvk4yYToqgrz3EX+0A3tT6k5Ij04z
         tSfg==
X-Gm-Message-State: AOAM533ynIv4XmZhecCMMNBF+578d5x4pIjL/AHWHJdA4EGdFp3qPau0
        /8+dbVrhNdLjVLfGXB0KV5M=
X-Google-Smtp-Source: ABdhPJxjlXDVaN8+tg1bxudbyKmetnxeWdVqGkL064ebMKIBrwhnuUBgPMqLVVo86W/q+KmaVUhOyQ==
X-Received: by 2002:a17:902:8493:b029:12c:552f:1fb1 with SMTP id c19-20020a1709028493b029012c552f1fb1mr2088759plo.26.1627428666440;
        Tue, 27 Jul 2021 16:31:06 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:f8ef:f6a:11cc:887d? ([2620:0:1000:2004:f8ef:f6a:11cc:887d])
        by smtp.gmail.com with ESMTPSA id j12sm4695249pfj.208.2021.07.27.16.31.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Jul 2021 16:31:05 -0700 (PDT)
Subject: Re: [PATCH 33/64] lib: Introduce CONFIG_TEST_MEMCPY
To:     Kees Cook <keescook@chromium.org>, linux-hardening@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Keith Packard <keithpac@amazon.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-staging@lists.linux.dev, linux-block@vger.kernel.org,
        linux-kbuild@vger.kernel.org, clang-built-linux@googlegroups.com
References: <20210727205855.411487-1-keescook@chromium.org>
 <20210727205855.411487-34-keescook@chromium.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <9827144a-dacf-61dc-d554-6c69434708de@acm.org>
Date:   Tue, 27 Jul 2021 16:31:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210727205855.411487-34-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/27/21 1:58 PM, Kees Cook wrote:
> +static int __init test_memcpy_init(void)
> +{
> +	int err = 0;
> +
> +	err |= test_memcpy();
> +	err |= test_memmove();
> +	err |= test_memset();
> +
> +	if (err) {
> +		pr_warn("FAIL!\n");
> +		err = -EINVAL;
> +	} else {
> +		pr_info("all tests passed\n");
> +	}
> +
> +	return err;
> +}
> +
> +static void __exit test_memcpy_exit(void)
> +{ }
> +
> +module_init(test_memcpy_init);
> +module_exit(test_memcpy_exit);
> +MODULE_LICENSE("GPL");

Has it been considered to implement this test using the Kunit framework?

Thanks,

Bart.


