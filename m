Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386DB5517E3
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiFTL44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241536AbiFTL4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:56:55 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D0D17E1C;
        Mon, 20 Jun 2022 04:56:54 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id B41865C0181;
        Mon, 20 Jun 2022 07:56:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 20 Jun 2022 07:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1655726213; x=1655812613; bh=DF7IXatyZc
        fmlzK8+a+MhGWDcx/oKyhm00O2IupG+FQ=; b=mlrVNjTCvYnNl5CCKcdeL0DydB
        Q1lav+HH1xUKrcd06uN0JAVYiLwnWsYL3/zm8jKqEki+oatveBtvR4nlQOHb6wJm
        cgXxfiNiME7dVy2rmplDAYaluH6H0JI/Pcfnw8G05UxalQ1e/EYIbM6IlKCpFWAJ
        3ycjWSZ9fLJRWDqvC7hzm3aVMbduqhY8Si1I8gsbd4ZLSqKaJVwUwPmW2Ct3feHY
        xtu95HhZ+OVIfJpT1ZJHfPv63mRkaY9s4tIWkqK5KL2zfcJhNFrPh3t2ly9hRO/x
        aJIZeyi3WsHO/WHQ9kBVzGRFPv+p4dBHwm5X436S4UpzT6RG5gE13kHV6glA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1655726213; x=1655812613; bh=DF7IXatyZcfmlzK8+a+MhGWDcx/o
        Kyhm00O2IupG+FQ=; b=t7pOi2FrxrrbySpK9wvrKZ9gV4es2g90+BcCCHXz6ohL
        xOOTuHFxP406cFJfRGFzE0CMt+jb4Y4p+NogFfrHN4yvzigsJCnE9GDkf1KsU44b
        swH4tMykh3rOQtqC3drKZVrl6AkEIgHPRdH5H6bKicfElmQE+UbNwSgCQJdi+XiB
        G3/XWYbKuExEN/ZCRJbF6DxE98MdeAFP+YXhtjYZA3Zc1+wXYst/EPX+rUfzZP+c
        NP/cy6AsbdySTuuulFB28nJzXK4kb2bVBDxSuQFZpKGyB3nQQOtOFBD/WaPle1/H
        xe8QNtRfqYv9Z5SLRl3WgT33wDd7vfiq5jx1g3pRaw==
X-ME-Sender: <xms:hWCwYi6yRozq7t28nEGdeGNL6NTynW3PhKHKEVA-AXZoGqNR8ZCdIQ>
    <xme:hWCwYr5Njaw0b3GlVvBQtKQRXHkCN_cMIaiNIq-cCSsBFuZAFVtjGQbK3yTXjFrA5
    5xzGCwG_Ag1uw>
X-ME-Received: <xmr:hWCwYhcmi9I_ma96ShKpyRnvcikwNHtuymKGUudKMUMtGfJDJd3nNlH9Cgyu8Y8FQsulDdrZvW69vCOpZkg2Y4SSFqVBs7Iz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudefuddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:hWCwYvJNj_1p_P2QbV4aPY3zg9DiGJ1O38fJQTRIP_WNE9FjTuVwNg>
    <xmx:hWCwYmJgZ6mSQ9rvKWfSr4NS22sERINb4jx98QBGLK2GQ2Gx3xJYlg>
    <xmx:hWCwYgyy2ljnWMDT61hpo3lGxDJJqCHx12O5PVZ2t-T9ei_la9jzuw>
    <xmx:hWCwYoCVsVP48WXwNmhPCrDUF0ti7DyxG6d839kRi7AJmjg4fTDUcw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 20 Jun 2022 07:56:53 -0400 (EDT)
Date:   Mon, 20 Jun 2022 13:56:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Meng Tang <tangmeng@uniontech.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH 5.10 2/2] commit 1b5d73fb8624 ("igc: Enable PCIe PTM")
Message-ID: <YrBggx8tmeM9Be+4@kroah.com>
References: <20220614011528.32118-1-tangmeng@uniontech.com>
 <20220614011528.32118-2-tangmeng@uniontech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614011528.32118-2-tangmeng@uniontech.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 09:15:28AM +0800, Meng Tang wrote:
> In the 5.10 kernel version, even to the latest confirmed version,
> the following error will still be reported when I225-V network card
> is used.
> 
> kernel: [    1.031581] igc: probe of 0000:01:00.0 failed with error -2
> kernel: [    1.066574] igc: probe of 0000:02:00.0 failed with error -2
> kernel: [    1.096152] igc: probe of 0000:03:00.0 failed with error -2
> kernel: [    1.127251] igc: probe of 0000:04:00.0 failed with error -2
> 
> Even though I confirmed that 7c496de538eebd8212dc2a3c9a468386b2640d4
> and 47bca7de6a4fb8dcb564c7ca4d885c91ed19e03 have been merged into the
> kernel 5.10, but bug still occurred, and this patch can fixes it.
> 
> Enables PCIe PTM (Precision Time Measurement) support in the igc
> driver. Notifies the PCI devices that PCIe PTM should be enabled.
> 
> PCIe PTM is similar protocol to PTP (Precision Time Protocol) running
> in the PCIe fabric, it allows devices to report time measurements from
> their internal clocks and the correlation with the PCIe root clock.
> 
> The i225 NIC exposes some registers that expose those time
> measurements, those registers will be used, in later patches, to
> implement the PTP_SYS_OFFSET_PRECISE ioctl().
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Tested-by: Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> Signed-off-by: Meng Tang <tangmeng@uniontech.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 5 +++++
>  1 file changed, 5 insertions(+)

Both now queued up, thanks.

greg k-h
