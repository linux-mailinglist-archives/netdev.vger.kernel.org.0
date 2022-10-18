Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDB6602A7C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbiJRLpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiJRLpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:45:22 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8ADACA0C
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 04:45:20 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id o21so11157874ple.5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 04:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KmUOEFAcwSq6OQXtBtquZZQSnsbd4alRNXkQKRMCI/0=;
        b=YTSaMKeVYIDgsLpMNYnAcqk+pOukfV1BoTlI2JEUwUsW3jtw4U2FDI7fZlpX/iGYns
         fFEdMxBZC3yRUFj+bXsLVZXQ9j+pEcR23ythctNjYgBlWwtvz0alG8Dfn7voIcqApt1l
         dVq2PwtykIFbz5fFtpBDdod4o/xybRexFlB+EEJQ4VJz00A+LbopCQamkAhI4Nx/dyww
         x+Hm1Tv3YM4k82e8/hM3zRsXBPM3IKxPKdDFcGNG8N2N2RSQV1pajKenMqRRhIkFiOqm
         N6yI2aIJVMrrDvfYclqB6giSE4zOWivF14Y1gSZQ+DxrzbIh5AapcYetIgfZptM5VARy
         Zyvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmUOEFAcwSq6OQXtBtquZZQSnsbd4alRNXkQKRMCI/0=;
        b=V5YZM/x87UhEQs/E7boFTeIK9c365U89U8WsCCrJn8h7aboYv3p7eBeluwtxXHqu8D
         /1gEHXw8x0KcUVNaTwRMZr+vHyGQVdlKRtYTgmT2O0IgNYyaNAx/utum5EYXQoeHWQR7
         os0G3zFcjypn2ZVIYYfkZGiLbSGSci8HptJ8xdrLlGK0tl2qjx9nRUEYgCzxb8pYJ65d
         7mUlSd51TqSEabTlQ1HvzLdZC0WGojY4mRmBHqcBwD/elX4MmfwqN8Xcy1D6eEklbWf0
         YaSSNmCdfbHOMd2h/D8B3iG01brFmyMJQHpId/bfDfFAi3BIrHgjqp/MIf/9Q32+2+Vg
         NCQQ==
X-Gm-Message-State: ACrzQf2P3z/xoeBIhfpMVhm3x1JUsq6fTEoyMnXxd1QkD35WwCjfrqjZ
        otwRKBEwlFhoOsrB87dvb1E=
X-Google-Smtp-Source: AMsMyM7N8hSUH2rfjW6RDLm/Dtz30cxXxdzcerAlSbR/+hHzynKLq5GnDxUsYw6Ln7QuCydn5kA+xw==
X-Received: by 2002:a17:902:c209:b0:17f:7da5:b884 with SMTP id 9-20020a170902c20900b0017f7da5b884mr2615993pll.26.1666093520246;
        Tue, 18 Oct 2022 04:45:20 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m3-20020a62a203000000b0053e38ac0ff4sm9009013pff.115.2022.10.18.04.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 04:45:19 -0700 (PDT)
Date:   Tue, 18 Oct 2022 04:45:17 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Cc:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        aravindhan.gunasekaran@intel.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        vinicius.gomes@intel.com
Subject: Re: [PATCH v2 0/5] Add support for DMA timestamp for non-PTP packets
Message-ID: <Y06RzWQnTw2RJGPr@hoboy.vegasvil.org>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 09:07:28AM +0800, Muhammad Husaini Zulkifli wrote:

> With these additional socket options, users can continue to utilise
> HW timestamps for PTP while specifying non-PTP packets to use DMA
> timestamps if the NIC can support them.

What is the use case for reporting DMA transmit time?

How is this better than using SOF_TIMESTAMPING_TX_SOFTWARE ?


Thanks,
Richard
