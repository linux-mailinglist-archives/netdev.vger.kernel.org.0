Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A8B2520344
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239694AbiEIRLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239563AbiEIRLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:11:49 -0400
Received: from smtpcmd12132.aruba.it (smtpcmd12132.aruba.it [62.149.156.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CFE619FB15
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:07:49 -0700 (PDT)
Received: from localhost.localdomain ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id o6rMnQWIJPF2eo6rMnMWqG; Mon, 09 May 2022 19:07:48 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652116068; bh=TjYG3E/+cnICxb5g+LSNmbTgbBfI9nG8Ag6knqdfm8U=;
        h=From:To:Subject:Date:MIME-Version;
        b=U62ACYD+sCcQP0r8SJ4yV629c1NlbI9Y0PbcVUv+JzJvawO7oUUl6wOhyZ2c/yAmX
         ZqbdaHTGb0CNY9+zbLi0Th2uPvLtA8a387wWLtXIcLev6EyC7Io0D3z3YYKFiMKPzb
         8B6p3tBkeNu00+SxE5dG6fSeZmN++SvB2NEDLvLiHZoY9L4MELVfRk/3bv5xRzh+F6
         o+HmgDJWkILqqeKjWpszifT8TkHytX5T5VFREkxZ4QnhI9lTlTbiQZAHfRlkBPt6K5
         yf0rFwn7N+wxm2g+Jx6H5usD1HS3FgqQWtsPmrfucQO4usnPef2jn0rR94DzPzWSdZ
         07UPN08D5mXFA==
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Subject: [PATCH RESEND 0/2] j1939: make sure that sent DAT/CTL frames are marked as TX
Date:   Mon,  9 May 2022 19:07:44 +0200
Message-Id: <20220509170746.29893-1-devid.filoni@egluetechnologies.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfHoU8zsQ3CAig+xXFPp80rmS8FcudGafCAuL5jnFEcx+3qXgsoeeZKhSUw9g5Xy8rlPtI99zVaWalDNhZw1RiF5+esJOJIbycLAXuHcoYfvrUIS1q0w9
 avhI1Lq+Cukse7QtfPwc0WWfmmiIp8GBTLTXMNfXPBFM3/nv0G3xUSofdzH1dTjqLeeWapv2VyJwIch9bN/Dt5HrWNJi6AE+u7I7iHsMgfXcfkJJohVutYrU
 0o2UXp81ZFX+lRZVyItD5IcIvtlZrlbvxRg0jznxO5QVj6rMpQhwRlX51MNNEcWJAepe/7lM3Lp+8OeaPH+jCYcX3yp8T8w22o3Kv/GOj419wDo3NRFrAYvf
 +Lvwf4Mjh51EjeI+i7ieRSSTpi3GoQPlb9knY1tHMbphXpWDoaPxtBTFC6WKZ69o9hE9Y/DFsqcylRWjWwTDH/0RbtT28orurYjyPoapyhax5N/LzdLPvBww
 QKM9o1pnNkZirMovOVYRerapMUtTMJie2miTROOMD6zRwWFCRZrELKQeAjMqE5GLHn5ptHxd/Rc7ScSoIW8M9ieFnZFm6P7ULMroQ/SvizFVjY/65GyrSv6o
 xmviFaHSPVMAUi3pawzeEy/UJ9xBW25HzxkW3A5qO6rz096lqjiDWV08qVTnySbO6sr800Dmg5aaz5IYGaS9WFP/TE7vN48NDx7AGiXW/Xbu8w==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

If candump -x is used to dump CAN bus traffic on an interface while a J1939
socket is sending multi-packet messages, then the DAT and CTL frames
show up as RX instead of TX.

This patch series sets to generated struct sk_buff the owning struct sock
pointer so that the MSG_DONTROUTE flag can be set by recv functions.

I'm not sure that j1939_session_skb_get is needed, I think that session->sk
could be directly passed as can_skb_set_owner parameter. This patch
is based on j1939_simple_txnext function which uses j1939_session_skb_get.
I can provide an additional patch to remove the calls to
j1939_session_skb_get function if you think they are not needed.

Thank you,
Devid

Devid Antonio Filoni (2):
  can: j1939: make sure that sent DAT frames are marked as TX
  can: j1939: make sure that sent CTL frames are marked as TX

 net/can/j1939/transport.c | 69 ++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 12 deletions(-)

-- 
2.25.1

