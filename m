Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C09E5102741
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 15:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728314AbfKSOrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 09:47:12 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:33978 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727693AbfKSOrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 09:47:12 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJEl3L1127708;
        Tue, 19 Nov 2019 08:47:03 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574174823;
        bh=OXUbZruzHdM6LcZR/07PxuUSjLDUqi60DA1vaZg2jFs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=my9n7z/+Rv8yLMeHxUFRDKMKyXZCTkd2eq1EOENBQJhIjjv+X2MCk+ILG43vMY/NV
         OzT4NwDWpErX+LIvRquDkBzX9slilH2Ze8hsSjOylwIjXAt5BPPbCh9LGE2yx2QCyR
         YA8OKf8gkUrwNRlae7WFchWC2WpNlYRdPXV9pRjU=
Received: from DFLE104.ent.ti.com (dfle104.ent.ti.com [10.64.6.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xAJEl2VQ068335
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 Nov 2019 08:47:03 -0600
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 08:47:01 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 08:47:01 -0600
Received: from [10.250.33.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJEl1j4013921;
        Tue, 19 Nov 2019 08:47:01 -0600
Subject: Re: [PATCH 2/2] can: m_can_platform: remove unnecessary
 m_can_class_resume() call
To:     Pankaj Sharma <pankj.sharma@samsung.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <wg@grandegger.com>, <mkl@pengutronix.de>, <davem@davemloft.net>,
        <rcsekar@samsung.com>, <pankaj.dubey@samsung.com>,
        Sriram Dash <sriram.dash@samsung.com>
References: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
 <CGME20191119102201epcas5p4e215c25d5d07269a7afb1f86fac0be65@epcas5p4.samsung.com>
 <1574158838-4616-3-git-send-email-pankj.sharma@samsung.com>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <0af3a926-fa28-2ddd-a6ef-1c516f674fc9@ti.com>
Date:   Tue, 19 Nov 2019 08:45:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1574158838-4616-3-git-send-email-pankj.sharma@samsung.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pankaj

On 11/19/19 4:20 AM, Pankaj Sharma wrote:
> The function m_can_runtime_resume() is getting recursively called from
> m_can_class_resume(). This results in a lock up.
>
> We need not call m_can_class_resume() during m_can_runtime_resume().
>
> Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
>
> Signed-off-by: Pankaj Sharma <pankj.sharma@samsung.com>
> Signed-off-by: Sriram Dash <sriram.dash@samsung.com>
> ---
>   drivers/net/can/m_can/m_can_platform.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
> index 2eaa354..38ea5e6 100644
> --- a/drivers/net/can/m_can/m_can_platform.c
> +++ b/drivers/net/can/m_can/m_can_platform.c
> @@ -166,8 +166,6 @@ static int __maybe_unused m_can_runtime_resume(struct device *dev)
>   	if (err)
>   		clk_disable_unprepare(mcan_class->hclk);
>   
> -	m_can_class_resume(dev);
> -
>   	return err;
>   }
>   
Acked-by: Dan Murphy <dmurphy@ti.com>
