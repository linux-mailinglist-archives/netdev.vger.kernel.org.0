Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AC16A4BA8
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbjB0Twt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230398AbjB0Twm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:52:42 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5808428875
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:52:12 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-536c02eea4dso208186867b3.4
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:52:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uokiycn85AjDpsYLuBMvaoyfBWnlLO7a+lqRCP62R1E=;
        b=byKKDZXgTSJxYLcqnSlUiilcbPARxTJZpXXAZgoMrBGekVxtY+Et4aU163X6kdgrgV
         ILxVzsICCCEXFvL3J8tZzZNT0ooMctJQaAYa9ms4gZ1LKtgYXjQ81Yo45Efes3aTBxxi
         ZCugrvuWK3jVF7SfXFkzHYbHXeJRzQVKLocA3D0lNVD7DEVbTpH8kjN6mug00FeyIK3X
         Fb4k8UCLUUETRKmP1dLv2XciF3dcSuPhsXHjDKVTWWUe3he2+HGOKeGhseSomhKD5Ft2
         uqfNSpIDHxeFgDCrTP4ibacT0CwuqwLtBX7mOaVMl9emL5cpgAbMSCKAYzloXteBcOsT
         TxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uokiycn85AjDpsYLuBMvaoyfBWnlLO7a+lqRCP62R1E=;
        b=PW9YNiQIpRhgI7KeDAqCq0KBuywh9sPUqQSpmHdwJoDI1pl+Wm0GeYwebafgxnsErm
         Mb8N/oLF+KwOYt1+2jVR69C1dTBQrsyAZcK7coLt46WPy1eOwRZjiYYWOe11nXaNGX2I
         Jm/qDajA+mAIcwN9NJCvsjlajsgqzfgL6jG+8lZxW3ngrZcvlfI9HXzYdpq8NcpWzPOJ
         REmym4mhNp0MUIZ16pCOWjIYC7iU2rqqSmzbT+9LdESlfsnDm+DLuWSVSHi2xIFeE2lM
         RsGJBPHiHo87GuK1xcq3ue1TAYQuQK8G3MEhLWzlypq3gMxV0UC94GSjX+Pdrq7g9+VS
         04HQ==
X-Gm-Message-State: AO0yUKUBbfuHccrSFBt5+k7TFtIR3/M3vz0AurG2/IPjYecDpJILbojo
        6PDHwHJINAsIXufDuUPrS/PMKZ7MtCmWRyvNkYIriQ==
X-Google-Smtp-Source: AK7set+rlxBdto30cojyziLIb1QIlfU+GjTx8fBHOIbosNDQdrCmBr1ej0mi4OIDg3aFpFpbjD89r4MY+NYj/tDQdpo=
X-Received: by 2002:a05:690c:609:b0:52e:b74b:1b93 with SMTP id
 bq9-20020a05690c060900b0052eb74b1b93mr668868ywb.0.1677527530073; Mon, 27 Feb
 2023 11:52:10 -0800 (PST)
MIME-Version: 1.0
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-2-pctammela@mojatatu.com> <Y/oIWNU5ryYmPPO1@corigine.com>
 <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com> <Y/o0BDsoepfkakiG@corigine.com>
 <20230227113641.574dd3bf@kernel.org>
In-Reply-To: <20230227113641.574dd3bf@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 27 Feb 2023 14:51:58 -0500
Message-ID: <CAM0EoMmx7As2RL4hnuH8ja_B7Dpx86DWL3JmPQKjB+2B+XYQww@mail.gmail.com>
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Simon Horman <simon.horman@corigine.com>,
        Pedro Tammela <pctammela@mojatatu.com>, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com, ozsh@nvidia.com,
        paulb@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 2:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sat, 25 Feb 2023 17:15:00 +0100 Simon Horman wrote:
> > > > OTOH, perhaps it's a regression wrt the oldest of
> > > > the two patches references below.
> > >
> > > ...because filters and actions are completely separate TC objects.
> > > There shouldn't be actions that can be created independently but can't be
> > > really used.
> >
> > I agree that shouldn't be the case.
> > For me that doesn't make it a bug, but I don't feel strongly about it.
>
> I'm with Simon - this is a long standing problem, and we weren't getting
> any user complaints about this. So I also prefer to route this via
> net-next, without the Fixes tags.

At minimum the pedit is a fix.
The rest is toss-a-coin and put in net-next or net.

cheers,
jamal
