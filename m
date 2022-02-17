Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3B94BA05C
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 13:49:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbiBQMtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 07:49:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239479AbiBQMty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 07:49:54 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DCB2A82D7;
        Thu, 17 Feb 2022 04:49:40 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id z22so9445112edd.1;
        Thu, 17 Feb 2022 04:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CjBXv9sEQT0KDRtB/KToxdmbCyPvDgWSftjqY9UdKEo=;
        b=e8cnyeD/uyiORbcZS33cFZjOMW7lj+oRGCaltVliLa8rJ/Ql3q3Fqi9fUyF8IYmJu0
         n8+FCKmNs1m9mOxaSkdZeJHaS3LXQyG691PvxAXF2ocY/OBjBX8EZ1cur/Lk2L3VXgZo
         ikVSjwVj0p7TLBUvp0L3GFT3FXaSje/Hh4pl16R5ESqppjrXYsGlQWtvYWprSqKHmNoY
         nDfVBpOpyuv3lOrhraToDQRd6Hrmc5JN0kAeOF09yuLKlEEuuon341wvrGVXF3VfADc/
         YdfZtqcI5OFp6GLSpcbXlLHrkLZ3gd1uYf4bdaZwTG3/hHgXrPVXluuXUyv+Sb+eIMJ9
         p2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CjBXv9sEQT0KDRtB/KToxdmbCyPvDgWSftjqY9UdKEo=;
        b=bdh5kD0vciPm6J7EXGULva+kAV+G56G0pDoAW6RZEDVeJNAF1n0/HYzL8pwWo3bZyC
         +Xniop2i7MPytKO28FenniX/5De5PbNZZOOkBSE/ZpWC9OMpJV7C1ADi9SptDcGiTgEa
         qbZBtKRP9Zq6ZSvzq3mGR4H/HP7XJikp350J3x/Mw1cwCh34Ntt7VpW0OjwC6Fz7/q5v
         xS65HUu3fcFr6tLAZ7SEPRsv0FpBehhzjat0GBxEKLEDZdtlGdrbMRM/MIuo59L6ibDH
         92PC/Y73rr+93TcFF5OpdG4izdhZ1S+4A9xumHnH6ImC2cuqQS94070/Ipr+ouS3tYNM
         7cKA==
X-Gm-Message-State: AOAM530cQJ8Etv6GmZ4z8L+1dFQDx4gSYr8SRNFjZJClShAxV3460Qoi
        EL2JY6k7XBk48b7Mqb0xHuI=
X-Google-Smtp-Source: ABdhPJz3zWsPmLz9CrxLGaDMYxawvXJubKNWhUWgfl8P4g8tOERhoxGWNI3aZnYBEFRxVVyHluXYVw==
X-Received: by 2002:a05:6402:35c8:b0:410:dd43:3c09 with SMTP id z8-20020a05640235c800b00410dd433c09mr2399902edc.256.1645102178256;
        Thu, 17 Feb 2022 04:49:38 -0800 (PST)
Received: from skbuf ([188.27.184.105])
        by smtp.gmail.com with ESMTPSA id w17sm3261813edd.18.2022.02.17.04.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 04:49:37 -0800 (PST)
Date:   Thu, 17 Feb 2022 14:49:35 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jianbo Liu <jianbol@nvidia.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com,
        claudiu.manoil@nxp.com, sgoutham@marvell.com, gakula@marvell.com,
        sbhatta@marvell.com, hkelam@marvell.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        simon.horman@corigine.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        baowen.zheng@corigine.com, louis.peens@netronome.com,
        peng.zhang@corigine.com, oss-drivers@corigine.com, roid@nvidia.com
Subject: Re: [PATCH net-next v2 2/2] flow_offload: reject offload for all
 drivers with invalid police parameters
Message-ID: <20220217124935.p7pbgv2cfmhpshxv@skbuf>
References: <20220217082803.3881-1-jianbol@nvidia.com>
 <20220217082803.3881-3-jianbol@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220217082803.3881-3-jianbol@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 08:28:03AM +0000, Jianbo Liu wrote:
> As more police parameters are passed to flow_offload, driver can check
> them to make sure hardware handles packets in the way indicated by tc.
> The conform-exceed control should be drop/pipe or drop/ok. Besides,
> for drop/ok, the police should be the last action. As hardware can't
> configure peakrate/avrate/overhead, offload should not be supported if
> any of them is configured.
> 
> Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
> Reviewed-by: Roi Dayan <roid@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---

Tested-by: Vladimir Oltean <vladimir.oltean@nxp.com>

But could we cut down on line length a little? Example for sja1105
(messages were also shortened):

diff --git a/drivers/net/dsa/sja1105/sja1105_flower.c b/drivers/net/dsa/sja1105/sja1105_flower.c
index 8a14df8cf91e..54a16369a39e 100644
--- a/drivers/net/dsa/sja1105/sja1105_flower.c
+++ b/drivers/net/dsa/sja1105/sja1105_flower.c
@@ -300,6 +300,46 @@ static int sja1105_flower_parse_key(struct sja1105_private *priv,
 	return -EOPNOTSUPP;
 }
 
+static int sja1105_policer_validate(const struct flow_action *action,
+				    const struct flow_action_entry *act,
+				    struct netlink_ext_ack *extack)
+{
+	if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when exceed action is not drop");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is not pipe or ok");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
+	    !flow_action_is_last_entry(action, act)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when conform action is ok, but action is not last");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.peakrate_bytes_ps ||
+	    act->police.avrate || act->police.overhead) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Offload not supported when peakrate/avrate/overhead is configured");
+		return -EOPNOTSUPP;
+	}
+
+	if (act->police.rate_pkt_ps) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "QoS offload not support packets per second");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 			   struct flow_cls_offload *cls, bool ingress)
 {
@@ -321,39 +361,10 @@ int sja1105_cls_flower_add(struct dsa_switch *ds, int port,
 	flow_action_for_each(i, act, &rule->action) {
 		switch (act->id) {
 		case FLOW_ACTION_POLICE:
-			if (act->police.exceed.act_id != FLOW_ACTION_DROP) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Police offload is not supported when the exceed action is not drop");
-				return -EOPNOTSUPP;
-			}
-
-			if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
-			    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Police offload is not supported when the conform action is not pipe or ok");
-				return -EOPNOTSUPP;
-			}
-
-			if (act->police.notexceed.act_id == FLOW_ACTION_ACCEPT &&
-			    !flow_action_is_last_entry(&rule->action, act)) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Police offload is not supported when the conform action is ok, but police action is not last");
-				return -EOPNOTSUPP;
-			}
-
-			if (act->police.peakrate_bytes_ps ||
-			    act->police.avrate || act->police.overhead) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Police offload is not supported when peakrate/avrate/overhead is configured");
-				return -EOPNOTSUPP;
-			}
-
-			if (act->police.rate_pkt_ps) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "QoS offload not support packets per second");
-				rc = -EOPNOTSUPP;
+			rc = sja1105_policer_validate(&rule->action, act,
+						      extack);
+			if (rc)
 				goto out;
-			}
 
 			rc = sja1105_flower_policer(priv, port, extack, cookie,
 						    &key,

Also, if you create a "validate" function for every driver, you'll
remove code duplication for those drivers that support both matchall and
flower policers.
