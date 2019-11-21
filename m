Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3E5105C22
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 22:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbfKUVjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 16:39:51 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:41750 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbfKUVjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 16:39:51 -0500
Received: by mail-qt1-f196.google.com with SMTP id o3so5416600qtj.8
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 13:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=30x9LAYM8YEZrrhc9umU9ng/SMsB8tX/XB4QoYomhGU=;
        b=TMOUZlngqaRctpVscm0CstRupnojn86DxkUd4at+T5Jzny9LG4mILwGdD7iAcPzA8a
         cla4JAj7dvzzkRQozLj7YITzebGTg0d33a3tX/nWi/VDoI/Tm/tBGlZVB2VQ3ktG6OJ+
         LXiQwV8S/b7vtAb9cagvzbRbguW720td4VmQ/Q85Fb4pJqp3jRknKngrFw3wAbxoRVuO
         vVd47sroRN6xsilovnRJNvLW/bL43IDem2dcYD9JUORnH127dLZJSz2PFeJSkXqPFYcH
         k7nDvn31Na+lUaChOHzepA/Mdj5gc6k5HkJP+6+Kfe7pRP9VvY4hPlsp5QMzvZsmu98p
         xY3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=30x9LAYM8YEZrrhc9umU9ng/SMsB8tX/XB4QoYomhGU=;
        b=ayfO5lsozQ5Zzz3Vpk7Q62vMWEBO0bTWtOkrTIkUYE/KB5CJcPcS14n6s/jJ96Ry9N
         OT9fZVycaQft2RgJno2UK077HiCKdQ9L03thv5UVh+EI8vW4uq/Mu8+slXgLGSpUIqvM
         gtfiiSt8l6pRXvMbgPnmcpa080HrPe15Vyz4PMcq8TMPFlsfBTfAMZcIiyuxo+KOef7z
         XuKxLSrH2zU8JLmiFbEpc80sHpQ6v2N1Z4C6d5n7/djV+KAzLRPzN9p3Sk3s2uELUVU0
         /iqnSSRtPEGJCFkTarwt866whCh8jA0WhdnDHsC+MKzMt4iaZacm7J3sDBq86JnE3dVp
         89rQ==
X-Gm-Message-State: APjAAAWy22MPViIXVuzbj2T5XgyHOHAS1z0IoICrqtBxdMDKKG2uDi6z
        pc+SnvcHy6fJH9HpQE6jZXI=
X-Google-Smtp-Source: APXvYqzpcbCVzF+7w9dbaGu8TK6WfqHO+572/g+FzMymu6PRT5EqJ9Zpyjmz7ixPQjOWxsYOPnz+4Q==
X-Received: by 2002:ac8:34a3:: with SMTP id w32mr11281036qtb.9.1574372390297;
        Thu, 21 Nov 2019 13:39:50 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id 11sm2242726qtx.45.2019.11.21.13.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 13:39:49 -0800 (PST)
Subject: Re: [PATCH iproute2-next] devlink: fix requiring either handle
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Shalom Toledo <shalomt@mellanox.com>,
        Quentin Monnet <quentin.monnet@netronome.com>
References: <20191120175606.13641-1-jakub.kicinski@netronome.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <56b7fcb2-f4ec-2bf4-59cb-952fcf79783a@gmail.com>
Date:   Thu, 21 Nov 2019 14:39:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191120175606.13641-1-jakub.kicinski@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 10:56 AM, Jakub Kicinski wrote:
> devlink sb occupancy show requires device or port handle.
> It passes both device and port handle bits as required to
> dl_argv_parse() so since commit 1896b100af46 ("devlink: catch
> missing strings in dl_args_required") devlink will now
> complain that only one is present:
> 
> $ devlink sb occupancy show pci/0000:06:00.0/0
> BUG: unknown argument required but not found
> 
> Drop the bit for the handle which was not found from required.
> 
> Reported-by: Shalom Toledo <shalomt@mellanox.com>
> Fixes: 1896b100af46 ("devlink: catch missing strings in dl_args_required")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>
> Tested-by: Shalom Toledo <shalomt@mellanox.com>
> ---
>  devlink/devlink.c | 1 +
>  1 file changed, 1 insertion(+)

applied to iproute2-next. Thanks
