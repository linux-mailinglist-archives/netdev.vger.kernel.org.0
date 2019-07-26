Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C820D76170
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 11:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfGZJAu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Jul 2019 05:00:50 -0400
Received: from gauss.credativ.com ([93.94.130.89]:55115 "EHLO
        gauss.credativ.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGZJAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 05:00:49 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jul 2019 05:00:47 EDT
Received: from gauss.credativ.com (localhost [127.0.0.1])
        by gauss.credativ.com (Postfix) with ESMTP id AEFC61E188F;
        Fri, 26 Jul 2019 10:54:22 +0200 (CEST)
Received: from openxchange.credativ.com (openxchange.credativ.com [93.94.130.84])
        (using TLSv1 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by gauss.credativ.com (Postfix) with ESMTPS id A0C9C1E1834;
        Fri, 26 Jul 2019 10:54:22 +0200 (CEST)
Received: from openxchange.credativ.com (localhost [127.0.0.1])
        by openxchange.credativ.com (Postfix) with ESMTPS id 45w2vL4HcNz2xGj;
        Fri, 26 Jul 2019 08:54:22 +0000 (UTC)
Date:   Fri, 26 Jul 2019 10:54:22 +0200 (CEST)
From:   Sedat Dilek <sedat.dilek@credativ.de>
Reply-To: Sedat Dilek <sedat.dilek@credativ.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Perrochaud?= 
        <clement.perrochaud@effinnov.com>,
        Charles Gorand <charles.gorand@effinnov.com>,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Cc:     Andrey Konovalov <andreyknvl@google.com>
Message-ID: <1208463309.1019.1564131262506@ox.credativ.com>
In-Reply-To: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
References: <20190725193511.64274-1-andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v3 01/14] NFC: fix attrs checks in netlink interface
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.10.2-Rev8
X-Originating-Client: open-xchange-appsuite
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ Please CC me I am not subscribed to this ML ]

Hi Andy,

unfortunately, I did not found a cover-letter on netdev mailing-list.
So, I am answering here.

What are the changes v2->v3?

Again, unfortunately I throw away all v2 out of my local linux Git repository.
So, I could have looked at the diff myself.

Thanks for v3 upgrade!

Regards,
- Sedat -

[1] https://marc.info/?a=131071969100005&r=1&w=2

> Andy Shevchenko <andriy.shevchenko@linux.intel.com> hat am 25. Juli 2019 21:34 geschrieben:
> 
>  
> From: Andrey Konovalov <andreyknvl@google.com>
> 
> nfc_genl_deactivate_target() relies on the NFC_ATTR_TARGET_INDEX
> attribute being present, but doesn't check whether it is actually
> provided by the user. Same goes for nfc_genl_fw_download() and
> NFC_ATTR_FIRMWARE_NAME.
> 
> This patch adds appropriate checks.
> 
> Found with syzkaller.
> 
> Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  net/nfc/netlink.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
> index 4a30309bb67f..60fd2748d0ea 100644
> --- a/net/nfc/netlink.c
> +++ b/net/nfc/netlink.c
> @@ -970,7 +970,8 @@ static int nfc_genl_dep_link_down(struct sk_buff *skb, struct genl_info *info)
>  	int rc;
>  	u32 idx;
>  
> -	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> +	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
> +	    !info->attrs[NFC_ATTR_TARGET_INDEX])
>  		return -EINVAL;
>  
>  	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> @@ -1018,7 +1019,8 @@ static int nfc_genl_llc_get_params(struct sk_buff *skb, struct genl_info *info)
>  	struct sk_buff *msg = NULL;
>  	u32 idx;
>  
> -	if (!info->attrs[NFC_ATTR_DEVICE_INDEX])
> +	if (!info->attrs[NFC_ATTR_DEVICE_INDEX] ||
> +	    !info->attrs[NFC_ATTR_FIRMWARE_NAME])
>  		return -EINVAL;
>  
>  	idx = nla_get_u32(info->attrs[NFC_ATTR_DEVICE_INDEX]);
> -- 
> 2.20.1


-- 
Mit freundlichen Grüssen 
Sedat Dilek
Telefon: +49 2166 9901-153 
E-Mail: sedat.dilek@credativ.de 
Internet: https://www.credativ.de/

GPG-Fingerprint: EA6D E17D D269 AC7E 101D C910 476F 2B3B 0AF7 F86B

credativ GmbH, Trompeterallee 108, 41189 Mönchengladbach 
Handelsregister: Amtsgericht Mönchengladbach HRB 12080 USt-ID-Nummer DE204566209 
Geschäftsführung: Dr. Michael Meskes, Jörg Folz, Sascha Heuer

Unser Umgang mit personenbezogenen Daten unterliegt folgenden Bestimmungen: 
https://www.credativ.de/datenschutz/
