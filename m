Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404166C1F23
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbjCTSKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbjCTSJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:09:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1EBE2B9C9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:44 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id d8so7132829pgm.3
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679335421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6+STFR+TohCdh1P67NsV5FZs6BfnbYejGuGRFxyQ8Y=;
        b=KjtFuFfJ41ytdqFlb5mRkH19/P1qbSSuXs/OXjGCpHdHpb+zmUXH+85gRxWZdTMySC
         pno8uDmPXJd1/KF4TCgp9Ld05ZU4GRAXCBOxLvPf0V2ouK/E2IftRrDSnb3qoeEAlacO
         eH93NgNtFIsNnqmaaxVlk+nI1HfXY28sC3ABb/2c1xk7FR11XACpVmW/TaDTUf4dEvm8
         45/sI0pmJaMDfWwm9N2lNtoi+d8Axa2BlygBZGMFLntetyulk9SH9owu8W4bLbJxjW0e
         brpFDqUrGxXZ32359zqy/A/D3Osb+IQuhEk16/JzFv7ZUQOHBtv1U6KwCG5JO1LmjA2A
         AuVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6+STFR+TohCdh1P67NsV5FZs6BfnbYejGuGRFxyQ8Y=;
        b=QTe9C4BDGX2IgTukQmH2tOgcheMjTwz6VG4wHh0cwdLulDXIV+ua+EmVamIZGkH35x
         AzTmfl1PIVAFE0yJPcNIbdQyHfYH38RumYPYCUNBXggN3u9YYlwbGLQQztFuXuF/Qu4u
         zXNiS9ONxHOoWYjYEGmb9mMns5bORV1s7HPpzWO6KGVQ8xX1WNCP/WNeijfye5db6wrs
         9/NQjgQzeF7lk0SLXiIG4GOeFdtMSOMRUXIOqDL9ITsyqQFlsCRXRz6Md71wADjMb6Jg
         wit5s/D8t1ahy5Ex2+7T0xYaqHqe/Z8VrZMNdy5lPwZQuJp5P9DQyri1wvY0SyiFeT/X
         FO5A==
X-Gm-Message-State: AO0yUKXSm8DTEapNFZtaSCG4XZlgyDS2SiQcgvTXro9fgls5mXdzy7Jw
        eFKNAsjvvNrbpoMhnrBSaIHjgMatG2V1y8nsLojowg==
X-Google-Smtp-Source: AK7set+5vFiunTuYDTT/GoX3/kB85P20nDcXhmIDZkeswyOGqnz0qksbnL1nMzpOrQ/SUs46kgk2D912wD2bi3pGdwo=
X-Received: by 2002:a65:448a:0:b0:4fc:d6df:85a0 with SMTP id
 l10-20020a65448a000000b004fcd6df85a0mr2177918pgq.1.1679335421055; Mon, 20 Mar
 2023 11:03:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com> <20230318002340.1306356-5-sdf@google.com>
 <20230317212354.0390ced0@kernel.org>
In-Reply-To: <20230317212354.0390ced0@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 20 Mar 2023 11:03:29 -0700
Message-ID: <CAKH8qBtrMtwGexJ2Zd7YX1K3CScVStbXHSyq-hF2w2Zet3e=Lw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] ynl: ethtool testing tool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
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

On Fri, Mar 17, 2023 at 9:23=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 17 Mar 2023 17:23:40 -0700 Stanislav Fomichev wrote:
> > diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
> > index 6c1a59cef957..2562e2cd4768 100644
> > --- a/tools/net/ynl/lib/ynl.py
> > +++ b/tools/net/ynl/lib/ynl.py
> > @@ -477,6 +477,19 @@ genl_family_name_to_id =3D None
> >
> >                  self.handle_ntf(nl_msg, gm)
> >
> > +    def operation_do_attributes(self, name):
> > +      """
> > +      For a given operation name, find and return a supported
> > +      set of attributes (as a dict).
> > +      """
> > +      op =3D self.find_operation(name)
> > +      if not op:
> > +        return None
> > +
> > +      attrs =3D op['do']['request']['attributes'].copy()
> > +      attrs.remove('header') # not user-provided
>
> 'header' is ethtool specific tho, right?

Good point, will move to the binary. (but as I mentioned in the cover
letter, not sure we need to really put that into the repo, up to you).

> > +      return attrs
