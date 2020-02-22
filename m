Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E16168CFE
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 07:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgBVGyo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 01:54:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54460 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726726AbgBVGyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 01:54:44 -0500
Received: by mail-wm1-f65.google.com with SMTP id z12so766349wmi.4
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 22:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rWp/7B6Yp6ADrgOXQPIgQbkYpc4oxjVruU2G/eBlbn0=;
        b=ngmtQjYGrLMN8QGyNCLLU5p8972wNtKY2OINll/2ldCvwqwtTINSW9uJ8HyDcCfITg
         DI2J6zS0Im4tFlbOjHoEvJpRyBkPq1CF6Aant293GJjtSs5ppb4NpsMUnheQeXthmK1G
         KTvaXo1ynmFs5JHezQ7V/G1695GrCfcdFMzjst6X96WX1OczEWw6oc2WkTFw+GsnmxCM
         dIGYpevYs8jyAN8GurZRjBUO5eiVEqZr7eg7T9Jb0/XwB9khm+dpACCEebfvOeVT1Tq3
         e+LOGEMQ0VO46gxDtQpgFeETaEEB4PXZjnUVRsUymQ9h5w1VXICSYBJkmX+0GGgU5/lL
         isEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rWp/7B6Yp6ADrgOXQPIgQbkYpc4oxjVruU2G/eBlbn0=;
        b=PxSuYtAx/nHgwY/dwzIZd8hYmekTk9PGcnlgPuFSTVM/CIfr2e2xGu6rSxWdfaWct2
         fnqlbB10tnCZyqNigI1McXvTfTuFvwpyKmGTmudyEuiYfF8YlX6lH5B3TTGVoCpDbi2v
         clKJEF5LCzLx+W/vRcp5I6EfA2ZHZO/BVH9uzuNYJcXJ3UrlXbQMMOXnaMEXHsajKfqe
         Qyi2O/o9CmEPRc6SzHfqV2ACyIWiWo2ar4nwqfR8vuDR3VdEvohumQrkQfjAQGgrSR/m
         bBIrH0Mbgmx/rSwY/Rd7foY4ktW8LpbLrQf9QWjzYa3Vo5Hg5+gidcDMvnMZ3c2zxGXp
         NDlA==
X-Gm-Message-State: APjAAAX0A1JYvdXMuVkD9DkvHYJ9mVFdk0VlkSD8Oy4A207kUSDkTZMu
        b5FMZ0tNormILBLPDUDVNId7Aw==
X-Google-Smtp-Source: APXvYqwj58zVTMKE7cRS0lk18Fd+gZw+oUl4y9AkmysWcLC95uMAuDeIhEM/xsjvmYRavMOYRdpyLw==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr8136783wme.37.1582354483100;
        Fri, 21 Feb 2020 22:54:43 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id l17sm7155554wro.77.2020.02.21.22.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 22:54:42 -0800 (PST)
Date:   Sat, 22 Feb 2020 07:54:42 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net] net: genetlink: return the error code when attribute
 parsing fails.
Message-ID: <20200222065442.GC2228@nanopsycho>
References: <933cec10232417777c5a214e25a31d1f299d1489.1582310461.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <933cec10232417777c5a214e25a31d1f299d1489.1582310461.git.pabeni@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 21, 2020 at 07:42:13PM CET, pabeni@redhat.com wrote:
>Currently if attribute parsing fails and the genl family
>does not support parallel operation, the error code returned
>by __nlmsg_parse() is discarded by genl_family_rcv_msg_attrs_parse().
>
>Be sure to report the error for all genl families.
>
>Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
>Fixes: ab5b526da048 ("net: genetlink: always allocate separate attrs for dumpit ops")
>Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Thanks!
