Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2957D4FFB3A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236844AbiDMQ2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 12:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233602AbiDMQ2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 12:28:30 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F9B4F46F
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 09:26:05 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id c23so2440553plo.0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 09:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:in-reply-to:references:subject:message-id:date:mime-version
         :content-transfer-encoding;
        bh=icLq0RS4aJKb4f64l926jTnyJSafOn3sGFTWOzwE0vM=;
        b=urs9K05tFxkZsd23QDf09C49lCfL10DoJiTqcg3+rlF3GbXQbSY/p9x3veXq6H7ZyC
         6R3tzj6CjtytQxyg1K4vqNZNzqkt7t2XxDUXAi9oOa67k251mZVgS5JvsZh4SzOo1Arp
         UIqdSB+I4vxAcSXXPMf2wVxzdighhwt8OdfdPHF0Bsb5XW3bAA8P7k419q8ODMYbUzeH
         48j5MDCHK5dMd8SN4EdelwtjUlSJGlsdoN7ie1u/FRwuHtkeCoDTeBn52E5kfNihLCGV
         5L2gB08fLrCWLWtpkSljEmTNAR0XRVNYhwhWmmGyy2eGaKRXLDTsog12fh9wQwhq1CsY
         M5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=icLq0RS4aJKb4f64l926jTnyJSafOn3sGFTWOzwE0vM=;
        b=fbji81fBrZD9P4CQDADJrtxv1ybEnS9egvpAQrPPiyMYO3rTxz0CUGuT5U1nf75kvS
         N+MAQ4tqs87hEZT38/GMjn09xAkA50fBd/s7aCrmP+wOTSXVhVAw/qhd7vT0sTzBJ1ji
         HTa9KJbw78QUmruMcOPk2y5qIprETiEx3wGkQu9QciYHGRjf07tbBD6XCllzzdoKy4YL
         jkJjjdRa+iqLgGIUBO40IQc90UcpkCgrpyXV+y3IM3xUY+3Nqi4pdOuLBIHzU7FtvRmV
         DTcuz0Vg9pu2H7Konx5Two8m6xWv8ZYIm6GhagGg0hTVRpwJN62ATuGMIj0HpDfF13Nf
         nazQ==
X-Gm-Message-State: AOAM532VUDaAam01jzlJ5VIEuQoYWnDnwyxCsCtHj41VZtfPs4s3n6Cd
        XqAOCqg/Ol2ysTkepQf/093l63tVrjKJP0sz
X-Google-Smtp-Source: ABdhPJx9ThWTjDpKQHpNUtiA+EyDLkkBtpX+gJEhpWVsh3Xn6v5mGteAhJr0tr5ygazXRpv8H9IDrw==
X-Received: by 2002:a17:90a:7145:b0:1ca:97b5:96ae with SMTP id g5-20020a17090a714500b001ca97b596aemr11849784pjs.64.1649867165020;
        Wed, 13 Apr 2022 09:26:05 -0700 (PDT)
Received: from [127.0.1.1] ([2600:380:7619:ef79:ffbd:c836:a5b0:a555])
        by smtp.gmail.com with ESMTPSA id q4-20020a17090a7a8400b001cd4a0c3270sm3392756pjf.7.2022.04.13.09.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 09:26:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, netdev@vger.kernel.org
In-Reply-To: <20220412202240.234207-1-axboe@kernel.dk>
References: <20220412202240.234207-1-axboe@kernel.dk>
Subject: Re: [PATCHSET 0/2] Add io_uring socket(2) support
Message-Id: <164986716390.2022.1994521571584523698.b4-ty@kernel.dk>
Date:   Wed, 13 Apr 2022 10:26:03 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 14:22:38 -0600, Jens Axboe wrote:
> The main motivator here is to allow creating a socket as a direct
> descriptor, similarly to how we do it for the open/accept support.
> 

Applied, thanks!

[1/2] net: add __sys_socket_file()
      (no commit info)
[2/2] io_uring: add socket(2) support
      (no commit info)

Best regards,
-- 
Jens Axboe


