Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7038754DFE5
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 13:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376725AbiFPLTu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 07:19:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376720AbiFPLTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 07:19:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E2955C87F
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655378387;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GJSHiXGnbIKwEFbP5SDVLebTcXv1rK1oD5ajGiN6VGI=;
        b=P/k3uAZuOzBL2oTx9r2BPPS+pRg8aSU74YeYnfaJTQ05kOPd1SvgjVLXCVVXhfS5z9wcuZ
        0TWANTk5x2L9u415DJnfmpg91+Sq4WV5txG26p+Q7XSQsyShPYg/LucX7mLvx5acL/8VQy
        PYXobtEUCHWESkulqzcd/SrfqOj29SA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-249-JuP08_R9PV6QdLeDamdLtw-1; Thu, 16 Jun 2022 07:19:46 -0400
X-MC-Unique: JuP08_R9PV6QdLeDamdLtw-1
Received: by mail-qk1-f199.google.com with SMTP id bk10-20020a05620a1a0a00b006a6b1d676ebso1466523qkb.0
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 04:19:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GJSHiXGnbIKwEFbP5SDVLebTcXv1rK1oD5ajGiN6VGI=;
        b=tLalLQiHAV96How3p6q5wJ/1lj1ImxBmaeI0lRhx6McetoqJEimM0n/GHKj0f8Oays
         BlwNciy1p/sX0WvHgNJO7ohT0St98Em86SW3Cs6QCPE2fBnXCJXCw6/ECT5ZdfVtK3Aw
         fPpRnsk22cGhnzz2ONxGCxhjEiUvhIbRaHLJQV5mIovTi+5a1U/ip1HKYCR+cwqzqs9D
         g/eZtDCPaiboLkxfkVXL4vTxh7iluoivpYYoSPe/ApAN+scJxSOZSr6bEZYJhu4I3yd7
         mq7zwkpdIpKr6/Mwc24X95JvoS5TnFkyu5qZ7JIHeCGcHc7TnxtJutXewpIF8BCPugEM
         16uw==
X-Gm-Message-State: AJIora9tVOl2vBt/ihoxjLJrc6sMoNAEdv6KYzRmX1tfM2pERtmRFyCX
        nQHkS5kC/LJLnWfRXF52cYpXYwErdb65mAN2sLIt4j0XvtNNIX4wiFtaIvPTmQPCxk86A5bi6Ye
        7t+mOOApxmU4anlWK
X-Received: by 2002:a05:6214:23c8:b0:45f:b582:346e with SMTP id hr8-20020a05621423c800b0045fb582346emr3505539qvb.109.1655378385560;
        Thu, 16 Jun 2022 04:19:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vPN3NH8XTlj3THOQd1RTUVZn+AfZCg1MWBWUAl6ty7RvnBmiNf2CcC5MJboEh3hTayNo/tiw==
X-Received: by 2002:a05:6214:23c8:b0:45f:b582:346e with SMTP id hr8-20020a05621423c800b0045fb582346emr3505524qvb.109.1655378385294;
        Thu, 16 Jun 2022 04:19:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id c4-20020a05620a268400b006a691904891sm1588334qkp.16.2022.06.16.04.19.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 04:19:44 -0700 (PDT)
Message-ID: <648a6e70fdfaa94ee678abda210860287ad09bc3.camel@redhat.com>
Subject: Re: [PATCH v3] ax25: use GFP_KERNEL in ax25_dev_device_up()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Peter Lafreniere <pjlafren@mtu.edu>, linux-hams@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date:   Thu, 16 Jun 2022 13:19:42 +0200
In-Reply-To: <20220615220947.3767-1-pjlafren@mtu.edu>
References: <20220615220947.3767-1-pjlafren@mtu.edu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, 2022-06-15 at 18:09 -0400, Peter Lafreniere wrote:
> ax25_dev_device_up() is only called during device setup, which is
> done in user context. In addition, ax25_dev_device_up()
> unconditionally calls ax25_register_dev_sysctl(), which already
> allocates with GFP_KERNEL.
> 
> Since it is allowed to sleep in this function, here we change
> ax25_dev_device_up() to use GFP_KERNEL to reduce unnecessary
> out-of-memory errors.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Peter Lafreniere <pjlafren@mtu.edu>
> ---
> v2 -> v3:
>  - Rebased for clean application to net-next
> 
> v1 -> v2:
>  - Renamed patch from "ax25: use GFP_KERNEL over GFP_ATOMIC where possible"
>    (Is that okay?)
>  - Removed invalid changes to ax25_rt_add()
> 
>  net/ax25/ax25_dev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
> index ab88b6ac5401..2093f94f6852 100644
> --- a/net/ax25/ax25_dev.c
> +++ b/net/ax25/ax25_dev.c
> @@ -52,7 +52,7 @@ void ax25_dev_device_up(struct net_device *dev)
>  {
>  	ax25_dev *ax25_dev;
>  
> -	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_ATOMIC)) == NULL) {
> +	if ((ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_KERNEL)) == NULL) {
>  		printk(KERN_ERR "AX.25: ax25_dev_device_up - out of memory\n");
>  		return;
>  	}

Since you are touching this line, please move the assignment in a
separate statement:

	ax25_dev = kzalloc(sizeof(*ax25_dev), GFP_KERNEL);
	if (!ax25_dev) {

so that we get rid of this obsolete codying style.

Thanks!

Paolo

