Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD3324AFF3C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 22:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbiBIVea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 16:34:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiBIVe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 16:34:29 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDD3C09CE58;
        Wed,  9 Feb 2022 13:34:31 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id r19so6663721pfh.6;
        Wed, 09 Feb 2022 13:34:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8efIbfbQA1nZztwEPxJJD+TMQydEcMqO9skHD9Y3d7E=;
        b=SSKsmqSBFSP7i68l+APpglzSh03gtLNtYPfZeQTB+iUFmrApkskOqcQDVramOIgfHl
         Dj/uZocNIEOIfgv1q+acHuXvY0oPuuKzuVlcDpHH1RCRXbO3BSm1tgujSan+OD4Q2oIj
         9XXCetW0sU6XC7cqbxw9DaqjEZA4GI15/WiibgaVhDAB3JVk+Z+bqGCeNWFuxE2zrkP7
         6LlkwsJ1S5yGhLchsHMNxVEEkmipaciGbwlcoWt+CCrV4RbhE9Ojga7FCK0j0xFG7gt/
         J7481veHQpjm6AJtYqU4V4QqXP0ZMVOdhwhjnvljKuMvuxCeuJXzyjojl7kykgBtedx9
         KcpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8efIbfbQA1nZztwEPxJJD+TMQydEcMqO9skHD9Y3d7E=;
        b=nV1TnXGNzNLnbgjBaHnlVm1wT+G0+XE8k0DHbA3oVYCdKtliY4gzpb3gHAq51QLimH
         wx7EIVSNrcA8JHa9SsvcqHPWRmKZJh/wbtW8zNw5kuQUPDTIZBx96KPVEC3+gUhAl999
         En5YWbSe/85u7IsufJGn68P7CqMOCjZ67qcYReaQWcESVjijYXoL2y/gn0mGGGxqZ4+u
         99ex0VLDdqSpChCusXQAdpjKfG1x1IqKOQYvP1qHItduaftHq78+aO57eGsUQDepIjpQ
         0htnkaTdtB0G4OnJG/ESB7XPFvzfaEVDQu03/J2Ww4NcK3Fq+N83PGBJMF2gFY3YVIIZ
         VDwQ==
X-Gm-Message-State: AOAM531zK4sLyV8U9d8MXK0rTjpsSAPspW2O2cysyyYnY+8UQFqhjO9x
        OODtMzi8xR6RtSYz8sHNJj0=
X-Google-Smtp-Source: ABdhPJwQlcha/oqUKj72WVijlZ5UwJwe4qfSWsM5cQHj6KmcwQgx6vZnBp1xiiKmNp3SY6h1cd+ycg==
X-Received: by 2002:a65:6283:: with SMTP id f3mr3540891pgv.552.1644442470876;
        Wed, 09 Feb 2022 13:34:30 -0800 (PST)
Received: from [10.20.86.120] ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id q8sm22373679pfl.143.2022.02.09.13.34.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 13:34:30 -0800 (PST)
Message-ID: <082e7c21-2973-e83a-29a1-0eb07de7dc75@gmail.com>
Date:   Wed, 9 Feb 2022 13:34:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v8 net-next] net: drop_monitor: support drop reason
Content-Language: en-US
To:     menglong8.dong@gmail.com, idosch@idosch.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, dsahern@kernel.org,
        Menglong Dong <imagedong@tencent.com>
References: <20220209060838.55513-1-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220209060838.55513-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/8/22 10:08 PM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
> 
> The drop reasons are reported as string to users, which is exactly
> the same as what we do when reporting it to ftrace.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v8:
> - pass drop reason to net_dm_packet_report_size()
> - move drop reason validation to net_dm_packet_trace_kfree_skb_hit()
> 
> v7:
> - take the size of NET_DM_ATTR_REASON into accounting in
>   net_dm_packet_report_size()
> - let compiler define the size of drop_reasons
> 
> v6:
> - check the range of drop reason in net_dm_packet_report_fill()
> 
> v5:
> - check if drop reason larger than SKB_DROP_REASON_MAX
> 
> v4:
> - report drop reasons as string
> 
> v3:
> - referring to cb->reason and cb->pc directly in
>   net_dm_packet_report_fill()
> 
> v2:
> - get a pointer to struct net_dm_skb_cb instead of local var for
>   each field
> ---
>  include/uapi/linux/net_dropmon.h |  1 +
>  net/core/drop_monitor.c          | 41 +++++++++++++++++++++++++++-----
>  2 files changed, 36 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


