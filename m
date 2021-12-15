Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0888947537F
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 08:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240324AbhLOHJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 02:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbhLOHJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 02:09:10 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF48CC061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 23:09:09 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id f125so19503170pgc.0
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 23:09:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QZlQadoGAwUafQy4zEDbySuEW6K5VdVls2aT6y7tSuo=;
        b=e/nZVL1yaUHjzjYEOnQaQcLvI4m32Dr6bRJk/MIUhrpwHSbCnecGOy4KxOc66bjHur
         k4GHJ4FSRo1r3rA4xxNBAOadzu7nPom+mDz/47QML6BmgY47fMbl7A1Ybvqb1dnMdhU1
         07yeaaymz+7DpnFH6yi0NTKNdOpz74N3hrbypw47xaFWOnekpNRjyhKi5fKJ8P1Apo9x
         AT5v/Gf42Oq3gh6w1eiaxRO4gXemhXr7WbiPv7X5xR+Uq2oC3QLb9ds0hYPgWcPMciDW
         RaNSOME5Xer51Ex9SXidvc0ikQQmzyRrilXTJmGNxdkILv89XHTJzmIL+QIpwOEZLChc
         Kjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QZlQadoGAwUafQy4zEDbySuEW6K5VdVls2aT6y7tSuo=;
        b=5jXK8ZOi72FIrM8WEhaL5OamgDJ3jSfbb8+6NmQp4jfnmId8mLSJDh6TlZjx/UgvES
         XEWLvxihvUsVUVD2FGpcjf0LQ/tZ01SFqkthNPMlJHKn7mzdrDXaMwarr8aQZj3VE5XB
         nl4qtMvOS2AwespDlIdoGS6czFaT5/zARvHKwSNCajylQm/U+NPvcNBKkDU+fzHg7cMu
         heIB/lGfGtdwN9Q2qWvrk7FaJ3fKeH/RdFR84JdKb7SCsk+aBbGdgmbiK7rQ+xH4ULbp
         PpfL+5hUSQe5C7VC3u5gqa1Rvae8bU86UHxvdL2CJj7vQnZZqQ5/VGg52LEBIcIEHVT/
         9XxQ==
X-Gm-Message-State: AOAM531YnRX6eZdDvVmip6Q/iuTbTFaQFPxVmq0vuJ6KhEHxmTUCTUos
        DX5u6mGY6WV67FO3JlWz78qRBHNR4X0=
X-Google-Smtp-Source: ABdhPJyZ6wdRIlD4r2bnINptuy+PZdIQOKOHvdMiqMXgiHtWYhWyUTPIM/zc/aXKwR177YIKGvxwMg==
X-Received: by 2002:a05:6a00:1a16:b0:49f:ed6d:c48e with SMTP id g22-20020a056a001a1600b0049fed6dc48emr7701670pfv.14.1639552149074;
        Tue, 14 Dec 2021 23:09:09 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16sm1179618pfl.69.2021.12.14.23.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 23:09:08 -0800 (PST)
Date:   Wed, 15 Dec 2021 15:09:01 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>
Cc:     Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jarod Wilson <jarod@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH draft] bonding: add IPv6 NS/NA monitor support
Message-ID: <YbmUjVHQQR8eJ3Xt@Laptop-X1>
References: <20211124071854.1400032-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124071854.1400032-1-liuhangbin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 03:18:53PM +0800, Hangbin Liu wrote:
> This patch add bond IPv6 NS/NA monitor support. A new option
> ns_ip6_target is added, which is similar with arp_ip_target.
> The IPv6 NS/NA monitor will take effect when there is a valid IPv6
> address. And ARP monitor will stop working.
> 
> A new field struct in6_addr ip6_addr is added to struct bond_opt_value
> for IPv6 support. Thus __bond_opt_init() is also updated to check
> string, addr first.
> 
> Function bond_handle_vlan() is split from bond_arp_send() for both
> IPv4/IPv6 usage.
> 
> To alloc NS message and send out. ndisc_ns_create() and ndisc_send_skb()
> are exported.

Hi Jay,

Any comments?

Thanks
Hangbin
