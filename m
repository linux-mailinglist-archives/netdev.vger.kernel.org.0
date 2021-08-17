Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 576563EF2EF
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 21:57:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233733AbhHQTzc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 15:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhHQTza (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 15:55:30 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08271C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 12:54:57 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id u10so848038oiw.4
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 12:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xob6Ce08HDG/Hsz4D+J2yrYb20flAMFS/yRie6YqXeA=;
        b=FJ8DpFvlbW/iQ4BLmQOt1rLlmA8GF/h00vhUM5OR0fKhm0owfsupyluAqOrQScIRkL
         yDxooQgcX4WGD3B+wTDOiWdya+VWW7l7b1/CZFW7D+P1b+zDkD8r37MdSiQ+EHlOCBsq
         m5wXpRluFvp0yRV7PAZaNF6LdnBVO3VZOamPAQnScZkkb2YYGyhK5JPicQnfDF3Tu1y3
         2wxRF8nJ8UDzAhoMsKThMB9xEO56VuxaYIffVCL3OfkHHyurSKp94Bs449MzdE6FJdpY
         L2p8VnQ4LCw4LPKkoGzOxWn8+vFLxsPNrhx/fn/wuTRAgI5JXTb9jKM+jsvQMhFIquKt
         C8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xob6Ce08HDG/Hsz4D+J2yrYb20flAMFS/yRie6YqXeA=;
        b=slxhdiDJ7TlED1VWT3OXt0GkZe0DrOTSeo2Sk8JmdoiWjPPe3JQGL9+l3V7wOq4IJ6
         orxsFRQsqcKDmxwG4aPQro1WBcGAgFbqIKFwX34Jul2Y8zUAfZtuE9gbi25WzOEYQod/
         5kbWxKYPQoU51enKsyL1TeiwL+qR/HI5roPDuWTcGJi8eixd/BHVPMhO17B/CU6l2vBA
         j2hKMCaZ6rbx+liRLuiW9H6VfJbXgBQuaf5PMrJd0OIyJm+udr5c0B6aiu985q+AJqcD
         6p+VrUx5jG+8YCmys8Yc0r45g1b3aVrwvrqFLpr+Vix3GzFavM3mDbrGg0pE4o7t3DRH
         F4Fg==
X-Gm-Message-State: AOAM531NfPWzWSyL2+qyECb+5jU2o04FkoFiBuZJboiPC/qtR6WlgMWT
        eGd5IVYJh2bmC3doMzWbpynRP8kIoNM=
X-Google-Smtp-Source: ABdhPJz/ViPHM4cefA6I1tAPMbeS96i6+ivY3MAfHCOoxvJCRZI15oPBqnZetmaWLhpFZR8WpeF01w==
X-Received: by 2002:a05:6808:f94:: with SMTP id o20mr3739259oiw.112.1629230096318;
        Tue, 17 Aug 2021 12:54:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id j70sm584463otj.38.2021.08.17.12.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 12:54:55 -0700 (PDT)
Subject: Re: ss command not showing raw sockets? (regression)
To:     Jakub Kicinski <kuba@kernel.org>, Jonas Bechtel <post@jbechtel.de>
Cc:     netdev@vger.kernel.org
References: <20210815231738.7b42bad4@mmluhan>
 <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817202135.6b42031f@mmluhan>
 <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
Date:   Tue, 17 Aug 2021 13:54:53 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 12:44 PM, Jakub Kicinski wrote:
>> @kuba With PROC_NET_RAW I consider the problem is found, isn't it? So
>> I will not download/bisect<->build or otherwise investigate the
>> problem until one of you explicitely asks me to do so.
>>
>> I have now redirected invocation of command with set PROC_NET_RAW on
>> my system, and may (try to) update to Linux 4.19.
> 
> I suspect the bisection would end up at the commit which added 
> the netlink dump support, so you can hold off for now, yes.

agreed.
> 
> My best guess right now is that Knoppix has a cut-down kernel 
> config and we don't handle that case correctly.
> 

CONFIG_INET_RAW_DIAG (or INET_DIAG) is probably disabled. surprised the
netlink dump does not return an error and it falls back to the proc file:

        if (!getenv("PROC_NET_RAW") && !getenv("PROC_ROOT") &&
            inet_show_netlink(f, NULL, IPPROTO_RAW) == 0)
                return 0;

can you strace it?
