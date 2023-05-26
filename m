Return-Path: <netdev+bounces-5782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 89058712BB5
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 19:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EE7D28191D
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D48E28C26;
	Fri, 26 May 2023 17:25:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B39271F6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 17:25:40 +0000 (UTC)
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3567AF3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:25:37 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so2995e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685121935; x=1687713935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l8g5Xna8j25EFmespE1bvOARSHuLS2nJdLVHo25mjSE=;
        b=f23M39+X+33xnPxCbKYMOJ14/bCAA9KXeklSOwa8N+tHHQEeVXO9PG06uqnHlgbpvJ
         yZcoi+2V0Rnvo3xNSbHS90ZINBSY8pxHi1Xm96Pc1OjyRBIMYwQg2pzWUKm9EvEGoqIg
         mRQCwruUR1IwLekhmrhr2T58qvSw2Qkt3CloEtcqrhHH6VZq5NTF+ZeRAfTCprFOJPL7
         s4ZPJ02tHgnaBv2DpSE42RD6H0VRLlp6RyMZXB3hJs1tYXQm0tIoHRpXpiEHXKluB88B
         6iMsG8tJ8UdDub6koAvqI+jJOj4p/m1joTQtKjUwx/iR1zcf7M4i1WxdB9+hz7d0nCFk
         KzDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685121935; x=1687713935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l8g5Xna8j25EFmespE1bvOARSHuLS2nJdLVHo25mjSE=;
        b=JaF9yOloGtc+/MPQ162c0FCArV5ZrEk7JU+XVa34j4pW6ig6PLNM5+D8dBeSwaoGwC
         2DrC2U0eSJzSMB9KbILWKpxwnknFMGdWzqYC7LyVmiIRbukBlYCVAULFub/6T5bgwuaH
         73wlMSvrVsVFgsmXrHeBUaahXInwFVOh1lyID/C+1svHM7PpaxwbDfH3ZkEY5ErxMedO
         hPEe6avGquYVkob7e8WIF0tzOJWwtwGhF7IJ95WsXCdA6laA+FlHjvUMbgJ2MHqT1IVu
         RSSC9p7GlYN0WHmTvxvNY0jlXZU76D0tLkjZ/bAeM67Ga5D6QDcOTH0b6I33epSqvTt7
         muFg==
X-Gm-Message-State: AC+VfDxwgFuUfDE3ZyxlgwAOLfj7IHNAeBeWTaZX/AKThIPYGcyYe6lX
	KfW0k+zPS3+kYzAHSTfP/+NFzwcfPt4zn39xULkQJA==
X-Google-Smtp-Source: ACHHUZ4Br5pF7X3UghPjBulDtJS9kb5PDC2rSf69Im3yVJUMPcC8EHvOTVaj+JsGIKn1he9aPepATioYeEtg/pDKIjs=
X-Received: by 2002:a05:600c:458b:b0:3f1:758c:dd23 with SMTP id
 r11-20020a05600c458b00b003f1758cdd23mr123345wmo.7.1685121935222; Fri, 26 May
 2023 10:25:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
 <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
 <CAHk-=wig6VizZHtRznz7uAWa-hHWjrCNANZ9B+1G=aTWPiVH4g@mail.gmail.com>
 <CAHk-=whkci5ck5Him8Lx5ECKHEtj=bipYmOCGe8DWrrp8uDq5g@mail.gmail.com> <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
In-Reply-To: <CAHk-=whtDupvWtj_ow11wU4_u=KvifTqno=5mW1VofyehjdVRA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 19:25:23 +0200
Message-ID: <CANn89i+u8jvfSQAQ=_JY0be56deJNhKgDWbqpDAvfm-i34qX9A@mail.gmail.com>
Subject: Re: x86 copy performance regression
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 7:17=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, May 26, 2023 at 10:00=E2=80=AFAM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Let me go look at it some more. I *really* didn't want to make the
> > code worse for ERMS
>
> Oh well. I'll think about it some more in the hope that I can come up
> with something clever that doesn't make objtool hate me, but in the
> meantime let me just give you the "not clever" patch.
>
> It generates an annoying six-byte jump when the small 2-byte one would
> work just fine, but I guess only my pride is wounded.

arch/x86/lib/copy_user_64.S:34:2: error: invalid instruction mnemonic
'alternative'
 alternative "jae .Lunrolled", "jae .Llarge", ( 9*32+ 9)
 ^~~~~~~~~~~

I changed alternative to ALTERNATIVE to let it build.

 SYM_FUNC_START(rep_movs_alternative)
        cmpq $64,%rcx
-       jae .Lunrolled
+       ALTERNATIVE "jae .Lunrolled", "jae .Llarge", X86_FEATURE_ERMS

I will report test result soon, thanks !

