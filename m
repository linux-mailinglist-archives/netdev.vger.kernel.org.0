Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3CCD5F7D6B
	for <lists+netdev@lfdr.de>; Fri,  7 Oct 2022 20:32:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiJGSc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Oct 2022 14:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbiJGSc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Oct 2022 14:32:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC702CC830
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 11:32:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C354661D40
        for <netdev@vger.kernel.org>; Fri,  7 Oct 2022 18:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06BCC433D6;
        Fri,  7 Oct 2022 18:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665167540;
        bh=2BJjLACV7jP0zfdjhacw1ZeEQqeDat3s4gqrYu8HMoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Re+fcIP/B64EshfPmsoUxcTtdKxOfzn26i2tQUCvsuPdVrclh4fcYFHoL5mfJ5Him
         P579ObKCwJ1mRSYL250F2mtb0iUDdoHGTdYOGE0W+snOPOTR4ptTIbz87RU+heVRJv
         3Mg3c1llja8K89fUu/fq1OQwaMtWPsf7kce4yAxvdAoqggx8MqOxa9YmAHcQpGBrsR
         LU8vhQQXQ5abWWp96MPuc3lt8EdLsIFsmC8LfNYyTYgoL5gKf5YGje9TrCrteC/xAK
         mso19YvPHZ3Ec9/JixbIkdBO3YWWAtQmamjBoDsi/TqPmrWrhUu7wDeRydyvSZOOzF
         seJENHgdFV5Aw==
Date:   Fri, 7 Oct 2022 11:32:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>, ecree@xilinx.com,
        netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        habetsm.xilinx@gmail.com, marcelo.leitner@gmail.com
Subject: Re: [RFC PATCH net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221007113219.74aede95@kernel.org>
In-Reply-To: <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
References: <cover.1665147129.git.ecree.xilinx@gmail.com>
        <a01a9a1539c22800b2a5827cf234756f13fa6b97.1665147129.git.ecree.xilinx@gmail.com>
        <34a347be9efca63a76faf6edca6e313b257483b6.camel@sipsolutions.net>
        <1aafd0ec-5e01-9b01-61a5-48f3945c3969@gmail.com>
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

On Fri, 7 Oct 2022 14:46:46 +0100 Edward Cree wrote:
> > That "if (__extack)" check seems a bit strange, you've long crashed with
> > a NPD if it was really NULL?  
> 
> Good point, I blindly copied NL_SET_ERR_MSG without thinking.
> The check should enclose the whole body, will fix in v2.

FWIW you can prolly use break; thanks to the do {} while wrapping.
Maybe that's hacky.
