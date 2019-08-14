Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4D38D75B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 17:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728286AbfHNPlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 11:41:49 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:43221 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbfHNPls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 11:41:48 -0400
Received: by mail-pg1-f194.google.com with SMTP id k3so2248619pgb.10;
        Wed, 14 Aug 2019 08:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=O5OHk4GVwTOH3/2WWRV/xHNUYFZMkcNgmPSCC7StgDo=;
        b=KCzk+TSQF9zO5+LG/31abtFiWvrfGr+w+7IDX/8xyVxpWtu/z3ge8H+rHyNmQ83Ht5
         0cw+/ok5i1F6DXsl2vrB2fJVruIto9zGFjiylm3DsepEPXGmbYfNGxpDUNww21sJ1nsN
         xz65QyvKG0H/CGzmYDd6av2QIVf+kGx5eTQsOsM4psAm3+EEOrZNjVaiWBsHOojRAiLo
         mYFFP2jmB1IHHBm4+aGsr7ZaV4suXqzt2DePHgANlvzoVT/9K6bHtKK0qwWHYxBVAZth
         X3XCqjNmQLDaHWjL4HRBuW6VUQsPEnlhUbP6ZbDWuRTWh0qBVdriaZEX/GMwwbnLFD/k
         FE0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=O5OHk4GVwTOH3/2WWRV/xHNUYFZMkcNgmPSCC7StgDo=;
        b=j8/P5RxC0xtOhlbcfUlv+FjNMgkpSS5QQR9sTTxC0nKWV3ISTcm26iblQgkUckvCTM
         i3m6NFGueSBwuot8Q/FqN+JS1VvRucdJy879MD2POjfNe0oOjZG/sWmE+bn3MlRRehqf
         0s+ZeK68sMRyK/pfOggX2IAyUTJU4LgJ2XJZ3pUvW3l3FczdtiXlvKH9zYxutpqlaZTk
         HESTRCXvD56oPOjUSj58zZwU7giSpztPggPt65RBqwChQjBGdg9LATNTHGdxaXGBBvHf
         kC0JedAHTX+C3pMUFAK7tld9gcH0sVI8FoCpnheWJcjOyDt+/VS7jmPweOvjV6dMFQKw
         JzpQ==
X-Gm-Message-State: APjAAAUtE6lzdFMnx9Y5k+23gL1QW/PTdhDTVu/Ou/N6iMDjKxb8MtFC
        DbWBxG+wnSZ0/UfmqeHZZbA=
X-Google-Smtp-Source: APXvYqzjZFrr3rJKcSsnGqyM/iwg1XYFzKS+wkccR7KdyMR5vL/4KzqhmcP/PytH3FlUAjPi1H+5YA==
X-Received: by 2002:a62:1d8f:: with SMTP id d137mr549211pfd.207.1565797308210;
        Wed, 14 Aug 2019 08:41:48 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id s72sm65545pgc.92.2019.08.14.08.41.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 08:41:47 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Magnus Karlsson" <magnus.karlsson@intel.com>
Cc:     bjorn.topel@intel.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, brouer@redhat.com, maximmi@mellanox.com,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com,
        ilias.apalodimas@linaro.org, kiran.patil@intel.com,
        axboe@kernel.dk, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH bpf-next v4 4/8] ixgbe: add support for AF_XDP need_wakeup
 feature
Date:   Wed, 14 Aug 2019 08:41:46 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <E0E5FCCE-AF23-4329-9789-292BE78C4B7C@gmail.com>
In-Reply-To: <1565767643-4908-5-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-5-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> This patch adds support for the need_wakeup feature of AF_XDP. If the
> application has told the kernel that it might sleep using the new bind
> flag XDP_USE_NEED_WAKEUP, the driver will then set this flag if it has
> no more buffers on the NIC Rx ring and yield to the application. For
> Tx, it will set the flag if it has no outstanding Tx completion
> interrupts and return to the application.
>
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
