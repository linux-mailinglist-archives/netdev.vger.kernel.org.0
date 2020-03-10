Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D6C180223
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:44:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbgCJPoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:44:09 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35405 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgCJPoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:44:09 -0400
Received: by mail-qk1-f193.google.com with SMTP id d8so8720573qka.2
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 08:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hGhJEwYcNkUu6d/e01/ViI8q88K0xEDtn9j67HjaOA4=;
        b=JcghvuH3dTV7R9Cmz0QTTUjydzhoT4QmEj3YCpCtlgLm5fqLmJxrFPiu/49qGXIww9
         bZUAF7O7Fkz9h5xa6NpZ1g1nw4D1Dam/ikwaufJvKcgrF8GAkvaytJYtlMZTI/PC412t
         lEZ0ksQNvVubseHNnRcf7SaDwEtY9eQ5XOzH1PqBj+9p6n7LO+GnH8iV/gdsffOsUYxI
         5rDhR15Qatd5YLsip0YVwqc+fmPN3g56wdioDr7SwHJWJVbriGb2Prc+3/EI/qNAigYf
         dNx9bjoNaeXR5I5dPvzPgoaCoA09Lm26erNHsuJuO0jEsBLLdUgjNDfIDuLyQ85Bt6i+
         Br3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hGhJEwYcNkUu6d/e01/ViI8q88K0xEDtn9j67HjaOA4=;
        b=hTDtW0QUrQXC6ciquWdncyLIvvNR/lWbDWda557VppuEhS9xO0KJXjdYwIWdVrpUJt
         9mXvf3CDZEzQ+13lbilB/XjhFtivtcj5uzL54Vsy0vDWPQWwaO9lC2rVMZ/Zv8qZAvBX
         STEMeZ3qM/F/ORQiFqCqC3Wb7O9PNzhp/25hX1iNm9TN/h4pA+wFocG+3v33q02svgV/
         vKi82kpdqnc4joe7CSqODZSFKrUpNf+0slOHd44+SOT6GZv5HqWKrJX5G1Pkjyk9iCCy
         G5TZGrvrJByhgeR3UFq6V1Wm1/AvUKNKYqRs6UUt0fRLfKdaldeq7sZal+4A8fmGDFm9
         QREg==
X-Gm-Message-State: ANhLgQ04RjWAWPUYIHIFTdGUoBhoYAtA/6Xz3vax0Pa7sUtTbukrErqY
        jcUmk+8Asjip1DP68S5dERsSbQ==
X-Google-Smtp-Source: ADFU+vvwLCrijPW2mlTtSZFKgaK4Ld7nVbLZtRjIOdfDyy3Ll00vBa2o09jzcWOt0sbz38cJxp/ksA==
X-Received: by 2002:ae9:f70b:: with SMTP id s11mr18352032qkg.201.1583855047937;
        Tue, 10 Mar 2020 08:44:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-57-212.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.57.212])
        by smtp.gmail.com with ESMTPSA id p2sm23345128qkm.64.2020.03.10.08.44.07
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 10 Mar 2020 08:44:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jBh38-0005Fi-Oo; Tue, 10 Mar 2020 12:44:06 -0300
Date:   Tue, 10 Mar 2020 12:44:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next 0/2] Packet pacing DEVX API
Message-ID: <20200310154406.GA19944@ziepe.ca>
References: <20200219190518.200912-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219190518.200912-1-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 19, 2020 at 09:05:16PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> This series from Yishai extends packet pacing to work over DEVX
> interface. In first patch, he refactors the mlx5_core internal
> logic. In second patch, the RDMA APIs are added.
> 
> Thanks
> 
> Yishai Hadas (2):
>   net/mlx5: Expose raw packet pacing APIs
>   IB/mlx5: Introduce UAPIs to manage packet pacing

Applied to for-next, thanks

Jason
