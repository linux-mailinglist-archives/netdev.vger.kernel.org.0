Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0DA554DFAE
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376373AbiFPLG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230291AbiFPLGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:06:55 -0400
X-Greylist: delayed 1380 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 16 Jun 2022 04:06:53 PDT
Received: from gateway24.websitewelcome.com (gateway24.websitewelcome.com [192.185.51.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA36B5DE75
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:06:53 -0700 (PDT)
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 525306FB5
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 05:43:53 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id 1myfoxFXz7B0O1myfoYrXC; Thu, 16 Jun 2022 05:43:53 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IfNIAqzersyDV8nNIwaREImkJNE8UvYTeYLFrLHtknY=; b=kPRyWpB9ZJNGcPo10dGSmxUtl3
        QtC/oUlh+uSnB6bKYV44YoyUUKu0+iyk6Sbc7mca4JPVPG4c8b328m/GdqFsGLoYSzYYOWy1iTQQg
        ZlvgqLcohMKojwvaQh9L1bj4MzPSIS1h+FzenkWHLglyG+RF+SJ6kdPtMzJDTw+wbN4zdMHbHHSeU
        9PVbuLdKTULCN5jPZBTCNDOopp5KGX5oVv0YnVaEYM//CEn0LCB/x5b+DTLbcc5KSy4ci1Dwgi27L
        g8a20UIJaaGrRtrIQS8f+EB08/8HcED8iQ3MsW56XUoFFg3BqzB/cjOKj8NwCAuYS/2hQ6xKUdgqA
        NCnR1nwQ==;
Received: from 193.254.29.93.rev.sfr.net ([93.29.254.193]:43842 helo=[192.168.0.101])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1o1mye-003dLc-9k;
        Thu, 16 Jun 2022 05:43:52 -0500
Message-ID: <e077bafc-17bf-37de-868a-3ab32f91769d@embeddedor.com>
Date:   Thu, 16 Jun 2022 12:43:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] hinic: Replace memcpy() with direct assignment
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20220616052312.292861-1-keescook@chromium.org>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <20220616052312.292861-1-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 93.29.254.193
X-Source-L: No
X-Exim-ID: 1o1mye-003dLc-9k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 193.254.29.93.rev.sfr.net ([192.168.0.101]) [93.29.254.193]:43842
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 4
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/16/22 07:23, Kees Cook wrote:
> Under CONFIG_FORTIFY_SOURCE=y and CONFIG_UBSAN_BOUNDS=y, Clang is bugged
> here for calculating the size of the destination buffer (0x10 instead of
> 0x14). This copy is a fixed size (sizeof(struct fw_section_info_st)), with
> the source and dest being struct fw_section_info_st, so the memcpy should
> be safe, assuming the index is within bounds, which is UBSAN_BOUNDS's
> responsibility to figure out.

Also, there is a sanity check just before the for() loop:

  38         if (fw_image->fw_info.fw_section_cnt > MAX_FW_TYPE_NUM) {
  39                 dev_err(&priv->hwdev->hwif->pdev->dev, "Wrong fw_type_num read from file, fw_type_num: 0x%x\n    ",
  40                         fw_image->fw_info.fw_section_cnt);
  41                 return false;
  42         }

so, this should be fine.

> 
> Avoid the whole thing and just do a direct assignment. This results in
> no change to the executable code.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Nathan Chancellor <nathan@kernel.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Tom Rix <trix@redhat.com>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Simon Horman <simon.horman@corigine.com>
> Cc: netdev@vger.kernel.org
> Cc: llvm@lists.linux.dev
> Link: https://github.com/ClangBuiltLinux/linux/issues/1592
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Thanks
--
Gustavo

> ---
>   drivers/net/ethernet/huawei/hinic/hinic_devlink.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> index 60ae8bfc5f69..1749d26f4bef 100644
> --- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> +++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
> @@ -43,9 +43,7 @@ static bool check_image_valid(struct hinic_devlink_priv *priv, const u8 *buf,
>   
>   	for (i = 0; i < fw_image->fw_info.fw_section_cnt; i++) {
>   		len += fw_image->fw_section_info[i].fw_section_len;
> -		memcpy(&host_image->image_section_info[i],
> -		       &fw_image->fw_section_info[i],
> -		       sizeof(struct fw_section_info_st));
> +		host_image->image_section_info[i] = fw_image->fw_section_info[i];
>   	}
>   
>   	if (len != fw_image->fw_len ||
