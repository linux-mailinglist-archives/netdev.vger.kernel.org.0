Return-Path: <netdev+bounces-9784-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AF8172A94F
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:18:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2C5E281AAC
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C756FAC;
	Sat, 10 Jun 2023 06:18:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76546FA7
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629E2C433EF;
	Sat, 10 Jun 2023 06:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686377925;
	bh=KPgD/9Glz7+iZJGMHKYZ1mmYqCqGiq+K6N4Gb83nmU4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=WfQA/qiwN1uY78SbVfP0pXYOw5bXZvDwqwyzVfboSQZbiZl0tmk8E/y8FT5EmvVMs
	 F9laZGCQo2iY3O1qTj+IoL/woQBGKebAO2I3ZrX+r/pbvax59Us1GFfb8iMUxE5sNB
	 L1SlxWyszSzsPrKaE+Zs3NxL9o01Cg0L9OoRoFAufQYowtk+fclGqD8zPXJVSds3Hr
	 ayV+4d3cOmKBrxNlu1Aug5zApooRSDmAVd1tDEHj9YrEh7OG9onz6N+HT3tc658Eh/
	 ivqV9atz7ykJKM5D0f/886+1PddRHsJzU+ev2NjjSzwXdn7GSHcgx3aZ5n6NPFXiH6
	 oXdvy72MdEqoQ==
Date: Fri, 9 Jun 2023 23:18:43 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Justin Chen <justin.chen@broadcom.com>
Cc: netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
 florian.fainelli@broadcom.com, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Andrew
 Lunn <andrew@lunn.ch>, Daniil Tatianin <d-tatianin@yandex-team.ru>, Ido
 Schimmel <idosch@nvidia.com>, Marco Bonelli <marco@mebeim.net>, Wolfram
 Sang <wsa+renesas@sang-engineering.com>, Jiri Pirko <jiri@resnulli.us>, Gal
 Pressman <gal@nvidia.com>, Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
 Kuniyuki Iwashima <kuniyu@amazon.com>, open list
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] ethtool: ioctl: improve error checking for
 set_wol
Message-ID: <20230609231843.6e5a18db@kernel.org>
In-Reply-To: <c512a8ee-cfc7-d0c8-6cf2-442da8dc1f1b@broadcom.com>
References: <1686179653-29750-1-git-send-email-justin.chen@broadcom.com>
	<c512a8ee-cfc7-d0c8-6cf2-442da8dc1f1b@broadcom.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 13:47:22 -0700 Justin Chen wrote:
> Was thinking more about this patch. I realized we don't account for the 
> different sopass case.
> # ethtool -s eth0 wol s sopass 11:22:33:44:55:66
> # ethtool -s eth0 wol s sopass 22:44:55:66:77:88
> 
> For this case, the second sopass values won't be stored.
>
> Can you drop this patch? I will submit another version.

We can't drop patches, it'd mess up commit IDs and basing
trees on top of net-next would be a major PITA for people.
Please send a fix on top (with a Fixes tag making it clear
that the problem has not reached any -rc kernel).

