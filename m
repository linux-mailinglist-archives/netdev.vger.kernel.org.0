Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F80951CE36
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 04:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388198AbiEFCB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 22:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349212AbiEFCBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 22:01:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4016615D;
        Thu,  5 May 2022 18:57:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 495C561B96;
        Fri,  6 May 2022 01:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDC3C385AC;
        Fri,  6 May 2022 01:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651802263;
        bh=GeHdkr2ZO4kmGx/9U2bw97L/SWe5YfhsVGtl0N4MQus=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NhqDevJKpqzSnUuqL/tpGdvIFH11cZzDNm5Hm500j1Wo0EVqgV37EO4yHfCAgyjQ5
         2k+mh9p8Kq2G/n5Scg+2++7nS69cctsbfozfwkaVabsRskVhOSYM4RTZ+pOaExpnRd
         g6FpeWxeuBufeVTDsh+9dq6EU4iZWBt5GAyO5H7dliy2LaFHMuKUUL4Mxz6oPImxLP
         iyxvVwgqN+GN1plq9fT2fId8SKcyFIqFl2teJsgh+mbnUWAPaDakv4rrsx+B23QCcp
         hAb7ljc6jM9LzLviskcnArIlz/FcFgYOJJ+hzVIsXsxe+R29Vju/eZ8PMUc8bxhQBP
         ktRJocE9mHXEQ==
Date:   Thu, 5 May 2022 18:57:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net v4 1/2] ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS
 support
Message-ID: <20220505185742.1246d738@kernel.org>
In-Reply-To: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
References: <1651697455-1588-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 May 2022 16:50:54 -0400 Min Li wrote:
> Use TOD_READ_SECONDARY for extts to keep TOD_READ_PRIMARY
> for gettime and settime exclusively

Can you fill in more details about what the user visible problem is?
Judging by the fact that you haven't tagged the patch as 
[PATCH net-next] after my previous explanation you do think this 
is a fix. But "Add xyz support" sounds like a feature, not a fix.

> Signed-off-by: Min Li <min.li.xe@renesas.com>
> Acked-by: Richard Cochran <richardcochran@gmail.com>

> -	err = char_array_to_timespec(buf, sizeof(buf), ts);
> -
> -	return err;
> +	return char_array_to_timespec(buf, sizeof(buf), ts);

I don't think you were modifying this code, so no need to clean it up
in this commit. It's unrelated to the change you're making now.

>  }

> -	/* Re-enable extts */
> -	if (extts_mask)
> -		idtcm_enable_extts_mask(channel, extts_mask, true);
> +	err = _idtcm_gettime(channel, ts, 10);
>  
>  	return err;
>  }

Here, tho, you are changing the code, and yet you haven't done what 
I asked.

