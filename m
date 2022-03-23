Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7A4E5136
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 12:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243841AbiCWLWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 07:22:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235624AbiCWLWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 07:22:49 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322DE78FCA;
        Wed, 23 Mar 2022 04:21:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r22so2116440ejs.11;
        Wed, 23 Mar 2022 04:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87E72TCYXIHs+TxIG+l3uw9PKroKBbtdliBk27X7cqU=;
        b=mZuOPUC1JPNEyLejK7a7msjQdh9oyGwx2iT5PQH8gXq9SYl5RA1ogmBF8TJrWyPBsO
         0d4YI6s3it4uHjEO5v9MjyYDck6aKZ2ASjWnL73UagE8pP5Ber56NrCV2wpa23Vg9d7t
         3jooRkr6m/d/Pu8ModCXLY3UP+ZFHuAk+2Z/MgM1meqKYV80Czohn5b+yeiXqWJKvZf6
         9uuVrJvCLgRvgWwjy7ZyscxLwlxsnSdAHYg9NhSmWVULxmAu1KQhafhnjW78XVw0oF1O
         n6XCZZLLGVcODUjD//HRBnnYjzdRyCklW+S1zt+anW3LanIPnNkF7Qt4qihcAZSBv6uX
         69aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87E72TCYXIHs+TxIG+l3uw9PKroKBbtdliBk27X7cqU=;
        b=ki1yawf+dnilRpP+H45eKDye8dplO1dmtPu6jYIiNppOgxt9Po63oGYplqYOie22SS
         Cqu+i9zCdDIj3pQSHQCEq0OGg5HZFMsC5B94VH50rW2+Dm0XF1QSLZBMyawlCKMsF7m9
         mjJnb17nWaeGOy8RZ1CqATDGYejk7yomzSwzevzLjrSfopIkJMCNhV33zxVqJDg5r3IY
         BZGINGdji8WFL8Y8osc4BJ3LhbhNpV594BahWcEvJ0mEHZYtc78WmVFz5QifY2LFMJCa
         2piZXBb27mZ++sagghbTpa0y17Dv5wQ94QVmqv3pyN+9pL3VEHY8jqkWrhWB/2vTEWNo
         Jk5A==
X-Gm-Message-State: AOAM53250mKSq5zydwxm7/hSYX6RTx1fc3Gz1ieNEvNOX8o1NUbxCfyT
        ayo8Rt6eiYBGjVEQPjbO6Z0=
X-Google-Smtp-Source: ABdhPJybO4BiYPAi/fg3VFIMEzE591UHnNC3gbe30chy4gmV4funJuWxJSRkeJ/Zs57SqVYNE2lZng==
X-Received: by 2002:a17:906:c214:b0:6b3:d0d6:9fe6 with SMTP id d20-20020a170906c21400b006b3d0d69fe6mr30833372ejz.150.1648034478453;
        Wed, 23 Mar 2022 04:21:18 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id og49-20020a1709071df100b006db0dcf673esm9856923ejc.27.2022.03.23.04.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 04:21:18 -0700 (PDT)
Date:   Wed, 23 Mar 2022 13:21:16 +0200
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
Message-ID: <20220323112116.q6shx2g4r23ungtc@skbuf>
References: <20220317172013.rhjvknre5w7mfmlo@skbuf>
 <86tubvk24r.fsf@gmail.com>
 <20220318121400.sdc4guu5m4auwoej@skbuf>
 <86pmmjieyl.fsf@gmail.com>
 <20220318131943.hc7z52beztqlzwfq@skbuf>
 <86a6dixnd2.fsf@gmail.com>
 <20220322110806.kbdb362jf6pbtqaf@skbuf>
 <86fsn90ye8.fsf@gmail.com>
 <20220323101643.kum3nuqctunakcfo@skbuf>
 <864k3p5437.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864k3p5437.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 23, 2022 at 11:57:16AM +0100, Hans Schultz wrote:
> >> >> Another issue I see, is that there is a deadlock or similar issue when
> >> >> receiving violations and running 'bridge fdb show' (it seemed that
> >> >> member violations also caused this, but not sure yet...), as the unit
> >> >> freezes, not to return...
> >> >
> >> > Have you enabled lockdep, debug atomic sleep, detect hung tasks, things
> >> > like that?
> >> 
> >> I have now determined that it is the rtnl_lock() that causes the
> >> "deadlock". The doit() in rtnetlink.c is under rtnl_lock() and is what
> >> takes care of getting the fdb entries when running 'bridge fdb show'. In
> >> principle there should be no problem with this, but I don't know if some
> >> interrupt queue is getting jammed as they are blocked from rtnetlink.c?
> >
> > Sorry, I forgot to respond yesterday to this.
> > By any chance do you maybe have an AB/BA lock inversion, where from the
> > ATU interrupt handler you do mv88e6xxx_reg_lock() -> rtnl_lock(), while
> > from the port_fdb_dump() handler you do rtnl_lock() -> mv88e6xxx_reg_lock()?
> 
> If I release the mv88e6xxx_reg_lock() before calling the handler, I need
> to get it again for the mv88e6xxx_g1_atu_loadpurge() call at least. But
> maybe the vtu_walk also needs the mv88e6xxx_reg_lock()?
> I could also just release the mv88e6xxx_reg_lock() before the
> call_switchdev_notifiers() call and reacquire it immediately after?

The cleanest way to go about this would be to have the call_switchdev_notifiers()
portion of the ATU interrupt handling at the very end of mv88e6xxx_g1_atu_prob_irq_thread_fn(),
with no hardware access needed, and therefore no reg_lock() held.
