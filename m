Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290B75E6718
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 17:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiIVPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 11:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiIVPad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 11:30:33 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1ABDA99E8
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:30:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id e67so3354285pgc.12
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 08:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=ktbc2zsLnnKt6+57+I19rvSLvElUo/d1AGdIoWTJ0qc=;
        b=EB4FOGidA7sCicF/Xmn0C2qVXh+wfP5QgcE1K0CuQZ9qnnfpX+0uEVXt8+wuQ+0EV+
         3Is4qbCNq9qjNOZkrOseshBh5NiMkSQyr3qj2e9sh9tyXnAVlVwtIvY953+mZVoKnJKm
         Wcsy0WISPa2Cp8t63rD2qlUbRgtRwgvgzztKGQrlnz6OO/rcgqzu8vMiA5lnEOIsKMMF
         MosKJPuDI86M273uRpFW0y4fX0AgHc5leNEbW7B/B+V+yphtWVw+X5UYSPcy45010Lls
         e0G/MZI+9+00UcJifHc5cK8Usl3MlGJvejCgAcWkaE3clKYX6LEWUBHmipVo8v2ySNok
         NXBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=ktbc2zsLnnKt6+57+I19rvSLvElUo/d1AGdIoWTJ0qc=;
        b=2HFhZweNqJoN6Bw2Ri6JSyM27gUXFghn+Y3FoUJZYQbpMf/1pOeEjuyHaVAoqpQuG8
         dPrY1Y48TMf3frVm2V3Z921ZNejcUUTTObbSRs1B/LsHNNhQYJGztfCPqePX3vf+AXEY
         p9eNaQ6rireMG+RhYiO97mkZU2pYia33PhY1CgeuesSt3jnd3ME/ae/RXFSUKfaxKpNb
         QqFlUWjdSuKc+YyR7byvRkrMi+qVptZQGTxqG11fEHtjmYs0r9B4p1JZgvQbP1RLWthc
         Vwb+w7G7QYmFMIBpTYSsNXpmM15bNKiXNZaLMuBAj6iCw1ttpqrMBIabNEdjevRbCMzF
         g46Q==
X-Gm-Message-State: ACrzQf19wIseCmrIuCSdflyCVrtH0eeoNlP/WEeBjKBpgVGDZ2McwVfK
        gKtGzqY9jw2/RS3MJUa/fJNyQQ==
X-Google-Smtp-Source: AMsMyM7tPDq5FCJv4ls78g2LIVVM5jjAfCPG6TzXMCSjRo7dBvzMcU6v/2ZWDnb00A00Mrq40Gl0hQ==
X-Received: by 2002:a63:20f:0:b0:43c:1ef6:ebd6 with SMTP id 15-20020a63020f000000b0043c1ef6ebd6mr1867621pgc.217.1663860631374;
        Thu, 22 Sep 2022 08:30:31 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id bg18-20020a056a02011200b00434feb1841dsm3861687pgb.66.2022.09.22.08.30.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 08:30:31 -0700 (PDT)
Date:   Thu, 22 Sep 2022 08:30:29 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 iproute2-next] ip link: add sub-command to view and
 change DSA master
Message-ID: <20220922083029.52524b21@hermes.local>
In-Reply-To: <20220922144123.5z3wib5apai462q7@skbuf>
References: <20220921165105.1737200-1-vladimir.oltean@nxp.com>
        <20220921113637.73a2f383@hermes.local>
        <20220921183827.gkmzula73qr4afwg@skbuf>
        <20220921153349.0519c35d@hermes.local>
        <20220922144123.5z3wib5apai462q7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Sep 2022 14:41:24 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Wed, Sep 21, 2022 at 03:33:49PM -0700, Stephen Hemminger wrote:
> > There is no reason that words with long emotional history need to be used
> > in network command.
> >
> > https://inclusivenaming.org/word-lists/
> >
> > https://inclusivenaming.org/word-lists/tier-1/
> >
> > I understand that you and others that live in different geographies may
> > have different feelings about this. But the goal as a community to
> > not use names and terms that may hinder new diverse people from
> > being involved.  
> 
> The Linux kernel community is centered around a technical goal rather
> than political or emotional ones, and for this reason I don't think it's
> appropriate to go here in many more details than this.
> 
> All I will say is that I have more things to do than time to do them,
> and I'm not willing to voluntarily go even one step back about this and
> change the UAPI names while the in-kernel data structures and the
> documentation remain with the old names, because it's not going to stop
> there, and I will never have time for this.
> 
> So until this becomes mandatory in some sort of official way, I'd like
> to make use of the exception paragraph, which in my reading applies
> perfectly to this situation, thank you.

Because it is in the Coding Style it has been approved by the
Linux Kernel Technical Advisor Board.
