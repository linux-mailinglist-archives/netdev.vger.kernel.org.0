Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACEF268770
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 10:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgINIqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 04:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgINIqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 04:46:11 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C2FC06174A;
        Mon, 14 Sep 2020 01:46:10 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id g4so16751747edk.0;
        Mon, 14 Sep 2020 01:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XuGmVWQ/C1VQzn4NF907Rd7tGA3RzQj75SvBymACUwY=;
        b=KAuZQWGnWOXAmoIJ5RdYKX9qoFTKc0Gcvcq8zH+aq2w+X3GwZ73Oa2h/MdKH/g9IPu
         W0N7nAjtS9/XVhZjl6FB7tDoHdpmsKUVcwFdfCVB9lLE1OGIREhBvPZ08timIm12KiyJ
         0J5oE4+as6cuGA50OvJV2j5KrvDcM+fLZRaKPjoA4MAhx66D79/A2DVGEz1/NSu7lxAj
         JN+dUtBCntrGR3q0x8xqkxIM8p6XY7hXSUzJHwmKNyVWiMZt6YQg4iDiLtlzf5yKa5Bo
         YIchxne8SZJqBrGQQXayKoq5qbcbf++luzrFUzN8cPKLWOIn19EGYuygx2zNGbGrBudZ
         Vb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XuGmVWQ/C1VQzn4NF907Rd7tGA3RzQj75SvBymACUwY=;
        b=e4H+kOpGp01+T5WRQ8yU7DDCA/wibU1BxCJ6OHz/oJbO+mkVSoOk2nekDJrs5f3Rp3
         0l2fHEkQMixN3XCdBSOzAN3Zt7i1u18MKWVKuzLb4liX6G4NU7h+cJN/363JU1vgj0jf
         KGkvPkQ2Y4u+qF5yo87gUjd6JhIueFtBwAE7utxaa9hj8R65RS7ZnhuAiErb8gHvwDLB
         BMw8WcCjUVKVZJHUpEL3Y0OFUU7o5qGdVD3NS1+Z4/6VDhD/uXwAWOC1f/iYuHL3515e
         bOkJOiUJGBMYOtnguap8a+4WU/pDjtY7X+vLcqZfpsocI7wXrMnb9863NewBQbTraDQ9
         V59Q==
X-Gm-Message-State: AOAM5316hhMT5g6M/O5QCseRy5jeAZ4GAj/5Jmiq7ZcZDZbw1QfcYKSU
        8W4XbZkVWAIe2Z59/jN9plY=
X-Google-Smtp-Source: ABdhPJzEsKFuXqBrpFADuhzDzq7+l8150SWf9Q+c3B5bBRXqBwwccQdGwdJQXfE/OUgwIXZ37Q6rQg==
X-Received: by 2002:aa7:d059:: with SMTP id n25mr16026892edo.270.1600073169140;
        Mon, 14 Sep 2020 01:46:09 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id bz5sm7156811ejc.83.2020.09.14.01.46.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2020 01:46:08 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailauth.nyi.internal (Postfix) with ESMTP id 4F55527C0054;
        Mon, 14 Sep 2020 04:46:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Sep 2020 04:46:04 -0400
X-ME-Sender: <xms:yi1fX7cJdjPxAbgq6OtpkW20p1EEwwA5oOPDcucjS6H_STSteqW0Vg>
    <xme:yi1fXxOppuRZANpu32LzJXvEsnjYlJ8Xy18zvXascEVOW2X4JAFYQwnDzXa6hMzew
    T-2ERBIGpb9TI7jlw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeiiedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhorhhtvggutfgvtghiphdvucdlgedtmdenucfjughrpeffhffvuffkfhggtggujges
    thdtredttddtvdenucfhrhhomhepuehoqhhunhcuhfgvnhhguceosghoqhhunhdrfhgvnh
    hgsehgmhgrihhlrdgtohhmqeenucggtffrrghtthgvrhhnpedvleeigedugfegveejhfej
    veeuveeiteejieekvdfgjeefudehfefhgfegvdegjeenucfkphephedvrdduheehrdduud
    durdejudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pegsohhquhhnodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdeiledvgeehtd
    eigedqudejjeekheehhedvqdgsohhquhhnrdhfvghngheppehgmhgrihhlrdgtohhmsehf
    ihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:yi1fX0hnwWWjBhv_AMzWu1kBSFd25-1FpdweIkTWDQAaQr-UieaQ_Q>
    <xmx:yi1fX88VZwE7ao4zxSnWzGhEwJ_r-tIdsvh4ttcJW0mK6ohVHxYjhg>
    <xmx:yi1fX3sHlA8luMPiQxVkqGe7gB3fCYiIn7rL9dsUXa4FJ8CXz-iVpQ>
    <xmx:zC1fX3dLnRdBGH9yqfr9D3wNHYf_o7tV8I8UQCmEkwcfhVCYhYyXLnXzZiw>
Received: from localhost (unknown [52.155.111.71])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8D6FC306467D;
        Mon, 14 Sep 2020 04:46:01 -0400 (EDT)
Date:   Mon, 14 Sep 2020 16:46:00 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     linux-hyperv@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Michael Kelley <mikelley@microsoft.com>, will@kernel.org,
        ardb@kernel.org, arnd@arndb.de, catalin.marinas@arm.com,
        mark.rutland@arm.com, maz@kernel.org
Subject: Re: [PATCH v3 08/11] Input: hyperv-keyboard: Make ringbuffer at
 least take two pages
Message-ID: <20200914084600.GA45838@debian-boqun.qqnc3lrjykvubdpftowmye0fmh.lx.internal.cloudapp.net>
References: <20200910143455.109293-1-boqun.feng@gmail.com>
 <20200910143455.109293-9-boqun.feng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200910143455.109293-9-boqun.feng@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:34:52PM +0800, Boqun Feng wrote:
> When PAGE_SIZE > HV_HYP_PAGE_SIZE, we need the ringbuffer size to be at
> least 2 * PAGE_SIZE: one page for the header and at least one page of
> the data part (because of the alignment requirement for double mapping).
> 
> So make sure the ringbuffer sizes to be at least 2 * PAGE_SIZE when
> using vmbus_open() to establish the vmbus connection.
> 
> Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
> ---
>  drivers/input/serio/hyperv-keyboard.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/input/serio/hyperv-keyboard.c b/drivers/input/serio/hyperv-keyboard.c
> index df4e9f6f4529..6ebc61e2db3f 100644
> --- a/drivers/input/serio/hyperv-keyboard.c
> +++ b/drivers/input/serio/hyperv-keyboard.c
> @@ -75,8 +75,8 @@ struct synth_kbd_keystroke {
>  
>  #define HK_MAXIMUM_MESSAGE_SIZE 256
>  
> -#define KBD_VSC_SEND_RING_BUFFER_SIZE		(40 * 1024)
> -#define KBD_VSC_RECV_RING_BUFFER_SIZE		(40 * 1024)
> +#define KBD_VSC_SEND_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
> +#define KBD_VSC_RECV_RING_BUFFER_SIZE	max(40 * 1024, (int)(2 * PAGE_SIZE))
>  

Hmm.. just realized there is a problem here, if PAGE_SIZE = 16k, then
40 * 1024 > 2 * PAGE_SIZE, however in the ring buffer size should also
be page aligned, otherwise vmbus_open() will fail.

I plan to modify this as

in linux/hyperv.h:

#define VMBUS_RING_SIZE(payload_sz) PAGE_ALIGN(sizeof(struct hv_ring_buffer) + (playload_sz))

and here:

#define KBD_VSC_SEND_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)
#define KBD_VSC_RECV_RING_BUFFER_SIZE VMBUS_RING_SIZE(36 * 1024)

and the similar change for patch #9.

Thoughts?

Regards,
Boqun

>  #define XTKBD_EMUL0     0xe0
>  #define XTKBD_EMUL1     0xe1
> -- 
> 2.28.0
> 
