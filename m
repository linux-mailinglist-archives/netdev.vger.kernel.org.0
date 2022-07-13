Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D05A057368D
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 14:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiGMMrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 08:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiGMMrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 08:47:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C98224
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 05:47:17 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id va17so19719733ejb.0
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 05:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JwiMhTcevgD+CvXE9Gzcb1dVKW10hQnsn4lZ+Kk1iCQ=;
        b=XEax3N5D+DcPoyRb+/EmlufqZNwc+r4b8e8XMHflWBx/aj/KT+7fI3p4glCEeCahuN
         SibKDfHueQOZSo5geiqvs8FGgPxCFDZe/3qimPVKjtMeQ8i3L65xMYkRyw2yza8MyIdz
         m2Q/JFu2SFP2BC+k3g/bfGFHrWYkUaGsITfliVXK1R+vhnCtAgGKTlaKL/wTx4Bl+GjX
         0xQXfsSqMa78RzRGmHdrVOF2cbfR3RHtABm0bk/CEUSmguIyOxARdioDES7AzAwwylFk
         vlmcSlK/u2832yEbPzzAh+BAZAD3+ktquhN8H3d6JNEQbAd2p1VW+N9se78QOC9VCeQz
         wHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=JwiMhTcevgD+CvXE9Gzcb1dVKW10hQnsn4lZ+Kk1iCQ=;
        b=lK/aQjWlDKNuECfj6mk873cjpSbbarAETLXfCTU2uu0UheBJSg5CK4yMlRXvpGa3t2
         dKy92iTSio4Z33eLghSCzaoAzb4mS0yvykCVW1XVwjEw7zLB7LPbVY/Hcm/2SE0aP1PC
         VU7puzk9qwnh1bV1EaRBCdXcVD6hjalz2x4Iv7qWr8zz9l6bg7Dk3IWsmpZwZ21LeU6I
         90KmPYEn/gZ0bTc05meyDiaxsflwZOP0ZdsFToj0JAYH7RHp0uv15R41Qo8WM3D9pYky
         75ctNIu4yH7Z+PNGZ/WAF+vY+JRLbrziAdhvqVhic4W+trYi3KqaNsP9zHq3TTnFKKuz
         idAg==
X-Gm-Message-State: AJIora/CkR9lmAUgASmRMiKDRHWvnRWU0lVokJWYIj/3U6LFSXGrWgOm
        e4E59n+A1EPaGhzpbnoyHzQ=
X-Google-Smtp-Source: AGRyM1uHw4m0X+np3ueRO4fsVlK/Tb2GQQE8JgHsgkyU2omIaZm4TReIQ+EUPeLOiD0RXCcj9L3Zog==
X-Received: by 2002:a17:907:7f1c:b0:72b:6e63:1798 with SMTP id qf28-20020a1709077f1c00b0072b6e631798mr3216225ejc.538.1657716436038;
        Wed, 13 Jul 2022 05:47:16 -0700 (PDT)
Received: from debian ([89.238.191.199])
        by smtp.gmail.com with ESMTPSA id 7-20020a170906310700b0072aa009aa68sm4910617ejx.36.2022.07.13.05.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 05:47:15 -0700 (PDT)
Date:   Wed, 13 Jul 2022 14:45:11 +0200
From:   Richard Gobert <richardbgobert@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: Fix IP_UNICAST_IF option behavior for connected
 sockets
Message-ID: <20220713124435.GA51741@debian>
References: <20220627085219.GA9597@debian>
 <7be18dc0-4d2c-283d-eedb-123ab99197d3@kernel.org>
 <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77c9a31ba08bcc472617c08c0542cd82f7959a58.camel@redhat.com>
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

On Wed, Jul 06, 2022 at 06:21:05PM +0200, Paolo Abeni wrote:
> I think your reasoning is correct, and I'm now ok with the patch. Jakub
> noted it does not apply cleanly, so a repost will be needed.
> Additionally it would be great to include some self-tests.

Will include self-tests and submit V2.
The patch applies cleanly in my local setup. Do you have an idea as to why
this might happen? I missed the email where Jakub mentioned this.

Thanks,
Richard
