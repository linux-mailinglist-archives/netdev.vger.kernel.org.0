Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6C620711E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 12:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388607AbgFXK1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 06:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388176AbgFXK1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 06:27:22 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A32C061573;
        Wed, 24 Jun 2020 03:27:21 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h19so1913507ljg.13;
        Wed, 24 Jun 2020 03:27:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J2MV0mam45EwIsPoyMX/nBi9KSxxMizw5CtJ6VCGjo8=;
        b=hMkCoL5ZOxiq80mZR2E1yBYK4igFfXdls3natzutOiX8GHy2vAgudRg0pSCXgf5aei
         fqORfN9MsDaLDNrrREl/+9/kGSgfynXkVDwdJTctDVVLN5VyntxkGjJ+EEdM+iEqOmLH
         ZGTpNJkGcfv1TYwLr0ySGtlQyzyygrPTWVGgycTvvj8qES7Q4NFsKESznJF6DKpCQFeh
         w5gSuzwvrJMAJeufx3TuENz0uFon7l/MBmrvjhrnUi/b4BbnLH20yLBX94yJN3RdTtM4
         vQnbqttXBjNVR4f+26QzFou0j8m050xHuvF4zl7OnpiUwpuvk3ahFPZaLoc8k7QvDqo0
         6V9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J2MV0mam45EwIsPoyMX/nBi9KSxxMizw5CtJ6VCGjo8=;
        b=FNBZyYxKxXtBDT5phSvqY0zEEMcPVSHM8Y5acUDQiMQWBRzqt+Qlinu/VzAVIqFVYe
         Zy37L4Nd9EhhMbpS5mE1YsrZFwxmcTxrFUJL5FguwImMszE4hj3if7gYA/UO3g4fXti3
         kRfysVNnfWV2u3A1qZlhTBF3TYxIql+TNIDL2yPJZARBdJqYn5/6ZYvD+rvEgvk0oJ6j
         H6khOQNIuINBuhy3FVBG43j3WKnPZoCzixTx/TDwLeDKdRLNsN0hrV8YENEzwSs++pW/
         CbuP360SVuhxjVmfkXRFtdGBP4SQUogqf69f1T/fg1YG+YCI2bkq0qq+NxUtqxvNXE1b
         Bt+A==
X-Gm-Message-State: AOAM533o3Rstz8RZNpZNX4hDbmyILLyHP7acUHSJI8Js4RLYMLWgtP6X
        0SY6nDNPgMacSoY4zVIJAydgihGroIAWEEHMK+k=
X-Google-Smtp-Source: ABdhPJwnBG/FDVDXsJX7ZVeVksmpwY9Fy+BMeTQ4IyHtEGNMeGi/EEoFgXsRrbtj7CwQuPPGJyFiPAZ/R8VsDmfNepI=
X-Received: by 2002:a2e:95d9:: with SMTP id y25mr14201341ljh.167.1592994440297;
 Wed, 24 Jun 2020 03:27:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200615154114.13184-1-mayflowerera@gmail.com>
 <20200615.182343.221546986577273426.davem@davemloft.net> <CAMdQvKvJ7MXihELmPW2LC3PAgXMK2OG6bJjPNJkCgE6eZftDVw@mail.gmail.com>
 <CAMdQvKtrzFtg9PwZhyMQ96S48ZLG5gAu3gk8m=k+tFVMHeshXQ@mail.gmail.com>
In-Reply-To: <CAMdQvKtrzFtg9PwZhyMQ96S48ZLG5gAu3gk8m=k+tFVMHeshXQ@mail.gmail.com>
From:   Era Mayflower <mayflowerera@gmail.com>
Date:   Wed, 24 Jun 2020 19:23:28 +0900
Message-ID: <CAMdQvKubUYCMRt0V+koj8nKAq+nZNABJZMAXX7jB-_fRiPeJog@mail.gmail.com>
Subject: Re: [PATCH] macsec: Support 32bit PN netlink attribute for XPN links
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 1:32 AM Era Mayflower <mayflowerera@gmail.com> wrote:
>
> On Wed, Jun 17, 2020 at 10:02 AM Era Mayflower <mayflowerera@gmail.com> wrote:
> >
> > On Tue, Jun 16, 2020 at 1:23 AM David Miller <davem@davemloft.net> wrote:
> > >
> > > From: Era Mayflower <mayflowerera@gmail.com>
> > > Date: Tue, 16 Jun 2020 00:41:14 +0900
> > >
> > > > +     if (tb_sa[MACSEC_SA_ATTR_PN]) {
> > >
> > > validate_add_rxsa() requires that MACSET_SA_ATTR_PN be non-NULL, so
> > > you don't need to add this check here.
> > >
> >
> > validate_add_rxsa() did not originally contain that requirement.
> > It does exist in validate_add_txsa(), which means that providing a PN
> > is necessary only when creating TXSA.
> > When creating an RXSA without providing a PN it will be set to 1
> > (init_rx_sa+15).
> > This is the original behavior which of course can be changed.
> >
> > - Era.
>
> Sorry for the time issues, just noticed I sent the previous mail with
> future time.
> Fixed it permanently on my computer.

Hello, is there any news?

- Era.
