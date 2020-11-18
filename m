Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A30582B86FA
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 22:44:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgKRVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 16:44:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726666AbgKRVoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 16:44:13 -0500
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23902C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 13:44:13 -0800 (PST)
Received: by mail-vs1-xe42.google.com with SMTP id r5so1879950vsp.7
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 13:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IhymcEpsiTxiXYLErxcWwtaKpQG1QSZdLECVabDRNpY=;
        b=P4MXbOh6XQiVfY7aX1XL7PxDisnl0PLAwv8TAeSoWASqiywPSnVZVNm/vBX/LpVEy/
         hfkXt/WvejmTudo0khBNDSa7oUkDsSBp8jAbx7neRLLN1hAc1Lfk8UdczS+7sfJ8VlXq
         c92643psUuYUTyDJilNbN/xGhtj3Nc/uRROo2Lt37Qnm9N08C523NuA9r39tqlwBEBqU
         CuNHsfeJR4B5FgJWTyvjDEWaDixBxWZyy0w8AY+M2YylpxM3AyNx9B4YELfBbxsU01hT
         6W7DMlqwMQ73yLDqPfXdy2xhdMznOmegqZvxvJWOEOHYWXPk7ovZDHoPJLiDOvN5D+Vh
         P54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IhymcEpsiTxiXYLErxcWwtaKpQG1QSZdLECVabDRNpY=;
        b=nag2vBiKEpphkFxZvCgyzy8CAXS/OJs0jc01bR7nOCP2N1AYZBmHBgt/znLtVH5+1N
         iQTaVf5TYJaaLM64YCTWrrdem9adnTFQzLzBxTGmVRHheIH7mamV5eneFCDLq6vJR58X
         5FCBfSgKjobZjoBRAbaaY4jAKw7O8Us3ykKYKOQnSTzs5CYLCxLCMwwwxAkDygPJuS+3
         Gbhw2obwHSU1FifqB/2T1iO187G45CzEpWPku91vIVUCdZaQRPtbeSYWDjgfpeOFA31R
         Fj3p8zylO2jK7uhqQqJkNQSUtE89U6t8CK2g7IKNNSel4hPL/gsxuwvC5uBBRr6bMh7c
         bb1Q==
X-Gm-Message-State: AOAM530dIITgeGnByxwOv/rKoh/gPDeSpFVqdYi+4bKZY/1zig0wNcjd
        vgnih9QZKfRl24jOgnxtsTmIPIYP6bk=
X-Google-Smtp-Source: ABdhPJxs5pMgeyx+tc186hzdgkVEcAC4BbWqIVCmF+PUaGA0FXhjEDqQOZAGz5qaE5TdBbc4AgPUkA==
X-Received: by 2002:a67:ee16:: with SMTP id f22mr5368375vsp.8.1605735851963;
        Wed, 18 Nov 2020 13:44:11 -0800 (PST)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id v26sm2725680vsq.20.2020.11.18.13.44.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 13:44:11 -0800 (PST)
Received: by mail-vs1-f42.google.com with SMTP id r5so1879898vsp.7
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 13:44:11 -0800 (PST)
X-Received: by 2002:a67:ed4b:: with SMTP id m11mr5433751vsp.14.1605735850633;
 Wed, 18 Nov 2020 13:44:10 -0800 (PST)
MIME-Version: 1.0
References: <20201113231655.139948-1-acardace@redhat.com> <20201113231655.139948-4-acardace@redhat.com>
 <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201117113236.yqgv3q5csgq3vwqr@yoda.fritz.box> <20201117091536.5e09ac13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117091536.5e09ac13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 18 Nov 2020 16:43:33 -0500
X-Gmail-Original-Message-ID: <CA+FuTSevYage147cqyogSfvZN5gtqKngP3RNQe0UoawgtQQ-xA@mail.gmail.com>
Message-ID: <CA+FuTSevYage147cqyogSfvZN5gtqKngP3RNQe0UoawgtQQ-xA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] selftests: add ring and coalesce selftests
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Antonio Cardace <acardace@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 17 Nov 2020 12:32:36 +0100 Antonio Cardace wrote:
> > On Mon, Nov 16, 2020 at 04:45:03PM -0800, Jakub Kicinski wrote:
> > > On Sat, 14 Nov 2020 00:16:55 +0100 Antonio Cardace wrote:
> > > > Add scripts to test ring and coalesce settings
> > > > of netdevsim.
> > > >
> > > > Signed-off-by: Antonio Cardace <acardace@redhat.com>
> > >
> > > > @@ -0,0 +1,68 @@
> > > > +#!/bin/bash
> > > > +# SPDX-License-Identifier: GPL-2.0-only
> > > > +
> > > > +source ethtool-common.sh
> > > > +
> > > > +function get_value {
> > > > +    local key=$1
> > > > +
> > > > +    echo $(ethtool -c $NSIM_NETDEV | \
> > > > +        awk -F':' -v pattern="$key:" '$0 ~ pattern {gsub(/[ \t]/, "", $2); print $2}')
> > > > +}
> > > > +
> > > > +if ! ethtool -h | grep -q coalesce; then
> > > > +    echo "SKIP: No --coalesce support in ethtool"
> > > > +    exit 4
> > >
> > > I think the skip exit code for selftests is 2
> > In the ethtool-pause.sh selftest the exit code is 4 (I copied it from
> > there), should I change that too?
>
> Sorry I misremembered it's 4. We can leave that as is.

Instead of having to remember, maybe we should have a file in
tools/testing/selftest to define constants?

I defined them one-off in tools/testing/selftests/net/udpgso_bench.sh

readonly KSFT_PASS=0
readonly KSFT_FAIL=1
readonly KSFT_SKIP=4

along with some other kselftest shell support infra. But having each
test figure this out independently is duplicative and error prone.
