Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C37A01AD3B4
	for <lists+netdev@lfdr.de>; Fri, 17 Apr 2020 02:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728137AbgDQAlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 20:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbgDQAlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 20:41:23 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE9EC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 17:41:22 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id c3so177560otp.8
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 17:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=jaxzzAGgt9b40w7dm+PLMrbiJc5E7EIOZfTpiPld5dU=;
        b=fYAgdfU897RkYG2bz88QgkywyCdCuxr3sjiRrrGJho9CBD3hX0vK/A3eDW/38UfWwD
         aXvPWzKgW6AupBrY93Ydgahlyg19WTUuuVG1ikla1ySXad3Y69k8q+RqGk1SAR0KIMPN
         NlsvIDzl6rTA9CUkm/HHrvOPYvgB0VJA4kgm7FnKe6/FvC1F51Ca1uhsWnpmXEPk8wLR
         KQQnnj6agUopxhmugxEUoekc/wJ5weIKcVeYDo4ZCIXTUWD6yNBQbRrquTy3Yu0RLX/X
         xlyxz+kruLpgu5TKROS4alAwmG3kCJhW5SLC+RFFSxl54UXcC2S2nBSWmgOZBlu/Y/ZQ
         wV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jaxzzAGgt9b40w7dm+PLMrbiJc5E7EIOZfTpiPld5dU=;
        b=i3n7BR0HeBybnvDbJUrC2v6maq77nrLbCHthE49f3DEuSauommy9JeoJNYuFiTC+Hy
         Z+fznOWIMDMNK4xPO4Fxe6TVIUYuqsl79oaVsOOHcbqGMEeMQXpdE/A6tgdwndVABmk6
         hdKYXUzz+us9VD3osR+ND8jj8WcM8GfHk1eXDaZZjQkJe+4pk6JOkFtu6vC8dsSfdPFg
         OUnVawXvAR2zmp7OoAFxNEj/aIyZ5sn5jaZ+gWgUUDoewg6C4QLVGW8GIJZNTy2uoTUL
         Cx/hll77jO3UVMRdqmfTPU69cmXkc0mF2nbyvIyzNFTuPponxh34lTQlJ6KviQ0i4QrO
         lxog==
X-Gm-Message-State: AGi0Pub9ZKIrlUucr+lfxprc1phKs89uPrkZqkDy0wkHh1RzkaLfsNLi
        OkAEt8OMDMUWSbdqVpV/5xEVsvQN
X-Google-Smtp-Source: APiQypJVeQgCgJIBueRDX1wphwvgGeLR4ifSOAi2+gznZ/lld7E11OqmbCDVoqNVFFfmteCdiP7q+w==
X-Received: by 2002:a9d:a55:: with SMTP id 79mr659666otg.295.1587084081906;
        Thu, 16 Apr 2020 17:41:21 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id i21sm5809655ooe.26.2020.04.16.17.41.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Apr 2020 17:41:21 -0700 (PDT)
Date:   Thu, 16 Apr 2020 17:41:20 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     netdev@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: -Wconstant-conversion in
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
Message-ID: <20200417004120.GA18080@ubuntu-s3-xlarge-x86>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I was building s390 allyesconfig with clang and came across a curious
warning:

drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:580:41: warning:
implicit conversion from 'unsigned long' to 'int' changes value from
18446744073709551584 to -32 [-Wconstant-conversion]
        mvpp2_pools[MVPP2_BM_SHORT].pkt_size = MVPP2_BM_SHORT_PKT_SIZE;
                                             ~ ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/mvpp2/mvpp2.h:699:33: note: expanded from
macro 'MVPP2_BM_SHORT_PKT_SIZE'
#define MVPP2_BM_SHORT_PKT_SIZE MVPP2_RX_MAX_PKT_SIZE(MVPP2_BM_SHORT_FRAME_SIZE)
                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/marvell/mvpp2/mvpp2.h:634:30: note: expanded from
macro 'MVPP2_RX_MAX_PKT_SIZE'
        ((total_size) - NET_SKB_PAD - MVPP2_SKB_SHINFO_SIZE)
                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.

As far as I understand it, the warning comes from the fact that
MVPP2_BM_SHORT_FRAME_SIZE is treated as size_t because
MVPP2_SKB_SHINFO_SIZE ultimately calls ALIGN with sizeof(struct
skb_shared_info), which has typeof called on it.

The implicit conversion probably is fine but it would be nice to take
care of the warning. I am not sure what would be the best way to do that
would be though. An explicit cast would take care of it, maybe in
MVPP2_SKB_SHINFO_SIZE since the actual value I see is 320, which is able
to be fit into type int easily.

Any comments would be appreciated, there does not appear to be a
dedicated maintainer of this driver according to get_maintainer.pl.

Cheers,
Nathan
