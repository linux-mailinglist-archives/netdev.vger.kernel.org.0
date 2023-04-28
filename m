Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40DFD6F112D
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 06:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbjD1E5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 00:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjD1E5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 00:57:40 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1808C2697
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:57:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 98e67ed59e1d1-246f856d751so6522187a91.0
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 21:57:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682657858; x=1685249858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0i18yd3kTBivQRh301ftlZyRSAuiuj0ykqMJXN0ZNo=;
        b=ED6p1QMUq/vRQaDpNQ0hjfRWgeVNTsqiw/sqL0ZJNKt+5ylRfjEtLpFvE9zQSKs4wS
         aCrtEz+Zno2KcmqvMpx4SOI8hWCgSZtWmcIhMn3fvLOd+b09sLXD80ig4My6K2MGxIu+
         i7YgxumlwvCJHpGL9HQCjRW2wD7M8mpYYlR2ezrCHka7KKVHdo1M2rByd26dwxc8o5uU
         +zo2HfHct5O+r31WUmb+qqIQevTDa8uqJw83MuoF3gKU1uvfgiN3Xlm3gaqQ5oWSQu4Y
         t6r0bry9ILYCFCOJLTfzURuQGxAv0HF8qP3n36V/46dclu0188vPzrj5reRyFG14j1Kq
         rTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682657858; x=1685249858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0i18yd3kTBivQRh301ftlZyRSAuiuj0ykqMJXN0ZNo=;
        b=a8WTqGLOqC1JsZ4Ess4DUDraGZr4g/sqQ+w1xPkz3RHa6DUyHq/nue4QZ5r9KUypG5
         KmQZhOWi0mZMqa+uvEiRTqrq/o7uczH3aXx4hs+VI0IauG9w8Oi9YqY/Ia4GUkq85fUk
         XPvcishxczWA7VRq6VeVfZs2jgFPwW925AS/XOawYq9OcUOxVdU5k9xl4eA6Hx0I9EHe
         M9493CqHT+ctzVWEZBY+piOSTnolgXwLFsK7iBi3qUiJEDQcjtPPPPMyzpSOD+9xmzuv
         4TExIB1KTr8/CpoTsqf+eK4DQWEQbpO5Q/+h552k696NlF4eofgOKpljpP08JO2Od9jG
         W+Eg==
X-Gm-Message-State: AC+VfDzfb2RU7W2tZIRp3B+2jH2RLUfYebxdKoPsGjZK9WU/hDCvB/yP
        QfvZ+zbloMho4LALxr/Phv6eeobeNqzl4Tsynls=
X-Google-Smtp-Source: ACHHUZ5Ey9HptVl+4tKsdZeJrSSF6ePVcgcEjEcn0pp9NuA6YhrBXAYuRT0puGXB+LGfaYIGWThtD8vh0hKAxUxIe/I=
X-Received: by 2002:a17:90a:7564:b0:233:c301:32b3 with SMTP id
 q91-20020a17090a756400b00233c30132b3mr4318240pjk.3.1682657858396; Thu, 27 Apr
 2023 21:57:38 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032437.285014-1-glipus@gmail.com> <20230426165835.443259-1-kory.maincent@bootlin.com>
 <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com> <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
In-Reply-To: <20230427102945.09cf0d7f@kmaincent-XPS-13-7390>
From:   Max Georgiev <glipus@gmail.com>
Date:   Thu, 27 Apr 2023 22:57:27 -0600
Message-ID: <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, I'm still learning the kernel patch communication rules.
Thank you for guiding me here.

On Thu, Apr 27, 2023 at 2:43=E2=80=AFAM K=C3=B6ry Maincent <kory.maincent@b=
ootlin.com> wrote:
>
> On Wed, 26 Apr 2023 22:00:43 -0600
> Max Georgiev <glipus@gmail.com> wrote:
>
> >
> > Thank you for giving it a try!
> > I'll drop the RFC tag starting from the next iteration.
>
> Sorry I didn't know the net-next submission rules. In fact keep the RFC t=
ag
> until net-next open again.
> http://vger.kernel.org/~davem/net-next.html
>
> Your patch series don't appear in the cover letter thread:
> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
> I don't know if it comes from your e-mail or just some issue from lore bu=
t could
> you check it?

Could you please elaborate what's missing in the cover letter?
Should the cover letter contain the latest version of the patch
stack (v4, then v5, etc.) and some description of the differences
between the patch versions?
Let me look up some written guidance on this.

>
> Please add "net:" prefix to your patches commit title when changing the n=
et
> core, "macvlan:" prefix for macvlan driver change, etc ...

Will certainly add tem.

>
> Also I see you forgot "net-next" to the subject prefix in this iteration =
please
> don't in next one.

My bad, will add it back.

>
> Thanks for your work!
