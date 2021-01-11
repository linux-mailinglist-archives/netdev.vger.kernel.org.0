Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84B72F19FA
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731095AbhAKPpz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:45:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34955 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730508AbhAKPpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 10:45:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610379868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iIVu/k8j+0dWaWrqMP7kq4fEJym6G5RVM3W9H/CfFj8=;
        b=E7XDfym0ZwT7Z8GmQq2svK50Ql1KF+cSY6kqCRrNZWpQ42VeZMdX8/wJROe4kQ0hB0kTu+
        KjQagB4QC/XZH2oFG/jks1NlCNtJeO7C8NfLqRmVRMQ02NCuD/0O+yu/DrrC19k+72e5/h
        4JIqPqK36jyUVdP+cXXVG7fgu38SDUc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-358-beTcG58JONGJcwZNEzU25g-1; Mon, 11 Jan 2021 10:44:26 -0500
X-MC-Unique: beTcG58JONGJcwZNEzU25g-1
Received: by mail-wr1-f72.google.com with SMTP id i4so8004454wrm.21
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 07:44:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iIVu/k8j+0dWaWrqMP7kq4fEJym6G5RVM3W9H/CfFj8=;
        b=AEZgZW0WFZpkJGxYAAndXyDSrIL7Xo4q9LMFYMW8LWuEW0LGaKb1yBlYa0rdpukphs
         4UpI/BbSx6l8rIY8HtbyijpL8ZlzD9hiiNMOF9VJ+xNAzTUDFGBpMgzgUdDKW257sMko
         Crjk6jruWgVOo2oWAg7a84hX8BrMEkNXQk5dY3YUHqvQ6wGnmfBP6ZJv6ihrSlJmj1Xy
         erJ+gKDkcGFGk0Tl0YC3iVnGkTlIQc2GrBF9RGgqaYvH/HUqEVS5FDXZXU/zk2S0EVM5
         ZkUh5suJCUWZSGSlhJzxVHOA7yOZE9xNICls4crDRIuzMe57+biMtxIia7h/d5Dsb6ul
         dvpA==
X-Gm-Message-State: AOAM530EQwN1ZDmjf7ErfATXbPexBmrLNyE6TKD74JGaegumlyIlt8dl
        JDhJ3vrC1LC6BxT3gISUhftmUs7cfTygPoE6LaaqE26PLqCLqTXVMIhSyBp6pOxoA0HUClNOasU
        l1xj7XFUFX/G+Ejhu
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr296823wmm.122.1610379865143;
        Mon, 11 Jan 2021 07:44:25 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzKNUnAz5QJae2eKaqgy4a4OxCUcV0fdIum6N6avmnW6onXg8sGrVLs/lEUAjvkD+Q3Mp7k/w==
X-Received: by 2002:a05:600c:2255:: with SMTP id a21mr296816wmm.122.1610379865025;
        Mon, 11 Jan 2021 07:44:25 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id t188sm223620wmf.9.2021.01.11.07.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:44:24 -0800 (PST)
Date:   Mon, 11 Jan 2021 16:44:22 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <20210111154422.GC13412@linux.home>
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
 <20210111105744.GA13412@linux.home>
 <68d32b59-4678-d862-c9c5-1d1620ad730a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d32b59-4678-d862-c9c5-1d1620ad730a@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 08:30:32AM -0700, David Ahern wrote:
> On 1/11/21 3:57 AM, Guillaume Nault wrote:
> > Okay, but, in the end, should I repost this patch?
> 
> I think your patches are covered, but you should check the repo to make
> sure.

This patch ("tc: flower: fix json output with mpls lse") doesn't appear
in the upstream tree.

