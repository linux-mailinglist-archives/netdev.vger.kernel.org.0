Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08C1A51834F
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234711AbiECLhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiECLhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:37:18 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC191F63A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:33:46 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-2ef5380669cso176123817b3.9
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 04:33:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cU55pjdD4r0nBMyteMyWhE7PaNwLmw8ghUxQGJMW0Fs=;
        b=ZWxqr8xxsr8+/+K1DcT4BWQ5jqfOAHlWmQByHsbtcZabCcfRhGctujKbnPFDtrCHad
         QOlERcQotITw6/RVh7y7IMg29xHOPcynYydEMSTDLfGIqEr8mXMBBRA+qClBWMmv3krm
         u5EuqrTb+yuYlGXtNDLRt/puv1v5guScm7Ih8aTw0RfjWFto9UenpNW+cANTCFXQJv55
         egk1Jxm0k09pBtAS4h0u2t+Dw2FZlGGZmSjvRlLhWj0b+E+u6T1SMD1XGMeC0jlBrUWX
         uAghnfEAWbyicQ57iw/+2EY2VlGgaM2v8eC+CfzyDKCDJ8GMh/MdL2gdkrjzeCQ0VIz1
         3SEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cU55pjdD4r0nBMyteMyWhE7PaNwLmw8ghUxQGJMW0Fs=;
        b=ob2uAiM9/sAO1YMHR3m/9xFnNx9JRMAabJI97BpfKTsIxlN5R0rewicJAH83Y3rcGD
         IePEXFnEvs9dx9wTs/nULqKiYbq4wzrupDz+PFFTIfFutkW0NaE66NVC2vic6kXjiHPc
         29kue1+aHJJTP9VeXLjMtqwzzZ2UpJM1aOQEyEsBP/xDj+cwjWYhlHZz2XNa0UldlDfI
         f39f04j7W7YWRk3Fe+B8Y8CMmp4oZCF/VdSIDuWalrZQehtbTvQuiGtmOvcdv2cVyUtz
         V/vlxNdxvPbbtViLWnH2cNM/vsGWkeXl+lN2cbx27E7PU2feZJAse1con/E4EENJLxGO
         74EQ==
X-Gm-Message-State: AOAM530Z6uBDWuS0cPvQQImkFJScBcnkf4iUi/qcbKmge+E6HCPsDpCT
        lQrscdLbdX7J+p0M6xwjn617Dv5uaoJvXcDHEhc=
X-Google-Smtp-Source: ABdhPJyBw5sHnBRqaWNlJyR1gE6YQr3fx0atFpjxEN79fsb3Knvifnrey/OvQbV1hl1+OigMUXglisolXd1fqBi2KNM=
X-Received: by 2002:a81:1914:0:b0:2f5:ec26:1b99 with SMTP id
 20-20020a811914000000b002f5ec261b99mr15369813ywz.252.1651577626029; Tue, 03
 May 2022 04:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220430135622.103683-1-claudiajkang@gmail.com>
 <4320a4cb3e826335db51a6fac49053dbd386f119.camel@redhat.com>
 <56e0b30632826dda7db247bd5b6e4bb28245eaa7.camel@perches.com> <83d7f24b-660e-1090-beef-f42fc29fe8aa@gmail.com>
In-Reply-To: <83d7f24b-660e-1090-beef-f42fc29fe8aa@gmail.com>
From:   Juhee Kang <claudiajkang@gmail.com>
Date:   Tue, 3 May 2022 20:33:11 +0900
Message-ID: <CAK+SQuS5vFK4MDP2ntGe4jzorLM1EgG0q-unbT+r=Y8gpV12qQ@mail.gmail.com>
Subject: Re: [net-next PATCH] amt: Use BIT macros instead of open codes
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Joe Perches <joe@perches.com>, Paolo Abeni <pabeni@redhat.com>,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>
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

Hello Paolo and Joe,

Thanks for the reviews!


On Tue, May 3, 2022 at 6:28 PM Taehee Yoo <ap420073@gmail.com> wrote:
>
> 2022. 5. 3. =EC=98=A4=EC=A0=84 2:19=EC=97=90 Joe Perches =EC=9D=B4(=EA=B0=
=80) =EC=93=B4 =EA=B8=80:
>  > On Mon, 2022-05-02 at 12:11 +0200, Paolo Abeni wrote:
>
> Hi Paolo and Joe,
> Thanks a lot for the reviews!
>
>  >> On Sat, 2022-04-30 at 13:56 +0000, Juhee Kang wrote:
>  >>> Replace open code related to bit operation with BIT macros, which
> kernel
>  >>> provided. This patch provides no functional change.
>  > []
>  >>> diff --git a/drivers/net/amt.c b/drivers/net/amt.c
>  > []
>  >>> @@ -959,7 +959,7 @@ static void amt_req_work(struct work_struct *wor=
k)
>  >>>    amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
>  >>>    spin_lock_bh(&amt->lock);
>  >>>   out:
>  >>> -  exp =3D min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT=
);
>  >>> +  exp =3D min_t(u32, (1 * BIT(amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
>  >>>    mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp *
> 1000));
>  >>>    spin_unlock_bh(&amt->lock);
>  >>>   }
>  >>> diff --git a/include/net/amt.h b/include/net/amt.h
>  > []
>  >>> @@ -354,7 +354,7 @@ struct amt_dev {
>  >>>   #define AMT_MAX_GROUP            32
>  >>>   #define AMT_MAX_SOURCE           128
>  >>>   #define AMT_HSIZE_SHIFT          8
>  >>> -#define AMT_HSIZE         (1 << AMT_HSIZE_SHIFT)
>  >>> +#define AMT_HSIZE         BIT(AMT_HSIZE_SHIFT)
>  >>>
>  >>>   #define AMT_DISCOVERY_TIMEOUT    5000
>  >>>   #define AMT_INIT_REQ_TIMEOUT     1
>  >>
>  >> Even if the 2 replaced statements use shift operations, they do not
>  >> look like bit manipulation: the first one is an exponential timeout,
>  >> the 2nd one is an (hash) size. I think using the BIT() macro here wil=
l
>  >> be confusing.
>  >
>  > I agree.
>  >
>  > I also believe one of the uses of amt->req_cnt is error prone.
>  >
>  >      drivers/net/amt.c:946:  if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
>  >
>  > Combining a test and post increment is not a great style IMO.
>  > Is this really the intended behavior?
>
> I agree that it would be better to avoid that style.
> I will send a patch for that after some bugfix.
>
> Thanks a lot,
> Taehee Yoo
>
>  >
>  >



--=20

Best regards,
Juhee Kang
