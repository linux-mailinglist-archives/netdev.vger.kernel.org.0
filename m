Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5980549CE2F
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242802AbiAZP2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236282AbiAZP2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:28:39 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C47DC06161C;
        Wed, 26 Jan 2022 07:28:39 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id z199so13251982iof.10;
        Wed, 26 Jan 2022 07:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MHOjiZTG9hOHGojjon35CAoUOzYXCdywjYZDDVGOdvk=;
        b=AZqQs1IVMv/KFA80lI3KJ8M1HXTeZozVCnSy7E6PBFFO8ZVwqpAJs21vpXn1WEZmCW
         wAcucDHZaVff5aCnjzwKeNz+Mu6j//3Ryv3XJQKK/sYTh/92PDcRRGL1NWKQA3BWG9LU
         xtsu19nGcl8dsdHdzMB6WFTGZmv2VBh1imE7oVaRhKPQswhwZ3112ne7jW/CzSBeHmy+
         QFmVd47w2Be+ricbd0YMr4w7fE/MCFuJ2nglwAFycFqGMPuPHzhEcnPR2J+5rlHU9Ql6
         jYfHh3v4zEpyQ2oXfGPByzN8MhuHrxpU/JSYklQquunk7P950XFu/jkvj9UmtcZGuRBE
         o6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MHOjiZTG9hOHGojjon35CAoUOzYXCdywjYZDDVGOdvk=;
        b=AEawFQaxVsDpsEUmylqMnOxyoyKKgsEOJWQ50Bx7ENCakcAIOWOoIsczfeSRIRo24U
         jJC2lNnNNyj8FBBQNp8mv0WboZpZRY4uJOKJ3FX9zFfq72vQ1kVmrjlepkS8D0Yb2JXn
         DT6R35gMZwyh2ana1+ZkAaJ9kUjiopDcxUUVjWMRnivO5GhhI/eZd+kOx9SuOik2B0iR
         122KSWzQ8d6kYrV+tY5Br0T/RlS5LeMB1S5KPNvpd+0bhGZ6Qad2KOEhtcdvLV5t0MB9
         IgpnriyG4+NnDVPqTtEPBRgrJzGXU7tMkIlrbLHQM/l0sA33mB9Xrv/OJWDYYUkoaiWZ
         sq/Q==
X-Gm-Message-State: AOAM5338J6h2W/MCTklA70npVkdvqhlxxhHQeW8dLorsDJLBm/N8UeXk
        q923j39sIKZBxLnmJIKgFvg=
X-Google-Smtp-Source: ABdhPJxrkl2FWHrrFaamz9+OYHF3JUN98tDi38tRR8TEE7mhKYYciPFb0AxaO6xXUa8HoE2+VxBVWg==
X-Received: by 2002:a02:b799:: with SMTP id f25mr7317183jam.217.1643210918657;
        Wed, 26 Jan 2022 07:28:38 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:1502:2fac:6dee:881? ([2601:282:800:dc80:1502:2fac:6dee:881])
        by smtp.googlemail.com with ESMTPSA id h16sm1369206ilj.13.2022.01.26.07.28.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 07:28:38 -0800 (PST)
Message-ID: <693a546d-8e34-5ada-5577-46dd11edef8e@gmail.com>
Date:   Wed, 26 Jan 2022 08:28:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in
 udp_queue_rcv_one_skb()
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
 <20220124131538.1453657-6-imagedong@tencent.com>
 <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
 <CADxym3aFJcsz=fckaFx9SJh8B7=0Xv-EPz79bbUFW1wG_zNYbw@mail.gmail.com>
 <00b8e410-7162-2386-4ce9-d6a619474c30@gmail.com>
 <20220125192515.627cdaa5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220125192515.627cdaa5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/22 8:25 PM, Jakub Kicinski wrote:
> On Tue, 25 Jan 2022 20:04:39 -0700 David Ahern wrote:
>>> I realized it, but SKB_DROP_REASON_TCP_FILTER was already
>>> introduced before. Besides, I think maybe  
>>
>> SKB_DROP_REASON_TCP_FILTER is not in a released kernel yet. If
>> Dave/Jakub are ok you can change SKB_DROP_REASON_TCP_FILTER to
>> SKB_DROP_REASON_SOCKET_FILTER in 'net' repository to make it usable in
>> both code paths.
> 
> SGTM, FWIW. 
> 
> What was the reason we went with separate CSUM values for TCP and UDP?
> Should we coalesce those as well?


To me those are good as independent reasons because the checksum is part
of the protocol and visible in packets.
