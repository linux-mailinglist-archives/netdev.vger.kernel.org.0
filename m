Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51FEC6430A9
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiLESlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:41:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiLESlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:41:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37E920BF1
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:39:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t18so1910214pfq.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 10:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8iNUxISKm9B6PM1Q9SGEe43OjFNmt1sRChUTn7Yj4o=;
        b=5brn8FYikApKr0TLaCPaEQYiGKeWQp1YE3xKi67ke1RMXKuaz1OBt5CFgaHu6FJ1do
         Bni2ImFP6kmo1K4oB1e4oT/XDeLId7b4qbtZPfuX3gxXNcZsD9u3PiN/sfhm9lA8/9uC
         hVhO9QdrdKYZVZIx7j7zcaczc8h7HjNwWm/zENXfLUu4U8NrfQQzbaepGb3ZTWvb1DS5
         BLdszZfoWfONJ/QcTAurSi7nvwpYryj9Y6eV8KlbESrAYJ1KeNMU2AJT1rZNxah+YBtC
         na+Goqfx01XuqnKHUgsYPc3qqPWftdFs5GlWcWEvzjdl7N4B2sNnzOBED5Fevru32ffi
         yHvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u8iNUxISKm9B6PM1Q9SGEe43OjFNmt1sRChUTn7Yj4o=;
        b=N/9xTLX+Ohn5Ln9W4TumQs9ZUid/0olSDucxUsbwSEmQlmhGOTwlZ2BiRj2Td+JZom
         qnp9kgE6nlenWz7S1NiOBlhR6j2HLMnDml8ecjTSd2+FctiUv3QFRI+nHTLKq4P6U8m8
         dhh06qqJZ+1k+cEQn9TPxiSKx3G7Qjm1t6MdYBwmwfpSPAao1fViZkjw0hzaBYXef48F
         /V7/8CSIFNYybk5QHff6S5o2hqaWXmHecl1G94IOcXNrNadcvmFpzfpgViHnwqFMUDvM
         yljYSLiMhe5yowMFA76gIddyUzngCK3CtR1tE4Klsz9LFRlBGPNFWkYCG9NSCOM2yL0j
         BDzw==
X-Gm-Message-State: ANoB5pmHdqKcjLWEm7Yoocc4N22G8wX8kFLGmFzFfYTaU/kxx/gJ3v2X
        2n9WkF28wp6sTmHR6z/PmFydtQ==
X-Google-Smtp-Source: AA0mqf6SIitPcDbOH0WoYCnbNDEQ7Q2Atx4/aKmeDSdK2dVmooeU2eVHPxFW2/uftXmHnRK6LZXaBg==
X-Received: by 2002:a63:195a:0:b0:477:c9d9:f8a0 with SMTP id 26-20020a63195a000000b00477c9d9f8a0mr49707918pgz.228.1670265548123;
        Mon, 05 Dec 2022 10:39:08 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y17-20020a17090322d100b0017f73dc1549sm10971902plg.263.2022.12.05.10.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 10:39:07 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:39:05 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        LiLiang <liali@redhat.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>
Subject: Re: [PATCH net] team: prevent ipv6 link local address on port
 devices
Message-ID: <20221205103905.1b2fa96a@hermes.local>
In-Reply-To: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
References: <32ee765d2240163f1cbd5d99db6233f276857ccb.1670262365.git.lucien.xin@gmail.com>
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

On Mon,  5 Dec 2022 12:46:05 -0500
Xin Long <lucien.xin@gmail.com> wrote:

> The similar fix from commit c2edacf80e15 ("bonding / ipv6: no addrconf
> for slaves separately from master") is also needed in Team. Otherwise,
> DAD and RS packets to be sent from the slaves in turn can confuse the
> switches and cause them to incorrectly update their forwarding tables
> as Liang noticed in the test with activebackup mode.
> 
> Note that the patch also sets IFF_MASTER flag for Team dev accordingly
> while IFF_SLAVE flag is set for port devs. Although IFF_MASTER flag is
> not really used in Team, it's good to show in 'ip link':
> 
>   eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>
>   team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
> 
> Fixes: 3d249d4ca7d0 ("net: introduce ethernet teaming device")
> Reported-by: LiLiang <liali@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

The failover device probably needs the same changes.
Does anyone use the failover network device? Looks like KVM never got support for it.
