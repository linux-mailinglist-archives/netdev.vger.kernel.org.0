Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C62E2D9F9
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfE2KGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:06:14 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:60151 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbfE2KGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 06:06:13 -0400
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 May 2019 06:06:12 EDT
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id A37261B2A;
        Wed, 29 May 2019 05:57:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 May 2019 05:57:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sakamocchi.jp;
         h=date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=U
        v/IO1lpsMhYefZCZE7IzUSu7PAH6TRG1LbnuRgviM4=; b=mn/7Y1LZeF5WEZX9C
        kyxZtrcWF3ULGfrAWaVTCu5SVtlugVE3VqZmjWKq6xRLw16HfohMo8gWCyfoiTDU
        8ddDr3hcah8IDP6Hys4o8IC2EdotB5aWhP8EraoIMIJh7rSxM+BKMMZLl9NkVZnK
        u8d8d3Tq/d+bMYPb6BDrLZqiB9tpWxyCpNDdk+W8+YDBdrWfUs98RZG9TU53K7Dz
        JzBTbjFIf3kdd64Cj3KvVjOeVIk0m+zXZwZfm3VO+qvQIqvJ5VIncx8ff7FI9cB1
        yNg71nTx/SLC0V1NRLStXOGxLLLNq2SftFdwZcoJwvxVzm0f9yJ9xJHcvbMQXOqS
        f9JWA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=Uv/IO1lpsMhYefZCZE7IzUSu7PAH6TRG1LbnuRgvi
        M4=; b=XISi7eb0l5udJyx94Grx8xbNBu9uDmTspw9Ab8MZI6lurhPep2RI+RxCG
        ZQTte0gx97SzC5lbqL/OsmzePdtwqlKhCnCKwx+J0wQH/g8awSkdq4a1owukWtLA
        pSl7na4swI9Jn5vGwVD9JNDTU+FqQo7zHiwOYrXVPzhmvKU0bhF2leedTKJqnsWJ
        ZtZ3NyH7sqtqulHulH6p8cFT/inzGk9BoRibxUJQCqYn7HfABDtSJ4wgJtcE93Dn
        ubSwIKAl5IYPjRHsfy/9y3A9uQnHlGjBxilfoFBwIobYLPZxf0MeJIy/dpZ66Cd6
        VespO6do/dcNZaF/vdhqkw+ACdFLw==
X-ME-Sender: <xms:k1fuXLxZbQcc-ANNiTUK7UBI2sL_vR5WZupSdrUc2A253Dtx8L_3pw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvjedgvdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjggfsehtkeertddtreejnecuhfhrohhmpefvrghk
    rghshhhiucfurghkrghmohhtohcuoehoqdhtrghkrghshhhisehsrghkrghmohgttghhih
    drjhhpqeenucfkphepudegrdefrdejhedrudekudenucfrrghrrghmpehmrghilhhfrhho
    mhepohdqthgrkhgrshhhihesshgrkhgrmhhotggthhhirdhjphenucevlhhushhtvghruf
    hiiigvpedt
X-ME-Proxy: <xmx:k1fuXDqJLSpSTXkTZTciZs27YxisYeoGB6fGIVbV6inmjPgmkZdzug>
    <xmx:k1fuXDzlPHfLKSKrwsKOVVoZfcm6NUzgWaAMmPe5QrZQEgSnVBAz3g>
    <xmx:k1fuXCurnFtFsjwzcDFGDUTFxiwmFbRMHUebTfAZecsGB5BQqUsLjQ>
    <xmx:lVfuXHp1xBd2evfpTHfjZBexRzt3oLWMlb8KBbQqAvRZxYLnnEZERg>
Received: from workstation (ae075181.dynamic.ppp.asahi-net.or.jp [14.3.75.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 59261380084;
        Wed, 29 May 2019 05:57:34 -0400 (EDT)
Date:   Wed, 29 May 2019 18:57:31 +0900
From:   Takashi Sakamoto <o-takashi@sakamocchi.jp>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] ALSA: fireface: Use ULL suffixes for 64-bit constants
Message-ID: <20190529095730.GA7089@workstation>
Mail-Followup-To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>, Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
        Joe Perches <joe@perches.com>, Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
References: <20190528142424.19626-1-geert@linux-m68k.org>
 <20190528142424.19626-5-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190528142424.19626-5-geert@linux-m68k.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, May 28, 2019 at 04:24:23PM +0200, Geert Uytterhoeven wrote:
> With gcc 4.1:
> 
>     sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_switch_fetching_mode’:
>     sound/firewire/fireface/ff-protocol-latter.c:97: warning: integer constant is too large for ‘long’ type
>     sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_begin_session’:
>     sound/firewire/fireface/ff-protocol-latter.c:170: warning: integer constant is too large for ‘long’ type
>     sound/firewire/fireface/ff-protocol-latter.c:197: warning: integer constant is too large for ‘long’ type
>     sound/firewire/fireface/ff-protocol-latter.c:205: warning: integer constant is too large for ‘long’ type
>     sound/firewire/fireface/ff-protocol-latter.c: In function ‘latter_finish_session’:
>     sound/firewire/fireface/ff-protocol-latter.c:214: warning: integer constant is too large for ‘long’ type
> 
> Fix this by adding the missing "ULL" suffixes.
> Add the same suffix to the last constant, to maintain consistency.
> 
> Fixes: fd1cc9de64c2ca6c ("ALSA: fireface: add support for Fireface UCX")
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  sound/firewire/fireface/ff-protocol-latter.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)

Thanks for your care.

Reviewed-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>

> diff --git a/sound/firewire/fireface/ff-protocol-latter.c b/sound/firewire/fireface/ff-protocol-latter.c
> index c8236ff89b7fb9de..b30d02d359b1d21b 100644
> --- a/sound/firewire/fireface/ff-protocol-latter.c
> +++ b/sound/firewire/fireface/ff-protocol-latter.c
> @@ -9,11 +9,11 @@
>  
>  #include "ff.h"
>  
> -#define LATTER_STF		0xffff00000004
> -#define LATTER_ISOC_CHANNELS	0xffff00000008
> -#define LATTER_ISOC_START	0xffff0000000c
> -#define LATTER_FETCH_MODE	0xffff00000010
> -#define LATTER_SYNC_STATUS	0x0000801c0000
> +#define LATTER_STF		0xffff00000004ULL
> +#define LATTER_ISOC_CHANNELS	0xffff00000008ULL
> +#define LATTER_ISOC_START	0xffff0000000cULL
> +#define LATTER_FETCH_MODE	0xffff00000010ULL
> +#define LATTER_SYNC_STATUS	0x0000801c0000ULL
>  
>  static int parse_clock_bits(u32 data, unsigned int *rate,
>  			    enum snd_ff_clock_src *src)
> -- 
> 2.17.1
> 


Regards

Takashi Sakamoto
