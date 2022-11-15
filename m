Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940FA6295CF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:28:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238332AbiKOK2r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:28:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232976AbiKOK2k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:28:40 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB5221E03;
        Tue, 15 Nov 2022 02:28:38 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id l11so21241594edb.4;
        Tue, 15 Nov 2022 02:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4xoHGYqIR0jb6YR52g7f5C100ipZZtybXvnbtnHyQls=;
        b=kny6qqMkR6UnOF2twttUfX6aYLEDao4dGposMUQXkLBe4B+f+Ql0QNeSZWKQCW0x6v
         p1J5bADPaWYL7lh+WgrKhx3p/lYZj/iGXt4SMJaFiLWLBXtCkAL61e8psCV2Ily5Nh79
         0VAeY6+pmvJ9FVBkznT3nF0LSupo2QG18g6sCsKqBYQ+HRNw1r1cPTCfIb3K2eh8oOzf
         dKn15xB6rPCqhQ/xKWakltkY6haQCYRGkmIXSbWWJyTPmUpC/5IJOh7xiZ1ZHvZoJ/qs
         VT4Y/AHkbluUfXhEiDqwJysjFRp8S0cLHNCKoVPMoVDi3OiofEDOVRGoWCOHNXyf63PU
         YzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4xoHGYqIR0jb6YR52g7f5C100ipZZtybXvnbtnHyQls=;
        b=wnjxGpOCZtIaJQ8IEW3sToXliZ+l0sUJ7OZul3cJ7CggpDWZAOVBffZZBQgrWsV6Wn
         M0yQ2Nur2pCphbMGTRVDaXMrE1wv/rR8h2YUmEHNF9eTWs4zNNwYec2vrD4GgxtFPbRX
         2QjXQchfJnYQSYyykERmWOJV0KGP/WCDlN9u6TGFKSNcllWh/3C+jnehrxCtL0UdK1HV
         6SoxzQM2fgcN1jCItqyJI0EXQ1C/A9rCgh2hhpqyqrhK5xtE54qCJrPvCe5YgI6HcrwA
         9gQAr/5cp5K2DH+j+M8YbyU96rEUuz8SE+O1y+Ey8rSWgJn4n0JtW98UqPJr34C2MRqE
         ATzg==
X-Gm-Message-State: ANoB5pnY5RRggGzdfobuPRL9e/E4PNKYdwYi7mNd0Y80Psp7q51bEvS8
        i6ckrjr2qx8uyWQ492hsqqh49isR2Pwh8Q==
X-Google-Smtp-Source: AA0mqf7SUQdFq0UdR+BwVVAISDy/whVsty5mVe8G8z/KuxPFef4yEZyAiWSjlnXAysejJP4DdxPO9A==
X-Received: by 2002:aa7:da55:0:b0:464:718c:b271 with SMTP id w21-20020aa7da55000000b00464718cb271mr14295109eds.287.1668508116735;
        Tue, 15 Nov 2022 02:28:36 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id k17-20020aa7c391000000b00467cc919072sm3047951edq.17.2022.11.15.02.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 02:28:36 -0800 (PST)
Date:   Tue, 15 Nov 2022 12:28:33 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115102833.ahwnahrqstcs2eug@skbuf>
References: <20221112203748.68995-1-netdev@kapio-technology.com>
 <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5559fa646aaad7551af9243831b48408@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 11:26:55AM +0100, netdev@kapio-technology.com wrote:
> On 2022-11-15 10:30, Ido Schimmel wrote:
> > On Sat, Nov 12, 2022 at 09:37:46PM +0100, Hans J. Schultz wrote:
> > > This patchset adds MAB [1] offload support in mv88e6xxx.
> > > 
> > > Patch #1: Fix a problem when reading the FID needed to get the VID.
> > > 
> > > Patch #2: The MAB implementation for mv88e6xxx.
> > 
> > Just to be sure, this was tested with bridge_locked_port.sh, right?
> 
> As I have the phy regression I have given notice of, that has simply not
> been possible. After maybe 50 resets it worked for me at a point
> (something to do with timing), and I tested it manually.
> 
> When I have tried to run the selftests, I get errors related to the phy
> problem, which I have not been able to find a way around.

What PHY regression?
