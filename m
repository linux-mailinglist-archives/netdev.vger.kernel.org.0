Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52A9A434159
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhJSW3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbhJSW3E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 18:29:04 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B88AFC061746;
        Tue, 19 Oct 2021 15:26:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id b14so4938689plg.2;
        Tue, 19 Oct 2021 15:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BdCMwQCN9+U5oBdVEb/4osn9WpevRcSTgk8gC0nOO60=;
        b=WtEzNtW3fhldK05cJTK8FR/FS9DO+gORfFxowz+Lahe3G6A/qjmOTuBRGihvJ7Y+p4
         0KKHUTBCkrO9NtLjtGeti58qSz/g/S9kLlxb3Mn7a2ci2oSUiQjAjSJZ9SOMf0kxU6UB
         UCJEMLyVFWrP1WU10dozXkXjY+EccsCjfR4TKgRsmqLr+pRCKGrte4UrSAXF6wFiyWQZ
         95Zwk6sQRs5Kx8+EPi69nGTPST5XReWnpAow8GTYFJVRDsA7/gac5l6z22NOvfY38Em5
         VQv25g/i2pw+/bLXQ2DRVDL3tenuCeg7kaKziAN2xDdCPudBv8g1Vc85oIc01Pdlz+xl
         BDyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BdCMwQCN9+U5oBdVEb/4osn9WpevRcSTgk8gC0nOO60=;
        b=y3RoAGX0M3jhIyKMg+jzQKRy/eGNP04ruS2NoJDno1Ojn3UqrQtAeZ0Ngjna/zavqO
         4kA0VcqWSnN/D2Gxt/1O/Uoszui4yPhdVk2CrI1AOaiJByQLYU9MVokthbktH0ifKJmX
         kD/GaQ+wSP6ozQjpWf6AiQh+BcbtJOqJYkhseaXDMojjgSuwX5va//VjniX1Vp1BisNR
         Mre+ZPyMNfcZG1BNXf1+msa9hH8xYFnt3gm2+hGy1QOnmPMPWrGDg5WHt9Vdd7gV8Ap2
         AstV7tJFg0KX0BHIBqBbi+WQgU3fEcHxQPlJaQv6AH4YvinkvORYsmw807QnLd/b38El
         b8YQ==
X-Gm-Message-State: AOAM533+HSgRg7dSdfir3SR96UJHH9BLKlbdO44/CD+njbuQbCUUv4oY
        1CdTvWABsqE4jznLXaaU8BQZqkqSQLc=
X-Google-Smtp-Source: ABdhPJzq0rargeLgvEqyIsNo3acgex1TsP+CNKZw80xGUkCXr9gTsB1IRB/Jf9TWKvmJHxejIXwxAg==
X-Received: by 2002:a17:90b:3850:: with SMTP id nl16mr2774066pjb.127.1634682409986;
        Tue, 19 Oct 2021 15:26:49 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:554e:89d1:9693:8d66? ([2620:15c:2c1:200:554e:89d1:9693:8d66])
        by smtp.gmail.com with ESMTPSA id k1sm151761pjj.54.2021.10.19.15.26.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 15:26:49 -0700 (PDT)
Subject: Re: [PATCH] [v2] net: sched: gred: dynamically allocate
 tc_gred_qopt_offload
To:     Arnd Bergmann <arnd@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Zheng Yongjun <zhengyongjun3@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211019191544.3063872-1-arnd@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d49b4b0f-d1d9-fb24-0ffb-660c666c8a28@gmail.com>
Date:   Tue, 19 Oct 2021 15:26:47 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019191544.3063872-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/21 12:15 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
>  
> @@ -754,6 +759,10 @@ static int gred_init(struct Qdisc *sch, struct nlattr *opt,
>  		sch->limit = qdisc_dev(sch)->tx_queue_len
>  		             * psched_mtu(qdisc_dev(sch));
>  
> +	table->opt = kzalloc(sizeof(table->opt), GFP_KERNEL);

sizeof(*table->opt) ?

> +	if (!table->opt)
> +		return -ENOMEM;
> +
>  	return gred_change_table_def(sch, tb[TCA_GRED_DPS], extack);
>  }
>

