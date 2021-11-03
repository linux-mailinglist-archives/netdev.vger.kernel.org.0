Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6F27444B9E
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 00:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhKCX3t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 19:29:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229561AbhKCX3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Nov 2021 19:29:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4176D6103C;
        Wed,  3 Nov 2021 23:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635982031;
        bh=9/eQnCMcyH6BP7eBC+Q6DAIGNIyNb51H9zuq9ADJcd0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DskdrxLiOuoZWACPAOP8l0+11zG1UZqpQQNLIYVMjija/KrcX6DmCxlL0CQdlxr9q
         zPpVZW0Pp9R0KWX2VcD+JGkvg1cm+AusDZ/VEtxMMmZAZd9Qgy9oJ2j0KPUfUtRdcx
         jdK9qR46+5ARnVxPG53EE5o6A9K3qY7ggzir6+VC1gP9DE/VhEiICMcE1oBBYa893h
         luw0jIR+z+JWc4l3xda67mVxpJGhxxgOnuiQfzFehEjsm/algYy9LSutNxX77HWf/9
         KOwK70Akzz/uXmF7z2lrG2C1PdxHrFmVHTWKaNNOxAbLb0El/YtTlGmBz9fjMHsIgg
         XPb8UZ7lrru/Q==
Date:   Wed, 3 Nov 2021 16:27:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huang Guobin <huangguobin4@huawei.com>
Cc:     <j.vosburgh@gmail.com>, <vfalico@gmail.com>, <andy@greyhouse.net>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next v2] bonding: Fix a use-after-free problem when
 bond_sysfs_slave_add() failed
Message-ID: <20211103162710.74755593@kicinski-fedora-PC1C0HJN>
In-Reply-To: <1635845853-4259-1-git-send-email-huangguobin4@huawei.com>
References: <1635845853-4259-1-git-send-email-huangguobin4@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Nov 2021 17:37:33 +0800 Huang Guobin wrote:
> When I do fuzz test for bonding device interface, I got the following
> use-after-free Calltrace:

> Put new_slave in bond_sysfs_slave_add() will cause use-after-free problems
> when new_slave is accessed in the subsequent error handling process. Since
> new_slave will be put in the subsequent error handling process, remove the
> unnecessary put to fix it.
> In addition, when sysfs_create_file() fails, if some files have been crea-
> ted successfully, we need to call sysfs_remove_file() to remove them.
> Since there are sysfs_create_files() & sysfs_remove_files() can be used,
> use these two functions instead.
> 
> Fixes: 7afcaec49696 (bonding: use kobject_put instead of _del after kobject_add)
> Signed-off-by: Huang Guobin <huangguobin4@huawei.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
