Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD96545515
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 21:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344828AbiFITj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 15:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbiFITj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 15:39:56 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB33C40;
        Thu,  9 Jun 2022 12:39:55 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id n197so11406442qke.1;
        Thu, 09 Jun 2022 12:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5tfF4G+wmNAqBae/QUeKWyxAUWGYbkKnmvZF4fbIoOA=;
        b=OfajvfkaCXPXne9Tib4Z5tBb+GqvdYz7rFZja2WRBM8rUTg3CM5LCehV6+ORtWSbha
         d1g3DTZJhR6Lsnz9A/ZCKsz2MnQxChU20f7QzbeYBLXlrdI83VcCWL4gpAIwxRoC5sdp
         UO9npFWrCr+62RwsHFfUAOF7BHpBIqfm8esg2DTyR0ApIBM+4uVCW1lJ1Thg9iOEG2Iq
         zLZ/3LD54gB4wzey7hQc909D8mYWIyw8fb3CuYk4ojJ/xzJVxkAusj9X3hwahc/OPVdK
         sXfOw6FhqmEUG3xZMiHOwdYYqpW+36pvEdy0tX5yuRjTIstY/EF4s9YMLYiYQyqIJg/E
         hKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5tfF4G+wmNAqBae/QUeKWyxAUWGYbkKnmvZF4fbIoOA=;
        b=KKfwLVYva77BxawnVWMRSIHPKIp8JJD8N7lwX/eSa3Htfj8EySEe0TF3gurcHSI5dU
         1aysDJpEjDx4BNCM0q/gdoAcQuD2uxWyZX6teoAmKljEDmE0QN2dVgvRBqez0GsRUU+O
         NsTzPogKhl7/avdPqLAOYhcLYoF4zjVJiK6u3IU2uVxG76R0+wQCYuOaFy/TD1A0/qX8
         85nh6VisuUvm0cjz680Gd5R9c7pOI4AMXdt60uo8F4jmzju1iuubWYuq0qORirku4H3j
         CQ/iKFyDH5TgcdhdlY7E4aT+t2aVZVhMEY5aSnd+1kSAKN9gWlbWKTLiDL3AdTC13E3A
         F3QA==
X-Gm-Message-State: AOAM531xRRXM0k8/K5idJJ5mM5/rL8iLQbVPj5BgiYfqK/fC3p1Cflys
        xxrrmvZ8UCbXdZn57EhyjNe1lk7eV87zl4J7
X-Google-Smtp-Source: ABdhPJxGOV2z1lvvqjxepBAVl/Yg+C7IQDKt8+SVGgcnopU5epeGhl3FOP77u7+BUnSSAyTZosH39g==
X-Received: by 2002:a05:620a:27c2:b0:6a7:1db:a6e2 with SMTP id i2-20020a05620a27c200b006a701dba6e2mr7069571qkp.150.1654803594959;
        Thu, 09 Jun 2022 12:39:54 -0700 (PDT)
Received: from Sassy (bras-base-oshwon9563w-grc-26-142-113-132-114.dsl.bell.ca. [142.113.132.114])
        by smtp.gmail.com with ESMTPSA id u3-20020a372e03000000b006a323e60e29sm19032378qkh.135.2022.06.09.12.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 12:39:54 -0700 (PDT)
Date:   Thu, 9 Jun 2022 15:39:53 -0400
From:   Srivathsan Sivakumar <sri.skumar05@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_main.c: convert do-while loops to for
 loops
Message-ID: <YqJMieQ3Hf8qc6nj@Sassy>
References: <YqIOp+cPXNxLAnui@Sassy>
 <20220609152653.GZ2146@kadam>
 <YqInZ/KNEJFN9kNS@Sassy>
 <20220609183419.GZ2168@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609183419.GZ2168@kadam>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 09:34:19PM +0300, Dan Carpenter wrote:
> On Thu, Jun 09, 2022 at 01:01:27PM -0400, Srivathsan Sivakumar wrote:
> > On Thu, Jun 09, 2022 at 06:26:53PM +0300, Dan Carpenter wrote:
> > > On Thu, Jun 09, 2022 at 11:15:51AM -0400, Srivathsan Sivakumar wrote:
> > > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > > > index 8c35d4c4b851..308e8b621185 100644
> > > > --- a/drivers/staging/qlge/qlge_main.c
> > > > +++ b/drivers/staging/qlge/qlge_main.c
> > > > @@ -3006,13 +3006,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> > > >  		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
> > > >  		tmp = (u64)rx_ring->lbq.base_dma;
> > > >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> > > > -		page_entries = 0;
> > > > -		do {
> > > > -			*base_indirect_ptr = cpu_to_le64(tmp);
> > > > -			tmp += DB_PAGE_SIZE;
> > > > -			base_indirect_ptr++;
> > > > -			page_entries++;
> > > > -		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
> > > > +
> > > > +		for (page_entries = 0; page_entries <
> > > > +			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
> > > > +				*base_indirect_ptr = cpu_to_le64(tmp);
> > > > +				tmp += DB_PAGE_SIZE;
> > > > +				base_indirect_ptr++;
> > > > +		}
> > > 
> > > It's better than the original, but wouldn't it be better yet to write
> > > something like this (untested):
> > > 
> > > 		for (i = 0; i <	MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> > > 			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));
> > > 
> > > Same with the other as well, obviously.
> > > 
> > > regards,
> > > dan carpenter
> > > 
> > 
> > Hello Dan,
> > 
> > Thanks for your input
> > 
> > wouldn't base_indirect_ptr point at a different endian value if tmp is
> > added with (i * DB_PAGE_SIZE)?
> 
> tmp is cpu endian so we can do math on it.  Then we convert the result
> to le64.  This is how it works before and after.  What isn't allowed
> (doesn't make sense) is to do math on endian data so "cpu_to_le64(tmp) +
> i * DB_PAGE_SIZE" is wrong.
> 
> Sparse can detect endian bugs like that:
> https://lwn.net/Articles/205624/
> 
> regards,
> dan carpenter
>

I understand now, I'll send the revised patch soon

thanks, 
Srivathsan
