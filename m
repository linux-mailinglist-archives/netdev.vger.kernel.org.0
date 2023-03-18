Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C016BF7A3
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 05:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCREBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 00:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCREBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 00:01:21 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF5215562;
        Fri, 17 Mar 2023 21:01:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id r11so27547004edd.5;
        Fri, 17 Mar 2023 21:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679112078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KeirjmG1sUwb49XvI4KP2IfB1JszbFMtQB2QE1hULE=;
        b=K2LJwfVyLehg6Mxx5HmKkknM0wgBzm3HFpJmn9UnF7PmpHespD8zY4ZhvLlwb0gFCY
         GDgCAM7CtImTGsUZBW3SYUTa2+AKQ7tzW2t4NP7zfFXqz+ZFq7E5Zn1UiLeg6tVI7We8
         fu2zI7i36ECjZ0+DO7MFa8VkDeXv1iBKlpCUF8bZ1v6SlzkdRRJoyiKcqhlfjte4kHrD
         zutJ5WAHBcPsONyjYVZDLRM4JDdQm2U6ETFVXRKu2R78dfvTUv56Dl6jJBUqHhZLLBeV
         vP19mrj+JECI1EaqpDYg1C5WaPKeE0M8kaGnXN1YdMWfj+ECHirxRBmvE0p8iizI304z
         vB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679112078;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+KeirjmG1sUwb49XvI4KP2IfB1JszbFMtQB2QE1hULE=;
        b=7/mYK3pM3gPInjk547oSvtACaKJOFuLJ71402s/3R6Ri9lO1Q3r1KKfpAwmailjlK9
         jUfbDMzqYPCabUJb/d8kUO+3tutKrLHuuTNO9SdihDSEJr38uJzaUJRdUE84LuH8CiaB
         p9wzJ+Y2Ja/s1IsztMe2MaxY6Tnf07iL0N+/LkW3Z94IWmSITHiyfcCOyiihjlm2R+5O
         xlRHj3ZWxg9K0yVM/9cfd2ze4NsGhXAFtru5xMuniXKLvThYhK11PKF0pgKvq8kFaspl
         CeT3WDMzNaBCZbXdGjMQWROlHjKxn2CW7AJh3ueop45PBguQS2wWjL2EHtoPdxGUr9AU
         RfEQ==
X-Gm-Message-State: AO0yUKUJN3AsJHxjFkxVgzmu8RPUhPUoqFJqA+u+0mFRYWrkycD+n99g
        ZzAMZAmdRV8yZASnLq2r7t8UEN10TL1dXXo5zQ8=
X-Google-Smtp-Source: AK7set8mLxndGSyIA2l8GY+iQ440UzjOGl06ijgNMk4wHC2/p7HvHLzeL2Fax0raAxzlhyofFewh/po4i6ZIaW9ll7E=
X-Received: by 2002:a17:906:9bf2:b0:8db:b5c1:7203 with SMTP id
 de50-20020a1709069bf200b008dbb5c17203mr768974ejc.11.1679112078556; Fri, 17
 Mar 2023 21:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
 <20230315092041.35482-3-kerneljasonxing@gmail.com> <20230316172020.5af40fe8@kernel.org>
 <CAL+tcoDNvMUenwNEH2QByEY7cS1qycTSw1TLFSnNKt4Q0dCJUw@mail.gmail.com>
 <20230316202648.1f8c2f80@kernel.org> <CAL+tcoD+BoXsEBS5T_kvuUzDTuF3N7kO1eLqwNP3Wy6hps+BBA@mail.gmail.com>
 <20230316213004.6a59f452@kernel.org>
In-Reply-To: <20230316213004.6a59f452@kernel.org>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Sat, 18 Mar 2023 12:00:42 +0800
Message-ID: <CAL+tcoCE=LRO=gpbWSoqzuR26Qpp1s89e3t1TvCUOoJBz_UKyA@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us
 tune rx behavior
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:30=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Fri, 17 Mar 2023 12:11:46 +0800 Jason Xing wrote:
> > I understand. One more thing I would like to know is about the state
> > of 1/2 patch.
>
> That one seems fine, we already collect the information so we can
> expose it.

Thanks, I got it.
