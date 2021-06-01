Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1929E397290
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 13:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhFALjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 07:39:45 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:38874 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233409AbhFALjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 07:39:43 -0400
Received: from bld-lvn-bcawlan-34.lvn.broadcom.net (bld-lvn-bcawlan-34.lvn.broadcom.net [10.75.138.137])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 3A7C5829D;
        Tue,  1 Jun 2021 04:38:01 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 3A7C5829D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1622547481;
        bh=A7DViLzhSSmk++S9KSFL1GRI7XxOsNHRI9z60MGz1zw=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Bxwbgz/205KnBPTpWMrQIYHlRNlywbla8G5vLdUvYZVgjA9StBtnydwBRPdIRUs4m
         hiil/PzpEiJqXrmJ3XdGhrfqC6RbYfrNsvPW46pJQgdF9gRi8hRFtB9d4/5+5uiTBQ
         KuWHSJqlhA64kjfJVXa1ltvQQVp+feVBW1xr1S/8=
Received: from [10.230.42.155] (unknown [10.230.42.155])
        by bld-lvn-bcawlan-34.lvn.broadcom.net (Postfix) with ESMTPSA id 16ACE1874BE;
        Tue,  1 Jun 2021 04:37:56 -0700 (PDT)
Subject: Re: [PATCH -next] brcmfmac: Fix a double-free in brcmf_sdio_bus_reset
To:     Tong Tiangen <tongtiangen@huawei.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210601100128.69561-1-tongtiangen@huawei.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <224ed779-5d68-9f67-9b17-75e1e1b4250c@broadcom.com>
Date:   Tue, 1 Jun 2021 13:37:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210601100128.69561-1-tongtiangen@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01-06-2021 12:01, Tong Tiangen wrote:
> brcmf_sdiod_remove has been called inside brcmf_sdiod_probe when fails,
> so there's no need to call another one. Otherwise, sdiodev->freezer
> would be double freed.
> 
> Fixes: 7836102a750a ("brcmfmac: reset SDIO bus on a firmware crash")
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 -
>   1 file changed, 1 deletion(-)
