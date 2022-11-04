Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9451618E30
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 03:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiKDCUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 22:20:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiKDCUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 22:20:06 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51022DF4
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 19:20:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y203so3319927pfb.4
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 19:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=btmbZscjcgDV6gMUkQqZSyJ7vtSOlzDWHe+5X4DPrdw=;
        b=Z9ekQ021oBqePrZb0PF85YgRCJdpGZ83zP2Q6+YbtdzK5IIDLfkC1zQOaqtVEwUccq
         CxQWDQQQwW+9FVibWg8vkXorcy8CwvyX+F/wNf1/+H0aHTddP3cawWdk9o5RJ0tbqfOP
         FvnkZHZkPOrbDsOkt3UfXyxcUWFzhMJ2VSd9+wpfIHGsDULeeNhTBfniAE9Z9u5RBx2E
         YVZXLbMssRgNNwrSiAyxc1PZYC9RmVOZlIWQ942aHS+504sCbndzulXdEuhqHhWAAZmz
         Kp1N9A7AJEWxpi8ufprZ8ICsVkg+Lk90VrTcDV69pV1bPlLioO34HBYgviUL3rgbErPr
         69vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=btmbZscjcgDV6gMUkQqZSyJ7vtSOlzDWHe+5X4DPrdw=;
        b=Nz1S/ZqhGjnz2O38Fx43Lz4LreOaQbxup5l+/E/Z0VQQ/33puQVTtKIdSy/cdMn1k0
         LV68DTyyErBaaE5XlBKHiYdR4u6MwRXZ4v1u5IXudQd3CtPT6IunMS0qenDQAzOM0eW6
         TX1hh9sLF9iihAt3gxDy7SqOLIM2B1WjEQH4z5wOquUmIMgeQ8sOWh7wGy2Xuwqf9XfN
         Q6KaxOyHpVsYe2J2UEc/iMfVfpm4EtCMg3RkMgkOUKmqiNBGj0/iASk3gF1EU60tZ0at
         fjQNbJ8BYJiCUBL5Op2bAWIbiPK5zS+5Z6Jw1ZRuvrByufFU/X2eeXWOvPanRuyhpJqM
         i7HA==
X-Gm-Message-State: ACrzQf2rDeJkaybAe9nM1h0VlOaU6xS+Xv4Cj2zO/fyf3AdS+6BOXNOP
        molx7wxXrx/PqAflHIhIO358pQ==
X-Google-Smtp-Source: AMsMyM5pE3mmaw6/qeuvRgKXiqRLQoNflp8hzJhkbKTQRR8UnRot0vmPPJr/W6bRjbZzjMAiiP9ILg==
X-Received: by 2002:a63:5063:0:b0:46e:cd36:ce0c with SMTP id q35-20020a635063000000b0046ecd36ce0cmr29196390pgl.617.1667528401459;
        Thu, 03 Nov 2022 19:20:01 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id r18-20020a170902e3d200b00187197c499asm1326816ple.164.2022.11.03.19.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 19:20:01 -0700 (PDT)
Date:   Thu, 3 Nov 2022 19:19:58 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Ren <andy.ren@getcruise.com>
Cc:     netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, kuba@kernel.org,
        pabeni@redhat.com, corbet@lwn.net, andrew@lunn.ch,
        dsahern@gmail.com, sthemmin@microsoft.com, idosch@idosch.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        roman.gushchin@linux.dev
Subject: Re: [PATCH net-next] net/core: Allow live renaming when an
 interface is up
Message-ID: <20221103191958.2b9aa91e@hermes.local>
In-Reply-To: <20221103235847.3919772-1-andy.ren@getcruise.com>
References: <20221103235847.3919772-1-andy.ren@getcruise.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Nov 2022 16:58:47 -0700
Andy Ren <andy.ren@getcruise.com> wrote:

> @@ -1691,7 +1690,6 @@ enum netdev_priv_flags {
>  	IFF_FAILOVER			= 1<<27,
>  	IFF_FAILOVER_SLAVE		= 1<<28,
>  	IFF_L3MDEV_RX_HANDLER		= 1<<29,
> -	IFF_LIVE_RENAME_OK		= 1<<30,
>  	IFF_TX_SKB_NO_LINEAR		= BIT_ULL(31),
>  	IFF_CHANGE_PROTO_DOWN		= BIT_ULL(32),
>  };

It helps with developers memory if you change the line to something like:
	/* was IFF_RENAME_OK */
