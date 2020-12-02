Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7E62CBB0D
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 11:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgLBKwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 05:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgLBKwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 05:52:03 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8756CC0613CF
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 02:51:22 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id r24so3827300lfm.8
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 02:51:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=g7vtvYhGpwx3So27JMWwGKcQ7yA3yH1ETx9G2qdDMNo=;
        b=KHQUe+eoILuzSzAPtsRVir7UMEKMqoYaAH8IKHRmNy8FV+KXa5w+dVM+TtljnPxDQn
         zohArFelWrMBsyq/SJHhGDhYp9/y2PBzryDEl0ME04knpUku0QTIKkXul7oyY/Ii/JFm
         v1gO/yFJzFJHrUnuYDN3DrFikX3dkG7DnAS2eoPLklnKBqGAv/QGm1VDLArmZiC40BeC
         DSp3EBMu0wkqc5yi7/cCwPUbZO70Nz0u9jkUDGd6m7xv7YPj5w0UJp0h5hiUyU6GHuc7
         vHYYmjDKnM7P3d4MAc5fSpzWwaeINs6fDl1WTI0ScbagRD96CoEHNgyYI5xu/T//0JxJ
         ye7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=g7vtvYhGpwx3So27JMWwGKcQ7yA3yH1ETx9G2qdDMNo=;
        b=W1SF8bSd/R7EOgFUCCJodaJKHoPho9OquOAkd0FeHkrzld1UB60geK72nrzw+V8cHX
         Y534S4wWknYIBDGUVhWbDr8bVfXRvD+Q2BZ7sKxLgoqFHdDZS7cjSAmGJP4wh8hptYaO
         R8uXikBE42YA8W+2C1bzMGFVtbjEfJeWf5GM3ADmm0GfRuGKM+Ha68wi+Qyt5YUqmNy+
         utuBvVfJHjCJCDvnxMGVemjURw+hIfCR8EUqo+zF6sBPTWYXj1IXRyazQskN/UnNuouH
         polfnvpm+FqCdekLCRY5yTdXCTjxyEZFHoHId+GXIsveHXeIId18gx8RyNrt6OQx/1z7
         yp4g==
X-Gm-Message-State: AOAM5326lMnmmTeAaqfYy+HP/By1P21FBLjhnCVCihrZaQWQSYUzcUAD
        k0xXej/eu99ZqS+3zF4iz6clJURCLrotJN8n
X-Google-Smtp-Source: ABdhPJzrC1elt1BfW9ZeUev9b6fTsKtrhofmLPrVCJed0XUufkB1jq8FZOpUL6afhzBAfWKRqYIBNA==
X-Received: by 2002:a19:a415:: with SMTP id q21mr1011594lfc.508.1606906280659;
        Wed, 02 Dec 2020 02:51:20 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id q21sm368360ljm.52.2020.12.02.02.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 02:51:20 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
In-Reply-To: <20201202100736.gdvi754tdcxrqb5b@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com> <20201202091356.24075-3-tobias@waldekranz.com> <20201202100736.gdvi754tdcxrqb5b@skbuf>
Date:   Wed, 02 Dec 2020 11:51:19 +0100
Message-ID: <87mtyw7a6w.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 12:07, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Dec 02, 2020 at 10:13:54AM +0100, Tobias Waldekranz wrote:
>> +
>> +	/* Link aggregates */
>> +	struct {
>> +		struct dsa_lag *pool;
>> +		unsigned long *busy;
>> +		unsigned int num;
>
> Can we get rid of the busy array and just look at the refcounts?

We can, but it is typically 4/8B that makes iterating over used LAGs,
finding the first free LAG etc. much easier.

> Can we also get rid of the "num" variable?

It can be computed but it requires traversing the entire dst port list
every time, as you can see in dsa_tree_setup_lags. We need to hoist the
lowest supported num up from the ds level to the dst.
