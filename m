Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE49629413
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbiKOJP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:15:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232253AbiKOJPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:15:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00331119
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668503690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QUlmfWvjqj8dNincCeQoVu54aDrOsJgpiyJRviE7Jqg=;
        b=QuF4ctenZfM8SwjS7Nkb61HPEjjv5UqSmh0/tZAOLVSbOXwsJKnhx5Gx4+uK7DyeicQyr5
        ewirjAuXkOwDLlH/t6fWt0lVmxlZyjkPuUKDSLUTedFVRdLfc27+/7ZHp20aY00MsPKnwJ
        TDHtSU6nWwSDdCBjRqZ9lyBfa5hBm2E=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-ZuEOJRulMxOy7898g-yzFA-1; Tue, 15 Nov 2022 04:14:49 -0500
X-MC-Unique: ZuEOJRulMxOy7898g-yzFA-1
Received: by mail-qv1-f69.google.com with SMTP id w12-20020a056214012c00b004c6257ca968so6832274qvs.16
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:14:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QUlmfWvjqj8dNincCeQoVu54aDrOsJgpiyJRviE7Jqg=;
        b=4FM4RdNGh37SLVmVLTJeudJd+jRfjnSrEGuPMcCkZzqZT2ZrnOojD8RnD3fwth+WMd
         AHrLREtzxSCOEqDIothy3/9cwk9SnJro1mBH2ZulUu34013mRuqTEA+6cfGm2zZSQZYu
         ulP21E10wonxLKnT53kMWSOsfV57aVKEoW3MrIkne190kh7enx1LAaqOf1vmIlNDQvjy
         ABVDJg9shilUQ7N+5BrowAwpl5/ufODdhF/+Tc47g+vkL7E0ygbRp1x7+EL1pUFOLT2b
         9KOvv+130sCAi4pGPsSQMj0H4g24a7wSTmXxTDtJVA3bz3aNm0agIJd8envmP+MmBJg6
         oSXQ==
X-Gm-Message-State: ANoB5pmEyWyDvmdIXR/W+ETtFLAZn5eKuxo1d3FsvnvO+JIcb0IBMAVT
        3E+VieXZJqsXKxRXKGg/psgr2prxXiF7oeZou/a2pDRZO/pOqc+41LVLTdVHiQKGrhsr/mbZPy6
        kd0zSEMar85hjGikE
X-Received: by 2002:ac8:4753:0:b0:3a5:2967:f8b6 with SMTP id k19-20020ac84753000000b003a52967f8b6mr16136301qtp.86.1668503688911;
        Tue, 15 Nov 2022 01:14:48 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5kPGzH6TAYidTWhoRRNJZnO12+Iz2KB2TJB9oSggbmRGNx8qM+cPaPCGkx0WO11mTIWU8ztA==
X-Received: by 2002:ac8:4753:0:b0:3a5:2967:f8b6 with SMTP id k19-20020ac84753000000b003a52967f8b6mr16136287qtp.86.1668503688705;
        Tue, 15 Nov 2022 01:14:48 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id h12-20020a05620a400c00b006b949afa980sm7880319qko.56.2022.11.15.01.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 01:14:47 -0800 (PST)
Message-ID: <9317e4d90174f7158e5e2856edc193a4bcefc04e.camel@redhat.com>
Subject: Re: [PATCH net-next v6] net/sock: Introduce trace_sk_data_ready()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 15 Nov 2022 10:14:44 +0100
In-Reply-To: <20221110023458.2726-1-yepeilin.cs@gmail.com>
References: <20221110023458.2726-1-yepeilin.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-11-09 at 18:34 -0800, Peilin Ye wrote:
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   ksoftirqd/0-16  [000] ..s..  99.784482: sk_data_ready: family=10 protocol=58 func=sock_def_readable
>   ksoftirqd/0-16  [000] ..s..  99.784819: sk_data_ready: family=10 protocol=58 func=sock_def_readable
> <...>

It looks like this does not touch/include sk_psock_strp_data_ready(),
why?

thanks!

Paolo

