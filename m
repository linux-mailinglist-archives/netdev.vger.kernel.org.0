Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C52DA371545
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 14:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233662AbhECMdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 08:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233336AbhECMde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 08:33:34 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9215AC06174A
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 05:32:41 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d11so5350559wrw.8
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 05:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ZlZNvnRym2MDQbFd2HN5geIh0ymC5AhetOzMMU4oqI=;
        b=AzCU1KJg5/MOElK12MA/FlJUSqjOjFzj3GMw+afpkRNv7h2Ldrf9LE78zkdN9HMWqm
         zGYh6+DKToLWUsJraM14oJ/O6qYGGlJtfYls62DqsmeXHQYIgoCjeS+ogQc1BvRUWhu7
         jMlRdTcdN6eZrTp85y4rWeYnG1ORRPAyz3YoMvXq4JYnWuYLP2mfVs6/6R4gU0jMdiZO
         stz+DOr5s06pF/57lt9QRXgvouZEWEYNRDjKpgygDPI/V8nM73+IcM8wEa8TZ4UepIYM
         6cVOXQkD/L+Sc4GLJYMIE2bV+M3fghOPRRsp1br5lSFevKn2vouLF7PUNtWgNC0dbJTO
         t9yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ZlZNvnRym2MDQbFd2HN5geIh0ymC5AhetOzMMU4oqI=;
        b=eZ/v4QfujZ0+2mEzaeDZV/+XYZPUPq0j3jwjPHBvhfPcX5/7EIcODyLRojsnkqxoBN
         4Pm/37ual1fMPicD9PzHtShF+5peshEgpaPgHV8+KiwHfgyIMPM6TzmhkG+3JYyZUU5J
         XpPKMr1nBBJMn1vVvm6HP4qGIKvCpFjMPDmLmKPedKqcURz7duZrgRdDJMy/+yDcJaa4
         o1RzTSoEZv4GM84G99GvNuzTXDPqsUizMGsJSI3aJn+8yn5lVBUFWcDupWwXNWPnFoKg
         WfMpGTWMtOIQOwecXxaSG7ZqqDLn5KCQrd2G4k6Cb5fwP+YS7IdpGEYZo1KEwufUR+nK
         8lOQ==
X-Gm-Message-State: AOAM531nTu9PaGks36BFgofJ4xzF3D4uWBFIA0mNsWUpszD1ClV/TTdG
        7k8/xVsl/mnczVvEdU7UZLpi8/m3oGWFc0IbObLcTtNl7SmmcA==
X-Google-Smtp-Source: ABdhPJzXmQCqXWnlCtcTTIGowjDEsO2sYyajSabEJJz6+xQOL2wtqJIfyu8TA3bdE+ti0qDGZZ8gmC91Ju6KgtlClw4=
X-Received: by 2002:a5d:610c:: with SMTP id v12mr24879954wrt.57.1620045160042;
 Mon, 03 May 2021 05:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <20201221222502.1706-1-nick.lowe@gmail.com> <379d4ef3-02e5-f08a-1b04-21848e11a365@bluematt.me>
 <20210201084747.2cb64c3f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a7a89e90bf6c3f383fa236b1128db8d012223da0.camel@intel.com>
 <20210201114545.6278ae5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <69e92a09-d597-2385-2391-fee100464c59@bluematt.me> <CADSoG1vn-T3ZL0uZSR-=TnGDdcqYDXjuAxqPaHb0HjKYSuQwXg@mail.gmail.com>
 <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210201123350.159feabd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 3 May 2021 13:32:24 +0100
Message-ID: <CADSoG1sf9zXj9CQfJ3kQ1_CUapmZDa6ZeKtbspUsm34c7TSKqw@mail.gmail.com>
Subject: Re: [PATCH net] igb: Enable RSS for Intel I211 Ethernet Controller
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Matt Corallo <linux-wired-list@bluematt.me>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Now that the 5.12 kernel has released, please may we consider
backporting commit 6e6026f2dd2005844fb35c3911e8083c09952c6c to both
the 5.4 and 5.10 LTS kernels so that RSS starts to function with the
i211?

Best,

Nick
