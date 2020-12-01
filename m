Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D332CAAD5
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392222AbgLASg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:36:58 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60404 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbgLASg5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 13:36:57 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkAVZ-009jau-Sx; Tue, 01 Dec 2020 19:36:13 +0100
Date:   Tue, 1 Dec 2020 19:36:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Subject: Re: [PATCH ethtool] Improve error message when SFP module is missing
Message-ID: <20201201183613.GM2073444@lunn.ch>
References: <4267a91b40ef4dff755c4476757e2b17f48dbf57.1606802961.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4267a91b40ef4dff755c4476757e2b17f48dbf57.1606802961.git.baruch@tkos.co.il>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 08:09:21AM +0200, Baruch Siach wrote:
> ETHTOOL_GMODULEINFO request success indicates that SFP cage is present.
> Failure of ETHTOOL_GMODULEEEPROM is most likely because SFP module is
> not plugged in. Add an indication to the user as to what might be the
> reason for the failure.
> 
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---
>  ethtool.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/ethtool.c b/ethtool.c
> index 1d9067e774af..6d785f830ffa 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -4856,6 +4856,7 @@ static int do_getmodule(struct cmd_context *ctx)
>  	err = send_ioctl(ctx, eeprom);
>  	if (err < 0) {
>  		perror("Cannot get Module EEPROM data");
> +		fprintf(stderr, "SFP module not in cage?\n");

I wonder if this should be limited to ENODEV and EIO? ENOMEM or
EINVAL is probably not going to be fixed by inserting a module.

       Andrew
