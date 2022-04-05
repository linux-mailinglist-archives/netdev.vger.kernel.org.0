Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6BD44F45CA
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233317AbiDET60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 15:58:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457452AbiDEQDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:03:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A4D83B1A;
        Tue,  5 Apr 2022 08:46:09 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ot30so17621337ejb.12;
        Tue, 05 Apr 2022 08:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7kpsGMmBzpfBM9jAlxaQhQ6QOVa8yPc2XChn38jewUY=;
        b=I5g0SlH/NucKf4U+Po0XGGhkZOjwxqIjt9E4hxyBJg0pvtGoLR0KIdFJrb0oGRicdZ
         OM1/ePde9Gbn5UEx1Ws+Qdpe7nfnQ0YdTPVjI6Swb8DHXaWdV/xcnjQ1QkqaazJ04+gL
         vsDF96pQWUkp2OvuQuGRSC+dGesVGoohUMm7bBMoC6weHrUz9+3atn5QsuEKe0wqz9IK
         AnGeYH/RgmF+ttX06xfQ9O70V76DJfDJD2t5UreZm3Gs8mipmWLqiVzrkFLJVGSA6Tc8
         Joi29ALUmcai5dyjkgJe00qXX8QJnutTDM1yJZMXK0KGOoI8w0jyum7lN8b7C1SQQNDr
         Sn3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7kpsGMmBzpfBM9jAlxaQhQ6QOVa8yPc2XChn38jewUY=;
        b=7dyJ1gtJD5llitJc/rjMBicpuy5vMMJJhyyNPuBt9xfzWsvm2d8mXw0kYffRTs7Sec
         CDEnXQTb0vtAGa7ANZBW/ktoWut0QY3TlkGfshuIZMw3gn9VhOz8BJANOJzUcwiaWPP6
         L6yA0exQORllghHXV6zz7rTDKyb+ovnhhQQZy8zXGvGTohhvXdkQAkubN+EKkEjoqtvY
         yeqKsgYDMbF9S9sFqceBTvomKxb2Ilz3u864DBKzTQnSV/Lk6TsSlzW0/H/vjH32l27b
         jnVCTmzN4p7zbEV69pXIrCNzXy8bSSM01/J0PCzXmcTOxv9J9oTyyAMufFcvjD6yy0gb
         n2Ag==
X-Gm-Message-State: AOAM531ubsh0dpYRgCInYeXtTei435OaZKhNIJGckAZPrwXwKy1wmsT3
        sIw31ARo5nsqPS//a7YKpbRPbGbuCLc=
X-Google-Smtp-Source: ABdhPJyEkIwTEUwce8H9FP20psOugoXTbBXDIbSo+wHBBaa2NYCuFO8E8gtxoJdmK5qt2Ye4zfh4JA==
X-Received: by 2002:a17:907:6d8b:b0:6e7:5610:d355 with SMTP id sb11-20020a1709076d8b00b006e75610d355mr4089958ejc.369.1649173567528;
        Tue, 05 Apr 2022 08:46:07 -0700 (PDT)
Received: from hoboy.vegasvil.org (81-223-89-254.static.upcbusiness.at. [81.223.89.254])
        by smtp.gmail.com with ESMTPSA id f26-20020a170906825a00b006e7efc52be8sm2649201ejx.166.2022.04.05.08.46.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 08:46:06 -0700 (PDT)
Date:   Tue, 5 Apr 2022 08:46:04 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        grygorii.strashko@ti.com, kuba@kernel.org, kurt@linutronix.de,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        mlichvar@redhat.com, netdev@vger.kernel.org,
        qiangqing.zhang@nxp.com, vladimir.oltean@nxp.com,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Message-ID: <20220405154604.GA6509@hoboy.vegasvil.org>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc>
 <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc>
 <20220405055954.GB91955@hoboy.vegasvil.org>
 <d38744cbe67474b3c83b84547ec3cb4f@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d38744cbe67474b3c83b84547ec3cb4f@walle.cc>
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

On Tue, Apr 05, 2022 at 10:48:21AM +0200, Michael Walle wrote:
> Can the ethernet driver select the default one? So any current
> driver which has "if phy_has_hwtstamp() forward_ioctl;" can set
> it to PHY while newer drivers can (or should actually) leave it as
> MAC.

I want to remove all of the phy_has_ stuff from MAC drivers.
MAC/PHY drivers should just implement the in-kernel interfaces.
IMO that is the clean way forward.

Thanks,
Richard
