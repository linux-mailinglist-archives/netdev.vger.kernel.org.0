Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820A36A237D
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 22:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBXVJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 16:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBXVJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 16:09:02 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374356F000
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:08:57 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id cq23so2517538edb.1
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 13:08:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wMNxsXkojw1967LyQO1wRe4xX5h8cb+WzivMMM/wqjE=;
        b=bM2ff5Cy7yQWUh9Gbzwsm4VTTZkAT9YQgEI37wFOYyvFpbXhIXz8HsbLNkETamjT05
         JnBcAqYvogS2oRH/OiI/kESAypMSq5jdOGwXaY4ZBIUhqk3VadTQztVsfg4Y4YfPkx0q
         gDe9QUXwwL+1JEQ0T1asDyPOkHnBY4IxkC8nybtaDQQhWwUT6hGzJ1EQItU54PxoAZzp
         7qBGWCg//TSg0kDYBwIVw6QvPi8lAdr5SOyUpnLS4fzrtEvwccfav9UbAYHu7lTEOZcg
         4JOoch4K3CFVCzkbJwbbU3d3LwgStnObh7ZBHFE10NEVe3BTIB3BC3iPv5eCxjusPVNC
         Gw4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMNxsXkojw1967LyQO1wRe4xX5h8cb+WzivMMM/wqjE=;
        b=ldm/phwhU+P0//uRRvPcK3q1oztm+PSD7fJ3RYvm9c7hxPFr87f2avbIQLcTEod3WY
         LbUU8kE15f1ORR1mVbwg0NUGRrT87GTi3VeQH4Lr8YbRtnbgztS6KcaBigTCSaR0RaTJ
         Vm80qObB02eT1QjXypkdfnQ6Vr2Knw0ZpExmihDlbeVpLzKx2Ji5YCB0XnHyOD3Rjj+U
         fLP7BBmlq/TBfjJpHpaucbeA3ttv++IpqlUbLNxjvL3LqaRWyJeqU8OUL58h+Q3tfehg
         +fAkLjWFzvObIgZhPtROOl1jupjJOejcan/9aDpJ3f71uQysoNDkSxiBaT60YnL/M/BG
         qMcg==
X-Gm-Message-State: AO0yUKULiDME73IY4II5T85rQt9HVo+89aDvM90cgTZsmB4cHmjLFWl3
        YIFf7V4WZErf7K/xLMM+x8k=
X-Google-Smtp-Source: AK7set9jnAO9pj6CSfKAA6rEL+RfBn4gLzjweB8851+3AdyrfasjQ6KNk1e+dQSdZ2hGMLYR6t4wUQ==
X-Received: by 2002:a05:6402:40ce:b0:4af:51b6:fe49 with SMTP id z14-20020a05640240ce00b004af51b6fe49mr1267891edb.13.1677272935498;
        Fri, 24 Feb 2023 13:08:55 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id a98-20020a509eeb000000b004ad601533a3sm153085edf.55.2023.02.24.13.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 13:08:55 -0800 (PST)
Date:   Fri, 24 Feb 2023 23:08:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
Message-ID: <20230224210852.np3kduoqhrbzuqg3@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 09:44:43PM +0100, Frank Wunderlich wrote:
> 6.1.12 is clean and i get 940 Mbit/s over gmac0/port6

Sounds like something which could be bisected?
