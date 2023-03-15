Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395AB6BB65D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 15:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjCOOnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 10:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbjCOOni (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 10:43:38 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD3388EFB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:43:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id q16so17545996wrw.2
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 07:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678891407;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PGk42Qdia22Yybsvm8NRwfH/j0OJcd4hytpNQc8RNCY=;
        b=T+p5FgfPopDDV2t3qwEXuzp5uvHJCIZIYHQSuxwhhxQzTO4uAVghvD1FY/bifr26QU
         w4HOUhxU0ByibJDAVS2QeLruWNcEm2W1RDMNl9/6agDN5G8UKTUwG/QzSWKyN36Sl5sx
         G/9kmUuKS6XuYYrKhVlk491TdG4CrIsA5Cz4nU3qDLpM749pf0A+yXB9YW3LbDJ4Yned
         8qORIf6Ub4LdanzYo75RIrDeQh4jv3ogJs0Z0DH7U7wDGkZCRPJYQtrf3xcTbKiDYca+
         5aDSjK3aLneskgcLJnzjv+sNNGNWgVJJeyBep3SVkJNMxWbRk4dXDFe4b6MQajuc8VQ+
         VEqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678891407;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PGk42Qdia22Yybsvm8NRwfH/j0OJcd4hytpNQc8RNCY=;
        b=wwf/cuGM2Rjv8RTKAdFLT0eqkFo3EAqT3oeal0qzWZdliJc7mbKEtuXK25ruPmB7O6
         7PmePEJwzhMduj+y7l+u8LxJwz7jkh+CZgAfRfoktNLcybEWz0Dl29uATA8dwj62XQZ+
         R1oVSdpUn2WN3E03L2DyX0zrslxr2qcSvO1DgdjYROKvvKxm4MxZjct9aAYe4P+cSGT2
         4PMwG9amtjON4jPUEa3J3Ju3ffPsnJUGWhkwm38tdBDTZ1nRCUTfnCuaHlvsrIO/qGxr
         hdX1xdvzGM8ywDIDaSdDs2lMnPasGx73XaXiQPChc7X63xvClZGc5oo2pQf7dgHhXmGD
         21TQ==
X-Gm-Message-State: AO0yUKW7RQfQ9F5Ndcz78c+JKS+bmUbFuRqU5dofZ9z41a0MlXDfSJU1
        l+E2H/TtFyh9zKVJ+fh5BXw=
X-Google-Smtp-Source: AK7set8D5OHC0KoyUCapv5oYiPx4zp2TKK7jCqP7D1gaaR+sP0i7HLtEHj4SZiDgZNfu5qToie8MCw==
X-Received: by 2002:adf:ec89:0:b0:2cf:ea5d:f5fe with SMTP id z9-20020adfec89000000b002cfea5df5femr2227645wrn.36.1678891407559;
        Wed, 15 Mar 2023 07:43:27 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id h5-20020a5d5485000000b002c5a1bd5280sm4785750wrv.95.2023.03.15.07.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 07:43:27 -0700 (PDT)
Subject: Re: [PATCH net-next 5/5] sfc: add offloading of 'foreign' TC (decap)
 rules
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <a7aabdb45290f1cd50681eb9e1d610893fbce299.1678815095.git.ecree.xilinx@gmail.com>
 <ZBGZvr/tDZYaUAht@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <4553b684-56ec-fe81-1692-b11e10914941@gmail.com>
Date:   Wed, 15 Mar 2023 14:43:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZBGZvr/tDZYaUAht@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 10:11, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 05:35:25PM +0000, edward.cree@amd.com wrote:
>> +int efx_mae_check_encap_type_supported(struct efx_nic *efx, enum efx_encap_type typ)
>> +{
>> +	unsigned int bit;
>> +
>> +	switch (typ & EFX_ENCAP_TYPES_MASK) {
> In 3/5 You ommited EFX_ENCAP_TYPE_NVGRE, was it intetional?

No, I'll go back and add it.

>> +enum efx_encap_type efx_tc_indr_netdev_type(struct net_device *net_dev)
>> +{
>> +	if (netif_is_vxlan(net_dev))
>> +		return EFX_ENCAP_TYPE_VXLAN;
>> +	if (netif_is_geneve(net_dev))
>> +		return EFX_ENCAP_TYPE_GENEVE;
> netif_is_gretap or NVGRE isn't supported?

It should be supported, the hardware can handle it.
I'll add it in v2, and test to make sure it actually works ;)

>> +static const char *efx_tc_encap_type_name(enum efx_encap_type typ, char *buf,
>> +					  size_t n)
>> +{
>> +	switch (typ) {
>> +	case EFX_ENCAP_TYPE_NONE:
>> +		return "none";
>> +	case EFX_ENCAP_TYPE_VXLAN:
>> +		return "vxlan";
>> +	case EFX_ENCAP_TYPE_NVGRE:
>> +		return "nvgre";
>> +	case EFX_ENCAP_TYPE_GENEVE:
>> +		return "geneve";
>> +	default:
>> +		snprintf(buf, n, "type %u\n", typ);
>> +		return buf;
> I will return unsupported here, instead of playing with buffer.

Hmm, maybe if I add a one-time netif_warn()?  I don't like the
 idea of not getting the bogus value out anywhere where it can
 be debugged.

>>  /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
> Is it a device documentation? Where it can be find?

Ahh, turns out this document isn't public :(  I'll see if we
 can get this section of it split out into something public.

> 
>>  enum efx_tc_action_order {
>> +	EFX_TC_AO_DECAP,
>>  	EFX_TC_AO_VLAN_POP,
>>  	EFX_TC_AO_VLAN_PUSH,
>>  	EFX_TC_AO_COUNT,
>> @@ -513,6 +558,10 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
>>  					  enum efx_tc_action_order new)
>>  {
>>  	switch (new) {
>> +	case EFX_TC_AO_DECAP:
>> +		if (act->decap)
>> +			return false;
>> +		fallthrough;
>>  	case EFX_TC_AO_VLAN_POP:
>>  		if (act->vlan_pop >= 2)
>>  			return false;
>> @@ -540,6 +589,288 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
>>  	}
>>  }
>>  
>> +static int efx_tc_flower_replace_foreign(struct efx_nic *efx,
>> +					 struct net_device *net_dev,
>> +					 struct flow_cls_offload *tc)
>> +{
>> +	struct flow_rule *fr = flow_cls_offload_flow_rule(tc);
>> +	struct netlink_ext_ack *extack = tc->common.extack;
>> +	struct efx_tc_flow_rule *rule = NULL, *old = NULL;
>> +	struct efx_tc_action_set *act = NULL;
>> +	bool found = false, uplinked = false;
>> +	const struct flow_action_entry *fa;
>> +	struct efx_tc_match match;
>> +	struct efx_rep *to_efv;
>> +	s64 rc;
>> +	int i;
>> +
>> +	/* Parse match */
>> +	memset(&match, 0, sizeof(match));
>> +	rc = efx_tc_flower_parse_match(efx, fr, &match, NULL);
>> +	if (rc)
>> +		return rc;
>> +	/* The rule as given to us doesn't specify a source netdevice.
>> +	 * But, determining whether packets from a VF should match it is
>> +	 * complicated, so leave those to the software slowpath: qualify
>> +	 * the filter with source m-port == wire.
>> +	 */
>> +	rc = efx_tc_flower_external_mport(efx, EFX_EFV_PF);
> Let's define extern_port as s64, a rc as int, it will be more readable I
> think.

Will it?  I feel it looks more natural this way — this is the way
 it would be written if mports always fitted into an int; the fact
 that they're actually u32 and thus the value needs to be wider to
 hold either an mport or an -errno is locally irrelevant to the
 reader.

>> +	/* Parse actions.  For foreign rules we only support decap & redirect */
>> +	flow_action_for_each(i, fa, &fr->action) {
>> +		struct efx_tc_action_set save;
>> +
>> +		switch (fa->id) {
>> +		case FLOW_ACTION_REDIRECT:
>> +		case FLOW_ACTION_MIRRED:
>> +			/* See corresponding code in efx_tc_flower_replace() for
>> +			 * long explanations of what's going on here.
>> +			 */
>> +			save = *act;
> Why save is needed here? In one bloick You are changing act, in other
> save.

Below, we set:

>> +			act->dest_mport = rc;
>> +			act->deliver = 1;

but then if this action is a mirred egress mirror, we don't want the
 next action-set in the action-set-list to deliver to the same place.
So we save the action state (collection of mutations applied to the
 packet) before the mirred, so that we can resume from where we left
 off:

>> +			/* Mirror, so continue on with saved act */
>> +			save.count = NULL;
>> +			act = kzalloc(sizeof(*act), GFP_USER);
>> +			if (!act) {
>> +				rc = -ENOMEM;
>> +				goto release;
>> +			}
>> +			*act = save;

The setting of save.count is a copy-paste error; that's needed in
 the non-tunnel case (efx_tc_flower_replace()) since that has a
 separate block for attaching counters (handling the case of
 FLOW_ACTION_DROP which we don't accept here in
 efx_tc_flower_replace_foreign()), but it's not needed here; maybe
 that was part of the confusion.

>> +			rc = efx_mae_alloc_action_set(efx, act);
>> +			if (rc) {
>> +				NL_SET_ERR_MSG_MOD(extack,
>> +						   "Failed to write action set to hw (mirred)");
>> +				goto release;
>> +			}
>> +			list_add_tail(&act->list, &rule->acts.list);
>> +			act = NULL;
> act was allocated, You need to free it, or maybe it is being cleared in
> alloc_action_set()? However, this function is really hard to follow.
> Please explain it more widely.

The list_add_tail attaches act (the action-set) to the list in
 rule->acts (the action-set-list), meaning it will be freed when the
 action-set-list is destroyed by efx_tc_free_action_set_list(),
 either in this function's failure ladder or in efx_tc_delete_rule().
I will try and write an extended comment under /* Parse actions */ to
 explain the use of this act 'cursor'.  Or rather, I'll add the
 comment to the efx_tc_flower_replace() equivalent, which works the
 same way, and reference it from here.

>> +	rc = efx_mae_insert_rule(efx, &rule->match, EFX_TC_PRIO_TC,
>> +				 rule->acts.fw_id, &rule->fw_id);
>> +	if (rc) {
>> +		NL_SET_ERR_MSG_MOD(extack, "Failed to insert rule in hw");
>> +		goto release_act;
>> +	}
> act is saved somewhere?

Sorry, this should be called `release_acts`, as its job is to
 remove the action-set-list (rule->acts) from hardware.  Will fix.

Thanks for the very thorough review of this series :)
