Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2138666E1BA
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 16:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjAQPKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 10:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbjAQPJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 10:09:54 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB3F040BC3
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:09:53 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-4c24993965eso419683547b3.12
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 07:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vO1ImiweOzoBtInzit/mjHfxkZCqptROLHafUjZGKew=;
        b=DQxl7lLnGVlbN3kISaxo/zzCdW/2oSKfHpoor/3BNknJ06o5+2vwWhF9/vJFhcyW2X
         2RI4uONDbdzX1Wg2qjaRcZBgtai8vQL6L+FboFwMYohd3hMs+txbM84H4JHbxRg6doJs
         1fGDDdUshtWetqBpubwEkFa764wg3mZuy9wC++5JSX5RLn7PizDG2tMsnKIGuFfXISHI
         0bPSwZFBMiyxOYdFJ+ik1Xi/S2fj9j19dGfwgcyRU269bYzhGroBvY0Lurb0EXlkClLs
         OAMXzeXlVKlWneLke6hxXow6U5l3NZk18U5Zvek6vRwL24PLbqRXoqecovdpLefWGk1G
         0V3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vO1ImiweOzoBtInzit/mjHfxkZCqptROLHafUjZGKew=;
        b=xxlbj91YjaMCsJkmqFaWIaZWiVmyec1G74tKkbQczBovY0Wa3+6W1lkLp9H4aWCGkF
         mY6NQ2ucjU6yW9aN5qmhMLArUcwiklXdHKgQ0+8vNLDDIHdk9ZhiDbPBRi3kYb58sGPf
         PTwAPT0hePJAe9Z8Wz0N2hX++Siqp37a2qnzpX9IutYopLh2ZIvRd+gl6tulpDInQiQs
         xRSJkDg4dUsbvEME0ZgL+VXfFslfDO69UHVahrRnfooouqD4xXa4LXCOwFtV3dAlBbMc
         Vuv+XID9YROcogbtM9MUq7+qggOWgcNU8dUWVJsUs45SIvw7Qonn6ykUXnbfLJuOFnu1
         Fe9g==
X-Gm-Message-State: AFqh2kqK1OUf/Xv5biltl+cpuLHsK56K8y8o2xxK6MZUVgwSgogLCc+v
        T2dOYt4A5wGoSf12A+Kmv7rVPJFOWD3bgxTB5B5UMQ==
X-Google-Smtp-Source: AMrXdXurh3GkbPNjryC2sk/yJ2VL0TEk9w+39HaeWgAUo4d+hFSrCvnq5yI/2VkwY4eDRcvLmlZrBXFwX1wgI0B3OT8=
X-Received: by 2002:a81:9881:0:b0:4dc:1d4b:620a with SMTP id
 p123-20020a819881000000b004dc1d4b620amr443046ywg.360.1673968193000; Tue, 17
 Jan 2023 07:09:53 -0800 (PST)
MIME-Version: 1.0
References: <20230113034353.2766735-1-liuhangbin@gmail.com>
 <20230113034617.2767057-1-liuhangbin@gmail.com> <20230113034617.2767057-2-liuhangbin@gmail.com>
 <20230112203019.738d9744@hermes.local> <CAM0EoMmw+uQuXkVZprspDbqtoQLGHEM0An0ogzD5bFdOJEqWXg@mail.gmail.com>
 <20230114090311.1adf0176@hermes.local>
In-Reply-To: <20230114090311.1adf0176@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 17 Jan 2023 10:09:41 -0500
Message-ID: <CAM0EoMkOquxiQH23gKwehf_MGL4j2GbGDdZxW-cc8bpC6Jrpqw@mail.gmail.com>
Subject: Re: [PATCH iproute2-next 2/2] tc: add new attr TCA_EXT_WARN_MSG
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 14, 2023 at 12:03 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Sat, 14 Jan 2023 07:59:39 -0500
> Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>

[..]
>
> Ok, but use lower case for JSON tag following existing conventions.
>
> Note: json support in monitor mode is incomplete for many of the
> commands bridge, ip, tc, devlink. It doesn't always generate valid JSON
> yet.

We can work for starters with the tc one and maybe cover ip as well...

cheers,
jamal
