Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA7B163C0C
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 05:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgBSE3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 23:29:37 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:41933 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgBSE3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 23:29:36 -0500
Received: by mail-qt1-f193.google.com with SMTP id l21so16276419qtr.8;
        Tue, 18 Feb 2020 20:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LOsFROh7MBsaKs8scMakdC0ZnZhWfyNZ1EStpa5BtiE=;
        b=axwuXCS9P4EpdvRhgQZTeLjVUacCYvwK5ey27xcZ+EFDIQIwnKUH/4HIzFUE6wK8bN
         6n7Dx5sREdoeD8krOleaDuRL5eCz3C4RdWp/hIiDF1gBCXMDmBVA/8Mxvg3M3sKZhrm6
         x7cPg0HNnpxtpZKiKG3o2tZL98i0jEwZwTQqOdee5aPEQc04Rra97rsrtDhJ3PkxvLW/
         7S29lUbY/zAF2Ml6WeBhcizH56qR9vq2sObSUIXWUOCiAVBIOmDfia4cGPSsOgMGmqoR
         HEtCk7yRxUTSQJoBvWSjNK5o/PnyJ7CjRBeqn6IC0j2AdlXbFVY4SyzY/8qF9w12Z6wU
         ctXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LOsFROh7MBsaKs8scMakdC0ZnZhWfyNZ1EStpa5BtiE=;
        b=L5PauHPFpbUpR4HcOziIb3gdKSTgSEWNtLscpVTB9u6hZU/Xd9VetQ4gD50TvVZT41
         B7vs2TbOUvbCu5EY3D+GYK2tHBQlIYiGDoc1QSKdqxJkQid3/VRM79AnDXGfIUazhbYz
         MwtrRy6WlWAt5vBZWCdfL3N/g21Rk7pCf+faeIzVUCuU3JykrXOSZqK11L1YqATDSjkN
         FgD8FkfxfoPmkCqgRyhIGuRHBQtfwUv8dAzvpimJRBjyOIicVDj+FOptCAZ/87QMuI/S
         Y/rHfnbA+eK4q7OdRq1gMLLxpGGr38UuOJWnpReGMdHgQLz8LHp8zpBwOqi4eChG9Mro
         FnOg==
X-Gm-Message-State: APjAAAXnkdlCIxPAuafWcfgSwO//idEqXA3RU+yQiMFT2BPKBx3qjOoU
        9Z1PCa4gek0hrh+IrYa3bsc=
X-Google-Smtp-Source: APXvYqyt8bFtso1ZwlQSj4yN05ejgvR5VkA3leXjVnvOF8VfkdkjhAnUJMkt19oS3BnKKkc2x8el7A==
X-Received: by 2002:ac8:65ce:: with SMTP id t14mr20191553qto.72.1582086575558;
        Tue, 18 Feb 2020 20:29:35 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:e144:c166:6873:61aa? ([2601:284:8202:10b0:e144:c166:6873:61aa])
        by smtp.googlemail.com with ESMTPSA id x28sm413266qkx.104.2020.02.18.20.29.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 20:29:34 -0800 (PST)
Subject: Re: [net-next 1/2] Perform IPv4 FIB lookup in a predefined FIB table
To:     Carmine Scarpitta <carmine.scarpitta@uniroma2.it>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ahmed.abdelsalam@gssi.it,
        dav.lebrun@gmail.com, andrea.mayer@uniroma2.it,
        paolo.lungaroni@cnit.it, hiroki.shirokura@linecorp.com
References: <20200213010932.11817-1-carmine.scarpitta@uniroma2.it>
 <20200213010932.11817-2-carmine.scarpitta@uniroma2.it>
 <7302c1f7-b6d1-90b7-5df1-3e5e0ba98f53@gmail.com>
 <20200219005007.23d724b7f717ef89ad3d75e5@uniroma2.it>
 <cd18410f-7065-ebea-74c5-4c016a3f1436@gmail.com>
 <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a39867b0-c40f-e588-6cf9-1524581bb145@gmail.com>
Date:   Tue, 18 Feb 2020 21:29:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200219034924.272d991505ee68d95566ff8d@uniroma2.it>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/20 7:49 PM, Carmine Scarpitta wrote:
> Hi David,
> Thanks for the reply.
> 
> The problem is not related to the table lookup. Calling fib_table_lookup and then rt_dst_alloc from seg6_local.c is good.
> 

you did not answer my question. Why do all of the existing policy
options (mark, L3 domains, uid) to direct the lookup to the table of
interest not work for this use case?

What you want is not unique. There are many ways to make it happen.
Bleeding policy details to route.c and adding a flag that is always
present and checked even when not needed (e.g.,
CONFIG_IP_MULTIPLE_TABLES is disabled) is not the right way to do it.
