Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E140660A43
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 00:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235524AbjAFX3L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 18:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbjAFX3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 18:29:10 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3466488DF0;
        Fri,  6 Jan 2023 15:29:09 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id v10so3069530edi.8;
        Fri, 06 Jan 2023 15:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V/CHtBfuoBwh3965bbOqa0bDVHTb0f8Tm9+/rTtd0Ow=;
        b=nNAFW27qekariEEjM4E0cydMN3kbkhn3rQ/aRH9h+cCh0JvnkXT2jOk5cukqT1gDGi
         v3AsbnQIGDzbKRHZSTrQwI7qVOYhHt7fXeaQK31dgtRcbCy98nCiO+ZoCI2o1k1IiDFu
         ao9r5KKjtgKBjtuKzsXll+FMEYr7QtmyEEWaK+uoOWSkzqVf1/LXrwYmq+260iv203W/
         YbV+6cFzM00ABf1Mf9dyzNMN3tZmxi79HUvJRcK67ruEbW0hCPYeJz966mWsjMGNoBU+
         bonmGWw16jiZpsbAEKELucLVMwWFhVJUUrLTT2uePgbllnFcOBm3jMQDg7K8qEKsUlwz
         s9Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/CHtBfuoBwh3965bbOqa0bDVHTb0f8Tm9+/rTtd0Ow=;
        b=NmpWPsdJXE9dATdPQmdkZ22hoqCJG/c9VndUHzZuRLV/vwghATlj5WPDp4NUnmgWEd
         7n+B65udy94JM0hSTh2VoojjHNZEgcTTbE/ddaNddOtDPe71tWPPSNCdvU24Q+qaHS8r
         9zcZWJs/p4EwYYpKZa9WXdJZFmll/vJiR2D16uLKwTTedjRjeY/EAufUh11SW20l30fH
         BUWixtFa0jg13bKxNCZFovoHafm5N8hXMk2+fqHksk0s4+MSGL04mxHGoYk8vQxZYy09
         WL7vqjvCk9MEorbMeevuwy3IEEbl8+mGkUhNcGQutuDlA2f2D6y2MTf4zYZU29lRz89k
         vSHw==
X-Gm-Message-State: AFqh2ko4QyHdTky3Ty+3CwXtRPhj7u+LbMnFlbG7ig7RfV4RR3Ud3nSa
        awPWtUBMU8n1b1ILlJ3idpQ=
X-Google-Smtp-Source: AMrXdXsn0WEffBN4eL5PkzFeQq844b6d6Xzq6XU0xN5TrtgLG+1qyX57k8ID7qYKnH0Sw33cc1fZnA==
X-Received: by 2002:aa7:d789:0:b0:497:4f53:ee8f with SMTP id s9-20020aa7d789000000b004974f53ee8fmr2427276edq.39.1673047747602;
        Fri, 06 Jan 2023 15:29:07 -0800 (PST)
Received: from skbuf ([188.26.184.223])
        by smtp.gmail.com with ESMTPSA id p18-20020a50cd92000000b0046ba536ce52sm925379edi.95.2023.01.06.15.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 15:29:07 -0800 (PST)
Date:   Sat, 7 Jan 2023 01:29:05 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tim Harvey <tharvey@gateworks.com>
Subject: Re: [PATCH net-next v5 4/4] phy: aquantia: Determine rate adaptation
 support from registers
Message-ID: <20230106232905.ievmjro2asx3dv3s@skbuf>
References: <20230103220511.3378316-1-sean.anderson@seco.com>
 <20230103220511.3378316-5-sean.anderson@seco.com>
 <20230105140421.bqd2aed6du5mtxn4@skbuf>
 <6ffe6719-648c-36aa-74be-467c8db40531@seco.com>
 <20230105173445.72rvdt4etvteageq@skbuf>
 <Y7cNCK4h0do9pEPo@shell.armlinux.org.uk>
 <20230106230343.2noq2hxr4quqbtk4@skbuf>
 <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ede0be8-4da5-4f64-6c67-4c9e7853ea50@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 06, 2023 at 06:21:26PM -0500, Sean Anderson wrote:
> On 1/6/23 18:03, Vladimir Oltean wrote:
> > On Thu, Jan 05, 2023 at 05:46:48PM +0000, Russell King (Oracle) wrote:
> >> On Thu, Jan 05, 2023 at 07:34:45PM +0200, Vladimir Oltean wrote:
> >> > So we lose the advertisement of 5G and 2.5G, even if the firmware is
> >> > provisioned for them via 10GBASE-R rate adaptation, right? Because when
> >> > asked "What kind of rate matching is supported for 10GBASE-R?", the
> >> > Aquantia driver will respond "None".
> >> 
> >> The code doesn't have the ability to do any better right now - since
> >> we don't know what sets of interface modes _could_ be used by the PHY
> >> and whether each interface mode may result in rate adaption.
> >> 
> >> To achieve that would mean reworking yet again all the phylink
> >> validation from scratch, and probably reworking phylib and most of
> >> the PHY drivers too so that they provide a lot more information
> >> about their host interface behaviour.
> >> 
> >> I don't think there is an easy way to have a "perfect" solution
> >> immediately - it's going to take a while to evolve - and probably
> >> painfully evolve due to the slowness involved in updating all the
> >> drivers that make use of phylink in some way.
> > 
> > Serious question. What do we gain in practical terms with this patch set
> > applied? With certain firmware provisioning, some unsupported link modes
> > won't be advertised anymore. But also, with other firmware, some supported
> > link modes won't be advertised anymore.
> 
> Well, before the rate adaptation series, none of this would be
> advertised. I would rather add advertisement only for what we can
> actually support. We can always come back later and add additional
> support.

Well, yes. But practically, does it matter that we are negotiating a
link speed that we don't support, when the effect is the same (link
doesn't come up)? The only practical case I see is where advertising
e.g. an unsupported 2.5G would cause the link to not establish at a
supported 1G. But as you say, I don't think this will be the case with
the firmware provisioning that Tim gave as an example?

> > IIUC, Tim Harvey's firmware ultimately had incorrect provisioning, it's
> > not like the existing code prevents his use case from working.
> 
> The existing code isn't great as-is, since all the user sees is that we
> e.g. negotiated for 1G, but the link never came up.
> 
> --Sean
