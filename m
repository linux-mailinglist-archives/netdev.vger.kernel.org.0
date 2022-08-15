Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C020592A93
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 10:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240763AbiHOICf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 04:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240479AbiHOICQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 04:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46B621C916
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 01:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660550534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Jg8oqAlmws/gbyv4WS+sTS1PPZS3LzrawxvloBs8oY=;
        b=Z24iyj5xhKIKE1u3wG4s7TIf7Nrm7kwvTQEKAlSPxyZlY3ZWDMvHsLGX2O8BVeSMxcyjmz
        EqRIPNbAYtE6aTqSkVXmQzZMSlX0FiUOOs9C+u7V3kxrQTcLAYMteXQAqsK7bVR6WDZvth
        3KOsdhkH0oAiJKd7eToCrd5i1D844mc=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-592-eL2xvlZ1OGWTGXyvnOyWsg-1; Mon, 15 Aug 2022 04:02:13 -0400
X-MC-Unique: eL2xvlZ1OGWTGXyvnOyWsg-1
Received: by mail-ed1-f71.google.com with SMTP id y16-20020a056402359000b0043db5186943so4313273edc.3
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 01:02:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=4Jg8oqAlmws/gbyv4WS+sTS1PPZS3LzrawxvloBs8oY=;
        b=2AePo2zIQ9DkkToQ8o+L5cOr5yaaZpGywi6lX+vktVKxLiOCExbO6wKUTTNViobvra
         tkUIT8a88zV0eIZ5NN4KGBYzbT3ztzyjIL/yEIC1QEcnUsSWakX9Qns//eWOsDjZVDKU
         NpaabtBmqbadhx+LEGXJH/7ntai3AvallZpuJ9Q/qBHk7lO+480IOq7tTmts177h29DL
         aaVyVS75VKYDbU7JmOW26UbRIsZR+OZzfrMMiDTQwSxQl50yli+7WIzYJV5wKTspJByn
         HQhAftXyJgMC+npwgWBwTcSu2A62ZeJj3S5DVANMuuLYtChqD6mo9BCFbp6RJtesLV5U
         q9JA==
X-Gm-Message-State: ACgBeo2QTBTl0jJk+8P3ojdjebkcaiSEjAeHcRz9Z0pZUqP+zXKP3Wju
        vYFR1xow9NBgSZjy1kYL8IuJZ37VcFoflKqvjtn6NBxRz2gc8EOIXAKwxL5ge8Wth8LUfyzFYU0
        JCgsByhj2nNc/RHgW
X-Received: by 2002:a17:907:c0d:b0:730:a85d:8300 with SMTP id ga13-20020a1709070c0d00b00730a85d8300mr9882748ejc.558.1660550531938;
        Mon, 15 Aug 2022 01:02:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4SndJAy1focKXdgrNdhVF4iukl3tw5+oox/Lgaz/m0ZIdCPTQsgSe8Nmrvc7s0AInVcbyaOg==
X-Received: by 2002:a17:907:c0d:b0:730:a85d:8300 with SMTP id ga13-20020a1709070c0d00b00730a85d8300mr9882725ejc.558.1660550531668;
        Mon, 15 Aug 2022 01:02:11 -0700 (PDT)
Received: from redhat.com ([2.54.169.49])
        by smtp.gmail.com with ESMTPSA id er6-20020a056402448600b00443d8118155sm789834edb.69.2022.08.15.01.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 01:02:11 -0700 (PDT)
Date:   Mon, 15 Aug 2022 04:02:05 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Andres Freund <andres@anarazel.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: upstream kernel crashes
Message-ID: <20220815035406-mutt-send-email-mst@kernel.org>
References: <20220814212610.GA3690074@roeck-us.net>
 <CAHk-=wgf2EfLHui6A5NbWoaVBB2f8t-XBUiOMkyjN2NU41t6eA@mail.gmail.com>
 <20220814223743.26ebsbnrvrjien4f@awork3.anarazel.de>
 <CAHk-=wi6raoJE-1cyRU0YxJ+9ReO1eXmOAq0FwKAyZS7nhvk9w@mail.gmail.com>
 <1c057afa-92df-ee3c-5978-3731d3db9345@kernel.dk>
 <20220815013651.mrm7qgklk6sgpkbb@awork3.anarazel.de>
 <CAHk-=wikzU4402P-FpJRK_QwfVOS+t-3p1Wx5awGHTvr-s_0Ew@mail.gmail.com>
 <20220815071143.n2t5xsmifnigttq2@awork3.anarazel.de>
 <20220815031549-mutt-send-email-mst@kernel.org>
 <3df6bb82-1951-455d-a768-e9e1513eb667@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3df6bb82-1951-455d-a768-e9e1513eb667@www.fastmail.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 12:46:36AM -0700, Andres Freund wrote:
> Hi,
> 
> On Mon, Aug 15, 2022, at 00:29, Michael S. Tsirkin wrote:
> > On Mon, Aug 15, 2022 at 12:11:43AM -0700, Andres Freund wrote:
> >> Hi,
> >> 
> >> On 2022-08-14 20:18:44 -0700, Linus Torvalds wrote:
> >> > On Sun, Aug 14, 2022 at 6:36 PM Andres Freund <andres@anarazel.de> wrote:
> >> > >
> >> > > Some of the symptoms could be related to the issue in this thread, hence
> >> > > listing them here
> >> > 
> >> > Smells like slab corruption to me, and the problems may end up being
> >> > then largely random just depending on who ends up using the allocation
> >> > that gets trampled on.
> >> > 
> >> > I wouldn't be surprised if it's all the same thing - including your
> >> > network issue.
> >> 
> >> Yea. As I just wrote in
> >> https://postgr.es/m/20220815070203.plwjx7b3cyugpdt7%40awork3.anarazel.de I
> >> bisected it down to one commit (762faee5a267). With that commit I only see the
> >> networking issue across a few reboots, but with ebcce4926365 some boots oops
> >> badly and other times it' "just" network not working.
> >> 
> >> 
> >> [oopses]
> 
> >> If somebody knowledgeable staring at 762faee5a267 doesn't surface somebody I
> >> can create a kernel with some more debugging stuff enabled, if somebody tells
> >> me what'd work best here.
> >> 
> >> 
> >> Greetings,
> >> 
> >> Andres Freund
> >
> > Thanks a lot for the work!
> > Just a small clarification:
> >
> > So IIUC you see several issues, right?
> 
> Yes, although they might be related, as theorized by Linus upthread.
> 
> > With 762faee5a2678559d3dc09d95f8f2c54cd0466a7 you see networking issues.
> 
> Yes.
> 
> 
> > With ebcce492636506443e4361db6587e6acd1a624f9 you see crashes.
> 
> Changed between rebooting. Sometimes the network issue, sometimes the crashes in the email you're replying to.
>

OK just adding:

    Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
    Acked-by: Jason Wang <jasowang@redhat.com>
	L: virtualization@lists.linux-foundation.org
	L: netdev@vger.kernel.org

I think we can drop the original Cc list:

Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jens Axboe <axboe@kernel.dk>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>

but I'm not sure, maybe they want to be informed.

> 
> > MST

