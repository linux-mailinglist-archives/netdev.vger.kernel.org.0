Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4475A5F6C
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 11:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbiH3J3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 05:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiH3J3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 05:29:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C286DDA80
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 02:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661851739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ah8/qz4A6ZAu9RX3bIj/W9IVTkE4sUTVT6VwswPKF2w=;
        b=OoXD4reHmEpETLN+bDFmWwixapkAECSKnYwjQTZP2pS8AjfUvoWfjN6+gHG2QhC4XA3yih
        7/Nh6baN13moZRGOu2GbRsomxnXIL1HRAsTqSukpn0uk76uJ5EKarKvIgB5HvKtcZgrtEs
        vWH1l2i1L8slmaQXfIhrOZI1W04fsHs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-570-PIpoL6fwM5mAdxFx-_D3dA-1; Tue, 30 Aug 2022 05:28:56 -0400
X-MC-Unique: PIpoL6fwM5mAdxFx-_D3dA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 133568039A1;
        Tue, 30 Aug 2022 09:28:56 +0000 (UTC)
Received: from starship (unknown [10.40.194.96])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 17F34492C3B;
        Tue, 30 Aug 2022 09:28:53 +0000 (UTC)
Message-ID: <bd59ecdaadfb5d515a487cf235f5339ce8808f9c.camel@redhat.com>
Subject: Re: Commit 'r8152: fix a WOL issue' makes Ethernet port on Lenovo
 Thunderbolt 3 dock go crazy
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Date:   Tue, 30 Aug 2022 12:28:52 +0300
In-Reply-To: <d88838ed-f49a-ac9f-5b4c-8e58cabf76fb@leemhuis.info>
References: <3745745afedb2eff890277041896356149a8f2bf.camel@redhat.com>
         <339e2f94-213c-d707-b792-86d53329b3e5@leemhuis.info>
         <8c214c0b-4b8f-5e62-5aef-76668987e8fd@leemhuis.info>
         <20220825091343.2e5f99dd@kernel.org>
         <d88838ed-f49a-ac9f-5b4c-8e58cabf76fb@leemhuis.info>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-08-26 at 09:49 +0200, Thorsten Leemhuis wrote:
> On 25.08.22 18:13, Jakub Kicinski wrote:
> > On Thu, 25 Aug 2022 09:26:21 +0200 Thorsten Leemhuis wrote:
> > > On 24.08.22 13:16, Thorsten Leemhuis wrote:
> > > > Hi, this is your Linux kernel regression tracker.
> > > > 
> > > > Quick note before the boilerplate: there is another report about issues
> > > > caused by cdf0b86b250fd3 also involving a dock, but apparently it's
> > > > ignored so far:
> > > > https://bugzilla.kernel.org/show_bug.cgi?id=216333  
> > > 
> > > TWIMC, apparently it's the same problem.
> > > 
> > > Fun fact: Hayes discussed this in privately with the bug reporter
> > > according to this comment:
> > > https://bugzilla.kernel.org/show_bug.cgi?id=216333#c3
> > > 
> > > Well, that's not how things normally should be handled, but whatever, he
> > > in the end recently submitted a patch to fix it that is already merged
> > > to net.git:
> > > 
> > > https://lore.kernel.org/lkml/20220818080620.14538-394-nic_swsd@realtek.com/
> > 
> > Yup, it will be part of 6.0-rc3. 

Thank you all very much! -rc3 indeed works for me!

Best regards,
	Maxim Levitsky

> 
> Great. BTW, a small note for Hayes and reviewers: The commit
> b75d61201444 ("r8152: fix the RX FIFO settings when suspending") links
> to the report with a "BugLink" tag. You want to use plain "Link:" tags
> instead, as explained in the documentation. Also: a "BugLink" tag not
> that long ago made Linus write:
> 
> ```
> please stop making up random tags that make no sense.
> 
> Just use "Link:"
> ```
> 
> Quote from:
> https://lore.kernel.org/all/CAHk-=wgs38ZrfPvy=nOwVkVzjpM3VFU1zobP37Fwd_h9iAD5JQ@mail.gmail.com/
> 
> Ciao, Thorsten
> 


