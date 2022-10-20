Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C072F6058F7
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiJTHsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiJTHsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:48:11 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75FE4175358;
        Thu, 20 Oct 2022 00:48:10 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id v11so4351146wmd.1;
        Thu, 20 Oct 2022 00:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qf5Po+dJdVElVGspHE8VFD4buBHmcH+O3lP8/s/tkhw=;
        b=bOY3CcvGgLZa/ZvdMRPovqAK3wnEadOjVdcxOoEW8gj33k3x2+4xzRTt/GrdNBD61C
         stE3UZo9XJeKSLmi9ZelXeUpoxZsVzcJ8yW17Hqc3/ODhaLkz0ybt+5KhBvzSiTY+myF
         o8tZ5lG+tkrNsQyh1dmbRlxR1tOLViDAWb6kPGqtp9OAJbI+f+Xb+r2OWWvQpn6zD167
         bHZBYiUxrAKw/FbEToeyvFaADyaG2G7enKWeSiQzgifha53qF3s6IXsZkVTHk2/ImTzN
         K5A8L7yrSoCGGeVT17ob0uq5Pf2sBTTW/7tFGYt3vQCL0KalAEHjrY95aedxT62BAznJ
         L8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qf5Po+dJdVElVGspHE8VFD4buBHmcH+O3lP8/s/tkhw=;
        b=hnJvVTTO2U9chywiXy2i2StvNA1jcXZBINjc7PbODOxRgy/yAa4eD6ROOlM0pHsgdR
         1/9inVvWAY2R0uwpd2joWpJ80Av6jHLUtrcf5LxGT7c+7ZG4mKPHsdsD4xc9vbEyP36n
         va8Vc783vlj9xWRo2dgmyW//+HhTXkibIzY9kyUd22Bx/DU7SRN2Fn3HdOrLeOjrdfV7
         J/P04RMStQLu1Vm+OTH3hyVlDglvfQ1c3TiWISsGFWv8gu7VjGnh3lNtShJ7IKOY4WDK
         3azR2kUHzey5S8H9wKPSDWVzU1o2poEV7tEXD+hLOwgZjS9XBQ5WY5S7y6DJ/dU/GK9P
         iCbw==
X-Gm-Message-State: ACrzQf3Wgzgdhz7FBurJQlMACiBmzxzfLd1mdCR1+3VjP4MvSoG4Bwba
        iTJVuuLWYsQbDLN0ryWELlg=
X-Google-Smtp-Source: AMsMyM7KSr1GHJz5ONftQT7jUuF0SxuIuDR1sPSbyDStKV6tLpmvFbXydk75lR4fWvK/u9eMo+ymsQ==
X-Received: by 2002:a05:600c:3b88:b0:3c6:cef8:8465 with SMTP id n8-20020a05600c3b8800b003c6cef88465mr28767169wms.64.1666252089050;
        Thu, 20 Oct 2022 00:48:09 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id n20-20020a1c7214000000b003b5054c6f87sm2055807wmc.21.2022.10.20.00.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 00:48:08 -0700 (PDT)
Date:   Thu, 20 Oct 2022 09:48:06 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 7/9] net: microchip: sparx5: Writing rules to
 the IS2 VCAP
Message-ID: <20221020074806.ys7lyfkn7f7zpkcp@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
 <20221019114215.620969-8-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019114215.620969-8-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-19 13:42, Steen Hegelund wrote:
> +static void vcap_iter_skip_tg(struct vcap_stream_iter *itr)
> +{
> +	/* Compensate the field offset for preceding typegroups */
> +	while (itr->tg->width && itr->offset >= itr->tg->offset) {
> +		itr->offset += itr->tg->width;
> +		itr->tg++; /* next typegroup */
> +	}
> +}

It was not immediately obvious to me why it should stop iterating when
tg->width is zero. But after some digging I saw that the tg iterators
always ends with an empty element (all bits zero, and therefore width is
zero). Could this be made clearer? Or maybe this is something common
that I'm just not used to seeing.

> +static void vcap_encode_bit(u32 *stream, struct vcap_stream_iter *itr, bool val)
> +{
> +	/* When intersected by a type group field, stream the type group bits
> +	 * before continuing with the value bit
> +	 */
> +	while (itr->tg->width &&
> +	       itr->offset >= itr->tg->offset &&
> +	       itr->offset < itr->tg->offset + itr->tg->width) {
> +		int tg_bitpos = itr->tg->offset - itr->offset;
> +
> +		vcap_set_bit(stream, itr, (itr->tg->value >> tg_bitpos) & 0x1);
> +		itr->offset++;
> +		vcap_iter_update(itr);
> +	}

Same as above.

> +static void vcap_encode_typegroups(u32 *stream, int sw_width,
> +				   const struct vcap_typegroup *tg,
> +				   bool mask)
> +{
> +	struct vcap_stream_iter iter;
> +	int idx;
> +
> +	/* Mask bits must be set to zeros (inverted later when writing to the
> +	 * mask cache register), so that the mask typegroup bits consist of
> +	 * match-1 or match-0, or both
> +	 */
> +	vcap_iter_set(&iter, sw_width, tg, 0);
> +	while (iter.tg->width) {
> +		/* Set position to current typegroup bit */
> +		iter.offset = iter.tg->offset;
> +		vcap_iter_update(&iter);
> +		for (idx = 0; idx < iter.tg->width; idx++) {
> +			/* Iterate over current typegroup bits. Mask typegroup
> +			 * bits are always set
> +			 */
> +			if (mask)
> +				vcap_set_bit(stream, &iter, 0x1);
> +			else
> +				vcap_set_bit(stream, &iter,
> +					     (iter.tg->value >> idx) & 0x1);
> +			iter.offset++;
> +			vcap_iter_update(&iter);
> +		}
> +		iter.tg++; /* next typegroup */
> +	}

Same as above.

Tested on Microchip PCB135 switch.

Tested-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Casper Andersson <casper.casan@gmail.com>

Best Regards,
Casper
