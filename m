Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9504B327665
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 04:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231438AbhCADVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 22:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbhCADVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 22:21:21 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67AC06174A;
        Sun, 28 Feb 2021 19:20:41 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id l11so1438104oov.13;
        Sun, 28 Feb 2021 19:20:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PlTjljidtcPwBJ9+CnXDxJyG1uC+fzpkw+sBbHIDMgQ=;
        b=A+RC368gaPStHiqC1WO8QboEhnPwEzoejk9JLYmx6Th2R88d6u1snEBdsos3eo9WrJ
         wR6e4JHUHs1Jt5+BeN1y6+Gan2MOM4nC/JhgeI46d0TIl4i3UQ2ZR1mGTYHtsP7ft97h
         WNOwdUeoJzAZPPEMfOXMvsu5bzqRUNkuaISahloMzAUokctyk1b7KojI4e//nRIllZ+3
         SGH6MSlV6jqgsvWK+RauSklRAqFT2D5grQHfU7X0Y46qGylKY53oBL76rjiCrEyiGXP2
         JB04RdyzJ39BPewF/L5ReLmiIPzro07GDmZ1nJfGg3yJqsP8+ADdtCMe55JUuJZ1yTKi
         pEIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PlTjljidtcPwBJ9+CnXDxJyG1uC+fzpkw+sBbHIDMgQ=;
        b=Z3wrWq3Lhb34pp5vrc3NsyNPdnlR7UAEIoSch48NtOE1BCUuOUaENZksfxoHGXN7IL
         wK1jdDRTFEvrhfRQ8eKi2dbcs08/CLwZwnbKBWyg4srvxQuTUa8TtozKrs3ywYu67G4P
         S20/L3/ZTpsG9TK12nTWxOiJfbXFQFCGq33TIJJ1+BuoteimEy+nWFMzeWmR9QjvwCR6
         FrMkV0Z5jgDSLA9g9CQ/4D/LPKlloO+zmyhQmsG1ZA4Kvd39vooPwsQiExdXldxXvVh3
         ofaeQtVLJ1Ap1MUUuMWkkCqKJwHSnRq/kzPm0A7O0E8OBWXXS5/fsjt3pFCZM3Vc9x43
         VShg==
X-Gm-Message-State: AOAM530bNek4CN4lIwPTkPzV9u1qffckex+hDZBlI8krCAXvQgCUYfiM
        z2J6S3mX7wUYylG1WsLKZMxi6/O4Pns=
X-Google-Smtp-Source: ABdhPJyqSXNUYI1gvKncnAvKUK/cCreLb+DMnug929uEBurhd7C/6DdRSGSBioW9xJkUY22i7tnlqQ==
X-Received: by 2002:a4a:d88a:: with SMTP id b10mr10899327oov.29.1614568840758;
        Sun, 28 Feb 2021 19:20:40 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id 109sm3366597otj.8.2021.02.28.19.20.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Feb 2021 19:20:39 -0800 (PST)
Subject: Re: [PATCH] net:ipv4: Packet is not forwarded if bc_forwarding not
 configured on ingress interface
To:     Henry Shen <henry.shen@alliedtelesis.co.nz>, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chris.packham@alliedtelesis.co.nz
References: <20210301005318.8959-1-henry.shen@alliedtelesis.co.nz>
 <20210301005318.8959-2-henry.shen@alliedtelesis.co.nz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <32dc320d-abb0-475d-ca94-bac3bd26f825@gmail.com>
Date:   Sun, 28 Feb 2021 20:20:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210301005318.8959-2-henry.shen@alliedtelesis.co.nz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/28/21 5:53 PM, Henry Shen wrote:
> When an IPv4 packet with a destination address of broadcast is received
> on an ingress interface, it will not be forwarded out of the egress
> interface if the ingress interface is not configured with bc_forwarding 
> but the egress interface is. If both the ingress and egress interfaces
> are configured with bc_forwarding, the packet can be forwarded
> successfully.
> 
> This patch is to be inline with Cisco's implementation that packet can be 
> forwarded if ingress interface is NOT configured with bc_forwarding, 
> but egress interface is.
> 

In Linux, forwarding decisions are made based on the ingress device, not
the egress device.
