Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA42367C45
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 00:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfGMWmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 18:42:33 -0400
Received: from mail-io1-f45.google.com ([209.85.166.45]:42199 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbfGMWmd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 18:42:33 -0400
Received: by mail-io1-f45.google.com with SMTP id u19so27945062ior.9
        for <netdev@vger.kernel.org>; Sat, 13 Jul 2019 15:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pp70/rX2Q5+wOAjth3RPYkTBVn2OKxynHYnWijVSFr4=;
        b=ZAq5exjD5rOkLOaA+vkAg3LluvzjNF2Q5AEGitTPIi5GzUJU6vpUXqttfdcCnuEoIa
         cAavFjATB0eu5vQH6+imiV1r5SrLVWBNboDdh75mQOUk/DvjaBqMtW3e33WL3VxQL3KB
         W1nVB9NE6lGAKuaHqx00CSUl8g/Z+7r8AwUPjMdYUdfoJ8KVYT4F8/aKOC8+Qg7f6JiK
         dKUv4iTS3jHEK1HuoxE+dQqGl818avz7T+YlqXwEAW60rS6gaCN2HiU055FC5HPq6ciG
         4f9jQUJ1BWmW9e7/SMIg82pXoPqn7+mf0Go/zhDh/cjh3KFEYump0Jle5JL+IInuRaen
         17Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pp70/rX2Q5+wOAjth3RPYkTBVn2OKxynHYnWijVSFr4=;
        b=LMEIdq8qz/gD892/bvuHAGLk+GrQ+mqw66Vplzf3kmO1NRIWQPAIYKhSEt2Fj5BBE4
         jyTHlZTh5ybtfWS2MVsAtGTnFx6CWSrI/ee/yDsI3xJ8+Gs8G/vSRwm79XlJIa2CSFG5
         ZpBa6+ry36MzLOAA/GpWc3tUm0ryFMR7dN5qCsmbZPTKKFpoe25cvuAwHE0PBF6PGodW
         dZfRQAipI/SukzlLVXLpOUkPplaqlDVX80AJ5f5xd5IhTRsZVxj032nU51GzN+A/SEGm
         ZvgGZmpvR7zBbyOftbgoy6R1X0ys3kdCmT8kIO5Rwett/vMqUfsOqWBPPcpHiDIpT6RJ
         H2Iw==
X-Gm-Message-State: APjAAAXrGax0VIghKa2sWyMoWyoBiOKWHrqPAPR0QErTIritaszHufL7
        pVviay6HbPuv3oSfxhO0AwY=
X-Google-Smtp-Source: APXvYqyuMHYl+28siLOxHDqrnPp7mOtm5i81E1B/z2am6i6bgNbp2khqV/sKQY/48uX9H9B3kCyR2g==
X-Received: by 2002:a6b:bf87:: with SMTP id p129mr15460896iof.253.1563057752676;
        Sat, 13 Jul 2019 15:42:32 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:184d:26dc:d796:2ec1? ([2601:282:800:fd80:184d:26dc:d796:2ec1])
        by smtp.googlemail.com with ESMTPSA id y20sm9802744ion.77.2019.07.13.15.42.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 13 Jul 2019 15:42:31 -0700 (PDT)
Subject: Re: [Patch net] fib: relax source validation check for loopback
 packets
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>
References: <20190712201749.28421-2-xiyou.wangcong@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8355af23-100f-a3bb-0759-fca8b0aa583b@gmail.com>
Date:   Sat, 13 Jul 2019 16:42:30 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190712201749.28421-2-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/12/19 2:17 PM, Cong Wang wrote:
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index 317339cd7f03..8662a44a28f9 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -388,6 +388,12 @@ static int __fib_validate_source(struct sk_buff *skb, __be32 src, __be32 dst,
>  	fib_combine_itag(itag, &res);
>  
>  	dev_match = fib_info_nh_uses_dev(res.fi, dev);
> +	/* This is rare, loopback packets retain skb_dst so normally they
> +	 * would not even hit this slow path.
> +	 */
> +	dev_match = dev_match || (res.type == RTN_LOCAL &&
> +				  dev == net->loopback_dev &&

The dev should not be needed. res.type == RTN_LOCAL should be enough, no?

> +				  IN_DEV_ACCEPT_LOCAL(idev));

Why is this check needed? Can you give an example use that is fixed -
and add one to selftests/net/fib_tests.sh?


>  	if (dev_match) {
>  		ret = FIB_RES_NHC(res)->nhc_scope >= RT_SCOPE_HOST;
>  		return ret;
> 

