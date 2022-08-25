Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B845A1B63
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243955AbiHYVoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 17:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243974AbiHYVoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 17:44:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B118C22A1;
        Thu, 25 Aug 2022 14:44:29 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id og21so4502127ejc.2;
        Thu, 25 Aug 2022 14:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=hlXRZ7/0O/GSBx8dM1cYudKz6m0oIQicSc3rOxsblVI=;
        b=F1f9UD/3EWkXiHP7zVxDvOMP06JyE77Axd+56iYrVfTGd/1KY4fs016sMiQrG27Xzf
         Z4/4RrtiJ8q6TktZSmzy7kD1Z3yyiCcJpZOqInTMya8Z3cQ2AbVptfay27dec9vIfRuJ
         HEsBX40ad6IBKDlZz9eOTvss0fLag2f+FASCXruE3omqDRWYLkcjFhAcLdRk8rjEKckc
         HhQ8KrfCnNw3U8DWmeoOKVzzT96Yrm3nQfz0kiF++AvfLnt1tU55NIsyeJGD2lQYh9tI
         dS+YAPvNIowUvvfy1inZMWmnGAAlyK9hCCcQEVbdKDtLD224JNqeDbed+fEue61hPHeD
         7qnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=hlXRZ7/0O/GSBx8dM1cYudKz6m0oIQicSc3rOxsblVI=;
        b=etSdkHhH0uEmrCERDx18IaMDlTfXuZQhqxPlOBJeKcRBKYssKVxLdZNb6RtDlOJ9HV
         HfRx66X4/hOulhqSyXlf5fp9Ew5Xfsh/pnL1MVwFT7nZ7rGU4qPI2T0D5Tk+GJyC35Y9
         4g3LvlB8qLYma2B/y0/RvXmpT9X2FYgamEDzsKro6e6mKTCpyx6Pj5mfM4zAizwXERIc
         RQ3RyG9d0aNDPDA9wgq9XsC6rlRAIJ85QNefpsj2Smi9WhCfGhbnN5VHCsTr5b8QvF6d
         1AOlhtfA87WJMjqzD07M7sM6LNtdIOqkVzPyBI4V4+tWudTPvcIL16pr9he6MDNqr12e
         t7kA==
X-Gm-Message-State: ACgBeo2sMYtFeqowwESBU90obwgl9gNEbceO10y7tgqQKhqJkBMsOE9v
        hSTScgdB5pdeVUlg0wXpV8M=
X-Google-Smtp-Source: AA6agR6jMHDuGpqsB5Yv2WCnx/5HQdwfjWLoi4+CsRz452suheF78eCr/oR6nZAj5slgUrHm68BmgA==
X-Received: by 2002:a17:907:6096:b0:73d:9d12:4b04 with SMTP id ht22-20020a170907609600b0073d9d124b04mr3724869ejc.745.1661463867662;
        Thu, 25 Aug 2022 14:44:27 -0700 (PDT)
Received: from skbuf ([188.27.185.241])
        by smtp.gmail.com with ESMTPSA id g17-20020a170906539100b0073d62cc3270sm120304ejo.118.2022.08.25.14.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 14:44:26 -0700 (PDT)
Date:   Fri, 26 Aug 2022 00:44:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH net-next v3 00/17] net: dsa: microchip: add error
 handling and register access validation
Message-ID: <20220825214424.u6oawi5n47zyn7rd@skbuf>
References: <20220823080231.2466017-1-o.rempel@pengutronix.de>
 <a359692096f20b2abc5e53cb796c892f97acec1b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a359692096f20b2abc5e53cb796c892f97acec1b.camel@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 11:00:44AM +0200, Paolo Abeni wrote:
> On Tue, 2022-08-23 at 10:02 +0200, Oleksij Rempel wrote:
> > changes v3:
> > - fix build error in the middle of the patch stack.
> 
> The series looks reasonable to me, let's see the comments from the DSA
> crew;)

Patch set looks ok from my side, won't leave review tags for each of the
17 patches, just here

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
