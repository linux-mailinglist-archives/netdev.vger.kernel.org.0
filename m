Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C251265DE02
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 22:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240191AbjADVGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 16:06:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240257AbjADVGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 16:06:12 -0500
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28F81CB2B
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 13:06:10 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id DAxcpwWwVxN58DAxcpFlIl; Wed, 04 Jan 2023 22:06:09 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 04 Jan 2023 22:06:09 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next 0/3] ezchip: Simplify some code
Date:   Wed,  4 Jan 2023 22:05:31 +0100
Message-Id: <cover.1672865629.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Theses patches (at least 1 and 2) can be seen as an RFC for net MAINTAINERS
get see if they see any interest in:
  - axing useless netif_napi_del() calls, when free_netdev() is called just
    after. (patch 1)
  - simplifying code with axing the error handling path of the probe and the
    remove function in favor of using devm_ functions (patch 2)

  or

if it doesn't not worth it and MAINTAINERS' time can be focused on more
interesting topics than checking what is in fact only code clean-ups.


The rational for patch 1 is based on Jakub's comment [1].
free_netdev() already cleans up NAPIs (see [2]).

CJ

[1]: https://lore.kernel.org/all/20221221174043.1191996a@kernel.org/
[2]: https://elixir.bootlin.com/linux/v6.2-rc1/source/net/core/dev.c#L10710


Christophe JAILLET (3):
  ezchip: Remove some redundant clean-up functions
  ezchip: Switch to some devm_ function to simplify code
  ezchip: Further clean-up

 drivers/net/ethernet/ezchip/nps_enet.c | 47 ++++++--------------------
 1 file changed, 10 insertions(+), 37 deletions(-)

-- 
2.34.1

