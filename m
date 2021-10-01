Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8550441E9A7
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 11:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353052AbhJAJhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 05:37:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49998 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353067AbhJAJhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 05:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633080928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=62HnbEByMpo+5iYUyz8UqEO7WQkRy8RAvP2IpsNVBck=;
        b=JLV5ddK0lo9q4xDV/TjgnKNouH9f4jfrMtR1o+il3V9VXKZwU24pE9nkKCuBbWKBFXHaaT
        NqbI8Wqe8iJRlIIzhvm/q6j9Icvc9+mvHBlvWT10Ab8OWNQuQNKXHzFS2sRjW9Lm59LnLL
        NVIa1tYve1+l7kAMfIQ52T1X1jGk06M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-L85e2M8wONG1qee4ip4TKQ-1; Fri, 01 Oct 2021 05:35:27 -0400
X-MC-Unique: L85e2M8wONG1qee4ip4TKQ-1
Received: by mail-ed1-f70.google.com with SMTP id s18-20020a508d12000000b003da7a7161d5so9781453eds.8
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 02:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=62HnbEByMpo+5iYUyz8UqEO7WQkRy8RAvP2IpsNVBck=;
        b=wGs0Gw2yxG0WYMYaHGMDsU7/pICG5QQgf68PCerkLUyB6AdVKP+f6T7tF6dIbYke+m
         tLOP+J8mJB420VDIbeE/mBv2kGY4hMca66fJcyFZd5O6itydVjkXAEi+zClG9qoRx+Iy
         XOGxB2F9ex0pWlsnpKL6/aOuE9aJU+ATgaKWuFh+riMFhSI65DWHbmOV2QTzmihKmaut
         9iEgXzGE0GQ32FQCtC3GbZ1zyAXVx4G4i8KuDb32lZxVRy+/VrelYXbqx0w9BwqvcpZl
         4s2vxkwmU8byCQmyps5WqvEMHodx6JvM6mobJ4xvzpyIjFRtZ4IDnpk22j3ImZ1iIolp
         uEtw==
X-Gm-Message-State: AOAM531pbAZn7ue+fSXSowhWaMtQmYuYrqPJER1GjqCeYRmwi5di41mM
        N2yhwsH+Y0/bVpsRgXbqsyvfTTPPhF+oJHuZekHT7c+EbPe+tVi8x+lzWvXN/fUpoxd5bwMLRzH
        QORJGxZBCYI7IsPUT
X-Received: by 2002:a17:907:7704:: with SMTP id kw4mr5255984ejc.23.1633080926227;
        Fri, 01 Oct 2021 02:35:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwR64401oRxVuEAIm4flgW54utF5jUXZZC1wDHVcs5AUPGuc3oGx2MuvnH0BRPHxu3M1GMk6Q==
X-Received: by 2002:a17:907:7704:: with SMTP id kw4mr5255970ejc.23.1633080926060;
        Fri, 01 Oct 2021 02:35:26 -0700 (PDT)
Received: from localhost ([37.162.39.158])
        by smtp.gmail.com with ESMTPSA id h9sm2730106ejx.78.2021.10.01.02.35.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 02:35:25 -0700 (PDT)
Date:   Fri, 1 Oct 2021 11:35:21 +0200
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     pabeni@redhat.com, Stephen Hemminger <stephen@networkplumber.org>,
        mptcp@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] mptcp: unbreak JSON endpoint list
Message-ID: <YVbWWcM4wAVtbiED@renaissance-vector>
References: <b526544bc745535f72c76752bbd850df5a0ac2e4.1633004460.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b526544bc745535f72c76752bbd850df5a0ac2e4.1633004460.git.dcaratti@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 05:19:25PM +0200, Davide Caratti wrote:
> the following command:
> 
>  # ip -j mptcp endpoint show
> 
> prints a JSON array that misses the terminating bracket. Fix this calling
> delete_json_obj() to balance the call to new_json_obj().
> 
> Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---

LGTM.
Acked-by: Andrea Claudi <aclaudi@redhat.com>

