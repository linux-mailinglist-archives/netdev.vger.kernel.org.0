Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2C34D1D50
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243420AbiCHQg5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:36:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiCHQg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:36:57 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D9F473AD
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:36:00 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id x4so5594238iom.12
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 08:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YM162oYLI0X6oafHr/qKwyiO+M+SlovCfLNKyqIoWZw=;
        b=Im4rZcuzFF5XMOq7GitUWQseUbSriVxKzflZmLzUjSeCsG+e7FqzF4eIOouQCbdznr
         WUDXW3ajO9X1gx6AqujlPppx2pnXSp5ZmNmnbGQGZd7xI1ku51yCXYujgm3l/Hi9YNlL
         A8M/me8O3IpXL558wjzD5bcWyfGzZozaOn+FyihqcOMZbOguTcdC331Btq0ZFy2SrB9g
         Opw5751PxMsQnjWE3nvT98DgI3Vj6pzfXbZjU1zJ8AVzIkSJVRQ+Ew8CIx4AQX7igEMg
         s6Pw4mafjnpR1t6TQ/7kZSdRiF8xPJjibakBEi2tmmS8bH7lXQUL+QOvu0MIPOsXSvMD
         5Tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YM162oYLI0X6oafHr/qKwyiO+M+SlovCfLNKyqIoWZw=;
        b=ZcshzvzrxK5cnpl33LV+ZU7jlgLzIV38RxgxUk4OrUP3UU6wPBw6y5dg2UQaCzOfeu
         Qrw9lqHkcm2PDcfMkA27Pwgld7Rz7MIXA2JK1jm5zhhn+Hg2/akiOfpe+bwuSACIog26
         eM/AYcMwuXif84GjdxV8AdfIiFtgUPuqx8j8InG+0cCWyHfUNaMc8UDBh5Kssm9T6YZ6
         qllcEdQ/kah0L13q5EYOj/y7yfNqsEfGCPoDUm8HDw8bmihuF/cuU2rWPeKZrNIyp4p3
         ZN9bch8Co4L/Vlwj+qUTIzMGT1zQ+232WVMrDWc18uiMzyVsi+KuwheAEQZM+Lajpjjz
         h4wg==
X-Gm-Message-State: AOAM5329bCs8i+TdBQf/qN4dcAiC1aT+GXcyID4wAPP9J9cL4uITavzB
        NNGvndb1ZThkAHTWceGWpK4=
X-Google-Smtp-Source: ABdhPJySzaa+tibKXMwv3ZSXYbAG/H1Cea1LNCl+wA6LlreLEQIW2kXF44wYpzKQMxdKfQV+XA+RwA==
X-Received: by 2002:a02:19c6:0:b0:30e:e6a5:67ad with SMTP id b189-20020a0219c6000000b0030ee6a567admr16329796jab.45.1646757360132;
        Tue, 08 Mar 2022 08:36:00 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id q7-20020a5d87c7000000b0064132d5bd73sm10572210ios.4.2022.03.08.08.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 08:35:59 -0800 (PST)
Message-ID: <8572666c-ec21-35d4-b147-d4f09851107f@gmail.com>
Date:   Tue, 8 Mar 2022 09:35:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com
References: <20220308004421.237826-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220308004421.237826-1-kuba@kernel.org>
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

On 3/7/22 5:44 PM, Jakub Kicinski wrote:
> We have a number of cases where function returns drop/no drop
> decision as a boolean. Now that we want to report the reason
> code as well we have to pass extra output arguments.
> 
> We can make the reason code evaluate correctly as bool.
> 
> I believe we're good to reorder the reasons as they are
> reported to user space as strings.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> v2: use Eric's suggestion for the name, indeed better than mine
> ---
>  include/linux/skbuff.h |  1 +
>  include/net/tcp.h      | 21 +++++++++++----------
>  net/ipv4/tcp.c         | 21 +++++++++------------
>  net/ipv4/tcp_ipv4.c    | 12 +++++++-----
>  net/ipv6/tcp_ipv6.c    | 11 +++++++----
>  5 files changed, 35 insertions(+), 31 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 34f572271c0c..26538ceb4b01 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -314,6 +314,7 @@ struct sk_buff;
>   * used to translate the reason to string.
>   */
>  enum skb_drop_reason {
> +	SKB_NOT_DROPPED_YET = 0,
>  	SKB_DROP_REASON_NOT_SPECIFIED,	/* drop reason is not specified */
>  	SKB_DROP_REASON_NO_SOCKET,	/* socket not found */
>  	SKB_DROP_REASON_PKT_TOO_SMALL,	/* packet size is too small */

This change looks ok to me, so:
Reviewed-by: David Ahern <dsahern@kernel.org>

I am a little nervous that some of the earlier code with jumps does not
properly do 'if (reason != SKB_DROP_REASON_NOT_SPECIFIED) reason = ...'
but rather 'if (!reason) reason = ...'

