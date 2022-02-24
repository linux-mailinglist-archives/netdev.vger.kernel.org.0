Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAE74C3502
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:48:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232709AbiBXSrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiBXSrp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:47:45 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4B3E009
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 10:47:13 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id g39so5418759lfv.10
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 10:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k3BHPmwmInewlllSCPIEfhpcQ7MvRPmjUv5RmDpnlMY=;
        b=iSOGf/geXIchKSa51oWoVUsdmoRz/4i8oc/fzY4LVMBLA+DP17tf/Fsb40OQwkuOMH
         7BW+YsWx0FkJjwZbmV9TT6wsGpnX4rxeqwYTpHg9OsbT+SJRhAg3hnqUaBGMGYG/DypE
         2QvnksLVisEvNiOln5hvMZM07gXnOlVrWp6bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k3BHPmwmInewlllSCPIEfhpcQ7MvRPmjUv5RmDpnlMY=;
        b=De3euLrTe3Y22gGmwBHpDOpaF0tc718AVh8YdPC02yNbe89EuVaa3ft48Np+c7hQuf
         c2Z6ilHN00b/8uoSbKuq7wPuTLugwwOuUZdICDDE5dEIGOqkw6NUSzDZxSJazPtRlQPp
         +GUkp1M++8L0hUJfGramiD5leH/ZeNvkgiV/+btnJWd13KsYI3LVcvnlMhEojbLFNin7
         YUbSIGpPxV9KMI4VoqfZWuyoJPlxRPD1d5RAjxsEL2vmXxgXvW2u+vmgk7uJ1iFpcHz+
         RmpJ4yB87BzfLJSeQPuWp8Y8LNoQ1ucYIaz0aE83ixLZD0JuUoW+eWqcK+qwFtnmD7an
         YBTg==
X-Gm-Message-State: AOAM530CEkrqrkNaHmgDmt008/dSxdWHOl0Jv3OiWHOSFlX2fHa2XZJv
        2JCL4zw8Ru9pHw20YgJfZzthSnLW4XLTMduLouMWIGIRjTU=
X-Google-Smtp-Source: ABdhPJyII46CgTmdtSNWJTbMlw0RZTaiJcbs2r5EK66JbeJSvO0SPKDq9h3ajMWN6VEVN2rDN2Gw81v/XA1GJn+ZuiY=
X-Received: by 2002:a05:6512:312f:b0:438:8567:7b4f with SMTP id
 p15-20020a056512312f00b0043885677b4fmr2565294lfd.379.1645728432289; Thu, 24
 Feb 2022 10:47:12 -0800 (PST)
MIME-Version: 1.0
References: <20220218234536.9810-1-dmichail@fungible.com> <20220218234536.9810-7-dmichail@fungible.com>
 <20220223205510.0bd583cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220223205510.0bd583cf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 24 Feb 2022 10:47:00 -0800
Message-ID: <CAOkoqZnu0Hqr-waa77a5wB4Nt6G5KS_HR3R4x9MDFYBVGhayvw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 6/8] net/funeth: add the data path
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 23, 2022 at 8:55 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 18 Feb 2022 15:45:34 -0800 Dimitris Michailidis wrote:
> > +     if (unlikely(skb->len < FUN_TX_MIN_LEN)) {
> > +             FUN_QSTAT_INC(q, tx_len_err);
> > +             return 0;
> > +     }
>
> Is there something in the standards that says 32 byte frames are
> invalid? __skb_put_padto() is your friend.

I'll remove this altogether. FW has its own handling for this case,
which also covers small packets from the XDP path.
