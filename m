Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE75A2BB
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbfF1RuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:50:25 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:38510 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfF1RuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:50:24 -0400
Received: by mail-lj1-f176.google.com with SMTP id r9so6815273ljg.5
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cXFG8aRFKmNI+Gch7Iq8Txc60jEsyL7gHu504nZhfww=;
        b=qMl7NAQjJu0lDXsvreek14vupq+8Ef94lYvdYnh7BEmpiUmtujZmU2K1xfga7CZF6n
         3R1yDRASHMvldnFtys2ZpRYy0FdrIniCVKqdr2m/1mwUZhNyEGE+Zyga8JOfB07sTswh
         z82/BSw/Q1H+x4ttVjEPmQsCkgt6VLxlIRxEVAPQ3soiryC6qyZDjwCwXKmtiaApnGfa
         PfHudHs2uiUAAPdWPYiNAI2DNHfmf9HCi4ZworMU9l+lfN9vsdr+K92T6Inbjw+CPnmV
         Fd5OhwxVOlSTUm+LM72V0JpsUvW0d2PwvkBjtw+zoJzy/TE53ooxKoOrT1396geDs1Fa
         qC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cXFG8aRFKmNI+Gch7Iq8Txc60jEsyL7gHu504nZhfww=;
        b=ffLkpkEmryLniFuniW8dEqC9gDvyh0w8WFZ6i1xrB4doce4adwcfMnas1Akaju+a1Q
         huvxWFbmBTTvUu0Ynu5uKHlNEGPfbOys1jN72de0luhH4CAHo21S2aPEyCrADR32Gy1v
         tXrTWgsyN1W7g2S4g9LN6KjJocG2cLi6h6b0mZ516BwrAhnHa9JScBFnWzWpBcSKB3de
         8FlbUVL0jZ1XxCuz/F1PvYlmQpTxmU9AkajRbuMKospD9MgnOTbkDOEBH5GiHyvrGTpl
         2sgBA55OsfMLMynjiGTWuB9Z3s51tbtivQ8JtuyDWi7b1qD1RJRb/lOB/z9FrdSUOMDP
         LolQ==
X-Gm-Message-State: APjAAAXQEqQ+njQoXb8WxEZP1vgdmVRcQuv3Pqx/cy2TfmkZyqqETMUV
        eNLTHrqujxk1g7pT8cG9jX5OQLjU6imrZd9StzsjRg==
X-Google-Smtp-Source: APXvYqyINnmV//vrGqvK0qk1D7uKuMz96YRm718LaK7PTq8zH9U7yqecyhNqsRzyUnerRNz7O5dYyQ4/D52oTKbzhJ8=
X-Received: by 2002:a2e:5b1b:: with SMTP id p27mr6673676ljb.97.1561744221798;
 Fri, 28 Jun 2019 10:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-3-csully@google.com>
 <20190626194203.GF27733@lunn.ch>
In-Reply-To: <20190626194203.GF27733@lunn.ch>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 10:50:10 -0700
Message-ID: <CAH_-1qwQZz5H9uQn21Vuob8PKs0-SNYh21=Q+G064OkLUUrzTQ@mail.gmail.com>
Subject: Re: [net-next 2/4] gve: Add transmit and receive support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Sagi Shahar <sagis@google.com>,
        Jon Olson <jonolson@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 12:42 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static int gve_change_mtu(struct net_device *dev, int new_mtu)
> > +{
> > +     dev->mtu = new_mtu;
> > +     return 0;
> > +}
>
> The default implementation does this.
>
> Also, i think your mtu has a limit of PAGE size.  So you should set
> the dev->max_mtu so the core will enforce this.
>
>     Andrew

Ah, thanks, gve_change_mtu will be removed in v2.
We already set dev->max_mtu to PAGE_SIZE in init_priv.
