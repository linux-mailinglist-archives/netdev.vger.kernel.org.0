Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53BCB66AB53
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 13:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjANMUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 07:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbjANMUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 07:20:06 -0500
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FC36E8C
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:20:05 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-4c131bede4bso319972687b3.5
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 04:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wzNK46WKAAA/weyFv6BTF2PNc1pL8qWm7PwbBVgA5Ak=;
        b=EzFxbma06pNZpAB9hJLY1BoUhAdJN8Q7wgOc3GR7L1zZ5wCOZaNsZDIfzmICjllVfo
         Oc851fLpKzJdtAMo38ghFoGE8IgnoaQmzRdg1a5ANwnQFE8e5YGhn0JFyXhci5x0IyCS
         emy/rQbFBrnDphKB1YmgQfZOhtGGMFrf+BPT4a45FnJ0LFRY+7DVfcQfgVD1fCV18wIq
         ZTchZaTsrvfyfYF8DLkYMAAh/2upjTjdFSI2jyArn5TCPAXvZgML5r/Yautu6SvuhKHm
         /8NFhDtnkMgT7oQOOIvftffJ1xhawHtIkqXH7mIYbQcEm/M679EUJ0OKXlDu53dFhTRM
         WGgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wzNK46WKAAA/weyFv6BTF2PNc1pL8qWm7PwbBVgA5Ak=;
        b=0BI4/nI6lDvqwoV2cILgivVePJDTBynhB7N4BdeKShxyMx5Mq+hYPzFFUc1VRY7ox3
         Hqa9Vqk5tjW86d7WatU1fvN8wLuvzCbviC6RW5Bc5CWJ8udIUECaK601topkIwgDHLnr
         thxiHpEnnzr3UN1kIC9jS+N8ivJM2T8t4zqj+mOow6909uZNLrBfo4yXLICzSNToO8FO
         DS9xs+mHCiI8BAbHnQwfTV3sB9dqZfRjfJmZrikCkBcrfpABtHmC08G2Rn4lP0Czox7F
         PjK1uaGdnhSUvE/82BFplgIZV6e4RwxXghB0inj4bloZ4WJxKcMPjwJnOTf3cgv3OzKk
         meMg==
X-Gm-Message-State: AFqh2kqOFufRLoD/H/kpk3nSGiqYXRwuilalOMOrsdigNsEErPq9j7j0
        FOT582U416mQnSg17xa6klszKMe5FOY5c9LdFIGYsg==
X-Google-Smtp-Source: AMrXdXv/NsrtMw3d4ocNlVPIl+y3f1xkiiTzE8UslXqQnwVajkh/SNhAz5/oGzH/97Uje+KhGUJYU6kQIPlwXoG5ZHU=
X-Received: by 2002:a05:690c:a88:b0:4dc:1d4b:620a with SMTP id
 ci8-20020a05690c0a8800b004dc1d4b620amr1025008ywb.360.1673698805039; Sat, 14
 Jan 2023 04:20:05 -0800 (PST)
MIME-Version: 1.0
References: <20230113034353.2766735-1-liuhangbin@gmail.com> <20230113221523.7940698a@kernel.org>
In-Reply-To: <20230113221523.7940698a@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 14 Jan 2023 07:19:53 -0500
Message-ID: <CAM0EoMk_zHtzfOdojz2jcwdakb_H9JtqGysqqrL2ekdPsnrrMw@mail.gmail.com>
Subject: Re: [PATCHv4 net-next] sched: add new attr TCA_EXT_WARN_MSG to report
 tc extact message
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

On Sat, Jan 14, 2023 at 1:15 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 13 Jan 2023 11:43:53 +0800 Hangbin Liu wrote:
> > We will report extack message if there is an error via netlink_ack(). But
> > if the rule is not to be exclusively executed by the hardware, extack is not
> > passed along and offloading failures don't get logged.
>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
