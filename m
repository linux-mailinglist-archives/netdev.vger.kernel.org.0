Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896892EE817
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 23:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbhAGWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 17:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbhAGWF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 17:05:26 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8970C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 14:04:45 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 22so6932169qkf.9
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 14:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iZAdUUT6vosmPFanbKlWS8UTPLOQlqRw/Bp9OylzCwg=;
        b=PzvvHlN6BxVpPePOG5OOqKJpBwKdP2WSXoMuf0ddbD6RI2l+1wBDoj/ZwHIIUh1bp3
         A9GB3/nwLLy4151UCr7SCyEkjWm9ADawc0QmVQB3KQUtDbewr1S1NjSDT7mRIhSikExV
         lajnGnxabmpjOAINpnXvU8TdQR5ZO4EpgHoSpJeUeAg249OjHIWBQOcTCFd7ift056i6
         kAgrCbw+UYqhIdqyV3nop3u0pQ56g3Cy3nc5R78bpgIb/pGHqZVQoRf4KDpagh5m7v/r
         Lh/UVte/oWKtQUIr/m901KvY1OSdVQ2BkJmClMYHGczhuivp1rDYu0CAKaEzhx778lIP
         7GCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iZAdUUT6vosmPFanbKlWS8UTPLOQlqRw/Bp9OylzCwg=;
        b=aPB5+NLf1CPqRfquW9vtDKm/jIdmJhntvG27Zi3Amukv5rxoV9IlBMDJ0iABCjRf4Z
         ABEKQU+g792f1E7EsZtnhxKhaa2+bHP3kE9PCfuzdKTUatlrGNTowjHX85MLboe3W3q8
         GsMNyrJrs2jzEkwP8cwcMZrhSPZrjDIJcMBzeStL4UZmR3VYPimTI72phDRBz5BQOMxY
         OpBjF7ZVJb8wqleeaw+uSbLaHMi+HJUkXdB316u999ZbHO1FE6BiuFqZt8LVqd4iRwPR
         1SDGs7W/ntv9kb7FXUKtu22Omekoe5ozsK2fBDd6gCloq6yzYwpRufb6leJfozUWjzCQ
         IpvA==
X-Gm-Message-State: AOAM532g3+IgPKHAqHbF+iaWWWcdk6oIZpItBBGTYbRqH9jKOTnwV6KC
        I5tCvW/GeNn0L3vmGKE6JRQ=
X-Google-Smtp-Source: ABdhPJxMaFUpkQPad7TfhNtibzcjJB2z8qeVSeAyZcPfehL/WBlFhKb2ZyL1EE23G74cBfihd1l+tw==
X-Received: by 2002:a05:620a:13b8:: with SMTP id m24mr1050774qki.205.1610057084529;
        Thu, 07 Jan 2021 14:04:44 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.157])
        by smtp.gmail.com with ESMTPSA id g26sm3890339qka.76.2021.01.07.14.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:04:43 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id B20EAC0768; Thu,  7 Jan 2021 19:04:40 -0300 (-03)
Date:   Thu, 7 Jan 2021 19:04:40 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 04/11] net/mlx5e: CT: Use per flow counter when CT flow
 accounting is enabled
Message-ID: <20210107220440.GD8313@horizon.localdomain>
References: <20210107202845.470205-1-saeed@kernel.org>
 <20210107202845.470205-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107202845.470205-5-saeed@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 12:28:38PM -0800, Saeed Mahameed wrote:
> From: Oz Shlomo <ozsh@nvidia.com>
> 
> Connection counters may be shared for both directions when the counter
> is used for connection aging purposes. However, if TC flow
> accounting is enabled then a unique counter is required per direction.
> 
> Instantiate a unique counter per direction if the conntrack accounting
> extension is enabled. Use a shared counter when the connection accounting
> extension is disabled.
> 
> Fixes: 1edae2335adf ("net/mlx5e: CT: Use the same counter for both directions")
> Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
> Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Tested-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Thanks.

> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Paul Blakey <paulb@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
