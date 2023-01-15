Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3641166B0E4
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 13:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjAOMNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 07:13:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjAOMNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 07:13:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A534FEC6A;
        Sun, 15 Jan 2023 04:13:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B20760C97;
        Sun, 15 Jan 2023 12:13:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BF08C433D2;
        Sun, 15 Jan 2023 12:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673784829;
        bh=sTsG13W9UebwSKWU8xglNKlA4vWEJMrgT7CdeBsW/yo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pR6tp4JB1DxjfL72Mf8tLhqGd6OsxVetLkkIxeuWwUPIiD/KzF6zOmXKINHfBpDzM
         wr1VFsDsLEAlV32K5zAjvNSHBJYngdok+lZ/kN9hiONjUAvbbdF8mXNfbbhMJx04OV
         tqqSz6maeRPQjOoZEwUmjQXIhQpcehoQSix1wwWKBAsIF/295pGHV97lxOjvGuvm7q
         OT1pwYLInsBuZIzWNfcnByuuERosUDU6i+LwbE6RiS/3gKpWhbgbGaTMw/2GO8hMIf
         AomtLaGMNRdUrxITO7/AfIuhQSXikFwlPxKvOKVALwej/NnC6xAqiQbIR6Jn/Tc9OZ
         IqpoCykvYY9kQ==
Date:   Sun, 15 Jan 2023 14:13:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lizhe <sensor1010@163.com>
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, johannes.berg@intel.com,
        alexander@wetzel-home.de, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] wireless/at76c50x-usb.c : Use devm_kmalloc replaces
 kmalloc
Message-ID: <Y8Pt+IdfWBVy8nIA@unreal>
References: <20230113141231.71892-1-sensor1010@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113141231.71892-1-sensor1010@163.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 13, 2023 at 06:12:31AM -0800, Lizhe wrote:
> use devm_kmalloc replaces kmalloc

No, it is not.

> 
> Signed-off-by: Lizhe <sensor1010@163.com>
> ---
>  drivers/net/wireless/atmel/at76c50x-usb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
> index 009bca34ece3..f486ddb83d46 100644
> --- a/drivers/net/wireless/atmel/at76c50x-usb.c
> +++ b/drivers/net/wireless/atmel/at76c50x-usb.c
> @@ -2444,7 +2444,7 @@ static int at76_probe(struct usb_interface *interface,
>  
>  	udev = usb_get_dev(interface_to_usbdev(interface));
>  
> -	fwv = kmalloc(sizeof(*fwv), GFP_KERNEL);
> +	fwv = devm_kmalloc(sizeof(*fwv), GFP_KERNEL);
>  	if (!fwv) {
>  		ret = -ENOMEM;
>  		goto exit;
> @@ -2535,7 +2535,6 @@ static int at76_probe(struct usb_interface *interface,
>  		at76_delete_device(priv);
>  
>  exit:
> -	kfree(fwv);
>  	if (ret < 0)
>  		usb_put_dev(udev);
>  	return ret;
> -- 
> 2.17.1
> 
