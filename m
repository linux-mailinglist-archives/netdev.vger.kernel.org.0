Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 043274F04EC
	for <lists+netdev@lfdr.de>; Sat,  2 Apr 2022 18:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358153AbiDBQe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Apr 2022 12:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352907AbiDBQe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Apr 2022 12:34:28 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71B5DF07
        for <netdev@vger.kernel.org>; Sat,  2 Apr 2022 09:32:36 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2e68c95e0f9so61802797b3.0
        for <netdev@vger.kernel.org>; Sat, 02 Apr 2022 09:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RycFDybbAA2lGRPGL77Hw+gaFXA7KQ8Z4NlWY/ZaLqU=;
        b=e0fvxUrtWorXB316w2seE6WEGlFCf2JCbJeyz/spu1hzO0VtjNzhV6+uTXoEoOb1lZ
         YFtQ2i+ST4vXDCipkfuIC9ANHsPnkX1xbXWO9QoqGVAbIfQ0vWX+QhmlZrNoYo/gs66t
         uWR+HqwzTzBz1rCnISVakAcR2WZJt55ttftaqcYRXg1KAYMzxr6vJXlm++CSA/t7PB5s
         2qru8MFfcgdCV/ZOm208a7+J5qLEXE4PwafBEpK+K+4YXOJmjSTo12EACxiFci+4rC5K
         QH71YhU2q5EvpiY/dn0xdhwkp6xxd8xpoTwC1bRsq/KntLmRs0cMLPJgQrhGGx0fSIlb
         ah+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RycFDybbAA2lGRPGL77Hw+gaFXA7KQ8Z4NlWY/ZaLqU=;
        b=sv0HLymb/KPRNFxGpFxjC44GpiJsMR1qHkqs65v1CoA3K3PKO25lEq2nwuV0Nzm3Tg
         ztpLdfnDGxSNf9yurZkiBYHQTOsAVmY81WUt3UGCnPkLgCZs9+lkinkgtw2/xrIdhmkT
         gCATCllfosPBHfXKz7uwtZWmKSzszBX8kprpTmd3uqwwbJifGLpK0hIVhXoZreOaLKJf
         CNWNn7zI2gAHMySDQkx4oO1qjTd+pbOHueiCgXn43m1+hoDB0EWBcY6FtLuf89XLgwZ7
         /AxZYBG8/zFPpMRnDFAnweqxvJw6DwGpTPLRomNRigoDZIPcZ62n78Tek7bwc1UNpWCA
         DZeg==
X-Gm-Message-State: AOAM531wCFv7fgd9rg15lecXqGPbJrWNHvCjpiS+bJYV7ssg11xQVkRt
        /uRVDDwRJjmA4naFfP+AXHnAtBsU6+w1q7GCnK90sw==
X-Google-Smtp-Source: ABdhPJzVK3H4+N3yCcwH2LUKu/QytnrcK6XhYuJMbkf7NZGlgDx3F1rg2eQgir87qDzs97sfYOs/j8vCCiWgT4LbFfw=
X-Received: by 2002:a81:4f87:0:b0:2e5:dc8f:b4e with SMTP id
 d129-20020a814f87000000b002e5dc8f0b4emr14964219ywb.467.1648917155729; Sat, 02
 Apr 2022 09:32:35 -0700 (PDT)
MIME-Version: 1.0
References: <E1nZMdl-0006nG-0J@plastiekpoot> <CADVnQyn=A9EuTwxe-Bd9qgD24PLQ02YQy0_b7YWZj4_rqhWRVA@mail.gmail.com>
 <eaf54cab-f852-1499-95e2-958af8be7085@uls.co.za> <CANn89iKHbmVYoBdo2pCQWTzB4eFBjqAMdFbqL5EKSFqgg3uAJQ@mail.gmail.com>
 <10c1e561-8f01-784f-c4f4-a7c551de0644@uls.co.za> <CADVnQynf8f7SUtZ8iQi-fACYLpAyLqDKQVYKN-mkEgVtFUTVXQ@mail.gmail.com>
 <e0bc0c7f-5e47-ddb7-8e24-ad5fb750e876@uls.co.za> <CANn89i+Dqtrm-7oW+D6EY+nVPhRH07GXzDXt93WgzxZ1y9_tJA@mail.gmail.com>
 <CADVnQyn=VfcqGgWXO_9h6QTkMn5ZxPbNRTnMFAxwQzKpMRvH3A@mail.gmail.com>
 <5f1bbeb2-efe4-0b10-bc76-37eff30ea905@uls.co.za> <CADVnQymPoyY+AX_P7k+NcRWabJZrb7UCJdDZ=FOkvWguiTPVyQ@mail.gmail.com>
 <CADVnQy=GX0J_QbMJXogGzPwD=f0diKDDxLiHV0gzrb4bo=4FjA@mail.gmail.com>
 <429dd56b-8a6c-518f-ccb4-fa5beae30953@uls.co.za> <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
In-Reply-To: <CADVnQynGT7pGBT4PJ=vYg-bj9gnHTsKYHMU_6W0RFZb2FOoxiw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 2 Apr 2022 09:32:24 -0700
Message-ID: <CANn89iJqKmjvJGtRHVumfP0T_SSa1uioFLgUvW+MF2ov2Ec2vQ@mail.gmail.com>
Subject: Re: linux 5.17.1 disregarding ACK values resulting in stalled TCP connections
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Jaco Kroon <jaco@uls.co.za>, Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 2, 2022 at 9:29 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> FWIW those log entries indicate netfilter on the mail client machine
> dropping consecutive outbound skbs with 2*MSS of payload. So that
> explains the large consecutive losses of client data packets to the
> e-mail server. That seems to confirm my earlier hunch that those drops
> of consecutive client data packets "do not look like normal congestive
> packet loss".


This also explains why we have all these tiny 2-MSS packets in the pcap.

Under normal conditions, autocorking should kick in, allowing TCP to
build bigger TSO packets.
