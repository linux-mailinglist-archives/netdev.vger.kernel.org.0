Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 165A325D05
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 06:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfEVEt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 00:49:26 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:42546 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfEVEtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 00:49:25 -0400
Received: by mail-yw1-f66.google.com with SMTP id s5so338572ywd.9
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 21:49:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RorBcV75iGwdZaCEuCNXHKglp0kbA8wKW2JhJoCiuT8=;
        b=lY+Duy28arF1QXcXG/2dWAyanN/T9chB+9S6g7DE7Jq4Bb8vStxF98Tg0a1O3e832g
         kkWElbF0g6hyvlsUloOXIT7YFnMrz9BWiWAJEwKnYm5rOQbfxpU8nBx+/XUeBxD9HAou
         To7qNy6g8OLnHcN4k6toky7PR6vqet2CvsTnbX3BFunJRkrRvplkwUqG89d41NBP0LYq
         UPv6pqzGsvZomsxtTVnEw91UVLkpSmYyvPHXqhChYzca5vsBjBaLbaCxTJrDbtLUAjYu
         aoTQENQAJTXatSXqfOSTL05H6yV8wymK62ZRdXx6HTbLtkFyyGQW2KWtlqXP/inXcG1K
         VILg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RorBcV75iGwdZaCEuCNXHKglp0kbA8wKW2JhJoCiuT8=;
        b=ZEK8B97kGXhwB9HsdwOv69rdejPfHQkq0n9ADSadWfJCsPcoj+XsCrUv3b3QlRJ+DG
         uh3gI25lY9G2cSYrQPLgNqqYFyzMd8jvOauzfca49l8ILSJJaa7zs9/fB2cJHPTUM5Jn
         OdQ2Sp0CBqDjeSyW4utSoVVNt9t5768KPzfdKwIQ6TpMH7Zsy9VFZCPWTHeq9STswZmd
         UrAAzXxy78Kh5Rt6Q1pWknuSQUa3I3KoLc5vlyM+pQXvrhINHsh6SaUUKBxAiY7hkAcM
         /Ma+39heVFFq7uza9Rpk5YhyfWKV29Rlsrf3I1oZA2Nj98L5iZXfKlhNeY/SB9L1MY+Q
         uxOA==
X-Gm-Message-State: APjAAAWbMw3cHrV/vNTaKwFx91ChNI89J/zkQFsNRLg1oSKpBL7FL4dj
        Qx7Tvc4EQNH782q4msO19dw5diqAg86bjEH5TBE=
X-Google-Smtp-Source: APXvYqyeuRLeY2OTOZ4A1wCOFJKeWdH63wklP3FUAjoR6URxk1W1+coBpcu7FzKTe4TrajkwZMF7jFWOvhJg38XNtp0=
X-Received: by 2002:a0d:c106:: with SMTP id c6mr15375557ywd.510.1558500564914;
 Tue, 21 May 2019 21:49:24 -0700 (PDT)
MIME-Version: 1.0
References: <1558140881-91716-1-git-send-email-xiangxia.m.yue@gmail.com>
 <CAJ3xEMhAEMBBW=s_iWA=qD23w8q4PWzWT-QowGBNtCJJzHUysA@mail.gmail.com>
 <CAMDZJNV6S5Wk5jsS5DiHMYGywU2df0Lyey9QYzcdwGZDJbjSeg@mail.gmail.com>
 <CAJ3xEMgc6j=+AxRUwdYOT6_cP69fY-ThVVbF+4EqtZGQ+-Sjnw@mail.gmail.com> <CAMDZJNU=8BHZJs95knTzuCv=7X3BXbqHrZAznOOcK2m_7QO2Pw@mail.gmail.com>
In-Reply-To: <CAMDZJNU=8BHZJs95knTzuCv=7X3BXbqHrZAznOOcK2m_7QO2Pw@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Wed, 22 May 2019 07:49:13 +0300
Message-ID: <CAJ3xEMj43wFacxR1bfqG8B0yVPiPyCh=DT5S3TojV8S8ZHaDsA@mail.gmail.com>
Subject: Re: [PATCH] net/mlx5e: Allow removing representors netdev to other namespace
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 22, 2019 at 4:26 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:

> I review the reps of netronome nfp codes,  nfp does't set the
> NETIF_F_NETNS_LOCAL to netdev->features.
> And I changed the OFED codes which used for our product environment,
> and then send this patch to upstream.

The real question here is if we can provide the required separation when
vport rep netdevs are put into different name-spaces -- this needs deeper
thinking. Technically you can do that with this one liner patch but we have
to see if/what assumptions could be broken as of that.
