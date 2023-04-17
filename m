Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6C3A6E4F79
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:43:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjDQRng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDQRnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:43:33 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3643D5BBA;
        Mon, 17 Apr 2023 10:43:32 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-54f6a796bd0so311432017b3.12;
        Mon, 17 Apr 2023 10:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681753411; x=1684345411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXM3tcJHyt53uhVMevTZLqYzJa2bs0mj/T5pFqvF7sw=;
        b=rqEWGzf8s7VoaYRlNCHWYM5J2ov3tWqIKn697PSaY4EhUKmPWJCGD0qaPA+i8sX5Wq
         XlkMYWvWn/bgu2ewMy6bsrw/OTigdFbHTPkQIoeOz2V3+QVSmeu6vvp4tq3U2kS/LON6
         DBS475NZjyeXVargZQQ6lLke5jGPhfGDFkEw6M4Q2M0RNjcrWnPWB/YYMl7WQzWKLkNI
         AQ3q+i5+72qLKnb1j/J4JckwhE1p5fHvQAaU/WZOHpWXfTRRu1ouVp3cmzhD3YdjNJIB
         UVFDiYRqWvnNS/yUhNnfFwFPgJ/gBWoCDC60rp7ZHl8XKq4agKMTBygzJDMHiaKAdwBJ
         fMUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681753411; x=1684345411;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXM3tcJHyt53uhVMevTZLqYzJa2bs0mj/T5pFqvF7sw=;
        b=N4KesXjUzThBZ4RQXvmS/TykSQEHr3yNFZ/j2leIBgEKbZHzEZozqNNcyvPEo1ijlr
         i+qt2VU8K8k57QJWVyf6e9WDnxEG83oFaignTvPIv//cgRyy2XgSuwu/f3MUUx59kl6S
         JGg5YLK4bN5EQPHH93YyWdEV0JIe4kC/JWxMcj4gOk2NxBepySE3oCj+6zid25mgf+On
         6uuQRsexnzF0EyNeP+O9y7U/FOp/9qaCiTo8XKwFRZ6HgiuYbmtl9/CVaI83XwtyJXCM
         evg+ckKfiIUOvHXAmTx689bF/qZF6gCgNrpXW22PFGQbalxcuciPHGB+XFIZrCbOdN71
         9eRA==
X-Gm-Message-State: AAQBX9cc35oXO5Go30qQtkW2YJkY5SR+MKi3s6ThhqNwvvG/IhR1bt5f
        XJWPCqNzQlxOGEA4MFMUEvJPZObj+kfmwP4f9FU=
X-Google-Smtp-Source: AKy350aA7UVxFBwKHsCUM9rF9SZYtM4FMVPMBZlX8/uZZNtGF7JZ9CAPEV9Bf2aNlqbVwE4tJyTdPOq5KxDBdn/Isbs=
X-Received: by 2002:a05:690c:706:b0:545:5f92:f7ee with SMTP id
 bs6-20020a05690c070600b005455f92f7eemr10476696ywb.2.1681753411040; Mon, 17
 Apr 2023 10:43:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230417053509.4808-1-noltari@gmail.com> <20230417053509.4808-2-noltari@gmail.com>
 <dd1525de-fa91-965f-148a-f7f517ae48f9@kernel.org>
In-Reply-To: <dd1525de-fa91-965f-148a-f7f517ae48f9@kernel.org>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Mon, 17 Apr 2023 19:43:20 +0200
Message-ID: <CAKR-sGeQ5SJk54tcrN+zqZnX9rc32QAzmoOQjrEycS89N9HwCg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: wireless: ath9k: document endian check
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     f.fainelli@gmail.com, jonas.gorski@gmail.com, nbd@nbd.name,
        toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        chunkeey@gmail.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

El lun, 17 abr 2023 a las 9:20, Krzysztof Kozlowski
(<krzk@kernel.org>) escribi=C3=B3:
>
> On 17/04/2023 07:35, =C3=81lvaro Fern=C3=A1ndez Rojas wrote:
> > Document new endian check flag to allow checking the endianness of EEPR=
OM and
> > swap its values if needed.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
>
> Please use scripts/get_maintainers.pl to get a list of necessary people
> and lists to CC.  It might happen, that command when run on an older
> kernel, gives you outdated entries.  Therefore please be sure you base
> your patches on recent Linux kernel.

I forgot to get the updated list for v2, sorry for that!

>
> You missed the lists so this won't be tested. Resend following Linux
> kernel submission process.

Looks like we will need v3 anyway, so I'll get all the maintainers in
the next version.

>
>
> > ---
> >  .../devicetree/bindings/net/wireless/qca,ath9k.yaml          | 5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.y=
aml b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> > index 0e5412cff2bc..ff9ca5e3674b 100644
> > --- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> > +++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
> > @@ -44,6 +44,11 @@ properties:
> >
> >    ieee80211-freq-limit: true
> >
> > +  qca,endian-check:
> > +    $ref: /schemas/types.yaml#/definitions/flag
> > +    description:
> > +      Indicates that the EEPROM endianness should be checked
>
> Does not look like hardware property. Do not instruct what driver should
> or should not do. It's not the purpose of DT.
>
>
> Best regards,
> Krzysztof
>
