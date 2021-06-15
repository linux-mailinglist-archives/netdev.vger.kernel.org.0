Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E533A864F
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbhFOQXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 12:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229689AbhFOQXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 12:23:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 953B7611EE;
        Tue, 15 Jun 2021 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623774106;
        bh=fbA/mW2k7HqL2X9tAQyK9Qz/fPeJfcGvBVz7b7/hcq8=;
        h=Date:From:To:Cc:Subject:From;
        b=Qt17jN5/0ijctpxeWo/wHnfW1oRW9jBduORKtS/rtz6Y/+SMb5TGMaXabyZ4JFe08
         fkvPtpKfRfR7C5PjCzwVNWspCSj/YtqEk1X58fYP01y9VS7JxukmYj6tVhw1383yLS
         6AUqYkNM6ScgK4hnFRjNhYIZlj1CMg4dQNu0+zr/jBDU7d9itV4o27dA9jZaKK4ae/
         oXyyRVI0Op2XgKAcUCQqYZJQhBav3Uu0MqrIQKXCEBOILXlCIIIsNs6QtPRgaLsWC8
         emQ9L3d1MuL5cvY2q9t8qGZkBx4btjYNgVrqwO/WlaIZyMCeLg34M6wzPiBqCSuDwA
         Gdl6ddNPNB2ow==
Date:   Tue, 15 Jun 2021 19:21:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        stable@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>
Subject: NetworkManager fails to start
Message-ID: <YMjTlp2FSJYvoyFa@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

The commit 591a22c14d3f ("proc: Track /proc/$pid/attr/ opener mm_struct")
that we got in v5.13-rc6 broke our regression to pieces. The NIC interfaces
fail to start when using NetworkManager.

There is nothing in dmesg except error that NetworkManager failed to start.

Our setups are:
 * VMs with virtio-net NICs
 * Fedora 29

The revert fixes the issue and VMs boot with network working.

Thanks
