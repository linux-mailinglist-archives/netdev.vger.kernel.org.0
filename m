Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D08662486
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 12:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234044AbjAILqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 06:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbjAILqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 06:46:17 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96415A467
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 03:46:16 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m21so12111516edc.3
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 03:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D+muiZeRodWSdkGCQbmoSfuYJGII8UbIeUoLS/b6C+I=;
        b=Ko611mylRP+u+n9GKoJjXB5WjWuyXhCN6znGhD3ifhT+bb3P66tvUnW92lps9qIrVv
         wsIRS3bP0+GFLE8GKK4U623KGsd4Spe9MMCitcgWinq019sms/afeUIEdlao4Spaft9k
         wUC4oFoRROEkHlPvUnxSj+bCsJTkBfh6GQ2MkoUZIp9oDn6iuNitXywxtfvloRXon9Sn
         gviMd2axNbEt5P0hGP5NssEY8Yp5SGA+UmkWfvSHVWqe9ZOw+uMMR8QUnUoFzdTCGiwX
         zshF9n0jmLgUpbm4CTuyUBq4vy3dYsErtmslQUsZ/Cy8tS972SGVOHfiMBaqC/aQedgE
         SLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+muiZeRodWSdkGCQbmoSfuYJGII8UbIeUoLS/b6C+I=;
        b=UnJ5ZsoV04Dizk2nJ7SeHh+DtqeRpDFda8mD1Q+dsp+8T36YYpLZdL1geMmDd+N086
         26T7BjFwfT2DZtQyPQvP6REWrcCxr9gU9b+eFwiyB+pEczFRGok40RUGiwQMPqtDL3BZ
         T8S5fYGX9LObT6t2YnB+8j7peD9hek3BcwYRAUvg2f7QEgF3v7Pc+XO9T6YLn/+7FoEo
         IX7eHZKl4HU/bpoC4pdlC7kfpmrfVwW600iv4yc9PoCo02CKPkrp3vrv3tEGZfI0NTdJ
         ZK1gf6kGzOdXL4N3X0ZTXT5+6MYrX1c///4WfIiNkS0nrjP+5Quz0ak25r9miWbTcbo4
         iQ4w==
X-Gm-Message-State: AFqh2kpt34XWwUSN257NT+Q5/jLgIDoNXEvhMpO2/raXnLUPgZDz8f0d
        qn8YSg8SIC9G59LvuMdVCGw=
X-Google-Smtp-Source: AMrXdXsvpl54//VKNGLg1WYd0fr576hTC2kKgjV2gAQCjdqSWcucTid0NkpQ/sdfp+n2SPm7wT43ww==
X-Received: by 2002:a05:6402:b31:b0:497:948b:e8 with SMTP id bo17-20020a0564020b3100b00497948b00e8mr7710306edb.6.1673264775197;
        Mon, 09 Jan 2023 03:46:15 -0800 (PST)
Received: from [10.158.37.55] ([193.47.165.251])
        by smtp.gmail.com with ESMTPSA id u9-20020aa7d889000000b00457b5ba968csm3644898edq.27.2023.01.09.03.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 03:46:14 -0800 (PST)
Message-ID: <3d2db7f2-9e3c-929c-de41-c3f0011839b8@gmail.com>
Date:   Mon, 9 Jan 2023 13:46:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 24/24] mlx5: Convert to netmem
Content-Language: en-US
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>, gal@nvidia.com,
        Dragos Tatulea <dtatulea@nvidia.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, linux-mm@kvack.org,
        Shakeel Butt <shakeelb@google.com>,
        Saeed Mahameed <saeed@kernel.org>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-25-willy@infradead.org>
 <6ebfda57-3a01-7fe2-4a95-65108a02e887@redhat.com>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <6ebfda57-3a01-7fe2-4a95-65108a02e887@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 06/01/2023 18:31, Jesper Dangaard Brouer wrote:
> 
> To Saeed and Tariq, please review.
> 

Adding Dragos, Gal.

Hi Jesper,
Thanks for the ping. I'm on it.

> This reminds me, that IMHO we/nvidia/mellanox should remove the local
> mlx5e_page_cache functionality, as SKBs can now recycle page_pool pages.
> This should simplify the driver and we get rid of the head-of-line
> blocking issue with the local page cache (refcnt elevation tricks).

Totally agree.
Dragos is currently working on this task. This should clean up 
significant amount of code, and improve performance. We target this for 
the next submission window, to kernel v6.4.

> It might look good in microbencmarks, but my experience from prod
> systems are that this local cache isn't utilized.  And I believe we
> should be able to get good/similar microbenchmark with page_pool, which
> will continue to recycle and have no HoL issues for prod use-cases.
> 

100%.

Thanks,
Tariq
