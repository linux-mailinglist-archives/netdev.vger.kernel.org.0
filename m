Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80FC749E6B8
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbiA0PxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:53:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243271AbiA0PxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:53:08 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E718C06173B;
        Thu, 27 Jan 2022 07:53:08 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z4so2855194ilz.4;
        Thu, 27 Jan 2022 07:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zYCnHem+yXsL+h430Le5ssJgbtLMHBH+MRHKqejQOZo=;
        b=q7mfusPKYjow17ekmUngWUB2JDK5Z3A1oufO+WTYJbLB5GCS/XnxBWSz/rwIiZTifE
         kugVXBn6BIrVOL/ALCec8NgGiP41zsG1CXKvjzjyFpv4AGG1nIn/A3vP24cGiWX2b6KV
         TLrml1TmvuIUm5Wxptrg4vAxDipjGKdoIsrU/19zKRzUhyr9leDLnGEs9VdCNN6Vrvw8
         kLy9G9omhYv4+BPPoBCrrdTqYclsQq5XJhbxJz9uCsntqom8OrgdPFYkAGUXFU/4q7Mo
         m1d/i7x+Zzglo60wKj0ZgTjinoMeAlvxh+BMaN5LOJHNKN3SumWgQc2JAHxJDEQa261J
         LIDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zYCnHem+yXsL+h430Le5ssJgbtLMHBH+MRHKqejQOZo=;
        b=1B6KDYWn24OQl96ZrCLGd3ZykFD0zZRTA3COYpeUNbPZJXtrbINXNd73/PSPF+koCV
         z9ikwVVnBnxDA0mysWkcWfOvQ22oeReAnXV+NDgOFQk6xtwHp73sydwbffxv/8e2/Zrb
         xvqjXm7YX8cnf6JGI9qyMkSY3QUa1ReAgiDT/0urZkykoc3NZuQKbAW6s3+eyh6i8Bak
         +Dsg79+OWna20hTVi6HuWP86fZEkd31W1hHlin1C7bYEMqCfhFk1GGC2hWuZAcHu+vU5
         v2ddfB/a5HV4fCuIFWtpPH3NXzpjAusy3RXt0nafcrJvRE9QQq8owrGxwQjOwsVmGQEF
         6t3w==
X-Gm-Message-State: AOAM5333zyRm+jr22pyKiex8pQ+WU9s/EsTKnbzIgN2K3uggAYCfu3Tg
        9TU+/9ZKGVsgmrVFoVQTe9k=
X-Google-Smtp-Source: ABdhPJxp25laGvXo7rDMI9ih8GLOWcBs03tBEPo8Guy2LK+i3vuBOe5IYuhPMPlZ+iUj3jNsDq9yqA==
X-Received: by 2002:a92:ca45:: with SMTP id q5mr2854645ilo.55.1643298787938;
        Thu, 27 Jan 2022 07:53:07 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:182c:2e54:e650:90f5? ([2601:282:800:dc80:182c:2e54:e650:90f5])
        by smtp.googlemail.com with ESMTPSA id i11sm12685619iow.9.2022.01.27.07.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 07:53:07 -0800 (PST)
Message-ID: <cdb189e9-a804-bb02-9490-146acf8ca0a6@gmail.com>
Date:   Thu, 27 Jan 2022 08:53:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v3 net-next] net: drop_monitor: support drop reason
Content-Language: en-US
To:     menglong8.dong@gmail.com, kuba@kernel.org
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        rostedt@goodmis.org, Menglong Dong <imagedong@tencent.com>,
        Ido Schimmel <idosch@idosch.org>
References: <20220127033356.4050072-1-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220127033356.4050072-1-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 8:33 PM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> In the commit c504e5c2f964 ("net: skb: introduce kfree_skb_reason()")
> drop reason is introduced to the tracepoint of kfree_skb. Therefore,
> drop_monitor is able to report the drop reason to users by netlink.
> 
> For now, the number of drop reason is passed to users ( seems it's
> a little troublesome to pass the drop reason as string ). Therefore,
> users can do some customized description of the reason.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
> v3:
> - referring to cb->reason and cb->pc directly in
>   net_dm_packet_report_fill()
> 
> v2:
> - get a pointer to struct net_dm_skb_cb instead of local var for
>   each field
> ---
>  include/uapi/linux/net_dropmon.h |  1 +
>  net/core/drop_monitor.c          | 16 ++++++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/net_dropmon.h b/include/uapi/linux/net_dropmon.h
> index 66048cc5d7b3..b2815166dbc2 100644
> --- a/include/uapi/linux/net_dropmon.h
> +++ b/include/uapi/linux/net_dropmon.h
> @@ -93,6 +93,7 @@ enum net_dm_attr {
>  	NET_DM_ATTR_SW_DROPS,			/* flag */
>  	NET_DM_ATTR_HW_DROPS,			/* flag */
>  	NET_DM_ATTR_FLOW_ACTION_COOKIE,		/* binary */
> +	NET_DM_ATTR_REASON,			/* u32 */
>  

For userspace to properly convert reason from id to string, enum
skb_drop_reason needs to be moved from skbuff.h to a uapi file.
include/uapi/linux/net_dropmon.h seems like the best candidate to me.
Maybe others have a better idea.

