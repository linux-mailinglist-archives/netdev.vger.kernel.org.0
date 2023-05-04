Return-Path: <netdev+bounces-273-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BA7636F6A87
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:55:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A85871C210FD
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 11:55:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29F010EC;
	Thu,  4 May 2023 11:55:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D563D1876
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:55:32 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B671994;
	Thu,  4 May 2023 04:55:30 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94f1d0d2e03so62053766b.0;
        Thu, 04 May 2023 04:55:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683201329; x=1685793329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEOKwlwL1tkxEiR+ZdLCkG8rCyDeDRTeVbJGwPAXSGE=;
        b=Rx1PxkEUSZX2Gwh18KtwSk/5C3dFrgX+H2AaM8bftpCHHttp6xvlf0Sp8WZOExZqdG
         gwnypz9DeKJMlnrBp7XMThdEgw1wHlr8EygBPLkdB6OCXakp1aRlphjih3t8jpI51o5h
         yTtRbCoUBunmy8cVUU4/Tuq+FJ+TwsPfAG7nKr5vt0HLtgRT6tqLnF0MFndEIr5L66fw
         0suNDQ5uLyhLsyq6o7j7/e9xpvIfW7mBlZOWGd0pnnDTMJXnwLx/3U/rP88yjBVo203h
         +tgs0kKHVpwDi7C6tCbafSBxP4PLrQ6VuXjVYGYiCK9aMmccOeVSO2dUqs9d98GFfjOB
         puaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683201329; x=1685793329;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yEOKwlwL1tkxEiR+ZdLCkG8rCyDeDRTeVbJGwPAXSGE=;
        b=mFqE3wR8i+7mnIs6zZCEdc3vwkbb+xBQynVpPm5EMG1rVKhZh1ccorZTQsp+LaSD6x
         s0QX8eODor42T/on/zZSMeIxZbOp1ospPWFEnyuvMl7koc10lJ1yVwkE7gZaHvySPqHp
         rW+d52zK8nW8q1FEEU9tCUkntPTDJXQIYVsVgzzxDtr+VOrDe7soK6hh+zCJAP8VGuD9
         HhpPmCMBVMA6mpoQcbwvRgETEmBFoYHny6GzMlqS+ZUk0syG+Ch1pqmjjDXbBSGd6PDp
         fcxlUR5tBj9FvOJTZ2SzYCJa07dOJoeyjeIVSt7kBkxxAGDxPcSmG7lEAUHH1cRFhC93
         tUbQ==
X-Gm-Message-State: AC+VfDwF1rRl4a+9KSBQCAqm9MFyoXB2iUzW85Rz/TTSg7irDIA0UA1o
	wJrcF7dmqvKVGb6j1a4nf+fbnc1bXDHbn4yd3HE=
X-Google-Smtp-Source: ACHHUZ66jegOa5ttR5HXWcc2L930eGU8hxtxNvfRUtILZHde78W74TppXdoANsNB+Ml/w7UwAF+nsq6hfEdAKFwvr8g=
X-Received: by 2002:a17:907:805:b0:94b:d57e:9d4e with SMTP id
 wv5-20020a170907080500b0094bd57e9d4emr6665740ejb.3.1683201329031; Thu, 04 May
 2023 04:55:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230503141123.23290-1-jandryuk@gmail.com> <4317357.pJ3umoczA4@silver>
In-Reply-To: <4317357.pJ3umoczA4@silver>
From: Jason Andryuk <jandryuk@gmail.com>
Date: Thu, 4 May 2023 07:55:17 -0400
Message-ID: <CAKf6xpscky_LLxStzZ6uAyeWPXC3gALsA_zVFpF8X7uktw=MxQ@mail.gmail.com>
Subject: Re: [PATCH v2] 9p: Remove INET dependency
To: Christian Schoenebeck <linux_oss@crudebyte.com>
Cc: Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	v9fs@lists.linux.dev, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 6:58=E2=80=AFAM Christian Schoenebeck
<linux_oss@crudebyte.com> wrote:
>
> On Wednesday, May 3, 2023 4:11:20 PM CEST Jason Andryuk wrote:
> > 9pfs can run over assorted transports, so it doesn't have an INET
> > dependency.  Drop it and remove the includes of linux/inet.h.
> >
> > NET_9P_FD/trans_fd.o builds without INET or UNIX and is unusable over
>
> s/unusable/usable/ ?

Whoops!  Yes, you are correct.  Thanks for catching that.

Regards,
Jason

