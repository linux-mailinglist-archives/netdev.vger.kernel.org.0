Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1AAF4C422A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239467AbiBYKT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 05:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239407AbiBYKTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 05:19:02 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CE01AF8CA
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:18:30 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h15so6699163edv.7
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 02:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=79Mi6jhlvYgXW7b8jpU+kYQwFYW+Q0WEL0kPj/siyUE=;
        b=ms9VQkfXWZS/iUC39jJ6ELQcSZYAI5a+/Hhx280glgDKTBdppemNgbSHwlJ/amAWc9
         vDuGxiALBV+343V8XCL7MF4EK+WPuwh5MjMQcyV/hM30WHKZK+A6EiydNvn3eW+eX4b2
         3OdYJh7Z4iR+wUl8ifLoM/W/GQBz6hKYRffV6FdDBZgfMaff0EzvHv5eJwrCfbVZwQ2n
         zDztw25KnmNJV9BhwmkJZP4aLKMrsYMWKD70yWLqrsHQp705hlz5BEV9Rst57CWXQA1H
         y1apMe8szfwGjKNuzH7lfTvtgoThJ634SGDd9khHAupUspqLSsr3j0P+d2mm0V3xVEkQ
         0lXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=79Mi6jhlvYgXW7b8jpU+kYQwFYW+Q0WEL0kPj/siyUE=;
        b=YdVYbomqjQ9DSqZhUDJr7mmhfRgtDE7k9jVx6cxs5vl7iK67/4POeOCIi2xWwuZEXA
         iYOiQwkAhPJebwTvoenSo4zzzXf4JTnfffAlKHRTCoK1RhqmKBxoG5Y8/vWqmQaZ2IcQ
         TXxDR6du3X7+4D5n0gXxeHUuJgORMpDErDyljboob+VXJV9LO1oJp5Z349MEfnHwB+rK
         7DpxV6DLvF4BbuUoECOIYTqBvxSIbHaVb3VDsrT4cABrLyLiu9NzRtT56xn450TI9KbZ
         AA8qw5Hpfm94TMbDHSrmTseYY1DASLOJZvEgmwDPuM0qsBUkSLfr6/lfzl59b5lEybor
         FTWw==
X-Gm-Message-State: AOAM531Ocp6qnhtVtnNrEoaa70Q54hiLtAAs3tROBRU5ACj7mCIE9LHs
        dol0piqAkKlSWqxLzghn87w=
X-Google-Smtp-Source: ABdhPJwbjAAI1U8FEJjXSwTc9G3oHpwKLRQI+jm5RuKgjHLvTPaDNtWP/SphMEVUTNOibCYiUKajUA==
X-Received: by 2002:a05:6402:742:b0:410:a427:3634 with SMTP id p2-20020a056402074200b00410a4273634mr6470036edy.304.1645784308495;
        Fri, 25 Feb 2022 02:18:28 -0800 (PST)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id rl3-20020a170907216300b006cee1186ce9sm842143ejb.5.2022.02.25.02.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Feb 2022 02:18:27 -0800 (PST)
Date:   Fri, 25 Feb 2022 12:18:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Marek Beh__n <kabel@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/6] net: dsa: sja1105: populate
 supported_interfaces
Message-ID: <20220225101826.kyxazqamaajyzmln@skbuf>
References: <YhevAJyU87bfCzfs@shell.armlinux.org.uk>
 <E1nNGlv-00AOid-Vd@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1nNGlv-00AOid-Vd@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 04:15:15PM +0000, Russell King (Oracle) wrote:
> Populate the supported interfaces bitmap for the SJA1105 DSA switch.
> 
> This switch only supports a static model of configuration, so we
> restrict the interface modes to the configured setting.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
