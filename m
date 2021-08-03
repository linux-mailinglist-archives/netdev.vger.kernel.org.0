Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC093DEB8C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235254AbhHCLGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbhHCLGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 07:06:06 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1F2C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 04:05:54 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id z24so19422167qkz.7
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 04:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Mk1pek9+7JlZmvaTGOAEgta5pjg81xwgfs8lwXrqNzY=;
        b=PmFkcw3lioGQy+uJ0ixzSQbKcnyLQqu/mqQ++e9wsaIS15v2x/A9+95swZ/X6E2Hj1
         vekSK/QU+BCYBNvnyYoSL0kYuM2H6oLko3L01pYiS6OEgU8qwsOPbI2Ldm3NJ0mGyPL5
         kF0y2klyGOO3SL8/DtUGtj2e+Fg612PSD0GEn43+8N+9OkPkG0C5iglOSmE+PzSpt9W+
         EVR5EtR/swSp4BT35zVnIvImDvtKuJalwHx2QIzOBebuNKqjlN6obJIIJT8SUF2OToLy
         NlbszhteGVtQwI/8T3+hkQHisJZAMI/Ij/g/QTAXNXs4JbIHY+/RGYja/2Yu7e6CbPtW
         YuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Mk1pek9+7JlZmvaTGOAEgta5pjg81xwgfs8lwXrqNzY=;
        b=q6BqMRP8WTzqYe0PUV52jpUvN4IyZpMBggV411yJS2GAWn6oV5rW2a1F4usIv98s3J
         VjdE5qD8gw/mBKeFggFjXpYtt/+0zkqjz/yzP9yTaTXfauX9QDi+TzV+QNtoPnCOfZs7
         Sb4tz0QxhMwxdzmabTCwqrsYUkitbhab5ad634Pg3I+peXoOYQdnVvHJjY4bg8+BT6m/
         YykCbIZBVd8mWHudDp8xw+WshlRW+Pm0S8gd3uBj1cx4ltwyhZtSqqroybcZffWfE3Yg
         g21w0QQDbV9LaGxX7HaoGxn42YGQmACMg1dkOPch2KlgINcFVOxqNYZTrcBK8pI6OU6k
         tpGA==
X-Gm-Message-State: AOAM533kuDnpbqLlnlRa8UAZ2w2u1bUnve0KqXWVQmgfxg2SsBOBjRfQ
        6H9F7PeUJXBsJmTww16D+jXg8Q==
X-Google-Smtp-Source: ABdhPJwRRe2iK6SiWKuzpdMDkjJoKis4RycWMMpYzcBEEorXaKK3ETTNihgRltoykflzKsaMnRdEmQ==
X-Received: by 2002:a05:620a:56b:: with SMTP id p11mr19760736qkp.66.1627988753709;
        Tue, 03 Aug 2021 04:05:53 -0700 (PDT)
Received: from [192.168.1.171] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id t20sm5936036qto.95.2021.08.03.04.05.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Aug 2021 04:05:53 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] flow_offload: allow user to offload tc
 action to net device
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
References: <20210722091938.12956-1-simon.horman@corigine.com>
 <20210722091938.12956-2-simon.horman@corigine.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <5e1689de-0448-e4a7-9714-86189549ea69@mojatatu.com>
Date:   Tue, 3 Aug 2021 07:05:52 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210722091938.12956-2-simon.horman@corigine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-22 5:19 a.m., Simon Horman wrote:

Triggered by my observation on 2/3 went back and looked at this again to
see if we have same problem with notification on REPLACE case (I think
we do) but here's another comment:

> +EXPORT_SYMBOL(tcf_action_offload_cmd);
> +
>   /* Returns numbers of initialized actions or negative error. */
>   
>   int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
> @@ -1514,6 +1544,9 @@ static int tcf_action_add(struct net *net, struct nlattr *nla,
>   		return ret;
>   	ret = tcf_add_notify(net, n, actions, portid, attr_size, extack);
>   
> +	/* offload actions to hardware if possible */
> +	tcf_action_offload_cmd(actions, extack);
> +

Above seems to be unconditional whether hw update is requested or not?
The comment says the right thing ("if possible") but the code
should have checked some sort of skip_sw check?

cheers,
jamal
