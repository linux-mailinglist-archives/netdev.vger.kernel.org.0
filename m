Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CC267DAB3
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjA0AWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:22:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjA0AWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:22:46 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708AA1EFC7
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:22:21 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id mg12so9616500ejc.5
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=m9gs0dujYLDK5Km9E6B0zUz0zQnJrvjlEkzrn/38rjE=;
        b=k+StCfZrhSYGIQk1shkv2rEzQETfPAXTVQlXYvtrSHn7IDgrZ5C+gvwr2djjaxHyIB
         sp0ahWWcmN22OMeZ9rqSuCVF7uWeulh/yJed6vw/BUC1T/fN1x2Z4VsES/HJgyTdoscA
         dxXUa2uc0n+Fm1zAqzu1T01X7FlO+xZwgW0Xc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m9gs0dujYLDK5Km9E6B0zUz0zQnJrvjlEkzrn/38rjE=;
        b=j+z+ROjCvKRzo92UgJxg7nqqGqyiXGYpi6fNaoMtr8S3UvTpwJh7r8uq01ec8eqjZ+
         ArxVHLy5iij9Zwqld+OhaQdSQIhTuJYQvprpQrDHQuHf2kMvS7OoeEoMWKNoa4scu0q0
         fB18naNiSai2569nbIBrG4MU5lJKKDYEzk8rRCX/TStU7lBZn/+Alru8QmIxTl8yA8RZ
         3P3akDMXXGIMcl7nHqoj919t2pUqjnrrRMgi0NgmJxaNbysdGYP98sJnkB5dvd6IqAHk
         DDM63W9VgWVjfAnoLM71nbPP/42TrBFBos0VRav3RJMr0ufbChX/0Q00xYVtXO71Ds0e
         GlPg==
X-Gm-Message-State: AO0yUKWlOA8hi7pEoU3BK6KqONRzb4Oh2TVv77wgY5UTRCiBW6Rbff/A
        OCI8H3ovHOyvym1cDXhkq4cxnHL4wbFi3gXfT68=
X-Google-Smtp-Source: AK7set92WUxsWJSMy+Ttz4SFxK4ETX46lGOtURyy86kwjigvQQLpLbzs3bO46N7xA6Lzn+7tAOCv9w==
X-Received: by 2002:a17:907:7671:b0:878:60da:1f63 with SMTP id kk17-20020a170907767100b0087860da1f63mr4672584ejc.43.1674778937865;
        Thu, 26 Jan 2023 16:22:17 -0800 (PST)
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com. [209.85.221.53])
        by smtp.gmail.com with ESMTPSA id q6-20020a1709064cc600b0084d494b24dcsm1291503ejt.161.2023.01.26.16.22.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 16:22:17 -0800 (PST)
Received: by mail-wr1-f53.google.com with SMTP id b7so3555182wrt.3
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 16:22:17 -0800 (PST)
X-Received: by 2002:a5d:6b51:0:b0:2bf:c5cc:e1d6 with SMTP id
 x17-20020a5d6b51000000b002bfc5cce1d6mr97439wrw.659.1674778496421; Thu, 26 Jan
 2023 16:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20230124110057.1.I69cf3d56c97098287fe3a70084ee515098390b70@changeid>
 <Y9LODwJPQpPs32Ds@bombadil.infradead.org>
In-Reply-To: <Y9LODwJPQpPs32Ds@bombadil.infradead.org>
From:   Doug Anderson <dianders@chromium.org>
Date:   Thu, 26 Jan 2023 16:14:42 -0800
X-Gmail-Original-Message-ID: <CAD=FV=WEQL+Kik9ZkvtzNKN+-ofZ=-g3OzyUnnJc7PWnRzLdEw@mail.gmail.com>
Message-ID: <CAD=FV=WEQL+Kik9ZkvtzNKN+-ofZ=-g3OzyUnnJc7PWnRzLdEw@mail.gmail.com>
Subject: Re: [PATCH 1/2] wifi: ath11k: Use platform_get_irq() to get the interrupt
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Nick Kossifidis <mickflemm@gmail.com>,
        Youghandhar Chintala <quic_youghand@quicinc.com>,
        junyuu@chromium.org, Kalle Valo <kvalo@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Thu, Jan 26, 2023 at 11:01 AM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Tue, Jan 24, 2023 at 11:01:00AM -0800, Douglas Anderson wrote:
> > For the same reasons talked about in commit 9503a1fc123d ("ath9k: Use
> > platform_get_irq() to get the interrupt"), we should be using
> > platform_get_irq() in ath11k. Let's make the switch.
>
> The commit log is rather weak, it is better to re-state what the commit
> log in 9503a1fc123d states as it is stronger, and very clear.

Sure. Adding in the info that Jonas provided about what commit
specifically broke me would also be nice. I'll try to send out a new
CL with improved wording tomorrow.


> To that end. Why not write an SmPL Coccinelle grammer patch for this
> and put it on scripts/coccinelle/api ? Then hunt / convert things which
> will use DT as well and where this is actually useful / likely buggy.

That sounds like a great idea. ...but not something I'm going to do.
I'm not personally on a mission to track down everyone hitting this
particular issue. Hopefully those that were involved in commit
a1a2b7125e10 ("of/platform: Drop static setup of IRQ resource from DT
core") made some effort to hunt problems down and it seems like,
maybe, the zeal robot was part of that effort? In my case, the ath11k
bug hit me and that's what I need fixed. I tried to be a friendly
citizen and also fixup ath5k because it was super obvious that it was
the same issue and the same code.

-Doug
