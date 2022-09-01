Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361AD5AA0F9
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 22:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233291AbiIAUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 16:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233094AbiIAUgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 16:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED00472EF3
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 13:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662064593;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KAlQhkA8oZVAtUjKMimmRFck4zP8R2Z4c1q1RUzZKkc=;
        b=Zf8uTJEy88tl0FzSO+rsURWRMzj4q7FTI4ZiOmyTwbp3K8AQxNxuZTxi4CSFOn9OeQerv4
        DSJAOz2e4OV/Vax2v5+oZRGnEzhhr564yKxB+DOzZPXmV/hjQCoreVlM5mWt07VTSZ4wj4
        CkE5Wye+PwhOm0XfPDOCSs5AR6MYfDo=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-76-bDVzqRdqOj27G7spVWdxYQ-1; Thu, 01 Sep 2022 16:36:33 -0400
X-MC-Unique: bDVzqRdqOj27G7spVWdxYQ-1
Received: by mail-io1-f72.google.com with SMTP id w7-20020a5d9607000000b0067c6030dfb8so17656iol.10
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 13:36:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=KAlQhkA8oZVAtUjKMimmRFck4zP8R2Z4c1q1RUzZKkc=;
        b=Y/fntbL80FDyW/dGNM/d6zsQqdPlXpuhkJCJ3QO0pceu5301AZsGQa9YxslvH1WE6K
         +NnZJk/efT0pfKYkhxCfql1awtFLdTviceh1pSsO+JPn0PIISI+FPgql1syZCz6VMm8x
         QdIvE5LR0+hVpVvSaNf/LOGU+lEE3VZSxOz42vi07Xu9RzRszuOByNCuirjMEOOtzZ1E
         j1oUuflzvhO78hQU4mwlfoTS/MguxAual+8B26kHZi+qK1qAxI2Di38HNu1xWl/KNp/p
         IasKRrbgckhD43HEHl29NXWeP2UbpGNWaU/JXPD72i/ewZD6Xb17q9C6nBfr9g7W++1x
         jPGQ==
X-Gm-Message-State: ACgBeo2Cb1IJ1qck9BwlS4taaMRnR2MXe5nVzR+1YsrFOPEXDfUSZOBv
        wGTuNnNOBa+inN41XGTSABZ3i7MUm+9y2F8LfyvAaB8UotCXihcZODBrwOwm0qVJBzdGlzeBHe9
        BDDHrNgjb0u+zOum3
X-Received: by 2002:a02:b383:0:b0:34c:e89:bd54 with SMTP id p3-20020a02b383000000b0034c0e89bd54mr4894429jan.290.1662064592200;
        Thu, 01 Sep 2022 13:36:32 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7LXo9d5a4G1Y1TjUodIAyqy9fvJQjo2moRcKMgTDEwM9dowocrU7kxQd5lUILaT/qDH2Ihdg==
X-Received: by 2002:a02:b383:0:b0:34c:e89:bd54 with SMTP id p3-20020a02b383000000b0034c0e89bd54mr4894420jan.290.1662064591916;
        Thu, 01 Sep 2022 13:36:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id b24-20020a05663801b800b00349deda465asm58914jaq.39.2022.09.01.13.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 13:36:29 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:36:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     joao.m.martins@oracle.com
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <20220901143625.4cbd3394.alex.williamson@redhat.com>
In-Reply-To: <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
        <20220901093853.60194-5-yishaih@nvidia.com>
        <20220901124742.35648bd5.alex.williamson@redhat.com>
        <b3916258-bd64-5cc8-7cbe-f7338a96bf58@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 1 Sep 2022 20:39:40 +0100
joao.m.martins@oracle.com wrote:

> On 01/09/2022 19:47, Alex Williamson wrote:
> > On Thu, 1 Sep 2022 12:38:47 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >> + * An example of the APIs on how to use/iterate over the IOVA bitmap:
> >> + *
> >> + *   bitmap = iova_bitmap_alloc(iova, length, page_size, data);
> >> + *   if (IS_ERR(bitmap))
> >> + *       return PTR_ERR(bitmap);
> >> + *
> >> + *   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
> >> + *
> >> + *   iova_bitmap_free(bitmap);
> >> + *
> >> + * An implementation of the lower end (referred to above as
> >> + * dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
> >> + * an IOVA as dirty as following:
> >> + *     iova_bitmap_set(bitmap, iova, page_size);
> >> + * Or a contiguous range (example two pages):
> >> + *     iova_bitmap_set(bitmap, iova, 2 * page_size);  
> > 
> > This seems like it implies a stronger correlation to the
> > iova_bitmap_alloc() page_size than actually exists.  The implementation
> > of the dirty_reporter_fn() may not know the reporting page_size.  The
> > value here is just a size_t and iova_bitmap handles the rest, right?
> >   
> Correct. 
> 
> The intent was to show an example of what the different usage have
> an effect in the end bitmap data (1 page and then 2 pages). An alternative
> would be:
> 
> 	An implementation of the lower end (referred to above as
> 	dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
> 	an IOVA range spanning @iova_length as dirty, using the configured
> 	@page_size:
> 
>   	  iova_bitmap_set(bitmap, iova, iova_length)
> 
> But with a different length variable (i.e. iova_length) to avoid being confused with
> the length in iova_bitmap_alloc right before this paragraph. But the example in the
> patch looks a bit more clear on the outcomes to me personally.

How about:

  Each iteration of the dirty_reporter_fn is called with a unique @iova
  and @length argument, indicating the current range available through
  the iova_bitmap.  The dirty_reporter_fn uses iova_bitmap_set() to
  mark dirty areas within that provided range

?

...
> >> +/**
> >> + * iova_bitmap_for_each() - Iterates over the bitmap
> >> + * @bitmap: IOVA bitmap to iterate
> >> + * @opaque: Additional argument to pass to the callback
> >> + * @fn: Function that gets called for each IOVA range
> >> + *
> >> + * Helper function to iterate over bitmap data representing a portion of IOVA
> >> + * space. It hides the complexity of iterating bitmaps and translating the
> >> + * mapped bitmap user pages into IOVA ranges to process.
> >> + *
> >> + * Return: 0 on success, and an error on failure either upon
> >> + * iteration or when the callback returns an error.
> >> + */
> >> +int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
> >> +			 int (*fn)(struct iova_bitmap *bitmap,
> >> +				   unsigned long iova, size_t length,
> >> +				   void *opaque))  
> > 
> > It might make sense to typedef an iova_bitmap_fn_t in the header to use
> > here.
> >  
> OK, will do. I wasn't sure which style was preferred so went with simplest on
> first take.

It looks like it would be a little cleaner, but yeah, probably largely
style.

> >> +{
> >> +	int ret = 0;
> >> +
> >> +	for (; !iova_bitmap_done(bitmap) && !ret;
> >> +	     ret = iova_bitmap_advance(bitmap)) {
> >> +		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
> >> +			 iova_bitmap_mapped_length(bitmap), opaque);
> >> +		if (ret)
> >> +			break;
> >> +	}
> >> +
> >> +	return ret;
> >> +}
> >> +
> >> +/**
> >> + * iova_bitmap_set() - Records an IOVA range in bitmap
> >> + * @bitmap: IOVA bitmap
> >> + * @iova: IOVA to start
> >> + * @length: IOVA range length
> >> + *
> >> + * Set the bits corresponding to the range [iova .. iova+length-1] in
> >> + * the user bitmap.
> >> + *
> >> + * Return: The number of bits set.  
> > 
> > Is this relevant to the caller?
> >   
> The thinking that number of bits was a way for caller to validate that
> 'some bits' was set, i.e. sort of error return value. But none of the callers
> use it today, it's true. Suppose I should remove it, following bitmap_set()
> returning void too.

I think 0/-errno are sufficient if we need an error path, otherwise
void is fine.  As above, the reporter fn isn't strongly tied to the
page size of the bitmap, so number of bits just didn't make sense to me.

> >> + */
> >> +unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> >> +			      unsigned long iova, size_t length)
> >> +{
> >> +	struct iova_bitmap_map *mapped = &bitmap->mapped;
> >> +	unsigned long nbits = max(1UL, length >> mapped->pgshift), set = nbits;
> >> +	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;  
> > 
> > There's no sanity testing here that the caller provided an iova within
> > the mapped ranged.  Thanks,
> >   
> 
> Much of the bitmap helpers don't check that the offset is within the range
> of the passed ulong array. So I followed the same thinking and the
> caller is /provided/ with the range that the IOVA bitmap covers. The intention
> was minimizing the number of operations given that this function sits on the
> hot path. I can add this extra check.

Maybe Jason can quote a standard here, audit the callers vs sanitize
the input.  It'd certainly be fair even if the test were a BUG_ON since
it violates the defined calling conventions and we're not taking
arbitrary input, but it could also pretty easily and quietly go into
the weeds if we do nothing.  Thanks,

Alex

