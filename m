Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA25965872E
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 23:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbiL1WFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 17:05:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiL1WFN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 17:05:13 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75F30101E2
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 14:05:12 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o2so11896817pjh.4
        for <netdev@vger.kernel.org>; Wed, 28 Dec 2022 14:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7i77mGGVMHE+yh81H2mW39t1MX5Oo5bzfihsYtcvRs=;
        b=bOcIBnYz72DPY6GsK3TE3/qvsFzZ4ZjQEmXhN46Ev/VYcblTMYlQD2Xgk15v/K/GPH
         AJbx87Rw4b1nwRgms34sHUmVWW6cmxtmjv5yITATKfiLElYUXLvp5gE9oYqr2NeYXuL+
         7A2yAwIJTxs0iplWkHjVGxwDL1ujCVmizU1ksNR2LOYUnQncdDAD/REtTwyNwDsEOooE
         35t/btXgSFf3ftmNCJYxy7mDbY1bMQY85V1+IxWIXQzWVc1zfW0Y9kuL5h6F5X3lESPB
         k/z2wxNhzmHiN0DK5RCI6mblIUALZlRTko8hECILp6/1w6cfLNX31PKaZ38sFkFrC7xt
         JMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7i77mGGVMHE+yh81H2mW39t1MX5Oo5bzfihsYtcvRs=;
        b=CWuiHfK7AjAusxB8Cvl4scnXlNYeGj98Bl/xEhCpf8fA6D9z/xY+lvLVRnDeILdkBw
         ZB+6kZ7dhD1DzmAbxeDoxQInxXSjUUkC+rZJWpIxH3rsvrL9eh603NztEOSZVCkgYVys
         vjMbXT+XNxmjeaeBmQp5B6+PPw09ZscjIcj/V8qEFF9HOto1QGZ4oTEccCkgKUuPofoG
         YE79kY5A9KZWNyNQzx9u7QJoJSPXREuOdi4u3zsktnmKpBMSLfvq37BwMRT8QEiVShRH
         S59g0h6jdxi+Yf4ABXsxDoS6EqwOqKKaGSpL2YCjCEAlfX0O8tluVcHlRoOtcif8kwbs
         IjMA==
X-Gm-Message-State: AFqh2kpxyg1y6dp6qWRuVr6KXGwrbIJ5BGHYnUTDezJ4br5MnWvzW+lw
        cYyB27FgKMtJgGzzq3kbMpOIgQ==
X-Google-Smtp-Source: AMrXdXu9dIS/yhQmTfqAE2n8L1C0J8ZigMiqUyJmvvuRDYGMX2F2Gx2mSfej7w/57qF7yt2S/vZX4g==
X-Received: by 2002:a17:90a:c696:b0:223:fa07:7bfc with SMTP id n22-20020a17090ac69600b00223fa077bfcmr29167535pjt.30.1672265111984;
        Wed, 28 Dec 2022 14:05:11 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id v12-20020a63464c000000b0044046aec036sm9700888pgk.81.2022.12.28.14.05.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 14:05:11 -0800 (PST)
Date:   Wed, 28 Dec 2022 14:05:09 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: disable ASPM in case of tx timeout
Message-ID: <20221228140509.21b14e7b@hermes.local>
In-Reply-To: <1847c5aa-39ff-4574-b1c5-38ac5f16e594@gmail.com>
References: <1847c5aa-39ff-4574-b1c5-38ac5f16e594@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Dec 2022 22:30:56 +0100
Heiner Kallweit <hkallweit1@gmail.com> wrote:

> There are still single reports of systems where ASPM incompatibilities
> cause tx timeouts. It's not clear whom to blame, so let's disable
> ASPM in case of a tx timeout.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Wouldn't a log message be appropriate here.

	netdev_WARN_ONCE(tp->dev, "ASPM disabled on Tx timeout\n");
