Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC792212DCB
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 22:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGBUUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 16:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgGBUUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 16:20:30 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31A2CC08C5DD
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 13:20:30 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id l6so26907844qkc.6
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 13:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dg7b2Gpb1xwhbPPAs3f/5zlrWsmCaI8VPFPJDIO7oCs=;
        b=LpHBpy/61tYHcbDhOlQTjymqaKpK8J7rjMk4O+FxTS5NK5wsajUBEDiNHJEIxDNrmb
         A/vjKlla5gFM9d87viW/fHklmhK1tz+CtGJjuLrOgKm1ZEF2DF0uohGaSUa3Od6uFgwF
         IwHbe9Uqjfw7uPuVBoh6o2uO3A9wCt0Y8mEwBxwU9GfTM8E8u1sUqDN/34Q6gUmbE6EE
         ziMKMEkt0n4svSAzY7929lErAeLqCQMYa4VIMUTzg5NGv46LiX8uJXvBZ8rB8C3++1H4
         P9iDLw5QIGqyZfad3TJGYKL8vyWL6exkLjaf4NXLoRBjSGaOQyIA7Z8ANbrxEJFmW8s1
         EKsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dg7b2Gpb1xwhbPPAs3f/5zlrWsmCaI8VPFPJDIO7oCs=;
        b=FHvSIQPLIUerssCrTqdUMIdtgC5G6qVTX9+JIBGZoWkm46YnUiy2vHNtPPS1t4N36w
         N35SZIHrijGYRm7KjIuUJQStpzUmJWA/JiAszbjezpHTrxg2hEz/A41/MyeTrKpOhVoi
         PcvZ2+JoOJlT8lhUmxcPiuXABDCcNRKbw0gaLUv/9rVCGDLGGcmcm6yKZ9yIeznWUVsr
         1BJilL2j5DT+cieM0D2ZB43dpHxqeiqMh1cA7X/7IeySS4jUol+YyUnIkun+Kk+U9lMX
         0PdcyW6NXtyg0qeqrmD50MtcM8iE/e/FFP+1AtjfWqIZ4UEDr635F3yayyyhbvNOagO+
         +9Qw==
X-Gm-Message-State: AOAM531o8oVPNPahAr1l/q1l659+qMV4qQX5c3E6zx9DMmT+OIU5xipK
        VxYHEGcE+u8sXP+Pq5B2PScr22VIXpBv10nqqOVntw==
X-Google-Smtp-Source: ABdhPJzESDQ4tCGpwJuT9gwjDr5sMmtLBgj+5Xday1tr8AbXF/DNxfrO2eOsGxU2iUNCm4NFuhVI4oXEJD/1BRXoKqY=
X-Received: by 2002:a37:a5cc:: with SMTP id o195mr32699648qke.326.1593721229404;
 Thu, 02 Jul 2020 13:20:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200629211801.C3D7095C0900@us180.sjc.aristanetworks.com>
 <20200629171612.49efbdaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+HUmGjHQPUh1frfy5E28Om9WTVr0W+UQVDsm99beC_mbTeMog@mail.gmail.com>
 <61CC2BC414934749BD9F5BF3D5D940449874358A@ORSMSX112.amr.corp.intel.com>
 <CA+HUmGhfxYY5QiwF8_UYbp0TY-k3u+cTYZDSqV1s=SUFnGCn8g@mail.gmail.com> <61CC2BC414934749BD9F5BF3D5D9404498748B57@ORSMSX112.amr.corp.intel.com>
In-Reply-To: <61CC2BC414934749BD9F5BF3D5D9404498748B57@ORSMSX112.amr.corp.intel.com>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Thu, 2 Jul 2020 13:20:18 -0700
Message-ID: <CA+HUmGi6D8Ci5fk7vyengJN4qOEH6zz18Kw6B9Us-Kav-78oAg@mail.gmail.com>
Subject: Re: [PATCH] igb: reinit_locked() should be called with rtnl_lock
To:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> So will you be sending a v2 of your patch to include the second fix?

Yes, I am working on it. Just to confirm, v2 should include both fixes, right?

Thanks,
Francesco
