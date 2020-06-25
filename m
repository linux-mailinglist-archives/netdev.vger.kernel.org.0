Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6752D209806
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 02:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388928AbgFYA4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 20:56:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgFYA4s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 20:56:48 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56397207DD;
        Thu, 25 Jun 2020 00:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593046608;
        bh=HUPase5PICJHZvekWmcFU805FX8Ug2fIUoGwQtLgQJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MnO5bIaUQWLHUaoFkkxpjaB1LEyfjDHg9cfqxeLD/AE3X2KOCeeVpwhdfE2JfTvj7
         G3w2nnpDECLRGxDz9KpLkWnK1lHRASWnIyv6yyRb2yiWWNd08lDQPO1VtRI9ntvIYZ
         yIeI2t7kQyAhlS6wDDGAYj8XDuhQXOuFaveFKobc=
Date:   Wed, 24 Jun 2020 17:56:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matheus Rodrigues <matheusrk800@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Generic Netlink multipart messages
Message-ID: <20200624175646.15d19ad1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAGNm9V9igWmDwV8fNQhvVTS0hJnBox40BWtqUV0sR3e6=QJs5g@mail.gmail.com>
References: <CAGNm9V9igWmDwV8fNQhvVTS0hJnBox40BWtqUV0sR3e6=QJs5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jun 2020 11:59:00 -0300 Matheus Rodrigues wrote:
> I'm trying to send a relatively "big" string (+/- 60Kb) through
> generic netlink, for this, I know that I've to use the multipart
> mechanism offered by the API, using the flags NLM_F_MULTI and
> NLMSG_DONE, but I don't know how to implement it, there is some
> example which breaks the string in various packages and send it to
> kernel? I looked a lot for some example but I didn't find any that
> does this. If there is none, so how do I do that using only the
> mechanism offered by libnl and generic netlink?

Not sure what your attribute structure is but you'd probably need to
chunk it up and include offset in each message. See how devlink region
read is implemented, maybe?
