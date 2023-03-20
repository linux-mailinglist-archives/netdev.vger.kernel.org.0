Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AFA6C124F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbjCTMuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231663AbjCTMth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:49:37 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B782928E98
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 05:48:36 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id y184so8576852oiy.8
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 05:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679316511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Fcx8zHn7vnihoLcNQZse4hBV2XpUbxRmx3d7IUCwBSQ=;
        b=tu+ibtZKnEPH+JHSMCKAsWM61fKt0D5vM19xv53GSCVp9tx+HzEnmzGmeAIqkKcpPZ
         QxuTbmkpYUue1q91kb91gdHLcMkhD1njuM3TUCDakGHO18N59AAFg8ou5ot7R6GsORz4
         0+yw1KeTE08BO3B01gxkOiRrIY1x4ZqfUasuczW8nTQc02nxFjfgcVQqXjMeTmfjM07L
         Pc2Ubp9PUl8apTe0LiiJ5j7gGECX31PewVLAsHLApfs9AyaabOkBkSvOvc4wSKAAvLST
         NnHU0MwjELqbfo3YN22w2aXZJ0qB4Z9/LceTULiReDepOEN8uchJB9VRPu1vOIF53sd/
         ucNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679316511;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fcx8zHn7vnihoLcNQZse4hBV2XpUbxRmx3d7IUCwBSQ=;
        b=MUb+lZk+6tINmzXc/dy3/Ghe4606WY2lIGfTfFlZIRFBkUgCLdFCM+qqpz1OObJXLI
         oqQwT+tqLiGJQUZQaWGJPXyd+NwXCQwc51gZfYX1LZo3+QhKd389o5vHB+6wcMtv3KOO
         WuxPev5SA3DnUY1KwA/QyxmRas1vDjA92Kqf2A1gjopnxTa8p6TYMqmv3sCkRdM6uhnD
         VDVzR1bVgdUFK/EuAQ7JFoG5qSH2wQBkXYFZiI0MUIhLO6SpywckR2M5nbm5m4YtFiOP
         3jKRPozrEBLTi2isN+9jDVTfDLKqBUd98UuO7CBTL6qk8VUz0BK/xkBDrIjny4y+nRxn
         +gCA==
X-Gm-Message-State: AO0yUKUpnTiuiOBQsaE43mLQS178FPZU8UIQNCAbj7A2fAiKzN8i2w0U
        Qk4GSFQkKxf1WfqtfM6Wub1SQlwJHUKL1q1HeeY=
X-Google-Smtp-Source: AK7set9NLbtbJRkDgf5ojSc26JPFeI7aGlkj4mGIcSPl5tNg7sOOSQJZM9UyhHhROgpGhZY670aogA==
X-Received: by 2002:a05:6808:158f:b0:386:a87b:ec2d with SMTP id t15-20020a056808158f00b00386a87bec2dmr10886206oiw.49.1679316511447;
        Mon, 20 Mar 2023 05:48:31 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:5aa4:fb5c:879b:205b? ([2804:14d:5c5e:4698:5aa4:fb5c:879b:205b])
        by smtp.gmail.com with ESMTPSA id a7-20020a056808098700b0037d93a7e8f6sm3630357oic.54.2023.03.20.05.48.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 05:48:30 -0700 (PDT)
Message-ID: <3afae398-4a82-0f59-794e-70bacd5f08dc@mojatatu.com>
Date:   Mon, 20 Mar 2023 09:48:27 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 2/2] net/sched: act_tunnel_key: add support for
 "don't fragment"
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org
References: <cover.1679312049.git.dcaratti@redhat.com>
 <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <13672bdb258d2f261ef233033437f1034995785b.1679312049.git.dcaratti@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2023 08:44, Davide Caratti wrote:
> extend "act_tunnel_key" to allow specifying TUNNEL_DONT_FRAGMENT; add tdc
> selftest that verifies the control plane, and a kselftest for data plane.
> 

I believe this patch could be broken down into 3:
- net/sched change
- kselftests
- tdc tests
