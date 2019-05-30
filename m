Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21530439
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfE3Vxw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:53:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfE3Vxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:53:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 257FC14DB1D91;
        Thu, 30 May 2019 14:36:05 -0700 (PDT)
Date:   Thu, 30 May 2019 14:36:04 -0700 (PDT)
Message-Id: <20190530.143604.925231544360388287.davem@davemloft.net>
To:     mcroce@redhat.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] sctp: deduplicate identical skb_checksum_ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190529153941.12166-1-mcroce@redhat.com>
References: <20190529153941.12166-1-mcroce@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 14:36:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matteo Croce <mcroce@redhat.com>
Date: Wed, 29 May 2019 17:39:41 +0200

> The same skb_checksum_ops struct is defined twice in two different places,
> leading to code duplication. Declare it as a global variable into a common
> header instead of allocating it on the stack on each function call.
> bloat-o-meter reports a slight code shrink.
> 
> add/remove: 1/1 grow/shrink: 0/10 up/down: 128/-1282 (-1154)
> Function                                     old     new   delta
> sctp_csum_ops                                  -     128    +128
> crc32c_csum_ops                               16       -     -16
> sctp_rcv                                    6616    6583     -33
> sctp_packet_pack                            4542    4504     -38
> nf_conntrack_sctp_packet                    4980    4926     -54
> execute_masked_set_action                   6453    6389     -64
> tcf_csum_sctp                                575     428    -147
> sctp_gso_segment                            1292    1126    -166
> sctp_csum_check                              579     412    -167
> sctp_snat_handler                            957     772    -185
> sctp_dnat_handler                           1321    1132    -189
> l4proto_manip_pkt                           2536    2313    -223
> Total: Before=359297613, After=359296459, chg -0.00%
> 
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Applied.
