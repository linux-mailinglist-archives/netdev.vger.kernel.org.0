Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7819A196125
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbgC0W3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:29:08 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38673 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726781AbgC0W3I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:29:08 -0400
Received: by mail-wr1-f68.google.com with SMTP id s1so13497230wrv.5
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 15:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MB9A2eOK1Nca81jvivZ3VogDjFrU2QZidzI6SImsNHA=;
        b=fehEj/28wAeoc1NxZV+rn0iVo0VqnEV5t7LzTKYDbzV5c4oU35kDhueEngr8BOZEt/
         8HGzlNJNbjikUB63TvQ6FDXoIarmxcglDDG5VmCkrhd6zFzwLDe8kml2L+OODRIWGsWQ
         DIgPO2u78hjcguG8zlh68vNXr74rZ8ak7Gxv+Bmr7DCbqXPfcenSSzc++nUQ22b5C5nf
         Gnp5qJWPj7MTJ4kOOnCX0vZzXSyW8Rn+Otyd9Y58Xvg8EBB8RtmddCOKwucZyFpEdF6i
         kG/4wwSwLTgM1GBf+2jufnjRESrJ3v3QLeSqJ/VJKZWPEpDQyPRqooxZh0vqbUJYZd5X
         0Chw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=MB9A2eOK1Nca81jvivZ3VogDjFrU2QZidzI6SImsNHA=;
        b=fvI7fDLi7kdLscyvlDvnGoR9s9OZxR/qg5giLSABrEjxWL1hubZHMyrl6tLz8N2EY9
         in9qcgvzq/smFdMPw9bf7jer8N/f3o6xurUhlxhR7Q3+CNQj+hKqChgB+cx7fB/ZxL58
         9JaqXjGhCvaQK0vxG7/lBma+MmZ386YqFJFiQch5G0e7LJImXQa+7g11tSNVTGgyMFVu
         5NYI76p1KFWmLFxnJF2AdXp/EddkDsg5t+4WH/0v0rbbLihPeHntdZeqaCOtSzhs77A3
         qS0tXu2gO+vha46N9o0JDTFrUk53KDW81wxBBOT1/86hXpiECPO5dU2yKRu3LsZqfnZV
         Zkzg==
X-Gm-Message-State: ANhLgQ24Qe+FdDPCQAyNmcZqBuNQIrIHr4NMpP8v4ZVauKKZqNPI9CB+
        Sa92gr2yWE23YiI0HsgWx1Hk5+0TL4Y=
X-Google-Smtp-Source: ADFU+vvhaXvV5a7zwm59WFlqx/jB+WQE/aHLiKmxmTPipmXnD980GRt3+o8thIElKmT5P35fmuT2hw==
X-Received: by 2002:adf:e588:: with SMTP id l8mr1678864wrm.186.1585348146447;
        Fri, 27 Mar 2020 15:29:06 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:2428:7eec:ef62:1393? ([2a01:e0a:410:bb00:2428:7eec:ef62:1393])
        by smtp.gmail.com with ESMTPSA id i8sm10355907wrb.41.2020.03.27.15.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 15:29:05 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3 net] net, ip_tunnel: fix interface lookup with no key
To:     William Dauchy <w.dauchy@criteo.com>, netdev@vger.kernel.org
References: <20200327145444.61875-1-w.dauchy@criteo.com>
 <20200327185639.71238-1-w.dauchy@criteo.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <042afef0-fcd4-6f37-ed25-518cf5352d9b@6wind.com>
Date:   Fri, 27 Mar 2020 23:29:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200327185639.71238-1-w.dauchy@criteo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 27/03/2020 à 19:56, William Dauchy a écrit :
> when creating a new ipip interface with no local/remote configuration,
> the lookup is done with TUNNEL_NO_KEY flag, making it impossible to
> match the new interface (only possible match being fallback or metada
> case interface); e.g: `ip link add tunl1 type ipip dev eth0`
> 
> To fix this case, adding a flag check before the key comparison so we
> permit to match an interface with no local/remote config; it also avoids
> breaking possible userland tools relying on TUNNEL_NO_KEY flag and
> uninitialised key.
> 
> context being on my side, I'm creating an extra ipip interface attached
> to the physical one, and moving it to a dedicated namespace.
> 
> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")
> Signed-off-by: William Dauchy <w.dauchy@criteo.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
