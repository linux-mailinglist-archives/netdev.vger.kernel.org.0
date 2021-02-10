Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AE8C315B50
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 01:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234165AbhBJAeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 19:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233732AbhBJANg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 19:13:36 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB3FC061786
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 16:12:56 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id r77so21901qka.12
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 16:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1s2btH15/qt3+1/RtDwaN9xqhOndmBYl62+foPJJmcM=;
        b=VWWXdAo2jBSjb9EAl0WAPEb0XCKueu9m3BQnE1e+a7jPUkwD9w7q4rfqkrkR8CXPMi
         m8GMw7vT8bpSSYvyIvfgguxn0muQaYE5QgKxPFgdYpmPUnHmxxpQfp5GMuddoKLNafdy
         p6uCKiQTemHkLYf+8t8/XHwMfmWfWhhZYHoDnM3WXCQPq1H3aIADA2xytwlZuQilVKx+
         bWqwyFzS3rqQIpYjZJW1tD4x2q6m3FfS1X2wF43PrX224DHhNCWEBYDJ7bCuRxlosmeU
         i0R5bDWZoYjIRuhMg8fd5cb+v58/DyOyS4gtlPKLfkj94Tre2yWijCSRchXKFKaQ8cJv
         GErQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1s2btH15/qt3+1/RtDwaN9xqhOndmBYl62+foPJJmcM=;
        b=oNBda2NQDQdvdpLeoi5FngwPaKIMtJpUnFHynal2Pf/Y3PmgATPafEVoH9wTR40vYs
         IFJd+IaEYebHeEmZSrOyngcMoU9lcEeS2/6IkMa62gGXXaU693OSzZkCirpKcZ7IgC2T
         rgdZryaE/uTbgFhpDYLAcDH+uoHGcjqDjq15rlXLYWVpQrYeCewhCRHR4aPd5+axCCgO
         /2h/1wnYBMQhX2UPM6+O9XKd5C9kHytjwCrt0Vs3GVPJFQ9GxRXD53kGsAW4ENnvex7Y
         sb5/SW8QsErhbzKEcOFVAypdXomkp+ckXRmAILJ92kscJfA9byKnIGaFzucJ/0jpr1Zd
         mJZQ==
X-Gm-Message-State: AOAM532w9vnXYARYXDIgCnniIjED8F0hGOGTpVVZy61GZ9lxFLciSpcf
        ncIFlUHTgLk5hFCkwWiChiEMtHPEigUoJg==
X-Google-Smtp-Source: ABdhPJwNztchXHGt81L9cDC5eUgT1Ef9UOkBBcFg2psTlj2hlQ80Tk3BkV8XeEQ6gsljevBePJ8KTg==
X-Received: by 2002:a05:620a:10a2:: with SMTP id h2mr815499qkk.463.1612915975687;
        Tue, 09 Feb 2021 16:12:55 -0800 (PST)
Received: from horizon.localdomain ([177.220.172.87])
        by smtp.gmail.com with ESMTPSA id p188sm268160qkf.89.2021.02.09.16.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:12:54 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1BE1BC00A2; Tue,  9 Feb 2021 21:12:52 -0300 (-03)
Date:   Tue, 9 Feb 2021 21:12:52 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     wenxu@ucloud.cn
Cc:     jhs@mojatatu.com, kuba@kernel.org, netdev@vger.kernel.org,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Subject: Re: [PATCH net v5] net/sched: cls_flower: Reject invalid ct_state
 flags rules
Message-ID: <20210210001252.GI2953@horizon.localdomain>
References: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612852669-4165-1-git-send-email-wenxu@ucloud.cn>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 09, 2021 at 02:37:49PM +0800, wenxu@ucloud.cn wrote:
> --- a/net/sched/cls_flower.c
> +++ b/net/sched/cls_flower.c
> @@ -30,6 +30,11 @@
>  
>  #include <uapi/linux/netfilter/nf_conntrack_common.h>
>  
> +#define TCA_FLOWER_KEY_CT_FLAGS_MAX \
> +		((__TCA_FLOWER_KEY_CT_FLAGS_MAX - 1) << 1)
> +#define TCA_FLOWER_KEY_CT_FLAGS_MASK \
> +		(TCA_FLOWER_KEY_CT_FLAGS_MAX - 1)
> +
>  struct fl_flow_key {
>  	struct flow_dissector_key_meta meta;
>  	struct flow_dissector_key_control control;
> @@ -686,8 +691,10 @@ static void *fl_get(struct tcf_proto *tp, u32 handle)
>  	[TCA_FLOWER_KEY_ENC_IP_TTL_MASK] = { .type = NLA_U8 },
>  	[TCA_FLOWER_KEY_ENC_OPTS]	= { .type = NLA_NESTED },
>  	[TCA_FLOWER_KEY_ENC_OPTS_MASK]	= { .type = NLA_NESTED },
> -	[TCA_FLOWER_KEY_CT_STATE]	= { .type = NLA_U16 },
> -	[TCA_FLOWER_KEY_CT_STATE_MASK]	= { .type = NLA_U16 },
> +	[TCA_FLOWER_KEY_CT_STATE]	=
> +		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
> +	[TCA_FLOWER_KEY_CT_STATE_MASK]	=
> +		NLA_POLICY_MASK(NLA_U16, TCA_FLOWER_KEY_CT_FLAGS_MASK),
>  	[TCA_FLOWER_KEY_CT_ZONE]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_ZONE_MASK]	= { .type = NLA_U16 },
>  	[TCA_FLOWER_KEY_CT_MARK]	= { .type = NLA_U32 },
> @@ -1390,12 +1397,33 @@ static int fl_set_enc_opt(struct nlattr **tb, struct fl_flow_key *key,
>  	return 0;
>  }
>  
> +static int fl_validate_ct_state(u16 state, struct nlattr *tb,
> +				struct netlink_ext_ack *extack)
> +{
> +	if (state && !(state & TCA_FLOWER_KEY_CT_FLAGS_TRACKED)) {
> +		NL_SET_ERR_MSG_ATTR(extack, tb,
> +				    "no trk, so no other flag can be set");

I just tested iproute2 and it can't report based on the attr here.
Nonetheless, that would be iproute2 job and not the errmsg, I think.

Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Thanks!

> +		return -EINVAL;
> +	}
> +
> +	if (state & TCA_FLOWER_KEY_CT_FLAGS_NEW &&
> +	    state & TCA_FLOWER_KEY_CT_FLAGS_ESTABLISHED) {
> +		NL_SET_ERR_MSG_ATTR(extack, tb,
> +				    "new and est are mutually exclusive");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  static int fl_set_key_ct(struct nlattr **tb,
>  			 struct flow_dissector_key_ct *key,
>  			 struct flow_dissector_key_ct *mask,
>  			 struct netlink_ext_ack *extack)
>  {
>  	if (tb[TCA_FLOWER_KEY_CT_STATE]) {
> +		int err;
> +
>  		if (!IS_ENABLED(CONFIG_NF_CONNTRACK)) {
>  			NL_SET_ERR_MSG(extack, "Conntrack isn't enabled");
>  			return -EOPNOTSUPP;
> @@ -1403,6 +1431,13 @@ static int fl_set_key_ct(struct nlattr **tb,
>  		fl_set_key_val(tb, &key->ct_state, TCA_FLOWER_KEY_CT_STATE,
>  			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
>  			       sizeof(key->ct_state));
> +
> +		err = fl_validate_ct_state(mask->ct_state,
> +					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
> +					   extack);
> +		if (err)
> +			return err;
> +
>  	}
>  	if (tb[TCA_FLOWER_KEY_CT_ZONE]) {
>  		if (!IS_ENABLED(CONFIG_NF_CONNTRACK_ZONES)) {
> -- 
> 1.8.3.1
> 
