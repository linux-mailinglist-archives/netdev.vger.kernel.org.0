Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16B546050F8
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 22:05:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbiJSUFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 16:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiJSUFs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 16:05:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F5618BE0F
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 13:05:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 477F7619AC
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 20:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8F1C433D6;
        Wed, 19 Oct 2022 20:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666209943;
        bh=eUJMv7fnTzYOk95G780BJAyyUPBRtC5XCITmLvYem0M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ja7uiFdTNE6Zsh0GDXSJ5Ul65zxleyb5hPbP7QCZIV28EsdMCH5C/2dRBnwmtn5Fj
         KdFLIPaIeQUrPzZwQ+xvPTQmej/eZItU4QvKesOu/+FH4zTKL/Vcs5NEHoEXslB2wG
         ss0z1ezoPAr3eUV3msHMxmAybh1kX1UQxTJ9iZBNcJowUfcZhSDRPusUbQuc9y2FG9
         /rcKp1va1uI6MDplOJzCcECKuIZd/wntepBMy50nyQnyxL/uw8p0QKM8hGQ9qH2ZF9
         W6+rTlxd7hAx/kPv9lD3tuUEY2d0EnceDo6NcdDfbknhWrUMs5uUjmjTXlQAazYF7K
         v0ocV19tk3vNg==
Date:   Wed, 19 Oct 2022 13:05:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, <johannes@sipsolutions.net>,
        <marcelo.leitner@gmail.com>, <jiri@resnulli.us>,
        Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v3 net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221019130542.3879a64c@kernel.org>
In-Reply-To: <f6cdbbf29de087257201abd06ddaff0593236106.1666102698.git.ecree.xilinx@gmail.com>
References: <cover.1666102698.git.ecree.xilinx@gmail.com>
        <f6cdbbf29de087257201abd06ddaff0593236106.1666102698.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Oct 2022 15:37:27 +0100 edward.cree@amd.com wrote:
> Include an 80-byte buffer in struct netlink_ext_ack that can be used
>  for scnprintf()ed messages.  This does mean that the resulting string
>  can't be enumerated, translated etc. in the way NL_SET_ERR_MSG() was
>  designed to allow.

I only read the code not the message yesterday, but FWIW I think 
the translation problem is surmountable within the format string 
itself. But let's worry about that if someone actually comes forward
and wants to work on the translations :/
