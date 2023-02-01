Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B98E2686297
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 10:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjBAJMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 04:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbjBAJMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 04:12:39 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9A311648
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 01:12:30 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id t18so16640192wro.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 01:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4Bjg8/mwrM30m1Qm0E9bGUKQY25/5LUlbnZWV4Z6CbU=;
        b=M5ViRqb7iwMSVny8MWaHrJgEXJV7jDCX/XBDY6CVq/57gvwf8nTcV05CO06OVWiSlD
         MNW/1W9vIRmHMYRn60h6brIvR0YVJWYn4u8MODg77llgSyZ9Xf7n+2EXVwGfyQXIGanD
         aEvYGGBhmvv3Vh2TGPUqet9QLVlxdteX6HovsdN90S2hbdtTZKELpFZtOAjf18/O33Ew
         MQja8aX14laHJMCYtGxj8TnA7wGW/k/6j8IxgyP5BiTJ/ZOXANAZanM7ZTAXlr7pKdYV
         I3nktfQaDZCKJceNaHBmMMWHnyZrwupKIFnt7stwu53mKLZxdNoC5GSNWhkply0fxGwU
         yU9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Bjg8/mwrM30m1Qm0E9bGUKQY25/5LUlbnZWV4Z6CbU=;
        b=KUEheHslHzbLdZxsd+GFLi6plhDuKwggLaJ+KlkJZcSsgtfv3rbvV9w9H7KRWyav5D
         U+8u5BuoXuSCXhr9ftfqsRQDHJcnRjL9AXlIenQ4ICF+/AO7IL2pJktl+K6Hr7MvHKgk
         Rf5x0vvhVlIw3Peo4Zd8PKvJzM99e/e9jLXlWkxEb+WrG4Puv4xhLxCgCq8DZGA7QyGA
         JoPTrqh+8nluRCFrlXvbXFbAekabi9A+zbP5sLERWQP4OvSbiHCQ0HryiqLrHUIj8kwa
         0sHYeMB3M7MFUfzzAOqB/Ayo0XUZsl0SledBqDNiit03LwhlInTgSqjcbjyVD5PP7GhR
         uhpQ==
X-Gm-Message-State: AO0yUKUdHKW0wJP4w4Kvs71pz4WrCzFto4tNCoQNj2DRdI/BOOveq6ny
        IDihiU88CXU6c/F6poJQgKDBCw==
X-Google-Smtp-Source: AK7set+QXDAsjfhkvnjTQLzBqB9EEwjkSvUahxkdtqbhN4rY0Z/sXSM6vrTKi6J1HoZEHT0ZkO5ITA==
X-Received: by 2002:adf:f186:0:b0:2bf:e69e:9ed1 with SMTP id h6-20020adff186000000b002bfe69e9ed1mr1812403wro.17.1675242748759;
        Wed, 01 Feb 2023 01:12:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id v12-20020a5d610c000000b0028965dc7c6bsm16537720wrt.73.2023.02.01.01.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 01:12:28 -0800 (PST)
Date:   Wed, 1 Feb 2023 10:12:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        vinicius.gomes@intel.com, Simon Horman <simon.horman@corigine.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/1] igc: return an error if the mac type is unknown
 in igc_ptp_systim_to_hwtstamp()
Message-ID: <Y9os+zttPvt5mlFM@nanopsycho>
References: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jan 31, 2023 at 10:54:37PM CET, anthony.l.nguyen@intel.com wrote:
>From: Tom Rix <trix@redhat.com>
>
>clang static analysis reports
>drivers/net/ethernet/intel/igc/igc_ptp.c:673:3: warning: The left operand of
>  '+' is a garbage value [core.UndefinedBinaryOperatorResult]
>   ktime_add_ns(shhwtstamps.hwtstamp, adjust);
>   ^            ~~~~~~~~~~~~~~~~~~~~
>
>igc_ptp_systim_to_hwtstamp() silently returns without setting the hwtstamp
>if the mac type is unknown.  This should be treated as an error.
>
>Fixes: 81b055205e8b ("igc: Add support for RX timestamping")
>Signed-off-by: Tom Rix <trix@redhat.com>
>Reviewed-by: Simon Horman <simon.horman@corigine.com>
>Acked-by: Sasha Neftin <sasha.neftin@intel.com>
>Tested-by: Naama Meir <naamax.meir@linux.intel.com>
>Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>---
> drivers/net/ethernet/intel/igc/igc_ptp.c | 14 +++++++++-----
> 1 file changed, 9 insertions(+), 5 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
>index c34734d432e0..4e10ced736db 100644
>--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
>+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
>@@ -417,10 +417,12 @@ static int igc_ptp_verify_pin(struct ptp_clock_info *ptp, unsigned int pin,
>  *
>  * We need to convert the system time value stored in the RX/TXSTMP registers
>  * into a hwtstamp which can be used by the upper level timestamping functions.
>+ *
>+ * Returns 0 on success.
>  **/
>-static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
>-				       struct skb_shared_hwtstamps *hwtstamps,
>-				       u64 systim)
>+static int igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
>+				      struct skb_shared_hwtstamps *hwtstamps,
>+				      u64 systim)
> {
> 	switch (adapter->hw.mac.type) {
> 	case igc_i225:
>@@ -430,8 +432,9 @@ static void igc_ptp_systim_to_hwtstamp(struct igc_adapter *adapter,
> 						systim & 0xFFFFFFFF);
> 		break;
> 	default:
>-		break;
>+		return -EINVAL;
> 	}
>+	return 0;
> }
> 
> /**
>@@ -652,7 +655,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *adapter)
> 
> 	regval = rd32(IGC_TXSTMPL);
> 	regval |= (u64)rd32(IGC_TXSTMPH) << 32;
>-	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
>+	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval))

Use variable to store the return value.


>+		return;
> 
> 	switch (adapter->link_speed) {
> 	case SPEED_10:
>-- 
>2.38.1
>
