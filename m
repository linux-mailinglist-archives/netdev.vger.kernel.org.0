Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2E8310DF4
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 17:37:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhBEOzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 09:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhBEOwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 09:52:33 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EE7BC061786;
        Fri,  5 Feb 2021 08:31:03 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id u20so7435320qku.7;
        Fri, 05 Feb 2021 08:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=79c3C5DFNJ8WA8GjidhCQlz0ze6LMsMDakYhczjboWk=;
        b=IYWurr9pqj0rjJmEfMg1YrQWHhA/HUTt5Jo8vEy75RWmPmgdpgkgICp/PVBHuTtFGo
         md6JRzrGd/vigb2Jq/ogGh11jr+KA/CwmAMH7/Z2l8xQkQRTLle7x31F0BNqOc1Rs/bp
         PkyiGNKCxbKqn9jWReL0X9MyBqkSUAhnBtppt6o0jnPXJKmzdxyDhMGS5tfLDe7D6YR3
         CmU8lPuze4Fo59V8oXSukcRTBTN5ptw9hNdWTtU+uoDtQmtsqrxGinfdptMdJHr/hSls
         YrMMk4BtpJWIbdr/dUYmUe4eFgo5iaoQlCF4Y3R+WAblZWnMFLaMYQyrjRSoUJgGmdgc
         tenQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=79c3C5DFNJ8WA8GjidhCQlz0ze6LMsMDakYhczjboWk=;
        b=fLxbVKXSp2Tzm3qy0H+1+Sneal5Hsilye2yZH0yHjPTsx7ClGmC5IX52GvV+QucXkl
         2/J15Fr13TYy5nnPOycXtLLNPLxuWcW5sJCxueA8FWzKRXY+LnyxPzkjDzJsfoHczZWe
         9jQg/86JgmWkmlhWG8HK0cdh6BKZyDZN6+njtMB8l//XzrX9iYMMqk7lq6/k67qVGYd5
         SfWnEKDcF1QnCO1XgIQGQ/BiamK3af24UKc64150LC5d0wrOu1h2FC8yiHMO5M5dHf02
         FpIJyszNKXSz8LAGK7y9yoqO/yTOHdY5DmZoRFDUdXq6mijepVIWuIvcZvBJS6yJ+1t3
         mH/w==
X-Gm-Message-State: AOAM533pasKJ4qGcw3H8VQjd3GB1zCzBm8uHG3OMsstzW9V5BxYiulcU
        8mkuR4pXaxiTy5CMWaFEWsW1u+kTFZyPuQ==
X-Google-Smtp-Source: ABdhPJwi3k/qRogPYiAooPeQqFkqdDdgJr4zFAL/3iyry38WNQnlvXREfylR4C/P/ldJDnwQLF8IHQ==
X-Received: by 2002:ac8:7757:: with SMTP id g23mr4383003qtu.305.1612535564872;
        Fri, 05 Feb 2021 06:32:44 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id p188sm9477098qkf.89.2021.02.05.06.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 06:32:43 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id B2339C147D; Fri,  5 Feb 2021 11:32:40 -0300 (-03)
Date:   Fri, 5 Feb 2021 11:32:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     NeilBrown <neilb@suse.de>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Xin Long <lucien.xin@gmail.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/3] net: fix iteration for sctp transport seq_files
Message-ID: <20210205143240.GA3406@horizon.localdomain>
References: <161248518659.21478.2484341937387294998.stgit@noble1>
 <161248539022.21478.17038123892954492263.stgit@noble1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161248539022.21478.17038123892954492263.stgit@noble1>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 11:36:30AM +1100, NeilBrown wrote:
> The sctp transport seq_file iterators take a reference to the transport
> in the ->start and ->next functions and releases the reference in the
> ->show function.  The preferred handling for such resources is to
> release them in the subsequent ->next or ->stop function call.
> 
> Since Commit 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration
> code and interface") there is no guarantee that ->show will be called
> after ->next, so this function can now leak references.
> 
> So move the sctp_transport_put() call to ->next and ->stop.
> 
> Fixes: 1f4aace60b0e ("fs/seq_file.c: simplify seq_file iteration code and interface")
> Reported-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: NeilBrown <neilb@suse.de>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
