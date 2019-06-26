Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36A2455D66
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 03:28:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbfFZB2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 21:28:30 -0400
Received: from ushosting.nmnhosting.com ([66.55.73.32]:47232 "EHLO
        ushosting.nmnhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfFZB2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 21:28:30 -0400
Received: from mail2.nmnhosting.com (unknown [202.169.106.97])
        by ushosting.nmnhosting.com (Postfix) with ESMTPS id 1D8A72DC731F;
        Tue, 25 Jun 2019 21:28:28 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=d-silva.org;
        s=201810a; t=1561512509;
        bh=53CwIRf7Bgu2C3nB/E/dYkm1SUmyHI16H7Vrw6tYZw0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XYXgZQwV/JVmjvrmmpsEfrzhsSdzQz90TZ3u4A5LuvxvOBf47Fp2ZRE6sw/yQxU8X
         TpjMqn9q/O2CpE5gTKB+jX8JuW3ZvjWwRjKNgYyQtDeLqC3AOTxGIo14uCtoknu1Ie
         FG22iYtvXLRXXqfNrSrJa+rVjda1vgisi7GOJbC+jBgTu/RViRQay4OWXhgCn3Nczb
         R37TlMkpZX8Y+mP/etyzy+OqhHUjAKgompFg31JlAIqUoS4aI+1LPHijcYXXJoVYTq
         Ygr7XlPyBBKYZb2Gi7aXZQsO2+StG1sjXOx+KdwCdKzCFyEWfWEKY/tQLkurs+ph9A
         MUUYKoT1SLivN87ZIKD5usJUxI6X9VbGAq0Giu0wTPvBE4irR3Jbh5NIjNdxwD4tWj
         TuNlZSN8qLv9Snh5uGeZMKYFnfUm7WdcPupOF8k4TJ+2MhVD7L9GTL2CGk9Qoaw7Tt
         MaiNteFekcRUw59fQrYPbrAIf7xqCZ3+cibIiO+j7YlstTAk+6ESZJ9WDAtwep+vAH
         niADVBPNIHpavAj51iob25f8WoSUtiKoWtXOYdL4L28EGQ9w2ayhlYobW1Jykne0xY
         8hbzBb2ugqf6wp6vG7XdsVpanY8BP7CyvaQOvuPAyHTsyukMlhVI18R5nWD5Fmf0gP
         U/5V+IOscL3fg+gbEE7NrBI8=
Received: from adsilva.ozlabs.ibm.com (static-82-10.transact.net.au [122.99.82.10] (may be forged))
        (authenticated bits=0)
        by mail2.nmnhosting.com (8.15.2/8.15.2) with ESMTPSA id x5Q1S75T029659
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 26 Jun 2019 11:28:23 +1000 (AEST)
        (envelope-from alastair@d-silva.org)
Message-ID: <e1b3d172f07f681fed9c311dec67cfb695408f5c.camel@d-silva.org>
Subject: Re: [PATCH v4 4/7] lib/hexdump.c: Replace ascii bool in
 hex_dump_to_buffer with flags
From:   "Alastair D'Silva" <alastair@d-silva.org>
To:     Joe Perches <joe@perches.com>
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Andrew Morton <akpm@linux-foundation.org>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-fsdevel@vger.kernel.org
Date:   Wed, 26 Jun 2019 11:27:53 +1000
In-Reply-To: <4ba3b835fb3675ea685390903a082bf8b7f9e955.camel@perches.com>
References: <20190625031726.12173-1-alastair@au1.ibm.com>
         <20190625031726.12173-5-alastair@au1.ibm.com>
         <3340b520a57e00a483eae170be97316c8d18c22c.camel@perches.com>
         <746098160c4ff6527d573d2af23c403b6d4e5b80.camel@d-silva.org>
         <4ba3b835fb3675ea685390903a082bf8b7f9e955.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2 (3.32.2-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail2.nmnhosting.com [10.0.1.20]); Wed, 26 Jun 2019 11:28:23 +1000 (AEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-06-24 at 22:19 -0700, Joe Perches wrote:
> On Tue, 2019-06-25 at 15:06 +1000, Alastair D'Silva wrote:
> > The change actions Jani's suggestion:
> > https://lkml.org/lkml/2019/6/20/343
> 
> I suggest not changing any of the existing uses of
> hex_dump_to_buffer and only use hex_dump_to_buffer_ext
> when necessary for your extended use cases.
> 
> 

I disagree, adding a wrapper for the benefit of avoiding touching a
handful of call sites that are easily amended would be adding technical
debt.

-- 
Alastair D'Silva           mob: 0423 762 819
skype: alastair_dsilva    
Twitter: @EvilDeece
blog: http://alastair.d-silva.org


