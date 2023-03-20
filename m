Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE5386C1EC7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 18:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbjCTR7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 13:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230457AbjCTR7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 13:59:16 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800177DB9;
        Mon, 20 Mar 2023 10:54:13 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id k37so3032384lfv.0;
        Mon, 20 Mar 2023 10:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679334771;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gjtrDHad5ipWXlVxyz0QsRXZabwmk49CGaT/vOXTHf0=;
        b=p3/toevd5cdAOFepc8U00wh0VujMAkg5H7hvY28RJO9BNGcXHu3xtQrR7NEQi87jVs
         fkinGfek9kZf9uraGEp9BXsdLLKyFT2O9mHG6tZE12ujpH0ckqd2PShBcKvtgOtbg0Cl
         S2ROq9DrNBEy4ic071UXERs0rTz0lyUdDBHyHW9Biapd/rTkmSgtlad5e9XC2kAce1xF
         C9MyghrxNHFppuaXg5ZY1LKBioZKaTNPHJbSvG5sge9pEl0JFptIBDfpg9tqO8013rO+
         CM3dtBJbTMG++uwx2ntapkpECg6C3vDD+GWUoGmqw/KHFK80czd8KPXiku5ofw45xiu3
         MrKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679334771;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gjtrDHad5ipWXlVxyz0QsRXZabwmk49CGaT/vOXTHf0=;
        b=pOPD1q1jX4cEUln4WOHVRMWj7PqIfJb0xRmfwgg1UjuaqNPUiPMRi0OvI+dOKlhnCF
         ymEe1gOK1k7xFIdhzlARi9BYf/0gJ7ldmXfoae08+L/6y8l7YCGK2X+DNW/HyWyZHQ5+
         B6GKVLGSp/Mi2EQlc8eq3NfIn2lZqNLDunONGeh/hhgZrXCXSK9zfzF6y13vBRDWQj/0
         zlDYjnxPF+nG9a+fYyACB2+9UiLLC+GxilppQs9qASd9D7WlV16qJOw6u9Dyonnkhb7M
         2SNKuAGrHQQhqrHwTPEl7Rr8+ZlVFmpFqT2u51wbnUZxbH6jtGd48ifqzN+dWkh3UX6l
         Xsog==
X-Gm-Message-State: AO0yUKVahky1m35DGo+Zbc+NcsJx9hDXEMb3YJ3s1GRsRAjlyNcaaP7F
        oYpnJ8NbMHiVdMnE/QGnMSM=
X-Google-Smtp-Source: AK7set9IgQpjLnKLnivs0dm+tDOD+Xi6seUQ4pg7hGKKZTtq+nmT30KTq7k4NiYmLFVewzs6Fr/zNw==
X-Received: by 2002:ac2:4830:0:b0:4e9:cfd2:e2d with SMTP id 16-20020ac24830000000b004e9cfd20e2dmr192306lft.65.1679334770529;
        Mon, 20 Mar 2023 10:52:50 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id t8-20020a19ad08000000b004a9b9ccfbe6sm1802168lfc.51.2023.03.20.10.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 10:52:50 -0700 (PDT)
Message-ID: <64189d72.190a0220.8d965.4a1c@mx.google.com>
X-Google-Original-Message-ID: <ZBidb1GWPPNegi80@Ansuel-xps.>
Date:   Mon, 20 Mar 2023 18:52:47 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 04/15] leds: Provide stubs for when CLASS_LED
 is disabled
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-5-ansuelsmth@gmail.com>
 <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa2d0a8b-b98b-4821-9413-158be578e8e0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 19, 2023 at 11:49:02PM +0100, Andrew Lunn wrote:
> > +#if IS_ENABLED(CONFIG_LEDS_CLASS)
> >  enum led_default_state led_init_default_state_get(struct fwnode_handle *fwnode);
> > +#else
> > +static inline enum led_default_state
> > +led_init_default_state_get(struct fwnode_handle *fwnode)
> > +{
> > +	return LEDS_DEFSTATE_OFF;
> > +}
> > +#endif
> 
> 0-day is telling me i have this wrong. The function is in led-core.c,
> so this should be CONFIG_NEW_LEDS, not CONFIG_LEDS_CLASS.
> 

Any idea why? NEW_LEDS just enable LEDS_CLASS selection so why we need
to use that? Should not make a difference (in theory)

Anyway hoping every other patch and Documentation patch gets some review
tag, v6 should be last revision I hope? (so we can move to LEDs stuff)

-- 
	Ansuel
