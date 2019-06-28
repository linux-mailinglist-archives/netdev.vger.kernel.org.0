Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B5E5A2D1
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbfF1RzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:55:08 -0400
Received: from mail-lj1-f170.google.com ([209.85.208.170]:33422 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfF1RzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:55:08 -0400
Received: by mail-lj1-f170.google.com with SMTP id h10so6849599ljg.0
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y0s6HPqY/rnDRcqUTFqbv4oQufnfq3U/uRBLMHxugPw=;
        b=EctJSKRkKiUddr8dAef3LZrLbZWT5sNtzn6VPNZIWf34TRiCdXbEdZd/vN72pvg2U3
         zjNlxv5EIPWXEf0RWSezcVsjh57Nd/S8InPJAkw8fYggcRE/XqsUfXTZb9nLLskIGrut
         poxgWnDQSmsti88yIwMBufaCxdtf/WnnJuo1MbTLsMwmCt+T0jTggsDPvlOJhiF4NWfs
         zoFWIxo05k7GCWUDYq1xLgj7uWydIEu+lMCLL0+U9fioFJPhK/0SVuYuivdUih+saFPH
         lrXyN6lkbAdKDdeI14bCdNvIygkQZtoNUrtWUBMVSENX7XE0Py9OVwmmVLTJU4t9hysA
         t7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y0s6HPqY/rnDRcqUTFqbv4oQufnfq3U/uRBLMHxugPw=;
        b=EyqK4aD2GepiYPbIsMMOr66lFgWYcZhgh5Ko0TS9Amcgu8wwgyStszKhcBaV/oukwr
         /qcUvIEK92fIBz5CWx8/HaCMB+Nf0bkgsPFXqrHafxTgNhKMDUkLKWeqA1aOIOinBHiS
         xDwBEMTy90iu/SQwnayV/cHuCwKk40gd3xU3UROaZcZQyH4lDTSp9ObUpgmXQ/BIloVc
         7ge/5rlIjAU4MwLrNOnSobSmJ5RDQRYv0vQ1ZKYsZNYOQpAeMeUjhtrU+5EkFPC3mEUf
         u1zYseWDswnSVI1PdEIwLivTz6sDGNZ3NyxGDvsvAoWZqP98RGBj2fhhEVzuKlerd7Rd
         ulbQ==
X-Gm-Message-State: APjAAAWB7Uda/Tt31IFSEqCZFi62VR9WXVuFesuqwjZy5Y1xXSULs8Cb
        kidAtu8FSWSNEK9DpYJIJEQZNWfN6lXobHqX3B/A1Q==
X-Google-Smtp-Source: APXvYqxucbF9+Io2ELwqZxzFqhQ5FLm4O7Udx908+A3JmVqjETWdBZrgcHDZlxJFUu4YBw8768MYqxftcFlUdnGVb50=
X-Received: by 2002:a2e:9754:: with SMTP id f20mr6872067ljj.151.1561744505536;
 Fri, 28 Jun 2019 10:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190626185251.205687-1-csully@google.com> <20190626185251.205687-2-csully@google.com>
 <20190626193509.GE27733@lunn.ch>
In-Reply-To: <20190626193509.GE27733@lunn.ch>
From:   Catherine Sullivan <csully@google.com>
Date:   Fri, 28 Jun 2019 10:54:54 -0700
Message-ID: <CAH_-1qxtAORrqcBFqKUa_5xn-6h6j25P7BMgVkJr3pL+z2GnUg@mail.gmail.com>
Subject: Re: [net-next 1/4] gve: Add basic driver framework for Compute Engine
 Virtual NIC
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

On Wed, Jun 26, 2019 at 12:35 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Wed, Jun 26, 2019 at 11:52:48AM -0700, Catherine Sullivan wrote:
> > Add a driver framework for the Compute Engine Virtual NIC that will be
> > available in the future.
> >
> > +static int __init gvnic_init_module(void)
> > +{
> > +     return pci_register_driver(&gvnic_driver);
> > +}
> > +
> > +static void __exit gvnic_exit_module(void)
> > +{
> > +     pci_unregister_driver(&gvnic_driver);
> > +}
> > +
> > +module_init(gvnic_init_module);
> > +module_exit(gvnic_exit_module);
>
> module_pci_driver()?
>
>         Andrew

Will fix in v2.
