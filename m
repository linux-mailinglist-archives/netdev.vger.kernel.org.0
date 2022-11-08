Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCD4620AC8
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 08:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbiKHH6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 02:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233583AbiKHH6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 02:58:23 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9175192A3;
        Mon,  7 Nov 2022 23:58:20 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id s12so11594812edd.5;
        Mon, 07 Nov 2022 23:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IE6wdunOqX6QxI/VDVDlSUgwrT2BZkhiuZcGv2loub0=;
        b=OX5tyRhUgeAXZyAmBY/qXphpDnbKdDnCPVrPbUdMmhSOY0PJL97vYH9DFecMKhvSQ5
         5dMLkb5Wroq9wccLls0ntTAYRDCfE8iuev+FdU3zqouXIYs15zO5Yv91ghxy87DVjmHe
         GB8QW9EvHhFLwZNAsKZLHEeRHAl0jjXS7Q3VvkEuvvkGe1Qq6RJt1fZbZauu+OtchLzn
         mEec3KiaHVE0ZUtFT7T2uxEOv3tYD17+vS/Q/+/AXZsh4ds0/XTK+/OTjOZ1Co0p8ynW
         zAtmiOjckTbEnJfKFohHqXwIwYIgqwjg3WEtJcRoCTU73amcZh26gXpgU3eomA4im+Py
         WttA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IE6wdunOqX6QxI/VDVDlSUgwrT2BZkhiuZcGv2loub0=;
        b=2ndi90MQtmsGlDTZ4IdQwIwjQ0R/tlI40yGHqE4IQ4NU9EtiAJw9ygPbfJQKvs4olC
         BzE6tBVXpDGI3FEg/2itjdf3TjDOag+/+RKfwotzqUZgiTaMBWWfjBPCkeZBazj6YkFr
         mcuix+DTbb0MyGswCTku96vJPwXKWD4d6N9IAQNNS4JJwHH6ihCemPIzrcWRJfQUIimQ
         05ZT7vMpS29LaXN5OT80CQy2bGk7qXtZYvzSh/8FA2RyyfoBV/Zxq2+u3BrGm0BAPa43
         hfkfVKwYMWsChgjBnohOwnnrWX3KNK+1NEULgowFSnOYQrWrG9ap9UvsqliHpDd6lI0u
         /ZxA==
X-Gm-Message-State: ACrzQf3DQKVHc01TU/3dkOE4iWlrR6PHPzAFQH/6C0dOg1KP+9ctSJX2
        zF3HA0jv0JBs4+LMP+IWLwA=
X-Google-Smtp-Source: AMsMyM6rVlyed+53Z8D6xzkvHzcl+/T/tWzMeSGXdAA/NsrhC6gxb+4HaKQhLVdTnOJrYtTqMTGZcQ==
X-Received: by 2002:a05:6402:1d4f:b0:461:d2ed:788c with SMTP id dz15-20020a0564021d4f00b00461d2ed788cmr54330142edb.418.1667894299000;
        Mon, 07 Nov 2022 23:58:19 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id d11-20020a1709067a0b00b0073dc4385d3bsm4329245ejo.105.2022.11.07.23.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 23:58:18 -0800 (PST)
Date:   Tue, 8 Nov 2022 09:58:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] net: dsa: tag_mtk: assign per-port queues
Message-ID: <20221108075816.wsn2olii2lzcq7tf@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-5-nbd@nbd.name>
 <20221107212209.4pmoctkze4m2ggbv@skbuf>
 <f714f3e2-44b0-e0f9-0b99-2878ec12cb56@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f714f3e2-44b0-e0f9-0b99-2878ec12cb56@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 07:01:29AM +0100, Felix Fietkau wrote:
> On 07.11.22 22:22, Vladimir Oltean wrote:
> > On Mon, Nov 07, 2022 at 07:54:43PM +0100, Felix Fietkau wrote:
> > > Keeps traffic sent to the switch within link speed limits
> > > 
> > > Signed-off-by: Felix Fietkau <nbd@nbd.name>
> > > ---
> > >  net/dsa/tag_mtk.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> > > index 415d8ece242a..445d6113227f 100644
> > > --- a/net/dsa/tag_mtk.c
> > > +++ b/net/dsa/tag_mtk.c
> > > @@ -25,6 +25,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
> > >  	u8 xmit_tpid;
> > >  	u8 *mtk_tag;
> > > +	/* Reserve the first three queues for packets not passed through DSA */
> > > +	skb_set_queue_mapping(skb, 3 + dp->index);
> > > +
> > 
> > Should DSA have to care about this detail, or could you rework your
> > mtk_select_queue() procedure to adjust the queue mapping as needed?
> I'm setting the queue here so that I don't have to add the extra overhead of
> parsing the payload in the ethernet driver.
> For passing the queue, I used a similar approach as tag_brcm.c and
> drivers/net/ethernet/broadcom/bcmsysport.c

I was just asking if you can't add the 3 elsewhere, since the DSA
tagging protocol shouldn't care how many MAC IDs the DSA master has.
