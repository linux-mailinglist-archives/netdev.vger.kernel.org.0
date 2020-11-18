Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363DA2B8016
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 16:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgKRPFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 10:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgKRPFW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 10:05:22 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D9C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:05:21 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id f20so3208237ejz.4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 07:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DS3BCiYH8fQiOJ4hgD9S0sN7nrSRrud2Y7cE9lgdhYY=;
        b=lzp+sfjarf4jZaB0F1qLbkQXhm2fx6TImm+UcKLZ86zVQYqQnFNJ/w576D8QtAfI9s
         Lkn5fJjF5jTreAiJDAlDBURkKoL4k43FPLqRsQ6pj7tRh1TTpWLYlwUMXPqzYA00oNZO
         GXeFGYMf8SF1TFdwaezQIBShUJNYS7dYxcIEgY6aKW0FdlOO2cJhfENfmcpWkr6tLZvy
         hjJmcKXPFvAtvVtP85sSfOhTKD92EHxnu7TwN0iKRuVTcceUw0dms6aE8fN81Yvjxhlz
         P6WdMu6HcB6IBRz24ehMhS6znO3g1S1g/rXom6JTr47snQsxBwpiFFxsk/TEu4nb1eyp
         i8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DS3BCiYH8fQiOJ4hgD9S0sN7nrSRrud2Y7cE9lgdhYY=;
        b=PBzwR7j41Na8ONaqkrp/kqIRY0yatbob2WpVb2Smg0wLjQF0sgHa9dA0a+tyuXP1nf
         tX3/u8UQEXQ6vjw4QkFh4r62Q5E2Y78W/VJiWpC7B6fOOXuD5ny4rv64WKVc6N9I0ViI
         TMHjy/L5iajXI8VY4peKTUA+9HI2kwRl8ODEp+O3+QnBhOmQ5LxbGhmGetYjIAnctN09
         EjTJq4AaqEzhn1462T7Vr1jW7wlLxxXY+oQUde579OKASEk8H6r9X8IxXBkS1dLgFp9P
         GAICPiFeVeLxA2dR0WxOM/JlLX33swZ24CXh6M1U8Y5dwOehgAbVtDmlN82mnPsrS8UF
         T3AQ==
X-Gm-Message-State: AOAM533f/iWShTkJ0vPa+A6CkNJqWj/SUY/CyeSZ1MXch1wAnDxMtAgY
        qteIK931X09MB/7WqMbDZL3f6A==
X-Google-Smtp-Source: ABdhPJzbTuoh2IjUr++nA8kxu3dQcFeBdlSirFrbiZy0m5HGLwdI44v6QAR6Iv2uoBRVoiHEZV9TLA==
X-Received: by 2002:a17:906:b53:: with SMTP id v19mr23549166ejg.136.1605711920170;
        Wed, 18 Nov 2020 07:05:20 -0800 (PST)
Received: from tsr-lap-08.nix.tessares.net ([2a02:578:85b0:e00:4bca:2353:bfc2:c761])
        by smtp.gmail.com with ESMTPSA id q15sm13306790edt.95.2020.11.18.07.05.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 07:05:19 -0800 (PST)
Subject: Re: [PATCH iproute2] ss: mptcp: fix add_addr_accepted stat print
To:     Andrea Claudi <aclaudi@redhat.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com
References: <a4925e2d0fa0e07a14bbef3744594d299e619249.1605708791.git.aclaudi@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <961ed3f0-c4d0-b759-5aa9-114b3f325b89@tessares.net>
Date:   Wed, 18 Nov 2020 16:05:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <a4925e2d0fa0e07a14bbef3744594d299e619249.1605708791.git.aclaudi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrea,

On 18/11/2020 15:24, Andrea Claudi wrote:
> add_addr_accepted value is not printed if add_addr_signal value is 0.
> Fix this properly looking for add_addr_accepted value, instead.

Good catch! We missed that when reviewing the code on MPTCP ML!

Acked-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
