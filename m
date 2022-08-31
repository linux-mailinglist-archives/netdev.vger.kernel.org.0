Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082515A8888
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 23:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiHaVyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 17:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiHaVym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 17:54:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E635E8329
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 14:54:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAE2861B54
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 21:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2F05C433D6;
        Wed, 31 Aug 2022 21:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661982881;
        bh=hNyVpLRZ/zkitEOttAq8AiRCdOGIK1Na1NUxxC+DM+Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hBVgLQOlhyjmROmRuE7vYvjCGp4LdiVZyY9BPOi3l4EAXTlVqONFypPRfaJUiiJrv
         lNYZ4SE64ib5dl5nU3m2tXgY9b2MxvodQD9YRi231mLTrV3MTIUGdh7O4UFOKJJiMY
         brtaB9xIkuWNd5HdKIpnG4eaHWq0WTSzaUN0vxlKMOD2RWX1Ogp/NTE5p8uqOgaPHl
         jdNJyJREjo/ObZK3Q8ozHo85cU4LtFnw6gLyrfiGg0CoOVL/VEmVTgoxarKU1bfq/9
         Uz29Ha0Vj7YoMxQfreHbOiiPkem/qAoL77xYJM6tPS37RUryiAmHHdND0LPSN2wY84
         aeUzQuj/wXuSA==
Date:   Wed, 31 Aug 2022 14:54:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        Michal Michalik <michal.michalik@intel.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        Gurucharan <gurucharanx.g@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH net 3/3] ice: Add set_termios tty operations handle to
 GNSS
Message-ID: <20220831145439.2f268c34@kernel.org>
In-Reply-To: <20220829220049.333434-4-anthony.l.nguyen@intel.com>
References: <20220829220049.333434-1-anthony.l.nguyen@intel.com>
        <20220829220049.333434-4-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 29 Aug 2022 15:00:49 -0700 Tony Nguyen wrote:
> From: Michal Michalik <michal.michalik@intel.com>
> 
> Some third party tools (ex. ubxtool) try to change GNSS TTY parameters
> (ex. speed). While being optional implementation, without set_termios
> handle this operation fails and prevents those third party tools from
> working. TTY interface in ice driver is virtual and doesn't need any change
> on set_termios, so is left empty. Add this mock to support all Linux TTY
> APIs.
> 
> Fixes: 43113ff73453 ("ice: add TTY for GNSS module for E810T device")
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Intel)
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Please CC GNSS and TTY maintainers on the patches relating to 
the TTY/GNSS channel going forward.

CC: Greg, Jiri, Johan

We'll pull in a day or two if there are no objections.

> diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c b/drivers/net/ethernet/intel/ice/ice_gnss.c
> index b5a7f246d230..c2dc5e5c8fa4 100644
> --- a/drivers/net/ethernet/intel/ice/ice_gnss.c
> +++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
> @@ -404,11 +404,26 @@ static unsigned int ice_gnss_tty_write_room(struct tty_struct *tty)
>  	return ICE_GNSS_TTY_WRITE_BUF;
>  }
>  
> +/**
> + * ice_gnss_tty_set_termios - mock for set_termios tty operations
> + * @tty: pointer to the tty_struct
> + * @new_termios: pointer to the new termios parameters
> + */
> +static void
> +ice_gnss_tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
> +{
> +	/* Some 3rd party tools (ex. ubxtool) want to change the TTY parameters.
> +	 * In our virtual interface (I2C communication over FW AQ) we don't have
> +	 * to change anything, but we need to implement it to unblock tools.
> +	 */
> +}
> +
>  static const struct tty_operations tty_gps_ops = {
>  	.open =		ice_gnss_tty_open,
>  	.close =	ice_gnss_tty_close,
>  	.write =	ice_gnss_tty_write,
>  	.write_room =	ice_gnss_tty_write_room,
> +	.set_termios =  ice_gnss_tty_set_termios,
>  };
>  
>  /**

