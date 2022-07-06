Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709EF5686B0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbiGFL00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbiGFL0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:26:25 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A61F1A3BF
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 04:26:24 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-10bffc214ffso10307171fac.1
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 04:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6JhYiXfPTefnZ8alx5Q4UAUNwD9Vz/k+0x/z5Yi/oDg=;
        b=fZbnjxO+fibxgjSJe6crnp7wIiNfV0d75W1TjnpH/OYBXTafaq2v6GpyV+gpuVg20R
         8qumWaYJYFNla05ZHMbnuEcdTb6YaffG72Y38mNRCfZc7OAr3p+LpN903NIzirM3VHbk
         UfzyA3/Zg82CzOPBsfaOCdL1l3OnZSlkPtMLWdDA2UcXPrdkCbTH3xkfRQhAr1DMpEy3
         uGLiyVfb5zdXU45VJXSOPwS8vWlCsal/PfJlDgpNObZwcbfWnUjdTGnR9zW+QZsRWZRn
         xXC+glX7B+j1pXigfXhPZVXDJfsgleJWwFrYPFCqixBn5RhDCagWaWJbYjef3eE3GIw2
         K+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6JhYiXfPTefnZ8alx5Q4UAUNwD9Vz/k+0x/z5Yi/oDg=;
        b=5pT17WEnT3dJhsM6U2jIuNYLpIAo46iBp2ZrihID/F7QqIOHN+uigEuhzOGFg8Ni3Q
         G2vlvB7ZmwTYxo0fn8uu+P0f/zkG/3UrmmIWRjzT6ka90SDMG7x2ukCd5WmL4GCSgvQ4
         vhFD2c2Qjd5WcXPlsDfxKWaGcouVIarAlw2jyyup5ySOy7EJwWkBU0SJ7Kx3LwB3tcAt
         0S24R7Y/5K4fkfpq8lZDvM/wIKq/gHjfrB39XHBJJvUwzeyvEDKBFXPKKmeWaYsGDZPr
         yZmH5Cp8G3A5JZFPBjGmU4F2154CHuYo4K1MaXY1RbuG8mrIR/dBvZ96wNsEa3ihOtlI
         eQNQ==
X-Gm-Message-State: AJIora/ZnzFFegJ6ffgESmngX/oylCWS+kiJjq6evj3+OEqTN05DFhup
        7IlELqmo3rLYBz9hXBFrzLQdbUjQYgO+mHATv0ZYxQ==
X-Google-Smtp-Source: AGRyM1sPFswMntX5l2bi+LncZixUW5W8TY1pPn3KuuZHSnJvLH1tbSUJOGA/T73pKWXiDpRP/WH0uO+uXlKR8TvOrwA=
X-Received: by 2002:a05:6870:a191:b0:10b:f366:8d1b with SMTP id
 a17-20020a056870a19100b0010bf3668d1bmr10945681oaf.2.1657106783861; Wed, 06
 Jul 2022 04:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAM0EoMkWjOYRuJx3ebY-cQr5odJekwCtxeM5_Cmu1G4vxZ5dpw@mail.gmail.com>
 <YsMWpgwY/9GzcMC8@shredder> <CAM0EoM=Gycw88wC+tSOXFjEu3jKkqgLU8mNZfe48Zg0JXbtPiQ@mail.gmail.com>
 <YsMgv2plWTuWcd4X@shredder> <20220704120719.505ed58e@hermes.local>
In-Reply-To: <20220704120719.505ed58e@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 6 Jul 2022 07:26:13 -0400
Message-ID: <CAM0EoMnoJq_4BRoTUxoSMfWDnydWC4xJhuhrfmpWC5AujmLrow@mail.gmail.com>
Subject: Re: Report: iproute2 build broken?
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Petr Machata <petrm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 3:07 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 4 Jul 2022 20:17:51 +0300
> Ido Schimmel <idosch@idosch.org> wrote:
>
> > On Mon, Jul 04, 2022 at 12:59:45PM -0400, Jamal Hadi Salim wrote:
> > > Thanks Ido. That fixed it.
> > > General question: do we need a "stable" iproute2?
> >
> > Maybe a new point release is enough (e.g., 5.18.1)?
>
>
> I don't think this is urgent enough for another release.

I was more wondering whether such a process even existed - it seems to
but then what is the criteria for deciding something deserves another release?
What was the motivation the last time?
Distros did their own thing in the past...

cheers,
jamal
