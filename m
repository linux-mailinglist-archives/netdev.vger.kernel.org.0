Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D32B462629
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 23:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234822AbhK2WsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 17:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhK2Wrc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 17:47:32 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC7CEC03AD56
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 10:10:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3E94FCE13AB
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 18:10:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451C0C53FC7;
        Mon, 29 Nov 2021 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638209432;
        bh=+jZXABAy86NtUcVg64ekIYcdwQVVvfyTYydQwcFdiCU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eETQg1VGpEizZw0j5AsfFa1wLWzYXjoQuZ+SgqmdJ7/IQMkCdXc45OqEbKGjNULWQ
         /oCNLmDhJurg9mz+tl3iBuivGmYL41wdRj6f6y6LdXLi3EuzLRFO4rbQ9Cgabq1mhS
         WzNAgqT3ej3BKFK6LiBue3mwWMMXdUnKi2lt4QsAWh3mF9OqVqOFepT1vxKIRq7GE5
         5QmDQqhX5zMFh5zc7nuDARH29A2g/JF0tB7/0KRr8NpIP64r6ourUgNlsNS9HibIPu
         qw8F5z0K0/zJtbGFmC0gmxInJLeKqmenBiMtgSdZtmJXL3f/X1KK55TFxFhdk/Y6bQ
         q3ZCStyn3mLTw==
Date:   Mon, 29 Nov 2021 10:10:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211129101031.25d35a5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <21da13fb-e629-0d6e-1aa1-56e2eb86d1c3@gmail.com>
References: <20211125165146.21298-1-lschlesinger@drivenets.com>
        <YaMwrajs8D5OJ3yS@unreal>
        <20211128111313.hjywmtmnipg4ul4f@kgollan-pc>
        <YaNrd6+9V18ku+Vk@unreal>
        <09296394-a69a-ee66-0897-c9018185cfde@gmail.com>
        <20211129135307.mxtfw6j7v4hdex4f@kgollan-pc>
        <21da13fb-e629-0d6e-1aa1-56e2eb86d1c3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Nov 2021 08:30:16 -0700 David Ahern wrote:
> On 11/29/21 6:53 AM, Lahav Schlesinger wrote:
> > Hi David, while I also don't have any strong preference here, my
> > reasoning for failing the whole request if one device can't be deleted
> > was so it will share the behaviour we currently have with group deletion.
> > If you're okay with this asymmetry I'll send a V4.  
> 
> good point - new features should be consistent with existing code.
> 
> You can add another attribute to the request to say 'Skip devices that
> can not be deleted'.

The patch is good as is then? I can resurrect it from 'Changes
Requested' and apply.

Any opinion on wrapping the ifindices into separate attrs, Dave?
I don't think the 32k vs 64k max distinction matters all that much,
user can send multiple messages, and we could point the extack at
the correct ifindex's attribute.
