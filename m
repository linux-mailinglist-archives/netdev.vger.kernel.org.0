Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA0067804F
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232877AbjAWPqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjAWPqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:46:24 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4499F5FFD
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:46:22 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id p189so5774018iod.0
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sahp6sJhGqsSGd7lXfmkCR5vZ/KMU+jdJ93BAvcFsDU=;
        b=Sw2GQq8Xsg6IC0nAOzG5/NSfyyLJEJJRAJ9Zr8FgYmsjHtzqndkHXnOXHEUUG5na3X
         7Y53/gXVEiEjFQeKs1eVkjARKT2iX3r6PpXyVvdLJrS641w4JrgHSlJ64UniSABpG4M/
         MxfqJT3if5u4pGDewcqphVW6d55OrCmnZx3Nc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sahp6sJhGqsSGd7lXfmkCR5vZ/KMU+jdJ93BAvcFsDU=;
        b=SycV0A/XxmmHnP0VrcSzfsO5F8VuEf1t0lD/SFOADWTaVcbumyKmOxElSaWpLPzRKk
         PXoikUw/aePIiOQrH7MC0FSVcVPZRz/2ufHDP5/xDtBFflxrPTmae3eNWR0YMxy1Uy6r
         cFcdxnY/5CoxOBDNVr9Uz45yvOXavGooE22dfc/S78swsek5W3r9wmw8srjxuZK2s6BU
         RSTmHrWR/ZV2gOBerHZ4B3Ino4N/EOi6xujnFUlidUG950A+fJ7D9e4mYIlxVHirdcki
         4aF5HyXVBxWNGH42eUnpBAN1zG16+DtwXJhsV40Ns681v+UMrhjPpJr+NWe3Fr7l/n5c
         7ajg==
X-Gm-Message-State: AFqh2krxJkDDkUQPSC/gzPdfb0AP+hF4KJGQzqFV9n9R2YNajxyt7iud
        vCrueIxmV/ikqIXf9btzfyAAXzcQ+q79QNmh
X-Google-Smtp-Source: AMrXdXtsR7DaD4DDWVXYRbLKn1gVY85l/Jn/a3X4Ap2JRY964aYPq3LgvrhlaiiYRoP/Qs5tAcE8Zw==
X-Received: by 2002:a6b:7316:0:b0:704:a01c:ea80 with SMTP id e22-20020a6b7316000000b00704a01cea80mr18286624ioh.14.1674488781654;
        Mon, 23 Jan 2023 07:46:21 -0800 (PST)
Received: from [192.168.0.41] ([70.57.89.124])
        by smtp.gmail.com with ESMTPSA id o9-20020a6b5a09000000b006c0cb1e1ea8sm15793949iob.12.2023.01.23.07.46.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 07:46:21 -0800 (PST)
Message-ID: <fd9d9040-1721-b882-885f-71a4aeef9454@cloudflare.com>
Date:   Mon, 23 Jan 2023 09:46:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: BUG: using __this_cpu_add() in preemptible in tcp_make_synack()
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
References: <2d2ad1e5-8b03-0c59-4cf1-6a5cc85bbd94@cloudflare.com>
 <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
Content-Language: en-US
From:   Frederick Lawler <fred@cloudflare.com>
In-Reply-To: <CANn89iJvOPH9rJ4YjRP-i99beY3g+moLnRQH2ED-CQX7QnDYpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 1/18/23 11:07 AM, Eric Dumazet wrote:
> On Wed, Jan 18, 2023 at 5:56 PM Frederick Lawler <fred@cloudflare.com> wrote:
>>
>> Hello,
>>
>> We've been testing Linux 6.1.4, and came across an intermittent "BUG:
>> using __this_cpu_add() in preemptible" [1] in our services leveraging
>> TCP_FASTOPEN and our kernel configured with:
>>
>> [snip]
> 
> Thanks for the report
> 
> I guess this part has been missed in commit 0a375c822497ed6a
> 
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index 71d01cf3c13eb4bd3d314ef140568d2ffd6a499e..ba839e441450f195012a8d77cb9e5ed956962d2f
> 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3605,7 +3605,7 @@ struct sk_buff *tcp_make_synack(const struct
> sock *sk, struct dst_entry *dst,
>          th->window = htons(min(req->rsk_rcv_wnd, 65535U));
>          tcp_options_write(th, NULL, &opts);
>          th->doff = (tcp_header_size >> 2);
> -       __TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> +       TCP_INC_STATS(sock_net(sk), TCP_MIB_OUTSEGS);
> 
>   #ifdef CONFIG_TCP_MD5SIG
>          /* Okay, we have all we need - do the md5 hash if needed */


Tested-by: Frederick Lawler <fred@cloudflare.com>
