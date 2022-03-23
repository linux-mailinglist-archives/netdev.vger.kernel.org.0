Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BCC4E546C
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 15:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244867AbiCWOn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 10:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbiCWOn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 10:43:59 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0F27E0A2;
        Wed, 23 Mar 2022 07:42:29 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 17so2153293lji.1;
        Wed, 23 Mar 2022 07:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=wWoDyk0souHL0BfO892KrxnvBcHbZCjITuRPNjJCS4Y=;
        b=Eeb2BjBdh6gZ3pn03ILA5hayAMXT+FBZurX2u1TenrsRs3wU+bTV1J/VdkuK8svT4Y
         limKSOwJZJ/axP0N+N+H3hQZ7LyolpT4nsTFCStFPOlcrFzhxFdPx7ebfzek/lMo1wTa
         Ix6g7Hc91E3thdxBPN7BrjeBOYteUA2MHCO49nHjC0Qy5LGJ7cJ0efMAiNoJZUbzDSoT
         tKPOo3i7ZNU2u3zOIMi5aeQLKMwiiIkgPvj19OKrOwR4turxWsmbKHvj3HAn6iF+w4ss
         38CdsQJJhkMBJyQFSQ8Ugqjab0l98jReUth1lu9lIDLRIpOgLC3xcnIC7qbU3FCqTJuJ
         DxyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=wWoDyk0souHL0BfO892KrxnvBcHbZCjITuRPNjJCS4Y=;
        b=2HG8ZkBChVO2xwxy3mdDXlp+PHI/NG3DoYxKswnQ/xPgd0fWEmdjtCsx72hw+Q+dgP
         sF6xxsMf0rxfHvvJ8g/U1TbgQ161XnGgSJNXYZK5M2l5Ta2nQedrDKnj3N/MXUzAioch
         KDwYRI0RhxqtKJBIFl3VVCarKV5Z70izCq30uOdiLeqPY6XqHzfnxpaLRSL8xrs0ylTw
         2i3ksCg8GkjdybgHfFlMU9avS+5vdgt/t7NoMJx0QPPSDzBqU9nWtaRXHbDekyfQu5eN
         R+LSOzaqg8bTU1kKlZ2eaysXYmo53AxUDFrVBL2otDr6/7jAjhK98y2ExIruOfiXoy74
         ovOw==
X-Gm-Message-State: AOAM533xyr9R5W96y4A5u/vAer6hUYoupuBpy8iSqN0lmNitNRqyqFVl
        NW3WvOGmpq6444o/hDH4UPhFU2g09O0QDg==
X-Google-Smtp-Source: ABdhPJyOZPDzNCLStyFd+3QSpZrdrdoNBlBodGlMGwyBzXRLMDkExYS2/X7ys+YlxkePUPOjYsj0lA==
X-Received: by 2002:a2e:860a:0:b0:249:93fb:f45f with SMTP id a10-20020a2e860a000000b0024993fbf45fmr243185lji.77.1648046547545;
        Wed, 23 Mar 2022 07:42:27 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id 25-20020a2e0e19000000b002495d863173sm17608ljo.61.2022.03.23.07.42.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 07:42:27 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220323123534.i2whyau3doq2xdxg@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com> <20220323123534.i2whyau3doq2xdxg@skbuf>
Date:   Wed, 23 Mar 2022 15:42:24 +0100
Message-ID: <86h77owx0v.fsf@gmail.com>
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

On ons, mar 23, 2022 at 14:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Wed, Mar 23, 2022 at 01:29:52PM +0100, Hans Schultz wrote:
>> On tor, mar 17, 2022 at 10:39, Hans Schultz <schultz.hans@gmail.com> wrote:
>> > Used for Mac-auth/MAB feature in the offloaded case.
>> >
>> > Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
>> > ---
>> >  include/net/switchdev.h | 3 ++-
>> >  net/bridge/br.c         | 3 ++-
>> >  net/bridge/br_fdb.c     | 7 +++++--
>> >  net/bridge/br_private.h | 2 +-
>> >  4 files changed, 10 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/include/net/switchdev.h b/include/net/switchdev.h
>> > index 3e424d40fae3..d5d923411f5e 100644
>> > --- a/include/net/switchdev.h
>> > +++ b/include/net/switchdev.h
>> > @@ -229,7 +229,8 @@ struct switchdev_notifier_fdb_info {
>> >  	u16 vid;
>> >  	u8 added_by_user:1,
>> >  	   is_local:1,
>> > -	   offloaded:1;
>> > +	   offloaded:1,
>> > +	   locked:1;
>> >  };
>> >  
>> >  struct switchdev_notifier_port_obj_info {
>> > diff --git a/net/bridge/br.c b/net/bridge/br.c
>> > index b1dea3febeea..adcdbecbc218 100644
>> > --- a/net/bridge/br.c
>> > +++ b/net/bridge/br.c
>> > @@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
>> >  	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
>> >  		fdb_info = ptr;
>> >  		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
>> > -						fdb_info->vid, false);
>> > +						fdb_info->vid, false,
>> > +						fdb_info->locked);
>> >  		if (err) {
>> >  			err = notifier_from_errno(err);
>> >  			break;
>> > diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
>> > index 57ec559a85a7..57aa1955d34d 100644
>> > --- a/net/bridge/br_fdb.c
>> > +++ b/net/bridge/br_fdb.c
>> > @@ -987,7 +987,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
>> >  					   "FDB entry towards bridge must be permanent");
>> >  			return -EINVAL;
>> >  		}
>> > -		err = br_fdb_external_learn_add(br, p, addr, vid, true);
>> > +		err = br_fdb_external_learn_add(br, p, addr, vid, true,
>> >  false);
>> 
>> Does someone have an idea why there at this point is no option to add a
>> dynamic fdb entry?
>> 
>> The fdb added entries here do not age out, while the ATU entries do
>> (after 5 min), resulting in unsynced ATU vs fdb.
>
> I think the expectation is to use br_fdb_external_learn_del() if the
> externally learned entry expires. The bridge should not age by itself
> FDB entries learned externally.
>

How is the mechanism supposed to work to remove fdb entries when ATU
entries age out?

>> >  	} else {
>> >  		spin_lock_bh(&br->hash_lock);
>> >  		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
>> > @@ -1216,7 +1216,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
>> >  
>> >  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>> >  			      const unsigned char *addr, u16 vid,
>> > -			      bool swdev_notify)
>> > +			      bool swdev_notify, bool locked)
>> >  {
>> >  	struct net_bridge_fdb_entry *fdb;
>> >  	bool modified = false;
>> > @@ -1236,6 +1236,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>> >  		if (!p)
>> >  			flags |= BIT(BR_FDB_LOCAL);
>> >  
>> > +		if (locked)
>> > +			flags |= BIT(BR_FDB_ENTRY_LOCKED);
>> > +
>> >  		fdb = fdb_create(br, p, addr, vid, flags);
>> >  		if (!fdb) {
>> >  			err = -ENOMEM;
>> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
>> > index f5a0b68c4857..3275e33b112f 100644
>> > --- a/net/bridge/br_private.h
>> > +++ b/net/bridge/br_private.h
>> > @@ -790,7 +790,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
>> >  void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
>> >  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>> >  			      const unsigned char *addr, u16 vid,
>> > -			      bool swdev_notify);
>> > +			      bool swdev_notify, bool locked);
>> >  int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
>> >  			      const unsigned char *addr, u16 vid,
>> >  			      bool swdev_notify);
>> > -- 
>> > 2.30.2
