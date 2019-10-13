Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 267EDD57DB
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfJMTp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:45:57 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40435 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728762AbfJMTp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:45:57 -0400
Received: by mail-pg1-f194.google.com with SMTP id e13so598046pga.7;
        Sun, 13 Oct 2019 12:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7hkgkxn5tX5Lu7EANqMWuMtKmOX/46/hM75I7oWJwRk=;
        b=Gui7vv2/nvyKokgY5fxhfY/iBSiMluSYqbm1HMiVKDDYNHZT0etzdlFtzyR4nnyt21
         bAaAjrGhZUNr7WQ7IyyeF3X5/3hkrMeaMZW0ncmMKYNwJT0+/wb/9T4jX8cwuMJVoCIU
         m68IXhMditLwDuQzR0fLoVK23KNUYrI27VCeFcTABa+TucEXt5OYvrVf7vuTq/Wroi2B
         NWhJ5Y4RsXX+DVX0BHKhvIed71GFMmeJedlfbs3G1EbFQR1GaqNyM72g1rYWKpQIB5m6
         QME/TYC8nGZxgPBmVJihnTD6moUGBGxsQRXXHrb32SAy2i6Np6PkgONPnWx4U1bIxhBZ
         4ybA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7hkgkxn5tX5Lu7EANqMWuMtKmOX/46/hM75I7oWJwRk=;
        b=Wu8+4/JxKVmynAlGP/b/mc6Mh+iLGd3yW4CaY54kaFLINkqc2hc0KgadH1oaazm8ll
         DapKIDSbHWo0TCRDBvCwn5DnlZmLU1niTURpZuNtjfm491W392hYZ1uE/7zE2dHtvpD9
         TXOdIvbxk1DovI9jsQpVh4iU78cpfUh7FadHRDeeftch4dnRHIDj/Ypkup2FjOsOfDjO
         d2HppO7V6dY2paaJ7OHZ4BXCXWf1q5RckDlLmHPqBa42qnK1LRdJ/nuIWEpCwjlbwwgX
         ww0iuQGr3ia38bZiA7Z/DRdDKwgGnCpZpK0ExIZXvYUgVmfpLzJ3J9X8FB+J9y/QCc2j
         2FTA==
X-Gm-Message-State: APjAAAWj2sGW7MpquRZXHkCSvM5PKZhJShp9jeIF5YTfzz70uXyMTKtO
        6TklTg7nls8E+jf2nBAyg/Y=
X-Google-Smtp-Source: APXvYqwItPee5hydRQfqLUl1ahdjZNyK0GLueTxXFcAuqgwUqW6nDSxU1XEPnIlLxg3eR3m/wVoN9A==
X-Received: by 2002:a17:90a:80c2:: with SMTP id k2mr32284786pjw.92.1570995956570;
        Sun, 13 Oct 2019 12:45:56 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id h70sm14384029pgc.48.2019.10.13.12.45.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 12:45:55 -0700 (PDT)
Subject: Re: tcp: Checking a kmemdup() call in tcp_time_wait()
To:     Markus Elfring <Markus.Elfring@web.de>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
References: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <124b41aa-7ba5-f00c-ab73-cb8e6a2ae75f@gmail.com>
Date:   Sun, 13 Oct 2019 12:45:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a219235e-bad5-8a9d-0f3e-c05d5cb11df1@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/19 7:51 AM, Markus Elfring wrote:
> Hello,
> 
> I tried another script for the semantic patch language out.
> This source code analysis approach points out that the implementation
> of the function “tcp_time_wait” contains also a call of the function “kmemdup”.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/net/ipv4/tcp_minisocks.c?id=1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n306
> https://elixir.bootlin.com/linux/v5.4-rc2/source/net/ipv4/tcp_minisocks.c#L306
> 
> * Do you find the usage of the macro call “BUG_ON” still appropriate at this place?
>   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/scripts/checkpatch.pl?id=1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n4080
> 
> * Is there a need to adjust the error handling here?

Presumably the BUG would trigger if a really disturbing bug happened.

There is no chance a timewait socket could be created with a MD5 key, 
if the established socket that is the 'parent' of the timewait
has not a MD5 context itself.

The parent socket only could have MD5 context if tcp_md5sig_pool_populated
could have been set to true.

Once tcp_md5sig_pool_populated is true it can never go back to false.

So the bug here would be that a socket  had a successful MD5 context,
and following tcp_alloc_md5sig_pool() would return false.

We can discuss of all BUG() in general, some people simply disable
all of them (cf CONFIG_BUG), but this particular one does not seem
specially bad to me, compared to others.

