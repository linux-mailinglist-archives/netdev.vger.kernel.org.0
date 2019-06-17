Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC42484FD
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:14:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbfFQOOD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:14:03 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44724 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFQOOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:14:03 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hcsOV-0005uy-4F; Mon, 17 Jun 2019 16:13:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     tariqt@mellanox.com, ranro@mellanox.com, maorg@mellanox.com,
        edumazet@google.com
Subject: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of list pointer
Date:   Mon, 17 Jun 2019 16:02:26 +0200
Message-Id: <20190617140228.12523-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tariq reported a soft lockup on net-next that Mellanox was able to
bisect to 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list").

While reviewing above patch I found a regression when addresses have a
lifetime specified.

Second patch extends rtnetlink.sh to trigger crash
(without first patch applied).

