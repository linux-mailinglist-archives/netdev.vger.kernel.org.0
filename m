Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5718B313854
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 16:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhBHPnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 10:43:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234033AbhBHPm1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 10:42:27 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58C6C061788;
        Mon,  8 Feb 2021 07:41:46 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id q4so3526169ood.8;
        Mon, 08 Feb 2021 07:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sxdNpbaxjlgrI7y1xjMXjF7UFp2IQQ7kDEnaAjSJx9g=;
        b=YfIiYx/BKZ4rZeX8RpLOTQsQ/KtLpC8M6vxPN/XhchXntph3d2A7qVunw33G3PREa0
         F+D2/WFlIa/yxvdNhzJ9UufatBB0/30XR7OCSbrAuPtQySZh6fH0VlX+20Q5nP8rbqt9
         MqOz/KG5w9mdSYoW08j54YMvejJIKhVcHGQGR6c1beANVWZvAOeRgcMtc7UI49l8oZNM
         cummtSiQEjqXpj61hbgNBBG3uFiUmnVdrYI4TzQuxqwcg71ZeFOVsp8NvX68SL47B2rb
         cQs6UJ9HED2gjXaL6iSIH7rfPRBsJOY9c8sa+MlvIB8piR3LC+RxN1Yw8Eq+X+xQpRcc
         aCOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sxdNpbaxjlgrI7y1xjMXjF7UFp2IQQ7kDEnaAjSJx9g=;
        b=E5V/9Cw9Pf4AwtJcb3RcKDW0Ly1KcHVfcq3dylvewGjtQO0rqCqEo1/wTw1Btv1aCJ
         HlM5txq+1zFiOgXinz8JHWgQhfJsMHs77kb1GVrFvAIxVQpELE8yMj/wcZaMykr7VSQD
         0D0bRAKRAGWeEnI8eF9a43h+6hyivjzs+HXWCjuCHs/E1LylijUWJ/giiFyH5sLWmEnr
         4ywTE4rUEWaGPItXCxG7/hjLqNSX+3c/wBbIObWushfi5Yu8i4rs3tp7Kmo8NTkMHNnz
         yCzlZfAOP3F00kKtVwt7Pe+xrIX0VzWil0JEnYzfMas48PhwOmfsE/d0a7hMl130AO6x
         G/CQ==
X-Gm-Message-State: AOAM532k9HL3RElgtTGjdLMG9kiFnDQ/LaKkzjrB20ivDrUUqXNACnHT
        Fo8bujjI07Og4t8DgqJOk6isZF7y2C4=
X-Google-Smtp-Source: ABdhPJwH0fwOOUu+Q0WPK3ANFlUUkzoJcW31wN26ZavLe1t95+GxV7PDkRUbDf4XQVe/bhFngUx0qQ==
X-Received: by 2002:a4a:d031:: with SMTP id w17mr5052846oor.33.1612798906284;
        Mon, 08 Feb 2021 07:41:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id d17sm1097652ooh.32.2021.02.08.07.41.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 07:41:45 -0800 (PST)
Subject: Re: [PATCH iproute2-next V3] devlink: add support for port params
 get/set
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        netdev@vger.kernel.org
Cc:     jiri@nvidia.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        kuba@kernel.org
References: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c22aaccf-59a9-d3bc-8eb3-0496f17c8dc3@gmail.com>
Date:   Mon, 8 Feb 2021 08:41:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210202130445.5950-1-oleksandr.mazur@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/21 6:04 AM, Oleksandr Mazur wrote:
> Add implementation for the port parameters
> getting/setting.
> Add bash completion for port param.
> Add man description for port param.
> 
> Example:
> $ devlink dev param set netdevsim/netdevsim0/0 name test_port_parameter value false cmode runtime
> 
> $ devlink port param show netdevsim/netdevsim0/0 name test_port_parameter
> netdevsim/netdevsim0/0:
>   name test_port_parameter type driver-specific
>     values:
>       cmode runtime value false
> 
> $ devlink port  -jp param show netdevsim/netdevsim0/0 name test_port_parameter
> {
>     "param": {
>         "netdevsim/netdevsim0/0": [ {
>                 "name": "test_port_parameter",
>                 "type": "driver-specific",
>                 "values": [ {
>                         "cmode": "runtime",
>                         "value": false
>                     } ]
>             } ]
>     }
> }
> 
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> ---
> V3:
>     1) Add usage example;
>     2) Remove stray newline in code;
> V2:
>     1) Add bash completion for port param;
>     2) Add man decsription / examples for port param;
> 
>  bash-completion/devlink |  55 ++++++++
>  devlink/devlink.c       | 274 +++++++++++++++++++++++++++++++++++++++-
>  man/man8/devlink-port.8 |  65 ++++++++++
>  3 files changed, 388 insertions(+), 6 deletions(-)
> 

does not apply to iproute2-next. please rebase

