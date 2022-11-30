Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA8D63DFCD
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbiK3Suj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbiK3Sud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:50:33 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 813B199F02;
        Wed, 30 Nov 2022 10:50:32 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id bj12so43489733ejb.13;
        Wed, 30 Nov 2022 10:50:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qE35TTAoQcWw0L4flPKU3V9y0ZmdQefm7mKBz7c20J4=;
        b=Y11E7pFHRXrqh2jkJTA3ijsp8MYVtthjM+INw6bEArmKF/KQ5vl9RlKLxWQeMf/DH0
         GEGjSyrCmdNX/gK9iTKIbv8KrSlNtSH30xTthoqVgfMSSwUOb3VubLdyb+VPjRO0YLS5
         a/ci7tnhdWQEFseBUJWeNh3ptVCxivHi5HEfqPuxBhNA1wNcJjIrZaocQfOMpdLUsMdO
         BbuXsuIy0vIF5CKKskp8JvuGARIOCad2zJvODcRxacPShhXSeOApvRqFP97zlfPDg3Ea
         7vwWU4FrFCSO2QOU5lr1Wq4Pp+62ViQFJXQRYiCO8SADJaTY6G+Ds8kMaNh75vwXadfD
         FIuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qE35TTAoQcWw0L4flPKU3V9y0ZmdQefm7mKBz7c20J4=;
        b=eEXLpZvSbJClENGnXo/E7qSm2+luAXkJBOg6h7qguSlpS67cozK+Pt4W8Y76cBn9pC
         QpIVRbyF2Y9UWDvRGTVZw8NoWcPg2piHXNbO7J9ZOBr5JzfTCAKGjQicwc7EnPzPvl1x
         mix7idRj9iua2sN8ybIXnINuhGaSyydQdrKNdTbMiSyxWHv8fEOqKdqPfk3oFTSRYODZ
         V0H3XMM5Bcc0bUoOUP2uhXSDjqsNjs5pVIk41tC0S6eVmOI2TpDkh6cGszg1X4v+fmBI
         nfBoXSAE1sCYj+zodlxsa08dXMgi7gwNBefJpoCx9gK7QA0bYXuYr+SxHxQmCDN1oNmk
         5/Xg==
X-Gm-Message-State: ANoB5pl/ZCG8k5LRY+64j5A8ZHb7SerH8h0Voy7Jv8cdkUHsJpBeATuI
        xX8xQI/BuvsS7DmKSdtfmqI=
X-Google-Smtp-Source: AA0mqf6KVZLMfnFc3XWh7Qkn+giNrblAMgOkHoXywdpkJIDtzLKtWao+dBQzUwgsFApf3WGxOMsGyw==
X-Received: by 2002:a17:906:2b8f:b0:7a0:3125:f1e5 with SMTP id m15-20020a1709062b8f00b007a03125f1e5mr51609113ejg.314.1669834229432;
        Wed, 30 Nov 2022 10:50:29 -0800 (PST)
Received: from skbuf ([188.26.184.222])
        by smtp.gmail.com with ESMTPSA id o15-20020a170906768f00b0077f20a722dfsm928037ejm.165.2022.11.30.10.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 10:50:28 -0800 (PST)
Date:   Wed, 30 Nov 2022 20:50:26 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jerry.Ray@microchip.com
Cc:     kuba@kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3] dsa: lan9303: Add 3 ethtool stats
Message-ID: <20221130185026.pxdv7daoiqliz7qq@skbuf>
References: <20221128205521.32116-1-jerry.ray@microchip.com>
 <20221128152145.486c6e4b@kernel.org>
 <MWHPR11MB1693E002721F0696949C5DCBEF159@MWHPR11MB1693.namprd11.prod.outlook.com>
 <20221130085226.16c1ffc3@kernel.org>
 <MWHPR11MB1693909B5E06A7791F0FD079EF159@MWHPR11MB1693.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1693909B5E06A7791F0FD079EF159@MWHPR11MB1693.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 06:12:54PM +0000, Jerry.Ray@microchip.com wrote:
> Won't be able to get to stats64 this cycle.  Looking to migrate to phylink
> first.  This is a pretty old driver.
> 
> Understand you don't know me - yet.

It would be good if you first prepared a bug fix patch for the existing
kernel stack memory leakage, and submit that to the net.git tree.
The net.git is merged back into net-next.git every ~Thursday, and
generally speaking, either you wait for bug fixes to land back into
net-next before you submit new net-next material in the same areas,
or the netdev and linux-next maintainers will have to resolve the merge
conflict between trees manually. Not a huge deal, but it is kind of a
nuisance for backports (to not be able to linearize a series of cherry
picks) and all in all, it's best to organize your work such that you
don't conflict with yourself.
