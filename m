Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84DF066AD14
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 18:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjANRgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 12:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbjANRgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 12:36:36 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A50D44AE;
        Sat, 14 Jan 2023 09:36:34 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 133AE419E9D1;
        Sat, 14 Jan 2023 17:36:31 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 133AE419E9D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1673717791;
        bh=QNbLvYRd7r/KjTcK2MsGuCJX9/CO/nTDz1fspNQ7yyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XNKepNMDDVHkDZP6WcR/P4sRocfpt0CNfcyV9d1RkURQ3XlvRbih2UNh7dgx0l/Db
         PURiJ49IeSSTRQ0LsQ6Y9qDgawK0fHktHOGK1w6LN+iLRBL1TSo+g6CdMR85rWQ+T2
         Pgqbj6katobvUNAE5Kj2O9Vq4IhxbrNjiWmGyR0I=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Ziyang Xuan <william.xuanziyang@huawei.com>, robin@protonic.nl,
        linux@rempel-privat.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: Re: [PATCH net] can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate
Date:   Sat, 14 Jan 2023 20:35:46 +0300
Message-Id: <20230114173546.38340-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20210910124005.GJ26100@pengutronix.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 10 Sep 2021 14:40:05 +0200, Oleksij Rempel wrote:
> Ok, I see, this warning makes sense only if session will actually be
> deactivated.
>
> Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
>
> Thank you!

As Ziyang Xuan stated, the patch was not applied to upstream.

Usage of WARN_ON_ONCE in this case is actually discouraged: it erroneusly
complains in a valid situation.

So the macro should be removed with the aforementioned patch. If it makes
some sense for debugging purposes, WARN_ON_ONCE can be replaced with
netdev_warn/netdev_notice but anyway discard of WARN_ON_ONCE.

--
Regards,

Fedor
