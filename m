Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6322D62D149
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238971AbiKQCx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238988AbiKQCxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:53:21 -0500
Received: from omta035.useast.a.cloudfilter.net (omta035.useast.a.cloudfilter.net [44.202.169.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF95243AD6;
        Wed, 16 Nov 2022 18:53:19 -0800 (PST)
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
        by cmsmtp with ESMTP
        id vUhcoS2B8XLQOvV1jo4gcx; Thu, 17 Nov 2022 02:53:19 +0000
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with ESMTP
        id vV1ho1mSMnOb9vV1iomTTM; Thu, 17 Nov 2022 02:53:18 +0000
X-Authority-Analysis: v=2.4 cv=FaMkeby6 c=1 sm=1 tr=0 ts=6375a21e
 a=1YbLdUo/zbTtOZ3uB5T3HA==:117 a=wTog8WU66it3cfrESHnF4A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10 a=9xFQ1JgjjksA:10
 a=wYkD_t78qR0A:10 a=NEAV23lmAAAA:8 a=VwQbUJbxAAAA:8 a=cm27Pg_UAAAA:8
 a=Oz70HW-ix1QoszwUlecA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=xmb-EsYY8bH0VWELuYED:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YIJybe7+LxLFiC77zqCyEKPoKaSBRm10qrdRa86ipds=; b=ZCEPuDyt/NayeF12PJcrr0qHu4
        q1OVCGRP9cDrkUOyUZhSOfu/GAagNToqoxQ8kI3XXVI3BqV7V6z/mqcjR3TQloGqlybfIbOTXCInu
        YHPiOLowob0O/yAuPBTch/1Ph/pvabQBVATxXfWrtKoatg2kUwNh8xAr5T2z7SUKY1QLOTkEm1CmN
        qAhROs1zdGTCzPa6Mkrzs/DHL1skPRUR0sdFLlWxy981ialg2LjInEiQK81rWqXJRyBCsDqCWp+mD
        iCpmxAdRPWPHwkOaCxSc5BYZr6kG73wnJFGRkTfcpGLJ3/jgggrLs653RXwzu7WvxsuBqkfCZgc8Z
        wwNquQSg==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:60960 helo=[192.168.15.7])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.95)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ovTMM-001Ria-NT;
        Wed, 16 Nov 2022 19:06:30 -0600
Message-ID: <ec1bd4b0-6ef1-1673-edaa-8d2abc3e6957@embeddedor.com>
Date:   Wed, 16 Nov 2022 19:06:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 2/2][next] wifi: brcmfmac: Use struct_size() in code
 ralated to struct brcmf_dload_data_le
Content-Language: en-US
To:     Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        SHA-cyfmac-dev-list@infineon.com,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <cover.1668548907.git.gustavoars@kernel.org>
 <41845ad3660ed4375f0c03fd36a67b2e12fafed5.1668548907.git.gustavoars@kernel.org>
 <202211161423.2531CADA73@keescook>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
In-Reply-To: <202211161423.2531CADA73@keescook>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1ovTMM-001Ria-NT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.7]) [187.162.31.110]:60960
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 0
X-Org:  HG=hgshared;ORG=hostgator;
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfANhfVq5PPKVf+YioRGkY6QNckHLtxBi9wXqc37JAuY5bYhIr1Dx1ptLxitCPhMqJ5x+mmUF/OsyUs3K2e3XZuYVVXPXG2bXhJIZZbSDuOVpB0We6qIS
 A68pgMzya3FElcszOzQcZeZ9UzfyIgWVZm7gH62YMpmLaJSjw/7kyQ0We8PfzPtg09oce/d8SqvD7O5F25u/PxmZLKXcoKNRTmz7EwwAuiVG8EMufR7e9PCu
 kE/4hBgTAGFHpUxlK2+cxSgjybUsLKy66LZ6IBDDi9392pUa6gRdZBiph8LSSbDnZRAGCgQ1xCEiNjQT7T1WlGX9ZQzPbfu8HAYqZTQ4IhUVkh8ESxtqIrXB
 5OugMOne
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/16/22 16:23, Kees Cook wrote:
> On Tue, Nov 15, 2022 at 03:55:34PM -0600, Gustavo A. R. Silva wrote:
>> Prefer struct_size() over open-coded versions of idiom:
>>
>> sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
>>
>> where count is the max number of items the flexible array is supposed to
>> contain.
>>
>> In this particular case, in the open-coded version sizeof(typeof-flex-array-elements)
>> is implicit in _count_ because the type of the flex array data is u8:
>>
>> drivers/net/wireless/broadcom/brcm80211/brcmfmac/fwil_types.h:941:
>>   941 struct brcmf_dload_data_le {
>>   942         __le16 flag;
>>   943         __le16 dload_type;
>>   944         __le32 len;
>>   945         __le32 crc;
>>   946         u8 data[];
>>   947 };
>>
>> Link: https://github.com/KSPP/linux/issues/160
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Thanks for the reviews! :)

--
Gustavo
