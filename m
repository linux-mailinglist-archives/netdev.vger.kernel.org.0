Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74CA1694361
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 11:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229957AbjBMKrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 05:47:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjBMKqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 05:46:35 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A41D18B06
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 02:46:10 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id a10so12202076edu.9
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 02:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iiy0OLFDxfc1r5kvZbuj2vRRtVrq5y2/ShbesT5hO4g=;
        b=kGacaduVFbuovBOtcIZJ7XDO0/U4BQuigpWjcqRWxkQTfgQgWCkWlL3FvpvDUADne2
         UW/QQN29Grm4NqNS5nG66FDexIFIX5uQAM729ZpCn+1dciO0j/M64xpdv4R67IBENCFa
         S5JD7SpRCU8/vtLqVqE99QZHAfkIEyDMHPnJybGOkCSTCHy3DRbJ8xmKPqUuTVC10YjA
         9Nm8UDd7J9Kh8Pv8l9Q7+4cVaKq9OWgwkQKcRvwjx6D9Dzp/J6xlUMQHUgV2L0YS50XA
         zAW+k/+wsznS0ZckjxJs5K/5sxMGILEfG/gMcfHXzE+uNehchlhr8Ai+Q6vhY2kluFLl
         aHwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiy0OLFDxfc1r5kvZbuj2vRRtVrq5y2/ShbesT5hO4g=;
        b=zu2QcBHRwMGfVtFv2TfPDVkdMjXq0spwrpUnW8Q3cUn9QWOmJKMIPenYiaomqj5yWe
         6gfKR5jfRjC/6udv+UoAYyePwyR2k8j9kCw1ZQ8MkiWh7xsIbNs/iQDpQnarN2WZqy6r
         KHrTMuPdw+vECI3JQagV15lJY+EPeyBmlC8ubH9XNYR2k6rGcCoHuktzI3WGRnmrTOBq
         X1b93O+bS7Qc/R7uWfkFxhBnUh1yken6kbmyRuotuMVmNf5kxMCbKmz87jgHqt0aZhBL
         42QAdeNKmYyI4c2XjxIJ5W7WIFQNSNjg+mqpx0tdIgULPVVzSroir470e7ypItWhUbdc
         OXHQ==
X-Gm-Message-State: AO0yUKXyj0fbsCx+yIgd8WVVBvWyGguOxFE6GD8A0xPhnVOf7qbGCZAH
        OU3zwdKs+XkAO5rAjnmZSWoZ7w==
X-Google-Smtp-Source: AK7set+THETqueJx0zh6rCZWWzLUIw28x63bGO9vHeOCIILr4q4MtjviZVnGIzjycdMqU0DEcN1FaA==
X-Received: by 2002:a50:8a88:0:b0:4aa:c4bb:2372 with SMTP id j8-20020a508a88000000b004aac4bb2372mr14360194edj.32.1676285119210;
        Mon, 13 Feb 2023 02:45:19 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id j23-20020a508a97000000b004acc2a0e3casm1992549edj.47.2023.02.13.02.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 02:45:18 -0800 (PST)
Date:   Mon, 13 Feb 2023 11:45:16 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, moshe@nvidia.com
Subject: Re: [patch net-next] devlink: don't allow to change net namespace
 for FW_ACTIVATE reload action
Message-ID: <Y+oUvEcsQE2jfpDa@nanopsycho>
References: <20230210115827.3099567-1-jiri@resnulli.us>
 <Y+ZDdAv/YXddqoTp@corigine.com>
 <ce11f400-5016-3564-0d31-99805b762769@intel.com>
 <Y+eW0E9HMPxndN2p@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y+eW0E9HMPxndN2p@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 11, 2023 at 02:23:28PM CET, simon.horman@corigine.com wrote:
>On Fri, Feb 10, 2023 at 11:43:04AM -0800, Jacob Keller wrote:
>> 
>> 
>> On 2/10/2023 5:15 AM, Simon Horman wrote:
>> > On Fri, Feb 10, 2023 at 12:58:27PM +0100, Jiri Pirko wrote:
>> >> From: Jiri Pirko <jiri@nvidia.com>
>> >>
>> >> The change on network namespace only makes sense during re-init reload
>> >> action. For FW activation it is not applicable. So check if user passed
>> >> an ATTR indicating network namespace change request and forbid it.
>> >>
>> >> Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
>> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> >> ---
>> >> Sending to net-next as this is not actually fixing any real bug,
>> >> it just adds a forgotten check.
>> >> ---
>> >>  net/devlink/dev.c | 5 +++++
>> >>  1 file changed, 5 insertions(+)
>> >>
>> >> diff --git a/net/devlink/dev.c b/net/devlink/dev.c
>> >> index 78d824eda5ec..a6a2bcded723 100644
>> >> --- a/net/devlink/dev.c
>> >> +++ b/net/devlink/dev.c
>> >> @@ -474,6 +474,11 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
>> >>  	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
>> >>  	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
>> >>  	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
>> >> +		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
>> >> +			NL_SET_ERR_MSG_MOD(info->extack,
>> >> +					   "Changing namespace is only supported for reinit action");
>> >> +			return -EOPNOTSUPP;
>> >> +		}
>> > 
>> > Is this also applicable in the case where the requested ns (dest_net)
>> > is the same as the current ns, which I think means that the ns
>> > is not changed?
>> > 
>> 
>> In that case wouldn't userspace simply not add the attribute though?
>
>Yes, that may be the case.
>But my question is about the correct behaviour if user space doesn't do that.

Okay. Will send v2.
