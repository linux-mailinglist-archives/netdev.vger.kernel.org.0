Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8D4A2BC237
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728555AbgKUVJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgKUVJO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:09:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A12220936;
        Sat, 21 Nov 2020 21:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605992953;
        bh=TIeS6PaUttvzRgqF20LuCyiAE4CU0g3ARlM/9kTLIBI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NkmiTi5Y24PhPioaBOkNQO0nQmuJR6hacM2cXlUL+19gTq3N16ZUs3BDA813sMebx
         cUf/dsxMydKOztKdZ0CZNqiOuPt4R4AepBvuKTXVSZ9x12AMODMeUQE1hlgeGOox7n
         r2HCuOQB7d0/bZ1C8xFP2Tfrt4aYqZWtvwXZOY5E=
Date:   Sat, 21 Nov 2020 13:09:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Jamie Iles <jamie@nuviainc.com>, netdev@vger.kernel.org,
        Qiushi Wu <wu000273@umn.edu>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCHv3] bonding: wait for sysfs kobject destruction before
 freeing struct slave
Message-ID: <20201121130912.68903b8a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <X7fjR8ZB6BVwKS++@kroah.com>
References: <20201113171244.15676-1-jamie@nuviainc.com>
        <20201120142827.879226-1-jamie@nuviainc.com>
        <X7fjR8ZB6BVwKS++@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:39:51 +0100 Greg Kroah-Hartman wrote:
> On Fri, Nov 20, 2020 at 02:28:27PM +0000, Jamie Iles wrote:
> > syzkaller found that with CONFIG_DEBUG_KOBJECT_RELEASE=y, releasing a
> > struct slave device could result in the following splat:

> > This is a potential use-after-free if the sysfs nodes are being accessed
> > whilst removing the struct slave, so wait for the object destruction to
> > complete before freeing the struct slave itself.
> 
> Nice, it looks like it should have always been done this way!
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Applied to net, thanks!
