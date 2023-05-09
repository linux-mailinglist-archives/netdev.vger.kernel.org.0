Return-Path: <netdev+bounces-1213-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 862286FCAD1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 18:10:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 696E31C20C08
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B1481801F;
	Tue,  9 May 2023 16:10:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA3D7499
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 16:10:26 +0000 (UTC)
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70284C1C
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:10:05 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id d75a77b69052e-3f396606ab0so228981cf.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 09:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683648602; x=1686240602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=054gJFj18y9E5NHnUst30bbm3PQm/ns3W+RPSXlvtZM=;
        b=FeyJSto0eE1PW0zKt+JH2brPNMpgwF9ERJtxTo4A+lAjD1oNYOqOUWAiXdiuC4vUoK
         yYi8ZhCTvz3SG4FGMPuw3RRq5NJGNEeVdXXuggcvpXO4/LBardBfE5kS89dALJpVCpIo
         Ir0Ek2UuCCDbsICvBiSHNs9UlJ5HRoljbiIOLCAmgQSSk5OHi9gRVgh/HfMVyyCYz7rI
         Pr22DNiatqevl8xq5optxjhuQvQiEyqJ5CgrIDyRW/JSxgBl4qH6U2+GffrqzGjiBguS
         s8HqCC65JeYfj2ejdPo3RstWVvHJzyCeCV7jW5reMGX8xjySgL6UVakoJhOSulZvuODm
         0Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683648602; x=1686240602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=054gJFj18y9E5NHnUst30bbm3PQm/ns3W+RPSXlvtZM=;
        b=RaFwVM773KjtOKgWeZz7nCs/hbN2l6/DLRK4pPO9BlXTxAczqhhnAxz45f48wefcRi
         PCs1UB4stZr2Yrt4l/PpWurL3umHioKUtbJt1brify9BNjiyjFXCcwXHk9kX4m1S/0+X
         UakeUOtKU9v6+BHk/PiwaYAmpgH/JQfoZ5ARzQ9zlhSQ4+qXWecK+X7TSWn0BstDOQKr
         Kk52V0F01Pj3iVjI8jRVqVYzvG9iFgYq+3PYOWD7F56tn+uNbXt2jmz1ag2RnT2MrOZS
         9ZO/oEqEKdJhepOYrWgFELDvOjDTSYn7EnZ/jZ96jCjo3TDJmET11q6Pd7Rwfoxfe8z7
         49GQ==
X-Gm-Message-State: AC+VfDxnpScg7XFdpl8tIG5OFL8c38Sf7aMJC7VgRWP8BhzskCv4lvId
	G2oFUuJzHU/4YX8rsQVXYzyo0VWIikL2dGhIDNtK1w==
X-Google-Smtp-Source: ACHHUZ7Js3saEMZDJR4cRznuKzrKfr6n52KBV+AV0kCsx3edMnIueD8bXVMMoId0w2UCa8rZeMO+I/5BZGr0nURAiHE=
X-Received: by 2002:a05:622a:5ca:b0:3ef:1c85:5b5e with SMTP id
 d10-20020a05622a05ca00b003ef1c855b5emr284466qtb.19.1683648602215; Tue, 09 May
 2023 09:10:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
In-Reply-To: <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
From: Shakeel Butt <shakeelb@google.com>
Date: Tue, 9 May 2023 09:09:50 -0700
Message-ID: <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
To: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, 
	Cgroups <cgroups@vger.kernel.org>
Cc: "Zhang, Cathy" <cathy.zhang@intel.com>, Paolo Abeni <pabeni@redhat.com>, 
	"davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, 
	"Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>, 
	"Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, 
	"eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+linux-mm & cgroup

Thread: https://lore.kernel.org/all/20230508020801.10702-1-cathy.zhang@inte=
l.com/

On Tue, May 9, 2023 at 8:43=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
[...]
> Some mm experts should chime in, this is not a networking issue.

Most of the MM folks are busy in LSFMM this week. I will take a look
at this soon.

