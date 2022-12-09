Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1773F6481CF
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiLILgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLILgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:36:12 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86B0396CA;
        Fri,  9 Dec 2022 03:36:11 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id gh17so10842904ejb.6;
        Fri, 09 Dec 2022 03:36:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hME457FwOcsuD85WVgREfguV7sHCYfmeueLMWOELtEM=;
        b=Ck6D15TXnyB+oYuhWGf71tGYDOXAQXmTym76Ry5hrZoZtB3AzhoavgH5Ykx5OqxzmV
         H3fMHIh+sUC8xSbhXzieR2RG37wYyjpzOP7m+RNeRmsdOZh6OypNE9N6IZ75xvYpxi23
         hzYzr4eE2wRma5gOJ+wFifBaNrPekbFh8+f08GDp424tFmDxAL77JaqQHQvw22fCVTid
         otRqqjeGdEy+H/BQy8EFpBnVXSvEgdeOro0+DCjBdwKobShWw9H7XowLqxo+Rn4S88Qm
         mj1mp21nFp6nuPoZrdsiplMXdk1VuHpa6iTH/QwBPLvAegyk1sj5YFC1unf1RQSxhdpb
         12UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hME457FwOcsuD85WVgREfguV7sHCYfmeueLMWOELtEM=;
        b=Rwk8BDq/rP5QqSzsHm3mzjxGfLC9j9cLsPh9SAJ/3eDd1nGckG7GijF3sCTOKSwF4V
         bFcidxtNdOkz8/wt8qA1eFQ7rib+NMP8WDeNthzEvnYO3ibATt2+xwNBpAPLJ8yzYDfM
         B7HyNzz+lCJeKAby0aTYOe5QRdFk074Ep3o2OqG38D+f/jdQJatiqhkEjwBZX9REpnd9
         Rld0ivg6QMZ45UkpryTYfiNtC27NbRHOwpNPyK6opwf2/rYCaRv9IX3jbNHAnWoX9N4S
         U9OjbKr/wDNre3i12H43n3IR52LF78cz7Zcs/lQpsLtUmIjdKZ0zAUJF5ZTsmyaHsmj4
         e9Dg==
X-Gm-Message-State: ANoB5plmW8z3pkbbfRd2IJSIITsAMZX7f7jeWvoC+6sGflheQWMDlRjn
        31oHfULiGmDVw6ybA4vJZHA=
X-Google-Smtp-Source: AA0mqf4GzzURqrp1SvrWFFE1v5/ZfrZ6vGVH4qUA2GaXMlagPoVnu1Y01106S2atusrbAOb5Dza5Xw==
X-Received: by 2002:a17:906:a102:b0:7bd:f540:9bf9 with SMTP id t2-20020a170906a10200b007bdf5409bf9mr4512403ejy.32.1670585770278;
        Fri, 09 Dec 2022 03:36:10 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906218900b007ad9c826d75sm465170eju.61.2022.12.09.03.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 03:36:09 -0800 (PST)
Date:   Fri, 9 Dec 2022 13:36:07 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com, richardcochran@gmail.com,
        ceggers@arri.de
Subject: Re: [Patch net-next v3 01/13] net: dsa: microchip: ptp: add the
 posix clock support
Message-ID: <20221209113607.xc5u7uhhlbevjk6w@skbuf>
References: <20221209072437.18373-1-arun.ramadoss@microchip.com>
 <20221209072437.18373-2-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209072437.18373-2-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 12:54:25PM +0530, Arun Ramadoss wrote:
> From: Christian Eggers <ceggers@arri.de>
> 
> This patch implement routines (adjfine, adjtime, gettime and settime)
> for manipulating the chip's PTP clock. It registers the ptp caps
> to posix clock register.
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Co-developed-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> 
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com> # mostly api
