Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A38D6806D3
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 09:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235354AbjA3IE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 03:04:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjA3IEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 03:04:25 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11BA18AA7
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:04:22 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y11so10093310edd.6
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 00:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jSqYq94IziQ+GwHhxfEtIh9C+sIOzYwnbpL+9Sa+D6g=;
        b=zhglBq6bfoBAi2lZoEVbraO8PHMnQWwTAHAZCSi7U8Oc5A/AZgMo3p8pR21FZtnjFI
         BM+mozWKaD4/5047N/CFDup7OEzAFUV+lH7agDR9MaOsux9+X9xeFgUUqMg9CCnWIxvv
         oWaf6slopNBDYo4PSP5+TlXlhweEAyMfp2CR7Y4UQAXm8M8oqTiPnndTVsxjv/BMlFjN
         MmH+wnwUp6AFgrwdnarYh2SdfGXve8XPuscQgX5f7UMMnV/owVJ0wtyHA+U27Lfy9L6o
         ANalzT/5F+ybUAfoLrgj3Oqj7beXlJjB7yNyt6IAwJXBdiFvxVW+baTybtBcCSemCGab
         xE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSqYq94IziQ+GwHhxfEtIh9C+sIOzYwnbpL+9Sa+D6g=;
        b=BCGGep20cGcnUNiUCj8/i6c29zF01OgJxnVEhuhf4VlgxxEDmthgjQdspM27gVjrSB
         jOuoLmF+kyeMv2AsHWGuzd8GdEwlKF32pFefq7A4u+EnOzfaSxL8d3UyMKGVZSUy/2fi
         bFvweUrpfUBuI9o8Rt3Cv5d6jhMoNCcfFcxfjTtC37nb5LZTMZH8WPvlqSetxErARKC8
         W8Wg6Ia6wDu12Mdt+glKEoMrdn+a8A2Re0eI1DafD6waPiFPQMBwZ9pEL470ODRP9nPD
         7KcJ0icE1evANfMTaTMdv8Wv3TtBmAVxuPI6DeAwj5TVE6aEZlRza+RkMHH5VUqKJgj1
         iPXA==
X-Gm-Message-State: AO0yUKXmlfNx+prmaHK22GKKR7UADqiv4dBbyXAoS9nhtzT+DUuiFXAi
        THu3ZqQ3/qMCCRLR/XVVoTyeyA==
X-Google-Smtp-Source: AK7set+cYVCENCwEm1hET+u41SxqRExvo79clTCj9hVoH4l/i9hXms0u8pq9XPXi1dlZc2QxBHeeAw==
X-Received: by 2002:aa7:cf89:0:b0:49c:9999:600e with SMTP id z9-20020aa7cf89000000b0049c9999600emr5570934edx.11.1675065861267;
        Mon, 30 Jan 2023 00:04:21 -0800 (PST)
Received: from blmsp ([2001:4091:a247:815f:d5ca:514b:67d4:fc9f])
        by smtp.gmail.com with ESMTPSA id n14-20020a056402060e00b00499703df898sm6359296edv.69.2023.01.30.00.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 00:04:20 -0800 (PST)
Date:   Mon, 30 Jan 2023 09:04:19 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 08/18] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <20230130080419.dzdnmq4vtag7wbpd@blmsp>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-9-msp@baylibre.com>
 <Y9I0KEeWq0JFy6iB@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9I0KEeWq0JFy6iB@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Thu, Jan 26, 2023 at 09:04:56AM +0100, Simon Horman wrote:
> On Wed, Jan 25, 2023 at 08:50:49PM +0100, Markus Schneider-Pargmann wrote:
> > Combine header and data before writing to the transmit fifo to reduce
> > the overhead for peripheral chips.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > ---
> >  drivers/net/can/m_can/m_can.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > index 78f6ed744c36..440bc0536951 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > @@ -1681,6 +1681,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> >  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
> >  		/* End of xmit function for version 3.0.x */
> >  	} else {
> > +		char buf[TXB_ELEMENT_SIZE];
> >  		/* Transmit routine for version >= v3.1.x */
> >  
> >  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> > @@ -1720,12 +1721,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> >  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
> >  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
> >  			fdflags | TX_BUF_EFC;
> > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> > -		if (err)
> > -			goto out_fail;
> > +		memcpy(buf, &fifo_header, 8);
> > +		memcpy(&buf[8], &cf->data, cf->len);
> >  
> > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> > -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> > +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> > +				       buf, 8 + DIV_ROUND_UP(cf->len, 4));
> 
> Perhaps I am missing something here, but my reading is that:
> 
> - 8 is a length in bytes
> - the 5th argument to m_can_fifo_write is the val_count parameter,
>   whose unit is 4-byte long values.
> 
>   By this logic, perhaps the correct value for this argument is:
> 
>   DIV_ROUND_UP(8 + cf->len, 4)

Thank you for spotting this. You are totally right, I will fix it for
the next version.

> 
> Also:
> 
> - If cf->len is not a multiple of 4, is there a possibility
>   that uninitialised trailing data in buf will be used
>   indirectly by m_can_fifo_write()?

Good point. I think this can only happen for 1, 2, 3, 5, 6, 7 bytes,
values above have to be multiple of 4 because of the CAN-FD
specification.

With 'buf' it should read garbage from the buffer which I think is not a
problem as the chip knows how much of the data to use. Also the tx
elemnt size is hardcoded to 64 byte in the driver, so we do not overwrite
the next element with that. The chip minimum size is 8 bytes for the
data field anyways. So I think this is fine.

Thanks,
Markus

> 
> >  		if (err)
> >  			goto out_fail;
> >  
> > -- 
> > 2.39.0
> > 
