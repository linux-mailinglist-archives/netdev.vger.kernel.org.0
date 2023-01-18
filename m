Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4D5672091
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 16:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjARPIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 10:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbjARPHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 10:07:55 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E74111F5FE;
        Wed, 18 Jan 2023 07:07:54 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id q10so14934492wrs.2;
        Wed, 18 Jan 2023 07:07:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVGIvPkx7V/OLAnlAwQUGA+K8l3OiY2HXWYlN9kgkPk=;
        b=Z4pvvEXIt1xVwj383nFpGqWWqH+8L01WcbGnS9nsDeqDWrevzPmh0AT41Z9VgSUBiY
         KDmhZwFZu468qosF9uaA3WDOwPxnR3hiWMwKyUna0O5YEjZx0sZGFJa69v7pWiEIz18D
         Eymr0Ic5qWJ6Mkq49Vy2WnPubc0u3xqgP23Plb2mQoSkPlSoaY3HAs0HV58k9T9hBmuH
         ASPU+07dg8jN8YwpWOrUQfPOldmB+pobKQj4TFGtAaX1yVB1hZ7SC+4qjNStWk9oi1Ap
         +fX+Ew9oOGcQHmUQ6YZpGfdgf7Hr52SvX0WvOAqXaY1F/lOxge5atv8ZSEEt3IJozBur
         DAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wVGIvPkx7V/OLAnlAwQUGA+K8l3OiY2HXWYlN9kgkPk=;
        b=aODsReNf7eytLvDNA3R3DTEktyd2mltvoP+C3U3G4D6/lTJoTNIr7QcrctcPgawbiE
         96BCoUKPzyXWtdvujvCM9VpWUyeZSXbHv8hRtY9PeGDDLAJHglqLa6OoWoO+Dmg/rnj1
         mZ3SZLp/v1jfnv18DhygJ7qGK4NpKIh6SZzhmuyZvmXPxn5g4ZXBChlwF5SyqZpFp2nN
         DGt9Iw4/N73DqfZhjMPmoV1Q7rMBw08KKHfvO3MUoS2++Du/zs9H6BNAU2JARA46OgfS
         cBvGhl7nUR50+2nUC7Wq91euDUkep3mB680Kd+W6yvzjOTuJsMXdd/4lh402gIBsbGwE
         jT2g==
X-Gm-Message-State: AFqh2krm2BFssx7loRPEyJx8u43KWR3kKXWBmK2uf6U0DFOiAAiPyvBW
        mDKwNlgOPYxu2sDXmW3biTI=
X-Google-Smtp-Source: AMrXdXsoMZX68p5+npbvF9kl2hMb2R16YvgJFGzIycoMffuBDklgUQz2jTwAg6qBtEwbNAj5bYYzlw==
X-Received: by 2002:a05:6000:25c:b0:2be:2bd:6817 with SMTP id m28-20020a056000025c00b002be02bd6817mr6449482wrz.2.1674054473335;
        Wed, 18 Jan 2023 07:07:53 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o2-20020a5d58c2000000b002bdbead763csm20679204wrf.95.2023.01.18.07.07.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 07:07:52 -0800 (PST)
Date:   Wed, 18 Jan 2023 18:07:48 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     Daniel Machon <daniel.machon@microchip.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, vladimir.oltean@nxp.com,
        maxime.chevallier@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/6] net: dcb: add new rewrite table
Message-ID: <Y8gLRF7/0sttKkPx@kadam>
References: <20230116144853.2446315-1-daniel.machon@microchip.com>
 <20230116144853.2446315-4-daniel.machon@microchip.com>
 <87lem0w1k3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lem0w1k3.fsf@nvidia.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 11:54:23AM +0100, Petr Machata wrote:
> > @@ -1241,6 +1242,26 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
> >  	spin_unlock_bh(&dcb_lock);
> >  	nla_nest_end(skb, app);
> >  
> > +	rewr = nla_nest_start_noflag(skb, DCB_ATTR_DCB_REWR_TABLE);
> > +	if (!rewr)
> > +		return -EMSGSIZE;
> 
> This being new code, don't use _noflag please.
> 
> > +
> > +	spin_lock_bh(&dcb_lock);
> > +	list_for_each_entry(itr, &dcb_rewr_list, list) {
> > +		if (itr->ifindex == netdev->ifindex) {
> > +			enum ieee_attrs_app type =
> > +				dcbnl_app_attr_type_get(itr->app.selector);
> > +			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
> > +			if (err) {
> > +				spin_unlock_bh(&dcb_lock);
> 
> This should cancel the nest started above.
> 
> I wonder if it would be cleaner in a separate function, so that there
> can be a dedicated clean-up block to goto.
> 
> > +				return -EMSGSIZE;
> > +			}
> > +		}
> > +	}
> > +
> > +	spin_unlock_bh(&dcb_lock);
> > +	nla_nest_end(skb, rewr);

If you see a bug like this, you may as well ask Julia or me to add a
static checker warning for it.  We're both already on the CC list but we
might not be following the conversation closely...

In Smatch, I thought it would be easy but it turned out I need to add
a hack around to change the second nla_nest_start_noflag() from unknown
to valid pointer.

diff --git a/check_unwind.c b/check_unwind.c
index a397afd2346b..3128476cbeb6 100644
--- a/check_unwind.c
+++ b/check_unwind.c
@@ -94,6 +94,11 @@ static struct ref_func_info func_table[] = {
 
 	{ "ieee80211_alloc_hw", ALLOC,  -1, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
 	{ "ieee80211_free_hw",  RELEASE, 0, "$" },
+
+	{ "nla_nest_start_noflag", ALLOC, 0, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
+	{ "nla_nest_start", ALLOC, 0, "$", &valid_ptr_min_sval, &valid_ptr_max_sval },
+	{ "nla_nest_end", RELEASE, 0, "$" },
+	{ "nla_nest_cancel", RELEASE, 0, "$" },
 };
 
 static struct smatch_state *unmatched_state(struct sm_state *sm)
diff --git a/smatch_data/db/kernel.return_fixes b/smatch_data/db/kernel.return_fixes
index fa4ed4ba5f0f..4782c5e10cdb 100644
--- a/smatch_data/db/kernel.return_fixes
+++ b/smatch_data/db/kernel.return_fixes
@@ -90,3 +90,4 @@ dma_resv_wait_timeout s64min-(-1),1-s64max 1-s64max[<=$3]
 mmc_io_rw_direct_host s32min-(-1),1-s32max (-4095)-(-1)
 ad3552r_transfer s32min-(-1),1-s32max (-4095)-(-1)
 adin1110_read_reg s32min-(-1),1-s32max (-4095)-(-1)
+nla_nest_start_noflag 0-u64max 4096-ptr_max

Unfortunately, there is something weird going on and only my unreleased
version of Smatch finds the bug:

net/dcb/dcbnl.c:1306 dcbnl_ieee_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1160,1171,1184,1197,1207,1217,1222,1232,1257.
net/dcb/dcbnl.c:1502 dcbnl_cee_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1502.

I have been working on that check recently...  Both the released and
unreleased versions of Smatch have the following complaints:

net/dcb/dcbnl.c:400 dcbnl_getnumtcs() warn: 'skb' from nla_nest_start_noflag() not released on lines: 396.
net/dcb/dcbnl.c:1061 dcbnl_build_peer_app() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1061.
net/dcb/dcbnl.c:1359 dcbnl_cee_pg_fill() warn: 'skb' from nla_nest_start_noflag() not released on lines: 1324,1342.

regards,
dan carpenter
