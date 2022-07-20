Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E6B57B931
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 17:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiGTPJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 11:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240905AbiGTPJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 11:09:11 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD762237D6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:09:09 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id e15so21306192wro.5
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PN9SvnUq9sr80nlTjpLBVjvKibhchzGAYby0F+GI01A=;
        b=PN1z7k6Rfqe5zKoCvNWGpugRL3O2TtMRILEah7PeQxCNTgnzweGkLFKhkkompJQOmD
         0SxXIn8qRFLMZ4VdvKmqJ4cuDnJf5uqXRjFYq4h18PIvt5P71kOb1v1mgKrGPxmzioI6
         2NZeUR/pr9ksbKXL6ZuAZf8AMxXyE8f5wC3veVv78NQu1hV9nZoTBGGKvVvNCb7VPMCn
         IKaDjKzkJJaCh4uwuAQPTUDSVVZEtdajv9XsgFiz3tPCVohbazsQHs1qZjlLIQWtQL81
         RtyUqOAbrxzw6Neb2ihUURnCEGzMTUIrFix+RcIQccZska6M4MvCmerux9jnD557/JZK
         fyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PN9SvnUq9sr80nlTjpLBVjvKibhchzGAYby0F+GI01A=;
        b=dexcMm29yng4EYUL6uL5ykzcmxDfYJns555pwP84ZRxFlZ1NOruYlVVMLG0u5p/psK
         a/kMsLjWLou8j8wziQK08WTzuIT5NHO0/mZ6w54PK7VUv9jMT/vRkc8r55h1XWkCQX4v
         zsaLKv9Yl2oN+IxELRpC48VjP/suvofyh/1UfEYaYRVFiZdWTgq2jOYNPI0i58wtOB7Z
         Yh+XtcdI0lO8MsdlivvTiiJt8qtWyRWRToyAFMckW8vwXCzCzLGlz/uOnv2Mrb6iUvhQ
         2zc9tZrqOcmYBhufGmQJRJU/1E4kG1zG1SmIjbmkYua/wbpEVjH1LadOm2m03kTfwPDD
         50Lw==
X-Gm-Message-State: AJIora93QSZTB8s07a3+pNjeSNkgLCxWHO8vd3ThN6Mf6D+9Gvaop77G
        5mGuf+4pF4PfOFNAcEibaoqjaA==
X-Google-Smtp-Source: AGRyM1vrHoREA6ePgwv5nj7EPRxMqkA/dHU6L0hL4/TpVgaBakQQRRi5UoVdKlWsUBdb3OpetwAbPA==
X-Received: by 2002:a05:6000:47:b0:21e:417b:95d with SMTP id k7-20020a056000004700b0021e417b095dmr5721434wrx.590.1658329748299;
        Wed, 20 Jul 2022 08:09:08 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f8-20020a05600c154800b00397402ae674sm3228665wmg.11.2022.07.20.08.09.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 08:09:07 -0700 (PDT)
Date:   Wed, 20 Jul 2022 17:09:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 05/12] mlxsw: core_linecards: Expose HW
 revision and INI version
Message-ID: <Ytgakkh8hcrbidoY@nanopsycho>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-6-jiri@resnulli.us>
 <YtfDQ6hpGKXFKfCD@shredder>
 <Ytf0vDVH7+05f0IS@nanopsycho>
 <Ytf4ZaJdJY20ULfw@shredder>
 <YtgYN3vi6MyTTT0K@nanopsycho>
 <YtgYuPrO6gw0nR3b@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtgYuPrO6gw0nR3b@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 20, 2022 at 05:01:12PM CEST, idosch@nvidia.com wrote:
>On Wed, Jul 20, 2022 at 04:59:03PM +0200, Jiri Pirko wrote:
>> Wed, Jul 20, 2022 at 02:43:17PM CEST, idosch@nvidia.com wrote:
>> >On Wed, Jul 20, 2022 at 02:27:40PM +0200, Jiri Pirko wrote:
>> >> Wed, Jul 20, 2022 at 10:56:35AM CEST, idosch@nvidia.com wrote:
>> >> >On Tue, Jul 19, 2022 at 08:48:40AM +0200, Jiri Pirko wrote:
>> >> >> +int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
>> >> >> +				    struct devlink_info_req *req,
>> >> >> +				    struct netlink_ext_ack *extack)
>> >> >> +{
>> >> >> +	char buf[32];
>> >> >> +	int err;
>> >> >> +
>> >> >> +	mutex_lock(&linecard->lock);
>> >> >> +	if (WARN_ON(!linecard->provisioned)) {
>> >> >> +		err = 0;
>> >> >
>> >> >Why not:
>> >> >
>> >> >err = -EINVAL;
>> >> >
>> >> >?
>> >> 
>> >> Well, a) this should not happen. No need to push error to the user for
>> >> this as the rest of the info message is still fine.
>> >
>> >Not sure what you mean by "the rest of the info message is still fine".
>> >Which info message? If the line card is not provisioned, then it
>> >shouldn't even have a devlink instance and it will not appear in
>> >"devlink dev info" dump.
>> >
>> >I still do not understand why this error is severe enough to print a
>> >WARNING to the kernel log, but not emit an error code to user space.
>> 
>> As I wrote, WARN_ON was a leftover.
>
>It was a leftover in patch #10 where you checked '!linecard->ready'.
>Here I think it's actually correct because it shouldn't happen unless
>I'm missing something

Correct, I confused myself :)

