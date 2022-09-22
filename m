Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C92ED5E670E
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbiIVP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbiIVP27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:28:59 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7925CF8FA1
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:28:57 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id b23so9638549pfp.9
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=KswiHudIP7D/CB8WXvLVWCTMlOtsuwtARdZEaSRmY84=;
        b=HohkanOrDDbOxqYJ8iePzrj+3clbMEZEC+IlZz8iyQHkTuTQpvhHSSth3RYZhiB39S
         d+Cgaef6WNSMKHOpcBT5uxvTfe6Ar+lTf1M8ngsf+MCpKGADKlLZ4EhZ1sNCpTV9tHKe
         8rs1xDzM9iaqtemhZaWKDToqjxDno8Tu8ej3kYwgXIqgqR6xNAc6hdPuhElJel66swoR
         oGGYW6z1vVILnxNhkL892qiW5T3DQjHoPJoceuL+aXpad43ssnEYDQqxkygjrTF7MJbD
         ZzPSGNBe7cZHxQV2Vjygp5pzRo2XXXLtTJGOaqpMI8fDJagGi3+bRM3sL9ybtAKwdYZj
         1duw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=KswiHudIP7D/CB8WXvLVWCTMlOtsuwtARdZEaSRmY84=;
        b=LIE9o4OrZq7TcHQQgXqtOKwcir5ozQYv5ZMOo2VqKz0jJsrDJiPZgzVM3eB1SLHCV2
         M6jeA1e8SGnMdGahSK3gaclB66YPsRpqYCM24bSAAC2solYyHagrJPWgl1KX5OSFntAD
         cOZ80amkDkLkK0zdRCbfWncCKXDFz8xzAQLl/IBeuVbMYleyblQ6B7u9YmXWI6gaBFhW
         5rDZiB8bCI9ZyzFTvR6C/9UCNfGpAmVoEOIJeHOzhWuT30ixQqqz99+kweCbclT68+yC
         2IqmVdHUM21/Rnl3hIldBBxfZnNou8GE7f7c1H6+zzb5Y6wmcHMnLwRrJHoBgX/3Fm3Q
         3Pow==
X-Gm-Message-State: ACrzQf1BtusPJMafwoV1u8O0jNrnUvvMkG/Pk2OeXZt96XvTkT4Osxnu
        G0OtxUrsPvnbXpAPVa86bFZ0YA==
X-Google-Smtp-Source: AMsMyM7RTY1XRFetYkAYRn/iX08VrTkOPPek9hFl55L3E97MqdgooK0RzzNDnT+m5/cd1QtaTySydQ==
X-Received: by 2002:a63:3686:0:b0:43c:dab:7c36 with SMTP id d128-20020a633686000000b0043c0dab7c36mr3390689pga.196.1663860536949;
        Thu, 22 Sep 2022 08:28:56 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id u15-20020a170902e5cf00b0016d6c939332sm4164542plf.279.2022.09.22.08.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:28:56 -0700 (PDT)
Date:   Thu, 22 Sep 2022 08:28:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Benjamin Poirier <bpoirier@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH iproute2 1/4] bridge: Do not print stray prefixes in
 monitor mode
Message-ID: <20220922082854.5aa1bffe@hermes.local>
In-Reply-To: <20220922061938.202705-2-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
        <20220922061938.202705-2-bpoirier@nvidia.com>
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

On Thu, 22 Sep 2022 15:19:35 +0900
Benjamin Poirier <bpoirier@nvidia.com> wrote:

> When using `bridge monitor` with the '-timestamp' option or the "all"
> parameter, prefixes are printed before the actual event descriptions.
> Currently, those prefixes are printed for each netlink message that's
> received. However, some netlink messages do not lead to an event
> description being printed. That's usually because a message is not related
> to AF_BRIDGE. This results in stray prefixes being printed.
> 
> Restructure accept_msg() and its callees such that prefixes are only
> printed after a message has been checked for eligibility.
> 
> The issue can be witnessed using the following commands:
> 	ip link add dummy0 type dummy
> 	# Start `bridge monitor all` now in another terminal.
> 	# Cause a stray "[LINK]" to be printed (family 10).
> 	# It does not appear yet because the output is line buffered.
> 	ip link set dev dummy0 up
> 	# Cause a stray "[NEIGH]" to be printed (family 2).
> 	ip neigh add 10.0.0.1 lladdr 02:00:00:00:00:01 dev dummy0
> 	# Cause a genuine entry to be printed, which flushes the previous
> 	# output.
> 	bridge fdb add 02:00:00:00:00:01 dev dummy0
> 	# We now see:
> 	# [LINK][NEIGH][NEIGH]02:00:00:00:00:01 dev dummy0 self permanent
> 
> Fixes: d04bc300c3e3 ("Add bridge command")
> Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
> ---

Looks good, reminds me that the bridge command need to be converted
to use json_print.
