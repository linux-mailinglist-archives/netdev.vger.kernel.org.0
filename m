Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A7962162F
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 15:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbiKHOXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 09:23:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiKHOXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 09:23:24 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F127F58BC9
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 06:22:47 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id n12so38938867eja.11
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 06:22:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I/2XrmdghbmaaNa8DlOtVmiZ6wnxuyN0Gwxqhrv9NWE=;
        b=Lob1t9kBBiWI2SJB+VBPSsmDx3w9cLYoa/XYK5DPyPLjn2NW1BilVWMW4gVJOLeLpB
         3NwRl39PRdmdpR/aimOMTtw1u8xfCs3WMXLc5F+aPdHEgJHNgcKZN/S4LLdTNReEt5P6
         hJ+z0NUcQ/UfvZ1YWSEGQv0qG4TfLF57zEDfViihTEH1JbqXcvMpvrSeiiBC+uq4PcFA
         Zk9WwtvmRC8X3RKcXYDqJNxVcuic2vLmjSR2RXyH5fWvJp++Mhm/WaSKSxn0JB7QzA1j
         UkTQ1F5C3hC1Q7GW6rxT7s8dWug1PbB4v1X87r849cazqyMaNg62KWhIfEaB1Cos4WRj
         UpQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I/2XrmdghbmaaNa8DlOtVmiZ6wnxuyN0Gwxqhrv9NWE=;
        b=X522G/xENTiZYa+2ptWTT9QxRJJ2NBDB0QDB4NsoB2hOCG8HaRdMOhMU3jRakT0mpL
         aBWDby3CZyKsdB+IXA1w7BrZ6TBiWLWkO6L5U98YtmPeqMfP/BZNH6VrHYGXBcw0JWY0
         wM9D3vJAgNyzsluJKnFUR4uwwBa0WswuQSVn30nq0/T3XLVnlsd7xT0ucpDi2M6ljUIO
         rrQH4bTTbb+vkwCDLNEurA56+adQbXyrvWqbUyW9KyIyccA74KuGJ37v70Kvh1DWrdwd
         1QjTwBtZ5Wm/THIjL/5QejFNH34tOgZHg2I7CscQJgdY0+Sg5TovlVRzqcAqHZz5aH9p
         lpPg==
X-Gm-Message-State: ACrzQf3Rty7zjSKEABI93wlTqNdqAlH4Rj0/rgnk05wv07pE/GYoFFQZ
        2t9WbUe8WXFYnWUSzBNHU/I=
X-Google-Smtp-Source: AMsMyM7eqIWfGlREyktBYHU4Mu59xyQRNn8ghLb+HacV99Jy45Vk5chEOOqFML2mz3qh98tz5Gu/7g==
X-Received: by 2002:a17:906:9bed:b0:7a6:a68b:9697 with SMTP id de45-20020a1709069bed00b007a6a68b9697mr52009042ejc.218.1667917367256;
        Tue, 08 Nov 2022 06:22:47 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id c26-20020aa7c99a000000b00462bd673453sm5622772edt.39.2022.11.08.06.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 06:22:46 -0800 (PST)
Date:   Tue, 8 Nov 2022 16:22:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ivan Vecera <ivecera@redhat.com>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>,
        "Hans J . Schultz" <netdev@kapio-technology.com>, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 03/15] bridge: switchdev: Reflect MAB bridge
 port flag to device drivers
Message-ID: <20221108142244.r5polveqve3ckr7j@skbuf>
References: <cover.1667902754.git.petrm@nvidia.com>
 <2db3f3f1eff65e42c92a8e3a5626d64f46e68edc.1667902754.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2db3f3f1eff65e42c92a8e3a5626d64f46e68edc.1667902754.git.petrm@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 11:47:09AM +0100, Petr Machata wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Reflect the 'BR_PORT_MAB' flag to device drivers so that:
> 
> * Drivers that support MAB could act upon the flag being toggled.
> * Drivers that do not support MAB will prevent MAB from being enabled.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Petr Machata <petrm@nvidia.com>
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
