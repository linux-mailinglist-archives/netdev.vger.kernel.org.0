Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4366141DE67
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 18:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348581AbhI3QIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 12:08:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347212AbhI3QIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 12:08:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C7DC61159;
        Thu, 30 Sep 2021 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633018013;
        bh=lowIIT/dlAxfmJTqeV3JfNAMCQISWlxzEw58S1IyV+I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CX9YHQ7Lchi0WkjF5UwAwDQE2P5GgKZM254hsCb9ub2laez23w8hD7De2mRaZl6bm
         116GUuAOUjKkFrjym4FBCoAPY1WHcodZA+uUDHEJjVIw6Q6exLy0R8Q7sS8GNbbCy6
         NYPvCyGCziDtqFU10OZwoGodYadmYNdGlw8FfMrVqlrTsflCQPjVk/rmeJldTK8Ktm
         +lMaWdo4FS2g3y3NN/C2oGTcn/7JPAp3C3I+Dw1ndgBWl/jKpaHKzh0QYn04cMhKJQ
         pNXnOzdvVFXK27q6koyK5misuLlFJ+N90/W1CcmyNtMuoTvRLQDfSlEJchIpNpgD/n
         CQUH0iqmfzACw==
Date:   Thu, 30 Sep 2021 09:06:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, lukas@wunner.de, kadlec@netfilter.org,
        fw@strlen.de, ast@kernel.org, edumazet@google.com, tgraf@suug.ch,
        nevola@gmail.com, john.fastabend@gmail.com, willemb@google.com
Subject: Re: [PATCH nf-next v5 0/6] Netfilter egress hook
Message-ID: <20210930090652.4f91be57@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YVXUIUMk0m3L+My+@salvia>
References: <20210928095538.114207-1-pablo@netfilter.org>
        <e4f1700c-c299-7091-1c23-60ec329a5b8d@iogearbox.net>
        <YVVk/C6mb8O3QMPJ@salvia>
        <3973254b-9afb-72d5-7bf1-59edfcf39a58@iogearbox.net>
        <YVWBpsC4kvMuMQsc@salvia>
        <20210930072835.791085f3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YVXUIUMk0m3L+My+@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Sep 2021 17:13:37 +0200 Pablo Neira Ayuso wrote:
> On Thu, Sep 30, 2021 at 07:28:35AM -0700, Jakub Kicinski wrote:
> > The lifetime of this information is constrained, can't it be a percpu
> > flag, like xmit_more?  
> 
> It's just one single bit in this case after all.

??

> > > Probably the sysctl for this new egress hook is the way to go as you
> > > suggest.  
> > 
> > Knobs is making users pay, let's do our best to avoid that.  
> 
> Could you elaborate?

My reading of Daniel's objections was that the layering is incorrect
because tc is not exclusively "under" nf. That problem is not solved 
by adding a knob. The only thing the knob achieves is let someone
deploying tc/bpf based solution protect themselves from accidental
nf deployment.

That's just background / level set. IDK what requires explanation 
in my statement itself. I thought "admin knobs are bad" is as
universally agreed on as, say, "testing is good".
