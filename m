Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4D233C76C
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 21:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234056AbhCOUFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 16:05:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234083AbhCOUEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 16:04:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 674EF64EB9;
        Mon, 15 Mar 2021 20:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615838689;
        bh=I46OkIL/c/Uw8/DvONd9SJp8nJHJ7/x02B7La8U26EM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZNuqw1Xod+Td6NzQc2ZBvcxuY1nCZf4usHhyqsQrWY/rtma2MH/QmNteNbQGq1K6p
         ajfqfvsvgMYi1LH2mcYuzR95so1yWC8krTWEzxObID07Gg+qa4OBKjhGjBtQq26cSn
         r4/WWxq3lTxtQapE7+L1xFmEVWgR37gHrDw8M5a3ykk6yqGigajNqa6JW/8RwFRGAY
         DcRk57W0LPxFfAvjCH/ggtruyfq8xREegKh/CUSEh72OwMBsDRmLudbrfUUK1E2mxn
         hGHWW/BfqAgLv+c24FhB3NZiIIfrMuXtHPnq2EMQ38cWjViZWm8g+CN4uzAMIChLwy
         IR/PqvBiU0gMA==
Date:   Mon, 15 Mar 2021 13:04:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <huangdaode@huawei.com>, <linuxarm@openeuler.org>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
Message-ID: <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
        <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> For device version V3, it supports queue bonding, which can
> identify the tuple information of TCP stream, and create flow
> director rules automatically, in order to keep the tx and rx
> packets are in the same queue pair. The driver set FD_ADD
> field of TX BD for TCP SYN packet, and set FD_DEL filed for
> TCP FIN or RST packet. The hardware create or remove a fd rule
> according to the TX BD, and it also support to age-out a rule
> if not hit for a long time.
> 
> The queue bonding mode is default to be disabled, and can be
> enabled/disabled with ethtool priv-flags command.

This seems like fairly well defined behavior, IMHO we should have a full
device feature for it, rather than a private flag.

Does the device need to be able to parse the frame fully for this
mechanism to work? Will it work even if the TCP segment is encapsulated
in a custom tunnel?
