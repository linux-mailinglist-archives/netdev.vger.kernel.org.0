Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978944CDE4C
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 21:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiCDUJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 15:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiCDUIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 15:08:06 -0500
Received: from mail-oo1-xc2b.google.com (mail-oo1-xc2b.google.com [IPv6:2607:f8b0:4864:20::c2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C2B220
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 12:02:40 -0800 (PST)
Received: by mail-oo1-xc2b.google.com with SMTP id h16-20020a4a6f10000000b00320507b9ccfso10645358ooc.7
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 12:02:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QUEYDFyyC+RIbJrZnqUZK2Xoo2z8a7MkfFmMZjEgUqg=;
        b=ZD2n+4IfHYDSkTnoNyHXEo8vImwlu1uOID9NQsEQW+JGAz574LgGjHBSSpLZQ0k2Fj
         aBFWNIFnLpjGrEJWuVMuEoK17h53uTIB7lE5DQo5tJOv3YtD72hFvCWLRFRTpbnFGT9G
         IVO53dut+WTRph7vjWEwgRH6L0ZxHYcGkxG9zL62JBI3tWxKl4MdZMVyYIjlODJGv4FW
         Z0qBYGSltVsVypPY8M9/SBnymjX9e2lG3h/4MAIjW+25+aIEDRl0467pvJM0WN82D9VM
         tG2cplkch4jvIZpeyNTUirtsP81OlvpIMUTYmJEE9uV5GdJoSIdB00ILVNmxKpssjbCg
         aMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QUEYDFyyC+RIbJrZnqUZK2Xoo2z8a7MkfFmMZjEgUqg=;
        b=EfIRk8toJPK/KThD6q7jE6sT4OqxQY+Kz+EiQ38bqq6RfIchsvfX1Pa2iRPSdda0CO
         GGWHQujpeVWdT4SHTPrLe2kpz5dTEFe4nIP0EvtA4SibSenj//0TXvG7jfADmmfUwiEP
         f+AlykV4l7YYmBbWuuL0EMI9xYSA7uL259mTMCwfegzEN29BbeK7MPtqJdz3lvnpsH1x
         NF7a7WWCSN0k2YQO3mwSrh5gCIwzzN5z92awGoqTQF8kmGpz+hLbMUj96lO8qqkpJOQm
         99jRlIRrYvGVEOSIfYPD8t5NtlFcQEG38emaOTzG3p2CIkkWOkUGMaa67liHi+E1KKEn
         KqXg==
X-Gm-Message-State: AOAM532zM+I93JTnhuTvzDaj0wL0ZbltLGxWuEhjX/WFw4xW+zAsUm3c
        63B4stMG4u4iyai5DG2n0r+WelQRN04=
X-Google-Smtp-Source: ABdhPJz9IRDtbDrfKKmRvPqUsHCpfrlSjc0xmLO4gTwIS4+mQbNFuNQBUfP0doSNutSjPBR5Z6t3Bw==
X-Received: by 2002:a17:90b:4d8e:b0:1be:f5de:be3e with SMTP id oj14-20020a17090b4d8e00b001bef5debe3emr191465pjb.148.1646421968229;
        Fri, 04 Mar 2022 11:26:08 -0800 (PST)
Received: from ?IPv6:2001:470:b:9c3:82ee:73ff:fe41:9a02? ([2001:470:b:9c3:82ee:73ff:fe41:9a02])
        by smtp.googlemail.com with ESMTPSA id bd6-20020a056a00278600b004f68f9fbbd5sm4751868pfb.129.2022.03.04.11.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 11:26:07 -0800 (PST)
Message-ID: <3e50ceabe3f1ea4007249afb6a30bda8996884c7.camel@gmail.com>
Subject: Re: [PATCH v2 net-next 04/14] ipv6: add struct hop_jumbo_hdr
 definition
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        David Ahern <dsahern@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Fri, 04 Mar 2022 11:26:06 -0800
In-Reply-To: <20220303181607.1094358-5-eric.dumazet@gmail.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
         <20220303181607.1094358-5-eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-2.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-03-03 at 10:15 -0800, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Following patches will need to add and remove local IPv6 jumbogram
> options to enable BIG TCP.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  include/net/ipv6.h | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/include/net/ipv6.h b/include/net/ipv6.h
> index 213612f1680c7c39f4c07f0c05b4e6cf34a7878e..95f405cde9e539d7909b6b89af2b956655f38b94 100644
> --- a/include/net/ipv6.h
> +++ b/include/net/ipv6.h
> @@ -151,6 +151,17 @@ struct frag_hdr {
>  	__be32	identification;
>  };
>  
> +/*
> + * Jumbo payload option, as described in RFC 2676 2.
> + */

The RFC number is 2675 isn't it?




