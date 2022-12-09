Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844FE6482A0
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 13:56:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbiLIM4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 07:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLIM4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 07:56:16 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F2276D7C2;
        Fri,  9 Dec 2022 04:56:15 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s5so2937890edc.12;
        Fri, 09 Dec 2022 04:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7d1Hk/u5OkE2zPYqVbYpGU1t6ccVyflAO01wLSPYehQ=;
        b=nrcyWL5B1D8yzm6Claadu23KRt4dCLQtQAj73LLu7tsf+fEBzT/Lc/Ue6lS5DKTgK/
         UHc75St4Muf57R5UmYqzFRHKc0qu9UbqFN6kNVFKVCZSvfqVrs9uxUJx73P/NTxkECEa
         iUA5ZLXWXZ+YvoBwsHkMNZEvYuJ+FR7l6RBcX8Hs4t4SYgJkPsSw/+3/h/ft0VFjJOge
         hFRhvqY4Np343jaAUrpHfDA5epFToMDsrgJKomlCQrFA8jenbVrSm+6lFmA3Lm1nbQ3S
         10oMLMsCuVJjpih+mRqFx0vVPyIfygG5Y2QJxjLHP+OO0fy4lLbPUlD84m47Jpx1F/Lm
         bU7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7d1Hk/u5OkE2zPYqVbYpGU1t6ccVyflAO01wLSPYehQ=;
        b=P9M02mT7VjWHCnxSRHf2eqGaUmt+IQ5tc6FM7Oi0563t96DGrwlbZnh24/3M8w6pLv
         yI0MN0qOvehWjAGe10+UsBTekbiKsEFFb9ZeDKWt2sPH1ENwLCGsnbj9dXaFtejW1Dlx
         l5qkFpD1drvhMEQrFoUgJnQw2Rm+GZVUIpygzNApTNf+k6dypJ+yxxKftnMflhFcod3Y
         gajUQoYyLdc4phkINbVxUkshRBZxuJFWCZaEajx1JBGHxOtv146V3DRZcqN7ArFEb6X0
         DNPwGOsDmrPU6FdhQWZ9hF3xBctsgVwyRDIXZCo2laWkxo8jPvAIWLUqVTB1aEwn5dki
         lAOA==
X-Gm-Message-State: ANoB5pm2PXiH0xEXFZxkELUcvOTgm8YIRGVp4BGeSozJZjad0/BZzCcc
        ETf4vwoTCP2fTpvjXY56Riw=
X-Google-Smtp-Source: AA0mqf4B49UrOCx9aH+8tTfjnZpNxCiOB8/xSuBspW9baeEO5llmBHb6DqPi1DEiCpU1RegX2WHWng==
X-Received: by 2002:a05:6402:4006:b0:46c:d5e8:2fc9 with SMTP id d6-20020a056402400600b0046cd5e82fc9mr6363175eda.13.1670590574002;
        Fri, 09 Dec 2022 04:56:14 -0800 (PST)
Received: from skbuf ([188.27.185.190])
        by smtp.gmail.com with ESMTPSA id n13-20020a05640204cd00b004677b1b1a70sm595922edw.61.2022.12.09.04.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 04:56:13 -0800 (PST)
Date:   Fri, 9 Dec 2022 14:56:11 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Michael Walle <michael@walle.cc>, Steen.Hegelund@microchip.com,
        UNGLinuxDriver@microchip.com, daniel.machon@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        lars.povlsen@microchip.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209125611.m5cp3depjigs7452@skbuf>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
 <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 01:58:57PM +0100, Horatiu Vultur wrote:
> > Does it also work out of the box with the following patch if
> > the interface is part of a bridge or do you still have to do
> > the tc magic from above?
> 
> You will still need to enable the TCAM using the tc command to have it
> working when the interface is part of the bridge.

FWIW, with ocelot (same VCAP mechanism), PTP traps work out of the box,
no need to use tc. Same goes for ocelot-8021q, which also uses the VCAP.
I wouldn't consider forcing the user to add any tc command in order for
packet timestamping to work properly.
