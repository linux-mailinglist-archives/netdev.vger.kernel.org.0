Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44B64F3FF2
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 23:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358721AbiDEUEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573716AbiDETuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 15:50:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6051AF29
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 12:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E690B81D6F
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBCF5C385A5;
        Tue,  5 Apr 2022 19:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649188133;
        bh=COsNySqQn+pD0lUgJj2S+mFWFLCmiIRXwvtF/xTbb3Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lGKV41YIALSeQIJvzKCVpFHyNXXFXtMkGe/o0JSP/yA7Vr6+5CwP4qd/uMhbpFIcr
         K9LudUYWptameEoddDyjimpxCdQkIs4S4b2VvjBgnPCumYdURZDOFOUhX6RXCfXQ0C
         PZWNERWUqpIQmHip8wdsFFEbW1+v9ID+I7vFXxohBiO9OZxbtXE29MxsV5wD7Zb0wm
         PJ+P/UOZkyUXm6r5GbugKIIB9tzmACNleYooVF0Paw/FkCHSAlRYYpDrupDM/uSNcn
         CL/oGQDUf2ICbnpgurCXZnA+Bd2NBZxfY99IdfoOXRQfoEUbgy0s+uhlJjWtAqJ5tZ
         eB3QXn+E7eHJg==
Date:   Tue, 5 Apr 2022 12:48:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Matej Zachar <zachar.matej@gmail.com>, netdev@vger.kernel.org
Subject: Re: [DSA] fallback PTP to master port when switch does not support
 it
Message-ID: <20220405124851.38fb977d@kernel.org>
In-Reply-To: <YktrbtbSr77bDckl@lunn.ch>
References: <25688175-1039-44C7-A57E-EB93527B1615@gmail.com>
        <YktrbtbSr77bDckl@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Apr 2022 00:04:30 +0200 Andrew Lunn wrote:
> What i don't like about your proposed fallback is that it gives the
> impression the slave ports actually support PTP, when they do not.

+1, running PTP on the master means there is a non-PTP-aware switch 
in the path, which should not be taken lightly.
