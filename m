Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42CCA686A7E
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232099AbjBAPiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232058AbjBAPiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:38:24 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FC41EBD8
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:38:23 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id w24so3720245iow.13
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:38:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lhvjHPL8tbjjER568EWyxVdkLyaVHdoJmcpBgSPvUV0=;
        b=ghynpY5QTLa7dqNkAjZDWJCq87KLeWZjT4kKYTEhkKiwe2+VmMMrc+e9RkNNClxpAk
         Pkhbbu6UPvnE3UNtwZX7YgF8VUQBnpLjs4+g60PGxYZpYNX42GBPOGqO/G8KkExq4ps9
         6oNUEMbOekPX53YsaXmIxNP6+VKpHPKqspiaauCWooo0HgFBz3YE8Z9EJBQ5g35/E2wx
         nKuQWc55J2OtGqvSTGjjxCxLUSUcuABB7+AvrJXkW8LlHswdvi9tiP6uVtuT7NIY/QQ2
         F3sDJk+30VF8KhVPxKGA0nodmSG2NSc3ns7kExQpsgCa3sg7h7NVS2GpiHFFQKrUtlNa
         hbow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lhvjHPL8tbjjER568EWyxVdkLyaVHdoJmcpBgSPvUV0=;
        b=IieKpqNjF4sGSj/Zm4N/Ic0fclowzJqomhpEZbk8ldO2Ps+lZ83XhPYeaM/71V5Xtw
         poInELLcPZFaG0JRomAP/lsK1N0mDivN4wlEKpnVDOripB7lRTqvjOTo9k6czYY95oOv
         /6bI/UbWguAzCR4p/1GUSSpQrKgOtVfqxOhoc9K6grZd5oJ+thKUrlkAt/9edsIF3ntE
         HD1gVEqsvgkDU7VES4mPnMAmqx4ru0bM61c9qLyvprJ+/SiWVui7fWybPsDE0CtwwhJo
         TRugWPnht4CCGWn6LuHlFqMArIYmXGoHcCkAK9lFLqHiPEwKJg5sjvMgTLFf0ltb1bCZ
         rOeg==
X-Gm-Message-State: AO0yUKXBdRgXGdWn2ZIlN8CLJ0H32ZJzDSYaCxjIe4itV1Iv2FgtdnS0
        7CmeQ7mTQmC5VCApnTNOM3c=
X-Google-Smtp-Source: AK7set9BmKQd/9lJsWopDXhVVZoVcNN7/E5dFg6cOC9iJt2a8T4DITSW3ON/J/HLCWacT88A/WEyxQ==
X-Received: by 2002:a05:6602:408a:b0:6ee:f9e1:423a with SMTP id bl10-20020a056602408a00b006eef9e1423amr2118086iob.11.1675265902945;
        Wed, 01 Feb 2023 07:38:22 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:1dfd:95ca:34d0:dedb? ([2601:282:800:7ed0:1dfd:95ca:34d0:dedb])
        by smtp.googlemail.com with ESMTPSA id t7-20020a5d8847000000b0071f4551300csm1995572ios.2.2023.02.01.07.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:38:22 -0800 (PST)
Message-ID: <726c28b4-f335-27c2-2c25-31f1c698d187@gmail.com>
Date:   Wed, 1 Feb 2023 08:38:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv4 net-next 10/10] net: add support for ipv4 big tcp
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
 <637aa55b8dbf0c85c2ee8892df26a8bbbf9f2ef5.1674921359.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <637aa55b8dbf0c85c2ee8892df26a8bbbf9f2ef5.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 1/28/23 8:58 AM, Xin Long wrote:
> Similar to Eric's IPv6 BIG TCP, this patch is to enable IPv4 BIG TCP.
> 
> Firstly, allow sk->sk_gso_max_size to be set to a value greater than
> GSO_LEGACY_MAX_SIZE by not trimming gso_max_size in sk_trim_gso_size()
> for IPv4 TCP sockets.
> 
> Then on TX path, set IP header tot_len to 0 when skb->len > IP_MAX_MTU
> in __ip_local_out() to allow to send BIG TCP packets, and this implies
> that skb->len is the length of a IPv4 packet; On RX path, use skb->len
> as the length of the IPv4 packet when the IP header tot_len is 0 and
> skb->len > IP_MAX_MTU in ip_rcv_core(). As the API iph_set_totlen() and
> skb_ip_totlen() are used in __ip_local_out() and ip_rcv_core(), we only
> need to update these APIs.
> 
> Also in GRO receive, add the check for ETH_P_IP/IPPROTO_TCP, and allows
> the merged packet size >= GRO_LEGACY_MAX_SIZE in skb_gro_receive(). In
> GRO complete, set IP header tot_len to 0 when the merged packet size
> greater than IP_MAX_MTU in iph_set_totlen() so that it can be processed
> on RX path.
> 
> Note that by checking skb_is_gso_tcp() in API iph_totlen(), it makes
> this implementation safe to use iph->len == 0 indicates IPv4 BIG TCP
> packets.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/core/gro.c       | 12 +++++++-----
>  net/core/sock.c      | 26 ++++++++++++++------------
>  net/ipv4/af_inet.c   |  7 ++++---
>  net/ipv4/ip_input.c  |  2 +-
>  net/ipv4/ip_output.c |  2 +-
>  5 files changed, 27 insertions(+), 22 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


