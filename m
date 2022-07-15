Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B89C575B2C
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 08:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbiGOGFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 02:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiGOGFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 02:05:01 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6D474D4;
        Thu, 14 Jul 2022 23:05:00 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 70so3841295pfx.1;
        Thu, 14 Jul 2022 23:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mrpg/XBJmJ+/oHHcv0wYb5WvP4RPml2VeSt1PW2ir9A=;
        b=eSWaEY3f+1OdlU9shsxVx0eJd6s3PObO8gHUdhe5LS8f940c2AWX88RkvKOE7oH3kL
         YgbRbk6/NgOed7GPSu0/fc259P0K5pzdA/DwHkLehA1RxIa3vTpPDBtd4Yv3Wm0bsaKl
         FF40XndHp1Pw+vyBVDq5m17uy1JkqhAn4rXWXdDsCS4yRE4afy9NViORUrmur9F5QN7E
         FSuPO+WF4pk6J0IqiNxEegSeov2HVPOA3Q7bW9lGjOBQlhawqAi/V19MRkf5kWxR0J7Q
         +qbGJ9Hh8JidkYTiw5gexzKyKpxjhJhBhMGd1NU5X6VW7zvfe6uD8YR+oMpDsk4kqGZS
         TG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mrpg/XBJmJ+/oHHcv0wYb5WvP4RPml2VeSt1PW2ir9A=;
        b=bcIOnDZfBleltWBSueq5zp4Opb6O4JajsNam6XUbZYNSABBWxFpvf/qy/trteQvt2s
         o9+ZidYKNlSVLGusm7jvN/RdoAwvbh9ZmzrO/9oNS/8E6yn3my4NmsEaUpZBopxpU6G9
         PU+DlIdHd+EIauKoVm+M4apr3QhiG3ykMC3aEYvWk7JNUKqqQXeGeXinjcNxwWjhEW8+
         8jRKvJ7lHnJE4c3Uepn2hR8zzon38vNBbnmJ4v+5hfnhVM9/Ryrr8/4ZnUmMcKSFcS+x
         9qWI5ciYk+GQVqzY6egsYzK/jqO7zYgH9JEkkZ9KGqqKKKLGhH6r/vxsPsebRyBKR9CU
         reww==
X-Gm-Message-State: AJIora/EXpEliSH29lcrClUzKiQMOumm1S3+f6r/lOwd1GxaYmiITDJ8
        wl2WGcaQS7K0YRcimfRoB1RDY8gbOGZUaA==
X-Google-Smtp-Source: AGRyM1tjJeVzzQccY1rwn9TNJo8Y8S/zWMwQaieNIT6zWqwGdtppVR9GOaAYOzXU8PbxggA4I/ryfg==
X-Received: by 2002:aa7:9256:0:b0:52a:cbf7:43ea with SMTP id 22-20020aa79256000000b0052acbf743eamr12147695pfp.7.1657865099393;
        Thu, 14 Jul 2022 23:04:59 -0700 (PDT)
Received: from cloud-MacBookPro ([2601:646:8201:c2e0:310b:ff49:22f8:d171])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902b40900b0016a1e2d148csm2535146plr.32.2022.07.14.23.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 23:04:58 -0700 (PDT)
Date:   Thu, 14 Jul 2022 23:04:57 -0700
From:   binyi <dantengknight@gmail.com>
To:     Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Manish Chopra <manishc@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        Coiby Xu <coiby.xu@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: qlge: Fix indentation issue under long for
 loop
Message-ID: <20220715060457.GA2928@cloud-MacBookPro>
References: <20220710210418.GA148412@cloud-MacBookPro>
 <20220712134610.GO2338@kadam>
 <1d6fd2b271dfa0514ccb914c032e362bc4f669fa.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d6fd2b271dfa0514ccb914c032e362bc4f669fa.camel@perches.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 07:14:55AM -0700, Joe Perches wrote:
> On Tue, 2022-07-12 at 16:46 +0300, Dan Carpenter wrote:
> > On Sun, Jul 10, 2022 at 02:04:18PM -0700, Binyi Han wrote:
> > > Fix indentation issue to adhere to Linux kernel coding style,
> > > Issue found by checkpatch. Change the long for loop into 3 lines. And
> > > optimize by avoiding the multiplication.
> > 
> > There is no possible way this optimization helps benchmarks.  Better to
> > focus on readability.
> 
> I think removing the multiply _improves_ readability.
> 
> > > diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
> []
> > > @@ -3007,10 +3007,12 @@ static int qlge_start_rx_ring(struct qlge_adapter *qdev, struct rx_ring *rx_ring
> > >  		tmp = (u64)rx_ring->lbq.base_dma;
> > >  		base_indirect_ptr = rx_ring->lbq.base_indirect;
> > >  
> > > -		for (page_entries = 0; page_entries <
> > > -			MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); page_entries++)
> > > -				base_indirect_ptr[page_entries] =
> > > -					cpu_to_le64(tmp + (page_entries * DB_PAGE_SIZE));
> > > +		for (page_entries = 0;
> > > +		     page_entries < MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN);
> > > +		     page_entries++) {
> > > +			base_indirect_ptr[page_entries] = cpu_to_le64(tmp);
> > > +			tmp += DB_PAGE_SIZE;
> > 
> > I've previously said that using "int i;" is clearer here.  You would
> > kind of expect "page_entries" to be the number of entries, so it's kind
> > of misleading.  In other words, it's not just harmless wordiness and
> > needless exposition, it's actively bad.
> 
> Likely true.
> 

I agree it could be misleading. But if "page_entries" is in the for loop I
would assume it's some kind of index variable, and still it provides some
information (page entry) for the index, probably page_entry_idx could be
better name but still makes the for loop a very long one. I guess I would
leave it be.

> > I would probably just put it on one line:
> > 
> > 		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> > 			base_indirect_ptr[i] = cpu_to_le64(tmp + (i * DB_PAGE_SIZE));
> > 
> > But if you want to break it up you could do:
> > 
> > 		for (i = 0; i MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN); i++)
> > 			base_indirect_ptr[i] = cpu_to_le64(tmp +
> > 							   (i * DB_PAGE_SIZE));
> > 
> > "tmp" is kind of a bad name.  Also "base_indirect_ptr" would be better
> > as "base_indirect".
> 
> tmp is a poor name here.  Maybe dma would be better.
> 

Yeah, I think so.

> MAX_DB_PAGES_PER_BQ(QLGE_BQ_LEN) is also a poorly named macro
> where all the existing uses are QLGE_BQ_LEN.
> 
> And there's base_indirect_ptr and base_indirect_dma in the struct
> so just base_indirect might not be the best.
> 
> 		tmp = (u64)rx_ring->lbq.base_dma;
> 		base_indirect_ptr = rx_ring->lbq.base_indirect;
> 
> And clarity is good.
> Though here, clarity to value for effort though is dubious.
> 
> btw: this code got moved to staging 3 years ago.
> 
> Maybe it's getting closer to removal time.
> 

That sounds sad.

Thank you for reviewing!

Best,
Binyi
