Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBAE6932D3
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 18:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjBKRVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 12:21:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjBKRVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 12:21:43 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2D51B1
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 09:21:42 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id k13so9765116plg.0
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 09:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XkGNGpDxm3vtLl5RCkD77UkR9lhE9xvqqTK+C3943pU=;
        b=BZOaiE+A22IL8Q20ifQZ+QJcc6iiwCUC+qfzfuRlAsmcBCWViC91lE3hGe+nySNk48
         sB2ZqNT9D126RNkt/gxoDGPdzZy7/HZ6msEjArDGYVCEZZxqqPm1q0HN1djHNhl0Ayq/
         cU47PAVOd7P1dmFWn9HvWUjDLUBTyy6MWngNw7oHHeoQBWNzLKcXVCpkNM60obP4QL8x
         sDk18dHdndzx55sapgp5ZONvQIksEgXeVecrGHCBly7+5dTFLrDaf5TwdPjPnLZsd5Zd
         365YS4zpazKMFtnq/Gsg6EmHTCegMm0YEgsC4df0l4oCVY2j8CZjAjz7CjaEE9b1bk0c
         57JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XkGNGpDxm3vtLl5RCkD77UkR9lhE9xvqqTK+C3943pU=;
        b=ApJBWlQw0c4ATNEXbqsAFb5ELayMXEym2OPoA6GPfzldp42LUij+xfLM7nDiWzC+1Q
         ioc9Pd2pHdGoSj5gNNHOaELhauDyw33P+RsE/vg1wu3eKIUvS0msyADRj1zQfmWqyZzc
         Kt7TORkcwtUW0PMsD600fmO1ESU+94fxzc2BYGxRLyiDSmvDbfCvnnT5l6epEui8tNqP
         QO1DiPikw7Wz9bQs/dP5JxoTso9s5XAVgb8Z6xheWxVa0s5igZ+Xk97yJl88v0D3nLhM
         LbyZag4f8Bw3CrtySaBMKO3oH0Ma2HYQQkKCFOEbcvmNX9k6qJ7SOtJq76yk56s9D4EC
         Y4nw==
X-Gm-Message-State: AO0yUKXHPcp8aHbj8A04/oE19POPAfTT08j0Du4lapxLBG6uShVFSgX4
        Z7kU/VUZevXQvrXoRqzBVKrZSw==
X-Google-Smtp-Source: AK7set/1PpTWnkSzC8KxBCHDl+PdCRZlMjJp9+LplBZQA4QFHeb5wWMzXuA5lICuJrtKOg5cjJUwAg==
X-Received: by 2002:a17:902:e385:b0:199:4d57:63a7 with SMTP id g5-20020a170902e38500b001994d5763a7mr10068313ple.52.1676136102243;
        Sat, 11 Feb 2023 09:21:42 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id b20-20020a170902d31400b00194706d3f25sm5228765plc.144.2023.02.11.09.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Feb 2023 09:21:41 -0800 (PST)
Date:   Sat, 11 Feb 2023 09:21:39 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH iproute2-next] tc: m_ct: add support for helper
Message-ID: <20230211092139.5fb1078e@hermes.local>
In-Reply-To: <ab1e6bfbefff74b2b4fe230162b198c38cf5b394.1676065393.git.lucien.xin@gmail.com>
References: <ab1e6bfbefff74b2b4fe230162b198c38cf5b394.1676065393.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Feb 2023 16:43:13 -0500
Xin Long <lucien.xin@gmail.com> wrote:

> +static void ct_print_helper(struct rtattr *family, struct rtattr *proto, struct rtattr *name)
> +{
> +	char helper[32], buf[32], *n;
> +	int *f, *p;
> +
> +	if (!family || !proto || !name)
> +		return;
> +
> +	f = RTA_DATA(family);
> +	p = RTA_DATA(proto);
> +	n = RTA_DATA(name);
> +	sprintf(helper, "%s-%s-%s", (*f == AF_INET) ? "ipv4" : "ipv6",
> +		inet_proto_n2a(*p, buf, sizeof(buf)), n);

Please us snprintf to avoid possible string overflows
