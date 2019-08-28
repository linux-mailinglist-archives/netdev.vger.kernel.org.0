Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4045A0DF4
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbfH1W6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:58:37 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37792 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfH1W6f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:58:35 -0400
Received: by mail-ed1-f66.google.com with SMTP id f22so1821867edt.4
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=MWIFKIzouiKNiGjOqNU3Lg2whivTBv+XNz2yxpVpVdk=;
        b=rczdY01AKrKa0uF52azBBxJb1SYipY6u79S6FnAjJZbqKBaWR4bEt5Q1F/z+gPOmV8
         2LgNnTLUtcsNPBxAimDjDrKhK0XRpX2UbKs39RWkqXGG9vFmXddS5Chm8nmO/ctPLS/W
         7Q3E4uzkWIt60Md8eSjv8qlbJC/ug1geug3/TgIL/4PFwjIPXZfAbBt8c5t0Zy4vZbJE
         zAOpSAmCM9V6Pw/rW6+TDwunxdFqfAuY2uHJ24RM3iuy1UP6oeVKO7wlEexYBwI5EEZG
         aCfhrSzLY3b5JnFMCUmlK4fswrNsctSFSCY1XQ93oEnydxJoaICx83awfv8BwNZUXeMX
         4aag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=MWIFKIzouiKNiGjOqNU3Lg2whivTBv+XNz2yxpVpVdk=;
        b=KoqRbCGVh9IdrsDZvQGA5YglmUiGkQ1zNCtAgpB4jYHlfxRJwwFb/ekmgyXR3bNPao
         +7gE0FOQPvMaGblidqZJAmEWM2kmGrlH1V+p0oexXQ4pk69rmDFCzXxUJLh6oppLdiVw
         t3CWcxrFJ9RlTGK3E8AdK1cZncvQgpdDeoXHIs9Y39JmTckQz/Sa5akO8hmEF2sOhxdr
         CDibqmXrOu6P2bkrbV+gYvV8T7HFvFmxMjPO4ohfMmYzEbm0h25gN8T7gSyYAprBePIS
         rKdd2/PdmDHrSlbnyp7UyS0dkKoYzvmTbgBbkq1ZNjKQzrIqqMJ3zAFw33AR2Bdp6NBk
         rvTg==
X-Gm-Message-State: APjAAAW2kHwH6PEa2XuAt53tB91KAZGh4eHVjJMlDUP5q5Vg65ZijC4X
        3CyqXzNnz5yOepOSU6JGq9fZBA==
X-Google-Smtp-Source: APXvYqzlwrSyUeO/iZbE6dDzW6rjW3NYftlJjlyPkx6b8TsSKh+G73SS2+o4rdG+5KdBZyEOmHOotw==
X-Received: by 2002:aa7:da4d:: with SMTP id w13mr6716505eds.224.1567033112940;
        Wed, 28 Aug 2019 15:58:32 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k15sm101111ejk.46.2019.08.28.15.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 15:58:32 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:58:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thomas Bogendoerfer <tbogendoerfer@suse.de>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 05/15] net: sgi: ioc3-eth: allocate space for
 desc rings only once
Message-ID: <20190828155809.5c155bee@cakuba.netronome.com>
In-Reply-To: <20190828140315.17048-6-tbogendoerfer@suse.de>
References: <20190828140315.17048-1-tbogendoerfer@suse.de>
        <20190828140315.17048-6-tbogendoerfer@suse.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 16:03:04 +0200, Thomas Bogendoerfer wrote:
> Memory for descriptor rings are allocated/freed, when interface is
> brought up/down. Since the size of the rings is not changeable by
> hardware, we now allocate rings now during probe and free it, when
> device is removed.
> 
> Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>

So the rings still get freed and allocated from ioc3_init()
but there's a set allocated from the start? I guess that makes 
some sense..

Most drivers will allocate rings in open() and free them in close().
