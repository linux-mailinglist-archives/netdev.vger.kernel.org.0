Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86980235515
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 06:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgHBEWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 00:22:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725866AbgHBEWF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 00:22:05 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7857A2075A;
        Sun,  2 Aug 2020 04:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596342124;
        bh=nKswPzV69paM5PpdDnwEV5X1NDfBxVoALBPeGfZvxJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1szGYV8GmveA6Vur/zsQf9NymfyeD4/BI8xiJx3bPk4Yl8EQwnZR9azcz/wV6N5U1
         a3/ag/vRkLl7OoBhKIqgFX/7Iju01TzewWNF8h9nWde6yolVswygrlbMd9mDnWx4nd
         m0dMaaXFrFhtyUAxMpKt9KBP9Gkz2gZXyahLxAXI=
Date:   Sat, 1 Aug 2020 21:22:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Cc:     Ganji Aravind <ganji.aravind@chelsio.com>, netdev@vger.kernel.org,
        davem@davemloft.net, vishal@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Add support to flash firmware config
 image
Message-ID: <20200801212202.7e4f3be2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200731211733.GA25665@chelsio.com>
References: <20200730151138.394115-1-ganji.aravind@chelsio.com>
        <20200730162335.6a6aa4cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200731110904.GA1571@chelsio.com>
        <20200731110008.598a8ea7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200731211733.GA25665@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 1 Aug 2020 02:47:38 +0530 Rahul Lakkireddy wrote:
> I thought /lib/firmware is where firmware related files need to be
> placed and ethtool --flash needs to be used to program them to
> their respective locations on adapter's flash.

Our goal is to provide solid, common interfaces for Linux users to rely
on. Not give way to vendor specific "solutions" like uploading ini files
to perform device configuration.

> Note that we don't have devlink support in our driver yet. And,
> we're a bit confused here on why this already existing ethtool
> feature needs to be duplicated to devlink.

To be clear - I'm suggesting the creation of a more targeted APIs 
to control the settings you have encoded _inside_ the ini file. 
Not a new interface for an whole sale config upload.

Worst case scenario - if the settings are really device specific 
you can try to use devlink device parameters.
