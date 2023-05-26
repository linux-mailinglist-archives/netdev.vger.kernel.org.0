Return-Path: <netdev+bounces-5777-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1A09712B92
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:17:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95E501C210CF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:17:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB38A28C17;
	Fri, 26 May 2023 17:17:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7812CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:17:25 +0000 (UTC)
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E004D19A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:17:23 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so1786502a12.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1685121442; x=1687713442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2SDbH8jwxHalkcPD4Gq6t9y7De5VNrdlKn9k4tsGfLw=;
        b=MW/im5IXrVqJSdFDGWSOK84wY4O3RxP+EURvoOQQHBAfvGOrslzA20/mwIm2C4u0kR
         cK1Txc+qhLf5IwZiqNXj9N3x0ArpC7dps9Loty59MDYPLbPFfsjG6ABnRd/nU0jPXleN
         FdPlR7eSep4csAWuqiHcaeA5bnNUKk4HKBh68=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685121442; x=1687713442;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2SDbH8jwxHalkcPD4Gq6t9y7De5VNrdlKn9k4tsGfLw=;
        b=gxfTR2+cf/5sidT+Xa6UyO9dVB6/S/axMB0Qq1YoHKb4MF0CW2OAA5ztFM9hGiuqUN
         xB8OhQa401vJu1NxGoJRCeyiviKMxSSeMi7minxOgu1UOpV/3HQn+RO/lv4ByzfMtRaS
         iH4lQYu0A5C9KNV9fJkt+lTWh/44n1vZqtpB3cimaB5UKB9szqhEgYN94bjSzNvXWTbT
         cKpLTyOMH+QIJEXPjolwDO80yk4sfucFbbZfpxAXWxsArDNwoeIsiAn5xwFyd5J052kH
         A7+28zN7PmhM7/Xh5YptDznccG+q90GN0ZeRplKIJTrT1gpgN/eDRuk0iM7wrlCOKY26
         stYg==
X-Gm-Message-State: AC+VfDyNj2WrMMUcbSYZnebGXKbJVGT+T++eHzzlMkQv+xyb9BdSFGE0
	uzNw3ig7y8fks+Gi9Cc9d5AKcjC5ASInKzca3QIjWaDX
X-Google-Smtp-Source: ACHHUZ57QlvrKbjYYYM2I0E51grI680PoYOMoidOqvfGJYEhaesFv4WQsoawofpArL17c4cdTHDZYA==
X-Received: by 2002:a17:907:1b17:b0:96f:9a90:c924 with SMTP id mp23-20020a1709071b1700b0096f9a90c924mr2753662ejc.74.1685121442044;
        Fri, 26 May 2023 10:17:22 -0700 (PDT)
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com. [209.85.208.49])
        by smtp.gmail.com with ESMTPSA id f19-20020a170906139300b0095fd0462695sm2347003ejc.5.2023.05.26.10.17.21
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 10:17:21 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so1786411a12.0
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:17:21 -0700 (PDT)
X-Received: by 2002:a17:907:2684:b0:969:e55f:cca2 with SMTP id
 bn4-20020a170907268400b00969e55fcca2mr2526701ejc.38.1685121440670; Fri, 26
 May 2023 10:17:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
 <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com> <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
In-Reply-To: <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 26 May 2023 10:17:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
Message-ID: <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Eric Dumazet <edumazet@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000e02ff905fc9be809"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

--000000000000e02ff905fc9be809
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 26, 2023 at 10:00=E2=80=AFAM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Let me go look at it some more. I *really* didn't want to make the
> code worse for ERMS

Oh well. I'll think about it some more in the hope that I can come up
with something clever that doesn't make objtool hate me, but in the
meantime let me just give you the "not clever" patch.

It generates an annoying six-byte jump when the small 2-byte one would
work just fine, but I guess only my pride is wounded.

              Linus

--000000000000e02ff905fc9be809
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_li4tsaq50>
X-Attachment-Id: f_li4tsaq50

IGFyY2gveDg2L2xpYi9jb3B5X3VzZXJfNjQuUyB8IDEwICsrKysrKysrKy0KIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9hcmNoL3g4
Ni9saWIvY29weV91c2VyXzY0LlMgYi9hcmNoL3g4Ni9saWIvY29weV91c2VyXzY0LlMKaW5kZXgg
NGZjNWMyZGUyZGU0Li43ZTk3MjIyNGIwYmEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2xpYi9jb3B5
X3VzZXJfNjQuUworKysgYi9hcmNoL3g4Ni9saWIvY29weV91c2VyXzY0LlMKQEAgLTcsNiArNyw4
IEBACiAgKi8KIAogI2luY2x1ZGUgPGxpbnV4L2xpbmthZ2UuaD4KKyNpbmNsdWRlIDxhc20vY3B1
ZmVhdHVyZXMuaD4KKyNpbmNsdWRlIDxhc20vYWx0ZXJuYXRpdmUuaD4KICNpbmNsdWRlIDxhc20v
YXNtLmg+CiAjaW5jbHVkZSA8YXNtL2V4cG9ydC5oPgogCkBAIC0yOSw3ICszMSw3IEBACiAgKi8K
IFNZTV9GVU5DX1NUQVJUKHJlcF9tb3ZzX2FsdGVybmF0aXZlKQogCWNtcHEgJDY0LCVyY3gKLQlq
YWUgLkx1bnJvbGxlZAorCWFsdGVybmF0aXZlICJqYWUgLkx1bnJvbGxlZCIsICJqYWUgLkxsYXJn
ZSIsIFg4Nl9GRUFUVVJFX0VSTVMKIAogCWNtcCAkOCwlZWN4CiAJamFlIC5Md29yZApAQCAtNjUs
NiArNjcsMTIgQEAgU1lNX0ZVTkNfU1RBUlQocmVwX21vdnNfYWx0ZXJuYXRpdmUpCiAJX0FTTV9F
WFRBQkxFX1VBKCAyYiwgLkxjb3B5X3VzZXJfdGFpbCkKIAlfQVNNX0VYVEFCTEVfVUEoIDNiLCAu
TGNvcHlfdXNlcl90YWlsKQogCisuTGxhcmdlOgorMDoJcmVwIG1vdnNiCisxOglSRVQKKworICAg
ICAgICBfQVNNX0VYVEFCTEVfVUEoIDBiLCAxYikKKwogCS5wMmFsaWduIDQKIC5MdW5yb2xsZWQ6
CiAxMDoJbW92cSAoJXJzaSksJXI4Cg==
--000000000000e02ff905fc9be809--

