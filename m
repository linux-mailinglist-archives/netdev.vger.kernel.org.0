Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6CF53BBFB
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiFBP4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiFBP4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 11:56:52 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E4D2CDFA
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 08:56:49 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id z17so5097961pff.7
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 08:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SX4g0utFC0ceL8tMKRQwC2iIsma38jKpvtUu58uhBbE=;
        b=59TTOOyM1z6aHhIev2+SflM2UqA3r1U4BAZXQSiLUDGWZerCBzhRKM1fU5SKouMe8+
         F8rSZH8LwQa6YwSMTy/NFwacy3aKqiy+6rcXvIhZ+kLC69X9B8Ng4lXSI6D5it1GbhCF
         IbgShTwjyNncdf7UoGE+pRzKR3j9usPGsI/gzWAnBEDKqKEnZ6vAUB2+9UC1Kk5Ws2af
         VW64DlnmcijJHXbXj8DZ86uvcCg/XpxTt4kKoAOApvgsb0U5JHTd4OoCfw3K2yuY/pjn
         3+ZHcVM5yXuGNcl2Xqr9Q/6WpNIWT4GZpgNJevtlPEP5T4J3ROAoiAHRPwMAog5ooEGQ
         HNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SX4g0utFC0ceL8tMKRQwC2iIsma38jKpvtUu58uhBbE=;
        b=NRIFyC4mWv7h2YhTeXBI1hHJ1wOyC4p6Wn6G0DRx7wc9OAJ++AyU/GMe+tNsuEVleK
         7Spi9QyaaIC8snttlKI9iEM4I24/a39GTtMkkOh7o09SMTa9kb9v1Nc9JQ5pMQCTL4le
         07BXwPDYE6Uy0ueWZz/+2aQ1Gsqpxf8dlcDuZ/nsAvCfEJwzSMqu0hgeUdU52/dZnO7K
         Q0Lwyrg4JqedHrwEUWhCztrbvuld0u1Wh0va1tpo9ZUPpnqmd+37GwXFdPUc5u0KKFiF
         qDJpyaFl9fTqeTDPMkk54EQ83WTwKAH/3l732eXTHYkcavyoKZMzJTf1SySDTVne97az
         0X/g==
X-Gm-Message-State: AOAM532iat5u64IGsFAEvBL4dC4FL55toiztix6LieK56xkTUrJ4pPVt
        7zPtctZDK1Xteafz+H4GG/ou3YK1960Qvw==
X-Google-Smtp-Source: ABdhPJyHlsKqI1hNSXzfEVIX6NKg5G708y17Rl3FOWZRz+eGgUh3jmJ4RFf6F+2kTWKM/ZnS9gR9pg==
X-Received: by 2002:a05:6a00:234b:b0:519:c7c:e58b with SMTP id j11-20020a056a00234b00b005190c7ce58bmr38712186pfj.32.1654185408749;
        Thu, 02 Jun 2022 08:56:48 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id 190-20020a6219c7000000b005184c9c46dbsm3661377pfz.81.2022.06.02.08.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 08:56:48 -0700 (PDT)
Date:   Thu, 2 Jun 2022 08:56:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <20220602085645.5ecff73f@hermes.local>
In-Reply-To: <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
        <20220601180147.40a6e8ea@kernel.org>
        <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
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

On Thu, 2 Jun 2022 09:22:34 +0000
Joakim Tjernlund <Joakim.Tjernlund@infinera.com> wrote:

> On Wed, 2022-06-01 at 18:01 -0700, Jakub Kicinski wrote:
> > On Thu, 2 Jun 2022 02:35:23 +0200 Joakim Tjernlund wrote:  
> > > UP/DOWN and carrier are async events and it makes sense one can
> > > adjust carrier in sysfs before bringing the interface up.  
> > 
> > Can you explain your use case?  
> 
> Sure, our HW has config/state changes that makes it impossible for net driver
> to touch and registers or TX pkgs(can result in System Error exception in worst case.
> 
> So the user space app handlings this needs to make sure that even if say dchp
> brings an I/F up, there can be no HW access by the driver.
> To do that, carrier needs to be controlled before I/F is brought up.
> 
> Carrier reflects actual link status and this kan change at any time. I honestly
> don't understand why you would prevent sysfs access to carrier just
> because I/F is down? 
> 
> >   
> > > Signed-off-by: Joakim Tjernlund <joakim.tjernlund@infinera.com>
> > > Cc: stable@vger.kernel.org  
> > 
> > Seems a little too risky of a change to push into stable.  
> 
> The change is minimal and only allows access to carrier when I/F is also down.
> I think this is a kernel bug and should go to stable too.
> 

For many devices when device is down, the phy is turned off so the
state of carrier is either always down or undefined.

That is why the code had the check originally.

