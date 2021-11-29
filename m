Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC51461FEC
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 20:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244092AbhK2TNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 14:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347911AbhK2TLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 14:11:37 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DC1C06175B
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:32:14 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so25990911otl.3
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 07:32:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MOZ/DFQuHWnZD4wx4PFRuKHng2uYWDVPLxUaSdu60uI=;
        b=AQ/AGbmkZE8Z3Jg9HzZJK1fl6pX48k7k+iihnYMh7E5Lt80d5pvkY+1R3j9zg3TUqt
         hJ2/SFYwb3PowjfZyyVjeyBjmuC2jAaQO/98lZ67mg87nxcl8pJeANdjhiYgYePUXaUW
         sbCGvg4m0lhU7FZRfM2erTwC/8e+NlqogW+re422B7Q+keszyEj/cTcmi/nptCDS56XR
         7JjrOAaRAaEDnfbDS+EO5JldQAwHH0P4tkcjUK1fjIhL8ScC2krK+GJ4ZG78JdEj884a
         G9aUGBTMFzZBeaFJ3eGLTESvGnba7khh1ydKb/iGJmehUlXHklGJsb7kgrXLg+CkX9J5
         nObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MOZ/DFQuHWnZD4wx4PFRuKHng2uYWDVPLxUaSdu60uI=;
        b=bFzMISp7QZe3xUSXGVNG3z1PwAiI/e10DphgcXc65JXiEFG8JsHo3gtZ72Z4JdUUgD
         mAPrcoAU9EdmxPr2Jspxemmb9Iv4fRHplgWv5J/JmVcKeEDcxrOIBTkzHR3y/MMLi58w
         3aq+y7BbKRgOauKlisbinLwNslZraA8euhadj+UclxNVul++jeidljvSgdvPttx9qFv9
         ALB0z2JHGSPfws+swfRhs6bNJjou87H8khxZlbsrLwnkpBv0n1w3JRR9iNKHpiYYaefA
         iQpjcywCpURq5kAFrg3E/QTuGNy00KAnY29NU30tLSWDvVpNtaXrNMOUgvJyVxh0fCLy
         /vbA==
X-Gm-Message-State: AOAM5300Nj0tv8n7dzt9FeR0ZmocvxyG2aqyCfM6/cJ2rNce/daa8SX7
        ZsgBbftahiM+HDs81XcQmrk=
X-Google-Smtp-Source: ABdhPJxkeT1Mi58nN+GbFIBmUFKfTLHEqLRu8/ma2w2R8RAhYoyEVbbwagGF5l7rGr2YHaymKTtnlw==
X-Received: by 2002:a9d:6f13:: with SMTP id n19mr44558784otq.317.1638199933576;
        Mon, 29 Nov 2021 07:32:13 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id k4sm3029067oij.54.2021.11.29.07.32.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Nov 2021 07:32:13 -0800 (PST)
Message-ID: <8b4a8d7c-a801-fc91-90a1-c973deb07eed@gmail.com>
Date:   Mon, 29 Nov 2021 08:32:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net-next] net: nexthop: reduce rcu synchronizations when
 replacing resilient groups
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20211129120924.461545-1-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211129120924.461545-1-razor@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/29/21 5:09 AM, Nikolay Aleksandrov wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> We can optimize resilient nexthop group replaces by reducing the number of
> synchronize_net calls. After commit 1005f19b9357 ("net: nexthop: release
> IPv6 per-cpu dsts when replacing a nexthop group") we always do a
> synchronize_net because we must ensure no new dsts can be created for the
> replaced group's removed nexthops, but we already did that when replacing
> resilient groups, so if we always call synchronize_net after any group
> type replacement we'll take care of both cases and reduce synchronize_net
> calls for resilient groups.
> 
> Suggested-by: Ido Schimmel <idosch@idosch.org>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> ---
>  net/ipv4/nexthop.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


