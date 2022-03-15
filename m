Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAB04D9764
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346395AbiCOJRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346469AbiCOJRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:17:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FEC4E391;
        Tue, 15 Mar 2022 02:15:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0B13B81183;
        Tue, 15 Mar 2022 09:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D9AC340E8;
        Tue, 15 Mar 2022 09:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647335741;
        bh=l1R2XSWapE0i4IDORc727y2YY4vcmUte1xjk7iPWNiY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sIGFKzlETLHpwWBIKenJKwxxPThR9CAm7ds8Hw6wTvcAFQuGSZN7ik/Ovcw0eGQao
         6+dTRUDXHH3Zpxlk3F95V/0UA+2V4iJ6r+2IqOcBRu5yeo7V6AcfdptpMvkNnqvz4k
         wYrveW7k7QwByiptSRXFCm7US448hDG30gI0nYVc=
Date:   Tue, 15 Mar 2022 10:15:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net] net: handle ARPHRD_PIMREG in dev_is_mac_header_xmit()
Message-ID: <YjBZNmRqp/GODOSP@kroah.com>
References: <20220315090102.31091-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315090102.31091-1-nicolas.dichtel@6wind.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 10:01:02AM +0100, Nicolas Dichtel wrote:
> This kind of interface doesn't have a mac header. This patch fixes
> bpf_redirect() to a PIM interface.
> 
> Fixes: 27b29f63058d ("bpf: add bpf_redirect() helper")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  include/linux/if_arp.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/if_arp.h b/include/linux/if_arp.h
> index b712217f7030..1ed52441972f 100644
> --- a/include/linux/if_arp.h
> +++ b/include/linux/if_arp.h
> @@ -52,6 +52,7 @@ static inline bool dev_is_mac_header_xmit(const struct net_device *dev)
>  	case ARPHRD_VOID:
>  	case ARPHRD_NONE:
>  	case ARPHRD_RAWIP:
> +	case ARPHRD_PIMREG:
>  		return false;
>  	default:
>  		return true;
> -- 
> 2.33.0
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
