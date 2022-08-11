Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BAE2590805
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 23:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbiHKVZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 17:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230239AbiHKVZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 17:25:51 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBC396766
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 14:25:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id s11so24459664edd.13
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 14:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=Av61MCjlR3mg8Dx2VvdjMo2UWGRPhMNNNMUbh2HIJOc=;
        b=XPy1b7gHNWhW4bPEJfCMKoDTBorrVE5knZYc0pr2Yt2Prz11wJwKGcC5w3T84v8cNx
         ENLBomSnMYVcdYS4Ru0Tv9sMoRNf4sdGGsYnRTuxk54JX8QdudMtFJ4/f4Kme0XbGqaC
         bEvdPalHXbbi+ruOg/Nm3c1K59DoTznTR6sjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=Av61MCjlR3mg8Dx2VvdjMo2UWGRPhMNNNMUbh2HIJOc=;
        b=Ch5yzJsZPgvw2YlioiYABFPEk9y8AMntpdjL/r8ZlMDbLAPVE/Ssxa6virZSENhUio
         ikMArtvfbTYBQ93vujoGDmej6/2oA2ytxBTWWFhC20+8jkyKAGZPJGq8ykT3dZl408aG
         bDAWOLhnwTyW8sFTybVcpMF2tggzSellKqBaUDF4MPUGTkf8kgttP8uqlBN31aiS1Ptl
         M/FCvnXL368Kg5i335LiU28toKk2/QeGmcDEirbpFGJmOeGA2hEsdDG7W7J758KcBYgD
         /e8ldTk/gqrfdXZ2X0WXtXaqJkUqGb6AmGI3K3Ltu7jcosIUYmqbsep8gp8/vlXbJ8OB
         /M/A==
X-Gm-Message-State: ACgBeo3H4/tcyX9NRYG7LrmVZ64kuFFwWbNrBnEG0Q6xHW9xEIh9nn1d
        pv3tC8RudCnTp8YgyZwxtqdhuDsNnYCBOWBr
X-Google-Smtp-Source: AA6agR79TZcgmVmsBQT+JdghupzX53jIyk0hYvQqJO911G0U1EcGLsx6ys4KIDVaKKekdedeeAK+TQ==
X-Received: by 2002:aa7:de85:0:b0:43a:d89f:1c7b with SMTP id j5-20020aa7de85000000b0043ad89f1c7bmr917091edv.17.1660253148807;
        Thu, 11 Aug 2022 14:25:48 -0700 (PDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com. [209.85.221.45])
        by smtp.gmail.com with ESMTPSA id v17-20020aa7d811000000b0043d7ff1e3bcsm285528edq.72.2022.08.11.14.25.47
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 14:25:47 -0700 (PDT)
Received: by mail-wr1-f45.google.com with SMTP id z17so22663300wrq.4
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 14:25:47 -0700 (PDT)
X-Received: by 2002:a5d:6248:0:b0:222:cd3b:94c8 with SMTP id
 m8-20020a5d6248000000b00222cd3b94c8mr414789wrv.97.1660253146870; Thu, 11 Aug
 2022 14:25:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220811185102.3253045-1-kuba@kernel.org> <20220811120902.7e82826a@kernel.org>
 <20220811124106.703917f8@kernel.org>
In-Reply-To: <20220811124106.703917f8@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 11 Aug 2022 14:25:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi0JE7EkqQajmhdvarwQBHYVOaSS5xqvtYpCrWmsZ6rkA@mail.gmail.com>
Message-ID: <CAHk-=wi0JE7EkqQajmhdvarwQBHYVOaSS5xqvtYpCrWmsZ6rkA@mail.gmail.com>
Subject: Re: [PULL] Networking for 6.0-rc1
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 12:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 12:09:02 -0700 Jakub Kicinski wrote:
> > Let's put this one on hold, sorry. We got a report 2 minutes after
> > sending that one of the BT patches broke mips and csky builds :S
> > I'll try to get hold of Luiz and fix that up quickly.
>
> Can I take that back? I can't repro with the cross compiler
> from kernel.org. I'll follow up with the reported separately.

I've merged this, and don't see any new build issues, so please do
report separately.

               Linus
