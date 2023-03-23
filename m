Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3746C5D75
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCWDtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCWDtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:49:19 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08E804C19;
        Wed, 22 Mar 2023 20:49:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso2675877pjf.0;
        Wed, 22 Mar 2023 20:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679543358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4P4sczMlLsp+gPtr1QGMWUNlSRoo/6Ef28EDu7xXAA0=;
        b=kB5Q2KP+JhIhSoBKI/gKVN0twUZxQi3zIMtd0hNrQ+TYwqKWRenB+L3ReUTsw+t8H1
         ZsrgYUAMYJRARxiVgibDu0jO8w6WqDhXKhKU9dO5FTDgQTewWCRc4zEDbfX7aMz8iTbH
         gYB93LE4E5kL43+PULmSgX/AH480HljXBN42/OsJ6l8iE9FTd3t/wcY7XtgSxIApqi0d
         E6ju+bbLJSwuXmnUmQJdQNnZoXwdRhFhZSlBr5vL+h/eC73Uupf8bLGT1ozwUfnWJAmp
         x0Yq85IiNgteCKw6sEa27xB+A9TYBxYYWEzXWs7zydJW1Rd4kMB4XdRq6Yfsq06M32fA
         GM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679543358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4P4sczMlLsp+gPtr1QGMWUNlSRoo/6Ef28EDu7xXAA0=;
        b=q+NUMQ9z2xWtlm6PU7leaBWlTePXguNKSI+wHXPBiKImQOWMsPC1b6OPFQZuFTjytf
         oszK+g578BtomTfFy2xe/pPRoAvZyB8tGhTT2ZtNs+ZBzxvHykkEqD5adrw/j0aLU2N5
         hWpDYKVZ1xpIDcclIyvmSnBFGxjqjRzMzXK3/mmo9rDq7nkj9orhsiO+8pS8LX1lW0Nq
         eSWSAvuEAoIaTgPRSyapK+s830b9Rd1n7pn/3muqIONs4yc/uiONTG9//ugwiBEJikcV
         jgRnWDscnpXRPnYDCZE8s4QS/BFJa6jAlT14JHdT0Y6apJg7nOHkZsvRYzBvppPXmEXe
         n8iA==
X-Gm-Message-State: AO0yUKU7bc0DInKgqtewW//2RAFo9PvdTpHAuaXC3qiUOHLbhmUxTxpj
        KmUJnn/wC7pvSdBTZZFJzxde6szezNBIydRbDoQP2JHeAhfyoW0B
X-Google-Smtp-Source: AK7set+nUZK1ltyrntedDdxlg/5GivXZkm46GNdcHtL09KKvRKeEduVqqfDfNiGUyMWNgkyTMWj7kPN6dO/zTUTGXtM=
X-Received: by 2002:a17:90a:348a:b0:23f:a26e:daa3 with SMTP id
 p10-20020a17090a348a00b0023fa26edaa3mr1775460pjb.9.1679543358398; Wed, 22 Mar
 2023 20:49:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230318080526.785457-1-zyytlz.wz@163.com> <167930401750.16850.14731742864962914143.git-patchwork-notify@kernel.org>
 <20230320122259.6f6ddc81@kernel.org>
In-Reply-To: <20230320122259.6f6ddc81@kernel.org>
From:   Zheng Hacker <hackerzheng666@gmail.com>
Date:   Thu, 23 Mar 2023 11:49:06 +0800
Message-ID: <CAJedcCzT0wt=QrrA0XVihyEvpK4eUo+_Aen6OqPE6gJidjNpGg@mail.gmail.com>
Subject: Re: [PATCH net v2] net: qcom/emac: Fix use after free bug in
 emac_remove due to race condition
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     patchwork-bot+netdevbpf@kernel.org, Zheng Wang <zyytlz.wz@163.com>,
        timur@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, 1395428693sheep@gmail.com,
        alex000young@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> =E4=BA=8E2023=E5=B9=B43=E6=9C=8821=E6=97=
=A5=E5=91=A8=E4=BA=8C 03:23=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, 20 Mar 2023 09:20:17 +0000 patchwork-bot+netdevbpf@kernel.org
> wrote:
> > Here is the summary with links:
> >   - [net,v2] net: qcom/emac: Fix use after free bug in emac_remove due =
to race condition
> >     https://git.kernel.org/netdev/net/c/6b6bc5b8bd2d
>
> Don't think this is correct FWIW, randomly shutting things down without
> holding any locks and before unregister_netdev() is called has got to
> be racy. Oh, eh.

Dear Jakubju,

Sorry for my late reply. I had a busy week.

I have taken a look at similar fixes implemented in other drivers, but
I do think your advice is more precious for I'm not familiar with the
driver.

Based on your experience and expertise, what do you think would be the
most effective solution to address the race condition issue that you
have identified in the emac_remove function of the qcom/emac driver? I
appreciate any insights or suggestions that you might have on this
matter.

Thank you for your time and help.

Best regards,
Zheng Wang
