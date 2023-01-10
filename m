Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7FC664685
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 17:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbjAJQuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 11:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjAJQuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 11:50:21 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D992732C
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:50:20 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d15so13800953pls.6
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 08:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0c2xMCk5pVV9SZlW5Qu1OjCsSybOQehQknFwjYVnjdM=;
        b=CU1ulvOJvJ3u4WlgPPv4PgMOyODw4a0pp/59xbPyFwuzIWmOik4PICRyrG9WhaQHxq
         2ZRO2WqiZZ1BxlyqFUm9mATfNMqBVCRXEG5HlHe2Aq+11x95vakKru/UToRMfXMYCRnH
         UYwieqTe5VpXi7GCp9NAANOEvT0KNgj8F3bLg2ZWUBmif2/LzxyWtHhJdIoFSbRFyFiS
         rxzcYHagDKB+YewyhBfSHSg5Cdxygw7BKD++BcnwOjmKLCyXriFCGWFc8k7/yh79qxK7
         3j9OgsSL+g+dswXHZC+Lm2Jb4aQD+8vmJXo1H3sbxEH0tnphFasTd4knhMDPyT8C22Zb
         pPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0c2xMCk5pVV9SZlW5Qu1OjCsSybOQehQknFwjYVnjdM=;
        b=3wL1fxgqRx9+UErkFqHtbF1mnbXrsAebtqMotp7uDZah24Nd2xYgDYGeTaxlH/HKHe
         7QyVFRrD+p8gZZ8ukTABfWpDwNOGDg4gW1MjQtYXc+6NsjL2QYY9uuSMgLR5VNwxiUyY
         1CT4E+ZsmECX5Cr0a+ZK8CuwervjxnkHnKkwErRp4fA4lQdpjETjBVsBp0Y9cTb6oLLT
         AD0EQVAGZ9+KfH8HjYMoW07sddHLKjV9nQufEq9j+78LveYsGvIWWoSsPfUNVejfPOBw
         Isxr+0DVzYO3FarviUORpjbbT6vc+FcuhHqOtUxAExOXe1dNlOqHJQ2JZyifBOLKOKil
         NTzA==
X-Gm-Message-State: AFqh2kpGmP5MMQyWnd1GjPRlVwk05dkMHosic/XOy8jDdsXwU16XsjUa
        YSF1kQm9X9SH4A5atXoqI8fjOg==
X-Google-Smtp-Source: AMrXdXvwDOncr7QY3Mo1IHj2Aijd4KhhkCOSV5Wetpw8wXPyajtEIiSmANYZF61pW0P9I2Hi8qd2Sg==
X-Received: by 2002:a17:902:9888:b0:192:ce7e:93b7 with SMTP id s8-20020a170902988800b00192ce7e93b7mr31466100plp.49.1673369420436;
        Tue, 10 Jan 2023 08:50:20 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b00192849e1d0asm8312037plk.116.2023.01.10.08.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 08:50:19 -0800 (PST)
Date:   Tue, 10 Jan 2023 17:50:17 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     ehakim@nvidia.com
Cc:     sd@queasysnail.net, dsahern@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH main v2 1/1] macsec: Fix Macsec replay protection
Message-ID: <Y72XSaZk2rFA0500@nanopsycho>
References: <20230110144901.31826-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110144901.31826-1-ehakim@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


But iproute2 into the subject []'s so it is clear where this patch is targeted.

Tue, Jan 10, 2023 at 03:49:01PM CET, ehakim@nvidia.com wrote:
>From: Emeel Hakim <ehakim@nvidia.com>
>
>Currently when configuring macsec with replay protection,
>replay protection and window gets a default value of -1,
>the above is leading to passing replay protection and
>replay window attributes to the kernel while replay is
>explicitly set to off, leading for an invalid argument
>error when configured with extended packet number (XPN).
>since the default window value which is 0xFFFFFFFF is
>passed to the kernel and while XPN is configured the above
>value is an invalid window value.
>
>Example:
>ip link add link eth2 macsec0 type macsec sci 1 cipher
>gcm-aes-xpn-128 replay off
>
>RTNETLINK answers: Invalid argument
>
>Fix by passing the window attribute to the kernel only if replay is on
>
>Fixes: b26fc590ce62 ("ip: add MACsec support")
>Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
>---
>V1 -> V2: - Dont use boolean variable for replay protect since it will
>            silently break disabling replay protection on an existing device.
>          - Update commit message.
> ip/ipmacsec.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/ip/ipmacsec.c b/ip/ipmacsec.c
>index 6dd73827..d96d69f1 100644
>--- a/ip/ipmacsec.c
>+++ b/ip/ipmacsec.c
>@@ -1517,7 +1517,8 @@ static int macsec_parse_opt(struct link_util *lu, int argc, char **argv,
> 			  &cipher.icv_len, sizeof(cipher.icv_len));
> 
> 	if (replay_protect != -1) {
>-		addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
>+		if (replay_protect)
>+			addattr32(n, MACSEC_BUFLEN, IFLA_MACSEC_WINDOW, window);
> 		addattr8(n, MACSEC_BUFLEN, IFLA_MACSEC_REPLAY_PROTECT,
> 			 replay_protect);
> 	}
>-- 
>2.21.3
>
