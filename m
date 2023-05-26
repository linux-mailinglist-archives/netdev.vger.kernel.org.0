Return-Path: <netdev+bounces-5762-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAF6712ABF
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 18:37:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D018E1C20F41
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 16:37:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40C9271F6;
	Fri, 26 May 2023 16:37:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E062CA6
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 16:37:26 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98623DF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:37:23 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f5dbd8f677so63925e9.1
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685119042; x=1687711042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EY8jNRNfAa0Ugc42QcvXpqkmlzbK+JbHaTZLZiADEaE=;
        b=De6LirTmjImnmRKlEqNPvy3JPAo2CR65jhpJD0oGuGW8VgRXuVGyhNZyzKlQlSoak3
         KVyRwC2UjOk5mnVr1vIjSAO1ZlaJp/OfszCysoCsP/OT00FJDh/y+gqaRGBqMhsNJdTs
         mn0GEl71o/Q40nq6QmPpRmLFK3oWrjXTGN3mOpXhot4VTm4K6wNfdlF+3GxdsVZsFhsR
         HsNwwe4vqovoNpqmAEWVAvI3D3jvR6xW4eGXZ0bUpD3yxdjx3frSyMI1r297n+BHEPnc
         bGDaBGx78/R3AOxec3a2nzy+udYTBlMyerU05I7wpp9x3vLuPbYzrnw+ziQ5Xc+8PQ3e
         +nVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685119042; x=1687711042;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EY8jNRNfAa0Ugc42QcvXpqkmlzbK+JbHaTZLZiADEaE=;
        b=lGBJFnWG9FdXUWC/UzAcYHxdrlDz/B5yeY0YKfw8ens8dAdGvvRfyWEhyq0xzgPqrH
         cVWNg8SOF/AZVQAo6p6gmNWelJUx7zzUDgwxgwXozknip11sclnyiRn22/oSURgrFqKO
         FB2igjoxgvD+D4uzGGTyhJYSXjzrU2P3rgzJks9XkBR8H5TV6pcx5iK+JXMGv9XGmDVl
         7oIhKMdyYHz2H8mt9m5j8ceStr9kpAbKVvf+DW8OXE/V2AKlEB036/uPxvETSYZzH3zR
         HYCffZNoVhOBAz/S+0/x+y034g5QJwCHG8pytmrmHpFvGHjse5jRe6WoKu5N85Vhqzz+
         329w==
X-Gm-Message-State: AC+VfDy881PqxWcV0grNBpzazuEpZwPgzzXxO9XpLea9W862WYotzwqD
	dKc/LfoU/y8IIZVZ4TceQr7cgPXF5BHxHixXpPGB1oalw9UtOGVbaGo+LA==
X-Google-Smtp-Source: ACHHUZ6luz3NVVUHHwLHkIApI6hqmLmBGSoFjISIyczkObu857DbTinAwsZjNBeumKUB6CavLiHhASOB1maa4I1JmkE=
X-Received: by 2002:a05:600c:3c93:b0:3f4:2594:118a with SMTP id
 bg19-20020a05600c3c9300b003f42594118amr132218wmb.2.1685119041804; Fri, 26 May
 2023 09:37:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANn89iKUbyrJ=r2+_kK+sb2ZSSHifFZ7QkPLDpAtkJ8v4WUumA@mail.gmail.com>
 <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
In-Reply-To: <CAHk-=whqNMUPbjCyMjyxfH_5-Xass=DrMkPT5ZTJbFrtU=qDEQ@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 26 May 2023 18:37:09 +0200
Message-ID: <CANn89i+bExb_P6A9ROmwqNgGdO5o8wawVZ5r3MHnz0qfhxvTtA@mail.gmail.com>
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

On Fri, May 26, 2023 at 6:30=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, May 26, 2023 at 8:00=E2=80=AFAM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > We can see rep_movs_alternative() using more cycles in kernel profiles
> > than the previous variant (copy_user_enhanced_fast_string, which was
> > simply using "rep  movsb"), and we can not reach line rate (as we
> > could before the series)
>
> Hmm. I assume the attached patch ends up fixing the regression?
>
> That hack to generate the two-byte 'jae' instruction even for the
> alternative is admittedly not pretty, but I just couldn't deal with
> the alternative that generated pointlessly bad code.
>
> We could make the constant in the comparison depend on whether it is
> for the unrolled or for the erms case too, I guess, but I think erms
> is probably "good enough" with 64-byte copies.
>
> I was really hoping we could avoid this, but hey, a regression is a regre=
ssion.
>
> Can you verify this patch fixes things for you?


Hmm.. my build environment does not like this yet :)

arch/x86/lib/copy_user_64.S:40:30: error: unexpected token in argument list
0: alternative ".byte 0x73," ".Lunrolled" "-0b-2", ".byte 0x73,"
".Llarge" "-0b-2", X86_FEATURE_ERMS
                             ^
make[3]: *** [scripts/Makefile.build:374: arch/x86/lib/copy_user_64.o] Erro=
r 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [scripts/Makefile.build:494: arch/x86/lib] Error 2
make[2]: *** Waiting for unfinished jobs....
make[1]: *** [Makefile:2026: .] Error 2

