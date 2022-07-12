Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D365728FE
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 00:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiGLWHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 18:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbiGLWHd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 18:07:33 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69DFCBD6A7;
        Tue, 12 Jul 2022 15:07:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id k30so11853305edk.8;
        Tue, 12 Jul 2022 15:07:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=13QMmUMD35mfHjG4ButJ0/fcWjEL1PPPZu/2HnZmXxY=;
        b=iUiRBpAyv70bFdviduODpVEPjWNySxtBwhl5JqUvUUWbk5Wn9ns5fAs7FXlK5yE7W4
         FGixiE4GSfjwOaG5Z14sMd7rSsO76hzT4cromBBMxoxAAywM031+BAYWGbAMPfCBbowD
         /w9Ssov6sbCdDKCB8TvpryL7aG9zIHhuu1VmEU9+WSvn3a1DEA9KnV0jLK6FKBdQlc03
         O7WemYiFzR3EcokNJl4IZUAw1HUobV7JuZ/CZwwSVIwAzid4YxMNTOlbvoLg9XyPwz/u
         Bc/07PAqKgd9/LPOUvYYOj+UIi/EzI31lJEf/KDgz20u7Kdku6YiNMttcLtz311365qH
         zK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=13QMmUMD35mfHjG4ButJ0/fcWjEL1PPPZu/2HnZmXxY=;
        b=bJTHZ8WyK2GgyaDX4x5/9ByIPvWAGpGzt/EOmaHZUn8CUhfYRdUIiH0145wZIigFyY
         oecE5H91jTwUtH1TugFFPEbY71WFMcrIs6d2tXJWAHUzsA/grgYIs0KMQ9tSa+12feOt
         /ycHHWtM7rbcucc0pKPBopbKiEX0Ncnx3/qLrexXqW1gYv1uZ9PdSNhydpU98w6IieBp
         yc3m19sJJ/7uPjiLQ4FDt1W458ogJX/F5GYuV/4iwft9xyiRAJ0HaqdNOf2PrE1KOh++
         QYDDD3VLb2Ktfpqs+l1Pi2raLELUj63nxJh+MY2Hy9JANyPPX8hCN4r8RK0h3abbgCjG
         DJxg==
X-Gm-Message-State: AJIora/C1DdgML8CVuIwWmQEnwzbMkUauY6zyRjJlSwLRahv1F9AidUg
        KsmKZRVGmlggvGgiq6ACTwMwxdSytgbSCWSi
X-Google-Smtp-Source: AGRyM1t+8wJVYbH35c2t0xPzRyNISb345+ACr3U5iNQPdxzYMFIUOqsdJsP3k9JwglmhBxXV6C2Y+A==
X-Received: by 2002:a05:6402:3690:b0:43a:83f8:93bf with SMTP id ej16-20020a056402369000b0043a83f893bfmr356265edb.49.1657663651025;
        Tue, 12 Jul 2022 15:07:31 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id c17-20020a056402121100b00437e08d319csm6624689edw.61.2022.07.12.15.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 15:07:30 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:07:28 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH stable 4.14 v3] net: dsa: bcm_sf2: force pause link
 settings
Message-ID: <20220712220728.zqhq3okafzwz6cvb@skbuf>
References: <20220708001405.1743251-1-f.fainelli@gmail.com>
 <20220708001405.1743251-2-f.fainelli@gmail.com>
 <Ys3JIVVpKvEts/Am@kroah.com>
 <b3c1d411-34c5-197c-5643-6fe4c4ee3723@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3c1d411-34c5-197c-5643-6fe4c4ee3723@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 12:30:00PM -0700, Florian Fainelli wrote:
> On 7/12/22 12:18, Greg Kroah-Hartman wrote:
> > On Thu, Jul 07, 2022 at 05:14:05PM -0700, Florian Fainelli wrote:
> > > From: Doug Berger <opendmb@gmail.com>
> > > 
> > > commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> > > 
> > > The pause settings reported by the PHY should also be applied to the
> > > GMII port status override otherwise the switch will not generate pause
> > > frames towards the link partner despite the advertisement saying
> > > otherwise.
> > > 
> > > Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> > > Signed-off-by: Doug Berger <opendmb@gmail.com>
> > > Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > > Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > > ---
> > > Changes in v3:
> > > 
> > > - gate the flow control enabling to links that are auto-negotiated and
> > >    in full duplex
> > > 
> > 
> > Are these versions better / ok now?
> 
> Vladimir "soft" acked it when posting the v3 to v2 incremental diff here:
> 
> https://lore.kernel.org/stable/20220707221537.atc4b2k7fifhvaej@skbuf/
> 
> so yes, these are good now. Thanks and sorry for the noise.
> -- 
> Florian

Sorry, I tend not to leave review tags on backported patches. I should
have left a message stating that I looked at these patches and they look ok.
