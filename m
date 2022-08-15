Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C785950C7
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 06:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbiHPEqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 00:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232981AbiHPEqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 00:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2ACB325
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660596179;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i1RagYWszqaSjhWpfjC6egbrOKZNG+z96AnlUoGxM5s=;
        b=OppNVZ0+96UeID/p0ojiE5t+bPilayA6ONyDPGUzM3xC8VR0eO+2GdOdgNm7EB5zvB8ueZ
        Ts/vBIoOyqtZ41EdOHJSzM1k+G67B5kAvjzA1fb0wETednwB02sQAlnkk7pVs93IHyxWR7
        BRY8EqF3FEJ47GbpiIjUkQ/zW5f56Sk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-175-uvYnCvY3Nzmqs9kMPRHvng-1; Mon, 15 Aug 2022 16:42:57 -0400
X-MC-Unique: uvYnCvY3Nzmqs9kMPRHvng-1
Received: by mail-ed1-f71.google.com with SMTP id z20-20020a05640235d400b0043e1e74a495so5433819edc.11
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 13:42:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=i1RagYWszqaSjhWpfjC6egbrOKZNG+z96AnlUoGxM5s=;
        b=ThR58hIofWEURfLFfN5cR/xpS67S6lerjf9w6onv0s8kQM8ahXfl//yKRdme5/6m+n
         SEsrqLd3MeZmah6sw1AxtVjtRA/H/lqC524yCuWVxi9FwJ3geEbB2vWNkrwAw44YcIBG
         f8hsexacTIYx31iyAGYaOpl71jIHHQXAV+Tf75l2C4idUVW+/RXCnhu4B39I670WzLF8
         UrkyIcmS316pMRik5QuQrO6nIApadFHe8mIOCE7DwTqmJcQsljSOaP0JVUsLvKLm6IeS
         1xsmTfDdqWJvAYgEFCoOHEl/fYMhQK7mpHcgprT4qIQckCClCIj1W4z8TbNdyimsBNjx
         IZjg==
X-Gm-Message-State: ACgBeo1A2NMsAtmuJuq8yi6esPz7mceiDpS7INfQYO+sQg+2Y7esetuQ
        0j5vsHFFXDjRp5Xh84UlVSPNy0HRD+vJfSupFDrUS9D63Oc/V2e/njZ3+cudEnKTRj5XPKa/1RZ
        CAcYVbg2B2VgKBAbq
X-Received: by 2002:aa7:cb83:0:b0:443:3f15:84fe with SMTP id r3-20020aa7cb83000000b004433f1584femr14740036edt.17.1660596176537;
        Mon, 15 Aug 2022 13:42:56 -0700 (PDT)
X-Google-Smtp-Source: AA6agR67uibTwHp3zJpk5WxR1XmHZTPFlM/8VgduWGMLCUUk/aIaJaspiMaWyR27MrJMbnjfUjKX9g==
X-Received: by 2002:aa7:cb83:0:b0:443:3f15:84fe with SMTP id r3-20020aa7cb83000000b004433f1584femr14740015edt.17.1660596176355;
        Mon, 15 Aug 2022 13:42:56 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id g1-20020a1709061e0100b00730a8190f54sm4421436ejj.102.2022.08.15.13.42.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 13:42:55 -0700 (PDT)
Date:   Mon, 15 Aug 2022 16:42:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        Andres Freund <andres@anarazel.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, c@redhat.com
Subject: Re: [PATCH] virtio_net: Revert "virtio_net: set the default max ring
 size by find_vqs()"
Message-ID: <20220815164013-mutt-send-email-mst@kernel.org>
References: <20220815090521.127607-1-mst@redhat.com>
 <20220815203426.GA509309@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815203426.GA509309@roeck-us.net>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 01:34:26PM -0700, Guenter Roeck wrote:
> On Mon, Aug 15, 2022 at 05:16:50AM -0400, Michael S. Tsirkin wrote:
> > This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.
> > 
> > This has been reported to trip up guests on GCP (Google Cloud).  Why is
> > not yet clear - to be debugged, but the patch itself has several other
> > issues:
> > 
> > - It treats unknown speed as < 10G
> > - It leaves userspace no way to find out the ring size set by hypervisor
> > - It tests speed when link is down
> > - It ignores the virtio spec advice:
> >         Both \field{speed} and \field{duplex} can change, thus the driver
> >         is expected to re-read these values after receiving a
> >         configuration change notification.
> > - It is not clear the performance impact has been tested properly
> > 
> > Revert the patch for now.
> > 
> > Link: https://lore.kernel.org/r/20220814212610.GA3690074%40roeck-us.net
> > Link: https://lore.kernel.org/r/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de
> > Link: https://lore.kernel.org/r/3df6bb82-1951-455d-a768-e9e1513eb667%40www.fastmail.com
> > Link: https://lore.kernel.org/r/FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE%40anarazel.de
> > Fixes: 762faee5a267 ("virtio_net: set the default max ring size by find_vqs()")
> > Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > Tested-by: Andres Freund <andres@anarazel.de>
> 
> I ran this patch through a total of 14 syskaller tests, 2 test runs each on
> 7 different crashes reported by syzkaller (as reported to the linux-kernel
> mailing list). No problems were reported. I also ran a single cross-check
> with one of the syzkaller runs on top of v6.0-rc1, without this patch.
> That test run failed.
> 
> Overall, I think we can call this fixed.
> 
> Guenter

It's more of a work around though since we don't yet have the root
cause for this. I suspect a GCP hypervisor bug at the moment.
This is excercising a path we previously only took on GFP_KERNEL
allocation failures during probe, I don't think that happens a lot.

-- 
MST

