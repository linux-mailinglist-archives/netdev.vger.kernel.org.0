Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 465A31FFAA2
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 19:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728465AbgFRR4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 13:56:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgFRRz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 13:55:59 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D6C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:55:59 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s88so3007419pjb.5
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 10:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VCeBvfPPvDQCgJSGe2MLS0zfKEsiI5wPyYxSAGm8deM=;
        b=GYU2jefiB/mBr1lTKHxXDfGk5w5nRr1Mju7fUw4cvUcTqmKzceW21ZEW18SxYfGNZH
         o5h9d+rINvAq6jSRppCxiBRMnPgiLNOpokoz9xu8j9RxoqQ0xJyNoO7hACwPvSEgRhvX
         VZdCpBz8i4wzHCwIKrlYUFqM1E5TLFP/ztUXPhx9I9q+ZO5dcb4Z+6lHsPnroiEX7A1x
         bE8QcfyxBINOQrGOiWgtIRt6wP5xMW6jDrBsnf/CouFIuULuwIgXu4fsQwZithF/G+bc
         0CRTNpo9KVaD7z+D7NVjBDCOauQsbyVKa/8yR4Hrj3RBPWO8JCegxjGNs2Vo9zFi1kr8
         /OWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VCeBvfPPvDQCgJSGe2MLS0zfKEsiI5wPyYxSAGm8deM=;
        b=JJ30i2XJv3s3k2k3/eOzcquRBRKevxYlNK2x8oGAhVwhSY/FQrv5lk8PB1eEhKVWzO
         iwcom+zrTfwEFfX7Zp4GpahSOH3j1a3sH+U3xn9gZMqxqJc5SYsLn8YFv6/Cem0KA1o/
         fd8vefo+W1H92SQoR8q03NMnS93UqGoZm6P+gaecCHBnUbPbhcmrJkH1/4Rnlk9So86e
         DbnqJXjYYxh5fSjFHKasOb/rnGOTtFFBQ8eUzrnYOBtmU8nuI21mp7jcM2aBHvA6uxw6
         KqGrkbpKoM/B5SaSocKikuXFxWHR1xDET0BoPfjXm+i4M9A2YdCFIv873Oi49m4vhoTw
         uQbQ==
X-Gm-Message-State: AOAM533YjCo4IudP2aAESV0scuATczjBo+FxJq3NEf+L7vuo1xOQUePX
        3F9C4l2pIPRPM9CJ2fuceCeEeH+p18qR7Xi6OnxIpvTm
X-Google-Smtp-Source: ABdhPJxCgugSR/md/M2LSa3afLoD7EkCR8xOABqkXs32t3gLc+ZF9CrJvr11/EpqqS9k4kN/3qegE7Hiqh5ZlYsQwPA=
X-Received: by 2002:a17:90a:b30d:: with SMTP id d13mr5298446pjr.181.1592502958976;
 Thu, 18 Jun 2020 10:55:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200617171536.12014-1-calvin.johnson@oss.nxp.com>
 <20200617171536.12014-3-calvin.johnson@oss.nxp.com> <20200617173414.GI205574@lunn.ch>
 <a1ae8926-9082-74ca-298a-853d297c84e7@arm.com> <CAHp75Vdn=t2UQpCP_kpOyyX_L6kvJ-=vtWp2t87PbYBbJOczTA@mail.gmail.com>
 <20200618174252.GA9430@lsv03152.swis.in-blr01.nxp.com>
In-Reply-To: <20200618174252.GA9430@lsv03152.swis.in-blr01.nxp.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 18 Jun 2020 20:55:46 +0300
Message-ID: <CAHp75VffyjomUmQixHV7aeuSD1yjh4oKwUcTwyss=thkmMQVNQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] net/fsl: acpize xgmac_mdio
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 8:43 PM Calvin Johnson
<calvin.johnson@oss.nxp.com> wrote:
> On Thu, Jun 18, 2020 at 07:00:20PM +0300, Andy Shevchenko wrote:
> > On Thu, Jun 18, 2020 at 6:46 PM Jeremy Linton <jeremy.linton@arm.com> wrote:

...

> > And here is the question, do we have (in form of email or other means)
> > an official response from NXP about above mentioned ID?
>
> At NXP, we've assgined NXP ids to various controllers and "NXP0006" is
> assigned to the xgmac_mdio controller.

Thanks!

-- 
With Best Regards,
Andy Shevchenko
