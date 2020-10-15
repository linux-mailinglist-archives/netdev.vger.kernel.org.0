Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F05728F9E0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 22:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727224AbgJOUDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 16:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726142AbgJOUDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 16:03:50 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2DAC061755
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:03:49 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l24so8661edj.8
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 13:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S7HzwVjSno4y7wZKs3op0DJ4j+ctb3DSm6IetgL1pfM=;
        b=DCx6mVO2H3W0hZk1CaSADyaKUDhiJQgtUR5LPdAYNj/IyXSCnEOdCtR05BwSl22WKq
         0CG+OWwYzTTidXEwSwwmyHC8TB9YcEEf3ez9WdFzfh10A7aO78a1OCH1bugIskmjJS+b
         laQ9Ap7yDV4FlpzJQ4ereRiBjgI4namIQQJBqJWHzpzejW3MqP0C8dIqnlQ3vywmfyZh
         ccYgywQ057E9bnf9phLFi3AeDX9DE1A/52jRSkuYsaZnAXkBhSsQMEPKk4dobxtNxY5x
         cOAgg0fJw4VkCOkJn3ecv7BywpZUoY949AakFSfK7BrBl4/0okTsrF5C81lk2bBCQGz7
         Lr0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S7HzwVjSno4y7wZKs3op0DJ4j+ctb3DSm6IetgL1pfM=;
        b=RPuBnFpLD1d03UzCeBHkTTVooKdurGywv0uYRRQ2HBF4lvX/Sa8Gzz+q6F38baJiXW
         dTMAurGbMIGZUs172IUNSsJrAju938FUXAPe1sTRmz+s23lX2ESKjBv5pPDB2+6xpqM4
         9TY0CGh4cQ3IzDTgWBfFt4Ms6jdYOXYk3Q/LhjnfxNWoa5wBG1M10QPK8Gl5m9gPGV5q
         qzyX7uEFoZIHWzQAKu9se7ZuqM64CKHghRA/gK7wR3/AH20RO4Z32j3M/4d+kn8+Eqk0
         5HILuxWXmqgwJ9bZoyJf66Qk77xdzD64yHltM0O9klWuO0mt9AYvb0e9XZV8MrXJ2ep5
         y2Og==
X-Gm-Message-State: AOAM533QpxEXil0wGHugkXZs8D9HFgihdfrgKNXOUdFtVHAS0PkuU1LV
        dXrg/mGV1SiLKZn74KOxLabu9xIAJaN3iL0c/YWlPpwQwoA=
X-Google-Smtp-Source: ABdhPJzcdHHCHOXNedPj4PFfA1i7uFGU43/kQkt8EqSMFVIzOjUBSVHB6NfA4JxAMGtn2TKdAEQSPq+WCdeJq7kGoPM=
X-Received: by 2002:a05:6402:32f:: with SMTP id q15mr126898edw.230.1602792228141;
 Thu, 15 Oct 2020 13:03:48 -0700 (PDT)
MIME-Version: 1.0
References: <20201014222715.83445-1-awogbemila@google.com> <20201014222715.83445-3-awogbemila@google.com>
 <20201015113228.4650680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201015113228.4650680e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 15 Oct 2020 13:03:37 -0700
Message-ID: <CAL9ddJfxNK-dJo0XHx7ngrU1F1m+qfTj9VNN1rZ9ZtY+McewOA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/4] gve: Add support for raw addressing to
 the rx path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 11:32 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 14 Oct 2020 15:27:13 -0700 David Awogbemila wrote:
> > diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> > index 008fa897a3e6..47d0687aa20a 100644
> > --- a/drivers/net/ethernet/google/gve/gve_rx.c
> > +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> > @@ -6,6 +6,7 @@
> >
> >  #include "gve.h"
> >  #include "gve_adminq.h"
> > +#include "linux/device-mapper.h"
> >  #include <linux/etherdevice.h>
>
> Why are you including the device mapper?

oh no .. sorry this is entirely accidental, I'll remove it.
