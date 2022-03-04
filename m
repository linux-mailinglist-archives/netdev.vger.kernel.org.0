Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8594CD824
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 16:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240322AbiCDPnc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 10:43:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233917AbiCDPnb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 10:43:31 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED04924088;
        Fri,  4 Mar 2022 07:42:43 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id gj15-20020a17090b108f00b001bef86c67c1so8156049pjb.3;
        Fri, 04 Mar 2022 07:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YgucM+pyBKX8gfpYonvUJSz0KwBP+cTn6q7it4dMeJw=;
        b=BQLDSB2P5WBjDBnJWqSX/5NWZ0uUXnd5kwq62qhSOIkTDR8ph9lnqQlO3kjiKynaHM
         mMHxXPaJHEaApjW4Wqngbn1zlGFUm9jMwZkk/qg6wVU7CUe1B14fpZxAqeEC7OX0Ag3g
         Z+EJsM48zpNVSpZMS36o8jDMTQShQEnOqX3j3+v8QkpGNVOz4kXoK/ScmhabZF5sJKyu
         ekwRmXoZ4pAneh9ujEfdwfbg4jP3YBKF67nkDr7gsAHoIlRWf+OiKB4276cnHLanH+HL
         uSFHPtEWYAJqhQ+3rmO48AASvZAMEyPP/4vFrX4tY2D3pLf2q5C81XUdi9goFeTz8EaM
         NHtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YgucM+pyBKX8gfpYonvUJSz0KwBP+cTn6q7it4dMeJw=;
        b=sUrx4nsHO6Guz2OR8wO9BNQQpW8FXphX1naJFMTpphBuIFeQQ0xKYZb877HMHtSqq+
         LDm1EMtlQyd+9LjlZjrBlwUhledAY2vXfKoYH39PPyP8L9OabNWTNcmL6X2xzIpjuaKT
         49InDmOlxPxabPbMpVnvGrcjkEV6My7awevWH7Hu1svl0x/LsT7pJPRCfdUWI+goweqp
         1Udel358tr4+eaujdOzPTUCFKs3alqq/cpmcxtX8SmOjwTlCzQn17mHeEFax40iBLfAN
         4P7/01E6xDDDNsiapVc3P3jLHJFm7vsvHwVP5cggSwjLUMBzRrW4njviY15Jy6N2QZiV
         Z4rA==
X-Gm-Message-State: AOAM533OSLXKQe6jC8O9WqubydalckhvDwYOx1Ah1k6Fg1LqXqQnsMn8
        IKk/BmTCwVmwL9X62mwuhZcFvkTqiU0=
X-Google-Smtp-Source: ABdhPJyejU5rfz127LXWtET01fbm7lJIft9hDGfGYPcKay7D8wXRpNXedntDeQ6KNyv5TZZWAZlzDg==
X-Received: by 2002:a17:902:7086:b0:14f:ee29:5ef0 with SMTP id z6-20020a170902708600b0014fee295ef0mr41307036plk.142.1646408563050;
        Fri, 04 Mar 2022 07:42:43 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id nk11-20020a17090b194b00b001beed2f1046sm8739014pjb.28.2022.03.04.07.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 07:42:42 -0800 (PST)
Date:   Fri, 4 Mar 2022 07:42:39 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, kuba@kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, madhuri.sripada@microchip.com,
        manohar.puri@microchip.com
Subject: Re: [PATCH net-next 0/3] Add support for 1588 in LAN8814
Message-ID: <20220304154239.GA13902@hoboy.vegasvil.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <164639821168.27302.1826304809342359025.git-patchwork-notify@kernel.org>
 <YiIO7lAMCkHhd11L@lunn.ch>
 <20220304.132121.856864783082151547.davem@davemloft.net>
 <20220304140628.GF16032@hoboy.vegasvil.org>
 <YiIfb821yzXf7YqY@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiIfb821yzXf7YqY@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 03:17:19PM +0100, Andrew Lunn wrote:

> My perception is that you also like to sleep at nights, and cannot
> keep up with David rapid pace. So setting up your own tree, collecting
> reviews and acks yourself will help you and the quality of the PTP
> code. So yes, go for it.  I just think it is wrong you have to do
> this.

I agree that PTP drivers are being merged too quickly without enough
review, and my commitment to maintaining a PTP tree will both allow
better review and reduce davem's burden.

So maybe it is right for me to do this after all.

Thanks,
Richard




