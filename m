Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F763BEAEC
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 05:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391674AbfIZDnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 23:43:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44289 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391561AbfIZDns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 23:43:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id i18so618063wru.11
        for <netdev@vger.kernel.org>; Wed, 25 Sep 2019 20:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ti6ccZ5Qof3JA4rRR42TrR5os1w1D6TdLIcCGOCIc0c=;
        b=lMvHh5GXU0LjxIbnPzlXKiXgX0tSKAhNWfxswOASGPoCSuAS+8s4atAKNMxReJptGi
         YXn9yhk1+E1Zuy6FiEOI8mb6AvkqaInMqSEe2Fa7lMTjUzM1xmb+lTf1jRypWxd3HwAp
         55GCS4Z1/mfo3sk0/jVab83kc3+6O6b9D4B25jKKaujksseuoUZ4yrnLryHfHmPEbnXh
         2YDmD+U4yFvhJhWAL0kFrkvHmV5r/lvRP5QOjP1pUi9a13nunLBKyr1i/dRywmKkQlN/
         +1sVnpiQ3VsnZ7sHmefj16eS6bZmCpY87fgC4wrjOLXIA2/xjwDKvXKDkkcNhj6Wq6dY
         3+Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ti6ccZ5Qof3JA4rRR42TrR5os1w1D6TdLIcCGOCIc0c=;
        b=t8bffpWjos5i+5msrKjSW29ol1UTosJOd4LreRY9tJCJPo5ht/11/Is1MPU6j7Uu8a
         yi7Qa5aCj/SHjIrexymB0D0ii/10z4mAxKtYFGRGjoLgE/Cv1f43WO8OQTxw8E2OqssO
         XVmPP/OTcl3saYV61Tthir6vVX35O9OgmxnTsD2vYVF/JVbZrFTK9Twu/GVqIUnSUemK
         4YUtH/vhQCvG5TicYjQH6cVfOCDThhCLMuzsrhJoC7aOY/SvJfHvio2Vk4dkryDyPWVP
         8aG3jvwi/tHAJ/1nvfoHU2N30LjmwM9xeSH9B8g2uaGESceyEXcwkKCvYnNBB7SQdVQ2
         3F7A==
X-Gm-Message-State: APjAAAWNBGCbdNQQh4dnPL5B/1TTJh9X1e1nvd8evfHvXutv5sWdbIkD
        Bm5B1S6336VUuWoq9LSzGPm+HL3e
X-Google-Smtp-Source: APXvYqw0dsSjwy/YZsst2nmgxdBMSQIH/ZgIeJfb9jkDef1B5C+/IboSFkZOI1EOZibzQ/tjGRoslA==
X-Received: by 2002:adf:f404:: with SMTP id g4mr975991wro.353.1569469426940;
        Wed, 25 Sep 2019 20:43:46 -0700 (PDT)
Received: from localhost (195-70-108-137.stat.salzburg-online.at. [195.70.108.137])
        by smtp.gmail.com with ESMTPSA id c132sm850734wme.27.2019.09.25.20.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2019 20:43:46 -0700 (PDT)
Date:   Wed, 25 Sep 2019 20:43:44 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Christopher Hall <christopher.s.hall@intel.com>
Subject: Re: [net-next v2 1/2] ptp: correctly disable flags on old ioctls
Message-ID: <20190926034344.GA21883@localhost>
References: <20190926022820.7900-1-jacob.e.keller@intel.com>
 <20190926022820.7900-2-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926022820.7900-2-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 25, 2019 at 07:28:19PM -0700, Jacob Keller wrote:
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 9c18476d8d10..67d0199840fd 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -155,7 +155,7 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
>  			err = -EINVAL;
>  			break;
>  		} else if (cmd == PTP_EXTTS_REQUEST) {
> -			req.extts.flags &= ~PTP_EXTTS_VALID_FLAGS;
> +			req.extts.flags &= PTP_EXTTS_V1_VALID_FLAGS;

Duh, the bit wise negation was not the intention.  Thanks for catching
this, and introducing the "V1" set of flags makes sense.

@davem Please merge this patch as a bug fix.

Acked-by: Richard Cochran <richardcochran@gmail.com>
