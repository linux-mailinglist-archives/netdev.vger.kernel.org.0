Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA21639718E
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 12:35:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233514AbhFAKg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 06:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhFAKgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 06:36:54 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1A4C061574;
        Tue,  1 Jun 2021 03:35:13 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lo1jq-000Xrw-7v; Tue, 01 Jun 2021 12:35:10 +0200
Message-ID: <0555025c6d7a88f4f3dcdd6704612ed8ba33b175.camel@sipsolutions.net>
Subject: Re: [RFC 3/4] wwan: add interface creation support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     linux-wireless@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        M Chetan Kumar <m.chetan.kumar@intel.com>
Date:   Tue, 01 Jun 2021 12:35:09 +0200
In-Reply-To: <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com> (sfid-20210601_112832_203691_AAB7DA4E)
References: <20210601080538.71036-1-johannes@sipsolutions.net>
         <20210601100320.7d39e9c33a18.I0474861dad426152ac7e7afddfd7fe3ce70870e4@changeid>
         <CAMZdPi-ZaH8WWKfhfKzy0OKpUtNAiCUfekh9R1de5awFP-ed=A@mail.gmail.com>
         (sfid-20210601_112832_203691_AAB7DA4E)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > +int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
> > +                     void *ctxt)
> > +{
> > +       struct wwan_dev_reg *reg;
> > +       int ret;
> > +
> > +       if (WARN_ON(!parent || !ops))
> > +               return -EINVAL;
> > +
> > +       mutex_lock(&wwan_mtx);
> > +       list_for_each_entry(reg, &wwan_devs, list) {
> > +               if (WARN_ON(reg->dev == parent)) {
> > +                       ret = -EBUSY;
> > +                       goto out;
> > +               }
> > +       }
> 
> Thanks for this, overall it looks good to me, but just checking why
> you're not using the wwan_dev internally to create-or-pick wwan_dev
> (wwan_dev_create) and register ops to it, instead of having a global
> new wwan_devs list.

Uh, no good reason. I just missed that all that infrastructure is
already there, oops.

johannes


