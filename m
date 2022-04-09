Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8DC4FAA87
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 21:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiDITtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 15:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiDITtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 15:49:06 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B3617E27
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 12:46:57 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j9so12186559lfe.9
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 12:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ylyncROvAk3qV8KCnWJolGLTwdVCttiZ9ZwX45cLPsk=;
        b=zByb6R+T6m+ifm3CbMxA9kc/6IhHHh7NmS2qakuuPoix6vo+6avqDDvLiDS/tqG/R7
         3hD73Q9wRALIpvyGG6QzjllizNKI/kl+NJ7TvBaRZlfggW0D6GQSnoKCD1eKPICMhN7R
         BJ8Wxmh3t/Iqua/FZ3agrZw2DCn5iYw/YnBjLr7ywfmuHMlUhgOtKMNZUmygdQBAkX/J
         zZlKUsGuaSKql53jqCaziS434NlwhtuUoobegxyR65wueXt2QKQ7x8sgLWRdDUGE05xy
         AM1gzeffhPF6aMVC3XOYlw0w6/zgrou1O4SltugDt0iuz43bLu8GcrfIObrJ+37O0QY8
         LPpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ylyncROvAk3qV8KCnWJolGLTwdVCttiZ9ZwX45cLPsk=;
        b=hH97YEUGAyxhoVfox2AuOBOebUSzYUE6F13hNfIQqNp9cY5LMOGLnz1ytjb7Nsz1GW
         PkoZGrKI0zB+8GsUw4SXfk9KNOSdj7iiwEFggc+k+OKt2Utjyom3k1tKj7kegKWaU+88
         yBK3uir4h1gnt/EYm8GfHM4kJRETdIR6Ne00Mff54dpHKOg6u+kMY7vk/TMxEqw0n6XK
         vpFDoZchlej/CR6+H5q8w3jABq8flZjNEhTkIiD0DUhz0XmZk+h15BZKii91ScZHGlDG
         +TZO86e/U8bnChrEcpydLOdu/XCuwLkulhVRCsMMUgp4ANWShK1oCICyKfFU+Z2ndFC9
         quZA==
X-Gm-Message-State: AOAM530CKVwYae0APyhycvD7rUbPcnqtEq8NhsGzaG8bjdT6tUuTvIBt
        FzzwaF+FPhVtEOI/do+fMtouqQ==
X-Google-Smtp-Source: ABdhPJzbPPaXtCqNPzbuDdi6QJSxDz6FX5+jG62eU6D60lkrUUKcoGWfeGQxgyedDbLLEDTuIStt3A==
X-Received: by 2002:a05:6512:3c96:b0:44a:3c85:ddb0 with SMTP id h22-20020a0565123c9600b0044a3c85ddb0mr16407160lfv.457.1649533616124;
        Sat, 09 Apr 2022 12:46:56 -0700 (PDT)
Received: from wkz-x280 (h-212-85-90-115.A259.priv.bahnhof.se. [212.85.90.115])
        by smtp.gmail.com with ESMTPSA id d12-20020a05651233cc00b0044a24fdd890sm2799724lfg.192.2022.04.09.12.46.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Apr 2022 12:46:55 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Mattias Forsblad <mattias.forsblad@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: Re: [PATCH net-next 0/6] Disable host flooding for DSA ports under
 a bridge
In-Reply-To: <20220408200337.718067-1-vladimir.oltean@nxp.com>
References: <20220408200337.718067-1-vladimir.oltean@nxp.com>
Date:   Sat, 09 Apr 2022 21:46:54 +0200
Message-ID: <877d7yhwep.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 08, 2022 at 23:03, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> For this patch series to make more sense, it should be reviewed from the
> last patch to the first. Changes were made in the order that they were
> just to preserve patch-with-patch functionality.
>
> A little while ago, some DSA switch drivers gained support for
> IFF_UNICAST_FLT, a mechanism through which they are notified of the
> MAC addresses required for local standalone termination.
> A bit longer ago, DSA also gained support for offloading BR_FDB_LOCAL
> bridge FDB entries, which are the MAC addresses required for local
> termination when under a bridge.
>
> So we have come one step closer to removing the CPU from the list of
> destinations for packets with unknown MAC DA.What remains is to check
> whether any software L2 forwarding is enabled, and that is accomplished
> by monitoring the neighbor bridge ports that DSA switches have.
>
> With these changes, DSA drivers that fulfill the requirements for
> dsa_switch_supports_uc_filtering() and dsa_switch_supports_mc_filtering()
> will keep flooding towards the CPU disabled for as long as no port is
> promiscuous. The bridge won't attempt to make its ports promiscuous
> anymore either if said ports are offloaded by switchdev (this series
> changes that behavior). Instead, DSA will fall back by its own will to
> promiscuous mode on bridge ports when the bridge itself becomes
> promiscuous, or a foreign interface is detected under the same bridge.

Hi Vladimir,

Great stuff! I've added Joachim to Cc. He has been working on a series
to add support for configuring the equivalent of BR_FLOOD,
BR_MCAST_FLOOD, and BR_BCAST_FLOOD on the bridge itself. I.e. allowing
the user to specify how local_rcv is managed in br_handle_frame_finish.

For switchdev drivers, being able to query whether a bridge will ingress
unknown unicast to the host or not seems like the missing piece that
makes this bullet proof. I.e. if you have...

- No foreign interfaces
- No promisc
_and_
- No BR_FLOOD on the bridge itself

..._then_ you can safely disable unicast flooding towards the CPU
port. The same would hold for multicast and BR_MCAST_FLOOD of course.

Not sure how close Joachim is to publishing his work. But I just thought
you two should know about the other one's work :)
