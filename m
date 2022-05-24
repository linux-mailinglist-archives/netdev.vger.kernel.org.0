Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BCEA533006
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 20:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240125AbiEXSEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 14:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238078AbiEXSE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 14:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60013206E
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 11:04:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FC0261538
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 18:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4528EC34115;
        Tue, 24 May 2022 18:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653415467;
        bh=476LS2xNftpyzU5owUqOU0LfUzm9lKLiSllqJ72ZA14=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jdT1IRAXif28R7b53X+d0z7QJl+CHmnJaD5aF0DbzViKT8DxOowqCmrzRJBb1y61j
         8Uoo7XSVJ+r2J7Y6Hjd6HcwOKrOqD2OZ9VNW35qRiNpv3fNXx5h+H+ldePGG6sDH2H
         c6lhZTq60jWxLmDTEl7T9g1j2DAFKjqHAYtl2+xpbCbKC2mwCPo/21+iRdH75PBFXa
         C+V7LFu0IXpAlN9t8jpy5a43XkGdrhKf2jvN3W6hXPW6TmpmcDwneTQANu7jcZVjmp
         M7EmmoEyWe/n4nzBV0w29esWbLGi5nf+9U9nOMCQiDpHGvf9p2JEc+Ofd1EhkWdxfF
         t6acN3lQ5VFxw==
Date:   Tue, 24 May 2022 11:04:26 -0700
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
Message-ID: <20220524110426.5f339585@kernel.org>
In-Reply-To: <b9cc320f-12b1-7460-5591-4ddc8b7f417f@linux.intel.com>
References: <20220519182703.27056-1-moises.veleta@linux.intel.com>
        <20220520103711.5f7f5b45@kernel.org>
        <34c7de82-e680-1c61-3696-eb7929626b51@linux.intel.com>
        <20220520104814.091709cd@kernel.org>
        <09ce56a3-3624-13f9-6065-1367db5b8a6a@linux.intel.com>
        <20220520111541.30c96965@kernel.org>
        <dc07d0a9-793b-5b76-cf10-d8fad77c04ea@linux.intel.com>
        <20220520144630.56841d21@kernel.org>
        <96352703-17b1-bc0b-2a54-e9651bf21b55@linux.intel.com>
        <b9cc320f-12b1-7460-5591-4ddc8b7f417f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 22:11:00 -0700 moises.veleta wrote:
> Is the issue with using the debugfs to send random data to the modem an 
> issue with validation?
> If so, what if the modem itself is validating the input string would 
> that suffice to allow this debugfs control port to act as the medium 
> between user space applications and the modem? Leaving the driver blind 
> to that process.
> Or is it preferable to have the driver do the validation on the user 
> space input to the modem?

Yes, the driver is not supposed to be blind to the process.
