Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C557F30E253
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 19:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbhBCSRj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 13:17:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:57902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233081AbhBCSRE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 13:17:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 590BB64DE1;
        Wed,  3 Feb 2021 18:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612376183;
        bh=xklJbfE8ZuEeNlAFPX8zVeCl/hrzpnaBjX/YB+35m80=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YXMmjh2xzWcg2JIeSM3YD3ox1mB0RmDnlFYZaUl9h52o+0uBjEa1ieBKDNo3/y7fi
         xoDae2lRPOfElDrR76CqM5Jntz1sEjcmljxgXBZsVB0c7ulZIG51R1KovOM7su3JjN
         fz0dREkC1rKmAOTkvLy30vYLt5l9OcQru6rnhfg583e3eGOMSEQKMRm6nDAYrjMEm4
         4o2/tnfDSBdfMb2ZqRcH1XEDRqcYcO+JN7mnPl4t3M/zTH80Mkl4N61w0BQzURCxft
         kdGcu6IMPXm27nGNvG40z1XjKUvYqYTpXfZdCd6/FDS6ck24PQJaMo7Q4Hl5A1Y5OZ
         tDQtDVBnnvJUg==
Date:   Wed, 3 Feb 2021 10:16:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sdf@google.com
Cc:     Eric Dumazet <edumazet@google.com>,
        Hariharan Ananthakrishnan <hari@netflix.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all
 tcp:tracepoints
Message-ID: <20210203101622.05539541@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YBrOnJvBGKi0aa7G@google.com>
References: <20210129001210.344438-1-hari@netflix.com>
        <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
        <YBrOnJvBGKi0aa7G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 3 Feb 2021 08:26:04 -0800 sdf@google.com wrote:
> On 02/02, Eric Dumazet wrote:
> > On Mon, Feb 1, 2021 at 11:06 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> > > Eric, any thoughts?  
> 
> > I do not use these tracepoints in production scripts, but I wonder if
> > existing tools could break after this change ?  
> 
> > Or do we consider tracepoints format is not part of the ABI and can be
> > arbitrarily changed by anyone ?  
> 
> They are not ABI and since we are extending tracepoints with additional
> info (and not removing any existing fields) it shouldn't be a problem.

Okay, but we should perhaps add the field at the end just to be on the
safe side (and avoid weird alignment of the IP addresses).
