Return-Path: <netdev+bounces-11155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC9D5731C68
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:25:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CF3E1C20EEA
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:25:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E71D915AE7;
	Thu, 15 Jun 2023 15:25:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDD5A20F5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 15:25:01 +0000 (UTC)
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 521F92688
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:25:00 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id e9e14a558f8ab-33d928a268eso250405ab.0
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686842699; x=1689434699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQkq5jMZ85kJho8z38Z7AGLtmMukGJR8u1F0qDCqvC0=;
        b=2W6VH2QkNnshu2yZFkM0c738QQJZdMGtN41g/6uyCQZRKfCFfGXWqtGz12jvGnZySX
         I0xofmMnlLI+H3rvVBggHEKUcRsTx9FxMqXHJsu7dHwAesbsnq0uYvr6sfwidaV2LH9u
         gWhVoYPL9mPr+1lPfCQb4HijvuvjG1Fi9XPjidPAVur0shEGrHCu8SR0fa+sEli3SSed
         +r5qoEDtwFyNL4Lq8dPzoBAvQ/7eFemrmYscsnHcf9QLrg0MLj66BeKe7rkJuhc4Bfmu
         36CSJLiVnBec+hJE2TQAnkT8dkOwYWZtSdfc12RaWJF1kRQJtEm4ijD2xTbbe3Sy5B7Y
         uPhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686842699; x=1689434699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQkq5jMZ85kJho8z38Z7AGLtmMukGJR8u1F0qDCqvC0=;
        b=XGeLYx5jkMsmil4XLgiOYP7c/PiggcQs5N5GkyJqppqXI/zPiwRfBAyE5/mgz4AwKX
         0e1NFO99DOIa4kTFpNejAH0UZg0egGfUjNQZ3PBknmRXlOWbj3OXoyTs6DPBVZvwbhQG
         Dx/pS5byXgsdrtK0cTM7uOz7W2AZlgHNt3yjdl5d+LAMUbQ4JGIB83kNtxCPeiEvwLbc
         lOBLg9VZbiUuv3uLvbcgzamZVSYq3RFi7DZUVXnIxh9SFR+kxx6GyXvVrDxtbQ9RB2S+
         gWGRvmqIUmrPHOUdQyNZqm4YYoGFGOuf60hJC528KQal9LFhLFvHnEUbTjHP7//m140O
         AZow==
X-Gm-Message-State: AC+VfDxNwuVCcLOQaZrV9O9mPpw1qy9Tw9Wal1y6YXyq18SGRShdi2zG
	3S1np4RARRowEyGFOtVogLKBWkMlfXRQVlGzddlbtw==
X-Google-Smtp-Source: ACHHUZ6jnCuB74Qn373OZTIDEjjyIKl+cD3dOo0vgtBYjSA6GmEGm+ChQ14YNVVWzcvBDpDyvrxKGE6RsKlggyovFb8=
X-Received: by 2002:a05:6e02:1d0e:b0:338:1993:1194 with SMTP id
 i14-20020a056e021d0e00b0033819931194mr170683ila.2.1686842699468; Thu, 15 Jun
 2023 08:24:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230606064306.9192-1-duanmuquan@baidu.com> <CANn89iKwzEtNWME+1Xb57DcT=xpWaBf59hRT4dYrw-jsTdqeLA@mail.gmail.com>
 <DFBEBE81-34A5-4394-9C5B-1A849A6415F1@baidu.com> <CANn89iLm=UeSLBVjACnqyaLo7oMTrY7Ok8RXP9oGDHVwe8LVng@mail.gmail.com>
 <D8D0327E-CEF0-4DFC-83AB-BC20EE3DFCDE@baidu.com> <CANn89iKXttFLj4WCVjWNeograv=LHta4erhtqm=fpfiEWscJCA@mail.gmail.com>
 <8C32A1F5-1160-4863-9201-CF9346290115@baidu.com> <CANn89i+JBhj+g564rfVd9gK7OH48v3N+Ln0vAgJehM5xJh32-g@mail.gmail.com>
 <7FD2F3ED-A3B5-40EF-A505-E7A642D73208@baidu.com> <CANn89iJ5kHmksR=nGSMVjacuV0uqu5Hs0g1s343gvAM9Yf=+Bg@mail.gmail.com>
 <FD0FE67D-378D-4DDE-BB35-6FFDE2AD3AA5@baidu.com>
In-Reply-To: <FD0FE67D-378D-4DDE-BB35-6FFDE2AD3AA5@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 15 Jun 2023 17:24:48 +0200
Message-ID: <CANn89iK1yo6R4kZneD_1OZYocQCWp1sxviYzjJ+BBn4HeFSNhw@mail.gmail.com>
Subject: Re: [PATCH v2] tcp: fix connection reset due to tw hashdance race.
To: "Duan,Muquan" <duanmuquan@baidu.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org" <dsahern@kernel.org>, 
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 15, 2023 at 2:14=E2=80=AFPM Duan,Muquan <duanmuquan@baidu.com> =
wrote:
>
> Hi, Eric,
>
> Could you please help check whether the following method makes sense, and
> any side effect? Thanks!
>
> If  do the tw hashdance in real TCP_TIME_WAIT state with substate
> TCP_TIME_WAIT, instead of in substate TCP_FIN_WAIT2, the connection
> refused issue will not occur. The race of the lookup process for the
> new SYN segment and the tw hashdance can come to the following
> results:
> 1) get tw sock, SYN segment will be accepted via TCP_TW_SYN.
> 2) fail to get tw sock and original sock, get a listener sock,
>    SYN segment will be accepted by listener sock.
> 3) get original sock, SYN segment can be discarded in further
> process after the sock is destroyed, in this case the peer will
> retransmit the SYN segment. This is a very rare case, seems no need to
> add lock for it.
>

You speak of SYN packet, while the original patch was all about FIN.

> I tested this modification in my reproducing environment,
> the connection reset issue did not occur and no performance impact
> observed.The side effect I currently can think out is that the original
> sock will live a little longer and hold some resources longer.
> The new patch is a temporary version which has a sysctl
> switch for comparing the 2 methods, and some modifications
> for statistics of the states not included.

So you are suggesting adding another hack/workaround for SYN packets,
on top of the other one ? What will follow next ?

Again, a correct fix needs to expand the scope of the ehash bucket lock.

I will handle this when time permits.

