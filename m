Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B05379035
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 16:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238193AbhEJOJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242181AbhEJOD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 10:03:58 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C369C0611A6
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:44:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso11192115wmj.2
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 06:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7aoIoj2Atw6ljmq40JQ+QDXCweymh1iprobxTPx3gvE=;
        b=unZihUVV3tKmX3JM7Nd8WU9KBbkSDvoV3Qr+zEX8cRWK2deZxnMcyN87mFj1sMx7j8
         ALFYjLaFbCpyrBzjHFJfULjZbgRqVed8HWuvFHOs4ZtRa6UPbaT7zdpUAVcNdCh+dEIQ
         GaGBDZCmCHL6tVUUyhObeAAJD+Mg/5I+ppIIt4/eQZw/KGL0b5/SVFtyKwobWk1Rebj7
         8Nwln/ERCseZP2v/4M7LCqNAFUBcToOrz43fFAR7IQrdTrU0UvkJJYDvW0Kd0XZvGOpV
         MjNLGK+ddgga0KAZP6FKmTq+ok3Q/RzPDu8wmffmU/B8kyp6t1mgGkGJ0yBnIgSHF1EW
         ijwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7aoIoj2Atw6ljmq40JQ+QDXCweymh1iprobxTPx3gvE=;
        b=iPxgAWcKT+rwPyspquKHguYsupPlRm3Ahjo0RU3WhCxzO0hlUsSL4ngtzbjp7Vffsy
         v488IllETaZm0KSUArxftPfzrDRTIOGndvG6vxe3kBUlsypayH57YjQRGxZBDJPZuXv8
         88AqvolTF6Y4AIVdh5d/OdmdBUHp71R2PtCua3uH8Ge/fNTj34qJKi4XdDYpAO5enpWO
         nbDIPT7FKfhJ8tWG5N+xCvIJxNVFpG54KZapHkzUzV0A7F9jFr9moTcowHgESO4XgBga
         6LTgapyRWBg0a27TqZez6UL8dP3xQdc5CLcpdOh4KkmQ1aCALvxTvE85vmUK2SCBho/f
         /urQ==
X-Gm-Message-State: AOAM530ik3Sy2CiSfCdJkioSf4hNgnWMuyOH8pLYChiZsLi73fRPJRz1
        TGD1/poCeJHmORymtpVdzhvA/bfKq7cKbyuTbrg=
X-Google-Smtp-Source: ABdhPJwvjlKheMZb3UZHs1dWvCiX7pEibR0ABd7lBuxH0C/L1+YcGe6Z0Ox56E/Uwn34ROHBnRY0bErGlLsI36/CvMs=
X-Received: by 2002:a1c:401:: with SMTP id 1mr36645845wme.138.1620654251882;
 Mon, 10 May 2021 06:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20210416204500.2012073-1-anthony.l.nguyen@intel.com>
 <20210416204500.2012073-3-anthony.l.nguyen@intel.com> <20210416141247.7a8048ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b2850afee64efb6af2415cb3db75d4de14f3a1e2.camel@intel.com>
In-Reply-To: <b2850afee64efb6af2415cb3db75d4de14f3a1e2.camel@intel.com>
From:   Nick Lowe <nick.lowe@gmail.com>
Date:   Mon, 10 May 2021 14:43:55 +0100
Message-ID: <CADSoG1uYJGygF9rm+15BE4gy=RU9EBbmGv_+pzddrKLJLdV14w@mail.gmail.com>
Subject: Re: [PATCH net-next 2/6] igb: Add double-check MTA_REGISTER for i210
 and i211
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Siwik, Grzegorz" <grzegorz.siwik@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Switzer, David" <david.switzer@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

> > Looks like a potential infinite loop on persistent failure.
> > Also you don't need "is_failed", you can use while (i >= 0), or
> > assign i = hw->mac.mta_reg_count, or consider using a goto.
>
> We will make a follow on patch to address these issues.
>
> Thanks,
> Tony

The patch for this that has been queued is as follows:

+     int failed_cnt = 3;
+     bool is_failed;
+     int i;
+
+     do {
+          is_failed = false;
+          for (i = hw->mac.mta_reg_count - 1; i >= 0; i--) {
+               if (array_rd32(E1000_MTA, i) != hw->mac.mta_shadow[i]) {
+                    is_failed = true;
+                    array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
+                    wrfl();
+               }
+          }
+          if (is_failed && --failed_cnt <= 0) {
+               hw_dbg("Failed to update MTA_REGISTER, too many retries");
+               break;
+          }
+     } while (is_failed);

https://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue.git/commit/?h=dev-queue&id=9db33b54fb98525e323d0d3f16b01778f17b9493

This will not reset the counter when checking each register and it
will not debug output which register failed, this does not seem
optimal.

Could it make more sense to instead do something like this? (Untested)

+     int i;
+     int attempt;
+     for (i = hw->mac.mta_reg_count - 1; i >= 0; i--) {
+          for (attempt = 3; attempt >= 1; attempt--) {
+               if (array_rd32(E1000_MTA, i) != hw->mac.mta_shadow[i]) {
+                    array_wr32(E1000_MTA, i, hw->mac.mta_shadow[i]);
+                    wrfl();
+
+                    if (attempt == 1 && array_rd32(E1000_MTA, i) !=
hw->mac.mta_shadow[i]) {
+                         hw_dbg("Failed to update MTA_REGISTER %d,
too many retries\n", i);
+                    }
+               }
+          }
+     }

Best,

Nick
