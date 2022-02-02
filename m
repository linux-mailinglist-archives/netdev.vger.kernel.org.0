Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89D1E4A7884
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 20:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346851AbiBBTKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 14:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiBBTKF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 14:10:05 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F3C061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 11:10:05 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id n17so310103iod.4
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 11:10:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZG2fv/wNTddSyPwS5YTgg3gaHN64dRAzo+uGL8oKAKI=;
        b=dgWOOjxLJVAEgS/M0ZFjqWIyVjoCzEDDMKAysugOvEkfox+EuEICgzMUGFQln9hWKX
         +xXjWYaD1o2sruXW+za7N+7OR7nIE4v6+CvqSZcwVDKFucRmf6Mkc14N0RmQXbOP6DIk
         Kn44fHWMirXvHbMGaUlCPUHwAlE5Mvquivy5YnfvgIebFdXUQNfjgd2DOlF8QSOqoLNQ
         etimORBG+y3sKS23pYSgv2Sv+keDgFEDI/ytSY9sbQBcvskhMc9+Vh6Dl7VL9Pp7Cr7D
         8WwgkfAfQSUSP7803DOzkIWjH7FtLS4vRgaFFblS/nB+FSsrtq/PCosOQ/2pb0EkzW6e
         IUeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZG2fv/wNTddSyPwS5YTgg3gaHN64dRAzo+uGL8oKAKI=;
        b=XTfwIYwDx9rI9oEQnN0ASDkwt+0eu0OqWFPLzg8ZBRyOLDJq6OnQqVZoulXxrPpxfQ
         RIcYscFQg088VZMkPGGeJ7hjVXePlcQ+x+nNPY9L1u1CXOLI74TIDnmSn6r38wn6kjQz
         wwWJ5EM0S1KiNh739ysOCh/J0KPVrDXAKq5ItYrI+4/dpGniob5od2oLekEqGd72aTpD
         GlUKrc8uLmc6HNQkP3bvDz5Q+kSWlJiqFtqpzz7NU/f3W5EMZL8PjlXmoTy/GGMnWNto
         Qo4IwPlppDaS0xtCOVyfb6IU+BE3eFb3t1ZUYC1hQib64vBhuF8JTc3fHUARHY6jstrU
         +eMg==
X-Gm-Message-State: AOAM530BlFP5RhhA7DhUlxyvWUnlw0M6kbXxPW2aB11VrGMVJq0ZYN7z
        TPtIWYvbjrcrDH+Ea7Dasco=
X-Google-Smtp-Source: ABdhPJzgOMdTCsRdbDcQlqZoPUKX30SODR2/zsx/nBNvw9Vzby2R3X8wcyuD3D1TILJobIhuYS05BA==
X-Received: by 2002:a05:6602:2d95:: with SMTP id k21mr17768852iow.201.1643829004778;
        Wed, 02 Feb 2022 11:10:04 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:8870:ce19:2c7:3513? ([2601:282:800:dc80:8870:ce19:2c7:3513])
        by smtp.googlemail.com with ESMTPSA id t15sm2789288ioj.24.2022.02.02.11.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 11:10:04 -0800 (PST)
Message-ID: <c40e7fc2-e395-6999-9967-3e76e0bcfd3f@gmail.com>
Date:   Wed, 2 Feb 2022 12:10:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH iproute2] lib/bpf: Fix log level in verbose mode with
 libbpf
Content-Language: en-US
To:     Paul Chaignon <paul@isovalent.com>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Hangbin Liu <haliu@redhat.com>
References: <20220202181146.GA75915@Mem>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220202181146.GA75915@Mem>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 11:11 AM, Paul Chaignon wrote:
> diff --git a/lib/bpf_libbpf.c b/lib/bpf_libbpf.c
> index 50ef16bd..bb6399bf 100644
> --- a/lib/bpf_libbpf.c
> +++ b/lib/bpf_libbpf.c
> @@ -305,7 +305,7 @@ static int load_bpf_object(struct bpf_cfg_in *cfg)
>  
>  	attr.obj = obj;
>  	if (cfg->verbose)
> -		attr.log_level = 2;
> +		attr.log_level = 1;
>  
>  	ret = bpf_object__load_xattr(&attr);
>  	if (ret)

ip and tc do not have verbosity flags, but there is show_details. Why
not tie the log_level to that?
