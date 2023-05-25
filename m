Return-Path: <netdev+bounces-5232-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A95F371058B
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 07:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E67E52814C4
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07D5D8820;
	Thu, 25 May 2023 05:58:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECECF8477
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 05:58:15 +0000 (UTC)
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B12DC5
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 22:58:13 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-96f5685f902so28177466b.2
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 22:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684994292; x=1687586292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oiM2VKsr6OFCD/kNIY8gUX5DW1dDVuIoVnnEoUMcNac=;
        b=MQ8VNA7U2ILZot0OVInIS2BNNhND2cKzp58WYDnebshLRAx/5oaWRo3FQh2BnFQCh5
         MEOFSeErB2Xn4vxqO7vYux3r68CC/bh2xBvcuNiroEyvT4iqbkmVaEzy+4I68bzZLtFn
         X4SoLEsS6/pz7XOXzaPQ1GsE0dN4H2dUJ9O4nv51ZhD1/q8ZXkVrCJIAlttjrexWnMuV
         thWNUCjwyyFdO8RmCpq8LVazTwujYBHRaRpB4Iv5zjCdsaYGnKQiDzkZAQRM+r7YFkhy
         rLomJOjF6f6Jw+E86qa03lIsxpf39yWRBbgsj0rrXmlsWlh6I4g6gr0KEYfQDGG+0OIL
         4cdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684994292; x=1687586292;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oiM2VKsr6OFCD/kNIY8gUX5DW1dDVuIoVnnEoUMcNac=;
        b=I+yktpqyM5hSaK9GPiN2RMKZ+9l6Pjx5xZs97x6AgtKEKguvWQRS8gAPUzjgMTmXbN
         zpVDhObN1G0fM66lB4nm3HbFpZa+Wen3SA5GGgY47o3XCmN+DVtgDW3ef/5zlZalNaXT
         xTVd5GCVMSxiB2lDU6DzQBGdUXTM+uEQQRbW21+Er7IBPH1AmJ2x3cjvXoPtSB2uXZ8K
         fZqajU/RbfnCtWLaUqQg8r0fRUKNWsZyVObFvQWiM/9+Knu2L9RP9QNKx1P6S2u37ogU
         lPS45fY6DIertE/UNgpX75P7Y7LNIeDU4tZkj57KczyeI8VeXAprtQTb3zVo5VRmzmuc
         c4uA==
X-Gm-Message-State: AC+VfDzJoaO5UMxLMPexCLhO87UH+fZAmaTK+pZLEZ0D4FYNIIeyz3oe
	N5h5wPsMdLWanBZorjmL3/0D5g==
X-Google-Smtp-Source: ACHHUZ7z4VIQIkErlaAmyoWrTN68sDGCmzzM/7UzFqHZHYlIHa/CD+NvWD49/6SRsZtQ/qBGE6CGJg==
X-Received: by 2002:a17:907:a48:b0:968:8b67:4507 with SMTP id be8-20020a1709070a4800b009688b674507mr353068ejc.69.1684994291975;
        Wed, 24 May 2023 22:58:11 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id oq27-20020a170906cc9b00b009662c57b4ffsm357497ejb.96.2023.05.24.22.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 22:58:11 -0700 (PDT)
Date: Thu, 25 May 2023 07:58:09 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 15/15] devlink: save devlink_port_ops into a
 variable in devlink_port_function_validate()
Message-ID: <ZG748Wu7Wtcc1doj@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-16-jiri@resnulli.us>
 <20230524215535.6382e750@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524215535.6382e750@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 06:55:35AM CEST, kuba@kernel.org wrote:
>On Wed, 24 May 2023 14:18:36 +0200 Jiri Pirko wrote:
>> +	const struct devlink_port_ops *ops = devlink_port->ops;
>>  	struct nlattr *attr;
>>  
>>  	if (tb[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] &&
>> -	    (!devlink_port->ops || !devlink_port->ops->port_fn_hw_addr_set)) {
>> +	    (!ops || !ops->port_fn_hw_addr_set)) {
>
>I was kinda expected last patch will remove the !ops checks.
>Another series comes after this to convert more drivers?

Well, there are still drivers that don't use the port at all ops. I can
have them register with empty struct if you like, no strong opinition. I
can do that as follow-up (this set has 15 patches already anyway). Let
me know.

