Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A996D5AD6A7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238776AbiIEPd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 11:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239204AbiIEPdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 11:33:49 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B93BB
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 08:33:47 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w8so13548176lft.12
        for <netdev@vger.kernel.org>; Mon, 05 Sep 2022 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date;
        bh=bKBkoVyUETeN42TKvO0UXkEqxyAyQzetgm6IB8+z4uc=;
        b=K0TDh8/FM3CFk/F3Js+5X99Ns/tZGOhcEfUDEB2X6AdN4029tTIyDhr4b9JtdVaRKN
         Al+ZonLymKSJAgq7f3Lwp4FcwJJxJqjCpy4yYck126sO0qnUzheKEnhC5FK+UItFRG0s
         mLAg8yVg1sONvaUKReL0CTMrac3qEEmx8O2m4bORFVRyyKg7g6vLQnGiSxZv5KT3PdWc
         lFy5Dh3zvcSOpBEMxFvCaTz0uXQ7clkAod8Kjb6ORCJhKF5gvi9gVUsL2SMDRlRkoG9t
         ZWYLMG0NLquXFReoY9eLodgx3ZfN3V3b3CaZWRjlEA6+13oTKKgIiZ/c/qCevcqxykNE
         GLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=bKBkoVyUETeN42TKvO0UXkEqxyAyQzetgm6IB8+z4uc=;
        b=EOZNJEaqahvzvUyJgGK/dsEl/FeX1M65nUQhuWLug2p/fUB0TUxJ9fgBq6TpYw+pxH
         e24lnL7sP8E1sB+/wLJpOISMr0Qz2vuwYUSTJ0JpBe4KwaT2XmVV1EGMHba/Ux0zVBLu
         E/l/V25ERl084o22GCc+bi6b48bDn77ztdc9tfwX08PludN3S8xCrLydNXdn20EPNgWR
         et40MzOgYDKREfoJspcfZeBJjZppMdxbeo6Iiff8LCue9KlJvoUM7A1dLpdNxHL+1frY
         PiuLRAD+sLoQH/RUKJzYaaJgfCcWbQepEG2EpPfgOER54ryQXCeXdDEsXZurCnT/CwjC
         wHxw==
X-Gm-Message-State: ACgBeo1cRQNPHrJlmnTcFcimfis0iXrcGIfZScL9W8vLtNud4qaxBIbC
        1t/wTJL+Ts6vxleyyrRxFC4=
X-Google-Smtp-Source: AA6agR5P2g1DBoosSUQe+SbwxYdvGrTpSnFP/zYLXeOOdDuGySjwUGbZWuw5aGKMey3jEibDdzx0nA==
X-Received: by 2002:a05:6512:15aa:b0:494:7a2a:cc1f with SMTP id bp42-20020a05651215aa00b004947a2acc1fmr10624560lfb.36.1662392026197;
        Mon, 05 Sep 2022 08:33:46 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id u8-20020a2eb808000000b002647530f3b6sm1435611ljo.137.2022.09.05.08.33.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 08:33:45 -0700 (PDT)
Date:   Mon, 5 Sep 2022 17:33:44 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH net-next] net: sparx5: fix return values to correctly use
 bool
Message-ID: <20220905152855.ud6a7cqbygoyvnfj@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20220902084521.3466638-1-casper.casan@gmail.com>
 <YxIyRDzQt5cN7Lbn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxIyRDzQt5cN7Lbn@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2022-09-02 18:41, Andrew Lunn wrote:
> On Fri, Sep 02, 2022 at 10:45:21AM +0200, Casper Andersson wrote:
> > Function was declared to return bool, but used error return strategy (0
> > for success, else error). Now correctly uses bool to indicate whether
> > the entry was found or not.
> 
> I think it would be better to actually return an int. < 0 error, 0 =
> not foumd > 1 found. You can then return ETIMEDOUT etc.
> 
>     Andrew

I can submit a new version with this. But since the commit title will be
different I assume I should make it a new patch and not a v2.

Best Regards,
Casper
