Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA1C2A26CF
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 10:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgKBJSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 04:18:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727818AbgKBJSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 04:18:50 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582E2C0617A6;
        Mon,  2 Nov 2020 01:18:50 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id r10so10245970pgb.10;
        Mon, 02 Nov 2020 01:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=C6EWmjCYcjXlVuyLZRKUgfoLilwqmfMB+owPMFBnb9c=;
        b=lqbbb1CuBH5eNHB+N9qLO4cm8cvi81NiGiv31bIGOb9Z0OAU3l/5nuLwb0vZO5VAnc
         FEDcOl0s69baIoU66mtPLi4ns3NtJZEeV7tDuQgSWtKg/w6Uy4gsdeKKFNIMegHiwmmY
         N1X3ePnP/HkuORodQnZZt4m9DBgpWfPfap1fji64okr+4Wr3Xt/gdHEhZX2LFsg6Yb3f
         6yUIQRr/KxFvD0on0D87mkrrHctXOTUFCbVxIAnkH1Y2Ym+8RP07Ke8Ai/GNOyLnlSe0
         07a3qX4l36fPErokAgiyKupIL8ICK/Ec6soFM9Kka1GSbGes/buF+kVlYgDlvlrV+j3h
         EHOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=C6EWmjCYcjXlVuyLZRKUgfoLilwqmfMB+owPMFBnb9c=;
        b=lz4TM7G424ITt2fH50bbLymL7POe6VcmiOFPkRmhHf5M7/Jz5OG+UzNk/i+lhtGDCn
         VHZDndhjWIH5qJlL1e5Z3BouBs0SBfA2b9XxKr5GAzBEv5HGGmrQps5tvY/8lcy2z4Ky
         dvT/4Wd/IpFUgeoV7f3ZDSCNms0AKB/Ha5hKI7KG7+ciA6vEi+3JT1Fwv1hrEFXkIcWh
         oJ1yMUJffnHRazMO5nAuxm+cfKpItKfkdn4mX7w+oC3NswEIxNAIwzCUFlC4roiHulce
         A6GlKwpQNVxkO8bl913oZ0CXLlfyIzj7itqeVy44TG9P1vbvz1QobVDRcAnA5kUFQc7z
         29Vg==
X-Gm-Message-State: AOAM532FOSiYA9g+lFlmC/HV72uJtfdsqqkI0AZXnXY3UaUWCD1RBfVS
        /Dv14I/R1px6LeBFNCE2IxM=
X-Google-Smtp-Source: ABdhPJwzD+VbIsMSXDRvOKgyBYSwbhoC1uwCxcueL1tYtFiAGqBfS4tnG1G/k6VNjo4gFo61zBqJAA==
X-Received: by 2002:a17:90a:7886:: with SMTP id x6mr16220678pjk.21.1604308729837;
        Mon, 02 Nov 2020 01:18:49 -0800 (PST)
Received: from [192.168.1.59] (i60-35-254-237.s41.a020.ap.plala.or.jp. [60.35.254.237])
        by smtp.gmail.com with ESMTPSA id nh24sm10707447pjb.44.2020.11.02.01.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:18:49 -0800 (PST)
Message-ID: <47e149dfbf84e685f8b81e4561b8c9fd375cbcb4.camel@gmail.com>
Subject: Re: [PATCH 2/3] mwifiex: add allow_ps_mode module parameter
From:   Tsuchiya Yuto <kitakar@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@intel.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>, verdre@v0yd.nl
Date:   Mon, 02 Nov 2020 18:18:44 +0900
In-Reply-To: <20201030110246.GM4077@smile.fi.intel.com>
References: <20201028142433.18501-1-kitakar@gmail.com>
         <20201028142433.18501-3-kitakar@gmail.com>
         <CA+ASDXMXoyOr9oHBjtXZ1w9XxDggv+=XS4nwn0qKWCHQ3kybdw@mail.gmail.com>
         <837d7ecd6f8a810153d219ec0b4995856abbe458.camel@gmail.com>
         <20201030110246.GM4077@smile.fi.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-10-30 at 13:02 +0200, Andy Shevchenko wrote:
> On Fri, Oct 30, 2020 at 04:58:33PM +0900, Tsuchiya Yuto wrote:
> > On Wed, 2020-10-28 at 15:04 -0700, Brian Norris wrote:
> 
> ...
> 
> > On the other hand, I agree that I don't want to break the existing users.
> > As you mentioned in the reply to the first patch, I can set the default
> > value of this parameter depending on the chip id (88W8897) or DMI matching.
> 
> Since it's a PCIe device you already have ID table where you may add a
> driver_data with what ever quirks are needed.

Sorry that my comment was misleading. I meant using the quirk framework
(that is based on DMI matching) I sent in another series. This applies
to the other replies from me.

However, thanks to your comment, I remembered that currently, the quirk
framework can be used only within pcie.c file. For example, the quirk
initialization is currently done in pcie.c file. The mwifiex driver is
divided into interface-specific modules (PCIe, SDIO, USB) (e.g.,
mwifiex_pcie module for PCIe interface) + common module (mwifiex module).

So, I need to extend the quirk framework so that it can be used by the
mwifiex module globally.

I'll make a v2 version of this series with using the updated quirk
framework so that it won't change behaviors for existing users.


