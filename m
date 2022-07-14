Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F50574D4D
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 14:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238088AbiGNMTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 08:19:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiGNMTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 08:19:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443D91A821;
        Thu, 14 Jul 2022 05:19:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1ACD61EA6;
        Thu, 14 Jul 2022 12:19:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF380C34114;
        Thu, 14 Jul 2022 12:19:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657801179;
        bh=djZHnQ5DWpPqB9xL6kTMPqvL+djGHp0K7rCJu0zj2EQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/3yk0qGYAzMJFuRNNIA3lB0ZFiRtn6Dq0o/V6+FfBOsKbilEyCKJ3afOw+eLM3Pw
         ityeYMlLorDWPDFQg3JRJqn5nYX0cJk0h5czf+GXbqlv56wSa/7c6GN+URtcrM4j6m
         fZQ90sJiCZ6YJgHLa4gOB97o/4c8M4G5+UWzkJS0=
Date:   Thu, 14 Jul 2022 14:19:36 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz?= Spintzyk <lukasz.spintzyk@synaptics.com>,
        Bernice Chen <Bernice.Chen@synaptics.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        oliver@neukum.org, kuba@kernel.org, ppd-posix@synaptics.com
Subject: Re: [PATCH v2 1/2] net/cdc_ncm: Enable ZLP for DisplayLink ethernet
 devices
Message-ID: <YtAJ2KleMpkeFfQq@kroah.com>
References: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220714120217.18635-1-lukasz.spintzyk@synaptics.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 02:02:16PM +0200, Łukasz Spintzyk wrote:
> From: Dominik Czerwik <dominik.czerwik@synaptics.com>
> 
> This improves performance and stability of
> DL-3xxx/DL-5xxx/DL-6xxx device series.
> 
> Specifically prevents device from temporary network dropouts when
> playing video from the web and network traffic going through is high.
> 
> Signed-off-by: Bernice Chen <Bernice.Chen@synaptics.com>
> Signed-off-by: Dominik Czerwik <dominik.czerwik@synaptics.com>
> Signed-off-by: Łukasz Spintzyk <lukasz.spintzyk@synaptics.com>
> ---
> 
> v2: Added Bernice Chen as company lawyer.

You forgot to cc: them, as they obviously want to be involved in this
process.  They do understand what Signed-off-by: means, right?

> 
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

Bernice, please note that Dominik is only adding 23 lines to a 2039 line
file, making this a change that only affects a very small percentage of
the overall code, and affects the logic in no direct way (they are only
adding new device information.)

Based on that information, you still believe this warrents an addition
of a copyright notice?  Any pointers to legal rulings where this is
backed up would be appreciated as it goes against what I have been told
to allow by my lawyers.

thanks,

greg k-h
