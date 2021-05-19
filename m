Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2D4388E3F
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353433AbhESMkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:40:36 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:33680 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353419AbhESMkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:40:35 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D722624706;
        Wed, 19 May 2021 05:39:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D722624706
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621427955;
        bh=rmuK/K3fBffMGY9dTheEJuib9VCu9Gy25cLus+IJUug=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=VgS533qm3C1EqyRmsV7B0Xs4p19KcSWkZBffW6Cf6caYrMtmogkGbUjQEqgK1PVEt
         +jL87cedxnr6z/qWPoqa0LOepb56Zuy8L3Apu/OkLEy1ZMMpX0PlmDpbuGrfuHYcEQ
         elsFfUk4kEEG4P58APWaL33j8OpRbgJUTXNcmUr0=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 6F0051874BE;
        Wed, 19 May 2021 05:39:11 -0700 (PDT)
Subject: Re: [PATCH] brcmsmac: mac80211_if: Fix a resource leak in an error
 handling path
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        davem@davemloft.net, kvalo@codeaurora.org, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <8fbc171a1a493b38db5a6f0873c6021fca026a6c.1620852921.git.christophe.jaillet@wanadoo.fr>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3b96aa02-869c-4663-1c63-759d058b8744@broadcom.com>
Date:   Wed, 19 May 2021 14:39:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <8fbc171a1a493b38db5a6f0873c6021fca026a6c.1620852921.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12-05-2021 22:58, Christophe JAILLET wrote:
> If 'brcms_attach()' fails, we must undo the previous 'ieee80211_alloc_hw()'
> as already done in the remove function.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>   .../wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c    | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
