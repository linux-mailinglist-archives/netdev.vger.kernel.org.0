Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC08687E4F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 14:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBBNKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 08:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231482AbjBBNKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 08:10:39 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33378E688
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 05:10:37 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id me3so5783679ejb.7
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 05:10:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=amdkUoG7lUkYVoF3GeIRSbtSXbydNKaXHbarQ4XEWNQ=;
        b=x6B4T+iSlZcnK2mOcptJh5ljpgTqY07B65Syri0RueqTee4rssolDnuhZQKgDOAMd1
         T6tVgXixMbfGGF/iM0DoouRw6Qs4B8A4SgwxZ8oLskgFE7fyjsvtjycoBV5LcvnM4UUK
         kD5RSfZ/VItgo+7k3A1bpJQ0awzlNrBe4oHz9SUpx7qmWD8oprGstyllABCueQXu6G7q
         aD4Vbl1h8r/z8XNxjGnFAvibzmzuDwIC1E8r1uULXFJqMkdBUT4/9zu8vdWjhl/KUwMd
         +m9rofSRV8rHMY4c5eKhxHhOB7u5HBCH9TitaPMou0tOWTfoxGB/ECUt4jlmnnYLK7oi
         nxiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=amdkUoG7lUkYVoF3GeIRSbtSXbydNKaXHbarQ4XEWNQ=;
        b=iLFi4jeuucIth7LtUsBtVSOPzUGeL7129n+I95u1LrgbCNkMldgextmOhMZ8qVK9by
         Jh5bn6/yHZI1U8RfvRMsICTG/0ZeSvDy8SfRpvUgDXNFLj4Z7nKsREsIGJwvswgxs6Hm
         O6k0zttMmJZsCyrFnbbVgMbo3pXHRH1djnYN2XrzinA9C2ZfjStjN5ItbnuWLo1ZvgOF
         4IoPcuUqcXSOyfp/UUck+aHf0JuTmOXAwsrukHuSH0+flwMpUpq4aEL/1Dx+DjRuc0nc
         hOGB4Tq/lcKtltv2SaY3cfnr7HMmJdiaxXjuo0X0WUOh2rJI+8k9w5y3PG0+2/gaAP/V
         IHCw==
X-Gm-Message-State: AO0yUKXcYfQlt1V0bc+38+CmS5J8px/VOw9s60MjoGA0j8y2hMk7N1GO
        W5I5LPU7zFbUmNyhmprU01VM4w==
X-Google-Smtp-Source: AK7set+CgjXwDr07GW722S/WwYBErb5Vj7jl/gT27dDP/Uv0W2k85OZZEfhyjvLhyKYW9K9gpxVeAA==
X-Received: by 2002:a17:906:5181:b0:878:79e6:4672 with SMTP id y1-20020a170906518100b0087879e64672mr6658337ejk.42.1675343436546;
        Thu, 02 Feb 2023 05:10:36 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id h1-20020a1709062dc100b0087bd2924e74sm10131524eji.205.2023.02.02.05.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 05:10:35 -0800 (PST)
Date:   Thu, 2 Feb 2023 14:10:34 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, andrew@lunn.ch, git@amd.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: macb: Perform zynqmp dynamic configuration only for
 SGMII interface
Message-ID: <Y9u2Skn6C0NMclWp@nanopsycho>
References: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675340779-27499-1-git-send-email-radhey.shyam.pandey@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 01:26:19PM CET, radhey.shyam.pandey@amd.com wrote:
>In zynqmp platforms where firmware supports dynamic SGMII configuration
>but has other non-SGMII ethernet devices, it fails them with no packets
>received at the RX interface.
>
>To fix this behaviour perform SGMII dynamic configuration only
>for the SGMII phy interface.
>
>Fixes: 32cee7818111 ("net: macb: Add zynqmp SGMII dynamic configuration support")
>Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@amd.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
