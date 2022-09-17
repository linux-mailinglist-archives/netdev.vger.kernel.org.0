Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14E3D5BBA0E
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 21:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbiIQTDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 15:03:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiIQTDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 15:03:05 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F4821E1B;
        Sat, 17 Sep 2022 12:03:04 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-12b542cb1d3so46897179fac.13;
        Sat, 17 Sep 2022 12:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=/CA0DZFOBTe2bIkUfL6y8/0s4OgPKz53/VylkkHM6J8=;
        b=hZn0P24U7A75jwYF2jztQhU7BiCbsggB+ovMi/R7Ymr2nswK4rkSHoi0ThiWMXhSBT
         aoT0Cj5KkL05sNf2WHXlbM0vHC/KHnwIhs7ZBU6RBO/4i/RRdK0LqMBz0/vU4mfgNdIU
         J7POWYZd0hMjh9veBBGgRXY0LHtbY8qHxGG7AUVYvy9YJ9fPjNYbbTzMKQQTh5Ginpbp
         JI+Dk1hiEadZU0KuLGwh2rZs1OTb7RmsJMTwlGFF+rqUJtQ/l8AqDCKQjxgxhbh1zpFo
         rpRDZKV6sZD5GcQxDpLAchfzkrXvhF81MZ7EV5FwzZk/DQvWHTUG37OIg6Oc7byasvZp
         6ppg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/CA0DZFOBTe2bIkUfL6y8/0s4OgPKz53/VylkkHM6J8=;
        b=UEq8WRKA3NmdLimteshEIzBhLzUygpF8dBcLJUFZ1YGWQrHdUg3kfxyHch6306MxSq
         pjVXNh6kW8vT+k9HoUCLxeOf3tUEzWYfr2ZKNWh3ClyGkwhh1cpA+Cj+anbgvgAqE3/5
         Tea+DQvX/Bn4RlG51uI5Mfm77VzdsQF2ru5svB7S+i8gWOJ0i9v9xwx1NOV/m3jZL6B9
         4QrUjuE2R6yHgbskST28awF68piWbc+ByTrQrinFonWNFa+wA8gNncwmlfjZM//enejW
         j04Nlo8CZ9eEDMngm9EyHS2WBy0RshgABWIIblZE6/9xoEjmJwWJyzR7VjVgXVsf4maz
         Nw7g==
X-Gm-Message-State: ACgBeo24uds4GGLLo1ffYZODwXd8QMCCH9V1UdrMVDvrClxE3pNIa6Fp
        s0GRXUChu/VJCuOPY06nJck=
X-Google-Smtp-Source: AA6agR4FF8/jOYS8VDJOqNJG3G33Pu9v3u5KKXZ71Ek3ultEJnBtFT+C1F4htCVwjW+M8tHE/pZ88g==
X-Received: by 2002:a05:6870:f6a8:b0:12a:e852:e05b with SMTP id el40-20020a056870f6a800b0012ae852e05bmr11478917oab.15.1663441383539;
        Sat, 17 Sep 2022 12:03:03 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:6d86:ddfc:9db0:2ba])
        by smtp.gmail.com with ESMTPSA id m20-20020a4add14000000b00443abbc1f3csm10490166oou.24.2022.09.17.12.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Sep 2022 12:03:02 -0700 (PDT)
Date:   Sat, 17 Sep 2022 12:03:01 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jhs@mojatatu.com, jiri@resnulli.us, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [RFC PATCH net-next 1/2] net: sched: act_api: add helper macro
 for tcf_action in module and net init/exit
Message-ID: <YyYZ5cKm5TiuKBgv@pop-os.localdomain>
References: <20220916085155.33750-1-shaozhengchao@huawei.com>
 <20220916085155.33750-2-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220916085155.33750-2-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 16, 2022 at 04:51:54PM +0800, Zhengchao Shao wrote:
> Helper macro for tcf_action that don't do anything special in module
> and net init/exit. This eliminates a lot of boilerplate. Each module
> may only use this macro once, and calling it replaces module/net_init()
> and module/net_exit().
> 

This looks over engineering to me. I don't think this reduces any code
size or help any readability.

Thanks.
