Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 498AE210009
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 00:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgF3W1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 18:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726139AbgF3W1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 18:27:38 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36435C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:27:38 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so21699032wrc.7
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 15:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t2W9sF6t8aHND3NKsdczT5+GvITCXwwid4kHS/FGw4g=;
        b=TuSr0Suc2mf0yuNUx5pUBAICnlOznAAWSYdbrv6+4I+fhZ0zdZxqDahar9EwcWKcon
         SnKv6A0YG67fFOcSiQGJuVNNcZfSipcA+Vkp/9hbLnxmVxlULLoPJVUQypMNXgwHUdP6
         T6t6XtiKPgmRACIonf79vuW4DGZbVdtu+Qdzl4EWm9GFad3uiKVXtwWCzRhzU0zg4Tls
         U2jTyNZYijAhzeXRA9zDcCdqz5QcnBCu5ykj3mKs/DIlhAyD+ajJvh6PdnpKxYOwYgEb
         48E4XWS4jKWe0f6Fysvn0acYKrUwWoZyS6PNIQst0TJ/mWoxseCO7GmnzPmMwOulacWs
         fHLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=t2W9sF6t8aHND3NKsdczT5+GvITCXwwid4kHS/FGw4g=;
        b=Guk6wPNk4z1hz0/coraEBzIrkd5VxZ8QqQ56E3hsCG3TR4RcbBq4kR50WStDq1ocOx
         ZLQl3+5F/GFpvjf+NZPpt48G+wChqXIDCoi8PsQcu5beW7qlRBZp4IHfSRUs5HjloMzp
         Rq1Sz1KQhw1LHlIGBkPfByiGFXr207bV8FD/C+Z01vvmjq/POaSP5mbxc0U3C97ByvxC
         zUppzNPXo49gsUEBNg8Xm4I7vkgYQ+bYJ0YFgpSw4ru6qrnBGLQHCWxzahHBxWO+jVud
         PkWuhfNppE8lMPXrAGoyJoPh0LR2Zd3Yc37/tmYfV9lZZw2pLzY00wyD23JuNJ4pI/AE
         djHw==
X-Gm-Message-State: AOAM531dFtFANc2BgS0fYRriqmVc0yI8hHGDLSJ6FtnvL1JluzlcJgSH
        onHH1sqC0idcwwN8oA7xMaRWpuP1RJ3qtA==
X-Google-Smtp-Source: ABdhPJxLGRmqIcbfJuYfIbAOt7DqWucCENT9jx2d50pqrOCQSgMdByGH3FY+1lAcGVzkTMgBzam4jw==
X-Received: by 2002:adf:f14e:: with SMTP id y14mr23731792wro.151.1593556056863;
        Tue, 30 Jun 2020 15:27:36 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:35a0:f979:fc54:add0? ([2a01:e0a:410:bb00:35a0:f979:fc54:add0])
        by smtp.gmail.com with ESMTPSA id 33sm5198043wri.16.2020.06.30.15.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 15:27:35 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v3] IPv4: Tunnel: Fix effective path mtu calculation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Oliver Herms <oliver.peter.herms@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
References: <20200625224435.GA2325089@tws>
 <20200629232235.6047a9c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <99564f5c-07e4-df0d-893d-40757a0f2167@6wind.com>
 <20200630103335.63de7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <86c71cc0-462c-2365-00ea-7f9e79c204b7@6wind.com>
Date:   Wed, 1 Jul 2020 00:27:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200630103335.63de7098@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 30/06/2020 à 19:33, Jakub Kicinski a écrit :
> On Tue, 30 Jun 2020 17:51:41 +0200 Nicolas Dichtel wrote:
>> Le 30/06/2020 à 08:22, Jakub Kicinski a écrit :
>> [snip]
>>> My understanding is that for a while now tunnels are not supposed to use
>>> dev->hard_header_len to reserve skb space, and use dev->needed_headroom, 
>>> instead. sit uses hard_header_len and doesn't even copy needed_headroom
>>> of the lower device.  
>>
>> I missed this. I was wondering why IPv6 tunnels uses hard_header_len, if there
>> was a "good" reason:
>>
>> $ git grep "hard_header_len.*=" net/ipv6/
>> net/ipv6/ip6_tunnel.c:                  dev->hard_header_len =
>> tdev->hard_header_len + t_hlen;
>> net/ipv6/ip6_tunnel.c:  dev->hard_header_len = LL_MAX_HEADER + t_hlen;
>> net/ipv6/sit.c:         dev->hard_header_len = tdev->hard_header_len +
>> sizeof(struct iphdr);
>> net/ipv6/sit.c: dev->hard_header_len    = LL_MAX_HEADER + t_hlen;
>>
>> A cleanup would be nice ;-)
> 
> I did some archaeological investigatin' yesterday, and I saw
> c95b819ad75b ("gre: Use needed_headroom") which converted GRE.
Thanks for the pointer.

> Then I think Pravin used GRE as a base for better ip_tunnel infra 
> and the no-hard_header_len-abuse gospel has spread to other IPv4
> tunnels. AFAICT IPv6 tunnels were not as lucky, and SIT just got
> missed in the IPV4 conversion..
Yep, I agree with you, it's probably "historical".
