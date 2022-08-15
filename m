Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13AAB594D6F
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 03:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233263AbiHPBDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 21:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348195AbiHPBCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 21:02:07 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DDCB9FB0;
        Mon, 15 Aug 2022 13:50:56 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id q16so7482185pgq.6;
        Mon, 15 Aug 2022 13:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=glA+4AWskQ0XcBj8UcnWlDiqOn/xWKEln7bVu+o8za4=;
        b=QQ7hvQ+ubp2iJzuj3UoaM8lWe4xQ/FUV+rXpyAd8B8F0q1DSanPwK8b8YKAu/ito2z
         EEOcMyBXUxdpbxc0dNqHywfGBX/ICtK3jTaetbb5KdVBQw67gS0C/M+TgADZAbbeyH3q
         aD0mXkAs0f4zzMC3gZJnm75uSpJnDu9MAVtISN9/J04MtSNTnO/X21jqiLLOyNMS1eji
         5cIkLVKER5CUqI1FGbTCFj0MYnXlI3gKBJ8S6kgnXvv+7mAdb2e48QKEWDZMAPWiseak
         wO2PBJnL1K5XxrkEb143yZe0LCXyHiz55SYAafuEXRc9M3XoXqVMr/rxlnUbY+ESvShL
         QacQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=glA+4AWskQ0XcBj8UcnWlDiqOn/xWKEln7bVu+o8za4=;
        b=KOziWPBO8/o6+u4/gNzTnIbbmVvOnBMEpWZWAybi8UJMEv1sCQE04CbgJCEn7glbmE
         TAXdvS9atS9+bsHcIjYEM52NRx14e0+jJlcH88ONceizg0/tGw5prkiG4bH8sgW091zO
         Px4XrxiHdsNgjm4pxo2twoHlV6v8va0xpOnLkvuSPmBWHU3jAmVdkm4HR/2jh/Y2WWpT
         VVbokeNjALBQfqU7PWyVOEW5haRjZ6f/pItx8hX+jY7z1i1kqPSYq5Ze9Kk7D0+IviQH
         o0hVQGpmmFu+um6dpzp7cptaHMthTyV31WkHZSP+4472quI1bj9dwqLmm0YaEVVBArD4
         k95g==
X-Gm-Message-State: ACgBeo0N1diDEkddeDtQ9ocvtyRokdJJ6wwq5rEcaZemoxJ0IgAE/oaZ
        oLL7KzFIZTGFBtM/Bd2cBdw=
X-Google-Smtp-Source: AA6agR7sPBhzIixnkq0W8yjYSrUdkzbyY93STp5RF3u/3ixs6au3SDQM9HC93KIyhdO/SDet4xb6jw==
X-Received: by 2002:a05:6a00:a04:b0:534:d8a6:40ce with SMTP id p4-20020a056a000a0400b00534d8a640cemr7012939pfh.15.1660596655420;
        Mon, 15 Aug 2022 13:50:55 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090a4d4800b001f4dd3b7d7fsm4975272pjh.9.2022.08.15.13.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 13:50:54 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 15 Aug 2022 13:50:53 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
Message-ID: <20220815205053.GD509309@roeck-us.net>
References: <20220815090521.127607-1-mst@redhat.com>
 <20220815203426.GA509309@roeck-us.net>
 <20220815164013-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815164013-mutt-send-email-mst@kernel.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 04:42:51PM -0400, Michael S. Tsirkin wrote:
> On Mon, Aug 15, 2022 at 01:34:26PM -0700, Guenter Roeck wrote:
> > On Mon, Aug 15, 2022 at 05:16:50AM -0400, Michael S. Tsirkin wrote:
> > > This reverts commit 762faee5a2678559d3dc09d95f8f2c54cd0466a7.
> > > 
> > > This has been reported to trip up guests on GCP (Google Cloud).  Why is
> > > not yet clear - to be debugged, but the patch itself has several other
> > > issues:
> > > 
> > > - It treats unknown speed as < 10G
> > > - It leaves userspace no way to find out the ring size set by hypervisor
> > > - It tests speed when link is down
> > > - It ignores the virtio spec advice:
> > >         Both \field{speed} and \field{duplex} can change, thus the driver
> > >         is expected to re-read these values after receiving a
> > >         configuration change notification.
> > > - It is not clear the performance impact has been tested properly
> > > 
> > > Revert the patch for now.
> > > 
> > > Link: https://lore.kernel.org/r/20220814212610.GA3690074%40roeck-us.net
> > > Link: https://lore.kernel.org/r/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de
> > > Link: https://lore.kernel.org/r/3df6bb82-1951-455d-a768-e9e1513eb667%40www.fastmail.com
> > > Link: https://lore.kernel.org/r/FCDC5DDE-3CDD-4B8A-916F-CA7D87B547CE%40anarazel.de
> > > Fixes: 762faee5a267 ("virtio_net: set the default max ring size by find_vqs()")
> > > Cc: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> > > Cc: Jason Wang <jasowang@redhat.com>
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > Tested-by: Andres Freund <andres@anarazel.de>
> > 
> > I ran this patch through a total of 14 syskaller tests, 2 test runs each on
> > 7 different crashes reported by syzkaller (as reported to the linux-kernel
> > mailing list). No problems were reported. I also ran a single cross-check
> > with one of the syzkaller runs on top of v6.0-rc1, without this patch.
> > That test run failed.
> > 
> > Overall, I think we can call this fixed.
> > 
> > Guenter
> 
> It's more of a work around though since we don't yet have the root
> cause for this. I suspect a GCP hypervisor bug at the moment.
> This is excercising a path we previously only took on GFP_KERNEL
> allocation failures during probe, I don't think that happens a lot.
>

Even a hypervisor bug should not trigger crashes like this one,
though, or at least I think so. Any idea what to look for on the
hypervisor side, and/or what it might be doing wrong ?

Thanks,
Guenter
