Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259B43CA142
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 17:16:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238427AbhGOPSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 11:18:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238418AbhGOPSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 11:18:49 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F5FC061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:15:55 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id k4so8241612wrc.8
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 08:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FLtkmRZTrCSIaXOsSedsDZnpkDbHaVPJhqgNe0A6lcE=;
        b=fCfE9KeYBevyWgI02tgk4nEfKYMad+ux1yUtpVSle12F9zSUt0oGM+5vSvmQ/50V4j
         dHaZeAnUUDdLykGPfmXSgxqh4l3vLbW6cUxIXpo3ZI8sJhdAqqBMJRNtghYfBE7QF4DP
         0p4mhvvQlFizMkdu3oI7wULZWk9GxdUEg/6OUl1zf+ImHzliSWGJQOhgOPi0yE7vjnsC
         NI+UTzNB5YGyGPv1mzy/S7KWJRvbArLaz5h6lAgbHuf2If30TTt3fzSfCfZTSmyagx0d
         TzuBdoiPKLaKRNo/0hHADuEAj+uddE8BUtUbkU0eBFY5SPuVtSZoPxbSOrpjPYub3SOC
         VrmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=FLtkmRZTrCSIaXOsSedsDZnpkDbHaVPJhqgNe0A6lcE=;
        b=qjeH6YTn6wZ9JH9F5O5AMMRRVXNO37f039L5uwM8lqeVf4wJ/bN5kvny8S6HdVJZbP
         pSzxuVL+ZlZD2r90pf9go6qgRYh2UnW273G9jVQwNYOfLeKMF3NdyglDz9WOThR6P5Qv
         VJwiAq33yLeFW8E8fib07tX7DsUxnF+Uh1IVMoI88OmEYpxspJ5GunjGMKfgktSFEYUs
         DVc6qc3NQP3mGX+0/apWhszjcwO/SDf6uvwkvSafVS4Tcr7NxLVrcrUI+ZU5KDdbCLBI
         3v+Q60kmktw5FVZ/IgJM1aQmfTI/JwuTIz0HO6IlYysgY1JuyUXV0XwzelEBRcmMjZr9
         dt+Q==
X-Gm-Message-State: AOAM530kj+1S1y74DdDOnTQ+SkcjGWTS+UOAib+YztiwJAkY45YC7aZu
        FXz5zhtJf+Zx9h+lRBPNxCAiQW7Fn9e59g==
X-Google-Smtp-Source: ABdhPJwvombve4/w8MtP8iQ8WcvcCgO7MY1aVQYHb8jk1GOV9Zb6OF2dWGqZ6R6I2v8uXRh8zW77jA==
X-Received: by 2002:adf:f305:: with SMTP id i5mr6246037wro.122.1626362154383;
        Thu, 15 Jul 2021 08:15:54 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:c510:a4d3:52d6:e2e? ([2a01:e0a:410:bb00:c510:a4d3:52d6:e2e])
        by smtp.gmail.com with ESMTPSA id p8sm7369056wmc.24.2021.07.15.08.15.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jul 2021 08:15:53 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] ipmonitor: Fix recvmsg with ancillary data
To:     Lahav Schlesinger <lschlesinger@drivenets.com>, dsahern@gmail.com
Cc:     netdev@vger.kernel.org
References: <20210715143856.6062-1-lschlesinger@drivenets.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <9aff4da8-fc89-20c7-7240-780ebc890171@6wind.com>
Date:   Thu, 15 Jul 2021 17:15:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210715143856.6062-1-lschlesinger@drivenets.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 15/07/2021 à 16:38, Lahav Schlesinger a écrit :
> A successful call to recvmsg() causes msg.msg_controllen to contain the length
> of the received ancillary data. However, the current code in the 'ip' utility
> doesn't reset this value after each recvmsg().
> 
> This means that if a call to recvmsg() doesn't have ancillary data, then
> 'msg.msg_controllen' will be set to 0, causing future recvmsg() which do
> contain ancillary data to get MSG_CTRUNC set in msg.msg_flags.
> 
> This fixes 'ip monitor' running with the all-nsid option - With this option the
> kernel passes the nsid as ancillary data. If while 'ip monitor' is running an
> even on the current netns is received, then no ancillary data will be sent,
> causing 'msg.msg_controllen' to be set to 0, which causes 'ip monitor' to
> indefinitely print "[nsid current]" instead of the real nsid.
> 
> Fixes: 449b824ad196 ("ipmonitor: allows to monitor in several netns")
> Cc: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
