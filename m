Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 594BC5501D3
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 04:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383708AbiFRCBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 22:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiFRCBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 22:01:49 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4A536B7DC;
        Fri, 17 Jun 2022 19:01:48 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id i16so6176740ioa.6;
        Fri, 17 Jun 2022 19:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=73MEOrbzE3ax8V04SP0mBcUvOAjpQzCDavp7u+MsS1A=;
        b=PjmM+Ah6v7ckzA7L/loqODl5JGBhLe5T6ueGPbcwG8n1W7ySnxPu5ZXcsDGhDzI9PT
         Z/jPtA8ypT+4OVHTojh2fDB0vMJLQ9PgjQkl95jWeNZx5tXl9MvN5xMgD/ul0sF96BkN
         2o5lzah/BYXNvVKOz/twEODCmw7cGt1dpd96KUfDwxcyZtdtpIJcsmTfjwSVtQrts0Ht
         juQUIINwRRsqgTcNnpWTJsYS6HyEcPAJQPeEBp5xf2t/3+0kvBO9kwDHz3MPvYXM7u20
         XIg3jcWFQUSzBEOqlMd8CNJ/WE6Yn3oZBVHkeDlzPrWz4na6OweLtYpJgTkYBsfXSpH6
         ho0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=73MEOrbzE3ax8V04SP0mBcUvOAjpQzCDavp7u+MsS1A=;
        b=K79ruohAimYg04RoGpm46tUAhGAZNheRhYS3zctx/NDp1ORKXPaxcfG168zkImuV9g
         AwffI+VAzp56sq6x2Ev/1GcNjSesmXeM3o/xOul4uA77b35juEnhK42UF6nWHL/GSwsO
         Mji4ayVKbqf5tJIInm4aLoP846z5tSkZcn0RCRMFoYHxjMa5okWtc2WaB9ISOsWSPbAy
         SU8YbzQXak+fOtnpQL5Iz9VLpeZNJOOQrYRi8YpAYKgOeUPxFq/ZbUc+ebErXuZOJwJ3
         w8en5/Kx+gl5dcvUoi9JpS0Fv1tne6tY5ZYM7HR/u2JJO+ZUGuzd1kGzuYCT21Ibt44b
         SuEg==
X-Gm-Message-State: AJIora+s+AiBnPmxJMSw7DViDmh4wUAq7uHJQ1fw91sbPagizTBQ76i/
        lqk5BFUATKahQL4IPceW/Q8=
X-Google-Smtp-Source: AGRyM1shytZfDTlraWsBl8stKabWGKteLo9OYpnpKHWpEucZBBT7DV3fr9EfrqvIy0zlW0vBmkR03Q==
X-Received: by 2002:a5d:9748:0:b0:669:4785:75bd with SMTP id c8-20020a5d9748000000b00669478575bdmr6516037ioo.93.1655517708234;
        Fri, 17 Jun 2022 19:01:48 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id t5-20020a056e02060500b002d8f2385d56sm612637ils.63.2022.06.17.19.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 19:01:47 -0700 (PDT)
Date:   Fri, 17 Jun 2022 19:01:40 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad3204b355b_24b3420897@john.notmuch>
In-Reply-To: <20220616180609.905015-5-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-5-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 04/10] ice: do not setup vlan for loopback VSI
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Currently loopback test is failiing due to the error returned from
> ice_vsi_vlan_setup(). Skip calling it when preparing loopback VSI.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

These look like fixes unrelated to BPF and probably should go as
driver fixes into net tree?

> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> index 5bdd515142ec..882f8e280317 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -6026,10 +6026,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
>  	if (vsi->netdev) {
>  		ice_set_rx_mode(vsi->netdev);
>  
> -		err = ice_vsi_vlan_setup(vsi);
> +		if (vsi->type != ICE_VSI_LB) {
> +			err = ice_vsi_vlan_setup(vsi);
>  

Extra newline here makes it less readable in my opinion.

> -		if (err)
> -			return err;
> +			if (err)
> +				return err;
> +		}
