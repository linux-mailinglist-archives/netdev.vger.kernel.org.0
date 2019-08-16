Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E28908DC
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 21:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfHPTo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 15:44:57 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45019 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfHPTo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 15:44:57 -0400
Received: by mail-qt1-f195.google.com with SMTP id 44so7323460qtg.11
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 12:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8oUD8uoK0U6eFOyqa1XdhinrbHHTjvt4vpE48z+ZU84=;
        b=inuomRVSW6pUNWICL/LbsTDKMo3RFuU0MwjtDwAmZ/ul11E1NZ00LJ9DyRk41zY7lH
         PQ5mS8WIPGJ29Idzv+lEjxBYaVGUxS9PuoKSanjPK2Poegc5eDbP7ikPdo1Tiy+MJjXu
         eZ8l20Gl0bj5tazFxsSjC6tyIlmsk7WiKl92eX/F3xrnwknxfylLwY3aLo5tMaI0pq8D
         cVzR/9gp/hTp1UMuo90lvfHQKlvMhIMIATbq9g+j69oPL6NkS9Hd0qYCy95O6wlEvUXj
         iXQWU+RXsym8ifNA4Z3SbfEy6DoQK8hsnrkJvTgiLqUJS5DSaSaJk7lhdBIHbBZsXGd6
         j6Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8oUD8uoK0U6eFOyqa1XdhinrbHHTjvt4vpE48z+ZU84=;
        b=Ys5b0xUjaP13KzyrvtF1xqLogiS6OpJY5/2c28wmBmntY3eFw8QJpJNo2Benev9ZE0
         xV+TlU8KJ8EMbb/gujQwr8L0Mm0JoYbjYdGwDowTKX7Jk5u+uYifUcfhtBowX85garJ5
         Z8Deug8lw7aY+sBtzO9NHC/E++axNi9OKnFYRu7pNiFDmghZzgfmZGHwhVM4MY2F5sio
         dyRHqGmJj0AZtga4bpWf6UzWDzcn4xEi8E7LWngn9x6WXJC6pLHsidzs3CW81XBnNaAx
         Myr1iUdazmJ5VU6l72d/xFkvtx21RaVQhUwXLxLKSD/Gxrh4SDkMvU/EjdGN/L6jbDnk
         ftPg==
X-Gm-Message-State: APjAAAU/8Pmy5xAU2HEMMYIZQdIkGY+3L33cV6ZzZov/V8PHRFtIBplJ
        n80RP2MuHYeCYERRMuid9lJULQ==
X-Google-Smtp-Source: APXvYqyThjW/BK3sV6h6FsEOIUaTM8wHYUa/3RM+1cvkwCZoYYzkocQGFjDKyvknq7JuMpiGF8phpg==
X-Received: by 2002:ac8:376c:: with SMTP id p41mr10458702qtb.306.1565984696577;
        Fri, 16 Aug 2019 12:44:56 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m8sm3812416qti.97.2019.08.16.12.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 12:44:56 -0700 (PDT)
Date:   Fri, 16 Aug 2019 12:44:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net,v5 2/2] netfilter: nf_tables: map basechain priority
 to hardware priority
Message-ID: <20190816124439.7cc166c1@cakuba.netronome.com>
In-Reply-To: <20190816012410.31844-3-pablo@netfilter.org>
References: <20190816012410.31844-1-pablo@netfilter.org>
        <20190816012410.31844-3-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 03:24:10 +0200, Pablo Neira Ayuso wrote:
> This patch adds initial support for offloading basechains using the
> priority range from 1 to 65535. This is restricting the netfilter
> priority range to 16-bit integer since this is what most drivers assume
> so far from tc. It should be possible to extend this range of supported
> priorities later on once drivers are updated to support for 32-bit
> integer priorities.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v5: fix clang warning by simplifying the mapping of hardware priorities
>     to basechain priority in the range of 1-65535. Zero is left behind
>     since some drivers do not support this, no negative basechain
>     priorities are used at this stage.

LGTM.
