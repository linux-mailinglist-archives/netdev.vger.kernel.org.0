Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD1F185E98
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 18:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728947AbgCOQ4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 12:56:20 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39040 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728628AbgCOQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 12:56:19 -0400
Received: by mail-pl1-f196.google.com with SMTP id j20so6763436pll.6
        for <netdev@vger.kernel.org>; Sun, 15 Mar 2020 09:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cid5VTPLehlCeSHLqDLGZ0DFhpoLzemPUpfKk2XUYkA=;
        b=lUBAGMI7hSPlKUpxCeuygTDGOOTmSeWTKgX/5XUJHkEb465zLbi3oXCcDMqT0VZ9/o
         dEKPIdV7z9I1/D8bsOUdcsTlkYtixNiall8OZBKDuOuEhU1b3ZDxX2JSjmf4EA63s53e
         qMIOGg56HwmgpefukWH/sZTKWwKlPP8C7Ri7KBXfsncpBACaFebNecsox+vKdiLhh9aL
         LLhmYpTAQu8ys6clx37yxdggnnyiCh1NIRZt9TtiuJa2ZmKoCn4bgQtnjv2hTpKLhUm8
         r4BXWF9H84KjT6mmKgSnzp7UoPDlyLheXB/c/6qaMuk6DFXt5FB+wAy7HC5Y022zEQiv
         8tGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cid5VTPLehlCeSHLqDLGZ0DFhpoLzemPUpfKk2XUYkA=;
        b=nBHL4MvXxouDp5z03UYp2w47s/iYznmJXbHpzYyzb71avEYiy9CPQC9HTph5dX33vM
         9yx7lUgIWKoXHTy04daQEMI29INnTSHvIcQRvoMNDs5iCFnyjjpB71izv9EhBn0bF5xt
         jiUM+tGsLJi+I8IQA3sJXrHg5vVYXMPa8SUhExqktRa431ETbPKmdwtmuZc8ihoRdzyx
         yrF6EWy6sznRPnHJ3cKcDn/6BgJeYhWlc1Z58IEmnzoxXaJAUvlOr8SHpD5jn80LyNQi
         D1L3ocS2rRFY6g4isfqSXgxGxynTGW5i9OrUlskzVaRKhhhmYS42Swrfs1DYytu2Y4B+
         DPxA==
X-Gm-Message-State: ANhLgQ1TnxV6POrabzerStQGimKm0ZH1ZAMImXnowmHpWM/dy+GmGV73
        tJ2dKEVRAX2mm6mfsO4T8WW6+vnmL8A=
X-Google-Smtp-Source: ADFU+vsGUjHQ8M0PnV7pBXMyxN78LeCh4myPBk5mWktI/az1QdPdO4lqaxiFsGitM+5p/9GlWIUnAw==
X-Received: by 2002:a17:902:d88d:: with SMTP id b13mr21701134plz.228.1584291378866;
        Sun, 15 Mar 2020 09:56:18 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id 6sm23448565pfx.69.2020.03.15.09.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Mar 2020 09:56:18 -0700 (PDT)
Date:   Sun, 15 Mar 2020 09:56:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH iproute2] nexthop: fix error reporting in filter dump
Message-ID: <20200315095609.55264c48@hermes.lan>
In-Reply-To: <07545342394d8a8477f81ecbc1909079bfeeb78e.1583842365.git.aclaudi@redhat.com>
References: <07545342394d8a8477f81ecbc1909079bfeeb78e.1583842365.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Mar 2020 13:15:17 +0100
Andrea Claudi <aclaudi@redhat.com> wrote:

> nh_dump_filter is missing a return value check in two cases.
> Fix this simply adding an assignment to the proper variable.
> 
> Fixes: 63df8e8543b03 ("Add support for nexthop objects")
> Signed-off-by: Andrea Claudi <aclaudi@redhat.com>

Applied, thanks
