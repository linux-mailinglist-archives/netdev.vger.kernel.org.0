Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30D652833D
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 13:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241287AbiEPLal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 07:30:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241458AbiEPLai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 07:30:38 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6599038D9E;
        Mon, 16 May 2022 04:30:35 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i19so27989770eja.11;
        Mon, 16 May 2022 04:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ii2fM3gUVndtKTi/w7gWvxmj+IqrSTy934UWhzf9y2g=;
        b=HmhOl8KiQKjqCnqk/GXUePnYMCMcxSD3lRw+3qwseR9Hvmpt1gr+YWTXgsBK0iESXH
         AOcenB8FYWLzmBURDXRIMAB/nmnT5kDQOkUp3QlBqWYvuF3BKmBtVtlnLp++SyAwqyn6
         KnvTIE7WZJ/HqLtAFcbQL6Fcra/HQYQ6NYYAf7XPOMeE4e2yjLPnAXQo2GrUGAz7qCTT
         apOJHoDJvTBKyVO5AllNo9jeL+lhK9/+atsMscT7/RHR7FED+EV9qQsR+FOGirFAbKfc
         hw16P89bAv0+EpaI7Uj+PIf5cABPKqs7lCDo5T84/ATtN4itm/qKOhn7y8CAh7lbym7s
         iZEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ii2fM3gUVndtKTi/w7gWvxmj+IqrSTy934UWhzf9y2g=;
        b=H64dXNN51SjidjrNRvzgyxkcqOpL/m6gsf7SsCeOtz8td0OG/JBWc4QYF5oVIkJUyi
         /hfRO/pMvaTEOk7YpyJymh2MBGWvxEcJxHlfuK/O7ORLUoJsva6NV58SjTZZo/N+TpQ9
         KIkOLOOqOpmieQbqiR8kesOlEzMpZi+AYHiu9ljFb7vM3cKSjiqsH94luzdf4ISb5suB
         3YqDyzfS7JV0ToOV2Lxpe9JrfkOjeR+P2uFPnvnRRazCfuLQSpp9LBbcgseZD0WMLZYQ
         G5z1y6g9+uB+YFlNsEv+W8k3xCUl0G6gg2BLawOLwcX330dsV8YwZrYYQ08vkGqo4O7I
         5r5w==
X-Gm-Message-State: AOAM5323SvzregzigNnkycXAwHhTdiNgRXircXRIBhZrNUzpjwaw9YOx
        fqVzuoRnLonEZ5agh8uMePg=
X-Google-Smtp-Source: ABdhPJwzOybb5AJH+pjHeykN2uJyYgQ8kT/lOrKic9O1q1bsdkcNSQVZ6uwK+3hiiTAE1Aa4M2Gqmw==
X-Received: by 2002:a17:906:dc8d:b0:6f4:75da:2fc8 with SMTP id cs13-20020a170906dc8d00b006f475da2fc8mr14728863ejc.7.1652700633973;
        Mon, 16 May 2022 04:30:33 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id i6-20020a50c3c6000000b0042617ba63besm5130657edf.72.2022.05.16.04.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 04:30:33 -0700 (PDT)
Date:   Mon, 16 May 2022 14:30:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Marek Vasut <marex@denx.de>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [RFC Patch net-next v2 9/9] net: dsa: microchip: remove unused
 members in ksz_device
Message-ID: <20220516113031.mygxtowcobq4lpum@skbuf>
References: <20220513102219.30399-1-arun.ramadoss@microchip.com>
 <20220513102219.30399-10-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513102219.30399-10-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 03:52:19PM +0530, Arun Ramadoss wrote:
> The name, regs_size and overrides members in struct ksz_device are
> unused. Hence remove it.
> And host_mask is used in only place of ksz8795.c file, which can be
> replaced by dev->info->cpu_ports
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
