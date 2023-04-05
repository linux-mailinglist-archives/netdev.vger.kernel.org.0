Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727B86D8678
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 21:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233855AbjDETC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 15:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDETC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 15:02:27 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649D9BA;
        Wed,  5 Apr 2023 12:02:26 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-17ab3a48158so39667505fac.1;
        Wed, 05 Apr 2023 12:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680721345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iuciwAKZq2wJaT34pYXM66kr946sug+R1OznahFQbBs=;
        b=GAaUYpEiV2Kl47BwmEhK7xVfJjJTlt1T3xzYge0UObeFDVpYOjI0mLsM/96CR/75Uc
         iAEBzvLXK+sjUt+RJE2HG2iwOdLyHf9CpZt0CBsXeSf2Qqlhh/9+X5beAFjasahU1wX/
         oObcb/d5krd9URFx9g8a2dHqSBA0f+Ix6GQFiiCm3thks0rqvXSdejTrYQpXHsq+J/5W
         0cFgPVpH5cH3vo+70IBd3XztFas+fmbAYFRowEpJrzKLEc2eKmgsUcQJ6q5Fpy7ORqGd
         QdHOQ/AhhH002MRxqQewW5fEdMX+519Q15s1l4G4CYGmgmi+thNCRLkBYiByR5ruIgmG
         3TiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680721345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iuciwAKZq2wJaT34pYXM66kr946sug+R1OznahFQbBs=;
        b=iMSJLMDGjWz3Wc9KWxFTyVINcArkHix1OuiTnbA0fHowPJYrKC1UDowc2eaaVSwJjw
         nDUTRk+gepoUPTEh5mJQb2FZNXdOVBZON5xOQ/IV4JHmy8NbAw74QbNSpMKH9/kjfh6U
         xM6YsXcCqq9JwAtF/qRtjppDmxZ0OPyagvcY9JFuR9ngrecqSQeYJeiSZSzKFI32s/cE
         VwWWRaYerIt9YLi5EGRJqXDHjZRw2S8HyO/nqB3hdS6b3ZHx801OaoZ7KoH0U9hyMQ3i
         2TxYr3B7vvK9wmb0rYKPZ954w1tPd6Sb2U7MwFbP+PeE4NDhgpX/k9DGMXE295IXx26z
         /1Rg==
X-Gm-Message-State: AAQBX9eYH5+Km66X9TpvTVTAwcjnnejULW3YkzM3q3QU0FdGdUz11y6w
        KCCLr/4nEuB+JCClRRV+1AI=
X-Google-Smtp-Source: AKy350ZG/6KmGrQcmR25Tx+lgzJ67Tk0y/et/MTnFdphXiBVmC6K7HCCleCmK9YphFfExyB962br7w==
X-Received: by 2002:a05:6870:41c8:b0:17a:a4af:8e3e with SMTP id z8-20020a05687041c800b0017aa4af8e3emr3874842oac.47.1680721345603;
        Wed, 05 Apr 2023 12:02:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id zq42-20020a0568718eaa00b0016b0369f08fsm6214199oab.15.2023.04.05.12.02.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 12:02:24 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 5 Apr 2023 12:02:23 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@armlinux.org.uk, hkallweit1@gmail.com, andrew@lunn.ch,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Shahab Vahedi <Shahab.Vahedi@synopsys.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Lai Peter Jun Ann <peter.jun.ann.lai@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        hock.leong.kweh@intel.com
Subject: Re: [PATCH net 1/1] net: stmmac: check fwnode for phy device before
 scanning for phy
Message-ID: <d942f8ac-3a60-4a71-8cd5-4f2f7aeaa2bd@roeck-us.net>
References: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093945.3549491-1-michael.wei.hong.sit@intel.com>
X-Spam-Status: No, score=0.7 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,
        FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 05:39:45PM +0800, Michael Sit Wei Hong wrote:
> Some DT devices already have phy device configured in the DT/ACPI.
> Current implementation scans for a phy unconditionally even though
> there is a phy listed in the DT/ACPI and already attached.
> 
> We should check the fwnode if there is any phy device listed in
> fwnode and decide whether to scan for a phy to attach to.y
> 
> Reported-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Fixes: fe2cfbc96803 ("net: stmmac: check if MAC needs to attach to a PHY")
> Signed-off-by: Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
> Tested-by: Shahab Vahedi <shahab@synopsys.com>
> Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Tested-by: Marek Szyprowski

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
