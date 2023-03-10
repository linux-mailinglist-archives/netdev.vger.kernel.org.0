Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA2B6B4471
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 15:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjCJOYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 09:24:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbjCJOX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 09:23:58 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9722522103;
        Fri, 10 Mar 2023 06:23:07 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id k10so20990893edk.13;
        Fri, 10 Mar 2023 06:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678458185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b0N4c8RzStlD0JxB1+41A9nyPhBf4fP0Je+CMQzn+Z8=;
        b=W6bcBl5CKrt67qB2SRJiUImKzE6LS+SJqawqQZTzlwmvMCbAu5Y4WM5GZVyCvHY65g
         ZaonHiMjDxnvDaP64MOo+bsE+qcQWirx887iwqX6rRCckuUsZN0azq32siv137vQmh0a
         1GN2U1IH1r9HEaqCeVCjarC10Vs2ONU386o5InCcOAP7OcemSGIy3xlUApgTgKbN5fDJ
         FMPE/k+K7NfGSPzoNMV75TH1/N7IxGUtZwuGzfGAa7+a5DXUXar6BgYZw888eLuxdzht
         5TxNJCJI3eUsd4+/WVlE6p+RRa3rc03oTqiyFxsLMTpPZG7dmHVC7q1UCsEZYry9QOhc
         mFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678458185;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0N4c8RzStlD0JxB1+41A9nyPhBf4fP0Je+CMQzn+Z8=;
        b=bgZJxXKYfboz4KJtZxrDXINgDAVllm4V4nqSDRo8n4AvL8qee+2vEse1XRHhCBVHLz
         e20DHF9w6a8Fa5sm646btUKtMTD6lEf1RZTXSJkFxAoQRyP3g7J78aUWX4GsWIIX2ChJ
         1WWqQttpR45N7TBGLB1+vpbtTCwChzBHF6NWqoquLRIwENmM9jw9IgoLy9u6CWnE3JHU
         DHYAJhtXBGPXy0WrwBwA4gezfNjps/x9NOQkxyQOvNxs+Henak3B796sU1LvyTJtithe
         hvX4GqfpIPuxgAI8vfSHCKvDsCrB/vqvNW09MhUGvSWW4TIYDTmd8yXkg5gIaGbaXm7u
         vYGg==
X-Gm-Message-State: AO0yUKWgdfNVxCJ8dIgZC3Nr7yjSwaeq+VXpvvAwNzqlXwUvocf9f58h
        ti45JVUpXMZod4TvdVwhv8E=
X-Google-Smtp-Source: AK7set83fhAm0ZXjq6UBXKkcdgMNQBJPlOc5BULKrhyG2bZq3diQwKivtbuHPjY0Ym0WSNePvEztrQ==
X-Received: by 2002:a17:907:94ce:b0:907:183f:328a with SMTP id dn14-20020a17090794ce00b00907183f328amr31845122ejc.65.1678458185266;
        Fri, 10 Mar 2023 06:23:05 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id z26-20020a1709067e5a00b008c673cd9ba2sm1006868ejr.126.2023.03.10.06.23.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Mar 2023 06:23:05 -0800 (PST)
Date:   Fri, 10 Mar 2023 16:23:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: Re: [PATCH 2/7] net: dsa: mv88e6xxx: add support for MV88E6020 switch
Message-ID: <20230310142302.6k2nybmjmfzow7r4@skbuf>
References: <20230309125421.3900962-1-lukma@denx.de>
 <20230309125421.3900962-3-lukma@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309125421.3900962-3-lukma@denx.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch has a prefix of "net: dsa: mv88e6xxx: " but the previous one
has "dsa: marvell: " even though it touches the same file. Please use
a single prefix consistently, I would suggest "net: dsa: mv88e6xxx: "
since that is what this driver uses in the majority of patches.
