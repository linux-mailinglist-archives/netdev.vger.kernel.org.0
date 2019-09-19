Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A62AB786B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389755AbfISLZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:25:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfISLZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 07:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 629CB21929;
        Thu, 19 Sep 2019 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568892310;
        bh=84PMMk/PsMhWfiAtr6+OFOFfKsnQcIbABrn95J9LeVM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b5o+0Zr9UDP0XhC0HKGUkWrVlpyQquvIdFP92L1R0FVJ97jL1fAvMmiWxIJGmL7Rv
         4y41MrBkFp0z0WtlpsaoPEl6A6NgvhaRsdGvg0Ucb2JjW7njglWNav6hhSdDWwF/EQ
         Xh9Tk8ZF7m+8ReQD2cmXt+2OAEDNaL8wb1WnyH64=
Date:   Thu, 19 Sep 2019 13:25:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        David Le Goff <David.Legoff@silabs.com>
Subject: Re: [PATCH 00/20] Add support for Silicon Labs WiFi chip WF200 and
 further
Message-ID: <20190919112508.GA3037175@kroah.com>
References: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190919105153.15285-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 10:52:34AM +0000, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Hello all,
> 
> This series add support for Silicon Labs WiFi chip WF200 and further:
> 
>    https://www.silabs.com/documents/public/data-sheets/wf200-datasheet.pdf
> 
> This driver is an export from:
> 
>    https://github.com/SiliconLabs/wfx-linux-driver/
>    
> I squashed all commits from github (it definitely does not make sense to
> import history). Then I split it in comprehensible (at least try to be)
> commits. I hope it will help readers to understand driver architecture.
> IMHO, firsts commits are clean enough to be reviewed. Things get more
> difficult when I introduce mac8011 API. I tried to extract important
> parts like Rx/Tx process but, big and complex patches seem unavoidable
> in this part.
> 
> Architecture itself is described in commit messages.
> 
> The series below is aligned on version 2.3.1 on github. If compare this
> series with github, you will find traditional differences between
> external and a in-tree driver: Documentation, build infrastructure,
> etc... In add, I dropped all code in CONFIG_WFX_SECURE_LINK. Indeed,
> "Secure Link" feature depends on mbedtls and I don't think to pull
> mbedtls in kernel is an option (see "To be done" below).
> 
> 
> What need to be done in this driver  to leave staging area?
> 
>   - I kept wfx_version.h in order to ensure synchronization with github
>     waiting for development goes entirely in kernel

That should be removed soon.

>   - I also kept compatibility code for earlier Linux kernel version. I
>     may drop it in future. Maybe I will maintain compatibility with
>     older kernels in a external set of patches.

That has to be dropped for the in-kernel version.

The rest of these are fine, can you add this list in a TODO file for
this directory like the other staging drivers have?

thanks,

greg k-h
