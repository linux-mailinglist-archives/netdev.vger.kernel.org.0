Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A27C3E98CB
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 21:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbhHKTdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 15:33:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:37256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhHKTdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 15:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69EF160F21;
        Wed, 11 Aug 2021 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628710360;
        bh=ZY8dkbEI7LmSgQrdttclvtLABoo8DhCPawqrvlD+eIk=;
        h=From:To:Cc:Subject:Date:From;
        b=iDdzhxOkZVTrb2QNBaS2oejdJHS0MIGotwCJ2j3FRe4MJijtdlv23RU7JhzKWhFV0
         b6yC0FSMwu0mf+4JKrlan47UkPJup1VxmIdnyk31q0R+D4MP+m9AvpMXbG8Np3zWoA
         Mi0EnM2Z1zhOnqmzwNwbDwqRkCLp3SoB9qHNYqXzrKIn7EvOl3nOUDnyyl4es6XXnM
         6Vnb8m3qC1TkEtWONVs8yPuhNe6AxfoFyvFG1ZLSiXPMVFyEFjXCqHtHfDGQDwUalw
         NxucZ9Kq/QvUeJeGD0KHuDH2YhXNTEP4jaD2yMC6Gv6y2/vrFQJJENMDCqrIQxIeQa
         nMMndcB7uyPEw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     michael.chan@broadcom.com, huangjw@broadcom.com,
        eddie.wai@broadcom.com, prashant@broadcom.com, gospo@broadcom.com,
        netdev@vger.kernel.org, edwin.peer@broadcom.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 0/4] bnxt: Tx NAPI disabling resiliency improvements
Date:   Wed, 11 Aug 2021 12:32:35 -0700
Message-Id: <20210811193239.3155396-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A lockdep warning was triggered by netpoll because napi poll
was taking the xmit lock. Fix that and a couple more issues
noticed while reading the code.

Jakub Kicinski (4):
  bnxt: don't lock the tx queue from napi poll
  bnxt: disable napi before cancelling DIM
  bnxt: make sure xmit_more + errors does not miss doorbells
  bnxt: count Tx drops

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 59 ++++++++++++++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  1 +
 2 files changed, 36 insertions(+), 24 deletions(-)

-- 
2.31.1

