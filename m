Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 058066C3A67
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 20:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjCUT1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 15:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbjCUT1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 15:27:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC70155513;
        Tue, 21 Mar 2023 12:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 44BB3B81988;
        Tue, 21 Mar 2023 19:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903DDC433EF;
        Tue, 21 Mar 2023 19:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679426863;
        bh=C/0ab2CywZhx7j9d2jbrGBqrW9lxAO1EyXEMje7UqUI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fqkrClXGi1MHn9tU26G1yPSoMloRZHDwzLVOK1L7YS28YYpvCN2nYHEBdC5LqB8O1
         AcmqTDvTXm1FxZ/qng0aL+vs+ODQKmUAd4LWVOPzkh0Y7E9WyGAHTxT2vSHHAmPYbD
         IumY4W8EiL9fM/OvinXKz6/ABsrOKEqQep8d5yZW4xOmTZHlhydZUNi0KTQ9DflS94
         veX+h+ilO11pRSsfXB+6Qy/F4atfN5GAjnmA6Mo39e9bEHjdPLFnYKMdyhy1cBaVOQ
         +wIS2Wx69jvwzKU9xq827OrQxMuI5VPMWwMAT5dED/mhEZz5uCd61riZv80es/x7cs
         /cIZoKwo91vQw==
Date:   Tue, 21 Mar 2023 12:27:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] smsc911x: remove superfluous variable init
Message-ID: <20230321122742.7bd1165f@kernel.org>
In-Reply-To: <ZBnBZwC9WEoNK0Gp@ninjato>
References: <20230321114721.20531-1-wsa+renesas@sang-engineering.com>
        <CAMuHMdXrvdUPTs=ExXJo-WM+=A=WgyCQM_0mGKZxQOrVFePbwA@mail.gmail.com>
        <ZBnBZwC9WEoNK0Gp@ninjato>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Mar 2023 15:38:31 +0100 Wolfram Sang wrote:
> > >         struct smsc911x_data *pdata = netdev_priv(dev);
> > > -       struct phy_device *phydev = NULL;
> > > +       struct phy_device *phydev;
> > >         int ret;
> > >
> > >         phydev = phy_find_first(pdata->mii_bus);  
> > 
> > Nit: perhaps combine this assignment with the variable declaration?  
> 
> I thought about it but found this version to be easier readable.

+1 

Calling functions which need their return value error-checked as part
of the variable declaration should be against the kernel coding style
IMHO.
