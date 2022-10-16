Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102B860038C
	for <lists+netdev@lfdr.de>; Sun, 16 Oct 2022 23:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiJPVzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Oct 2022 17:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJPVzF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Oct 2022 17:55:05 -0400
Received: from mailgw.felk.cvut.cz (mailgw.felk.cvut.cz [147.32.82.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6340A13FA2;
        Sun, 16 Oct 2022 14:54:59 -0700 (PDT)
Received: from mailgw.felk.cvut.cz (localhost.localdomain [127.0.0.1])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTP id BF2D730B2949;
        Sun, 16 Oct 2022 23:54:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        cmp.felk.cvut.cz; h=cc:cc:content-transfer-encoding:content-type
        :content-type:date:from:from:in-reply-to:message-id:mime-version
        :references:reply-to:subject:subject:to:to; s=felkmail; bh=LQd5Q
        rd/j/9u/DWNjR5yotOcmDbQdjNNhniIHl7ZOf0=; b=MVJLVMYqSYViWakjPEkyh
        jC5bHZpTvnlG/EkD9gUrNl+HiWBCacw7dmC80V+TfPPknuhBJ6yH0k0VD+86K0Yy
        0PkMckp1RqcMwCFaQ+ooWYtXftz+0pfRmDRWOK1yXx+8jnFFa86wg+ryT70+kQtE
        taPfDlDIgjBk7FIL/fpMCxMBP9YRUOQx5dsQIrJ76cnAKdOgXJFY1IPM39F8TY7x
        oWR/miAyybtBlLDWhm2YpFZwxi6z+ZgMiHglVrqDcgQoDahOW0xjylaQhPwx9zsk
        tQj7dqnmk4picPDdEXLCT2lPDvnC0Bu3SiRQVMrlc1KV+xUNtfAMLRPt+dcd+drh
        Q==
Received: from cmp.felk.cvut.cz (haar.felk.cvut.cz [147.32.84.19])
        by mailgw.felk.cvut.cz (Proxmox) with ESMTPS id D759630ADE4B;
        Sun, 16 Oct 2022 23:54:55 +0200 (CEST)
Received: from haar.felk.cvut.cz (localhost [127.0.0.1])
        by cmp.felk.cvut.cz (8.14.0/8.12.3/SuSE Linux 0.6) with ESMTP id 29GLstLx017446;
        Sun, 16 Oct 2022 23:54:55 +0200
Received: (from pisa@localhost)
        by haar.felk.cvut.cz (8.14.0/8.13.7/Submit) id 29GLstXE017445;
        Sun, 16 Oct 2022 23:54:55 +0200
X-Authentication-Warning: haar.felk.cvut.cz: pisa set sender to pisa@cmp.felk.cvut.cz using -f
From:   Pavel Pisa <pisa@cmp.felk.cvut.cz>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Subject: Re: [PATCH v5 2/4] can: ctucanfd: add HW timestamps to RX and error CAN frames
Date:   Sun, 16 Oct 2022 23:54:48 +0200
User-Agent: KMail/1.9.10
Cc:     Ondrej Ille <ondrej.ille@gmail.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20221012062558.732930-1-matej.vasilevski@seznam.cz> <20221012062558.732930-3-matej.vasilevski@seznam.cz>
In-Reply-To: <20221012062558.732930-3-matej.vasilevski@seznam.cz>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202210162354.48915.pisa@cmp.felk.cvut.cz>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the work

On Wednesday 12 of October 2022 08:25:56 Matej Vasilevski wrote:
> This patch adds support for retrieving hardware timestamps to RX and
> error CAN frames. It uses timecounter and cyclecounter structures,
> because the timestamping counter width depends on the IP core integration
> (it might not always be 64-bit).
> For platform devices, you should specify "ts" clock in device tree.
> For PCI devices, the timestamping frequency is assumed to be the same
> as bus frequency.
>
> Signed-off-by: Matej Vasilevski <matej.vasilevski@seznam.cz>

Acked-by: Pave Pisa <pisa@cmp.felk.cvut.cz>

It would be great if the code gets in as a basic level for CTU CAN FD
timestamping which we need for CAN latency test project.

In the longer term, it could be usesfull to discuss if rx_filter == HWTSTAMP_FILTER_ALL
and cfg.tx_type == HWTSTAMP_TX_ON should be divided to allow separate timestamping
enable and disable for transmit and receive. Our actual focus is to receive
and Tx is implemented by reading the timestamping counter in the message transmit
done interrupt. There is option (for newer core version) to loop Tx frames
into Rx loop which could allow to enhance precision of Tx timestamps
to 10 ns. But that requires newer IP core and I wait even for some minor changes
to allow identification of looped Tx frames into Rx queue.
Switch to such processing mode will have some overhead etc... So it should
stay configurable and used only when precise Tx timestamp are really required...

When the current timestamping patch is accepted I plan to discuss
use of clk_prepare_enable for the main IP core clocks.
These clocks are AXI bus ones on our FPGA integration so they
has to be up anyway and clk_prepare_enable etc.. does not change
behavior, but I want to make that correct in long term.
I hope/expect that it is not problem to call clk_prepare_enable twice
on same reference when the clocks are the same. As I read the code the
state is counted. If it is a problem then some if has to be put there
when the core and timestamp clock are the same.

Thanks for work and reviews,

                Pavel
-- 
                Pavel Pisa
    phone:      +420 603531357
    e-mail:     pisa@cmp.felk.cvut.cz
    Department of Control Engineering FEE CVUT
    Karlovo namesti 13, 121 35, Prague 2
    university: http://control.fel.cvut.cz/
    personal:   http://cmp.felk.cvut.cz/~pisa
    projects:   https://www.openhub.net/accounts/ppisa
    CAN related:http://canbus.pages.fel.cvut.cz/
    RISC-V education: https://comparch.edu.cvut.cz/
    Open Technologies Research Education and Exchange Services
    https://gitlab.fel.cvut.cz/otrees/org/-/wikis/home

