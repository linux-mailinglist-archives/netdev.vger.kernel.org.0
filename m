Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9F94423CF
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:12:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhKAXOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:33016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232572AbhKAXOS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 19:14:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D56E9611C0;
        Mon,  1 Nov 2021 23:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635808284;
        bh=NN5tF1XlTzG+RznUlYdaLrzQJJw9gP5fU5pzMvRrSEM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KnjFfslLAV/okcq1Cq5guHlq/HqK3U9jXvqUcKOd84X1+vbmXUytpQihOUNEIkXO7
         SoPa6tXmopkzw/U4W+vWHO0HmeJFmOlkFgH+jL1peGaCAYUb+MpFQhjgNx1vxlGQuj
         T3TNF8qRnnmKUOfGiczTMLoQQowxERaXO2t0dzUZ56aZSILmfIGtf8+NIlSeaUBZsI
         osA4AEY6dzV+DiWlekaNEODfIMjUAuvUq2+aQe7qoz+Tu1IVNEPp0sFqT4VkR1mxNo
         bkgJEccXRjteG5ffOeHs4pKSlsTyY3gc8m2Ry0J0aRi2vSrxjBS6LxlPZgokT8SMx2
         kafOvKj6d144w==
Date:   Mon, 1 Nov 2021 16:11:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, edwin.peer@broadcom.com
Subject: Re: [PATCH net-next] devlink: Require devlink lock during device
 reload
Message-ID: <20211101161122.37fbb99d@kicinski-fedora-PC1C0HJN>
In-Reply-To: <YYBTg4nW2BIVadYE@shredder>
References: <9716f9a13e217a0a163b745b6e92e02d40973d2c.1635701665.git.leonro@nvidia.com>
        <YYABqfFy//g5Gdis@nanopsycho>
        <YYBTg4nW2BIVadYE@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Nov 2021 22:52:19 +0200 Ido Schimmel wrote:
> > >Signed-off-by: Leon Romanovsky <leonro@nvidia.com>  
> > 
> > Looks fine to me.
> > 
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>  
> 
> Traces from mlxsw / netdevsim below:

Thanks a lot for the testing Ido!

Would you mind giving my RFC a spin as well on your syzbot machinery?

Any input on the three discussion points there?

 (1) should we have a "locked" and "unlocked" API or use lock nesting?

 (2) should we expose devlink lock so that drivers can use devlink 
     as a framework for their locking needs?

 (3) should we let drivers take refs on the devlink instance?
