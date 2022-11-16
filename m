Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC1762C5A3
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 17:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiKPQ7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 11:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232548AbiKPQ7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 11:59:51 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859F1140FB
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 08:59:50 -0800 (PST)
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668617989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ziPY9TIhuCDl5Ov5W3fS5XkHCork3vIKk2n8LfkX3Js=;
        b=WA71B6AsRIlbuvzqZPtkeJi0/h8EU1B0YquC1qL5Mxly4RrWOKXsbKQJ//mGcY5xQM71Id
        pobTj2t8LW3Sf03geL8bGj593EWXSkfwKGHNCC8J82otqNGuiJL88AbNxk/kMzQ9qk0baa
        iB8B1zNWXhpWDFKvfBaCg15bRNCdI9kc5ifF7a6VcWqv52sDRuebunws0OPZSHaFafn/58
        V+gHhpyEfMjdONR5j0CnTLiinH6Qa3qDsMyDbSJthuKuAv0+VOj1BXfBJA6dcglkjfK58L
        B5Dw6zIa6lBECmNyWOF7EuZ12fVTSxwtSo6r6FYd5ARwsFnAx0jyn7cuPUA3vg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668617989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ziPY9TIhuCDl5Ov5W3fS5XkHCork3vIKk2n8LfkX3Js=;
        b=TW1Q/1gvIxpfcm93/y8F3VHFo9GD7SdbP8Oh4cLqzP4OOp63Q3Dd62pD11eX7gOFYQyYuc
        pyjb/o5UvAoC65AQ==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net 0/5] hsr: HSR send/recv fixes
Date:   Wed, 16 Nov 2022 17:59:38 +0100
Message-Id: <20221116165943.1776754-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I started playing with HSR and run into a problem. Tested latest
upstream -rc and noticed more problems. Now it appears to work.
For testing I have a small three node setup with iperf and ping. While
iperf doesn't complain ping reports missing packets and duplicates.

One thing I didn't mention in the patches (and remember now) is that
before the revert (while looking for the reason of the duplicated
packets) I randomly observed a crash while hsr network was up but had no
traffic. It didn't happen with traffic or I was not patience enough.
It appears from the backtrace that the node was removed twice. This was
the additional boost for the revert since it appears it is not used. I
Didn't see the crash after the revert.

Sebastian


