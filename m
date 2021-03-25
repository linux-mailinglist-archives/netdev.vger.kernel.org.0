Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38F3495B9
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 16:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhCYPf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 11:35:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230095AbhCYPfg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 11:35:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 21999619EE;
        Thu, 25 Mar 2021 15:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616686535;
        bh=hk1klnU+xMU75YXTdm7Fa6836mugI24eHhT+ymPVC2M=;
        h=From:To:Cc:Subject:Date:From;
        b=Zh/vu5rzHWc19+aKTvt6679yUGven4xj6hb1CB67w+gk+t+Prx89iEEC9B0sReo8M
         arky4LmmYQj3stkadTLgCMp9rlTewEnDdHKwhZolnSsKV/k2RcyhH6S6w0sV3paffv
         gUc/UkWR6eHGj7kdugzeIKoW4BDzgoXDT5Zy91z0B9Fi+OFMpQ90suTrF+9Ly+Pzi/
         Bu4XP98rLYsc02rxkAHLMqWOQlGT8i/tUUm7pJASGVCs8Smdo3QkL71hqTky2r/6/9
         exp6P2m4tLjtPqWeIPO9sTqEkCU8dp6vkugOhN0wwHv0yBpKRui8QZZqwD20TRqh2J
         mY74fNDGM/akQ==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, echaudro@redhat.com,
        sbrivio@redhat.com, netdev@vger.kernel.org
Subject: [PATCH net 0/2] net: do not modify the shared tunnel info when PMTU triggers an ICMP reply
Date:   Thu, 25 Mar 2021 16:35:31 +0100
Message-Id: <20210325153533.770125-1-atenart@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The series fixes an issue were a shared ip_tunnel_info is modified when
PMTU triggers an ICMP reply in vxlan and geneve, making following
packets in that flow to have a wrong destination address if the flow
isn't updated. A detailled information is given in each of the two
commits.

This was tested manually with OVS and I ran the PTMU selftests with
kmemleak enabled (all OK, none was skipped).

Thanks!
Antoine

Antoine Tenart (2):
  vxlan: do not modify the shared tunnel info when PMTU triggers an ICMP
    reply
  geneve: do not modify the shared tunnel info when PMTU triggers an
    ICMP reply

 drivers/net/geneve.c | 24 ++++++++++++++++++++----
 drivers/net/vxlan.c  | 18 ++++++++++++++----
 2 files changed, 34 insertions(+), 8 deletions(-)

-- 
2.30.2

