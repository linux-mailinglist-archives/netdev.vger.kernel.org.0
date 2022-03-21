Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971D74E33B3
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 00:11:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbiCUXKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 19:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbiCUXJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 19:09:15 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5504E40C2CF
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:57:01 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b7so11353666ilm.12
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TdNlSMywY5dPT3xGYRT5dMhqNPmTRCENX2z/JgdMXr8=;
        b=ksDEoj9c4zCwIHUlgTViS0OKP5x3NGVM77uPQjf1hTSBLs4spw6GVhT9cezZ3YBIV0
         1H7lG6syyPWEExgmYrFaJTs+FL8kEnIbyZcesgtq9yGtoWiLGQsAbRy7IXouK6OAV8Su
         KiA6LR9nX/0hTX2RvlCdy6RP/USIP087U/q3q1aZYjdIXTI8t1R3ZQUSuY0xZv2SsOFe
         ahDcDaOnk+ZEO8W+oj4dlJ9yodG+CkUi0AYMaLCzh9XDVK3cjXEn2OAlu55Ajuig/d7c
         qkCa9CUv7aDrJr0IFTGRgRceXguD4e3Eu2gipeIQeSMFcfvspVKv3tMXcgat73eO60QC
         v+Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TdNlSMywY5dPT3xGYRT5dMhqNPmTRCENX2z/JgdMXr8=;
        b=Vs0+pIp4ISR0zcO1C48GPvYImNBuXAoPkcVKtX4QNJxpn/2rx2c/05cJx8bliGtOMT
         h5s1U/cCFWMRUcEytUKnpi0lLJ6UGtugfCteovnif1iYgq25YDkrImA1KBoD4wvIPuPa
         5fUTKKw3RWpgPHBaz+JW1Q2tAkKDN5zEl6Mqqnr4HXdY5m9PkVaIlxUFknZSDbxZNSxi
         vs7gUiLLRAxnHLBVULtIZ9eHLpgRPWXwa9NdaJjDpjdMM/vxJb4h0x8GwnD0ALJ4wbJB
         ZcR4SEU0lk8Caehx6ipz6R+zMOmNh7TfuO8oUp7ZgoDXYi2v3ticAvaIn/CM28oLEr7g
         Usig==
X-Gm-Message-State: AOAM532oMiqWlXksbwDytJzQKHvCf3BPnSA5OeLTdRiEjpdWb9mBYJa7
        rzK2sPeGY0oYu4CVmiRYCQfe91mcVvb6bA==
X-Google-Smtp-Source: ABdhPJyyM+TIYnaOZ1ahZo5ewABTFb6noRVSCI40uLzoZFUnU3b+uazy5qTHMAGGaCb2T6TwEbeq9A==
X-Received: by 2002:a63:eb51:0:b0:382:53c4:bb66 with SMTP id b17-20020a63eb51000000b0038253c4bb66mr9281733pgk.540.1647899100292;
        Mon, 21 Mar 2022 14:45:00 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id ob8-20020a17090b390800b001c6a1e5595asm384681pjb.21.2022.03.21.14.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:44:59 -0700 (PDT)
Date:   Mon, 21 Mar 2022 14:44:57 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [RFC PATCH net-next] net: create a NETDEV_ETH_IOCTL notifier
 for DSA to reject PTP on DSA master
Message-ID: <20220321144457.7dc6e8e0@hermes.local>
In-Reply-To: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
References: <20220317225035.3475538-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Mar 2022 00:50:35 +0200
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> The fact that PTP 2-step TX timestamping is deeply broken on DSA
> switches if the master also timestamps the same packets is well
> documented by commit f685e609a301 ("net: dsa: Deny PTP on master if
> switch supports it"). We attempt to help the users avoid shooting
> themselves in the foot by making DSA reject the timestamping ioctls on
> an interface that is a DSA master, and the switch tree beneath it
> contains switches which are aware of PTP.
> 
> The only problem is that there isn't an established way of intercepting
> ndo_eth_ioctl calls, so DSA creates avoidable burden upon the network
> stack by creating a struct dsa_netdevice_ops with overlaid function
> pointers that are manually checked from the relevant call sites. There
> used to be 2 such dsa_netdevice_ops, but now, ndo_eth_ioctl is the only
> one left.
> 
> In fact, the underlying reason which is prompting me to make this change
> is that I'd like to hide as many DSA data structures from public API as
> I can. But struct net_device :: dsa_ptr is a struct dsa_port (which is a
> huge structure), and I'd like to create a smaller structure. I'd like
> struct dsa_netdevice_ops to not be a part of this, so this is how the
> need to delete it arose.
> 
> The established way for unrelated modules to react on a net device event
> is via netdevice notifiers. These have the advantage of loose coupling,
> i.e. they work even when DSA is built as module, without resorting to
> static inline functions (which cannot offer the desired data structure
> encapsulation).
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Why is this not using netlink? 
