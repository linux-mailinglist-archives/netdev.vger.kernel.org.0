Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F38A39A1F7
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFCNQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhFCNQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:16:54 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE2CC06174A;
        Thu,  3 Jun 2021 06:14:56 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id x73so4846237pfc.8;
        Thu, 03 Jun 2021 06:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fBZJTdUeyr2PC5gYyTUryXoQTSj7Qok3gQumRrIu0a0=;
        b=HLmHLeJHhkSy2M1T5etFZSNqo3xvPd1u7R7Sa3lutKP4bDGIzQ2bPe1juOmclArj7M
         xW3iZw7ylIMBV8KjRJDHpJVw3ERQwORmDIQjvmdRi1ujVsDrZkguyihpsdyzy1GtLSAl
         oT95JVI8XG1BC8mvk1LPu3hCB5Vv6oMYtjCPwIDNUaAACOGJ4gl6tmf6jXISQYX1aKZb
         676iI19Cfod9pghrn5Pey4UbdJTMMDMMXNTrr3nw4cVrkGCdNb8JWpD91cuxDM6Qme1L
         yVx4tffFMm90E7GLDMHU/Nyi49Po3fSB6fWLpYjhvDskJ2n9C9Qoyjv0pGYEWJFxmHFE
         ykyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fBZJTdUeyr2PC5gYyTUryXoQTSj7Qok3gQumRrIu0a0=;
        b=Ag2WI/bVpP42Kl7T04pNeOEEkCVoxBDMXIMWVVRPMu56xN1VpGa3maPomXrUhiBIXd
         QES67rcBfzEvhqW3UrUXxOvRFoLOc+l7GJvgXdlgHKZnyML/LVlNzw7jgX1Izet5cVbs
         Co8TlKGEqjpB0arv6VQ+YiJDMeNoLQ0Mttd67oK6DRe7AMUmYR2YMeL6zAOYyN5bFd9P
         LlKUx3pVE9nFikq6toUxctiAwLLX+W7l7gb6VM9PU2Qm1zyPmMMxQdpAWmp0/op1YRnO
         QQAJuhEkarq4hvd618ai29g6+HRJLvVpQB7GkHCa3Ae5spqWa5OqxrWpHBfJX+m5pMhD
         VSqw==
X-Gm-Message-State: AOAM532x04QHKecnYM2fjlaPONfRPE26CfJ4WLI45M1QJGjlJVIAOxD0
        ay1VQCgGE4s2m+OX9tsBjjs=
X-Google-Smtp-Source: ABdhPJz5om3H8xNHSo1eHwum2iMJd7/GurKhKeEuAnqyeHIy9F3fHJ+2KN2D5ZuvxvRIErdNyKFbgA==
X-Received: by 2002:a62:3344:0:b029:24c:735c:4546 with SMTP id z65-20020a6233440000b029024c735c4546mr32657627pfz.1.1622726095612;
        Thu, 03 Jun 2021 06:14:55 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id y27sm633117pff.202.2021.06.03.06.14.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 06:14:55 -0700 (PDT)
Date:   Thu, 3 Jun 2021 06:14:52 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Subject: Re: [RESEND net-next 1/2] net: hns3: add support for PTP
Message-ID: <20210603131452.GA6216@hoboy.vegasvil.org>
References: <1622602664-20274-1-git-send-email-huangguangbin2@huawei.com>
 <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1622602664-20274-2-git-send-email-huangguangbin2@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 02, 2021 at 10:57:43AM +0800, Guangbin Huang wrote:

> @@ -4342,12 +4352,34 @@ static void hclge_periodic_service_task(struct hclge_dev *hdev)
>  	hclge_task_schedule(hdev, delta);
>  }
>  
> +static void hclge_ptp_service_task(struct hclge_dev *hdev)
> +{
> +	if (!test_bit(HCLGE_STATE_PTP_EN, &hdev->state) ||
> +	    !test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state) ||
> +	    !time_is_before_jiffies(hdev->ptp->tx_start + HZ))
> +		return;
> +
> +	/* to prevent concurrence with the irq handler, disable vector0
> +	 * before handling ptp service task.
> +	 */
> +	disable_irq(hdev->misc_vector.vector_irq);

This won't work.  After all, the ISR thread might already be running.
Use a proper spinlock instead.

> +	/* check HCLGE_STATE_PTP_TX_HANDLING here again, since the irq
> +	 * handler may handle it just before disable_irq().
> +	 */
> +	if (test_bit(HCLGE_STATE_PTP_TX_HANDLING, &hdev->state))
> +		hclge_ptp_clean_tx_hwts(hdev);
> +
> +	enable_irq(hdev->misc_vector.vector_irq);
> +}

Thanks,
Richard
