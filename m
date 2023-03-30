Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406FF6CF930
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 04:38:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjC3Cie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 22:38:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjC3Cie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 22:38:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958B34ECF
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 19:38:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 302B361EC0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 02:38:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45709C433EF;
        Thu, 30 Mar 2023 02:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680143912;
        bh=G1JC8mpr0TOdYTe/0EuN1FUDspQzRH9HnWXXr2HrOaE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KIqHXgcdoZFcvfnXtie2uIoMUPvDou6sTSQQ220v1YARmGDiFGiZygzfgIhEFyIAk
         ldE/A8rtRFJy0kb6U3zPsBqor91Ix5RXryklK84dajzpyzjp03awmDia97Nw1gbEYC
         xkCHx1WC8H4kzO7wVTbrXQG/jHK00NyTWgvL+k7g53iaOrREqowtAAGIHwcGTkVMz6
         ADB5FjoeLi49usYevs7J9lgmXPmK/4a0pxkf4yKngrotPSoZQKKuXQiY+LkIlak3kN
         qKLiOLw4wZuNN83KMUnI9Zs0b9UUml7nAYzlNtyfuVoLbUqJtaqGSoV97cIez+yy+g
         cD/aZj2R3kLiQ==
Date:   Wed, 29 Mar 2023 19:38:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yinjun Zhang <yinjun.zhang@corigine.com>
Cc:     Louis Peens <louis.peens@corigine.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>
Subject: Re: [PATCH net-next 1/2] nfp: initialize netdev's dev_port with
 correct id
Message-ID: <20230329193831.2eb48e3c@kernel.org>
In-Reply-To: <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
References: <20230329144548.66708-1-louis.peens@corigine.com>
        <20230329144548.66708-2-louis.peens@corigine.com>
        <20230329122227.1d662169@kernel.org>
        <DM6PR13MB3705D6F71A159185171319E3FC8E9@DM6PR13MB3705.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 01:40:30 +0000 Yinjun Zhang wrote:
> On Wed, 29 Mar 2023 12:22:27 -0700, Jakub Kicinski wrote:
> > On Wed, 29 Mar 2023 16:45:47 +0200 Louis Peens wrote:  
> > > In some customized scenario, `dev_port` is used to rename netdev
> > > instead of `phys_port_name`, which requires to initialize it
> > > correctly to get expected netdev name.  
> > 
> > What do you mean by "which requires to initialize it correctly to get
> > expected netdev name." ?  
> 
> I mean it cannot be renamed by udev rules as expected if `dev_port`
> is not correctly initialized, because the second port doesn't match
> 'ATTR{dev_port}=="1"'.

Yes, but phys_port_name is still there, and can be used, right?
So why add another attr?
