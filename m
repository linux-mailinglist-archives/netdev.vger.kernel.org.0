Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58AF96DA6FE
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 03:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238433AbjDGBcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 21:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbjDGBcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 21:32:47 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA2593F1;
        Thu,  6 Apr 2023 18:32:46 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id cw23so5387466ejb.12;
        Thu, 06 Apr 2023 18:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680831165; x=1683423165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlSksBDUl1ANt2MRZEOB1yOLrovtzvqjw2tq/2mITmA=;
        b=Or2OPR3TFUDnvvgnfjKVYksuN1IEks8iLB8F5pAXVs0pMpKXsTnJGmJaiyXHu8qKuK
         dFmgsxGhtCGlC5z9spDmWT5/Oyi+aLqLGzK75YTti00eavSnjscpjxJ9JCWr0zVmX0+w
         2yKF4XSby2IbN0qMtx22848Nl1rYoat9A8dWtmsdY3c8XmQ7PlUzVcAKJmrB/VnEKvXB
         HtvwoCoGf9+Agaj4/A1SJFptTBzCZNVr8wVIFrNHR1tRZNSDrtV2aJ/tWrgYfhpVl/53
         Ur7DFVFK/AQGdEZ9E5O3gQ63eDjJ5JldIphhkwy8LLXx7FXota2ZBoVf9bA1ph3NBYeQ
         vw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680831165; x=1683423165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlSksBDUl1ANt2MRZEOB1yOLrovtzvqjw2tq/2mITmA=;
        b=20scb7VaIe7TdvnzH2/YRRzlkox0arLC7sZUSpGtm2Bsb+ctwoq+UH6wZgDEgFocnl
         vurz0HCsitCrGRJxxb87ntsCFGMan9gPTewMu9GlvtoiHRB9B7lZE+dMOuFeLJZCvuPw
         IOlAxnqA68/QAZAbNv4iFeIjrEsVjsDiRhQ1tgXIPnExrBQ4qmynvnXHNv8xOkvyAyLm
         eNo15K075AhR2V4QE8vwT4FOXg1zQ+k3QMzpR39XGM2G+O7UoSt71NXRTL5IFRFwBqxH
         f565xkoBQU7zQroQSF5dFvZ0mmgOGrTsj8j3YWxQF0Q+mD06Fn2RPLCuDXYwFmqDchFW
         LiRQ==
X-Gm-Message-State: AAQBX9cJYHeo7NflVjskA8bZwDZZUPgkuCx/A/zXzulGEoCYFYVfyx2S
        MAZyfjorPcLWlP6oKYKJnKlGsz4pFOaGDCCoit8=
X-Google-Smtp-Source: AKy350b0JuuhleZvaPViTECJHwnka1OriDjzLpnK5Pn9n6ZZOSfISCkCSisHYU7RnezawXUsLLSU7v6230CICVDAE/s=
X-Received: by 2002:a17:907:86a6:b0:8ae:9f1e:a1c5 with SMTP id
 qa38-20020a17090786a600b008ae9f1ea1c5mr340012ejc.3.1680831164542; Thu, 06 Apr
 2023 18:32:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230404045029.82870-1-alexei.starovoitov@gmail.com>
 <20230404145131.GB3896@maniforge> <CAEf4BzYXpHMNDTCrBTjwvj3UU5xhS9mAKLx152NniKO27Rdbeg@mail.gmail.com>
 <CAADnVQKLe8+zJ0sMEOsh74EHhV+wkg0k7uQqbTkB3THx1CUyqw@mail.gmail.com>
 <20230404185147.17bf217a@kernel.org> <CAEf4BzY3-pXiM861OkqZ6eciBJnZS8gsBL2Le2rGiSU64GKYcg@mail.gmail.com>
 <20230405111926.7930dbcc@kernel.org> <CAADnVQLhLuB2HG4WqQk6T=oOq2dtXkwy0TjQbnxa4cVDLHq7bg@mail.gmail.com>
 <20230406084217.44fff254@kernel.org> <CAADnVQLOMa=p2m++uTH1i5odXrO5mF9Y++dJZuZyL3gC3MEm0w@mail.gmail.com>
 <20230406182351.532edf53@kernel.org>
In-Reply-To: <20230406182351.532edf53@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Apr 2023 18:32:33 -0700
Message-ID: <CAADnVQK8UH3Z8L9YckBXpPeeFTVFj0rn+widaEavfGDOEsiqmg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/8] bpf: Follow up to RCU enforcement in the verifier.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Vernet <void@manifault.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Dave Marchevsky <davemarchevsky@meta.com>,
        Tejun Heo <tj@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>,
        Yonghong Song <yhs@meta.com>, Song Liu <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 6, 2023 at 6:23=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Thu, 6 Apr 2023 18:17:57 -0700 Alexei Starovoitov wrote:
> > On Thu, Apr 6, 2023 at 8:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> > > > Yeah. If only...
> > > > I'm exclusively using -c.
> > > > -M only works with -s, but I couldn't make -s -M work either.
> > > > Do you pass the series as a number?
> > >
> > > Yes, it copy just the numerical ID into the terminal.
> > >
> > > > but then series_json=3D$(curl -s $srv/series/$1/) line
> > > > doesn't look right, since it's missing "/mbox/" ?
> > >
> > > That's loading JSON from the patchwork's REST API.
> >
> > This line still doesn't work for me.
> > curl -s https://patchwork.kernel.org/series/736654/
> > returns:
> > The page URL requested (<code>/series/736654/</code>) does not exist.
> >
> > while
> > curl -s https://patchwork.kernel.org/series/736654/mbox/
> > returns proper mbox format.
>
> Check if your git config is right:
>
> $ git config --get pw.server
> https://patchwork.kernel.org/api/1.1/
>
> that's where $srv comes from

Ahh. All works now!
I like the new output.
I'll play with it more.
Should -M be a default? Any downside?
