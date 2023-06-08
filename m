Return-Path: <netdev+bounces-9281-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4316872859F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84AE11C21048
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 16:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 394AA174DF;
	Thu,  8 Jun 2023 16:41:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B4E023D7
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 16:41:08 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12A0230CB
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 09:40:30 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-bacf5b89da7so892639276.2
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 09:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1686242420; x=1688834420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UwnQ7gMh3uF6spn3zYJa58b55y9bAxiBUmqGszFwGVo=;
        b=lV8Oq9jr+qs5CBBD4k99wi7E6Erg+3UMqQO6g1CLrP6DZMzZcC8mo1C1/edmWtYSgm
         SHXhqE8CsET658KeeX2HFIDNBg74QRHOtn02txcoeaUVJE2rvZr7EhLHCrbOx0Ua3VmM
         ENXiR/wro9HlowHjylthoBK1osBPztl8Hy/eeH/A7ifXmBtdsDwk4sBH5n2ZddovlXzg
         DqeBSS/l/vGkw/Exb+DFzTJbnhlwpEtFKj1ozLzw0uRHJBcs7Sdet0YJCIc9ZVRGu6j/
         84PO5q77AiiKBp/NCxKjc2sfz6WZT9zcV00JlijBVVwuo9whKudvvP76GJ/dz80+8DYT
         39xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686242420; x=1688834420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UwnQ7gMh3uF6spn3zYJa58b55y9bAxiBUmqGszFwGVo=;
        b=hDu4y2zsgRSWDU3MS1hInoxPG5pO+YSMtsW8YT9XvqUQHeK5e8pv7sZOOncJE+5p4y
         ZHV60QIF5zkUaYLwbt38xPGAJumJOVkLCbfO0U+ko9Tr2Sev/TjEFor7pyOHSzgoesrk
         hlfwJNteDD+hEOP5yLZfB8Uoi/zvAaU0FRa4F7GwHWo825Qai3icE2So7I2idjtczLVr
         vDJvbkS8O3eP6f4LE5eI+jKfFB6CEB8S40ryOhFN9oWtrmm5aqz1vnBW87w5G0GU5ZI+
         xWvd2+UBxc7V+m8OTrK8iLQ+LySE7KvkasiijtyYIZyxSONWEXF0GWXdmcPIiuMm3XNe
         eFCA==
X-Gm-Message-State: AC+VfDxsRabGkhpggkSb1TULuP8hJkFx/dvCSMgWBziVZ9TQq7yQcjsL
	GfxL56E2+3R8/8REQamL5DTEMe/bk/8zXU/QIowgEw==
X-Google-Smtp-Source: ACHHUZ7AhZn88bGMPHCodPlvz7TYoJYekWOxx3DkGp98MOcvdzej8YJDk5M7zt3LTY6QweM05oWxl2WZDOFPXYaXAio=
X-Received: by 2002:a81:5c86:0:b0:569:4fc4:62fe with SMTP id
 q128-20020a815c86000000b005694fc462femr283806ywb.12.1686242420111; Thu, 08
 Jun 2023 09:40:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608072903.3404438-1-lee@kernel.org> <CANn89iKtkzTKhmeK15BO4uZOBQJhQWgQkaUgT+cxo+BwxE6Ofw@mail.gmail.com>
 <20230608074701.GD1930705@google.com>
In-Reply-To: <20230608074701.GD1930705@google.com>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Thu, 8 Jun 2023 12:40:09 -0400
Message-ID: <CAM0EoM=osXFK7FLzF2QB3PvZ+W4sr=pnPD5jG1FjrzSbw-emWQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] net/sched: cls_u32: Fix reference counter leak
 leading to overflow
To: Lee Jones <lee@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>, xiyou.wangcong@gmail.com, jiri@resnulli.us, 
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 3:47=E2=80=AFAM Lee Jones <lee@kernel.org> wrote:
>
> On Thu, 08 Jun 2023, Eric Dumazet wrote:
>
> > On Thu, Jun 8, 2023 at 9:29=E2=80=AFAM Lee Jones <lee@kernel.org> wrote=
:
> > >
> > > In the event of a failure in tcf_change_indev(), u32_set_parms() will
> > > immediately return without decrementing the recently incremented
> > > reference counter.  If this happens enough times, the counter will
> > > rollover and the reference freed, leading to a double free which can =
be
> > > used to do 'bad things'.
> > >
> > > In order to prevent this, move the point of possible failure above th=
e
> > > point where the reference counter is incremented.  Also save any
> > > meaningful return values to be applied to the return data at the
> > > appropriate point in time.
> > >
> > > This issue was caught with KASAN.
> > >
> > > Fixes: 705c7091262d ("net: sched: cls_u32: no need to call tcf_exts_c=
hange for newly allocated struct")
> > > Suggested-by: Eric Dumazet <edumazet@google.com>
> > > Signed-off-by: Lee Jones <lee@kernel.org>
> > > ---
> >
> > Thanks Lee !
>
> No problem.  Thanks for your help.
>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

> --
> Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]

