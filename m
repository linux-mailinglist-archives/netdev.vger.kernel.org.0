Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C38046994C9
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjBPMuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230360AbjBPMup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:50:45 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5CF2D4A
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:50:44 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id jg8so4867919ejc.6
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 04:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kFcMQx/FobLdlN2Tsa9fqt6PNTE75tueqIOjn7uzh2M=;
        b=UwOtCF3i0UUV0irCMuPCDSdDnQGi9F31fPevAbVT3AJ31MQVxqS3hduiHa51g6PTyQ
         rpmASmszrq0RiuC16F+6xir8qFq3tXOHTboezBNQj0i9KS5XCl15g8/VEbosut+LaxnP
         woRTQGfTHL5xURI3zHd19n3zSsj4CI+Caxqx+dbjOZsMzmCeReCETBo+T4WHi9NVFQUn
         epHZEtA0ULkdfVAwZvn5iuAQVmfzQBgwJDLPkF1dgV11MVDcMvzYgeWI38/KpdCKDXV9
         jS8KKejg3xWXYeDFSYNdTegej+0lvguNnkjgbjHN+5vgj/qTfoprAGu6LYcgmLo/3Xuf
         iDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFcMQx/FobLdlN2Tsa9fqt6PNTE75tueqIOjn7uzh2M=;
        b=UIgQmwJ/qleXO0lf2+V6vplq5aI+9fr4G/RXlzQA3w+80KOmLeTTQkPBlFpipUoTZU
         NnsJOuBw+upMS6W15D1rZBOyIYqA3IC4S3IxIJH2FH8s58JWK2rG4XG6Y2+XxYwJVUjf
         zbNdn6rbkFH58Sr1MSTysqzDhSOQ7Se3TD91iVr5Ha446jIPuPE9u80seC1FxEVrL94X
         QAX3aYi84IA6M9m01IlT1aKTpB+2vN78ryGwfOTVBClpafUvK1Ty4GW2gkUq2aaBp+AG
         urOaO34jrHwZY3MMw1KtuEMaNzxyg4wfljK2Oa5l044MYLtbYbMYBz7QSMdYoGZsq68P
         jcVQ==
X-Gm-Message-State: AO0yUKVv9/WwgLU5S8s/7RJf+lz6PfPlZLTiBIcxqfVrVUv1iR7zWJeb
        JcZJ59KMIobZHq8R6wzoGZTK//hVtn7Bfw==
X-Google-Smtp-Source: AK7set/nnQPUa66CRkwXHM317kKha4nE+OyntSifHZq+cHpx+aUgbZkFop1vyLSj7RrhD7bLjvwz0g==
X-Received: by 2002:a17:906:e89:b0:88c:4f0d:85af with SMTP id p9-20020a1709060e8900b0088c4f0d85afmr6343894ejf.75.1676551842765;
        Thu, 16 Feb 2023 04:50:42 -0800 (PST)
Received: from skbuf ([188.26.57.8])
        by smtp.gmail.com with ESMTPSA id qp14-20020a170907206e00b008b126882334sm776109ejb.39.2023.02.16.04.50.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 04:50:42 -0800 (PST)
Date:   Thu, 16 Feb 2023 14:50:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230216125040.76ynskyrpvjz34op@skbuf>
References: <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
 <Y8/jrzhb2zoDiidZ@lunn.ch>
 <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e379c00-ceb8-609e-bb6d-b3a7d83bbb07@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 12:20:24PM +0100, Angelo Dureghello wrote:
> Still data passes all trough port6, even when i ping from
> host PC to port4. I was expecting instead to see port5
> statistics increasing.

> # configure the bridge
> ip addr add 192.0.2.1/25 dev br0
> ip addr add 192.0.2.129/25 dev br1

In this configuration you're supposed to put an IP address on the fec2
interface (eth1), not on br1.

br1 will handle offloaded forwarding between port5 and the external
ports (port3, port4). It doesn't need an IP address. In fact, if you
give it an IP address, you will make the sent packets go through the br1
interface, which does dev_queue_xmit() to the bridge ports (port3, port4,
port5), ports which are DSA, so they do dev_queue_xmit() through their
DSA master - eth0. So the system behaves as instructed.
