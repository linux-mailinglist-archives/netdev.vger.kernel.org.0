Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49A545291
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 19:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238852AbiFIRBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 13:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiFIRBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 13:01:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D1C9B490;
        Thu,  9 Jun 2022 10:01:31 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id c8so17609633qtj.1;
        Thu, 09 Jun 2022 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jnwjuzj3MrO/cwr2OIkDIAaSQBe3BajVFxJznUYian0=;
        b=KXqRhtXyWnfMMh67/l7UqFNSak6iRPazY7CXKZ8kXMQ28xL6ZgU/jokUz5eYFK4Fmf
         RSP4C1zwYfySDnFihTA+aG73lcyhQC2oUpja4Q0z5PZNdMPTSBVEYPXBzvrR3kLqDuUg
         ER3zClQ+6tt0BFGJmHXW9WWL6C/D68LHpXXhtEzC4d0A960OviV85LsphNuoMihi4fFT
         YicoSQdctm46hGSz4YgrEhYfyp1IhVjilwY7hZWzC9CLWNXUqD5eVMJb2GoUnLVzr3b2
         DRSDlDXTuIhIt3SoJuqetEdNDvg+rkRNVFpE574dSoUVTyyg9zOKm2gnPxvyT2p3csIP
         iHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jnwjuzj3MrO/cwr2OIkDIAaSQBe3BajVFxJznUYian0=;
        b=BMNFADqC2KJFEuzd7enq9kZLdIXCqPiqc2NMIsk7DOe5moLPgPsNkvAhcOYt4D1iiD
         8qKSotbixVh1q62x1llRKLY4sP3/UllogRQ/R/7G0qMhf2MdX3o7lIQf+YXs0wfGDwAb
         uetnjp6pMMHdB+1N4Dhr1LnghzzfQmVhXqTtJOBzZ30EeFgxPOXvYdmbnkkai+zXFAwK
         3khxGcl5G2eP7HntsigCNyseqmforT0TptiTkhXE72+Wr8GTn37CZw/saj7Mxx1poAti
         aLcurJpAevC2JMrbMuwmeM0WNv7h89Q5Qc960e8vDQJ3a11qKfPrPNdfPD4NxTsCzQja
         mGbA==
X-Gm-Message-State: AOAM533T4ObLrQErw3264v5boVJdrk+Lf8m/2xfThzK1ay2uxLWTG1DS
        /p7NFE9SUbFTN+bSyfPrAYz6XLwRrYSCKmD3
X-Google-Smtp-Source: ABdhPJxUnc6jx6BU5l82GJ9gkvxlowGGDi71/wPGyxGzCs8eaISpn9agirY+M5cMSde/PUqXlbAjrw==
X-Received: by 2002:ac8:5a11:0:b0:304:bab8:66f3 with SMTP id n17-20020ac85a11000000b00304bab866f3mr32399696qta.388.1654794089992;
        Thu, 09 Jun 2022 10:01:29 -0700 (PDT)
Received: from Sassy (bras-base-oshwon9563w-grc-26-142-113-132-114.dsl.bell.ca. [142.113.132.114])
        by smtp.gmail.com with ESMTPSA id w17-20020a05620a445100b006a7137330e2sm4046161qkp.132.2022.06.09.10.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 10:01:29 -0700 (PDT)
Date:   Thu, 9 Jun 2022 13:01:27 -0400
From:   Srivathsan Sivakumar <sri.skumar05@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: qlge: qlge_main.c: convert do-while loops to for
 loops
Message-ID: <YqInZ/KNEJFN9kNS@Sassy>
References: <YqIOp+cPXNxLAnui@Sassy>
 <20220609152653.GZ2146@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609152653.GZ2146@kadam>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 09, 2022 at 06:26:53PM +0300, Dan Carpenter wrote:
> On Thu, Jun 09, 2022 at 11:15:51AM -0400, Srivathsan Sivakumar wrote:
> > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> > index 8c35d4c4b851..308e8b621185 100644
> > --- a/drivers/staging/qlge/qlge_main.c
> > +++ b/drivers/staging/qlge/qlge_main.c
> > @@ -3006,13 +3006,13 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> >  		cqicb->flags |= FLAGS_LL;	/* Load lbq values */
> >  		tmp = (u64)rx_ring->lbq.base_dma;
> >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> > -		page_entries = 0;
> > -		do {
> > -			*base_indirect_ptr = cpu_to_le64(tmp);
> > -			tmp += DB_PAGE_SIZE;
> > -			base_indirect_ptr++;
> > -			page_entries++;
> > -		} while (page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN));
> > +
> > +		for (page_entries = 0; page_entries <
> > +			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++) {
> > +				*base_indirect_ptr = cpu_to_le64(tmp);
> > +				tmp += DB_PAGE_SIZE;
> > +				base_indirect_ptr++;
> > +		}
> 
> It's better than the original, but wouldn't it be better yet to write
> something like this (untested):
> 
> 		for (i = 0; i <	MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> 			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));
> 
> Same with the other as well, obviously.
> 
> regards,
> dan carpenter
> 

Hello Dan,

Thanks for your input

wouldn't base_indirect_ptr point at a different endian value if tmp is
added with (i * DB_PAGE_SIZE)?

Thanks,
Srivathsan
