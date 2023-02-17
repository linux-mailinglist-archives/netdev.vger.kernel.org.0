Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD6069A7A9
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 10:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbjBQJAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 04:00:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbjBQJAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 04:00:34 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8246460A41
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 01:00:28 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id cn2so1699268edb.4
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 01:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z7MOwsKCElOAtAmLCsle0eppsxQU4MsJcoZwcnw2sw4=;
        b=Xv11GRrNRIS4mttGsTTxI9hhwKE/HeXtHuCz8DO3J/7L3GRyzzGnra7WQAyLh/m25P
         p9XdPWMBGvlZHVXUJO62SGksmHeaQDZPBuRagxnE7Tj2Z3s0+DhCwCAdrkkN7U4T9Ea3
         smocYQkkIqqaxnKrLz9nvfIP/zJu6fNRiQlfDvOjLjtDY9ao50rOln8DVr8XUOaZF+ko
         nmboc38QnuuIAmTztuZzjdQg+aenBfogSbQjXiFPQEDJZPUDpUexLXFwXT1Gc+zErSQP
         VpkeCQDnNEGk02phkvR2h/gJmdOmULupwlRH+XCkLMNnqga/cFRUXWfW5sBWK/EJOdcj
         0cSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z7MOwsKCElOAtAmLCsle0eppsxQU4MsJcoZwcnw2sw4=;
        b=IbVLwfuNyxl5zBO1Gu/YFRYKyunHhTu6JQ3qYBzOluldKgqJqEGH7KrB7L/1YysPTi
         2T7O8ljNe6kBEPhMo19D2XH3wexAEf/pwf/xjbQfTT/imeHgyVLS6lu5VeNTxm0hrUkM
         KdNV8+LOKOtBZACMGGMsc2ryc9dov3DpuL5W+WQgCLWD51H7KmD41ImSk03TCySr5Mxj
         C0GQSb8Cwbl+i/xK4t/hKu/qRRbx+R/EAJy+x+ARYZ+wDLKC5yAfF0+4vruYxykRcCfY
         SZIP8rIxz4RkZkZwtKw7wz8eSsqWBlhr5ZrONpp99JPbt7uiZ25Auzw2Ahs7ADV2lx1C
         /ZGQ==
X-Gm-Message-State: AO0yUKX5L9GO8Vs1lz77QiqyXdYPRDAPVKwG+4ZD/yQXu3SejIir/F02
        ZcHbw2uJOHGwL3gwT0OjwNI=
X-Google-Smtp-Source: AK7set/uLcgrqApxv/wpNVe9igUpc3a6ez0fUCZ+VOz+aRkz2v2wxk/bqKPc6MXLkZADAx4Gb67yfg==
X-Received: by 2002:a05:6402:1345:b0:4ad:7b13:96a6 with SMTP id y5-20020a056402134500b004ad7b1396a6mr2766246edw.24.1676624426899;
        Fri, 17 Feb 2023 01:00:26 -0800 (PST)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id f11-20020a50d54b000000b00488117821ffsm1984661edj.31.2023.02.17.01.00.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 01:00:26 -0800 (PST)
Date:   Fri, 17 Feb 2023 09:00:24 +0000
From:   Martin Habets <habetsm.xilinx@gmail.com>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] sfc: support offloading TC VLAN push/pop
 actions to the MAE
Message-ID: <Y+9B5+qYFhuqzyQr@gmail.com>
Mail-Followup-To: edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Edward Cree <ecree.xilinx@gmail.com>,
        netdev@vger.kernel.org
References: <20230216160442.48394-1-edward.cree@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230216160442.48394-1-edward.cree@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 04:04:42PM +0000, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> EF100 can pop and/or push up to two VLAN tags.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> ---
>  drivers/net/ethernet/sfc/mae.c  | 43 ++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/mcdi.h |  5 ++++
>  drivers/net/ethernet/sfc/tc.c   | 53 +++++++++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/tc.h   |  4 +++
>  4 files changed, 105 insertions(+)
> 
> diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
> index 6321fd393fc3..7ae5b22af624 100644
> --- a/drivers/net/ethernet/sfc/mae.c
> +++ b/drivers/net/ethernet/sfc/mae.c
> @@ -679,9 +679,40 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
>  {
>  	MCDI_DECLARE_BUF(outbuf, MC_CMD_MAE_ACTION_SET_ALLOC_OUT_LEN);
>  	MCDI_DECLARE_BUF(inbuf, MC_CMD_MAE_ACTION_SET_ALLOC_IN_LEN);
> +	unsigned char vlan_push, vlan_pop;
>  	size_t outlen;
>  	int rc;
>  
> +	/* Translate vlan actions from bitmask to count */
> +	switch (act->vlan_push) {
> +	case 0:
> +	case 1:
> +		vlan_push = act->vlan_push;
> +		break;
> +	case 2: /* can't happen */

Use fallthrough here.

> +	default:
> +		return -EINVAL;
> +	case 3:
> +		vlan_push = 2;
> +		break;
> +	}
> +	switch (act->vlan_pop) {
> +	case 0:
> +	case 1:
> +		vlan_pop = act->vlan_pop;
> +		break;
> +	case 2: /* can't happen */

and here.

Martin

> +	default:
> +		return -EINVAL;
> +	case 3:
> +		vlan_pop = 2;
> +		break;
> +	}
> +
> +	MCDI_POPULATE_DWORD_2(inbuf, MAE_ACTION_SET_ALLOC_IN_FLAGS,
> +			      MAE_ACTION_SET_ALLOC_IN_VLAN_PUSH, vlan_push,
> +			      MAE_ACTION_SET_ALLOC_IN_VLAN_POP, vlan_pop);
> +
>  	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_SRC_MAC_ID,
>  		       MC_CMD_MAE_MAC_ADDR_ALLOC_OUT_MAC_ID_NULL);
>  	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_DST_MAC_ID,
> @@ -694,6 +725,18 @@ int efx_mae_alloc_action_set(struct efx_nic *efx, struct efx_tc_action_set *act)
>  			       MC_CMD_MAE_COUNTER_ALLOC_OUT_COUNTER_ID_NULL);
>  	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_COUNTER_LIST_ID,
>  		       MC_CMD_MAE_COUNTER_LIST_ALLOC_OUT_COUNTER_LIST_ID_NULL);
> +	if (act->vlan_push & 1) {
> +		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_TCI_BE,
> +				 act->vlan_tci[0]);
> +		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN0_PROTO_BE,
> +				 act->vlan_proto[0]);
> +	}
> +	if (act->vlan_push & 2) {
> +		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_TCI_BE,
> +				 act->vlan_tci[1]);
> +		MCDI_SET_WORD_BE(inbuf, MAE_ACTION_SET_ALLOC_IN_VLAN1_PROTO_BE,
> +				 act->vlan_proto[1]);
> +	}
>  	MCDI_SET_DWORD(inbuf, MAE_ACTION_SET_ALLOC_IN_ENCAP_HEADER_ID,
>  		       MC_CMD_MAE_ENCAP_HEADER_ALLOC_OUT_ENCAP_HEADER_ID_NULL);
>  	if (act->deliver)
> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> index b139b76febff..454e9d51a4c2 100644
> --- a/drivers/net/ethernet/sfc/mcdi.h
> +++ b/drivers/net/ethernet/sfc/mcdi.h
> @@ -233,6 +233,11 @@ void efx_mcdi_sensor_event(struct efx_nic *efx, efx_qword_t *ev);
>  	((void)BUILD_BUG_ON_ZERO(_field ## _LEN != 2),  \
>  	le16_to_cpu(*(__force const __le16 *)MCDI_STRUCT_PTR(_buf, _field)))
>  /* Write a 16-bit field defined in the protocol as being big-endian. */
> +#define MCDI_SET_WORD_BE(_buf, _field, _value) do {			\
> +	BUILD_BUG_ON(MC_CMD_ ## _field ## _LEN != 2);			\
> +	BUILD_BUG_ON(MC_CMD_ ## _field ## _OFST & 1);			\
> +	*(__force __be16 *)MCDI_PTR(_buf, _field) = (_value);		\
> +	} while (0)
>  #define MCDI_STRUCT_SET_WORD_BE(_buf, _field, _value) do {		\
>  	BUILD_BUG_ON(_field ## _LEN != 2);				\
>  	BUILD_BUG_ON(_field ## _OFST & 1);				\
> diff --git a/drivers/net/ethernet/sfc/tc.c b/drivers/net/ethernet/sfc/tc.c
> index deeaab9ee761..195c288736be 100644
> --- a/drivers/net/ethernet/sfc/tc.c
> +++ b/drivers/net/ethernet/sfc/tc.c
> @@ -286,6 +286,10 @@ static int efx_tc_flower_parse_match(struct efx_nic *efx,
>  
>  /* For details of action order constraints refer to SF-123102-TC-1§12.6.1 */
>  enum efx_tc_action_order {
> +	EFX_TC_AO_VLAN1_POP,
> +	EFX_TC_AO_VLAN0_POP,
> +	EFX_TC_AO_VLAN0_PUSH,
> +	EFX_TC_AO_VLAN1_PUSH,
>  	EFX_TC_AO_COUNT,
>  	EFX_TC_AO_DELIVER
>  };
> @@ -294,6 +298,22 @@ static bool efx_tc_flower_action_order_ok(const struct efx_tc_action_set *act,
>  					  enum efx_tc_action_order new)
>  {
>  	switch (new) {
> +	case EFX_TC_AO_VLAN0_POP:
> +		if (act->vlan_pop & 1)
> +			return false;
> +		fallthrough;
> +	case EFX_TC_AO_VLAN1_POP:
> +		if (act->vlan_pop & 2)
> +			return false;
> +		fallthrough;
> +	case EFX_TC_AO_VLAN0_PUSH:
> +		if (act->vlan_push & 1)
> +			return false;
> +		fallthrough;
> +	case EFX_TC_AO_VLAN1_PUSH:
> +		if (act->vlan_push & 2)
> +			return false;
> +		fallthrough;
>  	case EFX_TC_AO_COUNT:
>  		if (act->count)
>  			return false;
> @@ -393,6 +413,8 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>  
>  	flow_action_for_each(i, fa, &fr->action) {
>  		struct efx_tc_action_set save;
> +		int depth;
> +		u16 tci;
>  
>  		if (!act) {
>  			/* more actions after a non-pipe action */
> @@ -494,6 +516,37 @@ static int efx_tc_flower_replace(struct efx_nic *efx,
>  			}
>  			*act = save;
>  			break;
> +		case FLOW_ACTION_VLAN_POP:
> +			if (act->vlan_push & 2) {
> +				act->vlan_push &= ~2;
> +			} else if (act->vlan_push & 1) {
> +				act->vlan_push &= ~1;
> +			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN0_POP)) {
> +				act->vlan_pop |= 1;
> +			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN1_POP)) {
> +				act->vlan_pop |= 2;
> +			} else {
> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pops, or action order violated");
> +				rc = -EINVAL;
> +				goto release;
> +			}
> +			break;
> +		case FLOW_ACTION_VLAN_PUSH:
> +			if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN0_PUSH)) {
> +				depth = 0;
> +			} else if (efx_tc_flower_action_order_ok(act, EFX_TC_AO_VLAN1_PUSH)) {
> +				depth = 1;
> +			} else {
> +				rc = -EINVAL;
> +				NL_SET_ERR_MSG_MOD(extack, "More than two VLAN pushes, or action order violated");
> +				goto release;
> +			}
> +			tci = fa->vlan.vid & 0x0fff;
> +			tci |= fa->vlan.prio << 13;
> +			act->vlan_push |= (1 << depth);
> +			act->vlan_tci[depth] = cpu_to_be16(tci);
> +			act->vlan_proto[depth] = fa->vlan.proto;
> +			break;
>  		default:
>  			NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
>  					       fa->id);
> diff --git a/drivers/net/ethernet/sfc/tc.h b/drivers/net/ethernet/sfc/tc.h
> index 418ce8c13a06..542853f60c2a 100644
> --- a/drivers/net/ethernet/sfc/tc.h
> +++ b/drivers/net/ethernet/sfc/tc.h
> @@ -19,7 +19,11 @@
>  #define IS_ALL_ONES(v)	(!(typeof (v))~(v))
>  
>  struct efx_tc_action_set {
> +	u16 vlan_push:2;
> +	u16 vlan_pop:2;
>  	u16 deliver:1;
> +	__be16 vlan_tci[2]; /* TCIs for vlan_push */
> +	__be16 vlan_proto[2]; /* Ethertypes for vlan_push */
>  	struct efx_tc_counter_index *count;
>  	u32 dest_mport;
>  	u32 fw_id; /* index of this entry in firmware actions table */
