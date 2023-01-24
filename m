Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300FC6796D6
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 12:42:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbjAXLmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 06:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234244AbjAXLmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 06:42:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B9E3B652
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:42:00 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id g11so12479356eda.12
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 03:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yeBk2oTqxjs94yIGjzSu7p0Q0VqviO+iBLaR2P5DC24=;
        b=NqWDRIzkPwm9hIf6yBAL4JvVcZXbjtgeioGW3hZckQBIColwLfX1LgOVxAn4KQc53K
         ex9W9VM679jykw8fYpQZWUbfPar5MpL/NiGRIzujmzY8+F8VkQ9aSbr/RDD8RfAYV+UO
         BuXMQSbrXsCSUe9gOqR0c1sSHhZVwpI0VJqbr8Y4sWnRuh8B1Mp8LiivRK+vxd44poCI
         HyK+/8Kd2tt0dXKbrVDECOkvLHIapiKLRm1l3WoNlTjS5CrXtZyMNcxAgdVwzwknEQQ2
         H653OQCIXAa0/BZlmOzSy4O6BrGvQ694SQDvQHIx4RehGcRnpkRKlQcrszSlecGDq+ho
         j5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yeBk2oTqxjs94yIGjzSu7p0Q0VqviO+iBLaR2P5DC24=;
        b=XIXRxUK327QFruZrsybXKN+vyymtnOiPyY05/OTJTtrBmzv/RLs/eUSnZShR7QvHI4
         +4O9fTQ/+Jv6wOcojUhycnprzJEpW6inyQrz7s8GNnI4ksrc52HGtlcmaWRXlQOFzKkK
         k5INi1acCLSmOe83QwS3QQwojHsQsnQg2zqeHsiIJl7SdKk5n6TlEBOZREw5pcNrp4ev
         +n8NXw9GEAKYP4LeyEwLIBD4aX8RLXZeG6kdBWXnqrVwqufMaLj8slhi5D9qy6rKjhrE
         Bn9UA0V1ibwYFGzss9ILHAE/Y4NLOVMys9im5F2iZ3NunAiN/CCKDEftSVf1kZEx01Hg
         p++Q==
X-Gm-Message-State: AO0yUKXXDY3gkMClxEh//2znRq+hr6kB8eWp25EoYczy7rTYSATPXjUV
        PAJkfo+sg5zUjec7d6B7boAmN9dAB+o=
X-Google-Smtp-Source: AK7set97Lh2GeRJC6c7FdTTZcOhwBoQQvEF8LETiT0eICEhuFYRpYygrXxc2DPLzYFgamg6rtqoWRQ==
X-Received: by 2002:a05:6402:550f:b0:49f:da00:47a5 with SMTP id fi15-20020a056402550f00b0049fda0047a5mr2455638edb.25.1674560518644;
        Tue, 24 Jan 2023 03:41:58 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id p4-20020a056402044400b0048ecd372fc9sm960209edw.2.2023.01.24.03.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 03:41:58 -0800 (PST)
Date:   Tue, 24 Jan 2023 13:41:56 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Angelo Dureghello <angelo@kernel-space.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
Subject: Re: mv88e6321, dual cpu port
Message-ID: <20230124114156.ua4koty3xvu5xsfx@skbuf>
References: <Y7yIK4a8mfAUpQ2g@lunn.ch>
 <ed027411-c1ec-631a-7560-7344c738754e@kernel-space.org>
 <20230110222246.iy7m7f36iqrmiyqw@skbuf>
 <Y73ub0xgNmY5/4Qr@lunn.ch>
 <8d0fce6c-6138-4594-0d75-9a030d969f99@kernel-space.org>
 <20230123112828.yusuihorsl2tyjl3@skbuf>
 <7e29d955-2673-ea54-facb-3f96ce027e96@kernel-space.org>
 <20230123191844.ltcm7ez5yxhismos@skbuf>
 <Y87pLbMC4GRng6fa@lunn.ch>
 <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7dd335e4-55ec-9276-37c2-0ecebba986b9@kernel-space.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 08:21:35AM +0100, Angelo Dureghello wrote:
> What i need is something as
> 
>         eth0 ->  vlan1 -> port5(rmii)  ->  port 0,1,2
>         eth1 ->  vlan2 -> port6(rgmii) ->  port 3,4
> 
> The custom board i have here is already designed in this way
> (2 fixed-link mac-to-mac connecitons) and trying my best to have
> the above layout working.
> 
> If you have any suggestion on how to proceed, really appreciated.

The way this would have traditionally worked prior to having UAPI for
fine-grained user port to CPU port assignment was to declare in the
device tree that port6(rgmii) is a user port. This makes eth1 see
DSA-untagged traffic. Then you put port6 in a bridge with the other
ports, and isolate just ports 6, 3 and 4 in the VLAN that you desire,
and eth1's packets will be forwarded just to ports 3 and 4. Control
packts (STP, PTP) received over ports 3 and 4 are still trapped to the
CPU port (port5).

For some use cases, on LS1028A we still need to declare one of the CPU
ports as a user port. To achieve that, we take the existing upstream
device tree (which declares both CPU ports as CPU ports) and remove the
"ethernet" property from one of them, dynamically, from the U-Boot shell:

=> tftp $fdt_addr_r fsl-ls1028a-rdb.dtb
=> fdt addr $fdt_addr_r
=> fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet
=> tftp $kernel_addr_r uImage
=> bootm $kernel_addr_r - $fdt_addr_r
