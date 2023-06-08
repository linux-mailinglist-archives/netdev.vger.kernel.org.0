Return-Path: <netdev+bounces-9114-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 067FD7274F9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:23:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 618911C20F12
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:23:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3742A1107;
	Thu,  8 Jun 2023 02:23:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE99A52
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 02:23:09 +0000 (UTC)
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2D26A9;
	Wed,  7 Jun 2023 19:23:08 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id 5614622812f47-39aa8a055ecso108740b6e.1;
        Wed, 07 Jun 2023 19:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686190988; x=1688782988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rGkkSk0/C4/bnQbcrMfm2tdEZYME20m/Bpb2UhtM8LM=;
        b=kO58IsSUgv7SxdqON7BQ46Mli60Pvg5kOD7zIwFnl6uM4cdbqwwZ7i3QFkOTSNX0Xd
         Q3tlA/EspBc8nb9U7J+jDzy4Q8ZIAYghNiSYXIDz4p1kgkhMP7Au/C2VTQZFTRWOg3Ly
         q/MoHvnu4HiPSDc59SYgnu5q2XI+1579WnyFhbQXrzRwUfWBUAEmY7Ec93qiSFCKSFdA
         rp2H/rS/382h3CRSaqy3H9JkBzSjEapnRU3+9TZgkAGiZBg0eOgTrTymQR1G9T2z9sNF
         AMgeNnybekX6wJ3rSHjPCcRkwvNtrPP/6gdaAdQpwifXXeUe+AG6PH+hoLBm/XmcHypJ
         zQlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686190988; x=1688782988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rGkkSk0/C4/bnQbcrMfm2tdEZYME20m/Bpb2UhtM8LM=;
        b=NnCTJ3OyS62tGwXKEbKWwfVEuqSrwZUif5V+jvlaGMYLNySCZ752OFt7wubtlXt2T7
         GmKxa3SBjOFWSjHBeIovjursEg3aIcArfPwwQnsV03YBjQBqkaLmnB49ckHqL1uyxlZU
         NnAHavKrht2z3fEoDee1y6GtBojll4RIHcUdYS0PKBAx9Tn4OI9uN0l531epllfdn6oi
         wo+aPhVNFAIRGU9W0FKBcSJhU5xP4/qBQHFcyXr0JeFBTxJsO+/6Y3dM3hVK1q1ztLmZ
         gcoPlLewLV7rAZEKxfvtdkjoA0zQU0LeGKFqpmsCrNFMV4uAMdFXzcC5FeXZXU8+sE/p
         TTeA==
X-Gm-Message-State: AC+VfDwxRW6sEdl2ptE5QGdN+LkSDPwAsTd8YEbKZ8quVHpNbLy7HeeH
	LdzvtkaWF5v/WssM/g/G7psIXCPjML0QSZdPvck=
X-Google-Smtp-Source: ACHHUZ5u2kIvMA9SzdMee8mj5Xc/KyNzZBta5YguCmcEUqLwQ7OVJ/waKJh8OOV7pJKSj/1A/1fLBH15qLn37Gz/WS8=
X-Received: by 2002:aca:b941:0:b0:39c:7f78:ba6d with SMTP id
 j62-20020acab941000000b0039c7f78ba6dmr62541oif.19.1686190987911; Wed, 07 Jun
 2023 19:23:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602054112.2299565-1-wes.huang@moxa.com> <87y1l2m7u5.fsf@miraculix.mork.no>
In-Reply-To: <87y1l2m7u5.fsf@miraculix.mork.no>
From: Wes Huang <wes155076@gmail.com>
Date: Thu, 8 Jun 2023 10:22:56 +0800
Message-ID: <CAD_g2C3ng83vwbH83ntLgz7z=iDJoBFe5Dj5evJ0gSk5XSq2vw@mail.gmail.com>
Subject: Re: [PATCH 1/1] net: usb: qmi_wwan: add support for Compal RXM-G1
To: =?UTF-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, netdev@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Wes Huang <wes.huang@moxa.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 2, 2023 at 7:18=E2=80=AFPM Bj=C3=B8rn Mork <bjorn@mork.no> wrot=
e:
>
> Wes Huang <wes155076@gmail.com> writes:
>
> > Add support for Compal RXM-G1 which is based on Qualcomm SDX55 chip.
>
> Patch looks good to me, but checkpatch warns about mismatch between From
> (which ends up as Author) and your SoB:
>
>  WARNING: From:/Signed-off-by: email address mismatch: 'From: Wes Huang <=
wes155076@gmail.com>' !=3D 'Signed-off-by: Wes Huang <wes.huang@moxa.com>'
>
> If you have to send this from a different account, then you can work
> around that issue by adding "From: Wes Huang <wes.huang@moxa.com>" as
> the first line of the email body, followed by a single blank line.
>
> git will then use the second From as Author, and it will match the SoB.
>
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>
>
>
> Bj=C3=B8rn

I'll resend the patch and add the "From" information to the first line
of the email body. Thank you!

