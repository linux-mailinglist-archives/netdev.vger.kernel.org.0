Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844786D42AE
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 12:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbjDCK41 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 06:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbjDCK40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 06:56:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1CF5FE1;
        Mon,  3 Apr 2023 03:56:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id j1-20020a05600c1c0100b003f04da00d07so1369656wms.1;
        Mon, 03 Apr 2023 03:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680519384;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l1i/QXNc6lXMKJ7pXgmtLMgzIk+6jhfEKBjAn/Et1rw=;
        b=SY9DrhXh9MbQhpfR51VHj3wfR3mG1imKJmXJ88H0VIVh1pqtBNYJsO6s/J4ob+FDW9
         +5rqli8TusTk4LlO0sXY1pnnigkzxRsaqVyCP9nyS/1MgPCl/I008mQ3aW5M77Pa2v0R
         FajYlaQoqOR4Mna5k8c/585e67FVp7is2pXcDcecX/bZmN5GExoeor4zx6uh4nAtfG0G
         vZsDsGR8VSCY7MSlM+h/4mDtl6lC35IkRBB+MWaeauR6/sFCWBpq98gptNKKdkcxcVJs
         dKrQBX5zDDrbWMa+s/Majo/f+uoopvU7MuPVGsKPwWeIerw7XuwTQP/dS4LjmCIMTB8y
         XRqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680519384;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l1i/QXNc6lXMKJ7pXgmtLMgzIk+6jhfEKBjAn/Et1rw=;
        b=SMlspt9Br/d5euh+bWTLLVDMGxzdtZuF5w2ptAAPW6iECI70HHymJqZ66N+LGti8Tk
         khBl8sLZq4+lJ3YL2yfKkQgcRpDaIvT5OL9C8xyTzCkmPNP4aORPAwPjbL4ppZJiFfeH
         p+vOKN4ohjf0Esgy7fedjmLE1GMIF6kPhhW4P+Z54FUSR+KEYLzUV1TdSSIgiOCVXee8
         dSokHQdEmzc9Ka6+AAucN8YJShBWAzTp0WPVFupM+LX+fbQsbG2Mx0HOwWbQCLgUJf9F
         JHEtPWy1Z4lSZJ8Hkad+cZjp/WoRLSw69sGzKf1XUOycwTuk6OhDz+5kPdMRYqnWEiOg
         wSDw==
X-Gm-Message-State: AO0yUKU3dY/52HNZqFWOmmbg+dRIlkD6rn1GflPteC3eFUIckCG2hbl1
        /lZjJ9qo6eBz+8q9PzqD3C0=
X-Google-Smtp-Source: AK7set/4v/PIYKJUgECZ5BNmXFGzamGX8uKaz9ksiy+uqC3NIjHxHdJw4WF1RjeH/wKnDKNl1cf3xQ==
X-Received: by 2002:a1c:7207:0:b0:3ed:2606:d236 with SMTP id n7-20020a1c7207000000b003ed2606d236mr25782065wmc.38.1680519383527;
        Mon, 03 Apr 2023 03:56:23 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id k22-20020a7bc316000000b003ee20b4b2dasm11675100wmj.46.2023.04.03.03.56.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 03:56:23 -0700 (PDT)
Subject: Re: [PATCH] udp:nat:vxlan tx after nat should recsum if vxlan tx
 offload on
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Fei Cheng <chenwei.0515@bytedance.com>
Cc:     dsahern@kernel.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>, ecree@amd.com
References: <20230401023029.967357-1-chenwei.0515@bytedance.com>
 <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <fae01ad9-4270-2153-9ba4-cf116c8ed975@gmail.com>
Date:   Mon, 3 Apr 2023 11:56:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Lg_XSnE9frH9UFpJCZLx-gg2KHzVu7KmnigidujCvepQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/04/2023 19:18, Willem de Bruijn wrote:
> On Fri, Mar 31, 2023 at 10:31 PM Fei Cheng <chenwei.0515@bytedance.com> wrote:
>>
>> From: "chenwei.0515" <chenwei.0515@bytedance.com>
>>
>>     If vxlan-dev enable tx csum offload, there are two case of CHECKSUM_PARTIAL,
>>     but udp->check donot have the both meanings.
>>
>>     1. vxlan-dev disable tx csum offload, udp->check is just pseudo hdr.
>>     2. vxlan-dev enable tx csum offload, udp->check is pseudo hdr and
>>        csum from outter l4 to innner l4.
>>
>>     Unfortunately if there is a nat process after vxlan tx，udp_manip_pkt just use
>>     CSUM_PARTIAL to re csum PKT, which is just right on vxlan tx csum disable offload.

In case 1 csum_start should point to the (outer) UDP header, whereas in
 case 2 csum_start should point to the inner L4 header (because in the
 normal TX path w/o NAT, nothing else will ever need to touch the outer
 csum after this point).

> The issue is that for encapsulated traffic with local checksum offload,
> netfilter incorrectly recomputes the outer UDP checksum as if it is an
> unencapsulated CHECKSUM_PARTIAL packet, correct?

So if netfilter sees a packet with CHECKSUM_PARTIAL whose csum_start
 doesn't point to the header nf NAT is editing, that's exactly the case
 where it needs to use lco_csum to calculate the new outer sum.  No?

-ed

PS. Fei, your emails aren't reaching the netdev mailing list, probably
 because you're sending as HTML.  Please switch to plain text.
