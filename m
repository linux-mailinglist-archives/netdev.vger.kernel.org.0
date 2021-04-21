Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADB6A3668D8
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 12:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238213AbhDUKIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 06:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234167AbhDUKIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 06:08:20 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C834C06174A;
        Wed, 21 Apr 2021 03:07:48 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 130so2753153ybd.10;
        Wed, 21 Apr 2021 03:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IxtoLKTcNO5Tz48UiqjNhZ/CEX6Syyk0csYSCJ1EA5s=;
        b=BnOzNssLioOapGwcFlNtyvHqNowmMfmkvqYw6I0SnOJD8oUGZ2QVCH21hKl6rnUb65
         G/HOWpWTRkEQqi7etcbU8t23DG5ukbXVSAOwS6qviS0p4j5RxoZFYXZRHbp0Sxcps7o1
         07O+5h0PjOiPhZkrRZ8E1nF3D/3JEGIIZPAx66FMbLd6zQGO9UoCt4mEjJSjbghUXSDm
         Nhi/EyZGnRY86qkXPrmA7tFXHdvgYAaYNRvJ8QBruyllVZqbI912sj2ugY9eXClWiT9D
         SvZmm/Z8m0ypZBghiEPXfo0x63zRO09FSe1kV6iPAPboA52aiFYoWUjLeQSWdF8mEgI/
         ZW2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IxtoLKTcNO5Tz48UiqjNhZ/CEX6Syyk0csYSCJ1EA5s=;
        b=fT5Y5gyHbfn1+uiJgu/LKtJw4iMvOP6y+d2h73YXrwK82TB9CeoGh/RZYskBgvQe8f
         s+2k4jZ1mpijIS/QYhZmLE91bhxJ+uQcWiaHHKlAfT/VVCVgmgA7KZ2n2mWNnpRCW8KG
         QMvcSfUm5p1BsLLJ1nRoCCQe3qvzp+uImizpogww7Wpz4Pi6FcycENZL19D9W/6y2UHA
         fjY59dLE9zLcryufXOb3ZfmqmeRd1SOkXB8NCypQqewqfQcTP5tKobPDdZ9Mkoc2MGe6
         67sJqPYjv2JYntPsJxTPI+XHaOwYmSDepc4ozjtvXKU3NUr/RPxP0/YdcaHKhk7nBkbo
         aEcQ==
X-Gm-Message-State: AOAM533BkgXw1Jql+T9Js9GfosDGwhoWK65YktHcUEqM6pN93n0FHy8f
        9T/eq+aentXLeQyoR/LKI/BZVZzM0T2XS0ckxJn5OGzP0iQ=
X-Google-Smtp-Source: ABdhPJxHfFryJf1Ntt5ODk+DfiPTB6caeoWLJWg1RZRncnB7tjS6t+0VOJJAmImZiOzJZL3wSnay8GYGbJVHPNGPm6w=
X-Received: by 2002:a25:81cb:: with SMTP id n11mr29862288ybm.98.1618999667508;
 Wed, 21 Apr 2021 03:07:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210407001658.2208535-1-pakki001@umn.edu> <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org> <YH+zwQgBBGUJdiVK@unreal> <YH+7ZydHv4+Y1hlx@kroah.com>
In-Reply-To: <YH+7ZydHv4+Y1hlx@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Wed, 21 Apr 2021 11:07:11 +0100
Message-ID: <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, Apr 21, 2021 at 6:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > If you look at the code, this is impossible to have happen.
> > > >

<snip>

> > They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> > accepted patches from Aditya and 3 of them added various severity security
> > "holes".
>
> All contributions by this group of people need to be reverted, if they
> have not been done so already, as what they are doing is intentional
> malicious behavior and is not acceptable and totally unethical.  I'll
> look at it after lunch unless someone else wants to do it...

A lot of these have already reached the stable trees. I can send you
revert patches for stable by the end of today (if your scripts have
not already done it).


-- 
Regards
Sudip
