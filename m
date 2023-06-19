Return-Path: <netdev+bounces-11943-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24E00735616
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 13:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CA0F1C20A0A
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:46:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F118ED51A;
	Mon, 19 Jun 2023 11:46:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9264C2DC
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 11:46:49 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDB7137
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:46:46 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-31121494630so3902256f8f.3
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 04:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20221208.gappssmtp.com; s=20221208; t=1687175204; x=1689767204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QdTN+h4pTxBF1R7xcHre9g6cPzO2KdkdTYscPEGzTLM=;
        b=P4fDi611uOngEP6EdaSnzNOY1Y9HBEURzrdFMAmQOjvBAUoKi1jB05Cs3LxK3/mw+g
         LCDriaIztJ+nbZHY6sIGxlOAKrFHUkIvt02Dh3shvokTI/PyjkyG0nvpcmPYnK3l5X6C
         foXOQP5+h0yb29GFkAKAmNIrMBcZfzS4eqGGU3PVUOGta4hLMR5Pkj6yPS7HEuiLeMm+
         SbtcJ5zRBk02AuOwps126whp2tqJcflBviVkMKBNjS9aHKnfOKJQjrqa6eJeFCu8CLkd
         UhwONdMcDViELwP4lqM3sXMdYoB+J0b3oYlWSdVdlzbeyRBjc5LF+itHX6XNYJD2lTk8
         ZCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687175204; x=1689767204;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QdTN+h4pTxBF1R7xcHre9g6cPzO2KdkdTYscPEGzTLM=;
        b=d2Rov6aekwtYbgTaBNkwR69Q2IHIiyxU3TA4HIoKYe7kpsbBcdNLiOeSbOT6UcjdSu
         bYZf45mQlBEgviR+5uPfYuX1qafZ1ezFoWWJ5KydMW21+LfbGdcIdoTaZ2ehSlFklqlT
         1LaLRgYp6OJ2oNakkz4uBo9aw/gkNZ3bVlIpZqPHqdcSobjYCQKMqKNBBhcnTNvhF6nx
         tXAujGgNZ2JuEXoeI9g+dhoBxbHYSiDMuGCfKXrptMedRlhJfFRob0JyijIptmWkgiWy
         fULLaVmskdIE7uW8XeOwbnuCcvLUIv4XjBOAudE6jGb+hJhTUM8kC2DPmvLua5GoNch8
         9zrQ==
X-Gm-Message-State: AC+VfDydy/4BUdXmp8Pg8/T/o/73s/9Grmh0qJRfLI15xK8KbvJK/HPf
	1ksHKjakTy2QgAUUXBLC/+vhhX6pIfXOnUio52M=
X-Google-Smtp-Source: ACHHUZ48llS+kCE2mbeNkI9PvjAKHZDHQ6+DVkkVBa31lHuvuNsqCSvu6iqRvSbgnmoGOLso/x4MWA==
X-Received: by 2002:a5d:62cc:0:b0:30d:2184:84c0 with SMTP id o12-20020a5d62cc000000b0030d218484c0mr8443200wrv.30.1687175204447;
        Mon, 19 Jun 2023 04:46:44 -0700 (PDT)
Received: from blmsp ([2001:4090:a245:802c:bc2b:8db8:9210:41eb])
        by smtp.gmail.com with ESMTPSA id i1-20020a5d4381000000b0030c4d8930b1sm31281062wrq.91.2023.06.19.04.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 04:46:43 -0700 (PDT)
Date: Mon, 19 Jun 2023 13:46:42 +0200
From: Markus Schneider-Pargmann <msp@baylibre.com>
To: Simon Horman <simon.horman@corigine.com>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
	Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
	Wolfgang Grandegger <wg@grandegger.com>,
	Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
	linux-can@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 06/16] can: m_can: Write transmit header and data in
 one transaction
Message-ID: <20230619114642.66sccv36i4sfonny@blmsp>
References: <20230315110546.2518305-1-msp@baylibre.com>
 <20230315110546.2518305-7-msp@baylibre.com>
 <ZBLhDSl4a7AuCgNy@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZBLhDSl4a7AuCgNy@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

On Thu, Mar 16, 2023 at 10:27:41AM +0100, Simon Horman wrote:
> On Wed, Mar 15, 2023 at 12:05:36PM +0100, Markus Schneider-Pargmann wrote:
> > Combine header and data before writing to the transmit fifo to reduce
> > the overhead for peripheral chips.
> > 
> > Signed-off-by: Markus Schneider-Pargmann <msp@baylibre.com>
> 
> Thanks for addressing my comments on v2.
> 
> > ---
> >  drivers/net/can/m_can/m_can.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
> > index a5003435802b..35a2332464e5 100644
> > --- a/drivers/net/can/m_can/m_can.c
> > +++ b/drivers/net/can/m_can/m_can.c
> > @@ -1681,6 +1681,8 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> >  		m_can_write(cdev, M_CAN_TXBAR, 0x1);
> >  		/* End of xmit function for version 3.0.x */
> >  	} else {
> > +		char buf[TXB_ELEMENT_SIZE];
> > +		u8 len_padded = DIV_ROUND_UP(cf->len, 4);
> >  		/* Transmit routine for version >= v3.1.x */
> >  
> >  		txfqs = m_can_read(cdev, M_CAN_TXFQS);
> > @@ -1720,12 +1722,11 @@ static netdev_tx_t m_can_tx_handler(struct m_can_classdev *cdev)
> >  		fifo_header.dlc = FIELD_PREP(TX_BUF_MM_MASK, putidx) |
> >  			FIELD_PREP(TX_BUF_DLC_MASK, can_fd_len2dlc(cf->len)) |
> >  			fdflags | TX_BUF_EFC;
> > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID, &fifo_header, 2);
> > -		if (err)
> > -			goto out_fail;
> > +		memcpy(buf, &fifo_header, 8);
> > +		memcpy_and_pad(&buf[8], len_padded, &cf->data, cf->len, 0);
> 
> I'm probably missing something obvious here but I'm seeing:
> 
> * len_padded is the number of 4-byte words
> * but the 2nd argument to memcpy_and_pad should be a length in bytes
> * so perhaps it should be: len_padded * 4

Thank you Simon for all the reviews, finally some time to continue on
this:

Thanks for pointing this out. I updated my script used for testing so I
catch something like this the next time. I will be using
TXB_ELEMENT_SIZE - 8 to reflect the buffer size and the 8 byte offset.

Best,
Markus

> 
> >  
> > -		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_DATA,
> > -				       cf->data, DIV_ROUND_UP(cf->len, 4));
> > +		err = m_can_fifo_write(cdev, putidx, M_CAN_FIFO_ID,
> > +				       buf, 2 + len_padded);
> 
> This part looks good to me :)
> 
> >  		if (err)
> >  			goto out_fail;
> >  
> > -- 
> > 2.39.2
> > 

