Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FC42B6657
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgKQOCF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:02:05 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:40150 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731515AbgKQOCC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:02:02 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE1rJC046249;
        Tue, 17 Nov 2020 08:01:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1605621713;
        bh=/5Z6TCsOxHzpM5NFoTcfXBMVm9y2DF/QFISzS8e5r7w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=rfALYsqPdhpntYgVF0V2+qLBHJ2VGNPBF1PNbfaWWYFBxC364hshB8VnI8u+dL05k
         BNyls57EAlIPLP2J8Fuma3s56YGrX55gnpsmqM4oUASTEN3ayT9+UhoNGIWRA/Q5lT
         pdnZzPulRjgn9Nf3M+NtRbaXORQszk5fhzgs9Dc4=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 0AHE1rxM013508
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Nov 2020 08:01:53 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 17
 Nov 2020 08:01:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 17 Nov 2020 08:01:53 -0600
Received: from [10.250.39.187] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 0AHE1qHp036401;
        Tue, 17 Nov 2020 08:01:52 -0600
Subject: Re: [net 12/15] can: m_can: m_can_handle_state_change(): fix state
 change
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>,
        Wu Bo <wubo.oduw@gmail.com>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
 <20201115174131.2089251-13-mkl@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <7ddd0177-fdaa-0cf2-dd0d-90005ba3bf9f@ti.com>
Date:   Tue, 17 Nov 2020 08:01:52 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201115174131.2089251-13-mkl@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 11/15/20 11:41 AM, Marc Kleine-Budde wrote:
> From: Wu Bo <wubo.oduw@gmail.com>
>
> m_can_handle_state_change() is called with the new_state as an argument.
>
> In the switch statements for CAN_STATE_ERROR_ACTIVE, the comment and the
> following code indicate that a CAN_STATE_ERROR_WARNING is handled.
>
> This patch fixes this problem by changing the case to CAN_STATE_ERROR_WARNING.
>
> Signed-off-by: Wu Bo <wubo.oduw@gmail.com>
> Link: http://lore.kernel.org/r/20200129022330.21248-2-wubo.oduw@gmail.com
> Cc: Dan Murphy <dmurphy@ti.com>
> Fixes: e0d1f4816f2a ("can: m_can: add Bosch M_CAN controller support")
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---
>   drivers/net/can/m_can/m_can.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> index 02c5795b7393..63887e23d89c 100644
> --- a/drivers/net/can/m_can/m_can.c
> +++ b/drivers/net/can/m_can/m_can.c
> @@ -665,7 +665,7 @@ static int m_can_handle_state_change(struct net_device *dev,
>   	unsigned int ecr;
>   
>   	switch (new_state) {
> -	case CAN_STATE_ERROR_ACTIVE:
> +	case CAN_STATE_ERROR_WARNING:
>   		/* error warning state */
>   		cdev->can.can_stats.error_warning++;
>   		cdev->can.state = CAN_STATE_ERROR_WARNING;
> @@ -694,7 +694,7 @@ static int m_can_handle_state_change(struct net_device *dev,
>   	__m_can_get_berr_counter(dev, &bec);
>   
>   	switch (new_state) {
> -	case CAN_STATE_ERROR_ACTIVE:
> +	case CAN_STATE_ERROR_WARNING:
>   		/* error warning state */
>   		cf->can_id |= CAN_ERR_CRTL;
>   		cf->data[1] = (bec.txerr > bec.rxerr) ?

Reviewed-by: Dan Murphy<dmurphy@ti.com>

