Return-Path: <netdev+bounces-5758-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C8EC712AA3
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 128AF1C21110
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C495182A5;
	Fri, 26 May 2023 16:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4869428C02
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:30:23 +0000 (UTC)
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E43FD8
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:30:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96fffe11714so162476366b.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685118619; x=1687710619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rAOvIEHc+VxLUcDo7/1SZK+gxa4MgVK+c4EuJ+y9RwE=;
        b=TL0zUBAHAR2Y4qU+wjlAFDOW+IoU8PZhjy9GhK3tZHrBVeLQS4nSieUVKS/fQqf4R/
         6MVAUI78rJQpJfy+wqITaLMH7MbUIRQbCJLPeYqZACtOSIPbpkDX2QC2skaU3l7BDUfm
         UuUobXOWKudLHMbtc7ycHC/dVRmrHJFT+S4y0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685118619; x=1687710619;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rAOvIEHc+VxLUcDo7/1SZK+gxa4MgVK+c4EuJ+y9RwE=;
        b=aufo0SXjVDL9WpnxCj1QLb/KwIS156E1vgfYw+v13ZDpo31URhA7IVatYepaPsmnN9
         HKAi6bEDZ64Q1ToGazObmP9tBCVXt3L10WiV7+xm6yK+YLjoESA3+PMQE9fwYDb8GxE5
         ztxpwGtTZ6ZghM3Pj1dfQ8txN95vA0uheZggDBhqu79zAI11U/fjcPEKKMVjJjkl+Sal
         AA/7ilF7VyYo7FPae9GWg1tjatCfXJ7+3bd2gtMRmO3VvyZYFw6uLf4CwPP6uRzrHJKM
         uE2HOAuEYolYTlJf5zU+Gb1PSjov0PUEfE+Cuwq/Rqn75Iw9bxLt9kalmQYACaJMkGvc
         8D3w==
X-Gm-Message-State: AC+VfDwCYjX5qsBWrVLuBebQshXUUnQqPvYovp29Rh2oAqLQr9zhymH8
	tFwEi1NqrdDRyL1XtwuRO+80EkTw3EgXis3UbVKLo1tJ
X-Google-Smtp-Source: ACHHUZ7UQr/7Rp+ffNy7cm6KwhuCaVeeeCHpYkSkq82s8MawptN2QssDIJCUZ51KT9brxV3Pw6B7EA==
X-Received: by 2002:a17:907:1b1b:b0:94f:3521:396 with SMTP id mp27-20020a1709071b1b00b0094f35210396mr3115121ejc.23.1685118618537;
        Fri, 26 May 2023 09:30:18 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id f22-20020a50ee96000000b0050c0d651fb1sm104054edr.75.2023.05.26.09.30.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 09:30:17 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-96aae59bbd6so160081566b.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:30:17 -0700 (PDT)
X-Received: by 2002:a17:906:fd8d:b0:96f:5f44:ea02 with SMTP id
 xa13-20020a170906fd8d00b0096f5f44ea02mr2729037ejb.8.1685118617396; Fri, 26
 May 2023 09:30:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
In-Reply-To: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 09:29:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
Message-ID: <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Eric Dumazet <edumazet@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000987cc805fc9b40ca"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000987cc805fc9b40ca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 8:00=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> We can see rep_movs_alternative() using more cycles in kernel profiles
> than the previous variant (copy_user_enhanced_fast_string, which was
> simply using "rep  movsb"), and we can not reach line rate (as we
> could before the series)

Hmm. I assume the attached patch ends up fixing the regression?

That hack to generate the two-byte 'jae' instruction even for the
alternative is admittedly not pretty, but I just couldn't deal with
the alternative that generated pointlessly bad code.

We could make the constant in the comparison depend on whether it is
for the unrolled or for the erms case too, I guess, but I think erms
is probably "good enough" with 64-byte copies.

I was really hoping we could avoid this, but hey, a regression is a regress=
ion.

Can you verify this patch fixes things for you?

                  Linus

--000000000000987cc805fc9b40ca
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_li4s3rll0>
X-Attachment-Id: f_li4s3rll0

IGFyY2gveDg2L2xpYi9jb3B5X3VzZXJfNjQuUyB8IDE2ICsrKysrKysrKysrKysrKy0KIDEgZmls
ZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEv
YXJjaC94ODYvbGliL2NvcHlfdXNlcl82NC5TIGIvYXJjaC94ODYvbGliL2NvcHlfdXNlcl82NC5T
CmluZGV4IDRmYzVjMmRlMmRlNC4uMjFmMTFiZDM2Y2RjIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9s
aWIvY29weV91c2VyXzY0LlMKKysrIGIvYXJjaC94ODYvbGliL2NvcHlfdXNlcl82NC5TCkBAIC03
LDkgKzcsMTcgQEAKICAqLwogCiAjaW5jbHVkZSA8bGludXgvbGlua2FnZS5oPgorI2luY2x1ZGUg
PGFzbS9hbHRlcm5hdGl2ZS5oPgogI2luY2x1ZGUgPGFzbS9hc20uaD4KICNpbmNsdWRlIDxhc20v
ZXhwb3J0Lmg+CiAKKy8qCisgKiBEaXNndXN0aW5nIGhhY2sgdG8gZ2VuZXJhdGUgYSB0d28tYnl0
ZSAnamFlJyBpbnN0cnVjdGlvbgorICogZm9yICdhbHRlcm5hdGl2ZXMnIHRoYXQgd291bGQgb3Ro
ZXJ3aXNlIGdlbmVyYXRlIGEgcmVsb2NhdGlvbgorICogYW5kIGEgYmlnIGp1bXAuCisgKi8KKyNk
ZWZpbmUgSkFFKHgpICIuYnl0ZSAweDczLCIgI3ggIi0wYi0yIgorCiAvKgogICogcmVwX21vdnNf
YWx0ZXJuYXRpdmUgLSBtZW1vcnkgY29weSB3aXRoIGV4Y2VwdGlvbiBoYW5kbGluZy4KICAqIFRo
aXMgdmVyc2lvbiBpcyBmb3IgQ1BVcyB0aGF0IGRvbid0IGhhdmUgRlNSTSAoRmFzdCBTaG9ydCBS
ZXAgTW92cykKQEAgLTI5LDcgKzM3LDcgQEAKICAqLwogU1lNX0ZVTkNfU1RBUlQocmVwX21vdnNf
YWx0ZXJuYXRpdmUpCiAJY21wcSAkNjQsJXJjeAotCWphZSAuTHVucm9sbGVkCiswOglhbHRlcm5h
dGl2ZSBKQUUoLkx1bnJvbGxlZCksIEpBRSguTGxhcmdlKSwgWDg2X0ZFQVRVUkVfRVJNUwogCiAJ
Y21wICQ4LCVlY3gKIAlqYWUgLkx3b3JkCkBAIC02NSw2ICs3MywxMiBAQCBTWU1fRlVOQ19TVEFS
VChyZXBfbW92c19hbHRlcm5hdGl2ZSkKIAlfQVNNX0VYVEFCTEVfVUEoIDJiLCAuTGNvcHlfdXNl
cl90YWlsKQogCV9BU01fRVhUQUJMRV9VQSggM2IsIC5MY29weV91c2VyX3RhaWwpCiAKKy5MbGFy
Z2U6CiswOglyZXAgbW92c2IKKzE6CVJFVAorCisgICAgICAgIF9BU01fRVhUQUJMRV9VQSggMGIs
IDFiKQorCiAJLnAyYWxpZ24gNAogLkx1bnJvbGxlZDoKIDEwOgltb3ZxICglcnNpKSwlcjgK
--000000000000987cc805fc9b40ca--

