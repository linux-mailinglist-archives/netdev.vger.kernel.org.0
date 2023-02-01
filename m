Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8314D686C1F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbjBAQwJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjBAQwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:52:07 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ECD561D58
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:52:00 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id 143so12928248pgg.6
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 08:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xm0nVrTiE2LwH6HdNccgqBbifUQn+UCt78Fv+efTCn4=;
        b=ObfyWmejm1HzZPB+QeACGcpOACEQgda9guHF+ZV5lEjWxEAO0jEHVo+/JoZbcG6Cnf
         yUBakjbT6aYEAy0H7fDiRXwmY9IY3bHQCrFIiGFhAu4QvwZQ7pYDf+s1uOLOkp73KSmB
         8XNvI0Pev6wIB7ei0DXXf6jDIw86WsfFf/DkCTIPABNnSxB6eh8KeiRXcQ3rr+NRYwlN
         ErhTyuKF5FqDfl4hBFWD95JnNy2nhs6NRRXhB4lBVHETWAe9+I/0SLDXjeUEPAq9mHoq
         g3byO1UGFqOlDdX8/PDuS4taTpR6ngepdWSzLjMnsJ9nEh1Se5CNjL2hmCx/g56vMiR9
         gAIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xm0nVrTiE2LwH6HdNccgqBbifUQn+UCt78Fv+efTCn4=;
        b=KTE/ft3FtcSLp0cdJqs9ICHNhNV9WN00XQjPQn5jI3vICrvzHmVG7C9/JFWBWA2PM+
         6SqA842v88BtQUxS4MWNxnsWIiWsWo5Kmu3R8GXCZCMVMo1mAiOmeFPebZRt8WZdbpb4
         RsvJvsx0jv16DRjLTzcCYsAMIOgBtBJhEd8dJeJgghS86FBg3lEouXwqemltz8RM277B
         WVMqP3jMaBB+Yl+jVOJ11QEJqNsA6aGg9F9oRYDfxu5zQ8OATl+eFGqAdV9p/JMiQveM
         IKanlRH5gsxjfW1pOCfpcjmytPe9BBknkd2kp5HQAndGES3Ylcal5aA6/a89q8aoz39w
         9ASg==
X-Gm-Message-State: AO0yUKXqfbVeOfxIvKF7hJH7zwv0ks4dn1POy2fchNjGUDxob53IoXKp
        J3ev2+7OzKmjE/GH6lFjAdOjqJPDWTG6lvoznYhz2Q==
X-Google-Smtp-Source: AK7set+2REbogAH1fmSSzwS1kZBMqS2Vj5bOSAAXN63uUeD5POYhbr3TIi+wclMraNBed7OH6TljDaQq5C9LYsEZ+9U=
X-Received: by 2002:a05:6a00:2408:b0:593:c68b:4e5b with SMTP id
 z8-20020a056a00240800b00593c68b4e5bmr622769pfh.17.1675270319906; Wed, 01 Feb
 2023 08:51:59 -0800 (PST)
MIME-Version: 1.0
References: <20230201152018.1270226-1-alvaro.karsz@solid-run.com>
 <20230201105200-mutt-send-email-mst@kernel.org> <CAJs=3_Bw5QiZRu-nSeprhT1AMyGqw4oggTY=t+yaPeXBOAOjLQ@mail.gmail.com>
 <20230201110253-mutt-send-email-mst@kernel.org>
In-Reply-To: <20230201110253-mutt-send-email-mst@kernel.org>
From:   Alvaro Karsz <alvaro.karsz@solid-run.com>
Date:   Wed, 1 Feb 2023 18:51:23 +0200
Message-ID: <CAJs=3_DXaZh2aG7gJ66MUuqx4zTqK1ZWVsNudcGkQtnfAJhzBw@mail.gmail.com>
Subject: Re: [PATCH] vhost-vdpa: print error when vhost_vdpa_alloc_domain fails
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, netdev@vger.kernel.org,
        Eugenio Perez Martin <eperezma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > dev_warn then?
>
> dev_warn_once is ok.

Ok, thanks
I'll send a new version tomorrow.
