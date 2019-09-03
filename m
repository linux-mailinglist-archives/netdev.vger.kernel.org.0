Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F95A5F3D
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 04:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726581AbfICCOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 22:14:55 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43936 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfICCOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 22:14:55 -0400
Received: by mail-io1-f67.google.com with SMTP id u185so28614806iod.10
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 19:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ed4jCiZYkp5UwXmVoLlOjMENF1UO8wn0O7xDg99PuGM=;
        b=s5c9BEg8JDJ21uLdnVig+s5YWQ1azKK2MyNZhYhYJ0iqAE9q+iiZLTKrmUdn8Y5J/n
         mh2MfAbHH2gV9VgX+/hBW3nzCirZZakUuji0QH71HDQ003oI+lEMSxzKU7NoyEmv7EyM
         8FKBwWcIJYGioxIKKx/GYOnd/lRY/bVeEw4JusdjQsHW1un8akSfnGuR93/fTa0HIkjd
         o556P1Ijq9YJ/m+h0AtIZmyq73w/DwUj5Qcl8AlCiJW+tggeBdz1zdeTBq52Vbz1F7uq
         JYa7F15ofTgqZ33fpQXqrXEF1AR4E7C5U9nakp1+ZY8+crgOy0RuAe5kAi/nSCV4mKBZ
         0Eeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ed4jCiZYkp5UwXmVoLlOjMENF1UO8wn0O7xDg99PuGM=;
        b=Z8Per7kGNYUgoN/fLoKzGk+7etk0y3p8IMmOFj/nSHC9xTe5o7erYLHJh0YHMbkAoK
         bQcvRu2Y8h49U7oXwJoAR4RMfaezTQHz5hapWMTfPUQCejPA8oi8TIBPTvxKyn5ytO5z
         sENbVgdqKdTiTR0r8gQ3UQHC+UVBeiIFN6wDd5cb8UcFm/I15DBRhAv9zWKZiUMdlSFe
         kAXjegUOfrH8GGW7fMnAOXP7xL8r6YdbvUVc+tG4oBenetiw2Gh+5izVX6eq3VqwAy3Y
         NGcYTMjD/KBdocQomoxBMZ9BiZlyHu+CJ+zdhZxRC6BSFB8DRdUJfBkoR1jzsfR9mlh+
         vONQ==
X-Gm-Message-State: APjAAAWW8Exa0Hw6qyYP9sXVncXY4R89ORTy4VmgdPaitwDi9nmfYcev
        tzXcRk8Ug2EqCnG8mnQku6g=
X-Google-Smtp-Source: APXvYqyBI65VW1FN+DCZgDpX8hp3NligaNc9Yl0oOJAsWUjq1MJW8Rx3Rv90r2nFuSaeR4lVnkmeuA==
X-Received: by 2002:a02:c652:: with SMTP id k18mr28076637jan.44.1567476894530;
        Mon, 02 Sep 2019 19:14:54 -0700 (PDT)
Received: from [10.227.83.82] ([73.95.135.6])
        by smtp.googlemail.com with ESMTPSA id y19sm14034583ioq.69.2019.09.02.19.14.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 19:14:53 -0700 (PDT)
Subject: Re: [PATCH v2] net-ipv6: fix excessive RTF_ADDRCONF flag on ::1/128
 local route (and others)
To:     =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>
References: <565e386f-e72a-73db-1f34-fedb5190658a@gmail.com>
 <20190902162336.240405-1-zenczykowski@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0fce791a-8272-2eee-4e72-9b4fba54ce5c@gmail.com>
Date:   Mon, 2 Sep 2019 20:14:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190902162336.240405-1-zenczykowski@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/19 10:23 AM, Maciej Żenczykowski wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> There is a subtle change in behaviour introduced by:
>   commit c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
>   'ipv6: Change addrconf_f6i_alloc to use ip6_route_info_create'
> 
> Before that patch /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000003 00000000 80200001 lo
> 
> Afterwards /proc/net/ipv6_route includes:
> 00000000000000000000000000000001 80 00000000000000000000000000000000 00 00000000000000000000000000000000 00000000 00000002 00000000 80240001 lo
> 
> ie. the above commit causes the ::1/128 local (automatic) route to be flagged with RTF_ADDRCONF (0x040000).
> 
> AFAICT, this is incorrect since these routes are *not* coming from RA's.
> 
> As such, this patch restores the old behaviour.
> 
> Fixes: c7a1ce397adacaf5d4bb2eab0a738b5f80dc3e43
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Lorenzo Colitti <lorenzo@google.com>
> Signed-off-by: Maciej Żenczykowski <maze@google.com>
> ---
>  net/ipv6/route.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 

Looks correct to me. Thanks for the patch.

Reviewed-by: David Ahern <dsahern@gmail.com>
