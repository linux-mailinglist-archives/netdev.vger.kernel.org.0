Return-Path: <netdev+bounces-5234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1484710590
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 08:05:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8DB681C20C93
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 06:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFABC8832;
	Thu, 25 May 2023 06:05:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C098477
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:05:27 +0000 (UTC)
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D20E6D8
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:05:25 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-510b6a249a8so3692067a12.0
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 23:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684994724; x=1687586724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tHXVcQZ1uM0SfEZE5T0UkSv3jL9sLfnSHIwOItRwgzk=;
        b=XRB6CA2aP1fUeaeP+8cfG64DldzG89B9pZUZqTI0++NT4eUmuhaFhJKHgh9qD2Tqwy
         u0z5y+Yk3W0cwfb7PLCtWxgfakxm123XNofZwBlz3s4rLdJLIE88DivHFOlo7MV7gdGF
         tA1VrW5ypHtYAak8YIj6uPQ7JjI1nPBN72TS706zGjCTtl2xqyfYJWQPqZfm6CHpBLAe
         OjPzJi5cB+TCyQmaROBdH5DyhDbEItn/f8XcJwqXHgNxqSuLx15Zavu9kkGhR5NAJSoW
         1ZHaHmLEH0MWTPCZ4sAh37i2mqjFnJEu2ljSDFQt4N32TKH94WJ5krvJFOZdKYgggtui
         IN5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684994724; x=1687586724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tHXVcQZ1uM0SfEZE5T0UkSv3jL9sLfnSHIwOItRwgzk=;
        b=WlcnntROpLImKOnw2wVS9tOZfglpXB0nzZzEWJ6+RDLyEdGP6oSUFrSur9DAQSp1kJ
         njLV5n51tvpYAaJXSnYmLdzevu9dL2JqqDzSz9QUxynCpVG24skCzMsDNaZY60pcNrVW
         hb6GjKuTnEazDyY0aaoVEoMDUCH8wHIUUvWo29VsH/RD/JeRnIamKYWSlTAdaW9OnwA7
         MAXBC69PZWkMZFGTmGYOsqSBk8zprxWwLbqgFDJvLQnIFHATG38QNWqOAVmhy6SGBqFM
         7Z5bsjtz+uUnrFQgXJhXRUdp/4o6tkPGCPz/llxbBBYYMr9ZlZZMKBSAc0K+HHoQy0pa
         KgKw==
X-Gm-Message-State: AC+VfDzNy9iX9oknJ4CtSgYG4yBPfUaraxjp9z+hm/vYam2cGlEm08Co
	XFsceUoei1XQKFWsIWc1O/DXcw==
X-Google-Smtp-Source: ACHHUZ4WcA6k4hnLiNv7Y9z6ffU70XXGysAXhpGdI+jzaLy/cWLL0nn5/Uj2W5ZNIGOhnIw8Fu8x7A==
X-Received: by 2002:a17:907:9289:b0:94a:7da2:d339 with SMTP id bw9-20020a170907928900b0094a7da2d339mr364840ejc.26.1684994724237;
        Wed, 24 May 2023 23:05:24 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id a3-20020a1709066d4300b0094f07545d40sm344095ejt.220.2023.05.24.23.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 23:05:23 -0700 (PDT)
Date: Thu, 25 May 2023 08:05:22 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
	moshe@nvidia.com, jesse.brandeburg@intel.com,
	anthony.l.nguyen@intel.com, tariqt@nvidia.com, idosch@nvidia.com,
	petrm@nvidia.com, simon.horman@corigine.com, ecree.xilinx@gmail.com,
	habetsm.xilinx@gmail.com, michal.wilczynski@intel.com,
	jacob.e.keller@intel.com
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Message-ID: <ZG76ohK00xF2LHeK@nanopsycho>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-6-jiri@resnulli.us>
 <20230524215301.02ae701e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524215301.02ae701e@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thu, May 25, 2023 at 06:53:01AM CEST, kuba@kernel.org wrote:
>On Wed, 24 May 2023 14:18:26 +0200 Jiri Pirko wrote:
>>  /**
>>   * struct devlink_port_ops - Port operations
>> + * @port_split: Callback used to split the port into multiple ones.
>> + * @port_unsplit: Callback used to unsplit the port group back into
>> + *		  a single port.
>>   */
>>  struct devlink_port_ops {
>> +	int (*port_split)(struct devlink *devlink, struct devlink_port *port,
>> +			  unsigned int count, struct netlink_ext_ack *extack);
>> +	int (*port_unsplit)(struct devlink *devlink, struct devlink_port *port,
>> +			    struct netlink_ext_ack *extack);
>>  };
>
>Two random take it or leave it comments: (1) since these are port ops
>now do they need the port_* prefix? (2) I've become partial to adding

Yeah, I'd like to leave them, for grepability purposes.


>the kdoc inline in op structs:
>
>/**
> * struct x - it is the X struct
> */
>struct x {
>	/** @an_op: its an op */
>	int (*an_op)(int arg);
>};
>
>I think it's because every time I look at struct net_device_ops 
>a little part of me gives up.

Does this work? I checked the existing layout of devlink_ops and the
internal comments are ignored by kdoc. Actually the whole devlink_ops
struct is omitted in kdoc. See:
$ scripts/kernel-doc include/net/devlink.h

I followed the format we have for the other ops structures in devlink.h
which works with kernel-doc script.

