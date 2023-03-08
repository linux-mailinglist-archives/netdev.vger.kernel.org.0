Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743D46B02F9
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbjCHJeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:34:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCHJeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:34:14 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F82D95BF1
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 01:34:12 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id t25-20020a1c7719000000b003eb052cc5ccso792882wmi.4
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 01:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678268051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfJ8tVzKlgE9CbCau2LvfpOtjUn9llC8iNYbOsfWj54=;
        b=LvZ9I5f6eRY9wLbkBuoQHV+4Yiw2vCm1VrGbfrz3+q3HkdeDMUJloyKHL9aJnxG1fE
         BidIbFR8XGcnmSv852nziXwdlOrQMAeow0RYs14t9Gm7SOjbrEyjLWCFBrx2WwCHMXnQ
         QMOWiBagtinaEKDEhIaiCBzAigaxt2uEdfFzqwlRAtw68P/KwdSgI5o7dNxQAU44k5e1
         r+QaXhXJ0iwz7ozBk1HaoAniD1FD6D0uij8DGWr+0io+Wr0G+X1eKY3Rf7SZy49Ka+Ic
         eK2IrASg3lxUCOP/Z6RBShzxmg+hIzF/M3tlfqCyPwFLpf/IiTgKFFKdRMDJhA7fvPuM
         VSYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678268051;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wfJ8tVzKlgE9CbCau2LvfpOtjUn9llC8iNYbOsfWj54=;
        b=lHyk5WE5SxD7CkBmef4VYeW2eiVEmanlEKYsONu/e83VmdA55RXA96W7uLuf5FoYlx
         5Db318QXACrvpbxyV6zQjeDpfl7GnwM6iC7gWL5nGMHrJq0UbjWRC8HfK7T3i1QG0ZiP
         0k5RKZ2J1N1ozIzH39NGQHqVDSefWowMketPh+0ZeuMA2t4Fqc/nFDFccZbBRwCTwBdw
         fvvsi76eXOgXL9jTeYzm/9ZmUSOteQF10u57ylDDBRfajPKh4QAsfW5l3dsWx3GXCouK
         kAOri2ofCxizKWyZjPlvSeToSesX1XSRcdpnm+lVITnZjJwc2+u9fn8cFa489JOhSe60
         sD7w==
X-Gm-Message-State: AO0yUKXaEDg97oGAYrAUfST8YD1MSmk15LKFb8ws9rBrqv5hr2q6Njgj
        Xd2esdo8iHqim22spcszUbGFVwah9SeFSJhGlE3vHc5R8YoFcf/vzoc=
X-Google-Smtp-Source: AK7set82GryJrpTa+5Tj1f2Q4fQm3TkwXuMmRqyGNAx9w47kgv5b/uASg6YANJm3Rf84X2NZyUvD4g8tDxUMCCZV8e8=
X-Received: by 2002:a05:600c:54c4:b0:3df:e471:4ef6 with SMTP id
 iw4-20020a05600c54c400b003dfe4714ef6mr3741558wmb.2.1678268050949; Wed, 08 Mar
 2023 01:34:10 -0800 (PST)
MIME-Version: 1.0
References: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
In-Reply-To: <eb5656200d7964b2d177a36b77efa3c597d6d72d.1678267343.git.leonro@nvidia.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Mar 2023 10:33:59 +0100
Message-ID: <CANn89iLjJSAA=HFFe6ZDvcZOh24JRkHsQAcftu1FV50R6+nNAw@mail.gmail.com>
Subject: Re: [PATCH net-next] neighbour: delete neigh_lookup_nodev as not used
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 8, 2023 at 10:23=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> From: Leon Romanovsky <leonro@nvidia.com>
>
> neigh_lookup_nodev isn't used in the kernel after removal
> of DECnet. So let's remove it.
>
> Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
