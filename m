Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959BA4E51A7
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241262AbiCWLz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232988AbiCWLz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:55:56 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D84762A0;
        Wed, 23 Mar 2022 04:54:23 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id r13so2325490ejd.5;
        Wed, 23 Mar 2022 04:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tjXHN/eiBOH25O5STfPTfLcMinZ5HpozLUsy3qwmmWQ=;
        b=In1lSLjOxNHM4lD+mv/8ysYHAWkl7ETBHGwMnp4xudlx8mi44elGLdb08B5eEJSRlu
         k+iECO8zs1svCZSfH4zbgyfFRAvnMe3vyv6q82h6/+/IXlukfE2oLslpiPBYzHaXtdkj
         kaLB+YrriT+JdvU/D3xm7ZTyiuPei5ti+aDRpHp+B1f7CWoQQ0QauEUpOqYkiMe+fkQy
         mD67albiSCRCVe0v1H3qySwvrUJsTgaRmiYcs1P5gXkIX1jRxChiFmcyN1ZWi06TxHRs
         64AnXEgUCSupTx+TEEBR/YUY227lWtixDt2APmAM7LPtMh/O/CepNNQlzPCYj4kfV1zH
         fk7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tjXHN/eiBOH25O5STfPTfLcMinZ5HpozLUsy3qwmmWQ=;
        b=LMrLBUHU/2ro4kkADgW/FnDc80EzZ3jLe4gFfwLSq3sMoeD1V4KiKEvRhxUBxIa3se
         +HQjEcwkTK6uxU/F1YKNRc8TiH2orYW3baqD1MMx/+eNgAr3kxg9qsQiktUMxBqoh8NM
         ryrKmk626xJhcxxSvnWTVPI0KGK7PViNARACbOHRZbw8Z/0tBNz0nDOSsJ2Ste7+Favq
         SqmxYHJ0LVGGl8WbT46/T19zf4+M0YdnWZlewKOX+l+ONp71wYsV6XvsT4Nd7IyukD56
         Dmcob1kuV6QQkg4X5fk9iyZai4qvlkTZ78kE44/3vJ6Cpu5HPolJclPPkDzQtim/+HH9
         lh9A==
X-Gm-Message-State: AOAM532v0QcAhW/yEZBt//BlLv6PZiL8gneqFARNubzOnTfnyq5Zm3M7
        //YN3Styd3VOp8K3zz9liXc=
X-Google-Smtp-Source: ABdhPJzQdK6GZGqgS6tUs7KA2VUiibYqbOoA4gUyryiq0os00EyiyyvnXylRtnBUGjSvy1PZNlmCnQ==
X-Received: by 2002:a17:906:c211:b0:6ce:e221:4c21 with SMTP id d17-20020a170906c21100b006cee2214c21mr30817095ejz.691.1648036461593;
        Wed, 23 Mar 2022 04:54:21 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id j17-20020a05640211d100b00419357a2647sm5517586edw.25.2022.03.23.04.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 04:54:20 -0700 (PDT)
Date:   Wed, 23 Mar 2022 13:54:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20220323115419.svxnbcqqd7pyargn@skbuf>
References: <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com>
 <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com>
 <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86fsn90ye8.fsf@gmail.com>
 <20220323101643.kum3nuqctunakcfo@skbuf>
 <864k3p5437.fsf@gmail.com>
 <20220323112116.q6shx2g4r23ungtc@skbuf>
 <86tuboao8o.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86tuboao8o.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 12:43:03PM +0100, Hans Schultz wrote:
> On ons, mar 23, 2022 at 13:21, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Wed, Mar 23, 2022 at 11:57:16AM +0100, Hans Schultz wrote:
> >> >> >> Another issue I see, is that there is a deadlock or similar issue when
> >> >> >> receiving violations and running 'bridge fdb show' (it seemed that
> >> >> >> member violations also caused this, but not sure yet...), as the unit
> >> >> >> freezes, not to return...
> >> >> >
> >> >> > Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
> >> >> > like that?
> >> >> 
> >> >> I have now determined that it is the rtnl_lock() that causes the
> >> >> "deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
> >> >> takes care of getting the fdb entries when running 'bridge fdb show'. In
> >> >> principle there should be no problem with this, but I don't know if some
> >> >> interrupt queue is getting jammed as they are blocked from rtnetlink.c?
> >> >
> >> > Sorry, I forgot to respond yesterday to this.
> >> > By any chance do you maybe have an AB/BA lock inversion, where from the
> >> > ATU interrupt handler you do mv88e6xxx_reg_lock() -> rtnl_lock(), while
> >> > from the port_fdb_dump() handler you do rtnl_lock() -> mv88e6xxx_reg_lock()?
> >> 
> >> If I release the mv88e6xxx_reg_lock() before calling the handler, I need
> >> to get it again for the mv88e6xxx_g1_atu_loadpurge() call at least. But
> >> maybe the vtu_walk also needs the mv88e6xxx_reg_lock()?
> >> I could also just release the mv88e6xxx_reg_lock() before the
> >> call_switchdev_notifiers() call and reacquire it immediately after?
> >
> > The cleanest way to go about this would be to have the call_switchdev_notifiers()
> > portion of the ATU interrupt handling at the very end of mv88e6xxx_g1_atu_prob_irq_thread_fn(),
> > with no hardware access needed, and therefore no reg_lock() held.
> 
> So something like?
> 	mv88e6xxx_reg_unlock(chip);
> 	rtnl_lock();
> 	err = call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, brport, &info.info, NULL);
> 	rtnl_unlock();
> 	mv88e6xxx_reg_lock(chip);

No, call_switchdev_notifiers() should be the very end, no reg_lock() afterwards.
Do all the hardware handling you need, populate some variables to denote
that you need to notify switchdev, and if you do, lock the rtnetlink
mutex and do it.
