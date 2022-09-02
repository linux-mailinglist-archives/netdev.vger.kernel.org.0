Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE3A5AA57F
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 04:14:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbiIBCNS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 22:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbiIBCNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 22:13:17 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5054FA61D1;
        Thu,  1 Sep 2022 19:13:16 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso4214798pjk.0;
        Thu, 01 Sep 2022 19:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=qYL6s/9Aeo2GE4x5J9H3W9gBgDC4mxOsIuVqqCG9Ifc=;
        b=iqbWpX6axi4zrwgEuCpxATOxKDKiXl4xk/YOtHomHlekDTmI5RA20Ik/HAEy0TErsi
         A+YZ4xF7UJTdndCxJVAoaxN7KYsqkX72U5cblFlCHPgq7AhXYIoj5S5xtMB98cASGFut
         wy2qtnXtUPAJtKjTeis4faqZndPM5U4HO2RrQRkCoVHn4T+Rbu+qgP+UJCq9weIOQITp
         2719TcyYSDD8LKCRgZOtFS7XwVyyo0ClvQmDLidDL0fSJ8XSq/ilz9s6jByun8O1BRbs
         wkYHC2pe03xJbrSVqqCtjj5QpwNkHQBwIwkmdhUOPA8/l+BufJImgCyDI5lL2Au4AiVH
         iXmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=qYL6s/9Aeo2GE4x5J9H3W9gBgDC4mxOsIuVqqCG9Ifc=;
        b=pZkUTH455QhwA064327LI7oNDo3Qzth7Ogd6wXLJvte/ikiIv6rFS8gc9XskxRyep8
         8iCdF6bEYpTI1AMdT/ZpsFMTcHf7mr6CRd7bapRMV4UKE5jQSl6gF2W57Zdjwbilit8a
         brJYS7Q1dl8teGJ0GgLlzYFS8qcw/Lu6KTS8bBoL0PPFkYPyhSihJBJCz/H0sR9tYMOx
         GuLZTNTyZS9PPEleASAWwo7OC/T1ohrMj18yuaDtVbcruyoErFqux/47gdx1TbnZfAW+
         fgh/KUMa1R0AVYGOrUwwshhAZ9yIjdUAjMIWkDglIOWElYangNsGKPDM21QSNUZfRX2r
         5nTw==
X-Gm-Message-State: ACgBeo1yL5K3T86CNxq6JSdaT5liL9lSaKdUin8YDJObl02p/kdg4V6U
        afeb10SenQB6w/Pn2WHXLagrHQRPInS8vtx5AJw=
X-Google-Smtp-Source: AA6agR4SvYXFJR86zhxiAvZ2E9aA1jtrSB2etUHJ+zppF5LlPRxN9Ydu32iiiw2ecXmihjJAuJDuRm4aOuVeiGVoW2g=
X-Received: by 2002:a17:902:d4c4:b0:173:1206:cee7 with SMTP id
 o4-20020a170902d4c400b001731206cee7mr32821374plg.142.1662084795764; Thu, 01
 Sep 2022 19:13:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220901152339.471045-1-imagedong@tencent.com> <20220901141257.07131439@kernel.org>
In-Reply-To: <20220901141257.07131439@kernel.org>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Fri, 2 Sep 2022 10:13:04 +0800
Message-ID: <CADxym3bjafYdX0X8B+KFbKrgH0Cm5Th9F6V8SEi+KZJa95keaw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: skb: export skb drop reaons to user by TRACE_DEFINE_ENUM
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, davem@davemloft.net, pabeni@redhat.com,
        rostedt@goodmis.org, mingo@redhat.com, imagedong@tencent.com,
        dsahern@kernel.org, flyingpeng@tencent.com,
        dongli.zhang@oracle.com, robh@kernel.org, asml.silence@gmail.com,
        luiz.von.dentz@intel.com, vasily.averin@linux.dev,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Fri, Sep 2, 2022 at 5:12 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu,  1 Sep 2022 23:23:39 +0800 menglong8.dong@gmail.com wrote:
> > +#undef FN
> > +#define FN(reason) [SKB_DROP_REASON_##reason] = #reason,
> > +const char * const drop_reasons[] = {
> > +     DEFINE_DROP_REASON(FN, FN)
> > +};
>
> The undef looks a little backwards, no? We don't want to pollute all
> users of skbuff.h with a FN define.
>
> #define FN....
> /* use it */
> #undef FN

Okay, Thanks! I'll wait a moment to see if there are other comments
before sending the next version.

Menglong Dong
