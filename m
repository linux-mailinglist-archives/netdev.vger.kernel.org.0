Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5305E9CF9
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 11:09:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233913AbiIZJJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 05:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233527AbiIZJJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 05:09:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C154201A5
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:09:15 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso11793091pjk.0
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 02:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=zIwJkcfZiCJVcK2gsBhTYdXWB93nNMAsAQ0HD2M23SQ=;
        b=YFNize90a964bkhN4otkl/tclWwGNbzaGVgp6NAPKLOBXqxjFVnT6u8NWvbA5OuRoT
         QvZcNzJ7ISfwJ0f3dWSMX6vzasJv8vyysrhjn2xyVxwuEwAIlJ6UCaQTjowI1r11g8Wb
         CPSNHy8jbmPxMaGi88T2ZKSNqzWiBKlOXK3ksymo6Tn6jK3op5napXg7ELL8ARmHtnfb
         EPfBRwHMTfZv5peH6TxBbHuMUnvxueDOKlR/MZYy1CLINVw1zqdezgE8QfNUNKULtutv
         FWVW6nlny4tkk1CVFZ0afFmkVS1nrIKM1y9tYEPcmr+Ju4qfCjPBoUTRJgq2ANwqd6+w
         e1vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=zIwJkcfZiCJVcK2gsBhTYdXWB93nNMAsAQ0HD2M23SQ=;
        b=zYuLu8lrRQ3eqqPquwU9xfWZP4Ij3ZsxgsGljHbg+JIYEbNTVDozAu5a/8X/d1zfN+
         +1e18aTQK2YLV5JhzTJYVtTMGMkxFeCIivcwvUhONaHNx5IV0hU76WmBjQL0ACYWb88r
         NJXZeXdYgWjXzq6Ii0fPKQfwdvoIKd7jot307W8k9xX2qiPWT0NrewhqVY2/7cb7V+Er
         ZdgJIIf9p6ugMHsxS60mzSVqT6tLkvEIE3YCieeH3K/rOaH965D4RjX83jx30nizn+VV
         J34sm+SB41Hv707y6sp1ojlhT+CgL9bdVZV4DAACl/B3m29iaj7hODwAcitS5UVSWXBr
         o7Ug==
X-Gm-Message-State: ACrzQf0yotoLASQ2zHA8PsKZx7Y/eEHFDmLV3YyV0M1pSdkjNoWYuIKU
        9dIC9Sjn7uQdBqN6mt2cm1s=
X-Google-Smtp-Source: AMsMyM6Urlo72pi2O0vl4DVsMQefCMrBHjP7K2lUv6M8OpOw6yZJv3CxPEzuj8KxtiTAen+jX7zMJA==
X-Received: by 2002:a17:902:f70e:b0:178:9a17:8e42 with SMTP id h14-20020a170902f70e00b001789a178e42mr21458053plo.14.1664183354613;
        Mon, 26 Sep 2022 02:09:14 -0700 (PDT)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id g11-20020a63200b000000b00439f027789asm10282807pgg.59.2022.09.26.02.09.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 02:09:14 -0700 (PDT)
Date:   Mon, 26 Sep 2022 17:09:09 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCHv2 net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set, del}link
Message-ID: <YzFsNXDG0NYsQJLr@Laptop-X1>
References: <20220926071246.38805-1-liuhangbin@gmail.com>
 <e74aeed9-fd93-43dd-7692-251efbc5e5b9@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e74aeed9-fd93-43dd-7692-251efbc5e5b9@6wind.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 10:37:46AM +0200, Nicolas Dichtel wrote:
> > +	rtnl_notify(skb, dev_net(dev), pid, RTM_NEWLINK, nlh, GFP_KERNEL);
> The fourth argument is the group, not the command. It should be RTNLGRP_LINK
> here. But it would be better to pass 0 to avoid multicasting a new / duplicate
> notification. Calling functions already multicast one.

Thanks for the correcting. I will post a new update.

Hangbin
