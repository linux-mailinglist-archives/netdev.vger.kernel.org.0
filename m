Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 601CA36104A
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 18:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbhDOQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 12:39:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:44990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231137AbhDOQjs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 12:39:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 283416117A;
        Thu, 15 Apr 2021 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618504765;
        bh=PzNDOTdUC46w/7QK0SvtrXWv0rftMki7WMeQoetQsR8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TuVhsR+GOB0klKIrAaeh1hG5OV19esnJSpJNn6t+ybYb8u2Lt7trS4MRQrAczU2we
         2KAjcoaOgbOIeJwXyc32qAPH+U2uQS3nA1OP1ER2e3G5BZR5/YHUEGc0ToTGMWUWwb
         8rpuu5BA1U91faZ6HkXquGPNn7OGW8ZiQbm7EkFnRfvL1FZchzVfjsVJ0En2kda9ga
         7EszhuafBm32h6NzIYpxisNs1oHEEbUtJoNTOvtcY7pfqpXcQoiJ/xe2oVVjLcc6Ac
         w+RAo9wX9A49/f4pV1i1CsUkh9ahYiwHeu+lOH+CMUVDdSBewEod09EEfGgCCdSuGy
         ZUvLpNa3OaMFg==
Date:   Thu, 15 Apr 2021 09:39:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net-next 03/15] ice: Add new VSI states to track netdev
 alloc/registration
Message-ID: <20210415093924.15434088@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210415003013.19717-4-anthony.l.nguyen@intel.com>
References: <20210415003013.19717-1-anthony.l.nguyen@intel.com>
        <20210415003013.19717-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 17:30:01 -0700 Tony Nguyen wrote:
> From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
> 
> Add two new VSI states, one to track if a netdev for the VSI has been
> allocated and the other to track if the netdev has been registered.
> Call unregister_netdev/free_netdev only when the corresponding state
> bits are set.

Why? netdev already has a reg_state member.
You can also assign a NULL to the pointer to indicate it was freed.
