Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050F76190CD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKDGR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiKDGRX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:17:23 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1AD28E30;
        Thu,  3 Nov 2022 23:17:22 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l11so6202583edb.4;
        Thu, 03 Nov 2022 23:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vnXXi3dtDeA8axtgZhnSxDrgwZYg0E3gMcTkynU2jnc=;
        b=oweGMtYqZ7/L36euTghQ0xwNttLV0blhlZdGd9z30tXMFbZEG4H5+VveF/DO7F4dzg
         dCVcer72QSzmCGOEKz0FB+EwrXXfhXlfJU6Secs2DOy8XP7AHE31KtbL+OUUE0OCJ6Hr
         yrA91oVSsY7IRPk6F8QVClJAutQGbgIpB9s/hd0wYjdUTZGEp7ByXlZ2g8ZjS1hv6rQS
         ndeVc8Mmmt2q2ha7muD2EUHJPgMQ4FYk9ZRyIdjwVXQSGGIbXEYlJedplscA5n36dygm
         RZ86iK2RMdudYVhtuV5SFhEcL9qy3ueArwoFUt/9OJZx4f1oXyEiIQK40Jern8LvLyLd
         +rlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vnXXi3dtDeA8axtgZhnSxDrgwZYg0E3gMcTkynU2jnc=;
        b=xNSuiMT3va9rqi4j7ej7hJTJEIzH+ynqfSWPW+/1hkT8iWZ1FIy+/Zlr8AZh8AHS5y
         QiNoe1sOVCLPK3IhkawJCZvEzQD5jB+mq0+ZBZOBsNlQaNRa+3bV4kYw866Kbh+QPbEU
         litg1xb5N0fwNGrFbH6vu4vALSab/aXFBkhq6bVy86+5srAtC3UJo0fbGirFMRLDchmL
         nmVZ3d7lco3EB2Qu9TUYh2jWqmT2TY0Rf5dn8xDw/exwSHiQNEoNkNn2UWLwlYSPm/59
         IwzRyYa1zj4NkUwACIu2D0tgSjDM5kgg93MUR3ttctqLPIYROfEvtRHtBnDjjwrhbB+5
         5hOg==
X-Gm-Message-State: ACrzQf3dYrjuC8Gw5SarGW9ER8i2yH0rhcWa8+T+FysQ4icjGA+PlNd0
        7agMUPpIM4uo7Dg8S09ygp4=
X-Google-Smtp-Source: AMsMyM5qJJYQVnfTuAbfE974R0XTKpxn5urBJZVGPKiOREWaPv/BYEeOguBJ8dHuTJY+GO5bYVeW8w==
X-Received: by 2002:aa7:df94:0:b0:461:aff8:d3e1 with SMTP id b20-20020aa7df94000000b00461aff8d3e1mr34530709edy.10.1667542641116;
        Thu, 03 Nov 2022 23:17:21 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id sg43-20020a170907a42b00b0077d37a5d401sm1406870ejc.33.2022.11.03.23.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:17:20 -0700 (PDT)
Date:   Thu, 3 Nov 2022 23:17:18 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     bagasdotme@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next v2] net: ethernet: Simplify bool conversion
Message-ID: <Y2SubudMxMLV8R8D@hoboy.vegasvil.org>
References: <20221104030313.81670-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104030313.81670-1-yang.lee@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 11:03:13AM +0800, Yang Li wrote:

> diff --git a/drivers/net/ethernet/renesas/rcar_gen4_ptp.c b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
> index c007e33c47e1..37f7359678e5 100644
> --- a/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
> +++ b/drivers/net/ethernet/renesas/rcar_gen4_ptp.c
> @@ -29,7 +29,7 @@ static const struct rcar_gen4_ptp_reg_offset s4_offs = {
>  static int rcar_gen4_ptp_adjfine(struct ptp_clock_info *ptp, long scaled_ppm)
>  {
>  	struct rcar_gen4_ptp_private *ptp_priv = ptp_to_priv(ptp);
> -	bool neg_adj = scaled_ppm < 0 ? true : false;
> +	bool neg_adj = scaled_ppm < 0;
>  	s64 addend = ptp_priv->default_addend;
>  	s64 diff;

Please preserve reverse Christmas tree order.

Thanks,
Richard
