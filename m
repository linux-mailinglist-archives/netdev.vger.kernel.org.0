Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA07597513
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 19:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238596AbiHQR1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 13:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238035AbiHQR1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 13:27:09 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8360A031C;
        Wed, 17 Aug 2022 10:27:08 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w3so18417484edc.2;
        Wed, 17 Aug 2022 10:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=wZI3tld/QNucTFtbrUt7UlOI+G9nC5bXjdIDXeunuuU=;
        b=o9/QqRtP0PXeKhucl+cs0Ac5sNYNh7KvuMZec5/liF8Tue6Vm/HbH0jenXByiQlbQh
         2VxgIaZXbP7YS6TYVqSMMNLokE5fXNlgpSsriwyMt/NtieyPKITQd/7LTskuwP5rXG4n
         fM7ykT6iqS27mztynRBaQj6/C65TJet2NA8NV2ja34zTvxYErfnV3HneRLzgXj+XG9oo
         yYp99phiV/9Jjzkm7+55lKvnPoYblEXnUyh9LBfOjIRYtHnf7Z0U0whEYJUUqGDl0yUV
         lV6CODOH4srpX/EbTx/Lcd/NNUeRv41GBeloSlq3isKIKwJmTuHNvXJUTBovIuHqrPoB
         Ul1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=wZI3tld/QNucTFtbrUt7UlOI+G9nC5bXjdIDXeunuuU=;
        b=1slrIbZzfAXL3g1KIPeHvWcaNdVX0R4LcWzXV3VRQy7R43WWxsOKGhwClvfKKhSHdY
         27V8kZxYb6k32h+srQ4ZbhWnSMttMEAGxrswZ0Fg8/dGxVrU6yZ1OUWV+/OUTUNkLT38
         MHDahOTz2+JlKfQ9k4yD23u55bSqkD73M3BL4m1S0SwP5gG++WtedYOm+iiIZcxCO1Z4
         +cjVsr9rJozEhzGIE2tcunOS0RO+QNFdi8NioNMx65VczDTPGcQ7Y1ZPfJPhiFhmSUVH
         5BsLulDr1uKSVQuxFjQ0zVVDauUf8fGS40z62EiEtBzspzVzwUwnBi4wMJg+9VPppjYb
         o3Vw==
X-Gm-Message-State: ACgBeo1PdewGvVgOCk8esEEXxESiV+kJP9g9NfjakiNq2PHKePGXm1/f
        5Xoi1PFzOY4BKb9TgSjjJ58=
X-Google-Smtp-Source: AA6agR5XbwlsjSwC7+Y/qAB6qjRysLq5+bXTKf0VLMQ7e9XSIqBIOCpgjiU7bmwKesvqXCNbSOEsAg==
X-Received: by 2002:a05:6402:3304:b0:43e:8623:c402 with SMTP id e4-20020a056402330400b0043e8623c402mr24187784eda.200.1660757227343;
        Wed, 17 Aug 2022 10:27:07 -0700 (PDT)
Received: from skbuf ([188.26.184.170])
        by smtp.gmail.com with ESMTPSA id mu8-20020a1709068a8800b00730860b6c43sm7103646ejc.173.2022.08.17.10.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 10:27:06 -0700 (PDT)
Date:   Wed, 17 Aug 2022 20:27:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: bcm_sf2: Utilize PHYLINK for all
 ports
Message-ID: <20220817172704.ne3cwqcfzplt2pgp@skbuf>
References: <20220815175009.2681932-1-f.fainelli@gmail.com>
 <20220817085414.53eca40f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817085414.53eca40f@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 08:54:14AM -0700, Jakub Kicinski wrote:
> On Mon, 15 Aug 2022 10:50:07 -0700 Florian Fainelli wrote:
> > Hi all,
> > 
> > This patch series has the bcm_sf2 driver utilize PHYLINK to configure
> > the CPU port link parameters to unify the configuration and pave the way
> > for DSA to utilize PHYLINK for all ports in the future.
> > 
> > Tested on BCM7445 and BCM7278
> 
> Last call for reviews..

My review is: let's see what breaks...
