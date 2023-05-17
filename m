Return-Path: <netdev+bounces-3378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 86C7C706BF0
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:00:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43440281618
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:00:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A77524E;
	Wed, 17 May 2023 14:59:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5CD28FC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:59:58 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A17ED2C1
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:59:29 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f38824a025so197591cf.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684335565; x=1686927565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V7eC4rbCEh7MnRzusdaAsYfzrMc+DFDyN1QmOgTu4qw=;
        b=woId0PR10Taj+v86zKjlPqIZhkEq3AU+S8vTejRbVjldvPsvoQ9md9XWB2twODpk2H
         qkRQXEetcJ1c15mfBsO7DjItM8SE4Gka6M03peNr+lksctxd8mtRRc4mgssSX4+ga8Lo
         aYxYNDOvCVlBG85PWb7l3JjdRAJ0zvtizxh9zT9wzDUyjU75zbK80n3PWpQsjgdiUMth
         M7fm2eI/xhD5NKGUu+MvSXvOkMe7bl/b5UViWuOpwd0Sfpizrs+Z2ykSLcdfCiQCk9CM
         unDTOjF+W615+ANXEAgH0VEk+r3hgSmjowYYJ5ppyKOLnbOdgCjurabioMfGaGt4uLzp
         RPbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335565; x=1686927565;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V7eC4rbCEh7MnRzusdaAsYfzrMc+DFDyN1QmOgTu4qw=;
        b=hV7hugIYUh4yAxiWQ/99rJAAFCOGpKqe6SrXdw0FMB0mlljkeUrAS43w/A+Ra8+L2x
         ka8WEPi0rnl74eFKYeTZePlE97ERtYjCall0rQN3Ejot4AfUuHXx2CWsf330vszEsRDz
         fJYUmq7cI3eG+iPKxTxPtIzJoHS2AFALe0u1yxFQjAqKPoh79/eeAIvqKVbi0mI01Xao
         dqSOePZOosWhtECRfoKaXI2dQWoDtFk73/koO4LegLJq5oL3rsy10L1fb9khtH6ZgneH
         f5bJemkMsr0qrjHQxa8pRSWSsQ0d2UZ6gqMOD1QLvnDEA8c0PfS7oAEAdNcVRzZ+lsDb
         8uMw==
X-Gm-Message-State: AC+VfDzK1MSatGGvX3of1fshyiPPxlzfUYcqPTa18Rww3F7/sA/ubN3B
	FR7DVybSNTpfdZpA1dvDdaRMzW9KK1nV8iXSUYq5gw==
X-Google-Smtp-Source: ACHHUZ7/IZhEBnwPwpBnJBqWWoLHje8AK0Q2efknp9MjYDu6oAIe9U5HlXh+ej8TSpay90t0iD7437S+2NMQDBz1S6c=
X-Received: by 2002:ac8:7f14:0:b0:3f5:4eb4:414f with SMTP id
 f20-20020ac87f14000000b003f54eb4414fmr240353qtk.13.1684335565464; Wed, 17 May
 2023 07:59:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517143010.3596250-1-ap420073@gmail.com>
In-Reply-To: <20230517143010.3596250-1-ap420073@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 May 2023 16:59:14 +0200
Message-ID: <CANn89iL9u9fABLD2+XJdrWbNdAHJN-JNsCAy=86sQ9CMj9CLnw@mail.gmail.com>
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Taehee Yoo <ap420073@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, jiri@resnulli.us, 
	j.vosburgh@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org, 
	jarod@redhat.com, razor@blackwall.org, simon.horman@corigine.com, 
	wangyufen@huawei.com, syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 4:30=E2=80=AFPM Taehee Yoo <ap420073@gmail.com> wro=
te:
>
> When the virtual interface's feature is updated, it synchronizes the
> updated feature for its own lower interface.
> This propagation logic should be worked as the iteration, not recursively=
.
> But it works recursively due to the netdev notification unexpectedly.
> This problem occurs when it disables LRO only for the team and bonding
> interface type.
>
>        team0
>          |
>   +------+------+-----+-----+
>   |      |      |     |     |
> team1  team2  team3  ...  team200
>
> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
> event to its own lower interfaces(team1 ~ team200).
> It is worked by netdev_sync_lower_features().
> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
> work iteratively.
> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
> interface too.
> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for its own
> lower interfaces again.
> lower and upper interfaces receive this event and generate this
> event again and again.
> So, the stack overflow occurs.
>
> But it is not the infinite loop issue.
> Because the netdev_sync_lower_features() updates features before
> generating the NETDEV_FEAT_CHANGE event.
> Already synchronized lower interfaces skip notification logic.
> So, it is just the problem that iteration logic is changed to the
> recursive unexpectedly due to the notification mechanism.
>
> Reproducer:
>
> ip link add team0 type team
> ethtool -K team0 lro on
> for i in {1..200}
> do
>         ip link add team$i master team0 type team
>         ethtool -K team$i lro on
> done
>
> ethtool -K team0 lro off
>
> In order to fix it, the notifier_ctx member of bonding/team is introduced=
.
>
> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev feat=
ures down stack")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

