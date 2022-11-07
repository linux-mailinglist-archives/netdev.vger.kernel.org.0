Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2461F801
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 16:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232888AbiKGPy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 10:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiKGPy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 10:54:27 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB9439B
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 07:54:25 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id 13so31371834ejn.3
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 07:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l15uLbigy3XyVSiJISvT9ewrLFn++wtOYsfXKwIjE3I=;
        b=0VmMdclgGuhWooaQEpieYHLzIBbAfA+CKkmHIdnJ/LHLQF1SXvJ/2c2iMTIP4Vjbbe
         VLY0Ka5q7V0s6HjN1XdaMYLVsuMEelwoKqOoKJVAlCBZGFsVhahhHE1hldS5+IjDpHEa
         KtTCdRT+kySxjFUmVrwhUQQFLh1VKbuQeoJ/k/pnivsuPeI3/t5TiaCjkEY+C2Dy6E7z
         u8Th1xMI4TG6q/tQ7/y7eXj+Sg+j9jGui5uog2wEcxqinnfa5CBOOKfs+RyZld8EHiPm
         Qs0/1eMwodJT4IatKXOH5uO8aISiFasWpiIGp9RfDumh5pnH41pPF4gQsBPzllUePR6e
         kFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l15uLbigy3XyVSiJISvT9ewrLFn++wtOYsfXKwIjE3I=;
        b=7bMLE3EGtQ1dEV+qkSEDAEJWnScpd5fcJkaWkzPWV+tea8hoYmqWM2skXwQ8t7/XLX
         9KA2yfc//Cm8wuITJCNiOIhQZzhg3EPF2FmUhEpB7U0b6ZZruM61pCvhiw2GaPhiRcWK
         8sNVqZWK5z1xicHnh8g19dMcMmOzRFD0BeP+8wK5My4tPy4iyHCFlJwzZSSHSs2oDTGj
         NR6vfWoXbT3h9IGD+X6UHl6K+V/90WhxUHwI+UkjBtlufeYMX2z8VkjBN3Mclw1M3zOh
         DFMkabAfO2+TZzGSgw45k/jhNGGpwsVZcha3QUzlImBQtlHVc58ogsyAH5Z6r2PR0Z3Z
         l3Xw==
X-Gm-Message-State: ACrzQf16gEmCud6Ij1Q414sGPEEu+jyTGRcE3fxvZL0m2C7dxEOJMaCe
        oJOJo7y3vlINdgfwa/fzcwUrLA==
X-Google-Smtp-Source: AMsMyM75Wgut97W29X34qHGEWPyK3wxd9me4duOPmzD3b1dXW2xJIX2PZYsmfGQs6c0K2UrXSz8NnA==
X-Received: by 2002:a17:906:5e51:b0:7ae:32ca:78c9 with SMTP id b17-20020a1709065e5100b007ae32ca78c9mr17482105eju.166.1667836463738;
        Mon, 07 Nov 2022 07:54:23 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id w23-20020aa7dcd7000000b00443d657d8a4sm4355875edu.61.2022.11.07.07.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 07:54:22 -0800 (PST)
Date:   Mon, 7 Nov 2022 16:54:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, sthemmin@microsoft.com, kuba@kernel.org,
        moshe@nvidia.com, aeedm@nvidia.com
Subject: Re: [patch iproute2-next 1/3] devlink: query ifname for devlink port
 instead of map lookup
Message-ID: <Y2kqLYEle5oDxfts@nanopsycho>
References: <20221104102327.770260-1-jiri@resnulli.us>
 <20221104102327.770260-2-jiri@resnulli.us>
 <6903f920-dd02-9df0-628a-23d581c4aac6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6903f920-dd02-9df0-628a-23d581c4aac6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 04:16:42PM CET, dsahern@gmail.com wrote:
>On 11/4/22 4:23 AM, Jiri Pirko wrote:
>> From: Jiri Pirko <jiri@nvidia.com>
>> 
>> ifname map is created once during init. However, ifnames can easily
>> change during the devlink process runtime (e. g. devlink mon).
>
>why not update the cache on name changes? Doing a query on print has

We would have to listen on RTNetlink for the changes, as devlink does
not send such events on netdev ifname change.


>extra overhead. And, if you insist a per-print query is needed, why
>leave ifname_map_list? what value does it serve if you query each time?

Correct.

>
>
>> Therefore, query ifname during each devlink port print.
>> 
>> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
>> ---
>>  devlink/devlink.c | 46 +++++++++++++++++++++++++++++++---------------
>>  1 file changed, 31 insertions(+), 15 deletions(-)
>> 
>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index 8aefa101b2f8..680936f891cf 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>> @@ -864,21 +864,38 @@ static int ifname_map_lookup(struct dl *dl, const char *ifname,
>>  	return -ENOENT;
>>  }
>>  
>> -static int ifname_map_rev_lookup(struct dl *dl, const char *bus_name,
>> -				 const char *dev_name, uint32_t port_index,
>> -				 char **p_ifname)
>> +static int port_ifname_get_cb(const struct nlmsghdr *nlh, void *data)
>>  {
>> -	struct ifname_map *ifname_map;
>> +	struct genlmsghdr *genl = mnl_nlmsg_get_payload(nlh);
>> +	struct nlattr *tb[DEVLINK_ATTR_MAX + 1] = {};
>> +	char **p_ifname = data;
>> +	const char *ifname;
>>  
>> -	list_for_each_entry(ifname_map, &dl->ifname_map_list, list) {
>> -		if (strcmp(bus_name, ifname_map->bus_name) == 0 &&
>> -		    strcmp(dev_name, ifname_map->dev_name) == 0 &&
>> -		    port_index == ifname_map->port_index) {
>> -			*p_ifname = ifname_map->ifname;
>> -			return 0;
>> -		}
>> -	}
>> -	return -ENOENT;
>> +	mnl_attr_parse(nlh, sizeof(*genl), attr_cb, tb);
>> +	if (!tb[DEVLINK_ATTR_PORT_NETDEV_NAME])
>> +		return MNL_CB_ERROR;
>> +
>> +	ifname = mnl_attr_get_str(tb[DEVLINK_ATTR_PORT_NETDEV_NAME]);
>> +	*p_ifname = strdup(ifname);
>> +	if (!*p_ifname)
>> +		return MNL_CB_ERROR;
>> +
>> +	return MNL_CB_OK;
>> +}
>> +
>> +static int port_ifname_get(struct dl *dl, const char *bus_name,
>> +			   const char *dev_name, uint32_t port_index,
>> +			   char **p_ifname)
>> +{
>> +	struct nlmsghdr *nlh;
>> +
>> +	nlh = mnlu_gen_socket_cmd_prepare(&dl->nlg, DEVLINK_CMD_PORT_GET,
>> +			       NLM_F_REQUEST | NLM_F_ACK);
>> +	mnl_attr_put_strz(nlh, DEVLINK_ATTR_BUS_NAME, bus_name);
>> +	mnl_attr_put_strz(nlh, DEVLINK_ATTR_DEV_NAME, dev_name);
>> +	mnl_attr_put_u32(nlh, DEVLINK_ATTR_PORT_INDEX, port_index);
>> +	return mnlu_gen_socket_sndrcv(&dl->nlg, nlh, port_ifname_get_cb,
>> +				      p_ifname);
>>  }
>>  
>>  static int strtobool(const char *str, bool *p_val)
>> @@ -2577,8 +2594,7 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
>>  	char *ifname = NULL;
>>  
>>  	if (dl->no_nice_names || !try_nice ||
>> -	    ifname_map_rev_lookup(dl, bus_name, dev_name,
>> -				  port_index, &ifname) != 0)
>> +	    port_ifname_get(dl, bus_name, dev_name, port_index, &ifname) != 0)
>>  		sprintf(buf, "%s/%s/%d", bus_name, dev_name, port_index);
>>  	else
>>  		sprintf(buf, "%s", ifname);
>
