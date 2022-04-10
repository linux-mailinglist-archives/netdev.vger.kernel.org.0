Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BE2C4FB02B
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 22:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242613AbiDJUhT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 16:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243068AbiDJUhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 16:37:15 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1BC4ECF0;
        Sun, 10 Apr 2022 13:35:02 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z12so3442116edl.2;
        Sun, 10 Apr 2022 13:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dCmksJmPxgakgPcETkyiMkdEpAIfPO8dTB6JgwQ/+0c=;
        b=fJz20MHNwDvsBXdmgdMPNyq04BZ5BUG60QpxolftSlFksOd7su6HQLoU6Ym3gzUS9Z
         1HOHAI1W86fYaCzaxUN5sXZRzTzF/FgAhUMtk7w7n4SKYTDfggk4U2NXEHuuhBg5bOQj
         7AmYBCt6RZKmk/JrDlUwsJpoUULpi+QFAllfEIz2JBYO/eXqDK3Iev7FQY9dKcvA4Mmi
         tQGnUFhaplfYowHS0ggxLJH7BKaETYZLgXmFDsdvnDdMysaS0fSWOExFy96UIba2+vWu
         mz4aSQmoRlql8Scvd4xNgNcCvlcKYqi0CPXxIMHdzILmeexpscOm7rOOgg8pNpvJhqYL
         im3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dCmksJmPxgakgPcETkyiMkdEpAIfPO8dTB6JgwQ/+0c=;
        b=g//ZVmU7j2RwvxTjh7bHgP8TxPxVphr+3qIWFIpUgOae36UjsY7RuOsGobb9nTUgAd
         kQtxrRhnlPm03UOR5GcdDQW+Im9CJsZBqk+bEtiMYvhvEADXRxs/NGuxfSGzwE4leD78
         uOp0GsEeThTctTRe6oHBGauKicygVZjGGPRt8K3O0RDD3widb6MmS/PUdB6n6ZEDME3T
         nAUMc1vP9up7biLBuAxClE/e5JIFr3/Rq0swV8SxaGXqftccZzqM9cBDFsO/Z7hPzW7T
         1tEezlQFDUf0XwNa6ZuFMAYLOI8YTmJt+9JLB7jWTocCJJ+oC7xErRvdW+mLnuUnISXm
         wq3Q==
X-Gm-Message-State: AOAM532Ny2lIaSQW6fR7UP9KcIgMsTTVApUEmQ+H/m2VuS50hCUgtJGS
        QWDGTEC5gnbMPo9DPun56Ow=
X-Google-Smtp-Source: ABdhPJwZznt2lJwO+hf+ALxhFuyiAjJq2pf8wY+nER92urPfEHHhtB2vyJZ36qkUOAwve20Kv235ZQ==
X-Received: by 2002:a05:6402:34b:b0:41d:7026:d9e3 with SMTP id r11-20020a056402034b00b0041d7026d9e3mr7280900edw.168.1649622900513;
        Sun, 10 Apr 2022 13:35:00 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id u25-20020a170906b11900b006e08588afedsm11183676ejy.132.2022.04.10.13.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Apr 2022 13:35:00 -0700 (PDT)
Date:   Sun, 10 Apr 2022 23:34:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Colin Ian King <colin.king@intel.com>,
        Michael Walle <michael@walle.cc>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Xu Wang <vulab@iscas.ac.cn>, Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next 02/15] net: dsa: sja1105: Remove usage of
 iterator for list_add() after loop
Message-ID: <20220410203457.3las4i3qcmaitsjt@skbuf>
References: <20220407102900.3086255-1-jakobkoschel@gmail.com>
 <20220407102900.3086255-3-jakobkoschel@gmail.com>
 <20220408114120.tvf2lxvhfqbnrlml@skbuf>
 <FA317E17-3B09-411B-9DF6-05BDD320D988@gmail.com>
 <C9081CE3-B008-48DA-A97C-76F51D4F189F@gmail.com>
 <20220410110508.em3r7z62ufqcbrfm@skbuf>
 <935062D0-C657-4C79-A0BE-70141D052EC0@gmail.com>
 <C88FE232-417C-4029-A79E-9A7E807D2FE7@gmail.com>
 <20220410200235.6mtdkd2f73ijxknn@skbuf>
 <A8286EF1-4C38-4ACD-884A-6D1C64769DAE@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A8286EF1-4C38-4ACD-884A-6D1C64769DAE@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 10, 2022 at 10:30:31PM +0200, Jakob Koschel wrote:
> > On 10. Apr 2022, at 22:02, Vladimir Oltean <olteanv@gmail.com> wrote:
> > 
> > On Sun, Apr 10, 2022 at 08:24:37PM +0200, Jakob Koschel wrote:
> >> Btw, I just realized that the if (!pos) is not necessary. This should simply do it:
> >> 
> >> diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
> >> index b7e95d60a6e4..2d59e75a9e3d 100644
> >> --- a/drivers/net/dsa/sja1105/sja1105_vl.c
> >> +++ b/drivers/net/dsa/sja1105/sja1105_vl.c
> >> @@ -28,6 +28,7 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
> >> 		list_add(&e->list, &gating_cfg->entries);
> >> 	} else {
> >> +		struct list_head *pos = &gating_cfg->entries;
> >> 		struct sja1105_gate_entry *p;
> >> 
> >> 		list_for_each_entry(p, &gating_cfg->entries, list) {
> >> 			if (p->interval == e->interval) {
> >> @@ -37,10 +38,12 @@ static int sja1105_insert_gate_entry(struct sja1105_gating_config *gating_cfg,
> >> 				goto err;
> >> 			}
> >> 
> >> -			if (e->interval < p->interval)
> >> +			if (e->interval < p->interval) {
> >> +				pos = &p->list;
> >> 				break;
> >> +			}
> >> 		}
> >> -		list_add(&e->list, p->list.prev);
> >> +		list_add(&e->list, pos->prev);
> >> 	}
> >> 
> >> 	gating_cfg->num_entries++;
> >> -- 
> >> 2.25.1
> > 
> > I think we can give this a turn that is actually beneficial for the driver.
> > I've prepared and tested 3 patches on this function, see below.
> > Concrete improvements:
> > - that thing with list_for_each_entry() and list_for_each()
> > - no more special-casing of an empty list
> > - simplifying the error path
> > - that thing with list_add_tail()
> > 
> > What do you think about the changes below?
> 
> Thanks for all the good cooperation and help. The changes look great.
> I'll include them in v2 unless you want to do that separately, then I'll
> just remove them from the patch series.

I think it's less of a synchronization hassle if you send them along
with your list of others. Good luck.
