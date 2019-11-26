Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD71510A676
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfKZWU1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 17:20:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43030 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726050AbfKZWU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:20:27 -0500
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1iZjC3-0008Na-7K; Tue, 26 Nov 2019 23:20:23 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH net 0/2] __napi_schedule_irqoff() used in wrong context
Date:   Tue, 26 Nov 2019 23:20:11 +0100
Message-Id: <20191126222013.1904785-1-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I found three cases where __napi_schedule_irqoff() could be used with
enabled interrupts while looking for something else… There are patches
for two of them.

The third one, hyperv/netvsc, is wrong with the `threadirqs' commandline
option because the interrupt will be delivered directly via the vector
and not the thread. I will try to sort this out with the x86 folks.

Sebastian

