Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 396DF69C4F2
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 06:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbjBTFbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 00:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjBTFbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 00:31:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FB6BDCF
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 21:31:03 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id c5so562106wrr.5
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 21:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VyrfGt2FN77QTYZFXpX99DHt0bq2IkMtyc2KjQMiV8c=;
        b=e4SvGtUVBMCp2DQcqbtiNxiiPYgxiKUVXHYdpXcTHPxT2a43JvXQ2kOUpHuB2Hba97
         uzFuEHxK+pngPvI4rg27e7zXnTBs+6JKC3l0ocVndzInd+ghXrJyRCK7PNERnZFxU8Ox
         mTrWZfRZJHtkd7Ap95PyHf/wKeIOeWCEQqAZEgBA6x+94XO3jNR0k9z+Fx29/haaXQ+C
         c16c9OtfTWk9+kqSrFoCDZ87h9dRlM5ucECudTWs642QkdIJpAtPWNvi5qbxm777EW0M
         BqxFqAd1TAtrf2Tm+yUvU9nFiU0hVkWa3hZpch2XvtVbeDGpcqQ74fpzk/L+IPzUd+lJ
         RhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VyrfGt2FN77QTYZFXpX99DHt0bq2IkMtyc2KjQMiV8c=;
        b=n+3Bt4t93TlP+bhESG++hx1+mNrmZfW0uixEg7b32tKX/Fpdiy+ldGjFhed//OIobi
         DeVGiKOMYv2DUr0B5DLTki4gwZM5+qs/drBgBFlCsOxGHggqqwvd5L85JNBDJ4VPu/BB
         qXjdjKNqevESHWLbuEJCKpU2FDczozEglsyr7+a1jvhm+ikbGvXTg1f6BVKcgYlp11ub
         JyC0CBtdtGAvIrDKtiYI+k9Qy8XJON/X8CF2lsiQZFqTAtWqKh2Ob2lqbZc/MLb3gGHC
         D+CZwUxihrqghODnaWoACRS86FdK5QGzw74yYTyRfCad5Oa/8YqI1uT0foBA4d8GCTqI
         gSNg==
X-Gm-Message-State: AO0yUKXscPZ+lSfHgc7MS29Ir8v+CGqoLO560I+l1khvH2boyMxkBVjJ
        n0pv2f+o+xOYmWtQhktkdwhNaQ==
X-Google-Smtp-Source: AK7set9NxX2ASpmPL1uCTqe51ixIB3oHzSVDCLaDlY7uYoWgYJcR+6kLCNcv/ioOAj4vJorfZMwHyg==
X-Received: by 2002:adf:f942:0:b0:2c6:e87f:30cc with SMTP id q2-20020adff942000000b002c6e87f30ccmr1381373wrr.48.1676871062297;
        Sun, 19 Feb 2023 21:31:02 -0800 (PST)
Received: from blmsp ([2001:4090:a247:8056:883:2e39:923e:f1d])
        by smtp.gmail.com with ESMTPSA id t15-20020adfe10f000000b002c3f7dfd15csm3691489wrz.32.2023.02.19.21.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 21:31:01 -0800 (PST)
Date:   Mon, 20 Feb 2023 06:31:00 +0100
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
Message-ID: <20230220053100.nh2suaqi7237g5ny@blmsp>
References: <20230125195059.630377-1-msp@baylibre.com>
 <20230125195059.630377-9-msp@baylibre.com>
 <Y9I0KEeWq0JFy6iB@corigine.com>
 <20230130080419.dzdnmq4vtag7wbpd@blmsp>
 <Y95YNQwMfTM2h7iW@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y95YNQwMfTM2h7iW@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Simon,

On Sat, Feb 04, 2023 at 02:05:57PM +0100, Simon Horman wrote:
> On Mon, Jan 30, 2023 at 09:04:19AM +0100, Markus Schneider-Pargmann wrote:
> > Hi Simon,
> > 
> > On Thu, Jan 26, 2023 at 09:04:56AM +0100, Simon Horman wrote:
> > > On Wed, Jan 25, 2023 at 08:50:49PM +0100, Markus Schneider-Pargmann wrote:
> > > > Combine header and data before writing to the transmit fifo to reduce
> > > > the overhead for peripheral chips.
> > > > 
> > > > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> > > > ---
> > > >  drivers/net/can/m_can/m_can.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > > > index 78f6ed744c36..440bc0536951 100644
> > > > --- a/drivers/net/can/m_can/m_can.c
> > > > +++ b/drivers/net/can/m_can/m_can.c
> > > > @@ -1681,6 +1681,7 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> > > >  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
> > > >  		/* End of xmit function for version 3.0.x */
> > > >  	} else {
> > > > +		char buf[TXB_ELEMENT_SIZE];
> > > >  		/* Transmit routine for version >= v3.1.x */
> > > >  
> > > >  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> > > > @@ -1720,12 +1721,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> > > >  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
> > > >  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
> > > >  			fdflags | TX_BUF_EFC;
> > > > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> > > > -		if (err)
> > > > -			goto out_fail;
> > > > +		memcpy(buf, &fifo_header, 8);
> > > > +		memcpy(&buf[8], &cf->data, cf->len);
> > > >  
> > > > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> > > > -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> > > > +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> > > > +				       buf, 8 + DIV_ROUND_UP(cf->len, 4));
> > > 
> > > Perhaps I am missing something here, but my reading is that:
> > > 
> > > - 8 is a length in bytes
> > > - the 5th argument to m_can_fifo_write is the val_count parameter,
> > >   whose unit is 4-byte long values.
> > > 
> > >   By this logic, perhaps the correct value for this argument is:
> > > 
> > >   DIV_ROUND_UP(8 + cf->len, 4)
> > 
> > Thank you for spotting this. You are totally right, I will fix it for
> > the next version.
> 
> Thanks.
> 
> > > Also:
> > > 
> > > - If cf->len is not a multiple of 4, is there a possibility
> > >   that uninitialised trailing data in buf will be used
> > >   indirectly by m_can_fifo_write()?
> > 
> > Good point. I think this can only happen for 1, 2, 3, 5, 6, 7 bytes,
> > values above have to be multiple of 4 because of the CAN-FD
> > specification.
> > 
> > With 'buf' it should read garbage from the buffer which I think is not a
> > problem as the chip knows how much of the data to use. Also the tx
> > elemnt size is hardcoded to 64 byte in the driver, so we do not overwrite
> > the next element with that. The chip minimum size is 8 bytes for the
> > data field anyways. So I think this is fine.
> 
> I'm not the expert on the hw in question here, but intuitively
> I do feel that it may be unwise to send uninitialised data.
> While I'm happy to defer to you on this, I do wonder if it would be somehow
> better to use memcpy_and_pad() in place of memcpy().

Thank you, I think it is safe, but memcpy_and_pad seems like a good
solution here to make it even safer.

Best,
Markus
