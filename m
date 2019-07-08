Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79E5061DAE
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 13:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfGHLJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 07:09:34 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35593 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727668AbfGHLJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 07:09:34 -0400
Received: by mail-wr1-f66.google.com with SMTP id y4so7984077wrm.2
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 04:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=T/mwyoEbtZAxXS2qX/b/VFmj4D5jLD5Q/j893LrSxRs=;
        b=X3bDMlNELXP8F6g/cG7/wfUgho+WB8fK3bl08Yen6M7Cnndc79DXC7514KOPDIuLKq
         GCaHXJzKpjQA52G6Pqk6Al66Bq037I2iik15X/74vgd5wf4o2T8B+e7J0YaKTGHEwb57
         NyvSBnchGuNty6oze0owI0iBqiwLkVmLo6yMg9Rl8dv5hSeTPVZDRp/Ti5hgZ16JGRvG
         SE0fIdNkYYH7+5I2o4mdrxVRPl0gdXXeBQPJgpbxmjiTLWjao4ykdFLIF7vci0RYQCZP
         /Od2G9UsW79t0U4KIFjGxveTs9U52Q29iWtQaYTMeM6wb/GJyObKxNBIaB0/iOYgG6nf
         wAUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=T/mwyoEbtZAxXS2qX/b/VFmj4D5jLD5Q/j893LrSxRs=;
        b=UZO3hhon0JOma2zmZAVqfT7qHUlXuLtG/jfVbBvc1eV6UuywXcWaOA3lBqL6H2TV/6
         HVZdYr5AGFg24VPNSwnlHIUAxRuBjJ0ANCFbLU90FwKu8VKjrLooY2GjSCid7OTzthf/
         xTcYL/DiWfjbB76MNx9q7oAlwjKN+kBc6YazNtuSv3Wz2g3SrEDxq3slfQTrHUceLWH6
         Cd3G0PftF3AhsJmxGuRMCcO5P28eX6dd/aq7/+ABPC/9Mdfi3Wze01gcEPmIUyJOX2pw
         eA38nVXqxh5ogwjB8RZK8n8ZHPLvzJkgDvpSeoQJf68NTEUMIuzCzzSfjacAl99oheZO
         +pEw==
X-Gm-Message-State: APjAAAVAX0ALuxgp3W57p5xbJqDJsDGhWAJh6oqzvhFqmV0FDp1h1ChA
        usdP+ZyfOBGLBeGiNKUrVq/1vw==
X-Google-Smtp-Source: APXvYqwFsPplm6KxM/fzvAdXKehWGCXEf0SsVC4VwYDGuliu6Jl+n/kb8amI8BqXHOl364CUWLAHgw==
X-Received: by 2002:adf:e803:: with SMTP id o3mr18703996wrm.69.1562584172855;
        Mon, 08 Jul 2019 04:09:32 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id h19sm45130423wrb.81.2019.07.08.04.09.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 04:09:32 -0700 (PDT)
Date:   Mon, 8 Jul 2019 13:09:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 02/16] net/mlx5e: Fix error flow in tx reporter
 diagnose
Message-ID: <20190708110926.GB2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-3-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-3-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:52:54PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Fix tx reporter's diagnose call back. Propagate error when failing to

s/call back/callback/ - it's a noun.


>gather diagnostics information or failing to print diagnostic data per
>queue.
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

It's a fix, please provide "Fixes" line:
Fixes: de8650a82071 ("net/mlx5e: Add tx reporter support")
Also, it should be most likely sent to -net tree.

The patch itself looks fine.
Acked-by: Jiri Pirko <jiri@mellanox.com>
