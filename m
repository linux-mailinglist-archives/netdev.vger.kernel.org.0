Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7CD2FF7C2
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:12:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbhAUWLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:11:14 -0500
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:44807 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbhAUWLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:11:12 -0500
Received: from localhost.localdomain (38.25-200-80.adsl-dyn.isp.belgacom.be [80.200.25.38])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by serv108.segi.ulg.ac.be (Postfix) with ESMTPSA id 1A3CE200F4A1;
        Thu, 21 Jan 2021 23:00:54 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 1A3CE200F4A1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1611266454;
        bh=6+yZKpJf66+aalgw6xgutFJ20DIvRlOLHwaFUDUgmZ8=;
        h=From:To:Cc:Subject:Date:From;
        b=PUs1K3YuZUXDJCsGUnTi5ORZjWJ8sK9HfgEayhf7w1+tkpGaewwc2GNHVeJ9yG8Ca
         Ce0nqStXdlh2JajyNK1z6qVEsZnuutJY7RaH6Jj/Ix8cpK2+X2FMXgCeMOcUgfe+tz
         BzecxiXbgsty1TfiG3b12WQjNqt/xr5+kt9WVPsNlrfyBCalyHSO6noq8b6bnWiv6g
         a03lVzd3EpuJ4lK+ooxH5Jf3tspzNDVqx4El65yIsltWl9HFh5xbsQwyI1M24yojY5
         ONu0JZIg5/mURL2a+gQpIqLTkS9eskJ5SUM1SwglRzSwCLBMflr1+tsrBikoJveDnU
         Vify2M9b4HeSg==
From:   Justin Iurman <justin.iurman@uliege.be>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, alex.aring@gmail.com,
        Justin Iurman <justin.iurman@uliege.be>
Subject: [PATCH net 0/1] Fix big endian definition of ipv6_rpl_sr_hdr
Date:   Thu, 21 Jan 2021 23:00:43 +0100
Message-Id: <20210121220044.22361-1-justin.iurman@uliege.be>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following RFC 6554 [1], the current order of fields is wrong for big
endian definition. Indeed, here is how the header looks like:

+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
| CmprI | CmprE |  Pad  |               Reserved                |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

This patch reorders fields so that big endian definition is now correct.

  [1] https://tools.ietf.org/html/rfc6554#section-3


Justin Iurman (1):
  uapi: fix big endian definition of ipv6_rpl_sr_hdr

 include/uapi/linux/rpl.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

-- 
2.17.1

