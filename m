Return-Path: <netdev+bounces-9499-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04249729730
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 12:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3DCB2818BF
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 10:42:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 149AEA92C;
	Fri,  9 Jun 2023 10:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091467490
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 10:42:44 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBAE3C3A;
	Fri,  9 Jun 2023 03:42:23 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f778c50d64so2793275e9.0;
        Fri, 09 Jun 2023 03:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686307342; x=1688899342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lot98Cc3sqdz25vnOABojTEsU9LUeVox91mS0u9ZYdQ=;
        b=m8J+bZiVHFkf0uCmdy9hvThTxphkI0Utu2Gwb79FA9vfCPwtSp7xp/jYmp23ycksh2
         da14NVPgg953VOoiiTggmrltxW4zR3dcr/JyOeS0m5/IvTvcWZTWC6YQ/LVXDJzTdHB6
         XjbB/ieRtHJcNSwCb2NgpizCwzKPvFXELb/wBqdWZFc8VIfkwVedWOybEzd5P3Rk+xBJ
         JFjfwwmzwRxXFWIRa6pO+F5bzfIGCjLFFC6c1P/xTjoeIMaRSCPZ4WvlvaM2jCqw0SPf
         FqUQpiae+Hd1tLctwuUSklkXm7E3sTjX34NTm91nmndhIesLLeXkDOe8wAoi8ZasQi/1
         Ckyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686307342; x=1688899342;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lot98Cc3sqdz25vnOABojTEsU9LUeVox91mS0u9ZYdQ=;
        b=W6ksPGs8hyeqInGcDiQ/ek2875utVFLh8JDwUKA0qQ+zZeT4iA1TEIpARW3JFP8qGR
         FAeJcxuPAqfW5JXUNKAUliFNKcvS7P3Piffnj5nb4BM7V+QMDEb8yzvb7Kp5lSSXW+lo
         OXB0ybLxsZvBLI7qPlY0PBw/t/l9QNI1U+EbdY9U4/FsKWwQExa7/XSQgzhXTsSoioIF
         j6f+DB215byjSPspfIC7m7K4mbD3gGjf92/Q1trpap29d4eBZGSFBNdazpAwaX6us6cH
         116JpnQ7YMOjPynfvhzU2FdvguzesVmw1qyTFDwt2PTlcwmNQxLCYR/WX2LTxZnI/hLp
         Y0kQ==
X-Gm-Message-State: AC+VfDw/MbIRZHCrWBs4ojHTlakcNSaOGfQ9FUM7zeGNmFVqi1GWNpF4
	GYpFfugh+7MCrMUMZpfrbP4=
X-Google-Smtp-Source: ACHHUZ7DEmMn1nNDmk7+VbQTLCC+jnRbbP6ngZV4cZ8cK06LpaTU5URQ3+KVeVIJcP6od7OFQu4nLQ==
X-Received: by 2002:a05:600c:5191:b0:3f6:487:f058 with SMTP id fa17-20020a05600c519100b003f60487f058mr975912wmb.1.1686307341828;
        Fri, 09 Jun 2023 03:42:21 -0700 (PDT)
Received: from smtpclient.apple (212-39-89-143.ip.btc-net.bg. [212.39.89.143])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0acc00b003f195d540d9sm2277985wmr.14.2023.06.09.03.42.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Jun 2023 03:42:21 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net-next v4 1/4] usbnet: ipheth: fix risk of NULL pointer
 deallocation
From: George Valkov <gvalkov@gmail.com>
In-Reply-To: <168630302068.8448.16788889957368567496.git-patchwork-notify@kernel.org>
Date: Fri, 9 Jun 2023 13:42:09 +0300
Cc: Foster Snowhill <forst@pen.gy>,
 Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 patchwork-bot+netdevbpf@kernel.org,
 Simon Horman <simon.horman@corigine.com>,
 Jan Kiszka <jan.kiszka@siemens.com>,
 linux-usb <linux-usb@vger.kernel.org>,
 Linux Netdev List <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <07CBE5ED-2569-450D-975A-64B5670D6928@gmail.com>
References: <20230607135702.32679-1-forst@pen.gy>
 <168630302068.8448.16788889957368567496.git-patchwork-notify@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thank you David!

Can you please also backport the patch-series to Linux kernel 5.15, =
which is in use by the OpenWRT project! The patches apply cleanly.

Cheers!

Georgi Valkov
httpstorm.com
nano RTOS



> On 9 Jun 2023, at 12:30 PM, patchwork-bot+netdevbpf@kernel.org wrote:
>=20
> Hello:
>=20
> This series was applied to netdev/net-next.git (main)
> by David S. Miller <davem@davemloft.net>:
>=20
> On Wed,  7 Jun 2023 15:56:59 +0200 you wrote:
>> From: Georgi Valkov <gvalkov@gmail.com>
>>=20
>> The cleanup precedure in ipheth_probe will attempt to free a
>> NULL pointer in dev->ctrl_buf if the memory allocation for
>> this buffer is not successful. While kfree ignores NULL pointers,
>> and the existing code is safe, it is a better design to rearrange
>> the goto labels and avoid this.
>>=20
>> [...]
>=20
> Here is the summary with links:
>  - [net-next,v4,1/4] usbnet: ipheth: fix risk of NULL pointer =
deallocation
>    https://git.kernel.org/netdev/net-next/c/2203718c2f59
>  - [net-next,v4,2/4] usbnet: ipheth: transmit URBs without trailing =
padding
>    https://git.kernel.org/netdev/net-next/c/3e65efcca87a
>  - [net-next,v4,3/4] usbnet: ipheth: add CDC NCM support
>    https://git.kernel.org/netdev/net-next/c/a2d274c62e44
>  - [net-next,v4,4/4] usbnet: ipheth: update Kconfig description
>    https://git.kernel.org/netdev/net-next/c/0c6e9d32ef0c
>=20
> You are awesome, thank you!
> --=20
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
>=20
>=20


