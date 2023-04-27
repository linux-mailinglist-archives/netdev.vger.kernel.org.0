Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9FF6F0495
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 12:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243448AbjD0KzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 06:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243283AbjD0KzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 06:55:07 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5D71733;
        Thu, 27 Apr 2023 03:55:06 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3ef33a83ff1so38120351cf.1;
        Thu, 27 Apr 2023 03:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682592905; x=1685184905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q4yxf1kUwqhXPiNIN9b61myjf5LzeWeVStu3Emj9sUI=;
        b=o3+whjcITy9OD87HXnrfl5jdkVdRuMlIEPiCw2Fz7sT3DkKO+0WuStrjAMGaTqZnKS
         0vKQ2NmqLPImPvOYxYepAY2qLdsqrgPFMrx3cMZXsxTLWybCRYynnl9oLGCCl0pXnrkz
         exM8eXA9J6WcsUUGOFMn9qjNDXzPkV1HNP/ppwEELH626gMtuzC8K5/wj0EjRzwA+F4m
         wAVKV+pp80Bpx+eYTxhbB0HLuLRc4ltLxtYFw+971lefKCJ5mNQA1KGO4EMu/Xqux1LM
         noyRZzlfntKFCwpKkWjlThOyDZqP1zCVJIdPI+k5CCxms6m20BwHg3sYPkwHjYjrr3XP
         0EOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682592905; x=1685184905;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q4yxf1kUwqhXPiNIN9b61myjf5LzeWeVStu3Emj9sUI=;
        b=ay2HemcLGZiYRrH4lkfEZUh8DaEFCG3nKN2D+Km9uwPHtRnyVca7hL05//Dc6yUIGo
         AlMKv4u12grKZpNDP4SZufrP6JfUqOy2rQQnW9PabNMWDo+AFqZhoN8HhzUZiebzB/WO
         YciRJY+4LQgJbk/MTI/YYiV+2LJ5IXtq/JuTp2lJKvQ3qhUpnI9Ixlt88pjOgiWCq0rh
         EeP8w1XQuQVsMXIbw1BPZcg+pCLyA/jMFdenjLVEWSgLQ4tTfnFIPhEnSB5ByHyW/SVc
         MekTwyUUA5FVYeFln9n9jWygLeGlFy7/ASEbn7WM27liASjU0rGhTn4lg7Nlj+Xw1uP5
         ckPw==
X-Gm-Message-State: AC+VfDyVoTv27XxpcNWA4M6LDcVqAIMQoneDvDg8CQuaZOE+VdzlTa1M
        BlQMj8KG6XUVDroGjnBwzbBP+YrKS4zzPeyS4bo=
X-Google-Smtp-Source: ACHHUZ61OHQpcgVMkmE6fFvU0vNwyM94psPjya2fSxnz75hpgVx/bTds3f02yRr3P1D/N1fOuLh6oXHHZg4N+N9utSo=
X-Received: by 2002:ac8:7f8e:0:b0:3d8:2352:a661 with SMTP id
 z14-20020ac87f8e000000b003d82352a661mr1543069qtj.3.1682592905720; Thu, 27 Apr
 2023 03:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <1682327030-25535-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682327030-25535-3-git-send-email-quic_rohiagar@quicinc.com>
 <ZEk9lySMZcrRZYwX@surfacebook> <66158251-6934-a07f-4b82-4deaa76fa482@quicinc.com>
 <CAHp75VcCAOD3utLjjXeQ97nGcUTm7pic5F52+e7cJDxpDXwttA@mail.gmail.com> <1ed28be7-7bb5-acc5-c955-f4cf238ffc49@quicinc.com>
In-Reply-To: <1ed28be7-7bb5-acc5-c955-f4cf238ffc49@quicinc.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 27 Apr 2023 13:54:29 +0300
Message-ID: <CAHp75VcDBFyG9+RaOUma4y+Q0em2-Nvuk_71vDkenGk+2HJqEQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] pinctrl: qcom: Add SDX75 pincontrol driver
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-gpio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
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

On Thu, Apr 27, 2023 at 11:53=E2=80=AFAM Rohit Agarwal
<quic_rohiagar@quicinc.com> wrote:
> On 4/26/2023 10:12 PM, Andy Shevchenko wrote:
> > On Wed, Apr 26, 2023 at 6:18=E2=80=AFPM Rohit Agarwal <quic_rohiagar@qu=
icinc.com> wrote:
> >> On 4/26/2023 8:34 PM, andy.shevchenko@gmail.com wrote:

...

> >> Ok, Will update this. Shall I also update "PINGROUP" to "PINCTRL_PINGR=
OUP"?
> > Yes, please.
> PINCTRL_PINGROUP cannot be used as it is, since msm_pigroup has multiple
> other fields that needs to be set
> for each pingroup defined.
> Would rename this to SDX75_PINGROUP, as seen on some other platforms.
> Would that be ok?

For this patch, yes. But can you create a separate followup that
replaces three members of struct msm_pingroup by embedding struct
pingroup into it? There are examples of such changes in the kernel
already. https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/com=
mit/drivers/pinctrl?id=3D39b707fa7aba7cbfd7d53be50b6098e620f7a6d4


--=20
With Best Regards,
Andy Shevchenko
