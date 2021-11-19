Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1C84568D2
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234358AbhKSD5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbhKSD53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:57:29 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A595EC061574;
        Thu, 18 Nov 2021 19:54:28 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id o4so19155675oia.10;
        Thu, 18 Nov 2021 19:54:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vZDyNQlzKH5HpcJ35gDcDsZxrO1Q+mmnr2YDzJLZPoU=;
        b=BmNZN7DV+OPRRxeE3w0eOlHDSAd9HefcDXFNpzLxrXT762hIcFFa9a4kbQqo5yL4hU
         kQld98IZ1ky1fKGC7cZCtvEX6ftjvg0sS0X5p4LHKPzl4hvMLINszDBFGxJYrwMAZ10e
         9e/Rux0ggdUSF8+N9ZlCeEJCnFARWiB/YNrdRDyaTITMSRWhPLL4zbWUEKOdKLjQMLHz
         sU7LcHdoF4ZdlbMxm9YpwWYbTvdlWQthiWq1+pPWMA1XtTZP6druV0psu/yO113awV38
         nfTTv0GmhYnEIK0vqccciMhPMRaxBHrIAdYA6i5XzkiaRvHl/O1/hbH6cCOwhdP++nX2
         LTEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vZDyNQlzKH5HpcJ35gDcDsZxrO1Q+mmnr2YDzJLZPoU=;
        b=tpPAgAUD3F7nLWcK4ucKvz5AgId6GRQIJSydsfl59KSA1Mw4mn1DYLZ9Qbavz/eo4l
         IIYxfpFXgE7YozsqCtA3O4IS2HDdicdnDU0xQRr3byta1iPIPYWSvbfTiIFSV4jPhF3H
         EjpBZ67tYpUirG0ohaSOjdqfU637ff6jSZ73ZRy4ARDU+tJdAwS71zEroOJVuPkHZ5pE
         MbRl6kA/2kD3RmsW/2cQr1cprcpwfZsvd14PcUcojKoE7yvU5EbQci4RcC6aRzgEGWWI
         GaKgTEijov3d+eB244ZkzQFzp/8c4SCXoGLhzA3Uymt1oO7uXMFAAjP4SdMHfZoqOfnY
         U+Kg==
X-Gm-Message-State: AOAM530zeergZVdF0THMVxKNqCgtZGouihsfcGQA7z7DIPp6jPXYy9zf
        1YCg4JeUEidqX+mioWJWlzM=
X-Google-Smtp-Source: ABdhPJx6jnEkMJXgJPRSn+Q4Y0t/XcSnlVq8Ox0aVOUiDkG2AaHU/P2OsNUNW5DzYYrjVPpeCmwd2g==
X-Received: by 2002:a05:6808:2cc:: with SMTP id a12mr2235234oid.126.1637294068110;
        Thu, 18 Nov 2021 19:54:28 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n22sm343941oop.29.2021.11.18.19.54.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 19:54:27 -0800 (PST)
Message-ID: <9ad07da4-8523-b861-6111-729b8d1d6d57@gmail.com>
Date:   Thu, 18 Nov 2021 20:54:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH v2 net-next 0/2] net: snmp: tracepoint support for snmp
Content-Language: en-US
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>, mingo@redhat.com,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Menglong Dong <imagedong@tencent.com>,
        Yuchung Cheng <ycheng@google.com>, kuniyu@amazon.co.jp,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20211118124812.106538-1-imagedong@tencent.com>
 <67b36bd8-2477-88ac-83a0-35a1eeaf40c9@gmail.com>
 <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADxym3ZfBVAecK-oFdMVV2gkOV6iUrq5XGkRZx3yXCuXDOS=2A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 8:45 PM, Menglong Dong wrote:
> Hello~
> 
> On Thu, Nov 18, 2021 at 11:36 PM David Ahern <dsahern@gmail.com> wrote:
>>
> [...]
>>
>> there is already good infrastructure around kfree_skb - e.g., drop watch
>> monitor. Why not extend that in a way that other drop points can benefit
>> over time?
>>
> 
> Thanks for your advice.
> 
> In fact, I don't think that this is a perfect idea. This way may have benefit
> of reuse the existing kfree_skb event, but this will do plentiful modification
> to the current code. For example, in tcp_v4_rcv(), you need to introduce the
> new variate 'int free_reason' and record the drop reason in it, and pass
> it to 'kfree_skb_with_reason()' in 'discard_it:'. Many places need this kind
> modification. What's more, some statistics don't use 'kfree_skb()'.
> 
> However, with the tracepoint for snmp, we just need to pass 'skb' to
> 'UDP_INC_STATS()/TCP_INC_STATS()', the reason is already included.
> This way, the modification is more simple and easier to maintain.
> 

But it integrates into existing tooling which is a big win.

Ido gave the references for his work:
https://github.com/nhorman/dropwatch/pull/11
https://github.com/nhorman/dropwatch/commit/199440959a288dd97e3b7ae701d4e78968cddab7

And the Wireshark dissector is also upstream:
https://github.com/wireshark/wireshark/commit/a94a860c0644ec3b8a129fd243674a2e376ce1c8

i.e., the skb is already pushed to userspace for packet analysis. You
would just be augmenting more metadata along with it and not reinventing
all of this for just snmp counter based drops.
