Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A4D52E224
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 03:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344572AbiETBrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 21:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiETBrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 21:47:02 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE08D682B;
        Thu, 19 May 2022 18:47:01 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g12so9025490edq.4;
        Thu, 19 May 2022 18:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+xlTXsyAk/e17efczng1vq07W7jlbD6xzsBBuyJVH0M=;
        b=GkqvcdD+0YJpEcVANimuYVf/KRbU9litcoLK9LAQdwwAwhxmW6TZVLck2rOwTfhwP7
         Ww9zps/HifFzI0/JK1YbC7MGq2V4ep2eY4yJUfm0OLmUVxi03iGtsscYSnyCIu7kAfZg
         sTyYHn6SG11Sg4c/4fiv6KOWk3Xn8YKRKKMYIQCApUP4F6x9l/hjyTDivHo6AL0tKjDB
         r1fnCpxTiZIb5U/HFYIyA33eOthrjWw2F/1VMJwTVca5CM0rZPQVyMbzWsfUnlXRhz5H
         hg2JfmsLgURkQFATxhp63Ncx1b946PdyluW6Ztxg1K2wYydo30n9HmiuKW2n9gW8GnLA
         3dYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+xlTXsyAk/e17efczng1vq07W7jlbD6xzsBBuyJVH0M=;
        b=e8PcSay0cIDMKX09WUcahP7bKOwu0rS4On06qGUyAUEHTukfsxLkdEQ81VGJXrfrU9
         e1bXc6Y8k5CSRB0aHVbchlr8uobG3/jq1DQUBVZnm5nbl+uJAoREi6rNDFJq3W6CL/rR
         3i6bj4jGcqTdT2j3LvxLq8xTPMudIVP4bGUhk7MCXgW2WqD1VuhxpGAGZZm3rJsQaXcp
         bZNo2cBLUTsSnK3n1PgRrO2ET3FRvjyPaIhsVo4yNvVGMD/8gkr/FDFy2pq5i+U0cSd8
         xFuFMJezDaMwcHRljf4tKMr4aQ0XyhTnEElvsMAI11OjF4L6asa1j/D/qjcPJ/pjLm/Y
         H/hw==
X-Gm-Message-State: AOAM531bzRVt3ISIHCZDPE2PROe76NxfS1O6u3XRipRg5a1QPv3ocvZP
        /bXiRYOPQKiiJ3J0vCGgqM9zsj+wMKMTEszyPV4=
X-Google-Smtp-Source: ABdhPJwsOwN4tXqZjr4Z+fT7Lprmq2WVwCVuB9M2pLJ/hNGSKetnhJs2huDWD9s4qPSgcCcOtWZz4DgBVNzreP30q8o=
X-Received: by 2002:a05:6402:c17:b0:42a:b3e0:cbd0 with SMTP id
 co23-20020a0564020c1700b0042ab3e0cbd0mr8362638edb.213.1653011220172; Thu, 19
 May 2022 18:47:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220513030339.336580-1-imagedong@tencent.com>
 <20220513030339.336580-5-imagedong@tencent.com> <20220519084851.4bce4bdd@kernel.org>
In-Reply-To: <20220519084851.4bce4bdd@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 20 May 2022 09:46:49 +0800
Message-ID: <CADxym3Y7MkGWmu+8y8Kpcf39QJ5207-VaEnCsYKRDqnpre1O0Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: tcp: reset 'drop_reason' to
 NOT_SPCIFIED in tcp_v{4,6}_rcv()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 11:48 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 13 May 2022 11:03:39 +0800 menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <imagedong@tencent.com>
> >
> > The 'drop_reason' that passed to kfree_skb_reason() in tcp_v4_rcv()
> > and tcp_v6_rcv() can be SKB_NOT_DROPPED_YET(0), as it is used as the
> > return value of tcp_inbound_md5_hash().
> >
> > And it can panic the kernel with NULL pointer in
> > net_dm_packet_report_size() if the reason is 0, as drop_reasons[0]
> > is NULL.
> >
> > Fixes: 1330b6ef3313 ("skb: make drop reason booleanable")
>
> This patch is in net, should this fix have been targeting net / 5.18?

Yeah, I think it should have. What do I need to do? CC someone?
