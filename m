Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 656CE671A85
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 12:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229681AbjARL0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 06:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229976AbjARL0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 06:26:11 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5996676F9;
        Wed, 18 Jan 2023 02:44:18 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id v6so39169101ejg.6;
        Wed, 18 Jan 2023 02:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=htGsuXy+L4l/6YTEV2cN6mSyIrs9+KCugQunRnTONUc=;
        b=Aoh29YI5U/qq6weJC4EBm7IR+GoIdf69ZRtiUVvrv9/8cTy2VE0rtrILmHBu1dnvu0
         avc/sOfZtdudst6ZquNw8ZhT/nI3l53yP67zbN4NQs80orLSDHw8hdm/zWbpxxUc4yw8
         HvttpgwRRSJ5Psk3y5l7VYm0VwgLFSl99XV6Ov/LixDSD42NGS6UHk81WdpBG4Kf6KVJ
         vzZpnORHLK/EKKPxCHvmdagxEb5dwya088zIbfZu2GvjHFEHphaFwZexYwill/NU8MSG
         LE7m8wi7YNBEgqIwxBZfVreh8dptM5FwqxwWC2Z55UY5AMYx0fiCaV3KEyScge7edF+V
         Nxyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=htGsuXy+L4l/6YTEV2cN6mSyIrs9+KCugQunRnTONUc=;
        b=nGFhv53ok5u22gvCzieaX+DYTz/hjbN+iryYKRVKUoP0Pmi97tcFoB9FxAhiesIbXf
         ez8N6oIgy+D5Pw2dt2wQ3dXT33RwP5J6HBrHWTnEEdrCfCGSiignTCidbWt1x+xTubRE
         9/0p8CCKtrUz7YDBfo44oXRe+/gz+5a14tlAjQS2iZKK9UiPyCYw+Kip081Y7JgNnNWX
         FuOaqB1EqGjOujJBdVDr27oIPqFRruuLsHlVd3H7mk1qtlERf1FkU0cShkhO92iVU/e7
         bnZH/dJW81poM6guFIuuNfP+y8m3qH0xi4yAyIDWJMJc7rkehNjdS8zjJV7RmDQgnD3R
         TOvw==
X-Gm-Message-State: AFqh2ko8LZXNTEUwSkDk1bwH6kdCUCjeD74dkQusCZfT7QfqiCxdUd7D
        O/P3tPapsYJKxHsXof30OD8=
X-Google-Smtp-Source: AMrXdXtj9nFKzxhKPftKTG77LfDE7SDPunzMB1Ud5r1mxEo7Azfftv6y1dvgiNLM40TwDOeKlbts1Q==
X-Received: by 2002:a17:907:a585:b0:872:ec40:65e9 with SMTP id vs5-20020a170907a58500b00872ec4065e9mr5735827ejc.18.1674038657042;
        Wed, 18 Jan 2023 02:44:17 -0800 (PST)
Received: from skbuf ([188.27.185.42])
        by smtp.gmail.com with ESMTPSA id g11-20020a170906538b00b007c16e083b01sm14439082ejo.9.2023.01.18.02.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 02:44:16 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:44:14 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Christian Eggers <ceggers@arri.de>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: ptp: Fix error code in
 ksz_hwtstamp_set()
Message-ID: <20230118104414.2tvgqr4edjw32e3o@skbuf>
References: <Y8fJxSvbl7UNVHh/@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8fJxSvbl7UNVHh/@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 01:28:21PM +0300, Dan Carpenter wrote:
> We want to return negative error codes here but the copy_to/from_user()
> functions return the number of bytes remaining to be copied.
> 
> Fixes: c59e12a140fb ("net: dsa: microchip: ptp: Initial hardware time stamping support")
> Signed-off-by: Dan Carpenter <error27@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
