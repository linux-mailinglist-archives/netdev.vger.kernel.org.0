Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4A0668CA49
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 00:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbjBFXLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 18:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbjBFXKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 18:10:55 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275A23431D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 15:10:15 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id d14so11933059wrr.9
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 15:10:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tNF9BqYZJcImcf0S/HQnA27kPdbdCpP5ol4AYCdZq1s=;
        b=UZWdasjTr7m7xkX7vPNcxt27xcbks3cLIwOi9gNfCKMPEbkAX9xfYyfSQxmdFbR/gv
         +2ym4T1zghP3Ndk2RKJfIvgsQQ3gwhKxpUpbZB9yw1KdA+bKxMK2Mo200CjjzfGDLAY4
         htPEI07FzHMNR8nik3xaxCshwqbnbjnalvVlQAHkgacB8juApvny3pTILvUd/Wk68PeB
         Dj/IWxgfE6AWNydqJVh5Hl66v6WEQ0n7ld1gX5seEcaDsFLw+H0SgGPZVvpaE9pgVuNp
         PReThvmlQo0zb4gbi+w7hc8rGBMaItgdiXuuf+XQp2XX1awtjP2LS4S6AgZ7aJQk57JX
         w1rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tNF9BqYZJcImcf0S/HQnA27kPdbdCpP5ol4AYCdZq1s=;
        b=H3OFcYcDry8tFukWN4qouHHH2PuDd3VAFpN2LW4/6L3bkdbilxXBv19wUAW+B4s/ZD
         sjMNWjuetaEELS6DHInz2+uSbcJaGQTPl5IGUjc9eQfAqLVr1nv7lAqWQnmy02OspE/B
         q2AD0AuMGDlMaZscW2S2KxcDAGqC6kL9P0vG5nuLZsElIEBWFs6pGxAczhrdkzg3TvOs
         fvaAI/Dwt86FDMflJe2MKW57il+VNwQNA8Be9ELB0T75j9EbeOJcvD39jx3FQ989Efkx
         JQoXr4dUPSHlCLIYaph+MIjgHpNiVUCGmYz1e0pUv177c9jnnau235o9XWqb6xZ+0Cfg
         qZDQ==
X-Gm-Message-State: AO0yUKVEHfTV+zh0fETts36Kc4KLl/nJudMHkrCojup50jkuMeGuplnx
        ksUvwUTlL4kDYJMCt5x+Y8sl5Q==
X-Google-Smtp-Source: AK7set8ZS9wFyI2OB13MgBUbA93XkfNTvnHCNpr6G0obOG2lLivRBybeNPd8+V6mY2NICOYaGwvW4A==
X-Received: by 2002:a5d:6a45:0:b0:2bf:d541:6371 with SMTP id t5-20020a5d6a45000000b002bfd5416371mr576679wrw.41.1675725012983;
        Mon, 06 Feb 2023 15:10:12 -0800 (PST)
Received: from [192.168.100.228] (212-147-51-13.fix.access.vtx.ch. [212.147.51.13])
        by smtp.gmail.com with ESMTPSA id o15-20020a5d684f000000b002c3f03d8851sm1389853wrw.16.2023.02.06.15.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 15:10:12 -0800 (PST)
Message-ID: <7fb34207-473b-38aa-7184-0bb08fe87d3f@blackwall.org>
Date:   Tue, 7 Feb 2023 00:10:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH iproute2-next] bridge: mdb: Remove double space in MDB
 dump
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, mlxsw@nvidia.com
References: <20230206142152.4183995-1-idosch@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230206142152.4183995-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/6/23 16:21, Ido Schimmel wrote:
> There is an extra space after the "proto" field. Remove it.
> 
> Before:
> 
>   # bridge -d mdb
>   dev br0 port swp1 grp 239.1.1.1 permanent proto static  vid 1
> 
> After:
> 
>   # bridge -d mdb
>   dev br0 port swp1 grp 239.1.1.1 permanent proto static vid 1
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>   bridge/mdb.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/bridge/mdb.c b/bridge/mdb.c
> index f323cd091fcc..9b5503657178 100644
> --- a/bridge/mdb.c
> +++ b/bridge/mdb.c
> @@ -221,7 +221,7 @@ static void print_mdb_entry(FILE *f, int ifindex, const struct br_mdb_entry *e,
>   			__u8 rtprot = rta_getattr_u8(tb[MDBA_MDB_EATTR_RTPROT]);
>   			SPRINT_BUF(rtb);
>   
> -			print_string(PRINT_ANY, "protocol", " proto %s ",
> +			print_string(PRINT_ANY, "protocol", " proto %s",
>   				     rtnl_rtprot_n2a(rtprot, rtb, sizeof(rtb)));
>   		}
>   	}

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

