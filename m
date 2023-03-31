Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7DF6D207F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 14:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbjCaMj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 08:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjCaMjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 08:39:41 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5501D20618
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:37:24 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id h14so10071141ilj.0
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 05:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680266243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2OQdMVdZpxOaZorfrMBnHhwTaLeLt16Z0ZiPyMWrHs=;
        b=IW4PSHktMdOkPbi61ODzI+iS/rejZ60EBGtFIGATjg0eicIChpkPNOCOhF6cMnLX5y
         lYLkVNJxZ8pWlDQp3DBzHHqY97Z1zYKZRY8iY1TjdtlA2RelU/lLIsAXDbsN9z20o/Oz
         oWKK3hhUe4/kh3KeLnYffePIVG7rL3JYzk3RRLNQMoRDirSVHu3TgVwZPoU6aWIFd21i
         ZY5d1nu4Ss/GuxeEhNsRfwauLqbY0/UhdQ/xEG4M7SVbz/NDYVaF0hQuQVmTaweMZ2Cs
         YE1nLY06OrrOkGfbCJNq05BbGyXwmNmZtDwczJ8kRvHV2bWt24GU3gNB+G98P/oDE64p
         H5Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680266243;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2OQdMVdZpxOaZorfrMBnHhwTaLeLt16Z0ZiPyMWrHs=;
        b=nQwW2IEyBJ4OuT27CgkO0ieYAh0n+0/c9yolTLvlbrT7LyAhwqhCjfEaoA0oZQV9/4
         SSYxlTeollRd5HBi3TDzBjlWe+gobKJzkUm5I/1fj+Vta3PLg4vTG35vze7MRG11O2Dt
         ZTt6v5GsmSPQitAhVCSLNesP8OGyznYeXOnt/p+0cniD6o4f01P8rBKxluRWLXZcQnn1
         m27LX4TGzZFdh0IXVEoPicwB2yb8+RN8QQUfDd6EaSbzFLmO0epNp1UJVhojOUJ8uwG+
         fjMdf2yaDaibfe47mNM6Qb9afrwmNSED+1EyIQGkysmaPwudKCH6spTOjfNHlvvFxJB3
         S07g==
X-Gm-Message-State: AAQBX9ftWG1IualmyBSoKwr0306TsVrdxYIKnm0S0eTXCNAKD2D62oBK
        2njCxuDeDt9N8LkdUsQOmFF1useLWca9CQHak0C3j9c1ZUPcLQye46eq5w==
X-Google-Smtp-Source: AKy350akuGChlZXOKfeW0F4zuTrVCPe3sdt/Bm/jI70PrrZjZ8HrUQq5FwIPHQzS3xb4R/F2+xfZnP209iQWqPU8/uA=
X-Received: by 2002:a05:6e02:218d:b0:322:fd25:872c with SMTP id
 j13-20020a056e02218d00b00322fd25872cmr13735920ila.2.1680266243341; Fri, 31
 Mar 2023 05:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230331044731.3017626-1-kuba@kernel.org>
In-Reply-To: <20230331044731.3017626-1-kuba@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 31 Mar 2023 14:37:12 +0200
Message-ID: <CANn89iJ34wFoqL1ihQOhv3enAz_Gwop908y3=VmsLxGn50um-A@mail.gmail.com>
Subject: Re: [PATCH net-next] net: minor reshuffle of napi_struct
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 6:47=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> napi_id is read by GRO and drivers to mark skbs, and it currently
> sits at the end of the structure, in a mostly unused cache line.
> Move it up into a hole, and separate the clearly control path
> fields from the important ones.
>
>
Reviewed-by: Eric Dumazet <edumazet@google.com>
