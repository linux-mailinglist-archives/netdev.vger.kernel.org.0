Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EBD5811DD
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238398AbiGZLXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238492AbiGZLXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:23:50 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61E023245E;
        Tue, 26 Jul 2022 04:23:49 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id z22so17334113edd.6;
        Tue, 26 Jul 2022 04:23:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WYhFupqcqv33587GQRbJ/WysXydvniDXTfxLytVykR0=;
        b=UYPdT4QIa6dfNDbKkTvEdZ97T1JK4Ee6rNZLgbxpAErNke6wSfFRJ7bwLdhbmGxUCy
         hv5f9fW2TbshJThbh/36HYhusMPD35NcY+EhXBQBIR0ymies2iiAYbfi1hIJfAM29Igh
         s4eHxT4vkXgUFj4qJbHwXSYKtPlgSmbB6rFjHM5oLd1/C2ocjlA1PqnVL8ccU3wFWnmu
         tkehv33IN6YCO+8U+zZ8/4fcAlOwnWnGpagDO88G/7FXRzgJs4IkecPfFXWSzIz6LMp7
         BqJqpokUqZiFt04EQPgP9e/WVGYyt9MOfWKnhqC6pFOXD1BiFDe2Io7d9toLm6IdQc29
         hv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WYhFupqcqv33587GQRbJ/WysXydvniDXTfxLytVykR0=;
        b=U0VGwurQIawKXFtWFWTYnrci1E1jzanDsXKWc/LagFABWG3qWcdnf5/S4/lKhaky9x
         WgVyk1r8unacVIPzsHQsmW3N067NKIcLUJbcyujEVMB/j1RpokAkjaEA7I8BLmbPKjpS
         w9on6C8HWGJlNOHqOOUa56FsdAhgaInYZ1fFodSADBzFKko8CoXzjzGacgWtGSfq0+CL
         0TvMv44fdhvPfwZEdiRxIVJ8s9c2w96jZILpI3ymOLbz+cF4cXjsCB/GEDaKl+0IyOlQ
         47D0UXQJbZZiBrOo4gGrz+P0wciriihGtCIVTmRJc1Y2nQl6RMbqfw8lVkCCMNBzZHQ3
         0sPg==
X-Gm-Message-State: AJIora/O7NPy9yC5z/bUAxj+LVLcWHNrY37nxQPzLsLWfWzcpYE8RL4r
        Hf9c44VlvDxzfhy2z7DOLV8=
X-Google-Smtp-Source: AGRyM1u8vkJU9CdWgItodLlq8EDdNj8yIPQBE2xV5/z9l7yjjtw6XOLB3p9vYetqSgp2rYJgU9Kn1g==
X-Received: by 2002:aa7:d994:0:b0:43b:d187:69fd with SMTP id u20-20020aa7d994000000b0043bd18769fdmr17753201eds.201.1658834627673;
        Tue, 26 Jul 2022 04:23:47 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id d11-20020a05640208cb00b0043a7c24a669sm8401349edz.91.2022.07.26.04.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 04:23:47 -0700 (PDT)
Date:   Tue, 26 Jul 2022 14:23:44 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220726112344.3ar7s7khiacqueus@skbuf>
References: <20220725214942.97207-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220725214942.97207-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Jul 25, 2022 at 02:49:40PM -0700, Florian Fainelli wrote:
> Hi all,
> 
> Although this should work for all devices, since most DTBs on the
> platforms where bcm_sf2 is use do not populate a 'fixed-link' property
> for their CPU ports, but rely on the Ethernet controller DT node doing
> that, we will not be registering a 'fixed-link' instance for CPU ports.
> 
> This still works because the switch matches the configuration of the
> Ethernet controller, but on BCM4908 where we want to force 2GBits/sec,
> that I cannot test, not so sure.
> 
> So as of now, this series does not produce register for register
> compatile changes.

My understanding of this change set is that it stops overriding the link
status of IMP ports from dsa_switch_ops :: setup (unconditionally) and
it moves it to phylink_mac_link_up(). But the latter may not be called
when you lack a fixed-link, and yet the IMP port(s) still work(s).

This begs the natural question, is overriding the link status ever needed?
It was done since the initial commit for this driver, 246d7f773c13c.
