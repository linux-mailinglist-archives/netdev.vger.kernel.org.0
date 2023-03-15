Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F306BAC85
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232152AbjCOJsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbjCOJsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:48:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291763B0D5
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:47:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k2so11526224pll.8
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678873643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8H9fQT3zFrfhpLDjZ59Js/4Gl55Vo33DGvIkjU5w5n0=;
        b=QbjAKAJ1zLRhLPdbef6eqVwotdj5u/hvPUiKcr2HsxuKks+3rJMyI1vP3DxQO4DqJu
         8AlYJHKwvo1yQk9q3a5AUXQBPDNZkLH53ley0jLLedx5dWb6capFl6VHTdfOVwlaBDGq
         KvvfHFD34plUOL9TpK5cU1k6p/ustigokoku48+hfxsZfHYr4aaV5qMYVmCB+G2nARtH
         rAeC5hHGy40JMaNR5DyDw9SJHzdDFelsOUnEYY3vJXUGUYWlrz/qZnrUVy6l8wMUtGic
         /mmEUhCwfG0j+AvqnIc9jqwv/6nI/J6N0rok4qgs/h1S0qj61GxMJ+dqZiR/Nob0JzlV
         FYcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678873643;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8H9fQT3zFrfhpLDjZ59Js/4Gl55Vo33DGvIkjU5w5n0=;
        b=cIE9gBn2gY7xaA97wukDmg1IHar18Tz7woJOfH6HXLXjqmC6oC9+9z4cdY8JwiErnh
         NmGPRv8DvoI8a+DpeCUSbLbLX25yKyOPQSQPjtoPTFTDvnoXjVaYvdUzJCTU5y3IQ+kb
         NF5YndtT8tssVAx3WML2Pmfb3EpCEXavdpwTMb0SY2gA0vrxOSqK0dMuGj0VRTz4fpdf
         BMx9hBXD2oPtRW9V43d4vawYNdB/fWt6tjR4XWpEIWNvf89fdRnqjYC8TnXod2/ydeN/
         GJxw3nLxtX/k4mJ7Blk5CbYCLQf7YPsBYDZBogYYRWhWiS7y7amSfZmYazHoM5wIGnq1
         tjBw==
X-Gm-Message-State: AO0yUKUYWQmgJHXZDGcJtApHCKcpuTOz+LOX4eAue65AqwKNxh/sNuwf
        iOi6pwKySDojjqA+Ag6YZNE=
X-Google-Smtp-Source: AK7set8QPD+AtvpkejsaFjdq+BeIZ1hHm6DA3f9zo+CFr+67j2tF3DN/UZ3eyz2aGlG3ndaf3JVNtQ==
X-Received: by 2002:a17:902:e803:b0:19e:748c:ee29 with SMTP id u3-20020a170902e80300b0019e748cee29mr1994374plg.55.1678873643656;
        Wed, 15 Mar 2023 02:47:23 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id kv3-20020a17090328c300b0019c919bccf8sm3236120plb.86.2023.03.15.02.47.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:47:23 -0700 (PDT)
Date:   Wed, 15 Mar 2023 17:47:18 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
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
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG
 for tc action
Message-ID: <ZBGUJt+fJ61yRKUB@Laptop-X1>
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com>
 <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 06:35:29PM -0400, Jamal Hadi Salim wrote:
> Sorry, only thing i should have mentioned earlier - not clear from here:
> Do you get two ext warns now in the same netlink message? One for the
> action and one for the cls?
> Something to check:
> on terminal1 > tc monitor
> on terminal2 > run a command which will get the offload to fail and
> see what response you get
> 
> My concern is you may be getting two warnings in one message.

From the result we only got 1 warning message.

# tc qdisc add dev enp4s0f0np0 ingress
# tc filter add dev enp4s0f0np0 ingress flower verbose ct_state +trk+new action drop
Warning: mlx5_core: matching on ct_state +new isn't supported.

# tc monitor
qdisc ingress ffff: dev enp4s0f0np0 parent ffff:fff1 ----------------
added chain dev enp4s0f0np0 parent ffff: chain 0
added filter dev enp4s0f0np0 ingress protocol all pref 49152 flower chain 0 handle 0x1
  ct_state +trk+new
  not_in_hw
        action order 1: gact action drop
         random type none pass val 0
         index 1 ref 1 bind 1

mlx5_core: matching on ct_state +new isn't supported
^C

Thanks
Hangbin
