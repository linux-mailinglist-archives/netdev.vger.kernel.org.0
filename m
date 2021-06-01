Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16630397475
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234021AbhFANj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:39:56 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:61278 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233584AbhFANjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:39:55 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 151DbDgH029844;
        Tue, 1 Jun 2021 13:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Viv/x+byZDwsGUmiMZXHCsGFZQiVoyWBJs5IhnHEJY0=;
 b=jbdOC7IgyNMNemlbPbrpMbWE10+I8nNLqh7+E5akU8fQeR0Aek9XH42SjrDYQZLbx28A
 6tt5sZ5Io6YY1tPTdHlKhRf3rwjQoGCeLbubGvzpmrJfFsJc1T9TGl4UMzTJSHisTFFi
 HXg+kn+rbblV8kLYmdYnh2+3CJCHyJ9Xn6LHZg96B15idBrc/v/pKZD8nKgZq7agX8le
 MN/G/UELDh8y7P7pQhBk+ZOqEayXEHDTETn4OiV5I2NBre5aiYKNAQ6uvCF6YQIFZer5
 2djfe0eki+7Wpx2fKBUB6e65jftx/NJI1LvKTGMdkIsALgM5bLba7JtnfVWm1sNuZ9GV Zg== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 38vpk2gjs4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 13:38:10 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 151DcARp171013;
        Tue, 1 Jun 2021 13:38:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38ude8xcag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 13:38:10 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 151Dc9pT170936;
        Tue, 1 Jun 2021 13:38:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 38ude8xc9d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 13:38:09 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 151Dc7C1007167;
        Tue, 1 Jun 2021 13:38:07 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Jun 2021 13:38:07 +0000
Date:   Tue, 1 Jun 2021 16:37:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Nigel Christian <nigel.l.christian@gmail.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] NFC: microread: Pass err variable to async_cb()
Message-ID: <20210601133757.GA1955@kadam>
References: <YLYvcbjuPg1JFr7/@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLYvcbjuPg1JFr7/@fedora>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: 03Aj1Q60vjCTaQHXY3flQkZ0jgc6_-tw
X-Proofpoint-ORIG-GUID: 03Aj1Q60vjCTaQHXY3flQkZ0jgc6_-tw
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 09:00:33AM -0400, Nigel Christian wrote:
> In the case MICROREAD_CB_TYPE_READER_ALL clang reports a dead
> code warning. The error code is being directly passed to 
> async_cb(). Fix this by passing the err variable, which is also
> done in another path.
> 
> Addresses-Coverity: ("Unused value") 
> Signed-off-by: Nigel Christian <nigel.l.christian@gmail.com>
> ---
>  drivers/nfc/microread/microread.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/microread/microread.c b/drivers/nfc/microread/microread.c
> index 8d3988457c58..130b0f554016 100644
> --- a/drivers/nfc/microread/microread.c
> +++ b/drivers/nfc/microread/microread.c
> @@ -367,7 +367,7 @@ static void microread_im_transceive_cb(void *context, struct sk_buff *skb,
>  				err = -EPROTO;
>  				kfree_skb(skb);
>  				info->async_cb(info->async_cb_context, NULL,
> -					       -EPROTO);
> +					       err);

It would be better to just delete the "err = -EPROTO;" assignment.

Literals are more readable.  Avoid pointless indirection.

regards,
dan carpenter


