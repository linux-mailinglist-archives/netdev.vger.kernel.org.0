Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475F0174599
	for <lists+netdev@lfdr.de>; Sat, 29 Feb 2020 09:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgB2IBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 03:01:24 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39202 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgB2IBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 03:01:24 -0500
Received: by mail-wm1-f66.google.com with SMTP id c84so5757829wme.4
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 00:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YgyqiUJJi4HwheUz4LGAhVa8Uo15v/DJeOPxX+o0VCI=;
        b=PxlStcumhRK3w8ohNCLWGbfNi+RxtOCJvEjePXq2pw0eJ8ONEZMvSCL3pwuhYIgddH
         n7qHMETfcGPmNZN06HeJDae/LGev4zcFL4gM1btRVWoYH9Rq7UldUlSVpfDUojYV4p7F
         fGwiN3LZ+ZJudXrQ7G9qrtTglXseIsCZdXfn3oxJiEIZYLvU3y5rxk7O776Cx6EQDVox
         +UitHjO2c4hJLIAjW+LFw2RjBra4EGtUtDRDSnaYTN7FMOq/Jjmynr642ISX3sfdOC84
         YWjw888m0tgEW1v6aHvgpt+FdMHL4iL3oICyl+yeyRC/v22JlPCpl/ixqPgHeV6PZRnC
         NKWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YgyqiUJJi4HwheUz4LGAhVa8Uo15v/DJeOPxX+o0VCI=;
        b=heGQppX/Eklkk5j2wU7QGo8t5mhLLjgD9JS6L1XVR0cBULDGOKfuQqhveYjlud1tq8
         UCM0jad1CzELV5NlQNLcHofXijJmh8RHumb1XSY/zeirVcDW7HIhaiNDeccCMeKQ9Uey
         jsaUkVwNjpyG59iOtd64W4swYDaun/etf9jfEDfWwkeXN02DhmKwf7tQd66ndgx7jU0J
         B2vlGonJ0UHRPcu2G/J2gwUpwihr554JfABjb8vTYqzS+4gKTAdOW0RZJ+w6eAT5Cfbq
         BJsFDKx6ZBpaOZwGpKDGDER/6biIcX6VZGtQFJLx2xOZRDPomtJqoNHqpwxmjE7FOk71
         Lrpw==
X-Gm-Message-State: APjAAAXzaHFo0qm9Syj/BqeDHMdtzTlOnY3sldRYWoK4oqfGmYfRCOoI
        QpTSl8F2SJqilqoLXpmtsB+GJ2AIoek=
X-Google-Smtp-Source: APXvYqwbfOoS/a3o9RsHpPDIRHK+xSUqIRIwzONw2lFCsS78PiVdiR+4K13Z5O2mbelEHP9fdbk1UQ==
X-Received: by 2002:a1c:f707:: with SMTP id v7mr8885615wmh.121.1582963281570;
        Sat, 29 Feb 2020 00:01:21 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id q9sm16629987wrx.18.2020.02.29.00.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Feb 2020 00:01:21 -0800 (PST)
Date:   Sat, 29 Feb 2020 09:01:20 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Edward Cree <ecree@solarflare.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, saeedm@mellanox.com, leon@kernel.org,
        michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Marian Pritsak <marianp@mellanox.com>
Subject: Re: [patch net-next 00/10] net: allow user specify TC filter HW
 stats type
Message-ID: <20200229080120.GP26061@nanopsycho>
References: <20200221095643.6642-1-jiri@resnulli.us>
 <20200221102200.1978e10e@kicinski-fedora-PC1C0HJN>
 <20200222063829.GB2228@nanopsycho>
 <b6c5f811-2313-14a0-75c4-96d29196e7e6@solarflare.com>
 <20200224131101.GC16270@nanopsycho>
 <9cd1e555-6253-1856-f21d-43323eb77788@mojatatu.com>
 <20200224162521.GE16270@nanopsycho>
 <b93272f2-f76c-10b5-1c2a-6d39e917ffd6@mojatatu.com>
 <20200225162203.GE17869@nanopsycho>
 <20200228195909.dfdhifnjy4cescic@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228195909.dfdhifnjy4cescic@salvia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Feb 28, 2020 at 08:59:09PM CET, pablo@netfilter.org wrote:
>Hi Pirko,
>
>On Tue, Feb 25, 2020 at 05:22:03PM +0100, Jiri Pirko wrote:
>[...]
>> Eh, that is not that simple. The existing users are used to the fact
>> that the actions are providing counters by themselves. Having and
>> explicit counter action like this would break that expectation.
>> Also, I think it should be up to the driver implementation. Some HW
>> might only support stats per rule, not the actions. Driver should fit
>> into the existing abstraction, I think it is fine.
>
>Something like the sketch patch that I'm attaching?

But why? Actions are separate entities, with separate counters. The
driver is either able to offload that or not. Up to the driver to
abstract this out.


>
>The idea behind it is to provide a counter action through the
>flow_action API. Then, tc_setup_flow_action() checks if this action
>comes with counters in that case the counter action is added.
>
>My patch assumes tcf_vlan_counter() provides tells us what counter
>type the user wants, I just introduced this to provide an example.
>
>Thank you.

>diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
>index c6f7bd22db60..1a5006091edc 100644
>--- a/include/net/flow_offload.h
>+++ b/include/net/flow_offload.h
>@@ -138,9 +138,16 @@ enum flow_action_id {
> 	FLOW_ACTION_MPLS_PUSH,
> 	FLOW_ACTION_MPLS_POP,
> 	FLOW_ACTION_MPLS_MANGLE,
>+	FLOW_ACTION_COUNTER,
> 	NUM_FLOW_ACTIONS,
> };
> 
>+enum flow_action_counter_type {
>+	FLOW_COUNTER_DISABLED		= 0,
>+	FLOW_COUNTER_DELAYED,
>+	FLOW_COUNTER_IMMEDIATE,
>+};
>+
> /* This is mirroring enum pedit_header_type definition for easy mapping between
>  * tc pedit action. Legacy TCA_PEDIT_KEY_EX_HDR_TYPE_NETWORK is mapped to
>  * FLOW_ACT_MANGLE_UNSPEC, which is supported by no driver.
>@@ -213,6 +220,9 @@ struct flow_action_entry {
> 			u8		bos;
> 			u8		ttl;
> 		} mpls_mangle;
>+		struct {				/* FLOW_ACTION_COUNTER */
>+			enum flow_action_counter_type	type;
>+		} counter;
> 	};
> };
> 
>diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>index 13c33eaf1ca1..984f2129c760 100644
>--- a/net/sched/cls_api.c
>+++ b/net/sched/cls_api.c
>@@ -3435,6 +3435,7 @@ static void tcf_sample_get_group(struct flow_action_entry *entry,
> int tc_setup_flow_action(struct flow_action *flow_action,
> 			 const struct tcf_exts *exts)
> {
>+	enum flow_action_counter_type counter = FLOW_COUNTER_DISABLED;
> 	struct tc_action *act;
> 	int i, j, k, err = 0;
> 
>@@ -3489,6 +3490,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
> 				err = -EOPNOTSUPP;
> 				goto err_out_locked;
> 			}
>+			counter = tcf_vlan_counter(act);
> 		} else if (is_tcf_tunnel_set(act)) {
> 			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
> 			err = tcf_tunnel_encap_get_tunnel(entry, act);
>@@ -3567,10 +3569,19 @@ int tc_setup_flow_action(struct flow_action *flow_action,
> 			err = -EOPNOTSUPP;
> 			goto err_out_locked;
> 		}
>-		spin_unlock_bh(&act->tcfa_lock);
> 
> 		if (!is_tcf_pedit(act))
> 			j++;
>+
>+		if (counter) {
>+			struct flow_action_entry *entry;
>+
>+			entry = &flow_action->entries[j++];
>+			entry->id = FLOW_ACTION_COUNTER;
>+			entry->counter.type = counter;
>+			counter = FLOW_COUNTER_DISABLED;
>+		}
>+		spin_unlock_bh(&act->tcfa_lock);
> 	}
> 
> err_out:

