Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD8A7502F47
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 21:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348044AbiDOT2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 15:28:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244878AbiDOT2e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 15:28:34 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5DF617A
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 12:26:05 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id h5so8264481pgc.7
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 12:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vypcaUmZPYy5wV842v9q6uPqI+NkvMzRjNoH7IlR8ys=;
        b=5JckFVUL9mNLmVqFgOQeCamHHseqaVQEDHKeVf7AiMMNVLhrFTgJMFqUHSx/YnSuaW
         lHdnol8ock9ECau3zJNI3i7gitUYgrUrw3ZwRIW3Smu+P4K9+4GVkkkLo9hqArlB2VMm
         9Q2eFo28vA/UivwbPRGC1fbN0zFojj7oEAOSQRoxppVS1rpxXqYB54j37DBvgW145sm9
         liz/LhjArzsNvmJZKHw7iq7gO0FrRcoh9AJaU/lrzQ3pdAxNO2rQqTo05/LaqFVdsH8C
         yNlq36guTV1QVJpyGLPe3bvUNJTsiC96Gy0IENfWoV7Ge41TbKD/OQN3tYbJJmaKQRJO
         NDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vypcaUmZPYy5wV842v9q6uPqI+NkvMzRjNoH7IlR8ys=;
        b=c9ZeM72Z8HWOYGrz+HVnsImfVs4oEZQsibRXNjpprDQUE2Yjz7IHRgTqPmSg4MkC6f
         WTzK1lfFCzly8RPQSzRikgPFWjjgn/o/hLIu6KrdSsSpwt0dAg8qLczgp/Kgl+Ow80JB
         K/vTe955+p+2uj0qA0FiKPW7CyzTYzX8BJTpcM6X6bLe5S8RFesHO4+nodRhLZ0iE/an
         7NI8Ij0WGVjaTEErXJ/MsU+g5ykyeVRVJSoN0vRXHwWqj8O2hLaCkXbR3LaTos/7DfIY
         R/WaD1Yjm3w5rv/6KZsazmurswbdljJUhSEzfHD547Qiya9vd2EVFnk1BOur9NnveRf3
         NVBw==
X-Gm-Message-State: AOAM531Kq3nS3WL5v6cPm5QMt4rMksaDX15+nERFYuhvybjb7ijNXuZV
        SfL5dw2VG2atXkgDggxptmGnJw==
X-Google-Smtp-Source: ABdhPJwyFK51TbUH+aMhA45WK2jxFWuUXqBcX/yQZnr6b0DZPZQYxDv+ua5wjbslL+OcLZni2Wvq2Q==
X-Received: by 2002:a65:57cc:0:b0:384:3370:e161 with SMTP id q12-20020a6557cc000000b003843370e161mr413602pgr.364.1650050765010;
        Fri, 15 Apr 2022 12:26:05 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id bc11-20020a656d8b000000b0039cc4dbb295sm4863435pgb.60.2022.04.15.12.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 12:26:04 -0700 (PDT)
Date:   Fri, 15 Apr 2022 12:26:01 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florent Fourcot <florent.fourcot@wifirst.fr>
Cc:     netdev@vger.kernel.org, cong.wang@bytedance.com,
        edumazet@google.com, Brian Baboch <brian.baboch@wifirst.fr>
Subject: Re: [PATCH v5 net-next 4/4] rtnetlink: return EINVAL when request
 cannot succeed
Message-ID: <20220415122601.0b793cb9@hermes.local>
In-Reply-To: <20220415165330.10497-5-florent.fourcot@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
        <20220415165330.10497-5-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Apr 2022 18:53:30 +0200
Florent Fourcot <florent.fourcot@wifirst.fr> wrote:

> A request without interface name/interface index/interface group cannot
> work. We should return EINVAL
> 
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
> Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
> ---
>  net/core/rtnetlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 73f2cbc440c9..b943336908a7 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -3457,7 +3457,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			return rtnl_group_changelink(skb, net,
>  						nla_get_u32(tb[IFLA_GROUP]),
>  						ifm, extack, tb);
> -		return -ENODEV;
> +		return -EINVAL;

Sometimes changing errno can be viewed as ABI change and break applications.
