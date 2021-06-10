Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAA13A33AF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 21:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbhFJTGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 15:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbhFJTGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 15:06:43 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE375C061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:04:37 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c9so3449606wrt.5
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 12:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wgnfCHIBKLuJBy4h/q9Om0xGxAY+JZ7s+fe3Rk3GZ6o=;
        b=oWQ6ZR5bBBsSPhrGMq64ANhq3BqJ6FyxLCW7UbPbWTYQLkWWMGaVter5AMiZf8eyGl
         PerDBwjmTXYD/RzlNj7qSCE47v06MKhosaKwU0ZWLskAw/wsHZ8rtI+ePBRodMErLXgB
         Gpdm8aBw5222brjm2c9IyJXoZCJoVofP1GVXFWx4WMU6nZ+EFen8A747AMLBWLSPrHpK
         zQwQs4mTKRTs9u4IdY3qDJ6lttera+qRTK61tnR99dZFP5PB51soSSSwiWBX5NgRQzXi
         ins+M5C2Yn/3/gj1vh7Yifl8GCL0B5FuxcPpART0xHqlMAXXSzOnf1ad4TYxLmS0chcn
         GZrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wgnfCHIBKLuJBy4h/q9Om0xGxAY+JZ7s+fe3Rk3GZ6o=;
        b=NXYJD3t25vY3Aq379ghShBRK4Kj1b2AmqrspetA80ZSALG2osZtaC/YC1Z52C/21mB
         6PvN8u8jbUTU80MVmPA+vzVgbmkZ4JzkqtHvJcmlPW+b1BF1KMR5oCtA485hQsW8HLUF
         nszsQ0i0NOO37rxgbIvQpIpOi5zt7nwcFH68uFsbVk9r3QPFnWjXc/LGtdLoLlYBChrR
         Vw8hTeDFD91Zl7Em5V3UyhUooQSg2UDRzykPNbDo1U+GMiKKgDK8S631+BLHSwOlBiwd
         uZG3+YKguvJcMExpVu13B9NicWJkwZ4h/nnr9UiaVkKhHQ26FErXqN91O1jyzgbkhLsm
         Ip+g==
X-Gm-Message-State: AOAM5316d7pcKaejVj/Y6pB6GKawFfxVh2sJejBh7VGhGCu1ExGOX446
        7lmaHWdZnJq9YIm1f90ot1LYUlHMfLRvz9mINhA=
X-Google-Smtp-Source: ABdhPJxY7OjtdrnPlEFWKLIG3QO66ic5LiDyFcPwHwlnzBp2Ujl/FMtdrUBY+D8LvrCQuFmIf/7PmWHXLbcAIa5Oqgk=
X-Received: by 2002:a05:6000:1a87:: with SMTP id f7mr4308wry.172.1623351876444;
 Thu, 10 Jun 2021 12:04:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210610170835.10190-1-cforno12@linux.ibm.com>
In-Reply-To: <20210610170835.10190-1-cforno12@linux.ibm.com>
From:   Lijun Pan <lijunp213@gmail.com>
Date:   Thu, 10 Jun 2021 14:04:25 -0500
Message-ID: <CAOhMmr4KjBwH-vU7Z22wpap89=FtwcrYbKah8yvu=eGrnqU76g@mail.gmail.com>
Subject: Re: [PATCH, net-next, v2] ibmvnic: Allow device probe if the device
 is not ready at boot
To:     Cristobal Forno <cforno12@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Falcon <tlfalcon@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 12:11 PM Cristobal Forno <cforno12@linux.ibm.com> wrote:
>
> Allow the device to be initialized at a later time if
> it is not available at boot. The device will be allowed to probe but
> will be given a "down" state. After completing device probe and
> registering the net device, the driver will await an interrupt signal
> from its partner device, indicating that it is ready for boot. The
> driver will schedule a work event to perform the necessary procedure
> and begin operation.
>
> Co-developed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> Signed-off-by: Cristobal Forno <cforno12@linux.ibm.com>
>
> ---

Finally, this important feature patch is approved to be sent upstream
after almost one year "censorship" and testing. And the original
author, Tom, is not with the team anymore. I have mixed feelings about
that, but any way,

Acked-by: Lijun Pan <lijunp213@gmail.com>
