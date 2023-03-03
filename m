Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94FB6A9DC1
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 18:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbjCCRcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 12:32:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230228AbjCCRcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 12:32:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4C3E8
        for <netdev@vger.kernel.org>; Fri,  3 Mar 2023 09:32:52 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso6857385pjr.5
        for <netdev@vger.kernel.org>; Fri, 03 Mar 2023 09:32:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677864772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UIyBJEio9TpOtZtepkPZ9bgnJeq9AcTeG3hlFo5N1dc=;
        b=S6HTin3l9KQQI5C0WsyUs2LwKwomyh176y9RzW0oP8RrYyiEKj2g9PuK75u1BGuVy4
         h5IVrNDC2vjGh/nFWRM6Ocr0uNp61URDRGGkm1Sw6BH970oeTCAHNViHXNLQQUaakxUg
         QRrx/lwnP8W3ZX5gI+i2/j3x5v0T4TrvZaS+1O1otR5u2F+SMhN92b6ulbx9ePMfUa5a
         XqGKV2qsBkj9rdm4/oVYKHifUg9xJaLJyQjK1zyBwZEZrnxhOQ4PgrAMAV5k3/PkukR/
         qCd3/1woPUavg+p09ub05Ila+9mnoNPvUURk73wT4fs1zUd8nRENCp3MuVlRfM7Xsxlk
         LeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677864772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIyBJEio9TpOtZtepkPZ9bgnJeq9AcTeG3hlFo5N1dc=;
        b=WYPttqNUBnS4cLvA2ASJBXgrk3+d7idms1e4955LC+zSC4UGXeMycf/O9eldQvJPwC
         NBWBXqVbs/IVfdDWKZaIIoh/Y57262M8+SIoI65ndoICY292DZASnfal0LHiAZ//Hj3l
         yjr5FkF2/OzSVBh7nsvYqkYtGefuXMaL3mhcMeJnybHpTq+vl5P2Rgda/vlBs5IgjSfj
         6jokCFq35jegmSj0jEXnw/g6hHc4fTVy+zmvCwJVbJuriNc8wkrwTDjD2LcTSpafle9k
         fbhQE3ykVmV6b13gZey/qvrEw6vz9jGoviH4aAxvBGdXP2kaXdsOAJaNqvSECKuuggx2
         n9cQ==
X-Gm-Message-State: AO0yUKV9jOL0yNOV5XRHzzQOu5kDnJmQ633MEy/gghQg6+3HUj9PwLUQ
        Wcwfhu6hhfjbNEx3hlBLrzOB/qgUM5M=
X-Google-Smtp-Source: AK7set80ImkuBRn64GvXJe3d3GjeSewsc7yLnbu46RTyo0pLoKxLeHHj89W4f6oMulW3SQTnK2eYOQ==
X-Received: by 2002:a05:6a20:6906:b0:cd:2c0a:6ec0 with SMTP id q6-20020a056a20690600b000cd2c0a6ec0mr2664170pzj.3.1677864771917;
        Fri, 03 Mar 2023 09:32:51 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id c16-20020a62e810000000b0056bc5ad4862sm1926579pfi.28.2023.03.03.09.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 09:32:51 -0800 (PST)
Date:   Fri, 3 Mar 2023 09:32:49 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Michael Walle <michael@walle.cc>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        kory.maincent@bootlin.com, kuba@kernel.org,
        maxime.chevallier@bootlin.com, netdev@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
 [multicast/DSA issues]
Message-ID: <ZAIvQVm9TAOAjrXo@hoboy.vegasvil.org>
References: <ZADcSwvmwt8jYxWD@shell.armlinux.org.uk>
 <20230303102005.442331-1-michael@walle.cc>
 <ZAH0FIrZL9Wf4gvp@lunn.ch>
 <ZAH+F6GCCXfzeR+6@shell.armlinux.org.uk>
 <0c0df176-1fbb-43d5-9fb0-358b3873f4e0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c0df176-1fbb-43d5-9fb0-358b3873f4e0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 05:34:35PM +0100, Andrew Lunn wrote:
> > > 4) Some solution to the default choice if there is no DT property.
> > 
> > I thought (4) was what we have been discussing... but the problem
> > seems to be that folk want to drill down into the fine detail about
> > whether PHY or MAC timestamping is better than the other.
> > 
> > As I've already stated, I doubt DT maintainers will wear having a
> > DT property for this, on the grounds that it's very much a software
> > control rather than a hardware description.
> 
> We can argue it is describing the hardware. In that hardware blob X
> has a better implementation of PTP than hardware blob Y. That could be
> because of the basic features of the blob, like resolution, adjustable
> clocks, or board specific features, like temperature compensated
> crystals, etc.

IMO a DTS property is the most user friendly solution, even if it
isn't strictly hardware description.

Thanks,
Richard
