Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3AF5AF1D8
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239279AbiIFRH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbiIFRHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:07:19 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB697C763
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 09:55:20 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c198so2109068pfc.13
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 09:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=UkLsIRoPITN4M5EzGiQRq9TqbBIEfHXPT42QowPDTAk=;
        b=VkdNrQ2BR/DXUgBnBjQUwdGEN3P1EBFQR3Vqf246bk3JTQ1z78wN2if1HjfXgRXnUX
         6r5KD+qbcI4iEp//nHG3ED7ydyEXos0ianjzn8xgP0kld5HYEOUGBOg5RM7c40Bxaktv
         8aj30chWZRDWd/lfhyo9DEbPzMaFCdPkUnNDGtoNBmVEKcGWihKuy5ifMnqmvFwRbLSE
         gImMqCQEPniOkYwNvvf6NEZCXTJxsNY9DKG9/74FXlTZMG2JUJssmzJk31BpSTYhr+XM
         wWtwD7X/HMs6w50v0l4Htqwc1VVvvn55o61gVC24FC3Nf+nlRw6iNqKQdJX6IGCN0hQ+
         FMZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=UkLsIRoPITN4M5EzGiQRq9TqbBIEfHXPT42QowPDTAk=;
        b=hvC1xEAufXERfkxMWjZg80UbGjqYTESD0ygRZIPuOd1RpKZ4mMbouy/wkK/yFLkiSL
         ++uM56dK75G/zubIis3uaitFbL+ReNiWdIJbJuIwb9pqZ7HdXSpDdAcETW6HTfWfsrsO
         ewhyTL7j7ZG9jKOkl8ZBdxSZoNM+Ck6gonGNwLiai1vC9HvlhEvoQSUD5lM2sY5Ry/Bs
         nl6DuOICUvcKrtxThlrcs29IOBXMTmCtIhIvmeLKo0be0h7ZJTEqyoMMO4Vz08K1AYsk
         zMwDEL8n5jbitkhKmsFAq/xWBv3ZLB2TfMUsa8vOVWizXNNRFoY8ToPpfeKVqSko9xf6
         Ywmg==
X-Gm-Message-State: ACgBeo2Uw1IWvI2Q78GXpc9RvcydB4WPojxjySCEIVTmB+vbJJX4R/bW
        y4iDXxfU3akb80HmqmjZpqzWCQF/6OnBKg==
X-Google-Smtp-Source: AA6agR7bCRaA6MAYlL6dGNA93H5MHQXixdbUu4xtrisnia0ZcuBwh+gv3fn4zjMKKi+S1HBL8uSsCw==
X-Received: by 2002:aa7:9dde:0:b0:53e:5af7:ac10 with SMTP id g30-20020aa79dde000000b0053e5af7ac10mr1037809pfq.16.1662483319350;
        Tue, 06 Sep 2022 09:55:19 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id r12-20020aa7988c000000b0053612ec8859sm10329345pfl.209.2022.09.06.09.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 09:55:19 -0700 (PDT)
Date:   Tue, 6 Sep 2022 09:55:17 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220906095517.4022bde6@hermes.local>
In-Reply-To: <20220906164117.7eiirl4gm6bho2ko@skbuf>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
        <20220906082907.5c1f8398@hermes.local>
        <20220906164117.7eiirl4gm6bho2ko@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sep 2022 16:41:17 +0000
Vladimir Oltean <vladimir.oltean@nxp.com> wrote:

> On Tue, Sep 06, 2022 at 08:29:07AM -0700, Stephen Hemminger wrote:
> > On Sun,  4 Sep 2022 22:00:25 +0300
> > Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> >   
> > > Support the "dsa" kind of rtnl_link_ops exported by the kernel, and
> > > export reads/writes to IFLA_DSA_MASTER.
> > > 
> > > Examples:
> > > 
> > > $ ip link set swp0 type dsa master eth1
> > > 
> > > $ ip -d link show dev swp0
> > >     (...)
> > >     dsa master eth0
> > > 
> > > $ ip -d -j link show swp0
> > > [
> > > 	{
> > > 		"link": "eth1",
> > > 		"linkinfo": {
> > > 			"info_kind": "dsa",
> > > 			"info_data": {
> > > 				"master": "eth1"
> > > 			}
> > > 		},
> > > 	}
> > > ]
> > > 
> > > Note that by construction and as shown in the example, the IFLA_LINK
> > > reported by a DSA user port is identical to what is reported through
> > > IFLA_DSA_MASTER. However IFLA_LINK is not writable, and overloading its
> > > meaning to make it writable would clash with other users of IFLA_LINK
> > > (vlan etc) for which writing this property does not make sense.
> > > 
> > > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > ---  
> > 
> > Using the term master is an unfortunate choice.
> > Although it is common practice in Linux it is not part of any
> > current standard and goes against the Linux Foundation non-inclusive
> > naming policy.  
> 
> Concretely, what is it that you propose?

Maybe "switch" instead of "master"?

