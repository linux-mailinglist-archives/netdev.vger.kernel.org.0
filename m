Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0843436F8F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 03:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbhJVBr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 21:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbhJVBr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 21:47:56 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07487C061764;
        Thu, 21 Oct 2021 18:45:39 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id f4so4868666uad.4;
        Thu, 21 Oct 2021 18:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWt6uqKTCCbsCNQyOaLjTBfNtiRbQoxiDY+LcfMpBc8=;
        b=JmnAy8kwgFEEicRCGgjVO0otnNga/dFuZfftJUkEsqvlQWrZ4MRq+ZJ4hvxOV+Fy07
         q5DkJSksGZNxQnW7jjBWV/mol/fHdzZW4zBvAtSiE/Ik/ttLDFY8sb+tT/jPz3fzbs6r
         fvWNOkrA014tyYzkK+6KHe0a4zAsN1pXa0LszHDKS/51h4G2WPK3P36CYuhyKsBX5Apu
         dKZrGmcG4e2/87QUODg65LdZSZ0AxQMOuh+Y8aCeZOnqTdl8NjF0F2BqdKKfKiGSSkiU
         UmLrTdjwhWvf5FwJifq5TshIDMXBShDn1mm6HE1gcqFfRiynlIa3Vi/5tYrw0GqrDYxZ
         tuBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWt6uqKTCCbsCNQyOaLjTBfNtiRbQoxiDY+LcfMpBc8=;
        b=hu6tkQwaKwNk0vWGaEgaF9q8Dxl7Sw/lA4wDyvwTVShRDSjgUt4WvONnBROFLWdoz6
         RWJ55WgXn9Jv07G+hEP0Bi7rqw3s//vJUqKy8qbWu+EzB6+UVpMda/eNpT8R5qJ31BsI
         ipbdKEtmKx3WmqA7ouQXnMlSKgHqDStn/VMKwnbbq25f8w9idE7WRxcrZU8iYCKk5zim
         sxrQv9p4XglNJKDRQAa2HrFSXioyeA12igcVafvuZe4yprqjGA6OtI3QwgvqCFtBmabN
         UYAgc1lqjw44teizV2KuJPYSvRRyUZzudbzI1IpD6QKw7l+uvAsTsLzDybSQAa1Nae3w
         6ySQ==
X-Gm-Message-State: AOAM5331e37jAiERw/ziJw85/O0OLKMUlOuqMjawX2bIlVVxSbygK30V
        EWx+Ea/y/ZlzYnYOgfl2uycKSWJQTJ8=
X-Google-Smtp-Source: ABdhPJwu+YbcfSozFiBh7WVDUy+QLzNt1z2VCcQQNUTujIw9CRKuWpaMW82yW7akt/WkVm/kpEAGCw==
X-Received: by 2002:ab0:5741:: with SMTP id t1mr11182173uac.72.1634867139131;
        Thu, 21 Oct 2021 18:45:39 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:9215:811c:de3a:f39a:8a57])
        by smtp.gmail.com with ESMTPSA id n18sm3905633vsk.22.2021.10.21.18.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 18:45:38 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 39CA191F49; Thu, 21 Oct 2021 22:45:37 -0300 (-03)
Date:   Thu, 21 Oct 2021 22:45:37 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org,
        michael.tuexen@lurchi.franken.de
Subject: Re: [PATCH net 0/7] sctp: enhancements for the verification tag
Message-ID: <YXIXwWOkUYhazR4R@t14s.localdomain>
References: <cover.1634730082.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1634730082.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 07:42:40AM -0400, Xin Long wrote:
> This patchset is to address CVE-2021-3772:
> 
>   A flaw was found in the Linux SCTP stack. A blind attacker may be able to
>   kill an existing SCTP association through invalid chunks if the attacker
>   knows the IP-addresses and port numbers being used and the attacker can
>   send packets with spoofed IP addresses.
> 
> This is caused by the missing VTAG verification for the received chunks
> and the incorrect vtag for the ABORT used to reply to these invalid
> chunks.
> 
> This patchset is to go over all processing functions for the received
> chunks and do:
> 
...
> 
> This patch series has been tested with SCTP TAHI testing to make sure no
> regression caused on protocol conformance.

Nice!

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
