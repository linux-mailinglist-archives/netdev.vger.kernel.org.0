Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A891441BE0
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbhKANrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:57018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231741AbhKANrP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 09:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA67260E78;
        Mon,  1 Nov 2021 13:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635774282;
        bh=clWuDRj3uVxUbKZo8iDmWH75rZ/vuidgMGdP2dabqFQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PhbhNvJHyEy7TIOYaBVWAczHRStJqUJQvFkw24+NaH4uskhvbvYQNWj224cJJ89ch
         3aiPEbji8NcRkWPtLinZaTBEgw1gEnZePjM0wVo2c+QwYjWl36FStCIfomLPHF+kPB
         tQwKIPwOXYmF7Rc/OAhBJPagOl5Gps9aAj0DLM/NKqiqFCU7DZKl5PqmFtXchD/un6
         ya5Ujw8Z25qwGHyutv/oR/xx3WizRSKDlFkPsGGOPO4dnOrsGmuLAu00fyjhCtb0gL
         d97SYDwhNL66V4wFfnFmFRxU20yPKZEOeZs8w1zY6eUfu1e3ZUdKdWABdbJcJmb1u/
         AJbtJJ9et5FfQ==
Date:   Mon, 1 Nov 2021 06:44:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com
Subject: Re: [PATCH net-next v2 3/4] devlink: expose get/put functions
Message-ID: <20211101064440.57a587bf@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YX43wGPh5+TcXR81@unreal>
References: <20211030171851.1822583-1-kuba@kernel.org>
        <20211030171851.1822583-4-kuba@kernel.org>
        <YX43wGPh5+TcXR81@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 31 Oct 2021 08:29:20 +0200 Leon Romanovsky wrote:
> I really like this series, but your latest netdevsim RFC made me worry.
> 
> It is important to make sure that these devlink_put() and devlink_get()
> calls will be out-of-reach from the drivers. Only core code should use
> them.

get/put symbols are not exported so I think we should be safe
from driver misuse at this point. If we ever export them we 
should add a 

  WARN_ON(!(devlink->lock_flags & DEVLINK_LOCK_USE_REF));

> Can you please add it as a comment above these functions?

Will do if the RFC sinks.

> At least for now, till we discuss your RFC.
