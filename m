Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6A6BBCB0
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 19:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjCOSt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 14:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232038AbjCOSt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 14:49:56 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8EA28E53
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:49:55 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5447d217bc6so50418877b3.7
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 11:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678906194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBKt1+hZfSbz/dfEXjkRLNSHEzhLCzYAy33UvsJ6FF8=;
        b=7iPeSV6JuofSP2xxkve2kveagElMRlDdVmP/AzXToJb6BI/QXBh4tCmfss7a85+i0J
         nDTrrD2Ngwyw6+HoP/Zbtp6JfadfZKFv7G7rh0V7DOMGR0d1CCJTopiNuXdAfTsi4G1w
         7isQJsGmcSjmYvcfYheMsRhBFGgAQ4W+/IOXw9B5VcpHr1JtuvZpAkqYCF21wzHcpn3C
         zy5dgHVGAJktyU1CPKgjBaTgKfZSlNtMrJ7fxqucU6wu0rPRiU70JC5bCjkj3f2uTVOB
         Xz9/y0CJa2BRwRBV1C92asd/7Nh84QzDrp3+a8SzLzRxtmp8K+gKOoENhmQOAlRIJxZx
         CJAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678906194;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hBKt1+hZfSbz/dfEXjkRLNSHEzhLCzYAy33UvsJ6FF8=;
        b=1ahZAiOvYNT5L3gFfyhNMA/iNsUeH79HhhYbHJqmdwt17GgkLtFSxYAO7VVlz+ewO5
         VgpS92uY2I74KDtQqLNh6R6f1+ASCB7mXd5ShFV1TQKA2JltmYxgmBXGYZJTcSyAdfvU
         STXlHIYAr+nu7FTb8reLZwOZEajdMW5GoP4WVSs5YgVM+SczVesWHOoBNQBfrEbuYqbe
         Ssg7KRKBMwY7DUqKGMJ9A/mv/2yB5PaMEbWigOGBMi4M4AYJQmFQ8W1mPMgu+2+qBAjF
         yQKa8tNJORCie9EXjEm4N4lg8C/u8n1qezzRRrsoXXlCRxtFHC+j5/VQoDSpXpnxPypn
         ///A==
X-Gm-Message-State: AO0yUKVfriotCvVPamkdtzGw9OhcWz9tCA8qgtRfg7viNb/rJlbSqvM2
        izwx42uWmDGlWIXMsnJOQTfmF+uCNC5MD5WddVCIoQ==
X-Google-Smtp-Source: AK7set870pysvPxXD9oqD59UR7VCXkP7BMkwZGs0h6+OfWycFixMVwGSEAr8vOUp9mgtewtP04NM2j8w/F+3l1M40uA=
X-Received: by 2002:a81:ac53:0:b0:541:e84a:9d9 with SMTP id
 z19-20020a81ac53000000b00541e84a09d9mr538610ywj.7.1678906194507; Wed, 15 Mar
 2023 11:49:54 -0700 (PDT)
MIME-Version: 1.0
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com> <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
 <ZBGUJt+fJ61yRKUB@Laptop-X1>
In-Reply-To: <ZBGUJt+fJ61yRKUB@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Wed, 15 Mar 2023 14:49:43 -0400
Message-ID: <CAM0EoM=pNop+h9Eo_cc=vwS6iY7-f=rJK-G9g+SSJJupnZVy8g@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for
 tc action
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 5:47=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.com> =
wrote:
>
> On Tue, Mar 14, 2023 at 06:35:29PM -0400, Jamal Hadi Salim wrote:
> > Sorry, only thing i should have mentioned earlier - not clear from here=
:
> > Do you get two ext warns now in the same netlink message? One for the
> > action and one for the cls?
> > Something to check:
> > on terminal1 > tc monitor
> > on terminal2 > run a command which will get the offload to fail and
> > see what response you get
> >
> > My concern is you may be getting two warnings in one message.
>
> From the result we only got 1 warning message.
>
> # tc qdisc add dev enp4s0f0np0 ingress
> # tc filter add dev enp4s0f0np0 ingress flower verbose ct_state +trk+new =
action drop
> Warning: mlx5_core: matching on ct_state +new isn't supported.
>
> # tc monitor
> qdisc ingress ffff: dev enp4s0f0np0 parent ffff:fff1 ----------------
> added chain dev enp4s0f0np0 parent ffff: chain 0
> added filter dev enp4s0f0np0 ingress protocol all pref 49152 flower chain=
 0 handle 0x1
>   ct_state +trk+new
>   not_in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 1 ref 1 bind 1
>
> mlx5_core: matching on ct_state +new isn't supported
> ^C

Thanks for checking. I was worried from the quick glance that you will
end up calling the action code with extack from cls and that the
warning will be duplicated.

cheers,
jamal
