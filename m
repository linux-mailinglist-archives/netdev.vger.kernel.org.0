Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC6606753E3
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 12:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjATLym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 06:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjATLyi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 06:54:38 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6769EE13
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:54:33 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id r2so4622788wrv.7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 03:54:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qdJmmO+QRhLdssp1NY9FBVDF+G55OGqm/h6RlWQuA4o=;
        b=XHbtLqeIQTXAdbsDrzTqG5IWYxkOQIvmMVK0mBexrtMJkLsHRkLDkE0v4exycp0bPO
         hmUSIJaRXNbJuKuyr/A56YF9LSqM2J83lhILAnCqpVdXESzeYARYWQ0ChrTGP4imm70F
         tOikBSk2yuQnA9use9RVWVAx35qibo3sNATETDF01fxA1/FlLs/ouC7tdexHdu10jq6A
         U0WRxz/cKxtG5rUeYcO3rhFzvEfCvd+GCcRfFPfsFhCJi9MQFCY77bzbjJ8/DaB0pDoH
         6RufqrSHsALhx8zU+CbvSVEAmcabMN6IIIJ6XACdKOBkNNX38hjpnvkQnKaprZEpG3nl
         3AAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qdJmmO+QRhLdssp1NY9FBVDF+G55OGqm/h6RlWQuA4o=;
        b=lIbHGfgpdhQABmJEC/0ZWBlnD3pbn3yYWWrhzFXYrUrK2FGyCq+4OP+hHHEseTxga7
         YO4Is9yEIs6EtJqg6USHa3UaIB2TO4trDd9RVZM3SOm9aK95/Nc4bbWeXWDEE2IkRs2+
         HK0whRxcUODF8/NeQD34x1VpKS01q9KPcOOc+qHAWdTruOgiY2MHNDPAl2oJwMI4BnPg
         2wkW9Q2YOYz2QVH0KSWMkQn7rJMb/FqXRUCV9LZATkX9b0xzcR+8WdeZ43qvjeTIl7C+
         NMFif/kLGN98EZ0yvLsaSmZWP1/sBUwsX5nEg2vamipeRazClQYO87yVrYtoSdNt0ldx
         8wpg==
X-Gm-Message-State: AFqh2kr3aVjFuaj2Eogck4/n7NaFMO0TKUv9F2ExmuwSSbDadYUX+dDT
        daCo9yMTCTKBSL1NE3bK0Dt/o/7Elmg=
X-Google-Smtp-Source: AMrXdXs/9HiD7KSGN1C/EM+v/uaHWTbYIQwaahxzBQVvzMJSr8i/vMNlgUaNLsXXNqeGw8Bdr/i8Bw==
X-Received: by 2002:adf:e38f:0:b0:2bd:d76f:23eb with SMTP id e15-20020adfe38f000000b002bdd76f23ebmr9396766wrm.29.1674215671803;
        Fri, 20 Jan 2023 03:54:31 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id m5-20020a056000024500b00267bcb1bbe5sm36835007wrz.56.2023.01.20.03.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 03:54:31 -0800 (PST)
Subject: Re: [PATCH net-next 0/4] net/sched: cls_api: Support hardware miss to
 tc action
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Paul Blakey <paulb@nvidia.com>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
References: <20230112105905.1738-1-paulb@nvidia.com>
 <CAM0EoMm046Ur8o6g3FwMCKB-_p246rpqfDYgWnRsuXHBhruDpg@mail.gmail.com>
 <164ea640-d6d4-d8bd-c7d9-02350e382691@nvidia.com>
 <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <912be77b-3723-33a7-8fee-05262b94efa1@gmail.com>
Date:   Fri, 20 Jan 2023 11:54:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAM0EoM=FaRBWqxPv=jZdV_SZxqw26_yhK__q=o-9vqypSdMV1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/01/2023 13:40, Jamal Hadi Salim wrote:
> I agree that with your patch it will be operationally simpler. I hope other
> vendors will be able to use this feature (and the only reason i am saying
> this is because you are making core tc changes).
FTR at AMD/sfc we wouldn't use this as our HW has all action execution after
 all match stages in the pipeline (excepting actions that only control match
 behaviour, i.e. ct lookup), so users on ef100 HW (and I'd imagine probably
 some other vendors' products too) would still need to rewrite their rules
 with skbmark.
I mention this because this feature / patch series disconcerts me.  I wasn't
 even really happy about the 'miss to chain' feature, but even more so 'miss
 to action' feels like it makes the TC-driver offload interface more complex
 than it really ought to be.
Especially because the behaviour in some cases is already weird even with a
 fully offloadable rule; consider a match-all filter with 'action vlan push'
 and no further actions (specifically no redirect).  AIUI the HW will push
 the vlan, then deliver to the default destination (e.g. repr if the packet
 came from a VF), at which point TC SW will apply the same rule and perform
 the vlan push again, leading (incorrectly) to a double-tagged packet.
So it's not really about 'miss', there's a more fundamental issue with how
 HW offload and the SW path interact.  And I don't think it's possible to
 guaranteed-remove that issue without a performance cost (skb ext is
 expensive and we don't want it on *every* RX packet), so users will always
 need to consider this sort of thing when writing their TC rules.

TBH doing an IP address pedit before a CT lookup seems like a fairly
 contrived use case to me.  Is there a pressing real-world need for it, or
 are mlx just adding this support because they can?

-ed
