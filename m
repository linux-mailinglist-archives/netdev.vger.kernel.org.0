Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C606439801F
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 06:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbhFBEVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 00:21:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhFBEVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 00:21:50 -0400
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B164C061574;
        Tue,  1 Jun 2021 21:20:06 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso1326546otu.10;
        Tue, 01 Jun 2021 21:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iMGGsERMcpA8geFW9RIY3rOzp/NmJwFBkoB6KSFK9fg=;
        b=kXURr4p8FYVcPWJPYQpN81Dnc23rFNR576uqzwHXok9JqcJIjI6lYm+b/65+Kc7BzQ
         r3lfmmlY/ey68rQd9erNzPIRbPTPUCxhzBZWVFFYM354letowY1j3NV0w5pkBdOTs7fX
         lTDz4+vUHQ+5wN/nV8MO+4oMzUADGYznF/ijy2lvw6uR4vhT/Dch7MpI8OFKHPLWdHNZ
         kPeOF4sU8Umpl/15u5sBC9ePcVHkxAoG46af2xb1ljN4C150i/RHON091eYeWHF9R0St
         K8tN98do0Ar+WlfhtnaJUj5tDrmoZcYtM+re/HfDitBJY0H3GWZ/Cg70t+mpnsG/DECq
         LNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMGGsERMcpA8geFW9RIY3rOzp/NmJwFBkoB6KSFK9fg=;
        b=pskiJ+wiAsBnnQ0ZwCR1YEqavTWWy4H+cpH2xiLnfvlUOEJohvr4WosOoo4ug9Rvml
         gYyVWb8SMLEPDNIUqgnIHzeftJrMdYDSuvSlhQPipMqSjv+8Qr9uli8299DvI+nvWP4V
         oXXsuXeKN1yOT2YvOBjl62ElnKDGcibczURFVV8/mHSEctd0VFN5GmZyBCbmKVPnm5FS
         qMlJZjOWVW3aUfUtzFX8UaIQj68MSVaBZg1UVaf5ll0kvScjji/HHvKOPWNd9b8orWiQ
         A+FLbwpLNODirMU7rP3KGPYn6OiZ0vWKd6nDeU+Iocxqgg9iymC6VcItADwULvM8iIVj
         VB/w==
X-Gm-Message-State: AOAM533sYufswtFAenhZC6LH0Rx/Wh4TT4CQ5lSyGpn48PhXD46lNnqS
        6URmhr4N6L9suVuOXtVVlEc=
X-Google-Smtp-Source: ABdhPJxIICiS9DApqp6rDz37Pujc3qqjy2E0zZ1KFQCNVyxmacAjPjgq5QQFR3HoGsyV5xY4tmfwRQ==
X-Received: by 2002:a05:6830:16c4:: with SMTP id l4mr25176368otr.93.1622607605823;
        Tue, 01 Jun 2021 21:20:05 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x14sm3932671oic.3.2021.06.01.21.20.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 21:20:05 -0700 (PDT)
Subject: Re: [PATCH] ipv6: create ra_mtu proc file to only record mtu in RA
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com
References: <7087f518-f86e-58fb-6f32-a7cda77fb065@gmail.com>
 <20210602031502.31600-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <05efe271-72f8-bc77-8869-ae4685af5ea4@gmail.com>
Date:   Tue, 1 Jun 2021 22:20:03 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602031502.31600-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 9:15 PM, Rocco Yue wrote:
> On Tue, 2021-06-01 at 18:38 -0600, David Ahern wrote:
> On 6/1/21 3:16 AM, Rocco Yue wrote:
>>> For this patch set, if RA message carries the mtu option,
>>> "proc/sys/net/ipv6/conf/<iface>/ra_mtu" will be updated to the
>>> mtu value carried in the last RA message received, and ra_mtu
>>> is an independent proc file, which is not affected by the update
>>> of interface mtu value.
>>
>> I am not a fan of more /proc/sys files.
>>
>> You are adding it to devconf which is good. You can add another link
>> attribute, e.g., IFLA_RA_MTU, and have it returned on link queries.
>>
>> Make sure the attribute can not be sent in a NEWLINK or SETLINK request;
>> it should be read-only for GETLINK.
> 
> Thanks for your review and advice.
> Do you mean that I should keep the ra_mtu proc and add an another extra netlink msg?
> Or only use netlink msg instead of ra_mtu proc?
> I will do it.
> 

I meant DEVCONF and notification to userspace was good, but using an
IFLA attribute and no proc/sys file is better.
