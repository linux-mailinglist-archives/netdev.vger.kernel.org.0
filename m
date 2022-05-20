Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95C452F267
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352531AbiETSQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352570AbiETSPs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:15:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77D0E59
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:15:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 838DDB82A5D
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 18:15:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB574C34100;
        Fri, 20 May 2022 18:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653070543;
        bh=fFw54NZmAVQarWbYOAymLd90htSYlu58P4fIJWqebcY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cZN0opRaIoNevVeaMOFd5080AicEant0kB0vmR2OiLr+GzK6Uopm+l0/7PpuNRy7u
         NBsZGvqIgt20WBIl4M/KQMwWKLV+sSxOt8K/w5HnEHp9OCanzStHpuSkLRXx3LPyej
         +Eg3nRsxFRG8y5MuidYAHUNsXxZjS19FbDQ1sQfnD1O4ufyBsAks4ggy4T0yn1avVQ
         7WKLorVBdWA33+jEXGnB5DCZT47cR19ntzrnO88yVIE3YsrK8MKhhIgRtFcDRaI1s8
         IhU4F2+H70jgPau6ahZFeHGftYRFVQjiMoyZypS/GBZX+xfs+bybJea+6YMfKhmK52
         Ma/IdCZROMQUg==
Date:   Fri, 20 May 2022 11:15:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "moises.veleta" <moises.veleta@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, m.chetan.kumar@intel.com,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        haijun.liu@mediatek.com, andriy.shevchenko@linux.intel.com,
        ilpo.jarvinen@linux.intel.com, ricardo.martinez@linux.intel.com,
        sreehari.kancharla@intel.com, dinesh.sharma@intel.com
Subject: Re: [PATCH net-next 1/1] net: wwan: t7xx: Add port for modem
 logging
Message-ID: <20220520111541.30c96965@kernel.org>
In-Reply-To: <09ce56a3-3624-13f9-6065-1367db5b8a6a@linux.intel.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
        <20220520103711.5f7f5b45@kernel.org>
        <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
        <20220520104814.091709cd@kernel.org>
        <09ce56a3-3624-13f9-6065-1367db5b8a6a@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 11:01:31 -0700 moises.veleta wrote:
> On 5/20/22 10:48, Jakub Kicinski wrote:
> > On Fri, 20 May 2022 10:42:56 -0700 moises.veleta wrote:  
> >> Can we use debugfs to send an "on" or "off" commands, wherein the driver
> >> then sends special command sequences to the the firmware triggering the
> >> modem logging on and off?  
> > On/off for all logging or for particular types of messages?
> > If it's for all logging can't the act of opening the debugfs
> > file be used as on "on" signal and closing as "off"?
> >
> > Where do the logging messages go?  
> 
> It would be "on/off" for all logging.
> Yes, opening the debugfs file can be used for "on" and closing for "off" 
> without needing to use copy_from_user.

Sounds good. Can we also divert the actual logs so that they can be
read out of that debugfs file? That'd feel most natural to me..

> Logging messages would go to the relay interface file for consumption by 
> a user application.

What's the relay interface? a special netdev? chardev? tty?

