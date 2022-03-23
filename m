Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9E64E522E
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:30:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242360AbiCWMbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231716AbiCWMbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:31:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD4D15A0B1;
        Wed, 23 Mar 2022 05:30:02 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id bu29so2502188lfb.0;
        Wed, 23 Mar 2022 05:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=Mwi/PBVi4OPxhBhWV/Tktz9iiz8/C8WzSrL6VIgHGvk=;
        b=IQSd2x3y8uw0/eXpM0aSg9biATDuOVDOwzqaV//6E3+npTpbbX5NiWYAnWjaXE5tYe
         r6tGwUuwJyuRGBkBt4/svYcLJVPh+sgTWfNnbv+YKsjuOGO/7JAVVDkoIuf4dFAsnou7
         JSiUVi+Xhgz2j0OQwgS48G+blKrsgn6wVCszn7I+XAHYRtR9Yc4W2h+ZStLA/XGvSymq
         +E+fhmQCpTvGBucE7y7eIYQf8SqnQg28Yex1gci/rU603EA+XwHPDIX9lX50rble14t5
         IkHHbmm+uAEPXmhlf8JOU8iITQT+b3SnCkrKY9goLYq/cO7DwyvLS1XFC8sQbVS8CELJ
         +72A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Mwi/PBVi4OPxhBhWV/Tktz9iiz8/C8WzSrL6VIgHGvk=;
        b=yJlAA6miztcvccoDEF7qpd9hbNAtElFFz/ArhFUargcTuJ9ur3rSn44mkTu4+nHHFt
         OvhzcYYjo2zRA7f1fY35PLDdaIsGXC5FZdAOwB4hvrz/7xvHmOGtdHywbyB4cNeCbRr6
         4UBIWsOe/34DrQcBfmsZTJ+Sp3m/IBADb/c7wSzmT4C+9OG5Mn7nNUHm5H8U+C/vS174
         Lla6fTgAd3sVO6erXoExiipwAP3xelVVIxGKMRCs4hZmsrx0ADNfvL75Jfx+S0qOOP4n
         tIYKo8KUXApapVKAs6FqSh9twUroDfSKtsLBvEK2KDmtdfMUItGtPlG1tqcQsOlC5gVO
         Vchw==
X-Gm-Message-State: AOAM53283pT+xv+gZiQyO3j8kgSwUNI3x6ru1HeiOy+vNLuvpGQA23on
        /JcEu60qaDvaj1FliXMOSzkbpfL20+uLJA==
X-Google-Smtp-Source: ABdhPJzGnJoIOpq+fEcjN3P5YkjdZXy7TLYFPzwBqo0OfwZaY7XcXMBK/21jxIyD8wF4vg3d40qMbA==
X-Received: by 2002:a05:6512:3d1a:b0:44a:10f5:5670 with SMTP id d26-20020a0565123d1a00b0044a10f55670mr16395636lfv.198.1648038600680;
        Wed, 23 Mar 2022 05:30:00 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id b7-20020a05651c098700b00247ea2fa530sm2710621ljq.20.2022.03.23.05.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 05:30:00 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
In-Reply-To: <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
Date:   Wed, 23 Mar 2022 13:29:52 +0100
Message-ID: <86o81whmwv.fsf@gmail.com>
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

On tor, mar 17, 2022 at 10:39, Hans Schultz <schultz.hans@gmail.com> wrote:
> Used for Mac-auth/MAB feature in the offloaded case.
>
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  include/net/switchdev.h | 3 ++-
>  net/bridge/br.c         | 3 ++-
>  net/bridge/br_fdb.c     | 7 +++++--
>  net/bridge/br_private.h | 2 +-
>  4 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index 3e424d40fae3..d5d923411f5e 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -229,7 +229,8 @@ struct switchdev_notifier_fdb_info {
>  	u16 vid;
>  	u8 added_by_user:1,
>  	   is_local:1,
> -	   offloaded:1;
> +	   offloaded:1,
> +	   locked:1;
>  };
>  
>  struct switchdev_notifier_port_obj_info {
> diff --git a/net/bridge/br.c b/net/bridge/br.c
> index b1dea3febeea..adcdbecbc218 100644
> --- a/net/bridge/br.c
> +++ b/net/bridge/br.c
> @@ -166,7 +166,8 @@ static int br_switchdev_event(struct notifier_block *unused,
>  	case SWITCHDEV_FDB_ADD_TO_BRIDGE:
>  		fdb_info = ptr;
>  		err = br_fdb_external_learn_add(br, p, fdb_info->addr,
> -						fdb_info->vid, false);
> +						fdb_info->vid, false,
> +						fdb_info->locked);
>  		if (err) {
>  			err = notifier_from_errno(err);
>  			break;
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 57ec559a85a7..57aa1955d34d 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -987,7 +987,7 @@ static int __br_fdb_add(struct ndmsg *ndm, struct net_bridge *br,
>  					   "FDB entry towards bridge must be permanent");
>  			return -EINVAL;
>  		}
> -		err = br_fdb_external_learn_add(br, p, addr, vid, true);
> +		err = br_fdb_external_learn_add(br, p, addr, vid, true,
>  false);

Does someone have an idea why there at this point is no option to add a
dynamic fdb entry?

The fdb added entries here do not age out, while the ATU entries do
(after 5 min), resulting in unsynced ATU vs fdb.

>  	} else {
>  		spin_lock_bh(&br->hash_lock);
>  		err = fdb_add_entry(br, p, addr, ndm, nlh_flags, vid, nfea_tb);
> @@ -1216,7 +1216,7 @@ void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p)
>  
>  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>  			      const unsigned char *addr, u16 vid,
> -			      bool swdev_notify)
> +			      bool swdev_notify, bool locked)
>  {
>  	struct net_bridge_fdb_entry *fdb;
>  	bool modified = false;
> @@ -1236,6 +1236,9 @@ int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>  		if (!p)
>  			flags |= BIT(BR_FDB_LOCAL);
>  
> +		if (locked)
> +			flags |= BIT(BR_FDB_ENTRY_LOCKED);
> +
>  		fdb = fdb_create(br, p, addr, vid, flags);
>  		if (!fdb) {
>  			err = -ENOMEM;
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index f5a0b68c4857..3275e33b112f 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -790,7 +790,7 @@ int br_fdb_sync_static(struct net_bridge *br, struct net_bridge_port *p);
>  void br_fdb_unsync_static(struct net_bridge *br, struct net_bridge_port *p);
>  int br_fdb_external_learn_add(struct net_bridge *br, struct net_bridge_port *p,
>  			      const unsigned char *addr, u16 vid,
> -			      bool swdev_notify);
> +			      bool swdev_notify, bool locked);
>  int br_fdb_external_learn_del(struct net_bridge *br, struct net_bridge_port *p,
>  			      const unsigned char *addr, u16 vid,
>  			      bool swdev_notify);
> -- 
> 2.30.2
