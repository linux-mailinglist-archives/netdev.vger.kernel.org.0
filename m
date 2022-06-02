Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C870653B8CA
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 14:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234435AbiFBMIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 08:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbiFBMIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 08:08:48 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110BA2717BD;
        Thu,  2 Jun 2022 05:08:47 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id g25so4987944ljm.2;
        Thu, 02 Jun 2022 05:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=QdNf1+ADCDYIFdMt/u0EWuhJR3TaXSiM6WxoeP7Eubo=;
        b=Sr4MSscJ3lDmLRDowY0p2F36myUdh5acadCAYqP6y6lRile9Ir7mBytU3OgIgUFZUF
         1CZmrb7YxF0A/b4XWk+rLAlmOMiQjL46TOhhS7qsB53sWCKLsbpKldE6N0S+YBplVoLB
         sBFlPQHIBjuSbG9EpX2gv1OPch3Sk2FPoFD83yjh3A0AQcFC+VJSX/x8knhDDr8Slx3u
         fNNpeIEbuIkrcndC7Dvct4MzKA2XSMmQWZ8MfgMcux/h4yPji5DwAZzb0jiCg572EYsm
         XrKx+EfbQEcGjMEUs/Rmc8WtDaD0J5+3bRqRVXOgWRlbpgBWbh6Kwc1zXesWIptqZbP+
         VjbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=QdNf1+ADCDYIFdMt/u0EWuhJR3TaXSiM6WxoeP7Eubo=;
        b=07VkBYE3d7HkLTJwZUqeztmH3e8S6xv6Usj6UIWp+HKIFN6unOxnwqcBpsTdykIRCm
         8+1nzkMBwPv+sxbwXjPuoVKnMwIhKOqtqiP7c4owwqo49kMb4SYDZ81FHvmgjnZwbgzr
         yZrLJMrMG7vn9iOKCD23zb28L9UsUAKyi18X1Ml6z87GPjaPCOPdYT4Js9YI/vS6daQU
         wRlQLRUg1f/Ls7Ie5fcTKqcoa7r7/OMzluakmCo7o95Xwnfk0/mM3i5TfpBUCzJVs6Aq
         Z+bkfwxSpLs9QBda2C8A4/jAdk09KoIGj4Q3In//mwGuBZMT1blD/SKNsCGxU+uiPWgN
         AVUA==
X-Gm-Message-State: AOAM533y6nC6xd1F2m0dMKczFleJo5Tdf1b1EciYOs63HBvuD7B2fJYm
        qn6219szFS2s9brFtLGM7dVUEUnm4b7JLA==
X-Google-Smtp-Source: ABdhPJyzjXZmbGB25Nt6LYzK4/Lb1b18NojM2rGYKC4gJb6rhYHNS5GmPPf2ZZCqPqhuXGeoBdiM6w==
X-Received: by 2002:a05:651c:1a2c:b0:253:d897:ee2f with SMTP id by44-20020a05651c1a2c00b00253d897ee2fmr39569928ljb.232.1654171725398;
        Thu, 02 Jun 2022 05:08:45 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.28])
        by smtp.gmail.com with ESMTPSA id h9-20020a056512054900b00477c8127e50sm1001299lfl.122.2022.06.02.05.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 05:08:44 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Hans Schultz <schultz.hans@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YpiTbOsh0HBMwiTE@shredder>
References: <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder> <86y1yfzap3.fsf@gmail.com>
 <d88b6090-2ac8-0664-0e38-bb2860be7f6e@blackwall.org>
 <86sfonjroi.fsf@gmail.com>
 <3d93d46d-c484-da0a-c12c-80e83eba31c9@blackwall.org>
 <YpiTbOsh0HBMwiTE@shredder>
Date:   Thu, 02 Jun 2022 14:08:41 +0200
Message-ID: <86mtevjmie.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> I think Hans is testing with mv88e6xxx which dumps entries directly from
> HW via ndo_fdb_dump(). See dsa_slave_port_fdb_do_dump() which sets
> NTF_SELF.
>
> Hans, are you seeing the entry twice? Once with 'master' and once with
> 'self'?
>

When replacing a locked entry it looks like this:

# bridge fdb show dev eth6 | grep 4c
00:4c:4c:4c:4c:4c vlan 1 master br0 extern_learn offload locked

# bridge fdb replace 00:4c:4c:4c:4c:4c dev eth6 vlan 1 master static ; bridge fdb show dev eth6 | grep 4c
00:4c:4c:4c:4c:4c vlan 1 self static

The problem is then that the function
br_fdb_find_rcu(br,eth_hdr(skb)->h_source, vid);
, where the h_source and vid is the entry above, does not find the entry.
My hypothesis was then that this is because of the 'self' flag that I
see.

I am thinking that the function dsa_slave_port_fdb_do_dump() is only for
debug, and thus does not really set any flags in the bridge modules FDB,
but then I don't understand why the above find function does not find
the entry?
