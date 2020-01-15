Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC6E513CE29
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 21:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729274AbgAOUjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 15:39:31 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39014 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgAOUja (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 15:39:30 -0500
Received: by mail-qt1-f195.google.com with SMTP id e5so16984623qtm.6
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 12:39:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ipG4hKVWO36UBYjzndMB1WJDOPTaBicd8BoGcrdlLvE=;
        b=GW9nRogp3a2Z10qL/O/JVeeVSPowlp3ZdGAdfqatqJMcZmMMB6iSmLXYpnCCqIBhQa
         H+nna9QB+l/Z6v4tAE8EqlWK/lG4RUXUG0zdASsEBA+3mmAotR2zVkOBiV6JoWbu9Hw5
         A7btnI+DmQQFqtlB02AD9h7XHzhk0m09aHNFE07qnu3rRfURrJ56wlFpvX6O6zd3VW+H
         rJa8l/Ar7KtWxpp8M471W7ZnWRXPiRKXUX4nq3uR23aVu/h5/jevqiydEX3dvVPVRLZX
         1/jx4ohqCYxyxUrtd0rVM8M3ccoe/HRNBCrbUrFBZ35xvXobwDFxKt2vabX7DKK8ALXX
         fptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ipG4hKVWO36UBYjzndMB1WJDOPTaBicd8BoGcrdlLvE=;
        b=phITkd6LOYq9vjAP0vUrqAjAVm9l6kWjMSQ2plQM3IxS2txWNSxXn8QdRl71q9c3td
         jVLO8JzEfge5RLiDAogP3aBjiG83cud5Ci84FTVTsCNkezGo2SKKaQ4Vcp52KjPBN2UB
         cAq2b/X11KXjR385IqHrCWhvbOJr3qjI3XLt7hRCYOfAsFcv9e1llREwfS9jDUG30tGk
         ru4JKCAZUAL989f4Rcz88t+qqALbl6OSzE5Ldwkew+lmXhTutuSvbbAuoSOJHYzP5SPJ
         UIvMexlEuNL54HZrTjcXN3eds6HrDtCBpeohzsJvUzJ+96VdJD17lUdmXWemcQ9pl1kX
         Vp7Q==
X-Gm-Message-State: APjAAAXzuIvIxi5A4VFhI29fwshqTg1vUXrMnFucmkc/3i6KZ3e60Lpb
        LhiiaxsDgqwNHrPF7cQ16o4SLFeg9WY=
X-Google-Smtp-Source: APXvYqxc326AZJsqbdqeaEd/VQzC59gRyhUheeJsqg5NaIAc9NcrRnaG5LcQX+F9q15PuN4kX1I4Kg==
X-Received: by 2002:aed:2f01:: with SMTP id l1mr417869qtd.391.1579120769915;
        Wed, 15 Jan 2020 12:39:29 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id q25sm9175209qkq.88.2020.01.15.12.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Jan 2020 12:39:29 -0800 (PST)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1irpRp-0006zN-4c; Wed, 15 Jan 2020 16:39:29 -0400
Date:   Wed, 15 Jan 2020 16:39:29 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Avihai Horon <avihaih@mellanox.com>,
        Maor Gottlieb <maorg@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] RoCE accelerator counters
Message-ID: <20200115203929.GA26829@ziepe.ca>
References: <20200115145459.83280-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115145459.83280-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 04:54:57PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> Very small change, separated to two patches due to our shared methodology.
> 
> Thanks
> 
> Avihai Horon (1):
>   IB/mlx5: Expose RoCE accelerator counters
> 
> Leon Romanovsky (1):
>   net/mlx5: Add RoCE accelerator counters

Looks fine to me, can you update the shared branch?

Thanks,
Jason
