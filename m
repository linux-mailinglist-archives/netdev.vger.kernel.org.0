Return-Path: <netdev+bounces-5341-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 06182710E54
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:28:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4BA32814E0
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 14:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14E1F156EF;
	Thu, 25 May 2023 14:28:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096AF156EE
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 14:28:06 +0000 (UTC)
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4665A195;
	Thu, 25 May 2023 07:28:05 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id ada2fe7eead31-439554d9a69so709629137.1;
        Thu, 25 May 2023 07:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685024884; x=1687616884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KABNbqgRSF0ElKxd5/lulUsYdIV0ZGlWkswDAW4GXS0=;
        b=LI7VgDt2YvGlufUmETttGA0dMPhUSaOePjgRZfDvPh654KQmqMTZaA9nyEmvKEdHdD
         6JeqEDYtriVnbHpDlSGE2l3Z2wwTeVYgQIZCnmg/j/u+xCYK639DUxl40vBu94F2ks4h
         ru8Y36StcH7ic/upryppG/EO0VBssQEElcn237Y1A3O41mxzQs2Gtr1Qc9XzSHHu/vxI
         bC/UTvjgeGWY+JKWeM/fYIgIODntdQYfVh+zI8bzYUGASEeDmArKwGgXfOm/TS1+fxsf
         r8+vV/wXAeKySN+BcL3hgdB8tkwg6Z37X9M3IxKnTYahGZefZjjCmXP0ut4XEqiEKBKV
         aawg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685024884; x=1687616884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KABNbqgRSF0ElKxd5/lulUsYdIV0ZGlWkswDAW4GXS0=;
        b=VzIvRSdiX1Sr3Nab1xLE80UgbHqUf4xFUTnCpvzEBNtgi/bD35xt3KN6+WstOWc/j9
         TLokrupw/7WxxM+2iaekf+zpS3e9cPe0FA0ECyagR2m1K4bnrQFbjHgd9ittynRWaS8+
         OuVqTEjVV5l3uPZG71U98SjjVkFbP9Ch1vwN3EDloCmaoJuda9kKd+odWNSZUyUnSim9
         Djgw4dOk3OtH8WNR7jILw+lA0N3swn8oVMAhcZhwOT6cWVcTpylEqQO1OGu60pty1aoq
         kAHamSc0I7jJ9pMjJFGJJ0ogwEK64o5+Nilas7BhzV03zdS64hNDiD/LN3YWQTF9SxZd
         u/7g==
X-Gm-Message-State: AC+VfDzRoouOo07VpCjyhFvQ1mZrQMG4etnm7yLBueo2KEjLybTB/Hea
	p0CskvpE4ArgN35PhitlfQsFcQ3dUsrsi0NSb3M=
X-Google-Smtp-Source: ACHHUZ6whagj/KairX2rPB95POUHKDXohXY/Ovl50/lXjaFnjBy+NEnbdnbPmymX+31TWsYMa8dOE09nQ01LnO4OHNA=
X-Received: by 2002:a05:6102:126e:b0:42e:5b08:ec71 with SMTP id
 q14-20020a056102126e00b0042e5b08ec71mr853836vsg.11.1685024884316; Thu, 25 May
 2023 07:28:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230523223944.691076-1-Kenny.Ho@amd.com> <01936d68-85d3-4d20-9beb-27ff9f62d826@lunn.ch>
 <CAB9dFdt4-cBFhEqsTXk9suE+Bw-xcpM0n3Q6rFmBaa+8A5uMWQ@mail.gmail.com>
 <c0fda91b-1e98-420f-a18a-16bbed25e98d@lunn.ch> <CAOWid-erNGD24Ouf4fAJJBqm69QVoHOpNt0E-G+Wt=nq1W4oBQ@mail.gmail.com>
 <5b1355b8-17f7-49c8-b7b5-3d9ecdb146ce@lunn.ch> <CAOWid-dYtkcKuNxoOyf3yqSJ7OtcNjaqJLVX1QhRUhYSOO6vHA@mail.gmail.com>
 <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com>
In-Reply-To: <30d65ea9170d4f60bd76ed516541cb46@AcuMS.aculab.com>
From: Kenny Ho <y2kenny@gmail.com>
Date: Thu, 25 May 2023 10:27:53 -0400
Message-ID: <CAOWid-eEbeeU9mOpwgOatt5rHQhRt+xPrsQ1fsMemVZDdeN=MQ@mail.gmail.com>
Subject: Re: [PATCH] Remove hardcoded static string length
To: David Laight <David.Laight@aculab.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Marc Dionne <marc.dionne@auristor.com>, 
	Kenny Ho <Kenny.Ho@amd.com>, David Howells <dhowells@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 5:14=E2=80=AFAM David Laight <David.Laight@aculab.c=
om> wrote:
>
> I does rather beg the question as what is in UTS_RELEASE when
> it exceeds (IIRC) about 48 characters?

Thanks for the question as it made me dig deeper.  UTS_RELEASE is
actually capped at 64:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/Makef=
ile?#n1317
"""
uts_len :=3D 64
define filechk_utsrelease.h
if [ `echo -n "$(KERNELRELEASE)" | wc -c ` -gt $(uts_len) ]; then \
 echo '"$(KERNELRELEASE)" exceeds $(uts_len) characters' >&2;    \
 exit 1;                                                         \
...
"""

So UTS_RELEASE on its own would fit perfectly by coincidence (and it
is also why UTS_RELEASE with the pre and postfix exceeds the limit.)
That makes me wonder if the content / format of the version matter and
looks like it sort of does by looking at when the string was
introduced:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/net=
/rxrpc/local_object.c?id=3D44ba06987c0b10faa998b9324850e8a6564c714d

"The standard formulation seems to be: <project> <version> built
<yyyy>-<mm>-<dd>"

That commit also confirms the size and null termination requirement.

I will create a separate patch with your suggestion.

Regards,
Kenny

