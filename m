Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E960F21CAAF
	for <lists+netdev@lfdr.de>; Sun, 12 Jul 2020 19:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729289AbgGLR3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jul 2020 13:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729103AbgGLR3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jul 2020 13:29:50 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D400EC061794;
        Sun, 12 Jul 2020 10:29:49 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id f5so12337107ljj.10;
        Sun, 12 Jul 2020 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=mXVhnMbLGoPfvAx6e38CZX1k0UQjQcfgooySs19pric=;
        b=LNr4Maxoqb8MK8gGDyYGRVFEoRo8DH097f671Xs1HfD6kaEKPQ5FeECRrS4qi7BEk1
         mXTTfjjAQkORxZKT5q0KteZxLk9/2XCaHFQJLwxDxG+EXbe5ABaIYAwXxBsJONZNRT0i
         /PC5w9PtmRc1xaJDu5weHBFnrqTszZ1o0Zx9CH4gjuGBLppG23kHgszept6a700rC0q6
         wNygOQZpfTxF9IVhqPGQp1BQ2o1iW+rx99wfaOCJoET4FsqVqbAhUAXf5PA+GXZu1c23
         fgY6orVq8Xj5XgI6inN4Ub7WsxWYaAIRYKxd4Y2zUIlrN/7Jszchu4qOgvUeKh42bK7L
         br8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version;
        bh=mXVhnMbLGoPfvAx6e38CZX1k0UQjQcfgooySs19pric=;
        b=r6fFif7sIS8j5Pg7NeumcHdkV1RLHQGnJvNrleADxl5hw9PIlZwSqTFKgMgx9nbwn3
         zqcC+b8XhoEEVDKG1latDpzvSVxsu2KtRINhRkrVwttaeU717YjGVHJjXlf5vRx8gKWu
         zwUGKbeuY+uDxjrfWsjItyDyoXq/Pi5ft0iVLz2E6D8S9e5CTIFkrIaceeceR+dX/jwj
         mldKUD3sbQugKuv1TFx3JEPgCSOlXN2LXU4ehFoEHvxqswJBCwcY797Tyi4ReWjtD/Ut
         /dpfcC2VH50PGfnoQ/q2H/nL3yM9ZeRgWmRiTeLu8LjNLg42Tr00K5ZQhWQLAIU55mwM
         ZCZA==
X-Gm-Message-State: AOAM531K7Am7YM+QY5KW2Mnfh0O6aZTvx6LTVl0m+xBFHDDEEFREIomi
        CTMlBoLvuVeXv+xGnCkerbI=
X-Google-Smtp-Source: ABdhPJyr6bzqR//X0RR5XORGSPPI9WOgxbi1Ys9ZalmHnD/o3zbxUIE613ShV3ebLgpqk22UIMWNWA==
X-Received: by 2002:a05:651c:102d:: with SMTP id w13mr40787617ljm.29.1594574988275;
        Sun, 12 Jul 2020 10:29:48 -0700 (PDT)
Received: from osv.localdomain ([89.175.180.246])
        by smtp.gmail.com with ESMTPSA id j18sm4084653lfj.68.2020.07.12.10.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 10:29:47 -0700 (PDT)
From:   Sergey Organov <sorganov@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net] net: fec: fix hardware time stamping by external
 devices
References: <20200706142616.25192-1-sorganov@gmail.com>
        <20200711120842.2631-1-sorganov@gmail.com>
        <20200711231937.wu2zrm5spn7a6u2o@skbuf> <87wo387r8n.fsf@osv.gnss.ru>
        <20200712150151.55jttxaf4emgqcpc@skbuf>
Date:   Sun, 12 Jul 2020 20:29:46 +0300
In-Reply-To: <20200712150151.55jttxaf4emgqcpc@skbuf> (Vladimir Oltean's
        message of "Sun, 12 Jul 2020 18:01:51 +0300")
Message-ID: <87r1tg7ib9.fsf@osv.gnss.ru>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> On Sun, Jul 12, 2020 at 05:16:56PM +0300, Sergey Organov wrote:
>> Vladimir Oltean <olteanv@gmail.com> writes:
>> 
>> > Hi Sergey,
>> >
>> > On Sat, Jul 11, 2020 at 03:08:42PM +0300, Sergey Organov wrote:
>> >> Fix support for external PTP-aware devices such as DSA or PTP PHY:
>> >> 
>> >> Make sure we never time stamp tx packets when hardware time stamping
>> >> is disabled.
>> >> 
>> >> Check for PTP PHY being in use and then pass ioctls related to time
>> >> stamping of Ethernet packets to the PTP PHY rather than handle them
>> >> ourselves. In addition, disable our own hardware time stamping in this
>> >> case.
>> >> 
>> >> Fixes: 6605b73 ("FEC: Add time stamping code and a PTP hardware clock")
>> >
>> > Please use a 12-character sha1sum. Try to use the "pretty" format
>> > specifier I gave you in the original thread, it saves you from
>> > counting,
>> 
>> I did as you suggested:
>> 
>> [pretty]
>>         fixes = Fixes: %h (\"%s\")
>> [alias]
>> 	fixes = show --no-patch --pretty='Fixes: %h (\"%s\")'
>> 
>> And that's what it gave me. Dunno, maybe its Git version that is
>> responsible?
>> 
>> I now tried to find a way to specify the number of digits in the
>> abbreviated hash in the format, but failed. There is likely some global
>> setting for minimum number of digits, but I'm yet to find it. Any idea?
>> 
>
> Sorry, my fault. I gave you only partial settings. Use this:
>
> [core]
> 	abbrev = 12

Thanks, Vladimir and Andrew!

>
>> > and also from people complaining once it gets merged:
>> >
>> > https://www.google.com/search?q=stephen+rothwell+%22fixes+tag+needs+some+work%22
>> >
>> >> Signed-off-by: Sergey Organov <sorganov@gmail.com>
>> >> ---
>> >> 
>> >> v2:
>> >>   - Extracted from larger patch series
>> >>   - Description/comments updated according to discussions
>> >>   - Added Fixes: tag
>> >> 
>> >>  drivers/net/ethernet/freescale/fec.h      |  1 +
>> >>  drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++++++++++------
>> >>  drivers/net/ethernet/freescale/fec_ptp.c  | 12 ++++++++++++
>> >>  3 files changed, 30 insertions(+), 6 deletions(-)
>> >> 
>> >> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
>> >> index d8d76da..832a217 100644
>> >> --- a/drivers/net/ethernet/freescale/fec.h
>> >> +++ b/drivers/net/ethernet/freescale/fec.h
>> >> @@ -590,6 +590,7 @@ struct fec_enet_private {
>> >>  void fec_ptp_init(struct platform_device *pdev, int irq_idx);
>> >>  void fec_ptp_stop(struct platform_device *pdev);
>> >>  void fec_ptp_start_cyclecounter(struct net_device *ndev);
>> >> +void fec_ptp_disable_hwts(struct net_device *ndev);
>> >>  int fec_ptp_set(struct net_device *ndev, struct ifreq *ifr);
>> >>  int fec_ptp_get(struct net_device *ndev, struct ifreq *ifr);
>> >>  
>> >> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
>> >> index 3982285..cc7fbfc 100644
>> >> --- a/drivers/net/ethernet/freescale/fec_main.c
>> >> +++ b/drivers/net/ethernet/freescale/fec_main.c
>> >> @@ -1294,8 +1294,13 @@ fec_enet_tx_queue(struct net_device *ndev, u16 queue_id)
>> >>  			ndev->stats.tx_bytes += skb->len;
>> >>  		}
>> >>  
>> >> -		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS) &&
>> >> -			fep->bufdesc_ex) {
>> >> +		/* NOTE: SKBTX_IN_PROGRESS being set does not imply it's we who
>> >> +		 * are to time stamp the packet, so we still need to check time
>> >> +		 * stamping enabled flag.
>> >> +		 */
>> >> +		if (unlikely(skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS &&
>> >> +			     fep->hwts_tx_en) &&
>> >> +		    fep->bufdesc_ex) {
>> >>  			struct skb_shared_hwtstamps shhwtstamps;
>> >>  			struct bufdesc_ex *ebdp = (struct bufdesc_ex *)bdp;
>> >>  

[...]

> As far as I understand. the reason why SKBTX_IN_PROGRESS exists is for
> skb_tx_timestamp() to only provide a software timestamp if the hardware
> timestamping isn't going to. So hardware timestamping logic must signal
> its intention. With SO_TIMESTAMPING, this should not be strictly
> necessary, as this UAPI supports multiple sources of timestamping
> (including software and hardware together),

As a side note, I tried, but didn't find a way to get 2 timestamps,
software and hardware, for the same packet. It looks like once upon a
time it was indeed supported by:

SOF_TIMESTAMPING_SYS_HARDWARE: This option is deprecated and ignored.

> but I think
> SKBTX_IN_PROGRESS predates this UAPI and timestamping should continue to
> work with older socket options.

<rant>The UAPI to all this is rather messy, starting with ugly tricks to
convert PTP file descriptors to clock IDs, followed by strange ways to
figure correct PTP clock for given Ethernet interface, followed by
entirely different methods of getting time stamping capabilities and
configuring them, and so forth.</rant>

>
> Now, out of the 2 mainline DSA drivers, 1 of them isn't setting
> SKBTX_IN_PROGRESS, and that is mv88e6xxx. So mv88e6xxx isn't triggerring
> this bug. I'm not sure why it isn't setting the flag. It might very well
> be that the author of the patch had a board with a FEC DSA master, and
> setting this flag made bad things happen, so he just left it unset.
> Doesn't really matter.
> But sja1105 is setting the flag:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/dsa/sja1105/sja1105_ptp.c#n890
>
> So, at the very least, you are fixing PTP on DSA setups with FEC as
> master and sja1105 as switch. Boards like that do exist.

I'll do as you suggest, but I want to say that I didn't question your
claim that my proposed changes may fix some existing PTP/DSA setup.

What I still find doubtful is that this fact necessarily means that the
part of the patch that fixes some other bug must be submitted
separately. If it were the rule, almost no patch that needs to fix 2
separate places would be accepted, as there might be some bug somewhere
that could be fixed by 1 change, no?

In this particular case, you just happen to identify such a bug
immediately, but I, as patch submitter, should not be expected to check
all the kernel for other possible bugs that my changes may happen to
fix, no?

It seems like I misunderstand something very basic and that bothers me.

>
>> In case you insist they are to be separate, I do keep the split version
>> in my git tree, but to finish it that way, I'd like to clarify a few
>> details:
>> 
>> 1. Should it be patch series with 2 commits, or 2 entirely separate
>> patches?
>> 
>
> Entirely separate.

OK, will do a separate patch, as you suggest.

[...]

>
>> 3. If entirely separate patches, should I somehow refer to SKBTX patch in
>> ioctl() one (and/or vice versa), to make it explicit they are
>> (inter)dependent? 
>> 
>
> Nope. The PHY timestamping support will go to David's net-next, this
> common PHY/DSA bugfix to net, and they'll meet sooner rather than
> later.

I'll do as you suggest, separating the patches, yet I fail to see why
PHY /time stamping bug fix/ should go to another tree than PHY/DSA /time
stamping bug fix/? What's the essential difference? Could you please
clarify?

Thanks,
-- Sergey
