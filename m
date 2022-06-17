Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E821F54F27C
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 10:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380331AbiFQIEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 04:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380252AbiFQIEf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 04:04:35 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5ADE67D2C
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:04:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d13so3242071plh.13
        for <netdev@vger.kernel.org>; Fri, 17 Jun 2022 01:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9b/0wCRv3qlIwnB/0D4htcy8ncGavUAJsw9Rjm/0NNs=;
        b=W7rfd8DbFfQf7oGKBY2jMsufSmSWlSRUbAO+fpq8gZx/lplsebekJUU/HMQ8HlMZeg
         0QQYWLyPjhanhGr8hFs+OLGqME3j/6LomKZ+1TvhP+u/yjSzBxEOB84XbomIFbJSpj6i
         1EaYfCqQrK6UvXtWQ81kzcTEgEbiAN+HnS7eBi6orYE7eLyIrZVSymYNuSQp/ip0XL7j
         0zJmVJZXFTu2kxNfhpfx+cjivu1rSvn2xC0ftcK0MVLVeKkA3YMkGMsDzAR8cfOoUQvE
         yBQmOxtVtyMWJl88v4SfJ5vLiewUitXMmsC6VNx8MO8RYax4RtLGFS8p06zAW+dm8SN9
         qCpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9b/0wCRv3qlIwnB/0D4htcy8ncGavUAJsw9Rjm/0NNs=;
        b=Pf/u0b6Lr2NjhLbb/z4EPC6a+kNY66Rz9J13WUOxHDRfSIlgdtwaVQRp940Tetxjfu
         ib9oAfcqdZy5CAEbFTn1IHeLyFP4aDH0NEyGjmxNIOM/x2YI4IWmpYoamdzyqVweNQtK
         aPauCL5kJyKp65ZAbA8UhtWjptxSrbuFY3JyA5MD2O4L/UNZUgbvbAfbR1Yb9p568TfH
         6JHq5FckSieLl2Wik9heBMgV9ZyFw4zKyABKW/UjGH9XgpLzwj74+IukudB/lSxUcEKz
         kCcHtAg+h3/GzA1/+NdumtsCbszTvN3uZ5PrxZBjKEC1ErQ04WXOsY3mElpclNnhNQPi
         9wQg==
X-Gm-Message-State: AJIora9zxWzgZbAXgetaq0yH0G+7X8Q/x1u3P32YyOZSlvPcqCTWpYZ4
        bmwGDw9vEhYMO/5dl3y2gpo=
X-Google-Smtp-Source: AGRyM1tvyzi0LwTMdsaxPSRPkpZt5VlMMHVzU+tL8LNdHHEICmqAEZjlXbiHSeIR/Hzyutrp3yR49Q==
X-Received: by 2002:a17:90a:aa96:b0:1ea:3780:c3dc with SMTP id l22-20020a17090aaa9600b001ea3780c3dcmr20296828pjq.241.1655453073282;
        Fri, 17 Jun 2022 01:04:33 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id ik25-20020a170902ab1900b00169e556f864sm1347103plb.218.2022.06.17.01.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:04:32 -0700 (PDT)
Date:   Fri, 17 Jun 2022 16:04:26 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCHv2 net-next] Bonding: add per-port priority for failover
 re-selection
Message-ID: <Yqw1iheXg0fT3QcU@Laptop-X1>
References: <20220615032934.2057120-1-liuhangbin@gmail.com>
 <c5d45c3f-065d-c8e7-fcc6-4cdb54bfdd70@redhat.com>
 <YqqcPcXO8rlM52jJ@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqqcPcXO8rlM52jJ@Laptop-X1>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 16, 2022 at 10:58:12AM +0800, Hangbin Liu wrote:
> > > @@ -157,6 +162,20 @@ static int bond_slave_changelink(struct net_device *bond_dev,
> > >   			return err;
> > >   	}
> > > +	if (data[IFLA_BOND_SLAVE_PRIO]) { > +		int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
> > > +		char prio_str[IFNAMSIZ + 7];
> > > +
> > > +		/* prio option setting expects slave_name:prio */
> > > +		snprintf(prio_str, sizeof(prio_str), "%s:%d\n",
> > > +			 slave_dev->name, prio);
> > > +
> > > +		bond_opt_initstr(&newval, prio_str);
> > 
> > It might be less code and a little cleaner to extend struct bond_opt_value
> > with a slave pointer.
> > 
> > 	struct bond_opt_value {
> > 		char *string;
> > 		u64 value;
> > 		u32 flags;
> > 		union {
> > 			char cextra[BOND_OPT_EXTRA_MAXLEN];
> > 			struct net_device *slave_dev;
> > 		} extra;
> > 	};
> > 
> > Then modify __bond_opt_init to set the slave pointer, basically a set of
> > bond_opt_slave_init{} macros. This would remove the need to parse the slave
> > interface name in the set function. Setting .flags = BOND_OPTFLAG_RAWVAL
> > (already done I see) in the option definition to avoid bond_opt_parse() from
> > loosing our extra information by pointing to a .values table entry. Now in
> > the option specific set function we can just find the slave entry and set
> > the value, no more string parsing code needed.
> 
> This looks reasonable to me. It would make all slave options setting easier
> for future usage.

Hi Jan, Jay,

I have updated the slave option setting like the following. I didn't add
a extra name for the union, so we don't need to edit the existing code. I think
the slave_dev should be safe as it's protected by rtnl lock. But I'm
not sure if I missed anything. Do you think if it's OK to store/get slave_dev
pointer like this?

diff --git a/include/net/bond_options.h b/include/net/bond_options.h
index 1618b76f4903..f65be547a73d 100644
--- a/include/net/bond_options.h
+++ b/include/net/bond_options.h
@@ -83,7 +83,10 @@ struct bond_opt_value {
 	char *string;
 	u64 value;
 	u32 flags;
-	char extra[BOND_OPT_EXTRA_MAXLEN];
+	union {
+		char extra[BOND_OPT_EXTRA_MAXLEN];
+		struct net_device *slave_dev;
+	};
 };
 
 struct bonding;
@@ -133,13 +136,16 @@ static inline void __bond_opt_init(struct bond_opt_value *optval,
 		optval->value = value;
 	else if (string)
 		optval->string = string;
-	else if (extra_len <= BOND_OPT_EXTRA_MAXLEN)
+
+	if (extra && extra_len <= BOND_OPT_EXTRA_MAXLEN)
 		memcpy(optval->extra, extra, extra_len);
 }
 #define bond_opt_initval(optval, value) __bond_opt_init(optval, NULL, value, NULL, 0)
 #define bond_opt_initstr(optval, str) __bond_opt_init(optval, str, ULLONG_MAX, NULL, 0)
 #define bond_opt_initextra(optval, extra, extra_len) \
 	__bond_opt_init(optval, NULL, ULLONG_MAX, extra, extra_len)
+#define bond_opt_initslave(optval, value, slave_dev) \
+	__bond_opt_init(optval, NULL, value, slave_dev, sizeof(struct net_device *))
 
 void bond_option_arp_ip_targets_clear(struct bonding *bond);
 #if IS_ENABLED(CONFIG_IPV6)


diff --git a/drivers/net/bonding/bond_netlink.c b/drivers/net/bonding/bond_netlink.c
index 5a6f44455b95..f0d3f36739ea 100644
--- a/drivers/net/bonding/bond_netlink.c
+++ b/drivers/net/bonding/bond_netlink.c
@@ -157,6 +162,16 @@ static int bond_slave_changelink(struct net_device *bond_dev,
                        return err;
        }

+       if (data[IFLA_BOND_SLAVE_PRIO]) {
+               int prio = nla_get_s32(data[IFLA_BOND_SLAVE_PRIO]);
+
+               bond_opt_initslave(&newval, prio, &slave_dev);
+               err = __bond_opt_set(bond, BOND_OPT_PRIO, &newval,
+                                    data[IFLA_BOND_SLAVE_PRIO], extack);
+               if (err)
+                       return err;
+       }
+
        return 0;
 }

diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 96eef19cffc4..473cedb0cb0b 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
+static int bond_option_prio_set(struct bonding *bond,
+                               const struct bond_opt_value *newval)
+{
+       struct slave *slave;
+
+       slave = bond_slave_get_rtnl(newval->slave_dev);
+       if (!slave) {
+               netdev_dbg(newval->slave_dev, "%s called on NULL slave\n", __func__);
+               return -ENODEV;
+       }
+       slave->prio = newval->value;
+
+       if (rtnl_dereference(bond->primary_slave))
+               slave_warn(bond->dev, slave->dev,
+                          "prio updated, but will not affect failover re-selection as primary slave have been set\n",
+                          slave->prio);
+       else
+               bond_select_active_slave(bond);
+
+       return 0;
+}

Thanks
Hangbin
