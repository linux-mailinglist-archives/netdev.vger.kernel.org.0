Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF211B54F7
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgDWGxZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 23 Apr 2020 02:53:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54628 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWGxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 02:53:25 -0400
Received: from mail-pl1-f199.google.com ([209.85.214.199])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1jRVjf-0003hx-B3
        for netdev@vger.kernel.org; Thu, 23 Apr 2020 06:53:23 +0000
Received: by mail-pl1-f199.google.com with SMTP id s1so3928142plp.21
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 23:53:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Brn70UkrdEH9wF8l6cReBO011o8Fv5QqqLg/eGvIrCI=;
        b=jtvkjDih15HEU4RAL1uTrebmnCRCbzKJR7ZGwUpZsFgoOqNaY7e8JhqcbEDt6wr1rr
         1MzsTuzR1dIkOG+Lce/Z2tjlzDqa3AJPUBbfaLGTw4PBOkqUh+Dms8YYfpfoBj08iD65
         fx7l2sF124s2Sq/xNLgz/Rxy7aVTebBLw/BeDUHjM0RLSyLdpaY7D6eFojoVmnyRhNBC
         oCEJu3VVXpZ9OcYSGLYQAcfVD8oWjQBWRi5z0c3BDghe6AabazXiCEbGRuYENA8XMn9/
         0sP8MEfhSGUvG01zcq98EBNRodrqZkRwoZB54Mxf+gC5pQ5yHzNUAxgCPkWjdTaRG/IU
         X14Q==
X-Gm-Message-State: AGi0PubXGngkgIh14jjNEt9BhFtgOBs9xmd5UYZgWIvtpS/hBu6JCXj6
        nm1lMhdYW4VSFiTkcRjyI6Aa8FnH8Y0yu+qmRrlJvBp80hzTZFdavBH2XVz7MhVL2qE1I3se0WC
        1vhH50y60/z8oTD/SIlEVGezSO2es9RhBuw==
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr2202449plc.209.1587624801890;
        Wed, 22 Apr 2020 23:53:21 -0700 (PDT)
X-Google-Smtp-Source: APiQypJjjevu44Y1bDstf34odxPmWbk2i8mHMY4lhgtg04FGkpDdcGX8ckb4H8mS0HyeJuNBf7IfnQ==
X-Received: by 2002:a17:902:20b:: with SMTP id 11mr2202437plc.209.1587624801597;
        Wed, 22 Apr 2020 23:53:21 -0700 (PDT)
Received: from [192.168.1.208] (220-133-187-190.HINET-IP.hinet.net. [220.133.187.190])
        by smtp.gmail.com with ESMTPSA id n9sm1289198pjt.29.2020.04.22.23.53.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Apr 2020 23:53:21 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH 2/2] rtw88: Use udelay instead of usleep in atomic context
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <87h7xan1cy.fsf@kamboji.qca.qualcomm.com>
Date:   Thu, 23 Apr 2020 14:53:18 +0800
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <D2ACB475-AE1A-41D1-BEB9-1FC30DA13AE8@canonical.com>
References: <20200423063811.2636-1-kai.heng.feng@canonical.com>
 <20200423063811.2636-2-kai.heng.feng@canonical.com>
 <87h7xan1cy.fsf@kamboji.qca.qualcomm.com>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 23, 2020, at 14:49, Kalle Valo <kvalo@codeaurora.org> wrote:
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
> 
>> It's incorrect to use usleep in atomic context.
>> 
>> Switch to a macro which uses udelay instead of usleep to prevent the issue.
>> 
>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> This fixes a regression, right? So there should be a Fixes line.

Yes, but the regression commit isn't in Linus' tree, so the sha1 may change.

Kai-Heng

> 
> Also I can't take this until patch 1 is in my tree. And I don't know who
> takes iopoll.h patches.
> 
> -- 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

