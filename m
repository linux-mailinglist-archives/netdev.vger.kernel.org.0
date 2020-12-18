Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 118C92DEA1F
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:20:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387504AbgLRUSu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387496AbgLRUSt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:18:49 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0873C0617A7
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:18:06 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id i67so3191140qkf.11
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TN0YKydFOcwaoL0LprOHmYM5z1euEdDwBFvpqdblXvs=;
        b=UXAPftnZ62lfDQZO6VMuyWluH5OP9yuMUyZvxPCaFLZwji7q8uQx2BfJWYDrWiJkSJ
         ljf7wkT62mhdorwbCMReuNyHhVFCbjaxshGPm6PAtZkuM2BOpyPRIxaPRhKi83WaPoYT
         spywgkVUhBYFJLlpOUFnPmzhnifKoS9IdSIXC3m7pmPk5VAwxg/KTSVWsa0IKlqIBy8Y
         Db2RhAeWVe6NIOIdKwsI6pqwwlj4t8njKOJCZs1/Hqb1ihmSGicwfdC8jKJCb4lb6Grr
         /8nEpQMo721xvJfD972MCxnEkTbgdx62C5291zCTiBQspPyeLxXQUHts+Tsv/nQJdBWw
         V5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TN0YKydFOcwaoL0LprOHmYM5z1euEdDwBFvpqdblXvs=;
        b=Q7ZsfzpI8epXCPBP2Un5/sIz9R76n2LJcQJwmdXBlurRIBHFGhjFGQwKSqms+FPEYC
         AySqCqA6+BhvonYKgOC2jP4feGp4G6S3LtV7PKH3PJIMu3pLMGFb+CnQpEJ+Li2L8MFG
         ITjpk7eLKvAH/UdRBrVWQ7ALg+I6I2Qq9wDq7pBLKHiojcXmtPFX24IBczbYTxhhc5Dz
         ZjEx0imtmnl8wKIvq/TEYLlSsbXXNa35HXCd35bLAIDAmQ7RWcbH8ssfdjGVzfrk5ava
         HbwPIjazsl2FQ9RGQvbi2thjKTB9Uq3NTE1xJY4xV/L+tZqkRetTolH8GQHfBC9CDIIF
         lu/A==
X-Gm-Message-State: AOAM532SAXSP0JHEmhuD7yVsQswY95rilV7athUTX763aQwiz37dwxyy
        xDZqpVL6CoSIOSXkyKEJAKbLkA==
X-Google-Smtp-Source: ABdhPJzqt2OVq2gxNomgOEqcAGDJcT+MkbCR1AE0CrFP1EVr8TeDBcLZ4GpnxOxyn/dDv0ApFuP8pA==
X-Received: by 2002:a37:b82:: with SMTP id 124mr6640244qkl.294.1608322686035;
        Fri, 18 Dec 2020 12:18:06 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id 60sm5782291qth.14.2020.12.18.12.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 12:18:05 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kqMCS-00Ctfw-PO; Fri, 18 Dec 2020 16:18:04 -0400
Date:   Fri, 18 Dec 2020 16:18:04 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Parav Pandit <parav@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Netdev <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Kiran Patil <kiran.patil@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [net-next v4 00/15] Add mlx5 subfunction support
Message-ID: <20201218201804.GQ5487@ziepe.ca>
References: <20201216175112.GJ552508@nvidia.com>
 <CAKgT0Uerqg5F5=jrn5Lu33+9Y6pS3=NLnOfvQ0dEZug6Ev5S6A@mail.gmail.com>
 <20201216203537.GM552508@nvidia.com>
 <CAKgT0UfuSA9PdtR6ftcq0_JO48Yp4N2ggEMiX9zrXkK6tN4Pmw@mail.gmail.com>
 <c737048e-5e65-4b16-ffba-5493da556151@gmail.com>
 <CAKgT0UdxVytp4+zYh+gOYDOc4+ZNNx3mW+F9f=UTiKxyWuMVbQ@mail.gmail.com>
 <BY5PR12MB43220950B3A93B9E548976C7DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0UdtEJ0Xe5icMOSj0dg-unEgTR8AwDrtdAWTKEH4D-0www@mail.gmail.com>
 <BY5PR12MB43223E49FF50757D8FD80738DCC30@BY5PR12MB4322.namprd12.prod.outlook.com>
 <CAKgT0Uetb7_P541Sd5t5Rne=np_+8AzJrv6GWqsFW_2A-kYEFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0Uetb7_P541Sd5t5Rne=np_+8AzJrv6GWqsFW_2A-kYEFw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 11:22:12AM -0800, Alexander Duyck wrote:

> Also as far as the patch count complaints I have seen in a few threads
> I would be fine with splitting things up so that the devlink and aux
> device creation get handled in one set, and then we work out the
> details of mlx5 attaching to the devices and spawning of the SF
> netdevs in another since that seems to be where the debate is.

It doesn't work like that. The aux device creates a mlx5_core and
every mlx5_core can run mlx5_en.

This really isn't the series to raise this feature request. Adding an
optional short cut path to VF/SF is something that can be done later
if up to date benchmarks show it has value. There is no blocker in
this model to doing that.

Jason
