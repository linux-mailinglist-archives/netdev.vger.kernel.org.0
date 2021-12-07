Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF5E46B05F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 03:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhLGCEB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 21:04:01 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47082 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbhLGCEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 21:04:01 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5D5DB81607;
        Tue,  7 Dec 2021 02:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED298C341C1;
        Tue,  7 Dec 2021 02:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638842429;
        bh=vZKuzetVYUotfHbqXSkvgU1/GVRXMbdAez66GxQsRPQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ShO4v8bNSokN6loOIh7VjQwg37VabDSOCHKuaxxKVsYoRpYDRvtn3NQEnFkvC+0Ja
         QIbm07XV/OvMGcb1M2f4rDSIDnQWtNirw7JKvMp8DNKQXd/7e38kDypuDo6pNBI9k0
         cbWdeOkyzFmEUizKga0ojsgQDqILoSuTI6TC+1JWxbbQHhFeu1ZKCmX2K/ueF137sc
         QalpKGp0+ZyvnV2QXRhQLWxB6LonOVWdFJf7XPllOp2XwjvdCtF3oQ5lPQDEV4OP3Y
         YoEXYmivwoGX58FYVbWjs/m1mYAuC/fdW+HmtQA8nITh7r80XqHnHorNuABb4ETjtm
         R1U9H5j2ZDj/Q==
Date:   Mon, 6 Dec 2021 18:00:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] Allow parallel devlink execution
Message-ID: <20211206180027.3700d357@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  5 Dec 2021 10:22:00 +0200 Leon Romanovsky wrote:
> This is final piece of devlink locking puzzle, where I remove global
> mutex lock (devlink_mutex), so we can run devlink commands in parallel.
> 
> The series starts with addition of port_list_lock, which is needed to
> prevent locking dependency between netdevsim sysfs and devlink. It
> follows by the patch that adds context aware locking primitives. Such
> primitives allow us to make sure that devlink instance is locked and
> stays locked even during reload operation. The last patches opens
> devlink to parallel commands.

I'm not okay with assuming that all sub-objects are added when devlink
is not registered.
