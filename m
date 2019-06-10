Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE53D3BF7B
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 00:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390238AbfFJW1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 18:27:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388328AbfFJW1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jun 2019 18:27:18 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5A1D7E421;
        Mon, 10 Jun 2019 22:27:17 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-18.ams2.redhat.com [10.36.112.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8B13D608E4;
        Mon, 10 Jun 2019 22:27:16 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     Guillaume Nault <gnault@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: [PATCH net 0/2] Don't assume linear buffers in error handlers for VXLAN and GENEVE
Date:   Tue, 11 Jun 2019 00:27:04 +0200
Message-Id: <cover.1560205281.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Mon, 10 Jun 2019 22:27:17 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guillaume noticed the same issue fixed by commit 26fc181e6cac ("fou, fou6:
do not assume linear skbs") for fou and fou6 is also present in VXLAN and
GENEVE error handlers: we can't assume linear buffers there, we need to
use pskb_may_pull() instead.

Stefano Brivio (2):
  vxlan: Don't assume linear buffers in error handler
  geneve: Don't assume linear buffers in error handler

 drivers/net/geneve.c | 2 +-
 drivers/net/vxlan.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.20.1

