Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC56D67CC53
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 14:36:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbjAZNgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 08:36:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjAZNga (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 08:36:30 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9251739;
        Thu, 26 Jan 2023 05:36:29 -0800 (PST)
Received: from fedcomp.intra.ispras.ru (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 503B740D403D;
        Thu, 26 Jan 2023 13:36:25 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 503B740D403D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1674740185;
        bh=0b43UeQLqG/CbFnOsMwNF1eMzXNA9GcQsvNOir8rjrQ=;
        h=From:To:Cc:Subject:Date:From;
        b=hXpJvfU9DuJrhnOG9b4M9+BSbCzhZMXVr4Lt4Dp+DURGkHi6SOSPFWLz+LSQLuqw9
         66kKeuiPs8pM1zVpTDNtulWfDorF1E07OGIoAGXfgSzMflxgidrQ+gEuiP2mdAaUfb
         lYFRmExq3nKQqx+gN5pmr38Nj7omkcjUwFuG2XUk=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Archie Pusaka <apusaka@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@google.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH 6.1 0/1] Bluetooth: hci_sync: cancel cmd_timer if hci_open failed
Date:   Thu, 26 Jan 2023 16:36:12 +0300
Message-Id: <20230126133613.815127-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzkaller reports use-after-free in hci_cmd_timeout(). The bug was fixed
in the following patch and can be cleanly applied to 6.1 stable tree.

Due to some technical rearrangement, the fix for older stable branches
requires a different patch which I'll send you in another thread.
