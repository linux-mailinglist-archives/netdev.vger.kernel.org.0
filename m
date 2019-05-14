Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD9A1D063
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 22:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfENUQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 16:16:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:33480 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726254AbfENUQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 16:16:15 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (Proofpoint Essentials ESMTP Server) with ESMTPS id 6C49FB40080;
        Tue, 14 May 2019 20:16:13 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 14 May
 2019 13:16:09 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net 0/2] flow_offload: fix CVLAN support
To:     David Miller <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        <netdev@vger.kernel.org>, Jianbo Liu <jianbol@mellanox.com>
Message-ID: <6ba9ac10-411c-aa04-a8fc-f4c7172fa75e@solarflare.com>
Date:   Tue, 14 May 2019 21:16:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24612.005
X-TM-AS-Result: No-0.541900-4.000000-10
X-TMASE-MatchedRID: FHOCjPwihtzVF+EKi1OPX7BZAi3nrnzbWYZREwIGtxkR5h9YeZuu7Z3w
        TAj7CwR8Uz44CZW4mpzWTqibVjLaWiYKstYBxVaGuwdUMMznEA9XjjsM2/DfxntTo0P1ssT+wBI
        zUVtFoCLsY8uquIgVespN/dr1JrlFedTACv7eJKKcVWc2a+/ju8bMPJyz6yYwmyiLZetSf8nJ4y
        0wP1A6AAOkBnb8H8GWDV8DVAd6AO/dB/CxWTRRuzBqYATSOgWjPwm4lxkNOPBiw2cDbdtYOrWCA
        1qXuAgVMvBP6ImpyZTUyTExUBeyzoCFPU/E+Umm3lRUVT8UoKcBgwFk9mwxL89Q/jQtJRYvMcKp
        Xuu/1jVAMwW4rY/0WO2hZq8RbsdETdnyMokJ1HRyBhhCd0s8837cGd19dSFd
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.541900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24612.005
X-MDID: 1557864974-MBtN5FoGtYLn
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the flow_offload infrastructure was added, CVLAN matches weren't
 plumbed through, and flow_rule_match_vlan() was incorrectly called in
 the mlx5 driver when populating CVLAN match information.  This series
 adds flow_rule_match_cvlan(), and uses it in the mlx5 code.
Both patches should also go to 5.1 stable.

Edward Cree (1):
  flow_offload: support CVLAN match

Jianbo Liu (1):
  net/mlx5e: Fix calling wrong function to get inner vlan key and mask

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 include/net/flow_offload.h                      | 2 ++
 net/core/flow_offload.c                         | 7 +++++++
 3 files changed, 10 insertions(+), 1 deletion(-)

