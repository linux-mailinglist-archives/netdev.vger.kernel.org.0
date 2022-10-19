Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9A2604985
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 16:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbiJSOm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 10:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbiJSOmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 10:42:10 -0400
X-Greylist: delayed 445 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 19 Oct 2022 07:27:36 PDT
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1311717A01D
        for <netdev@vger.kernel.org>; Wed, 19 Oct 2022 07:27:36 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 11740 invoked from network); 19 Oct 2022 11:00:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1666170053; bh=3iSyL7Yr0KXhutVzhxVQQmQBj+WqFimMQl9DBDJpgOM=;
          h=From:To:Cc:Subject;
          b=htd/dTu9w9KQgwvCLEwNwa5TxHkcmBOR/AchgyTvSPzOO91bYFNuolLihjMgvUCga
           QhkQSx6OIaV7RtcUiDwOT4/PXQkieeEvo9M2i6E+j8fG8sgZ4clEv5JA+ld0UrsiJJ
           oiXsHc4S5f1DR8SQvJyp6cSEzJO6jR4r4aHLdAeo=
Received: from 89-64-7-202.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.7.202])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <Jason@zx2c4.com>; 19 Oct 2022 11:00:53 +0200
Date:   Wed, 19 Oct 2022 11:00:52 +0200
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH v2] wifi: rt2x00: use explicitly signed or unsigned types
Message-ID: <20221019090052.GB81503@wp.pl>
References: <20221018202734.140489-1-Jason@zx2c4.com>
 <20221019081417.3402284-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019081417.3402284-1-Jason@zx2c4.com>
X-WP-MailID: ea5fd171d046a1a6ccd8e0dd348d5991
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [4dNk]                               
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 19, 2022 at 02:14:17AM -0600, Jason A. Donenfeld wrote:
> On some platforms, `char` is unsigned, but this driver, for the most
> part, assumed it was signed. In other places, it uses `char` to mean an
> unsigned number, but only in cases when the values are small. And in
> still other places, `char` is used as a boolean. Put an end to this
> confusion by declaring explicit types, depending on the context.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Cc: Stanislaw Gruszka <stf_xl@wp.pl>
> Cc: Helmut Schaa <helmut.schaa@googlemail.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
<snip>

> @@ -3406,14 +3406,14 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
>  		} else if (rt2x00_rt(rt2x00dev, RT5390) ||
>  			   rt2x00_rt(rt2x00dev, RT5392) ||
>  			   rt2x00_rt(rt2x00dev, RT6352)) {
> -			static const char r59_non_bt[] = {0x8f, 0x8f,
> +			static const s8 r59_non_bt[] = {0x8f, 0x8f,
>  				0x8f, 0x8f, 0x8f, 0x8f, 0x8f, 0x8d,
>  				0x8a, 0x88, 0x88, 0x87, 0x87, 0x86};
>  
>  			rt2800_rfcsr_write(rt2x00dev, 59,
>  					   r59_non_bt[idx]);
>  		} else if (rt2x00_rt(rt2x00dev, RT5350)) {
> -			static const char r59_non_bt[] = {0x0b, 0x0b,
> +			static const s8 r59_non_bt[] = {0x0b, 0x0b,
>  				0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
>  				0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};

Please make those two tables u8 as well.

Regards
Stanislaw
