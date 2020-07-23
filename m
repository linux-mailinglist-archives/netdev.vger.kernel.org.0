Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6755C22A4E7
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgGWBvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGWBvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:51:55 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BECFC0619DC;
        Wed, 22 Jul 2020 18:51:55 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id e7so3389225qti.1;
        Wed, 22 Jul 2020 18:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zxS10A7wAxoRecaoX+Mx3KcQ2CI6xAvKBIk98C9qDcE=;
        b=vBldd5movYMtCFFcfGJkt9KSEO8tYgGqM/HiLqii3LDggKyFfzq0LtJoZKCT74eusK
         Q4n6tvMgGacjj9k3cnGv6334nWpSk/0Soc/g6osXk20TSkrwQv1cs5TjFFG8/X5qaR8x
         ShD/6BgQd6m0EGcf2U8yIhGH1Sq9P1ePaoJcIZ0299u0PCnLpGRFyf5JISoY0OsWv5Cf
         XVVNyOn8Q9049MeiTZBWgQA5hkd8K4F+RfpVmVsv9vGh1GJnmN5vT4geUeiYsGC00TFs
         iJVjPttdQWbogqqcbq3TbX+u4E5xaWPgepxjc5/hTkbESzFj7lSFo67EeJvbc/zik2je
         veVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zxS10A7wAxoRecaoX+Mx3KcQ2CI6xAvKBIk98C9qDcE=;
        b=rxK82ZP7w3s5VIfMwkGhfFVy2PsgfLvfQbQ/Sy+BJfB8k1dLjMGQmJ+5KcrdwBrW0a
         Z6/NQMzQ8LAu3TVb2cMaiSfNKkDKpOJGyF2VUEvcfButdNK4sbwYCca3U0Qj72PokABF
         J8u/LLJG3tvYCQLfyueZh7fOdUKvxNhqeoKqFpkEw4zGY7/Ih4F5Rh+/SuZDdgVKHLAN
         ZTFpFDaGDW+qCt3bAkwemPPyp3xM3gvYi2GzRBIshHOgcYQyB4vbtARFTpyXU+3mUT7M
         qr1QKyohZEm6kJMxpmyYW6MgHF5ys1MrR4R64XSOnGDMo2XJ0BmhUJR+2CZmd2+Tp4oQ
         3c9w==
X-Gm-Message-State: AOAM530iXsqn6c4Hg0qj9c0k/vMhztI5l2/VWDpO29l2Np7dr32XHW1r
        9bpif4Ajlvc4neLqpiUHTmM=
X-Google-Smtp-Source: ABdhPJxtCRrwBd0g8KzYMIKjVWd5DhLZjgODh6Uzwn7DYr4cds4rEmF2zpsHhOSpks7sRGwJ8Gqymg==
X-Received: by 2002:ac8:7c9:: with SMTP id m9mr2270926qth.166.1595469113960;
        Wed, 22 Jul 2020 18:51:53 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id e25sm1340780qtc.93.2020.07.22.18.51.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 18:51:53 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9D55E27C0054;
        Wed, 22 Jul 2020 21:51:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 22 Jul 2020 21:51:52 -0400
X-ME-Sender: <xms:N-0YX14bQzCZ3WAWKAOGKXX-XcmmMF2HQbUO1tbomH_eys59i4U27A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedtgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepsghoqhhunhdr
    fhgvnhhgsehgmhgrihhlrdgtohhmnecuggftrfgrthhtvghrnhepuddvgfeutdeuhefggf
    fhlefggeevueeliefgvdfggeeukeehleelueeiiedukedunecukfhppeehvddrudehhedr
    udduuddrjedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeg
    hedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomh
    esfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:N-0YXy43x93hQrhWmbdXPXFKVvryx2G75xV0uE2CuF_SJcHX4xHxFw>
    <xmx:N-0YX8cqLiPGGzMvvVFMnkZvYI6g0wEr60TDt3UF0xVse-Gwy_sf4w>
    <xmx:N-0YX-JsbrvhAwRrUGwVwtgek6EGxlf5YgUNS1k79W8edpGAy4HZlw>
    <xmx:OO0YX7jA9R8Tj3uTsy-Em9Zy-kHODHBRMVOBeSu8s68DMK--MKcMEXx0qM0>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B93F328005E;
        Wed, 22 Jul 2020 21:51:51 -0400 (EDT)
Date:   Thu, 23 Jul 2020 09:51:49 +0800
From:   boqun.feng@gmail.com
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
Message-ID: <20200723015149.GE35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-12-boqun.feng@gmail.com>
 <MW2PR2101MB1052B072CA85F82B74BE799FD7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB1052B072CA85F82B74BE799FD7760@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 12:13:07AM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:42 PM
> > 
> > Hyper-V always use 4k page size (HV_HYP_PAGE_SIZE), so when
> > communicating with Hyper-V, a guest should always use HV_HYP_PAGE_SIZE
> > as the unit for page related data. For storvsc, the data is
> > vmbus_packet_mpb_array. And since in scsi_cmnd, sglist of pages (in unit
> > of PAGE_SIZE) is used, we need convert pages in the sglist of scsi_cmnd
> > into Hyper-V pages in vmbus_packet_mpb_array.
> > 
> > This patch does the conversion by dividing pages in sglist into Hyper-V
> > pages, offset and indexes in vmbus_packet_mpb_array are recalculated
> > accordingly.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/scsi/storvsc_drv.c | 27 +++++++++++++++++++++------
> >  1 file changed, 21 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> > index fb41636519ee..c54d25f279bc 100644
> > --- a/drivers/scsi/storvsc_drv.c
> > +++ b/drivers/scsi/storvsc_drv.c
> > @@ -1561,7 +1561,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct
> > scsi_cmnd *scmnd)
> >  	struct hv_host_device *host_dev = shost_priv(host);
> >  	struct hv_device *dev = host_dev->dev;
> >  	struct storvsc_cmd_request *cmd_request = scsi_cmd_priv(scmnd);
> > -	int i;
> > +	int i, j, k;
> >  	struct scatterlist *sgl;
> >  	unsigned int sg_count = 0;
> >  	struct vmscsi_request *vm_srb;
> > @@ -1569,6 +1569,8 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct
> > scsi_cmnd *scmnd)
> >  	struct vmbus_packet_mpb_array  *payload;
> >  	u32 payload_sz;
> >  	u32 length;
> > +	int subpage_idx = 0;
> > +	unsigned int hvpg_count = 0;
> > 
> >  	if (vmstor_proto_version <= VMSTOR_PROTO_VERSION_WIN8) {
> >  		/*
> > @@ -1643,23 +1645,36 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct
> > scsi_cmnd *scmnd)
> >  	payload_sz = sizeof(cmd_request->mpb);
> > 
> >  	if (sg_count) {
> > -		if (sg_count > MAX_PAGE_BUFFER_COUNT) {
> > +		hvpg_count = sg_count * (PAGE_SIZE / HV_HYP_PAGE_SIZE);
> 
> The above calculation doesn't take into account the offset in the
> first sglist or the overall length of the transfer, so the value of hvpg_count
> could be quite a bit bigger than it needs to be.  For example, with a 64K
> page size and an 8 Kbyte transfer size that starts at offset 60K in the
> first page, hvpg_count will be 32 when it really only needs to be 2.
> 
> The nested loops below that populate the pfn_array take the 
> offset into account when starting, so that's good.  But it will potentially
> leave allocated entries unused.  Furthermore, the nested loops could
> terminate early when enough Hyper-V size pages are mapped to PFNs
> based on the length of the transfer, even if all of the last guest size
> page has not been mapped to PFNs.  Like the offset at the beginning of
> first guest size page in the sglist, there's potentially an unused portion
> at the end of the last guest size page in the sglist.
> 

Good point. I think we could calculate the exact hvpg_count as follow:

	hvpg_count = 0;
	cur_sgl = sgl;

	for (i = 0; i < sg_count; i++) {
		hvpg_count += HVPFN_UP(cur_sg->length)
		cur_sgl = sg_next(cur_sgl);
	}

> > +		if (hvpg_count > MAX_PAGE_BUFFER_COUNT) {
> > 
> > -			payload_sz = (sg_count * sizeof(u64) +
> > +			payload_sz = (hvpg_count * sizeof(u64) +
> >  				      sizeof(struct vmbus_packet_mpb_array));
> >  			payload = kzalloc(payload_sz, GFP_ATOMIC);
> >  			if (!payload)
> >  				return SCSI_MLQUEUE_DEVICE_BUSY;
> >  		}
> > 
> > +		/*
> > +		 * sgl is a list of PAGEs, and payload->range.pfn_array
> > +		 * expects the page number in the unit of HV_HYP_PAGE_SIZE (the
> > +		 * page size that Hyper-V uses, so here we need to divide PAGEs
> > +		 * into HV_HYP_PAGE in case that PAGE_SIZE > HV_HYP_PAGE_SIZE.
> > +		 */
> >  		payload->range.len = length;
> > -		payload->range.offset = sgl[0].offset;
> > +		payload->range.offset = sgl[0].offset & ~HV_HYP_PAGE_MASK;
> > +		subpage_idx = sgl[0].offset >> HV_HYP_PAGE_SHIFT;
> > 
> >  		cur_sgl = sgl;
> > +		k = 0;
> >  		for (i = 0; i < sg_count; i++) {
> > -			payload->range.pfn_array[i] =
> > -				page_to_pfn(sg_page((cur_sgl)));
> > +			for (j = subpage_idx; j < (PAGE_SIZE / HV_HYP_PAGE_SIZE); j++) {
> 
> In the case where PAGE_SIZE == HV_HYP_PAGE_SIZE, would it help the compiler
> eliminate the loop if local variable j is declared as unsigned?  In that case the test in the
> for statement will always be false.
> 

Good point! I did the following test:

test.c:

	int func(unsigned int input, int *arr)
	{
		unsigned int i;
		int result = 0;

		for (i = input; i < 1; i++)
			result += arr[i];

		return result;
	}

if I define i as "int", I got:

	0000000000000000 <func>:
	   0:	85 ff                	test   %edi,%edi
	   2:	7f 2c                	jg     30 <func+0x30>
	   4:	48 63 d7             	movslq %edi,%rdx
	   7:	f7 df                	neg    %edi
	   9:	45 31 c0             	xor    %r8d,%r8d
	   c:	89 ff                	mov    %edi,%edi
	   e:	48 8d 04 96          	lea    (%rsi,%rdx,4),%rax
	  12:	48 01 d7             	add    %rdx,%rdi
	  15:	48 8d 54 be 04       	lea    0x4(%rsi,%rdi,4),%rdx
	  1a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
	  20:	44 03 00             	add    (%rax),%r8d
	  23:	48 83 c0 04          	add    $0x4,%rax
	  27:	48 39 d0             	cmp    %rdx,%rax
	  2a:	75 f4                	jne    20 <func+0x20>
	  2c:	44 89 c0             	mov    %r8d,%eax
	  2f:	c3                   	retq   
	  30:	45 31 c0             	xor    %r8d,%r8d
	  33:	44 89 c0             	mov    %r8d,%eax
	  36:	c3                   	retq   

and when I define i as "unsigned int", I got:

	0000000000000000 <func>:
	   0:	85 ff                	test   %edi,%edi
	   2:	75 03                	jne    7 <func+0x7>
	   4:	8b 06                	mov    (%rsi),%eax
	   6:	c3                   	retq   
	   7:	31 c0                	xor    %eax,%eax
	   9:	c3                   	retq   

So clearly it helps, I will change this in the next version.

Regards,
Boqun

> > +				payload->range.pfn_array[k] =
> > +					page_to_hvpfn(sg_page((cur_sgl))) + j;
> > +				k++;
> > +			}
> >  			cur_sgl = sg_next(cur_sgl);
> > +			subpage_idx = 0;
> >  		}
> >  	}
> > 
> > --
> > 2.27.0
> 
