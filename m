Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C60B510CC7
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 01:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356183AbiDZXqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 19:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356179AbiDZXqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 19:46:09 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5EC7E59A;
        Tue, 26 Apr 2022 16:42:59 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bv19so139103ejb.6;
        Tue, 26 Apr 2022 16:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Whkd6X4Vda9pJlYGx1RfhTrFV98ApGBqMgpbLXTGqPc=;
        b=IE9MK8IQM8p6rFzyhrfmoQld/DH97yQM/z3Ok3DSHXeG6A2mM5jRA36DF/EWgStmKx
         NAD+dc1ZhwFJu08YUrPWnpKDM/A/gEkw07vCbYIlSe16+ztEdvKEY952MnnzlaweqE4v
         3iqFl52ZDj5LKdRSuH3oetbUNFBAzOQzIoJSPho0rbblo8MSdzsXdNlv6zb3cRvV8A9v
         3d8NZ/YPS+NP3c0wj3QwZyAebTzxxhUtDy+RO2fqNAFhNN7HsG7cO+Zqn5fD1/DXrayA
         jZXZJBZO64w9yE4846tLkJBFhPpg9P1Alf3S2cyt2U+VrvPsFwMpEiN8vE27DahgZlyw
         Tu7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Whkd6X4Vda9pJlYGx1RfhTrFV98ApGBqMgpbLXTGqPc=;
        b=cifuOT1MsjusGTwFdhLePahq6sI86OLeKpJN0+nmA13gc9Bg465dWWpcu9xKDDe93e
         jSrVoZxyOVVdB8x3EGOTSWwsK7ELD8Wn+PsaMkzWGluoGip4A+Rr6LgrmLDadUgjabEv
         ANBWM4srB/9grJcqTV+zQOn+N+UxXXMd1eApnpeGSJehzDu+4gH8aDhshrFh+fjWAtW/
         obdNqadPW17vlX+Fgd/LjIIYYyVcn7wLyXF9HthJjDOz25ElV/ItZ+A2JlyonlYlWUll
         iqcOMonvV/m741AV9XPfFoJPU/tNtoV18dA7bpo4g15GWB+zXFAgM/nY4FCnj/3cczgA
         Oc9Q==
X-Gm-Message-State: AOAM531j3MOnpa/dAKixId7zbDJ6AUzcvKg4tAQkT22nRSsL01PTTf62
        xjoHF6jnsKyC9yzmWTCaVM8=
X-Google-Smtp-Source: ABdhPJyl65bCAVP2RgjJRSBroQtNLZRIZRCHFV+6DN445hPdmiDAF3T370NX7IEcvb7g2FmAT7XPZw==
X-Received: by 2002:a17:906:7c5:b0:6e8:7c6f:4f49 with SMTP id m5-20020a17090607c500b006e87c6f4f49mr23751752ejc.378.1651016578256;
        Tue, 26 Apr 2022 16:42:58 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id kk14-20020a170907766e00b006f3a6a528c8sm2249789ejc.146.2022.04.26.16.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 16:42:57 -0700 (PDT)
Date:   Wed, 27 Apr 2022 02:42:55 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [Patch net-next] net: dsa: ksz9477: move get_stats64 to
 ksz_common.c
Message-ID: <20220426234255.cuczg2rotywlesty@skbuf>
References: <20220426091048.9311-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426091048.9311-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 26, 2022 at 02:40:48PM +0530, Arun Ramadoss wrote:
> The mib counters for the ksz9477 is same for the ksz9477 switch and
> LAN937x switch. Hence moving it to ksz_common.c file in order to have it
> generic function. The DSA hook get_stats64 now can call ksz_get_stats64.
> 
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
