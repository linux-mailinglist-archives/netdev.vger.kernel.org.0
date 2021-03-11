Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4455E3378B9
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbhCKQFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234293AbhCKQEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:04:38 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C3DC061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:04:37 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id b8so1927085oti.7
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:04:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uSpf9aL/lHJWNtdPyg7y2Zm88ICDjzkW7Mhrl0shhRc=;
        b=TS1dYeVlPwh9ZGJkmsHBWbuIhAYm1QrO9QVTXyNwnVF4zE7NG7NDy+d+gMnQ8wH2Xe
         k5NyzCHt1FYe+batZobniUsJMB5sbLHaHXZNv/J/MKSu2NbsP/83zIzubfVb31M3VEPt
         lfBnwWcBW1E3RIqleMgwV4XQflnfwezCmoaWlX/IeKigDk3BDETpfg6ubzWX0iukAQos
         QTLzZJ6NCj5zPjXHR+6/S0/jzzsrM/yvFSS2+UF5kud3JY5QbWFxkBOqYbzcQLz1BXw8
         HHQI9rxsngCOKN2mJSGw73EuFyduVKzlVvZpPgOmiUKTWphBn7GMPrbW2tnD+Lu5WGgU
         SJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uSpf9aL/lHJWNtdPyg7y2Zm88ICDjzkW7Mhrl0shhRc=;
        b=UnIfn5DBEx/NW3jUQrMLXXc749lk/M9OW2kdQIfTjXQD4b71ICXDufsmacQFmZZFeq
         2ZAVo2pzTyK+XvZkattdRvGmNy3RmA2cdJnYypQb0vVIYVtlEz/chVNpZoERlmtFslu9
         +cG/KTR+J+6OAoXkPOrkPF06WWD+oNc4l0GNkJImkJY6r03MwWLk5d8k5NzADxV8Fea/
         QSZ+tINWWaco8W0Cn0dtadALVj7/ZGvC9/OM9ya0TeudyRM6+l732xteGWOswqiaigSy
         80T0KbZL59172UlYuH5VwTXaRfwYt8nuLFkBQLpVlMToU3+AERghAmHRUJOc38rtx+yG
         10pw==
X-Gm-Message-State: AOAM532XazSBWtaGCJChQn9+syLFBJGijW9saWevzB6+CMQEA2JD2gzB
        cvrYuG1a31d0jhBduq9xpQE=
X-Google-Smtp-Source: ABdhPJzk0vRenl6WCum4EMdX0XS6Qgi4tlB41zoswWfGVlv4SviQF2jKfkoSKqc8VvEBcxVISekp5Q==
X-Received: by 2002:a9d:565:: with SMTP id 92mr7562384otw.109.1615478676650;
        Thu, 11 Mar 2021 08:04:36 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id n1sm629889oig.47.2021.03.11.08.04.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:04:36 -0800 (PST)
Subject: Re: [PATCH net-next 09/14] nexthop: Allow reporting activity of
 nexthop buckets
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <d1e3bab356ae50c7e716721ed63d3ffeae91a451.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <83a89f6c-6ad3-2d7f-8f37-7910cb957ec2@gmail.com>
Date:   Thu, 11 Mar 2021 09:04:33 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <d1e3bab356ae50c7e716721ed63d3ffeae91a451.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The kernel periodically checks the idle time of nexthop buckets to
> determine if they are idle and can be re-populated with a new nexthop.
> 
> When the resilient nexthop group is offloaded to hardware, the kernel
> will not see activity on nexthop buckets unless it is reported from
> hardware.
> 
> Add a function that can be periodically called by device drivers to
> report activity on nexthop buckets after querying it from the underlying
> device.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 
>  include/net/nexthop.h |  2 ++
>  net/ipv4/nexthop.c    | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


