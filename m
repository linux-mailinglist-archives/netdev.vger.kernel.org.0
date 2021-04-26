Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456FA36AA9A
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 04:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhDZCdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 22:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231550AbhDZCdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Apr 2021 22:33:54 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23907C061574
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 19:33:09 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 35-20020a9d05260000b029029c82502d7bso19317679otw.2
        for <netdev@vger.kernel.org>; Sun, 25 Apr 2021 19:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uGAbESCSuQz7F5ZSnqZAZ91MN2Qi3x0dCCIEeqcQkEk=;
        b=RbpIRw7Z0/x2BOxWUgyShbK7S57dlArgfkFUfQvnQIei+Mwsdv8xuFleGPmnRs1dXB
         dcZZmlmc76fstGB+2k3prm+33vucBXT+KiR/5LIBNT7of3d/xUCmIEp4hOGIo5nA/QDI
         /ZmVCxGnXEkifBU6VN/p0VBKXhhc+SGZfR0I553weuVahlAZVS6JlWfFg+awqqWwKMdh
         QcHAI46jXH3R+bgqEb9qOJXtEecypq1KyqpHJfFbyzhIvPcmQNc433J40ZcL9a9EPu73
         R4WwdFvqKM/sSUlvHoDggAXD8AksX6Bl91xOWxbjEZFWXgyzsJgrewfJhEAvwVnsmkaq
         YDrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uGAbESCSuQz7F5ZSnqZAZ91MN2Qi3x0dCCIEeqcQkEk=;
        b=SKil44F4J7D1c0QCFR+pPftf0iVqAfXjG/zFggGHO2szhhJU5P56HeHbdzXVkJbian
         Z2WRZnw2PHswx6dw6SH0eZ9m26HVj3N4dRYebFB2sbp38Ng9TQQRMJImL+10sqAe58Dq
         uEyY9a6bLsnlxQvIqsC0QnorOBVWNKoidUxts5wH3X546JKeNUFdi9zQ5gYN60BAWCG5
         0Y+h9r97ISFN0aR1hAwH8qrSMNbeT+xfpgTvyu1zkvtMaLWrXyDBDSxvFjo+9tHAEk3/
         tqvae7suT8EVP5PD7V3lop7xLo9EAhS2IaWqNBzbJ9S0CuEMQTwOtATGrhGfuf17U+d+
         ByfA==
X-Gm-Message-State: AOAM5327P4aCxqWF/qqO0QaSB+QN1dcOl4jWJKfyompOnPNkcHw+7ELn
        nOfF29S8rOYqZ+yGYY0/EghQgJ+c2WU=
X-Google-Smtp-Source: ABdhPJzCohVfA4LGd7Jy7cJEwK8tfCCaHH0AkUOPC5IobZ1QyNTtcS0nTMpy/jx7kx5EG3RJVHW5UQ==
X-Received: by 2002:a9d:311:: with SMTP id 17mr12711695otv.77.1619404388424;
        Sun, 25 Apr 2021 19:33:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id o186sm2632102ooa.35.2021.04.25.19.33.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 19:33:08 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2] bridge: vlan: dump port only if there
 are any vlans
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210423115259.3660733-1-razor@blackwall.org>
 <20210423121018.3662866-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <66869960-15f0-bdea-516a-58014fa927a0@gmail.com>
Date:   Sun, 25 Apr 2021 20:33:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423121018.3662866-1-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/21 5:10 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> When I added support for new vlan rtm dumping, I made a mistake in the
> output format when there are no vlans on the port. This patch fixes it by
> not printing ports without vlan entries (similar to current situation).
> 
> Example (no vlans):
> $ bridge -d vlan show
> port              vlan-id
> 
> Fixes: e5f87c834193 ("bridge: vlan: add support for the new rtm dump call")
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
> v2: sent proper patch version, fixed the vlan port closing only when opened
>     added an example
> 
> Targeted at next since the patches were applied there recently.
> 
>  bridge/vlan.c | 21 ++++++++++-----------
>  1 file changed, 10 insertions(+), 11 deletions(-)
> 

applied to iproute2-next

