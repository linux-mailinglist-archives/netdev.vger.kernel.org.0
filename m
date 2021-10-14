Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA4042DB62
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231361AbhJNOY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhJNOYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:24:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D849CC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:22:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id q2-20020a17090a2e0200b001a0fd4efd49so1106914pjd.1
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EMwDXgwXoXF7SJJC/qZQx+iamVJ9IAoHTJ7NZ/HN9Rg=;
        b=ETvHGUwHG/zNHf5o1+vARHesXnfa+3+7u6M0xtAlwoVduXR6mkjF8uk/SyT7Nqi3/i
         9qDyBiStkVJrEvZk2thXcpiBdzaJd5+CoahSH5E803tQ3uLiWWi1XxlhcPYM+KO3cobM
         oKkZZ1wlfu3j0zbQzuh32Yoz3ORBIZhnot9uJoESWPBBXrq/1fKLiE08j0MqQijpu2t6
         0dGadW4Gzsm51HrvR2oo8+MqruM1U3pnGxy1ZbursCRO8FmD2vVFK0gDfzfdcKcq2uy5
         S6oA3ReXZaaUWH/gOH6IjaeJrfovPWEzUNenX3B5NQMAWlDDzxyOsIzkfh6ARs7NTGSQ
         SrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EMwDXgwXoXF7SJJC/qZQx+iamVJ9IAoHTJ7NZ/HN9Rg=;
        b=HzOo5LvS2GAj7hCktajK9QnvbZRUCvH3XI+GHtkxil6HjK7aLZgqAOxmyvS5h4NV5J
         ixJvXqF5vHnAl1nA0l4W8UDMaJ192zI1uLdsFGwt37vrT0vkcf0kPkEKYl3ZO21OmJ34
         FzEM4fFno3LbNlreNIGSUtnp1xOznldgO5zFKH8TZfWfUjfuiVxG+i9QzVVN4RC5u5rF
         lbsErQeWylPS2YcuHVnNAdG/Pj8pFKinsPQ+L76ZBwWc5YXSDNeSWBVLGCBMev6OIKvc
         YE0FhJIA4mJMTS97PceEGxUE2bxyF0no/pvuqcX+R4kBspUudZUJMoW71pXRHeC7K8R4
         dDMw==
X-Gm-Message-State: AOAM532MUBS+A5CKz247u+7BBsMaprpWbnTPK+q5pfjvN1SVL7DlKmg8
        ohMgAAz6OVS9rwdQtS7tNYg=
X-Google-Smtp-Source: ABdhPJzf/mtylGR9H7OXHgXyEYtkQIu8ODpYpJhH8ktzgNAVJNgMBOcY2jB1Jr6KEwTxvCPupIWX6w==
X-Received: by 2002:a17:902:70cb:b0:13e:91f3:641a with SMTP id l11-20020a17090270cb00b0013e91f3641amr5143051plt.13.1634221340379;
        Thu, 14 Oct 2021 07:22:20 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id b10sm2987437pfl.200.2021.10.14.07.22.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:22:19 -0700 (PDT)
Subject: Re: [PATCHv3 net] icmp: fix icmp_ext_echo_iio parsing in
 icmp_build_probe
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
References: <31628dd76657ea62f5cf78bb55da6b35240831f1.1634205050.git.lucien.xin@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <16bd32a3-b716-0a83-3983-85f4a6468645@gmail.com>
Date:   Thu, 14 Oct 2021 07:22:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <31628dd76657ea62f5cf78bb55da6b35240831f1.1634205050.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/14/21 2:50 AM, Xin Long wrote:
> In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> step by step and skb_header_pointer() return value should always be
> checked, this patch fixes 3 places in there:
> 
>   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
>     from skb by skb_header_pointer(), its len is ident_len. Besides,
>     the return value of skb_header_pointer() should always be checked.
> 
>   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
>     skb_header_pointer(), and also do the return value check for
>     skb_header_pointer().
> 
>   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
>     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
>     then check its return value and ident_len.
>     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
>     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
>     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
>     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
>     sizeof(struct in_addr)" or "ident_len".
> 
> v1->v2:
>   - To make it more clear, call skb_header_pointer() once only for
>     iio->indent's parsing as Jakub Suggested.
> v2->v3:
>   - The extobj_hdr.length check against sizeof(_iio) should be done
>     before calling skb_header_pointer(), as Eric noticed.
> 
> Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks !

