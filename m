Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C6564E9F
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 09:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbiGDHZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 03:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbiGDHZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 03:25:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA5756398;
        Mon,  4 Jul 2022 00:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F297B80D79;
        Mon,  4 Jul 2022 07:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8963C3411E;
        Mon,  4 Jul 2022 07:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656919547;
        bh=CMzbwHV87MtVKIEm8gCOGjt884UiGhoUpRTPOzSZWxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khJC0mIWrztZoPaePP/a9MQp22bHIdMnrN3W2UoRn6EcIaMzdglOyMc2AeYwlSLPq
         9LjDXaU7ZaGBt0Ayf1quoPJgKJc9Ib/1Yv/Lz7DtTPx99UR8WpwVz83Ajv42LqS0XU
         rGIsAFai8CU9YjRSjmJhamofndlni6IueCPNgfWU=
Date:   Mon, 4 Jul 2022 09:25:44 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
Subject: Re: [PATCH 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Message-ID: <YsKV+BFUIt7UN7xP@kroah.com>
References: <20220704070407.45618-1-lukasz.spintzyk@synaptics.com>
 <20220704070407.45618-2-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220704070407.45618-2-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 04, 2022 at 09:04:06AM +0200, Łukasz Spintzyk wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
> 
> Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> ---
>  drivers/net/usb/cdc_ncm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
> index d55f59ce4a31..4594bf2982ee 100644
> --- a/drivers/net/usb/cdc_ncm.c
> +++ b/drivers/net/usb/cdc_ncm.c
> @@ -2,6 +2,7 @@
>   * cdc_ncm.c
>   *
>   * Copyright (C) ST-Ericsson 2010-2012
> + * Copyright (C) 2022 Synaptics Incorporated. All rights reserved.

As I ask many times for other copyright additions, when making a change
like this, for such a tiny patch, I want to see a lawyer from your
company also sign off on the patch proving that they agree that this
line should be added.

thanks,

greg k-h
