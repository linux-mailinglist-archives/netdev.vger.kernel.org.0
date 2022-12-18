Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05518650517
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 23:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiLRWQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 17:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbiLRWQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 17:16:41 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3B85F80
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 14:16:40 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id d7so7325990pll.9
        for <netdev@vger.kernel.org>; Sun, 18 Dec 2022 14:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+nDChsAiauvTbVEjEy6+4uC6d/Qdg4vgddjYfyqQ9Xo=;
        b=mGK+PMgM1pZQQs/9Bu2754hwGDLH7/WmvhSNY20eHOI8H2XkLCpF3BnAcYW7LKK47n
         OGK83Zs7WwejNNqrs+QTsGqQV/pX01Z+/7PfUKOrhvusE2AyO2Lk3lvzFI1nwcuFRn18
         CnxX3eEwbHzk58BJW1JCQpkpfTGIDVDAqlO2wTxEgckbvKmxMyPlAgpT79fkQfbYqpxL
         lcFD+Sm/SlTJ6hunAZ3b2EBnco02emf66kxkbft7DxCJrFJrFBhbV8r31S07Dxx6UENu
         QvDanI56PocdRtIkNgKRR11DQl8gwwT/n3/qISJqGQr+pFNhiY+nPoyFNTnxsFTXbjGw
         WsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+nDChsAiauvTbVEjEy6+4uC6d/Qdg4vgddjYfyqQ9Xo=;
        b=gG6Qh84ax2gsbncd35W+Q8FyUB1aFqkp+xHT6s2/VRQrnrMrV8zJMRiqBf1Tk70TPy
         Jqgp2QaLS2upH1LdYhmOQx3mdWNqTR1SpdG8dvmvjWhgO8m8ZS7tfvVs/owJfJvdywZg
         W1MRwYxLxCbVIxCCA2Hw1rJy5pHOgE5jcHM5o/rY/iELPAVwSbJzgE2Pi7F96V7fR0rb
         L9s26m75f9ewx6IajvslihoVcJphxnZG11iLQ+eapf6bSKkOdM6jlc8PVlgLa/KJWSWh
         n9wflD6upOkkHhVFr2rVsk4bpQmv4b5Pyy6nmYhWGRjisLHZ4zHVmkoKlEMSrX5UV8Cw
         T0MQ==
X-Gm-Message-State: ANoB5pnq72O3KH9Df5kTmus/QgWrcATXbHJfmdhSafsZtByDGAzwHx0e
        bH8Qxy+uATSdO7JM/IBvLyizKA==
X-Google-Smtp-Source: AA0mqf7CXN00Ses2qziZ3zhPKmfMndGD/+v95rVYj5BnCqYIzvoGbHI3tMZe5kusamsvt8mRVm5whA==
X-Received: by 2002:a17:903:330d:b0:189:aedc:f6d6 with SMTP id jk13-20020a170903330d00b00189aedcf6d6mr39548113plb.28.1671401800402;
        Sun, 18 Dec 2022 14:16:40 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id p15-20020a170902780f00b00186b69157ecsm5504029pll.202.2022.12.18.14.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Dec 2022 14:16:40 -0800 (PST)
Date:   Sun, 18 Dec 2022 14:16:38 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, a@unstable.cc, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ip/ip6_gre: Fix changing addr gen mode not
 generating IPv6 link local address
Message-ID: <20221218141638.41d8d32f@hermes.local>
In-Reply-To: <20221218215718.1491444-2-Thomas.Winter@alliedtelesis.co.nz>
References: <20221218215718.1491444-1-Thomas.Winter@alliedtelesis.co.nz>
        <20221218215718.1491444-2-Thomas.Winter@alliedtelesis.co.nz>
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

On Mon, 19 Dec 2022 10:57:17 +1300
Thomas Winter <Thomas.Winter@alliedtelesis.co.nz> wrote:

> +	switch (dev->type) {
> +	#if IS_ENABLED(CONFIG_IPV6_SIT)
> +	case ARPHRD_SIT:
> +		addrconf_sit_config(dev);
> +		break;
> +	#endif
> +	#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
> +	case ARPHRD_IP6GRE:
> +	case ARPHRD_IPGRE:
> +		addrconf_gre_config(dev);
> +		break;
> +	#endif

Linux kernel style is to start any conditional compilation in first column

I.e.

#if IS_ENABLED(CONFIG_IPV6_SIT)

Not
	#if IS_ENABLED(CONFIG_IPV6_SIT)
