Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E48C6E42B6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 10:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjDQIhn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 04:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjDQIhm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 04:37:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F1B1FEE;
        Mon, 17 Apr 2023 01:37:40 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so12681774wms.1;
        Mon, 17 Apr 2023 01:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681720659; x=1684312659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1TS0efwUAAd7nlMdFggdSRaEYHBszL5PVl2VfDfaNHg=;
        b=nVVXDYKM7dS4sxRa/jMCyNcxKoWwzHPzKRS0iVd6JdsLC4Yvf7HqH5uJYkZn6sPUaL
         iCcJorJ9taEkn5S/3hZFlnNfdUXK8M9QZR9HeG/ElesAuSQ0SxIH3lplS8Z3IVQJ9tK2
         8nfGLoQaiJgUbrvKa5++zjHL1JtK9vMOCOZ11G2mGaYsJtcN5AdMBQp7Mcy5E43bRwMA
         4JUppzGWq8k1kaih4oTsHrEuznAt4v1Njjmr+1B2RtULOASeBzU5CCLFl18qC2Y5VYBW
         jmlQ0p3MbMsR+GEyRUnpskMp+fYdwMXusiBhofFYKAd271MjGcWIR3P5YhGhFIQ8ZPBQ
         jo8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681720659; x=1684312659;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TS0efwUAAd7nlMdFggdSRaEYHBszL5PVl2VfDfaNHg=;
        b=eXTICIODZXN9B43gR+uc4si7jF4inzrdzs4ytzNGSs4iObEm2NnM4/7VbYgyOUwOVL
         q+hobA5MnxP3VoRG14SnG/kKvlIiXUhuaAAxzCR4zLuqHYX8lH0wy1vCRbjG19pId/oM
         BzBeUxy+C4FkupLHR7d0K0pjkZSEvxhMYfTV9ITklf93oqCxBJXb8uRS8W2Pp/VLC/rf
         9Wodz8v+7HoDTFb0bUXU0o8sJM1B+VjdJA0xME+BCmydRvOjLvIqvhT/ey12SnST63k+
         AnCZx5ey7vbg2cK6AUzxH1x1pR7J7gQZ2Tq5BbyOVX2Cus0+NrR5ZB5U6X40kLaqGYh5
         4Hcg==
X-Gm-Message-State: AAQBX9d7eJjpSKsy1clMOBiyw3OT6N5h1c6WCXozkIKN5dfL9gajysSc
        Nf8nVT1Lj063S4fZKA3VJgBku2d6HD8=
X-Google-Smtp-Source: AKy350alSXGGOxruHJRLZ27Qv5gwxhcs5eIGFX7ZpE88yZEtv4l1XpzjXc4my9iIW8NDRUQO5YYFsQ==
X-Received: by 2002:a05:600c:1e0f:b0:3f1:7510:62e8 with SMTP id ay15-20020a05600c1e0f00b003f1751062e8mr763946wmb.3.1681720659317;
        Mon, 17 Apr 2023 01:37:39 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id t12-20020a5d460c000000b002c561805a4csm9943079wrq.45.2023.04.17.01.37.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 01:37:38 -0700 (PDT)
Date:   Mon, 17 Apr 2023 11:37:30 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ladislav Michl <oss-lists@triops.cz>,
        linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <26dd05e9-befa-4190-ac3c-bf31d58a5f1e@kili.mountain>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
 <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
 <ZDgxPet9RIDC9Oz1@lenoch>
 <e2f5462d-5573-483c-9428-5f2b052cf939@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2f5462d-5573-483c-9428-5f2b052cf939@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 07:20:08PM +0200, Andrew Lunn wrote:
> > I was asking this question myself and then came to this:
> > Converting driver to phylink makes separating different macs easier as
> > this driver is splitted between staging and arch/mips/cavium-octeon/executive/
> > However I'll provide changes spotted previously as separate preparational
> > patches. Would that work for you?
> 
> Is you end goal to get this out of staging? phylib vs phylink is not a
> reason to keep it in staging.
> 
> It just seems odd to be adding new features to a staging driver. As a
> bit of a "carrot and stick" maybe we should say you cannot add new
> features until it is ready to move out of staging?

We already have that rule.  But I don't know anything about phy vs
phylink...

regards,
dan carpenter

