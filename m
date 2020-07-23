Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3089A22A492
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 03:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbgGWB2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 21:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgGWB2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 21:28:20 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD154C0619DC;
        Wed, 22 Jul 2020 18:28:20 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id z15so3940743qki.10;
        Wed, 22 Jul 2020 18:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ISvgzxoJxaqtfEN4cCxmEtaBa4qO2/WEkfAYC32QJPQ=;
        b=KFRhdGJbHHLCEpmHHLiG8973VYDa+If4ydc/+E7duJ0NcIOOohAB/Qq59dynEm/Z8u
         eI8gL/jMkd33ppjnq6XGc3cGCGg0z0UCZrue73FNRJQbh+bR63igYlsuAPjuLas6GkOj
         UGEjgg4jV5GycvGZnBbftdXpr7hGHa5QSDUUMik+oLF6sUncqyzdTsv+Al7+ACGJxMUu
         pIq9vE1pmgaFKjR8Y9UJa8v4lqxzRKyXWWQRNb5MB7WlnwISi2LhNii2TyI/EGZGavZk
         zABZ+wKNWg/hPMvm+PmKK3XEnyGIgZow1KaF/DjkvQRXrWBJZWa6C7ov6gCqPdzvOw3N
         Crmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ISvgzxoJxaqtfEN4cCxmEtaBa4qO2/WEkfAYC32QJPQ=;
        b=PdlwSf0PLa1smg4EhJ7hyIDW3QvNu8OZV3/Nrd6hJxFGx/Zi2NcoSJRs0xcOdhN+oG
         WqzSnORrlYBfz3JUOlcHdEB7OG5QTu5ScHQ4AXmDgZRswT/51dioVK+6Ww+kAJgwOqqc
         fKP6WSl11t8/IYdboZS/6Vc5oxWGttrpB23QQKhCL4QvMI266JMsbKkHroyGwyR+kThj
         RCNmY8EEGA8mFoTyIgGSlpXFsQD1qGsgMMOMZ+u6VlYl2PYMGkH+R/X4yPo/mMsXa5o0
         vtEZVw5x0zQquJRJvzla5UGl6L34n1WW8XKB4LASDJ8FF2dlfZ1iFQl1DizXmgEmzu14
         CF8A==
X-Gm-Message-State: AOAM530B7rh3bSUOCN25vn2PcHhgwjwW2rJUHpL2vEpMeAcxUyPsYeMd
        G7QtmfJiuztG4PtREHs7I78=
X-Google-Smtp-Source: ABdhPJwioK3vBm5SNOB4zOe+LvL66NxrJ+j/NpajF6LJW3yIwImr04wvzo/wZHJ54a7mVYssu3SROw==
X-Received: by 2002:ae9:ef8d:: with SMTP id d135mr2836947qkg.109.1595467699964;
        Wed, 22 Jul 2020 18:28:19 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id t5sm1423180qkh.46.2020.07.22.18.28.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Jul 2020 18:28:19 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id EF10927C0054;
        Wed, 22 Jul 2020 21:28:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 22 Jul 2020 21:28:17 -0400
X-ME-Sender: <xms:sOcYX8onqX89VS5RHmezV31Yf9HDdqVO0WXYrlVckW4-Zon4tL8TKQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrhedtgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepsghoqhhunhdr
    fhgvnhhgsehgmhgrihhlrdgtohhmnecuggftrfgrthhtvghrnhepuddvgfeutdeuhefggf
    fhlefggeevueeliefgvdfggeeukeehleelueeiiedukedunecukfhppeehvddrudehhedr
    udduuddrjedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqieelvdeg
    hedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeepghhmrghilhdrtghomh
    esfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:sOcYXyqJ83aJq9JSKwOU3pzUui55376a6Ia7uEZ4GwHrcBHiJckPrg>
    <xmx:sOcYXxN7BUlFTfjNa_2Lz08krILI5ZM0BKkXyUr57G-T_vqkVyL33g>
    <xmx:sOcYXz7lTzi0PUP1FaUdejEUOVu9bTqzo7k1LZyegGfQjcmW2SPRpA>
    <xmx:secYX6TBZ0AIjtnDiQ3nXBsWvGO7UEY2EdxZkpJ_NlpHsLijiCBU85QunPQ>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0FE8F30600A3;
        Wed, 22 Jul 2020 21:28:15 -0400 (EDT)
Date:   Thu, 23 Jul 2020 09:28:14 +0800
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
Subject: Re: [RFC 09/11] HID: hyperv: Make ringbuffer at least take two pages
Message-ID: <20200723012814.GD35358@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200721014135.84140-1-boqun.feng@gmail.com>
 <20200721014135.84140-10-boqun.feng@gmail.com>
 <MW2PR2101MB10524E4C2DB9FBADEF887165D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW2PR2101MB10524E4C2DB9FBADEF887165D7790@MW2PR2101MB1052.namprd21.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 11:36:15PM +0000, Michael Kelley wrote:
> From: Boqun Feng <boqun.feng@gmail.com> Sent: Monday, July 20, 2020 6:42 PM
> > 
> > When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> > least 2 * PAGE_SIZE: one page for the header and at least one page of
> > the data part (because of the alignment requirement for double mapping).
> > 
> > So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> > using vmbus_open() to establish the vmbus connection.
> > 
> > Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> > ---
> >  drivers/hid/hid-hyperv.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/hid/hid-hyperv.c b/drivers/hid/hid-hyperv.c
> > index 0b6ee1dee625..36c5e157c691 100644
> > --- a/drivers/hid/hid-hyperv.c
> > +++ b/drivers/hid/hid-hyperv.c
> > @@ -104,8 +104,8 @@ struct synthhid_input_report {
> > 
> >  #pragma pack(pop)
> > 
> > -#define INPUTVSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> > -#define INPUTVSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> > +#define INPUTVSC_SEND_RING_BUFFER_SIZE		(128 * 1024)
> > +#define INPUTVSC_RECV_RING_BUFFER_SIZE		(128 * 1024)
> 
> Use max(40 * 1024, 2 * PAGE_SIZE) like in patch 8 of the series?
> 

Sure! Will change it in next version.

Regards,
Boqun

> > 
> > 
> >  enum pipe_prot_msg_type {
> > --
> > 2.27.0
> 
