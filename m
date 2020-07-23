Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C0422A5DF
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 05:12:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbgGWDMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 23:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728902AbgGWDMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 23:12:33 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63D6C0619DC;
        Wed, 22 Jul 2020 20:12:32 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e12so3449070qtr.9;
        Wed, 22 Jul 2020 20:12:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NGDK+kNgygkQL2/duxa0tvXq/rGFs3aZ5cNCdt/QTUQ=;
        b=DZXcBEB2wi9z9ZRAQKJ6D3OL0vJYMu4fijKSF7rFTdTDIl3BFlcePkFmUuy4q9Qkid
         HA9hl/gIua0h1523F9xaf950U1dAb+lJ7/aAEf51HpNsYZlj3aO4GkfGO8ViKw1gx+kS
         C3vlq8nNA2/6F0W0JBXGjf9gQ+cw7i//IoRd6McZRg38iuXjBv9CmKSx8X4zDi1kwg8c
         LQcY37aFVU+0EApcCoiJpk89AyG6My9YWFloUf2xCTZqExc5N3gLlz2TMdecbegOgxHH
         vtF2J2SdTSgKZXDtTJ7ZNinwoSOtMZvF5IhOZpG0dryuZxM+VQ3WYoZ6q9UhPZzHrWpW
         JFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NGDK+kNgygkQL2/duxa0tvXq/rGFs3aZ5cNCdt/QTUQ=;
        b=Ua3Gd5pE/yntyM6v5Tl1WL6U7qv5kw7S3iQxSNvqnYaMyVqXF6Q22pf59WSBP16Syt
         s8XjX7husrbL+pBzeRsRshOk6ua6d2cb0JC4g15HUzgIMVVBqkpbAs6tKaC9FajGNLII
         ffZ2fkm7PdB1YSZMOTKP793nt/+tCbWH51ePcruBUXJPN3M3PnNmeE7XNi9Yvik4vyRL
         dslJWihlHpGYzk2E+3X32oWeG3W5kr9PGP26bxDrb90J6/kDaUxHxRCbgluyLiri4V1M
         es4McS5SbpOmaVMmTr6GerkgnuBkHagm59cBA011JB1MkN4qcj1sdFtXgcbSCgifw3Qm
         IWcA==
X-Gm-Message-State: AOAM530Itoho19FwMeL8dGJURnV9z1KCymFQSsxMwQjjkvMk7LCBdc88
        NZvwSzf4Xoko81zYsitfD5c=
X-Google-Smtp-Source: ABdhPJxUT7XhsW/5wqXqpsIl4TccJNtdW//KOm21QkO0JA3pKlIetB3+NjDsq33r1GNGCLyA4xm3Ag==
X-Received: by 2002:ac8:4419:: with SMTP id j25mr2575976qtn.0.1595473951192;
        Wed, 22 Jul 2020 20:12:31 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id n127sm1652301qke.29.2020.07.22.20.12.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 20:12:30 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id ED33B27C005A;
        Wed, 22 Jul 2020 23:12:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Jul 2020 23:12:28 -0400
X-ME-Sender: <xms:GwAZX5L2TzPXdLFjceNvh_7NmIC3ZE_mgEVBxQDol01dM8cCAy4Qvw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedtgdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhunhcu
    hfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrghtth
    gvrhhnpedvleeigedugfegveejhfejveeuveeiteejieekvdfgjeefudehfefhgfegvdeg
    jeenucfkphephedvrdduheehrdduuddurdejudenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:GwAZX1JEIeNbcfvdN0jQE56aFGWe2G6FFR8Ik2irM57CXhbQ8QlaoQ>
    <xmx:GwAZXxsbhKcNvcGARaFuTtGuaZI80WSBr3e522bwacceVyRd19MWkw>
    <xmx:GwAZX6Y4Ya8GCTMYUhvIllG_2hmamhT11p_GJm5D3Y3PkKn5icrcRg>
    <xmx:HAAZX2wjVqht2XPTkwVQoNX9zVgYV0HWZPW95FD8GMaj-9m3S-ByaW7tr7I>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6DCED3280060;
        Wed, 22 Jul 2020 23:12:27 -0400 (EDT)
Date:   Thu, 23 Jul 2020 11:12:25 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Michael Kelley <mikelley@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC 11/11] scsi: storvsc: Support PAGE_SIZE larger than 4K
Message-ID: <20200723031225.GA79404@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-12-boqun.feng@gmail.com>
 <MW2PR2101MB1052B072CA85F82B74BE799FD7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
 <20200723015149.GE35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
 <MW2PR2101MB1052D1FD22F1A91082843EC0D7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052D1FD22F1A91082843EC0D7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 02:26:00AM +0000, Michael Kelley wrote:
> From: boqun.feng@gmail.com <boqun.feng@gmail.com> Sent: Wednesday, July 22, 2020 6:52 PM
> > 
> > On Thu, Jul 23, 2020 at 12:13:07AM +0000, Michael Kelley wrote:
> > > From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:42 PM
> > > >
> > > > Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
> > > > communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZE
> > > > as the unit for page related data. For storvsc, the data is
> > > > vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in unit
> > > > of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cmnd
> > > > into Hyper-V pages in vmbus_packet_mpb_array.
> > > >
> > > > This patch does the conversion by dividing pages in sglist into Hyper-V
> > > > pages, offset and indexes in vmbus_packet_mpb_array are recalculated
> > > > accordingly.
> > > >
> > > > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > > > ---
> > > >  drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++++++------
> > > >  1 file changed, 21 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > > > index fb41636519ee..c54d25f279bc 100644
> > > > --- a/drivers/scsi/storvsc_drv.c
> > > > +++ b/drivers/scsi/storvsc_drv.c
> > > > @@ -1561,7 +1561,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host,
> > struct
> > > > scsi_cmnd *scmnd)
> > > >  	struct hv_host_device *host_dev = shost_priv(host);
> > > >  	struct hv_device *dev = host_dev->dev;
> > > >  	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
> > > > -	int i;
> > > > +	int i, j, k;
> > > >  	struct scatterlist *sgl;
> > > >  	unsigned int sg_count = 0;
> > > >  	struct vmscsi_request *vm_srb;
> > > > @@ -1569,6 +1569,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host,
> > struct
> > > > scsi_cmnd *scmnd)
> > > >  	struct vmbus_packet_mpb_array  *payload;
> > > >  	u32 payload_sz;
> > > >  	u32 length;
> > > > +	int subpage_idx = 0;
> > > > +	unsigned int hvpg_count = 0;
> > > >
> > > >  	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
> > > >  		/*
> > > > @@ -1643,23 +1645,36 @@ static int storvsc_queuecommand(struct Scsi_Host *host,
> > struct
> > > > scsi_cmnd *scmnd)
> > > >  	payload_sz = sizeof(cmd_request->mpb);
> > > >
> > > >  	if (sg_count) {
> > > > -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> > > > +		hvpg_count = sg_count * (PAGE_SIZE / HV_HYP_PAGE_SIZE);
> > >
> > > The above calculation doesn't take into account the offset in the
> > > first sglist or the overall length of the transfer, so the value of hvpg_count
> > > could be quite a bit bigger than it needs to be.  For example, with a 64K
> > > page size and an 8 Kbyte transfer size that starts at offset 60K in the
> > > first page, hvpg_count will be 32 when it really only needs to be 2.
> > >
> > > The nested loops below that populate the pfn_array take the
> > > offset into account when starting, so that's good.  But it will potentially
> > > leave allocated entries unused.  Furthermore, the nested loops could
> > > terminate early when enough Hyper-V size pages are mapped to PFNs
> > > based on the length of the transfer, even if all of the last guest size
> > > page has not been mapped to PFNs.  Like the offset at the beginning of
> > > first guest size page in the sglist, there's potentially an unused portion
> > > at the end of the last guest size page in the sglist.
> > >
> > 
> > Good point. I think we could calculate the exact hvpg_count as follow:
> > 
> > 	hvpg_count = 0;
> > 	cur_sgl = sgl;
> > 
> > 	for (i = 0; i < sg_count; i++) {
> > 		hvpg_count += HVPFN_UP(cur_sg->length)
> > 		cur_sgl = sg_next(cur_sgl);
> > 	}
> > 
> 
> The downside would be going around that loop a lot of times when
> the page size is 4K bytes and the I/O transfer size is something like
> 256K bytes.  I think this gives the right result in constant time:  the
> starting offset within a Hyper-V page, plus the transfer length,
> rounded up to a Hyper-V page size, and divided by the Hyper-V
> page size.
> 

Ok, then:

	hvpg_offset = sgl->offset & ~HV_HYP_PAGE_MASK;
	hvpg_count = HVPFN_UP(hv_offset + length);

?

Thanks!

Regards,
Boqun

> 
> > > > +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> > > >
> > > > -			payload_sz = (sg_count * sizeof(u64) +
> > > > +			payload_sz = (hvpg_count * sizeof(u64) +
> > > >  				      sizeof(struct vmbus_packet_mpb_array));
> > > >  			payload = kzalloc(payload_sz, GFP_ATOMIC);
> > > >  			if (!payload)
> > > >  				return SCSI_MLQUEUE_DEVICE_BUSY;
> > > >  		}
> > > >
> > > > +		/*
> > > > +		 * sgl is a list of PAGEs, and payload->range.pfn_array
> > > > +		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> > > > +		 * page size that Hyper-V uses, so here we need to divide PAGEs
> > > > +		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> > > > +		 */
> > > >  		payload->range.len = length;
> > > > -		payload->range.offset = sgl[0].offset;
> > > > +		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
> > > > +		subpage_idx = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
> > > >
> > > >  		cur_sgl = sgl;
> > > > +		k = 0;
> > > >  		for (i = 0; i < sg_count; i++) {
> > > > -			payload->range.pfn_array[i] =
> > > > -				page_to_pfn(sg_page((cur_sgl)));
> > > > +			for (j = subpage_idx; j < (PAGE_SIZE / HV_HYP_PAGE_SIZE); j++) {
> > >
> > > In the case where PAGE_SIZE == HV_HYP_PAGE_SIZE, would it help the compiler
> > > eliminate the loop if local variable j is declared as unsigned?  In that case the test in the
> > > for statement will always be false.
> > >
> > 
> > Good point! I did the following test:
> > 
> > test.c:
> > 
> > 	int func(unsigned int input, int *arr)
> > 	{
> > 		unsigned int i;
> > 		int result = 0;
> > 
> > 		for (i = input; i < 1; i++)
> > 			result += arr[i];
> > 
> > 		return result;
> > 	}
> > 
> > if I define i as "int", I got:
> > 
> > 	0000000000000000 <func>:
> > 	   0:	85 ff                	test   %edi,%edi
> > 	   2:	7f 2c                	jg     30 <func+0x30>
> > 	   4:	48 63 d7             	movslq %edi,%rdx
> > 	   7:	f7 df                	neg    %edi
> > 	   9:	45 31 c0             	xor    %r8d,%r8d
> > 	   c:	89 ff                	mov    %edi,%edi
> > 	   e:	48 8d 04 96          	lea    (%rsi,%rdx,4),%rax
> > 	  12:	48 01 d7             	add    %rdx,%rdi
> > 	  15:	48 8d 54 be 04       	lea    0x4(%rsi,%rdi,4),%rdx
> > 	  1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
> > 	  20:	44 03 00             	add    (%rax),%r8d
> > 	  23:	48 83 c0 04          	add    $0x4,%rax
> > 	  27:	48 39 d0             	cmp    %rdx,%rax
> > 	  2a:	75 f4                	jne    20 <func+0x20>
> > 	  2c:	44 89 c0             	mov    %r8d,%eax
> > 	  2f:	c3                   	retq
> > 	  30:	45 31 c0             	xor    %r8d,%r8d
> > 	  33:	44 89 c0             	mov    %r8d,%eax
> > 	  36:	c3                   	retq
> > 
> > and when I define i as "unsigned int", I got:
> > 
> > 	0000000000000000 <func>:
> > 	   0:	85 ff                	test   %edi,%edi
> > 	   2:	75 03                	jne    7 <func+0x7>
> > 	   4:	8b 06                	mov    (%rsi),%eax
> > 	   6:	c3                   	retq
> > 	   7:	31 c0                	xor    %eax,%eax
> > 	   9:	c3                   	retq
> > 
> > So clearly it helps, I will change this in the next version.
> 
> Wow!  The compiler is good ....
> 
> > 
> > Regards,
> > Boqun
> > 
> > > > +				payload->range.pfn_array[k] =
> > > > +					page_to_hvpfn(sg_page((cur_sgl))) + j;
> > > > +				k++;
> > > > +			}
> > > >  			cur_sgl = sg_next(cur_sgl);
> > > > +			subpage_idx = 0;
> > > >  		}
> > > >  	}
> > > >
> > > > --
> > > > 2.27.0
> > >
