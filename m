Return-Path: <netdev+bounces-7197-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A9D171F0B3
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 19:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A20811C21071
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:25:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1650646FF8;
	Thu,  1 Jun 2023 17:25:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B98F42501
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 17:25:35 +0000 (UTC)
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C6F136
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 10:25:33 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-96f7bf29550so156023966b.3
        for <netdev@vger.kernel.org>; Thu, 01 Jun 2023 10:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1685640332; x=1688232332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zQsLOYw2qsyNq/n+5eOaAgo493QBN57EdOSrWMISRRE=;
        b=BIQzhqi2lFWKFCf8MCcXrdp6Ls+Xl+DSWyM1IbjQ05PzaMPk/+jZkx5JcdIMPBey7X
         6RiIiOmJfpU4vrjY8cUSm0+w4+o2BpfgKd6UZQPXxV84xd9M08PoMmQ1rttHclUHy72D
         9VnfHl6hE5+U/3wiqmdyrHjmPXRdawFJgNXsVb5Hv0OhN5Ysg8gubJkg5H4mNJnDzc15
         CSoooUjd/9BOPZoPKmqAEbCso0kpZU++EKlCoNJXpALsPvbFep8y4BSmUycAH9qekLlq
         KwEjwUQ17zRtZV5OSjjIxq/T3nwTg49ZEupTLcEEozamE+83GlC+19pUnN2dZS0NvPn4
         +Mvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685640332; x=1688232332;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zQsLOYw2qsyNq/n+5eOaAgo493QBN57EdOSrWMISRRE=;
        b=cj7MhMIIIvUvBMrqxMFoIKowluH5izwOduYGc8kusEN/Ul4FjRhcpfBEkbEdn2LM1o
         StyuINAgLX+HRqeXqHNK80mcEPac43HtwkKgv69V8z/4FvlH0ADkS0cyoGbKOhrfAsux
         RyA3gynERT1Yq4bOXGc29yg0Ta2dry2DzngPS6k8O4pReeCQO/S9I+J3nAwXeXyOHfAI
         DXbJ5HgfCchzeFwB4R4k82T58XE/RXUL2PYK7pUIFqkgzpSHO4q0Nymwhqu7zL+e6w9l
         YazAvSg1dlwdclc7a+wpB94XR91MEPqWvixUfW/IwT3+1WpW2PRCRGHIx6RO8K3hmex7
         smew==
X-Gm-Message-State: AC+VfDyvDBpiq6YgClRKe2lWfkaceQrv4iBtakuq4eW7Bgqc9riN0sfK
	4hRQ+JuFu8LfxyImmUbc0Y2CLhI/zJcUWjKceN040w==
X-Google-Smtp-Source: ACHHUZ7pGo4YjGEvhSHHfN7mvAAlE9HTJ3y3u33chg2VLuCOcgk3TgJL3g+ohWpyZKJhnXfPquHkOw==
X-Received: by 2002:a17:907:8687:b0:973:ca9c:3e2b with SMTP id qa7-20020a170907868700b00973ca9c3e2bmr9251985ejc.25.1685640331865;
        Thu, 01 Jun 2023 10:25:31 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id h26-20020a1709063b5a00b00968242f8c37sm10634044ejf.50.2023.06.01.10.25.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jun 2023 10:25:31 -0700 (PDT)
Message-ID: <258b291e-4631-bb49-58e8-0dc5bf30ed3e@blackwall.org>
Date: Thu, 1 Jun 2023 20:25:30 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH iproute2 3/7] bridge: make print_vlan_info static
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org
Cc: Roopa Prabhu <roopa@nvidia.com>, bridge@lists.linux-foundation.org
References: <20230601172145.51357-1-stephen@networkplumber.org>
 <20230601172145.51357-4-stephen@networkplumber.org>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230601172145.51357-4-stephen@networkplumber.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 01/06/2023 20:21, Stephen Hemminger wrote:
> Function defined and used in only one file.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  bridge/br_common.h | 1 -
>  bridge/vlan.c      | 3 ++-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/bridge/br_common.h b/bridge/br_common.h
> index 1bdee65844c1..704e76b0acb2 100644
> --- a/bridge/br_common.h
> +++ b/bridge/br_common.h
> @@ -6,7 +6,6 @@
>  #define MDB_RTR_RTA(r) \
>  		((struct rtattr *)(((char *)(r)) + RTA_ALIGN(sizeof(__u32))))
>  
> -void print_vlan_info(struct rtattr *tb, int ifindex);
>  int print_linkinfo(struct nlmsghdr *n, void *arg);
>  int print_mdb_mon(struct nlmsghdr *n, void *arg);
>  int print_fdb(struct nlmsghdr *n, void *arg);
> diff --git a/bridge/vlan.c b/bridge/vlan.c
> index 5b304ea94224..dfc62f83a5df 100644
> --- a/bridge/vlan.c
> +++ b/bridge/vlan.c
> @@ -18,6 +18,7 @@
>  
>  static unsigned int filter_index, filter_vlan;
>  static int vlan_rtm_cur_ifidx = -1;
> +static void print_vlan_info(struct rtattr *tb, int ifindex);
>  
>  enum vlan_show_subject {
>  	VLAN_SHOW_VLAN,
> @@ -1309,7 +1310,7 @@ static int vlan_global_show(int argc, char **argv)
>  	return 0;
>  }
>  
> -void print_vlan_info(struct rtattr *tb, int ifindex)
> +static void print_vlan_info(struct rtattr *tb, int ifindex)
>  {
>  	struct rtattr *i, *list = tb;
>  	int rem = RTA_PAYLOAD(list);

Thanks,
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


