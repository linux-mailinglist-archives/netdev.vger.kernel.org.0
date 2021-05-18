Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63EFC386E84
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 02:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbhERAyA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 20:54:00 -0400
Received: from gateway30.websitewelcome.com ([192.185.160.12]:34487 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235791AbhERAx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 20:53:59 -0400
Received: from cm11.websitewelcome.com (cm11.websitewelcome.com [100.42.49.5])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id B3F5E30DD
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 19:06:28 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id inFklZOiwnrr4inFklXBwb; Mon, 17 May 2021 19:06:28 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k4sEVLknnruDHNpvaSM+w0j2lvZwEiQryRCoSyKzAtU=; b=EUHY6myuyr28THoBW+A8QZ9WrE
        zwLvASFA/r9a4pD9OF0Mp8ZUXxRer1beCcK7nCD1OPIfv1Dc9ZvvFvxnYUBHwpHNex9xtxZviSZfg
        8fKZlzcIdRMu+yfkR6Hvb15SjVj/eYw3w+ApkrBesr11i1XF5c6sHK3dJ+68prRnA2ekWkqcQBnfy
        xNawyp6G7n07NwtPi/Er//wTLw2C8izlOm7yf1k34xZREK517KR/J2mg51EiYaHs4GlDMq2vfAyyu
        6XbMtgynGXws3QA2IliXreIYxsHF2a8SNSc4A+e4ZPbQ9fbwyIjBohfZy4CW4Du9cogxpdmPotUL2
        +mLWfhNw==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:53386 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <gustavo@embeddedor.com>)
        id 1linFh-0028jA-89; Mon, 17 May 2021 19:06:25 -0500
Subject: Re: [oss-drivers] Re: [PATCH RESEND][next] nfp: Fix fall-through
 warnings for Clang
To:     Simon Horman <simon.horman@netronome.com>
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, oss-drivers@netronome.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
References: <20210305094937.GA141307@embeddedor>
 <20210305121949.GF8899@netronome.com>
 <b4fd4c37-ccd6-3cbb-a127-3b2ad9516871@embeddedor.com>
 <20210421093911.GA15091@netronome.com>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <3c89dd75-64a9-d60b-164c-598cdb4ab2b8@embeddedor.com>
Date:   Mon, 17 May 2021 19:07:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210421093911.GA15091@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1linFh-0028jA-89
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:53386
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 11
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I'm taking this in my -next[1] branch for v5.14.

Thanks
--
Gustavo

[1] https://git.kernel.org/pub/scm/linux/kernel/git/gustavoars/linux.git/log/?h=for-next/kspp

On 4/21/21 04:39, Simon Horman wrote:
> On Tue, Apr 20, 2021 at 03:23:39PM -0500, Gustavo A. R. Silva wrote:
>> On 3/5/21 06:19, Simon Horman wrote:
>>> On Fri, Mar 05, 2021 at 03:49:37AM -0600, Gustavo A. R. Silva wrote:
>>>> In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
>>>> by explicitly adding a break statement instead of letting the code fall
>>>> through to the next case.
>>>>
>>>> Link: https://github.com/KSPP/linux/issues/115
>>>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>>>
>>> Thanks Gustavo,
>>>
>>> this looks good to me.
>>>
>>> Acked-by: Simon Horman <simon.horman@netronome.com>
>>
>> Hi all,
>>
>> Friendly ping: who can take this, please?
> 
> Hi Jakub, Hi David,
> 
> I'm happy to repost this patch if it would help with your processes.
> 
>>>> ---
>>>>  drivers/net/ethernet/netronome/nfp/nfp_net_repr.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>>>> index b3cabc274121..3b8e675087de 100644
>>>> --- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>>>> +++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
>>>> @@ -103,6 +103,7 @@ nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
>>>>  	case NFP_PORT_PF_PORT:
>>>>  	case NFP_PORT_VF_PORT:
>>>>  		nfp_repr_vnic_get_stats64(repr->port, stats);
>>>> +		break;
>>>>  	default:
>>>>  		break;
>>>>  	}
>>>> -- 
>>>> 2.27.0
>>>>
