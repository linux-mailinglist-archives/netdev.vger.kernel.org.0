Return-Path: <netdev+bounces-8950-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BD4D8726632
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:42:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B6EF1C20864
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6FF8168B9;
	Wed,  7 Jun 2023 16:42:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEA4563B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA60C433EF;
	Wed,  7 Jun 2023 16:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686156149;
	bh=zssne6QqdNoHguRgMNiZP5ueUBStAFNcKnJEkn1gm2Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EESF+uePGlgZb8fBowcYBUtnY7g6zGoPZrTxhyKWuenwbV4HaeCioP/6ntPc24Ye2
	 c9mcs521mSEoXC4JcvdXwmFpdb9rSkaTCLCFi8p5uZAg60lP60ksGGQDDUBbDBI6EW
	 rU/OJp/12lYRD7K4Igo+QhVybNXrX8XdUgAY7mm8kSAjp8wii3Tv/rAxDAQg0QrwUw
	 71uFamwH+xmY/3jjoZh/HDmPWWzqD6vzvB8nNxE0oTFrHJgFVgXGJ4v1IsjTQw/J+9
	 3qLkCSvSRAVSPzpHzUp57VMJKxSmBQxyr8XrI7vxPCJSfIiGMe6S4PO2kQTT60+y0i
	 LB3UZRFks044A==
Date: Wed, 7 Jun 2023 09:42:28 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Przemek Kitszel <przemyslaw.kitszel@intel.com>, Alexander Lobakin
 <aleksander.lobakin@intel.com>, intel-wired-lan@lists.osuosl.org, Jesse
 Brandeburg <jesse.brandeburg@intel.com>, Tony Nguyen
 <anthony.l.nguyen@intel.com>, Anirudh Venkataramanan
 <anirudh.venkataramanan@intel.com>, Sudheer Mogilappagari
 <sudheer.mogilappagari@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH iwl-next] ice: clean up __ice_aq_get_set_rss_lut()
Message-ID: <20230607094228.10f5b84a@kernel.org>
In-Reply-To: <ZIAzEh1Y++os19fl@corigine.com>
References: <20230606111149.33890-1-przemyslaw.kitszel@intel.com>
	<ZH9S6wPIg9os8HYa@corigine.com>
	<1e11a484-af99-4595-dc1f-80beb23aae9f@intel.com>
	<ZH9hS9BBDhy9lIG1@corigine.com>
	<9b5c6653-3319-3516-0b50-67668dcc88f3@intel.com>
	<ZIAzEh1Y++os19fl@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 7 Jun 2023 09:34:42 +0200 Simon Horman wrote:
> > it's the same on gcc-13 on default (make M=...) settings, I think, I will
> > post next version that is passing that build, even if to make integration
> > with new gcc easier  
> 
> Thanks. TBH it does seem a bit silly to me.
> But GCC builds failing does seem to be a problem that warrants being addressed.

Isn't GCC right? There's no guarantee that the value of @type in real,
numerical sense falls within the set of values sanctioned by the enum.
It is C after all, so enums are just decorated ints, aren't they?

