Return-Path: <netdev+bounces-12146-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E89873668B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4159B1C2042B
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260F7AD56;
	Tue, 20 Jun 2023 08:44:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191BC848A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:44:22 +0000 (UTC)
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE881E71
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:44:20 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id d75a77b69052e-3f9d619103dso513721cf.1
        for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 01:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687250660; x=1689842660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jpS2988X6yNaKctvWlZlRA1+efu91k0WuueI7vggz0g=;
        b=F0UvonubafLgJLPjlzCxpv7lCVS+oKnCBCiXHBcIL7dJx5KdEGluI6l9WZ1IpinG3z
         pjhH0Gelzx48XJykVo0PwJQA+o5DADMm6yNX+oLAAmcfq4zJoZdgLMgCqDKYvSvwK4gQ
         qEq1rvdelIkJYHgYM/4/qy6DPeWWliYii/QlGwRUVAtIyhpigS1uD5ZtCB6Bw3vbCO6E
         Ng/zzKqB8IZJIXvPw2FcdkoaVtc4qgpfmwzrKgfftk86Fk4AT6YnRLuj/FYFXLFHj/LC
         1w97CJl0DTQgGwlNBeOaq1X6bxQLWi1WZBOLRJ+mKRe8Y6rIlCxvDGHZhp2W9yxy2Myr
         aXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687250660; x=1689842660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jpS2988X6yNaKctvWlZlRA1+efu91k0WuueI7vggz0g=;
        b=jTWTzv693+lDaCt3ewDyPFi4O+aESTND1zpLzSxeqHrXYNDCq0RoPxloVnBmZXzqN2
         HIET4PB0rRuWfp1t+Ofl977A7M0/UBlvAe8JCLA6wF+P9SzImYgcQg6U0GGC+u6Nbdgm
         /1mrzLqMkv6cfS6Fj4hckr5MdKfHarnDshapkrTK0UeY47YfqB8kKWMvNAA8+RpW6942
         1i1/895PK/YH7jtG/yYFisCoKlV8X8pVbyK2mP/izOX3tSuW1yEMLSnJQEXxt6+eetJ/
         sGOK3JCV5XW99oZxYXFjjsWihByGjL67A0XmoA82JeqFcoajLHsBKmiRipcVu5mw5BS0
         2drA==
X-Gm-Message-State: AC+VfDzw/PHiUzF5WRL96ZynE/8952yssjxYJZqpauy63zeijLBy2i+A
	7eFC5LlblHAy3g+xbh3PMj4LiIEWxutC5STOPYkHww==
X-Google-Smtp-Source: ACHHUZ5X4hbqTTd5rxInDCE3wqVdi7khZp+ucTSv4dh6lH0cnI61klfIyLTAHAfugtn+MJOxThi7sJQNOjEzgx63MKE=
X-Received: by 2002:a05:622a:13d4:b0:3de:1aaa:42f5 with SMTP id
 p20-20020a05622a13d400b003de1aaa42f5mr1221369qtk.15.1687250659753; Tue, 20
 Jun 2023 01:44:19 -0700 (PDT)
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
 <FD0FE67D-378D-4DDE-BB35-6FFDE2AD3AA5@baidu.com> <CANn89iK1yo6R4kZneD_1OZYocQCWp1sxviYzjJ+BBn4HeFSNhw@mail.gmail.com>
 <AF8804B1-D096-4B80-9A1F-37FA03B04123@baidu.com>
In-Reply-To: <AF8804B1-D096-4B80-9A1F-37FA03B04123@baidu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 20 Jun 2023 10:44:08 +0200
Message-ID: <CANn89i+fNWbRLYx7gvF7q_AGdQOhRxgFnwMqnpZK91kkEEg=Uw@mail.gmail.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 20, 2023 at 5:30=E2=80=AFAM Duan,Muquan <duanmuquan@baidu.com> =
wrote:
>
> Hi, Eric,
>
> Thanks for your comments!
>
> Why not speak of the FIN:
> For current implementation, hashdance can be done on state FIN_WAIT2,  it=
 may race with the ehash lookup process of  passive closer=E2=80=99s FIN. M=
y new patch 3 does the tw hashdance until receiving passive closer's FIN(re=
al TIME_WAIT),  so this race does not exist and  the 'connection refused' i=
ssue will not occur, so I did not speak of the FIN again with the new patch=
.
>
shdance begins, the FIN may be dropped in further process if the sock
is destroyed on another CPU after hashdance.
>
> I took a look at FreeBSD, it uses hash table lock and per sock level lock=
.It also needs some tricks to retry for some cases, for example, sock dropp=
ed by another thread when waiting for per sock lock during the lookup:
>    /*
>      * While waiting for inp lock during the lookup, another thread
>      * can have dropped the inpcb, in which case we need to loop back
>      * and try to find a new inpcb to deliver to.
>      */
>     if (inp->inp_flags & INP_DROPPED) {
>         INP_WUNLOCK(inp);
>         inp =3D NULL;
>         goto findpcb;
> }
>

This is the last time you bring FreeBSD code here.

We do not copy FreeBSD code for obvious reasons.
I never looked at FreeBSD code and never will.

Stop this, please, or I will ignore your future emails.

