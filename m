Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B59F0DA32B
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbfJQBa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:30:27 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39301 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727399AbfJQBa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:30:27 -0400
Received: by mail-lj1-f195.google.com with SMTP id y3so693557ljj.6
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=f/PQegEoIpBB4MGY4fNUCmW+CJDi2P5mhk0/EPdgpDA=;
        b=sIvaIr3CsG2EmQ4+mCgEtbiGB4EIOTspEErgwN7YaP9YvhOkA02tmRvaIQNOEoW0VI
         hXrfpHpuV5U5FAWotntWJ+QNUDS170oy560ytvDw7nwKqi+vLrLgZmwR9ax5CaXARSAN
         9QWv46+uu7AcwRpOznN7xFa/sFk2R0Kww45jOAbUE10ajwBLadflMwz1/N7EmdFtubGq
         wAEwPEWHmGnZJhMFD/5zMaRPToijPmA7+98XuIuYaJrOhxsUsqaRjMeHjmqzxjSqEGyq
         XMANum/mtY9ZV+cAqtquZ80TCu5etjF45X8fxsKk+AJNwQ/FDo1lqQWH8pVBxCOu1eU4
         eZxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=f/PQegEoIpBB4MGY4fNUCmW+CJDi2P5mhk0/EPdgpDA=;
        b=f8uw43uxYTaL5cCN+0kSWV3xu6uLmAHnplv0NovPQMHt/zRgVnmp8tBaad80xUTSjM
         bi3+Z9gtH8a+UFBE5Fw1iqfYibTz9fYzXWRNdig/f6H3lhG6UGnJCL9qLJ3RspoOGnJw
         Ygk+LKO3VElontyvhfflYFDXIm265NC3Z3YU0jbzjtWwZHVlBDXghfJ6xNcifieEEHpt
         DBe5CGal+ujWwfoHY8YXUrYTlkVu3G2NLnLYK30HQkCDVNTqPB6wK+ajGTJ68XG9vCQo
         inVJL1AwpiRDwZ0L6V8RCOXZeE2tFvdGGS2uCfa1NzV0FbU4VXVYjV4f9747yq4mhOe3
         Qziw==
X-Gm-Message-State: APjAAAVZAgqi4hR1ynruhfaTEQwRXekPyiX7mbQMEnfZfhkzylW2p53p
        Kmk36FUcrRPuuueXMXMl8uNOKTfBV28=
X-Google-Smtp-Source: APXvYqxYntt8CrV12WF8etW7yrDgRSW4areRB1rlnEIueShHpRm7GK7UiLt7wwxQOSsHYaHe7gDf4A==
X-Received: by 2002:a2e:9759:: with SMTP id f25mr620931ljj.173.1571275825632;
        Wed, 16 Oct 2019 18:30:25 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g26sm272913lje.80.2019.10.16.18.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:30:25 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:30:18 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <brouer@redhat.com>, <ilias.apalodimas@linaro.org>,
        <saeedm@mellanox.com>, <tariqt@mellanox.com>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH 01/10 net-next] net/mlx5e: RX, Remove RX page-cache
Message-ID: <20191016183018.62121bdf@cakuba.netronome.com>
In-Reply-To: <20191016225028.2100206-2-jonathan.lemon@gmail.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
        <20191016225028.2100206-2-jonathan.lemon@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 15:50:19 -0700, Jonathan Lemon wrote:
> From: Tariq Toukan <tariqt@mellanox.com>
> 
> Obsolete the RX page-cache layer, pages are now recycled
> in page_pool.
> 
> This patch introduce a temporary degradation as recycling
> does not keep the pages DMA-mapped. That is fixed in a
> downstream patch.
> 
> Issue: 1487631

Please drop these Issue identifiers.

> Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
> 

And no empty lines between tags.

> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
