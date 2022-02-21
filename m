Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1E684BE029
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347556AbiBUJHq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 04:07:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347677AbiBUJHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 04:07:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B5531343;
        Mon, 21 Feb 2022 00:59:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07D00B80EAF;
        Mon, 21 Feb 2022 08:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71643C340E9;
        Mon, 21 Feb 2022 08:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645433997;
        bh=EDcnl/SXjNhFjt2tMyZWMrIk4KXM0og1BPFfteTgKWk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=E6TMrjcjgWKg8e0p3Frb4HVh5bubGzKepDtd2OdOOi6nqqEIktYo1MbWIYol4HQiF
         7t6mkT4A5fVYglEtRwYacRNJvkEDN9JiRHKVdYz6ueB7YcSy/EbN+0+2an6rUF5WAK
         LRa2pJdBGd/Qpobem0KH4gz16QSdkq7W1OFe1TBqgs6ygFw91/3CB5vfC0V2JJsqQd
         iuG3K7gGG0YNkPABL5GB35VOwyYcjyJVH32k8wRMH4cUALZ8RF4fISqEIPojlf8pbW
         DwnJaQphtxeDqtcifeTxCJs6IhebXOBoQi5voFcWqNDkSzI9PVaEPG/S9vKYjUV81b
         4eu/kxBnZELOA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] brcmfmac: Replace zero-length arrays with
 flexible-array members
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216194935.GA904103@embeddedor>
References: <20220216194935.GA904103@embeddedor>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543399279.995.3471133482847126442.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 08:59:54 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:

> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Patch applied to wireless-next.git, thanks.

d8b1f4193e09 brcmfmac: Replace zero-length arrays with flexible-array members

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216194935.GA904103@embeddedor/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

