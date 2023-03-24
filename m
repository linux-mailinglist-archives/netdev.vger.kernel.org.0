Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5696C8338
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:20:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbjCXRUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbjCXRUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:20:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84965E075;
        Fri, 24 Mar 2023 10:20:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A92CB825B5;
        Fri, 24 Mar 2023 17:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7312CC433EF;
        Fri, 24 Mar 2023 17:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679678439;
        bh=r3PzR5IITn8iM3hReDFwFchJAFCpyZocVJYzF2d+kNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h4wpnfBdtKvrDki7BZnHTobGMgqrJbTi6joX0wBsf0UDB0FzTJljw6noFhaojjcEm
         eM8YylHPsJFUnGuuOquK2AV4617aGUkdwfrG4GTNtxv1QRlIvoUaJi0x/y+I9kE0BX
         OC7rTljvKmoJFjt0q2uo8125DR88onQ1Ga+EM4icOaKKEPhQabB02TLk4f7erefPAj
         LF02bOC2hw159GLt3Ts7AF/LrYL4+rk0rnVd2/DiiplBNIDn3wIp5R7ht/Rawu6Be6
         yHZ+A5pBHPgrIOSZ4f7ZmfIPEJuU4AQzMUFj2HDLIOKM+5jYFgsQ0Ym+vcnLJ9w5NX
         V5LBfHoYoq94Q==
Date:   Fri, 24 Mar 2023 10:20:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net/core: add optional threading for backlog
 processing
Message-ID: <20230324102038.7d91355c@kernel.org>
In-Reply-To: <20230324171314.73537-1-nbd@nbd.name>
References: <20230324171314.73537-1-nbd@nbd.name>
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

On Fri, 24 Mar 2023 18:13:14 +0100 Felix Fietkau wrote:
> When dealing with few flows or an imbalance on CPU utilization, static RPS
> CPU assignment can be too inflexible. Add support for enabling threaded NAPI
> for backlog processing in order to allow the scheduler to better balance
> processing. This helps better spread the load across idle CPUs.

Can you explain the use case a little bit more?
