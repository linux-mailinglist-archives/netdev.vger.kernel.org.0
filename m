Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACBF640975
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 16:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233520AbiLBPcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 10:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiLBPce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 10:32:34 -0500
X-Greylist: delayed 73935 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Dec 2022 07:32:31 PST
Received: from mail.enpas.org (zhong.enpas.org [IPv6:2a03:4000:2:537::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72C00DB0D4;
        Fri,  2 Dec 2022 07:32:31 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by mail.enpas.org (Postfix) with ESMTPSA id 8ED11FF9B7;
        Fri,  2 Dec 2022 15:32:23 +0000 (UTC)
Date:   Sat, 3 Dec 2022 00:32:11 +0900
From:   Max Staudt <max@enpas.org>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        dario.binacchi@amarulasolutions.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Palethorpe <richard.palethorpe@suse.com>,
        Petr Vorel <petr.vorel@suse.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] can: slcan: fix freed work crash
Message-ID: <20221203003211.4c6a63b9.max@enpas.org>
In-Reply-To: <20221202152701.ewnillsqded7uby4@pengutronix.de>
References: <20221201073426.17328-1-jirislaby@kernel.org>
        <20221202152701.ewnillsqded7uby4@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the crash, but is IMHO incomplete: The flush_work() in
.ndo_stop() should also be removed, since its existence implies
unexpected behaviour.

In other words, my moving it there in can327 was a double mistake, and
slcan just happened to copy my mistake over.

I'm preparing a patch for can327, and it will remove the flush from
.ndo_stop(). What shall we do about slcan?


Max
