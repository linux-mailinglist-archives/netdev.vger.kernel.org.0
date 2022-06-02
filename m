Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41FAA53BDA9
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 19:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237456AbiFBR5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 13:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiFBR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 13:57:05 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F59A6451
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 10:56:58 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y187so5376247pgd.3
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 10:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ems8PWEuJ/fW2BfgzSOOWAd0N2Cz4ChOr6Nu4ne2Q1Q=;
        b=BksTUY1mSDCjjBOEGPvJ4MIQFrPfOCl6NJf84ziigdz6yWlgtmaRA0/TUSmsxdkY/W
         ubUQt3+FB1upqMfWo7T8aPHCMFkEglx0dNt3aLAWeoDiaOFTUvim84hzWlo0MLFiLZmy
         ZZwlmVjJjhs8O2Segxm03E1ACFHg1oBTUEpKZmnwTueyFzfVSKxKcjmP8biet+3YRBrB
         SluBoywwaRWwjKr96uiKe9ZrzqhOlN2/LP0V9XMnj0CEMZ8v/DZSf5lph9laq75ql4yH
         8r7cwAnWe0n+XN54wtnE8FxBy8s+ESoi+8MPASa+w6qvI88BrK9/KpP/ZP8IZn3Qh+pg
         zhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ems8PWEuJ/fW2BfgzSOOWAd0N2Cz4ChOr6Nu4ne2Q1Q=;
        b=D8/T/4WGLAT0Z3zUJ+UVWBzbtleo5CBYrP/ISTITbVNNI4YoaVK5sW22ZG94SpHLkb
         oW66jA/x03B05z9jLUByE3C8DyVLUXk36/H9fxsAFDJjLKmpnQj0aEvy7d0rA40p4I9A
         lcw6Ko8a676cXskKG0lnBILQpeCEfWO84vHmsPWsl213UuyP6Cb5WTJAahuHL22ica4/
         3TZALOqhxUsIbGN3p8XVBR+De804h9Pkl/z0L/+Voj3TaGBdPH2sf/cWaJbkUlbwGTET
         QIGJJIWqwFfz3WHSwC6oF4fxTfpG/AF24rlabszToesIdmDBadoVLYkH3vhLbOTeuaiU
         vEnA==
X-Gm-Message-State: AOAM530DyIjst5zA11N0GWC4u8l9DzWVk+wQrSJ5rak9NGhts8FbC633
        D0dc3BI+EjrJxPIse4+rt59fGg==
X-Google-Smtp-Source: ABdhPJz4S7rMnMHxqqAo4/YnhWfch2/dCiAGMXbZdi+BIM8YEWu71usXFn2nsGu1uBlz2P5kRAP9/Q==
X-Received: by 2002:a05:6a00:1745:b0:51b:de90:aefb with SMTP id j5-20020a056a00174500b0051bde90aefbmr171584pfc.11.1654192617855;
        Thu, 02 Jun 2022 10:56:57 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id c3-20020aa781c3000000b0051b9ac243dfsm3785488pfn.119.2022.06.02.10.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 10:56:57 -0700 (PDT)
Date:   Thu, 2 Jun 2022 10:56:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220602105654.58faf4bd@hermes.local>
In-Reply-To: <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
        <20220601180147.40a6e8ea@kernel.org>
        <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
        <20220602085645.5ecff73f@hermes.local>
        <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
        <20220602095756.764471e8@kernel.org>
        <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jun 2022 17:15:13 +0000
Joakim Tjernlund <Joakim.Tjernlund@infinera.com> wrote:

> On Thu, 2022-06-02 at 09:57 -0700, Jakub Kicinski wrote:
> > On Thu, 2 Jun 2022 16:26:18 +0000 Joakim Tjernlund wrote:  
> > > On Thu, 2022-06-02 at 08:56 -0700, Stephen Hemminger wrote:  
> > > > > Sure, our HW has config/state changes that makes it impossible for net driver
> > > > > to touch and registers or TX pkgs(can result in System Error exception in worst case.  
> > 
> > What is "our HW", what kernel driver does it use and why can't the
> > kernel driver take care of making sure the device is not accessed
> > when it'd crash the system?  
> 
> It is a custom asic with some homegrown controller. The full config path is too complex for kernel too
> know and depends on user input. The cashing/TX TMO part was not part of the design plans and
> I have been down this route with the HW designers without success.

Changing upstream code to support out of tree code?
The risk of breaking current users for something that no one else uses
is a bad idea.

> >   
> > > Maybe so but it seems to me that this limitation was put in place without much thought.  
> > 
> > Don't make unnecessary disparaging statements about someone else's work.
> > Whoever that person was.  
> 
> That was not meant the way you read it, sorry for being unclear.
> The commit from 2012 simply says:
> net: allow to change carrier via sysfs
>     
>     Make carrier writable
> 

Setting carrier from userspace was added to support VPN's etc;
in general it was not meant as hardware workaround.

Often using operstate is better with complex hardware did you look at that?
