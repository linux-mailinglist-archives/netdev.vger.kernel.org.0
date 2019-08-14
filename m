Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46BF38D6A8
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727703AbfHNOxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 10:53:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41940 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfHNOxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 10:53:54 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so42863613pgg.8;
        Wed, 14 Aug 2019 07:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=+iv6tMK/o9vMBCxy40O2J+PdS9TBkY+n+okgVzN9Tqw=;
        b=oeA15lyRbPS94WCVj5L8WfPsOiB030AomtlKlmEnzKHY9ppuXhOis3qbtEfov6Hm//
         EPXPtqzIhBo1AZWTz8as4/tYw5Z03niKCtuZht7WOPOFACJqvI6XyKLr1/mc5uP4dfCX
         a8Nfm/GXnx3c6BK4qLZTC3CXtVRW9BDQMebfPzvd6+oFY13e6IxsMGcuRY51MZZDCq/W
         XCo15Dr/yfvyq2kP/vHiIif41arVcLF18y9nk4tTfFUvVj9u6d3TjT5Ge4++Xo1OdWf8
         whkcFWO+OqEqvyUJIqWyfLtaKrVXLldrFBfv9ecKMAAKqyPvYtaQFE2VaccbTPnHptgc
         aFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=+iv6tMK/o9vMBCxy40O2J+PdS9TBkY+n+okgVzN9Tqw=;
        b=HaGSYAZQ8fx9zym3NTmPPm6V6ysyciag1mZFlZPSa9KlNVathvE9NL6dwyETOsKBS8
         CbpK1UfrNkzhE8LPYLkjMdcD81qEYVCcf/iHINyXWvesPwpB++hyqXgkcUMGorb/rlzX
         VijNcAtWUs7mVrqARINsvqjoD+ghSaSF4P2w/gv00jYa/hWTw2N8JC9f1TzskDDDB4JQ
         QoTasyGIt6qyGvWQGw+rChUfiThjGIIpvAkdsj5Qe9ExKtJHAEph29B+aQivJVuDuK6t
         DjbVeUGnRUf9DCxe6HmyHFoazBhx++21bTejY6HXppvxSmHk3iHCOq45BU5h2HcXDFL0
         HNcg==
X-Gm-Message-State: APjAAAVVRMom6JqNsuYYuppsfYQL4o9vrNfFiDdYDip25U7kMYNdPFME
        N2pUAobyVwQrQTMHXoxsnYI=
X-Google-Smtp-Source: APXvYqwkCrLOvikbUjEU3qo2UvtHhQFopTxQRFv6lIHxPE5Q7nVoLGeEyOR0lvXOYLX6yuzMCTNufg==
X-Received: by 2002:a63:2887:: with SMTP id o129mr32644602pgo.179.1565794433673;
        Wed, 14 Aug 2019 07:53:53 -0700 (PDT)
Received: from [172.26.122.72] ([2620:10d:c090:180::6327])
        by smtp.gmail.com with ESMTPSA id k64sm90010717pge.65.2019.08.14.07.53.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 07:53:53 -0700 (PDT)
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
Subject: Re: [PATCH bpf-next v4 7/8] net/mlx5e: Move the SW XSK code from NAPI
 poll to a separate function
Date:   Wed, 14 Aug 2019 07:53:51 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <52303412-E8CB-4F34-A41D-4CDE12D719CA@gmail.com>
In-Reply-To: <1565767643-4908-8-git-send-email-magnus.karlsson@intel.com>
References: <1565767643-4908-1-git-send-email-magnus.karlsson@intel.com>
 <1565767643-4908-8-git-send-email-magnus.karlsson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14 Aug 2019, at 0:27, Magnus Karlsson wrote:

> From: Maxim Mikityanskiy <maximmi@mellanox.com>
>
> Two XSK tasks are performed during NAPI polling, that are not bound to
> hardware interrupts: TXing packets and polling for frames in the Fill
> Ring. They are special in a way that the hardware doesn't know about
> these tasks, so it doesn't trigger interrupts if there is still some
> work to be done, it's our driver's responsibility to ensure NAPI will be
> rescheduled if needed.
>
> Create a new function to handle these tasks and move the corresponding
> code from mlx5e_napi_poll to the new function to improve modularity and
> prepare for the changes in the following patch.
>
> Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
