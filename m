Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22BE43660E2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbhDTU2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:28:14 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.89]:35125 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233619AbhDTU2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 16:28:12 -0400
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 504F6400C7755
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 15:27:39 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id YwyBlOcgLMGeEYwyBllFC4; Tue, 20 Apr 2021 15:27:39 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=tx5snhU3r7ZxxPo+QKrbHdn/tSplnVEsmvWKh2OnMcE=; b=jIjFNaMX9gnup8YvgCoemgSlT5
        U/Mt1F0O0qCWC2Q+L+avKAEdl87qXCoJiQf+UwxhUtcLqTljyhM5ihhb6f89oLrsSWLkYySeD/85S
        kjZXzqcgbMEooDCtyUhsPlltcQ4MSuA9ZNG5L1yCjViD5aWLOK2hiICIdLTtonnnUMJVVqWqlYPLT
        3N2RndHYZYfqLD7L3jC170bC/k1xmcDvAz0vZ7agDtZ2DtfWLFPaI4SlwEfOWrnIodVtJqQ84+4Yw
        q1XAXum0+Xd2M96QAyvXEwtN88VeYVBCsbbJbtga78sHTdkbyMkGeLaChLYDqqLf+Lefn3hoa+3H0
        /RJsCTuQ==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:49060 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1lYwy7-0038Rn-QV; Tue, 20 Apr 2021 15:27:35 -0500
Subject: Re: [PATCH RESEND][next] qlcnic: Fix fall-through warnings for Clang
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20210305091735.GA139591@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <9502f47c-4e5c-2406-9cc7-708c90899c9d@embeddedor.com>
Date:   Tue, 20 Apr 2021 15:27:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210305091735.GA139591@embeddedor>
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
X-Exim-ID: 1lYwy7-0038Rn-QV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:49060
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 199
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Friendly ping: who can take this, please?

Thanks
--
Gustavo

On 3/5/21 03:17, Gustavo A. R. Silva wrote:
> In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
> warnings by explicitly adding a break and a goto statements instead of
> just letting the code fall through to the next case.
> 
> Link: https://github.com/KSPP/linux/issues/115
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c   | 1 +
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> index bdf15d2a6431..af4c516a9e7c 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> @@ -1390,6 +1390,7 @@ static int qlcnic_process_rcv_ring(struct qlcnic_host_sds_ring *sds_ring, int ma
>  			break;
>  		case QLCNIC_RESPONSE_DESC:
>  			qlcnic_handle_fw_message(desc_cnt, consumer, sds_ring);
> +			goto skip;
>  		default:
>  			goto skip;
>  		}
> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> index 96b947fde646..8966f1bcda77 100644
> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
> @@ -3455,6 +3455,7 @@ qlcnic_fwinit_work(struct work_struct *work)
>  			adapter->fw_wait_cnt = 0;
>  			return;
>  		}
> +		break;
>  	case QLCNIC_DEV_FAILED:
>  		break;
>  	default:
> 
