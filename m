Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B34159CEAC
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 04:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239455AbiHWCgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 22:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbiHWCgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 22:36:15 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C59D59270
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:36:14 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id a4so9425525qto.10
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 19:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=o6OtoMeQ07AJHdopkP3J2QJPmV9cqCObzS3tS9GTuYc=;
        b=FbyPXhBONePQGi+02SF7ARgoj20SPIvGSkwWNqgKTA52fCbNqZzkelIC8KL3ntTaDK
         75QvyJQ9AsdwcjvjwA9s4s0Xge4SF4ctn6+IYv351Oh7xNdDqJ+gNacGXUACTzrNT34E
         hAs07HNJL5cdiemG3UX/X8oXdPMWiNuFCmrhTQKjpZzFc0vdNdxoJVxtcuFsvTQZZznQ
         reIZZjDE/ZQtpomVbOEshLyGrZp1ue9JXZljBTpxg8rs2ecokYjaWJZQvdcLWkNzFl7y
         BFYCp6Ej1qL6KQLBE6InrUxpiiax2GYFVqU40KEQeXo5ObXh8zGti57PB4kLP6IYO4T+
         3icQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=o6OtoMeQ07AJHdopkP3J2QJPmV9cqCObzS3tS9GTuYc=;
        b=SblRSs2KS6yVxnxgcSFrhSBfEq8KUNVlfRYDa1VCLHLy6F36plV9oJPhmCsLwxpU3l
         QVGAWER8/9U/LfkErFyowBdm1Dgu2DV3zqz0SUSR7d2RiRGI1dr8DYdA43l7pekDvhHY
         r/S1QEKkIPX4oFSNZVnNAOMZJIjoTh3Tjx6t0L++HAVqJBw+Qh8uS0/M7A5BLpiWSaCX
         7cJLS9GBUVkPhXud7J3QPtn9Su0do1SDYwKWLZgmpXCcg1i/wNCXNWNSGllfD5nO8SHW
         6kM2GT8sFwsXioOBwbc3JE8eNLDgApzU1g4t9CRy7Xn4MP3N76Kyp9Ra+k2aQsEGEfyt
         NJ1Q==
X-Gm-Message-State: ACgBeo2l2C5WdY+yrSXnBsB4/RIw03P2fwmxwByxhGo/0lEMEUK4quHj
        skDlPqfu8UdHB1HrKRBHqTbdH2Taehd4yQhZfC3/yg==
X-Google-Smtp-Source: AA6agR7gkeZ4nNT8xY9H0f9BmSLIQ5I6jduq2tKAuzoB+DNH/CNsXeRRky0pjw/6cMKDQsgcjGJF+8GpECB5lwV/368=
X-Received: by 2002:a05:622a:195:b0:344:5630:dcc with SMTP id
 s21-20020a05622a019500b0034456300dccmr17701562qtw.598.1661222173463; Mon, 22
 Aug 2022 19:36:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220819183451.410855-1-harshmodi@google.com> <20220822185609.1d34f75d@kernel.org>
In-Reply-To: <20220822185609.1d34f75d@kernel.org>
From:   Harsh Modi <harshmodi@google.com>
Date:   Mon, 22 Aug 2022 19:35:37 -0700
Message-ID: <CAO5Vyb9G3AdtAbZ48V0bphkbhgB+yYg9ODcuD+XBMW8ZAapKPQ@mail.gmail.com>
Subject: Re: [PATCH] br_netfilter: Drop dst references before setting.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately, it is unclear which commit introduced the leak. Will
repost with the appropriate CC. Thanks!

On Mon, Aug 22, 2022 at 6:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 19 Aug 2022 11:34:51 -0700 Harsh Modi wrote:
> > It is possible that there is already a dst allocated. If it is not
> > released, it will be leaked. This is similar to what is done in
> > bpf_set_tunnel_key().
>
> Please repost with a Fixes tag and appropriate folks added to the CC
> (scripts/get_maintainer).
