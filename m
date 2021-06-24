Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C443B344C
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 19:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFXRI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 13:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhFXRI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 13:08:28 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13032C061574
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:06:09 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n23so4490171wms.2
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 10:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YO5sAu1hHI6h64ve39mHrabpVWMOQcT3wz+GPwVoue8=;
        b=Vnp0DbUE61vkxPGv/tgAUrY+kzNKj0kS5XHs8c1/ldHFu1FOg1EZiMzDGG3VK8wNGe
         ztYOvjCAnsKK+17WjHNv51YHOdlR9gixZ+d0onAfJC+XKhxsFucR/qqRZndAGEL6syT6
         koC0q9fZE30Kc4bg8GWjmiDCtiNRVJm5ORLkRzbGGosfTrBQxRn21rIOTHtaay/1Q9tf
         HwoEkzNg4RRoWMbUIbe843FnkzhpOCNcA+ldr5IWg31iwyPhkXvaTz9b26EAS5LmktiA
         IVP5Vb75gQtPe7mRo7b9sHLW4aQTsLtosT4p7ocilsQqGUW0FeTSqyBu8Cyf+3/qb5nL
         rZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YO5sAu1hHI6h64ve39mHrabpVWMOQcT3wz+GPwVoue8=;
        b=nURXCJA77Jc1ie8xop/oBUPJ4v8vcG/Ltp51h/sACFX1YNqNi/POFdsoTeNTT9ZS+w
         u0NIL0jz3WFoiI5Gl0SnB6yeHCxunUVmW3Ihn+nnVoeiXD/EaVY20dLyLBgACx6EC14P
         nkmJBz7t9/apmO2yTQi789Zr78/b4QcM6bBcFLxTciGrYVuCvFdZFPC2MVMGBt4wvyTm
         zquLJ9aq1IOvt/5VHNanHVHKVHgIbjH2hcoQQhT05F4Yv8jMQtu6qVdZC+JUYjftuOaG
         EhybgDKUEnzd9Wdk8cDCJ1l16sXOWjCDith/58HWqnFTTUDG9gaW7h2Uoa7FSvKK+FWO
         hXGA==
X-Gm-Message-State: AOAM531YfWRbhnOqKuVHrBirL6nWpYzQ5HiwnTt15nxfWHw3Zeb/awxG
        2jbeHF4apj7n4kdaCZxKrTiAeEyzS67GlznAMTA=
X-Google-Smtp-Source: ABdhPJyA1AYi2iuJJzbpcjadMHoYApbn80qJLqmt/Bud3Sl2rhVwQcdiNf9nOTFBl0vp19p5rN7KhO6Zb6zC0+Xeg6E=
X-Received: by 2002:a1c:a707:: with SMTP id q7mr5531840wme.144.1624554367532;
 Thu, 24 Jun 2021 10:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210624041316.567622-1-sukadev@linux.ibm.com>
 <20210624041316.567622-3-sukadev@linux.ibm.com> <CAJAjEthEoZk8LLWhhwMaTy0nrh5qaeY6ouUu--Uv2D_Zr+1pug@mail.gmail.com>
 <fcabc0b3-8b1f-3690-37ca-047ea34101e2@linux.vnet.ibm.com>
In-Reply-To: <fcabc0b3-8b1f-3690-37ca-047ea34101e2@linux.vnet.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 24 Jun 2021 12:05:56 -0500
Message-ID: <CAOhMmr5M9HD=io2pDYtWasePcvh_RD0K7-PrQj2M=MqCbX5D5Q@mail.gmail.com>
Subject: Re: [PATCH net 2/7] Revert "ibmvnic: remove duplicate napi_schedule
 call in open function"
To:     Rick Lindsley <ricklind@linux.vnet.ibm.com>
Cc:     Johaan Smith <johaansmith74@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Networking <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>,
        Brian King <brking@linux.ibm.com>,
        Cristobal Forno <cforno12@linux.ibm.com>,
        Abdul Haleem <abdhalee@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 2:29 AM Rick Lindsley
<ricklind@linux.vnet.ibm.com> wrote:
>
> On 6/24/21 12:02 AM, Johaan Smith wrote:
> > On Wed, Jun 23, 2021 at 11:17 PM Sukadev Bhattiprolu
>
> > Sometimes git bisect may lead us to the false positives. Full investigation is
> > always the best solution if it is not too hard.
>
> I'd be happy to view evidence that points at another patch, if someone has some.
> But the original patch did not address any observed problem:
>
>       "So there is no need for do_reset to call napi_schedule again
>        at the end of the function though napi_schedule will neglect
>        the request if napi is already scheduled."
>
> Given that it fixed no problem but appears to have introduced one, the efficient
> action is to revert it for now.
>

With this reverted patch, there are lots of errors after bringing
device down then up, e.g.,
"ibmvnic 30000003 env3: rx buffer returned with rc 6".
That seems something wrong with the handling of set_link_state
DOWN/UP. It is either the communication protocol or the VIOS itself.
