Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 288DF41537D
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238299AbhIVWd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 18:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbhIVWd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 18:33:56 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261F5C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:32:26 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id x9so4447979qtv.0
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 15:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DDs3Yia41qjcTEvUG3xpQcfWAqsHUxC0GxJ/XYnTTpo=;
        b=h8WED7ReknF4JEhmVO2q3VJZ8USxVmUHb1ZYHzTYOqaoIU5KL7KhicwFFJdxE9pqbf
         pOzqSo5Ll+TLRfLUFjEQ3skRA55JORUxqskY+fIghQEyN0RANmPA9vzG3Sbv8rWFea3H
         ZOv3ujLnfQNyVX1HpxoGGWLR4tHjqL+5N5vjFEXD3ryjVwjWmCaAGsZCVefcAy5gN25t
         fSs5UXKF2b3PDcsOGvj3I5buPWVt45HhCAoCuBb7pDNqON9bt+OzZNOO6Ci0/J41DywC
         dFBeVuElnqDdYDGYDCePfwOA5KDFC12WRR/srg2cbEfIDEoW4+U9/xYTeWhTZphyocrY
         m/dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DDs3Yia41qjcTEvUG3xpQcfWAqsHUxC0GxJ/XYnTTpo=;
        b=xihuwk7ypiGEGbAjLCcRJ16I+DCN/GUTyEuCvgX+tl4FULx1R20R1G556wULoe0ec3
         26113nXlMEYaR4l5wvvVLCHVxFAHLJ8OYfs/0v38xqkq1wEFw42AEK6fBTED+G1ej03v
         s0T5iwQ/MyuTTMtrKYS1LWOPXeIuMb+MtMobRplu1+6eEXATttW/kWgt2zR05gJA3tF7
         VFl0JWyxL10lTZhkhdvEvl2+dn9Ax2Jc2cJviM3KkOdMcyMuJAYS5enOKZQEcZJEKg/B
         ipKsTV2zWA70ZUeKHoTwmoxTNKC4Rk7LpxqTFBNacTE2n8LJXaSGdNzEEhGfFMgr+4FE
         kBPA==
X-Gm-Message-State: AOAM532rH2zawxWSebMQ/mbq2xfeNqDDkZmI2Q0YnLut6r2pbz3O5LjU
        HWifRWtf+w8UGw0uktmHHS4=
X-Google-Smtp-Source: ABdhPJzLsc9LYdy/dEnZd6FLTqJygkBGUKv6nLOuW2a/pYK7Xh6In5oT28+1GZDq2Ua2ukGZkxAmag==
X-Received: by 2002:a05:622a:164d:: with SMTP id y13mr1780384qtj.409.1632349945313;
        Wed, 22 Sep 2021 15:32:25 -0700 (PDT)
Received: from t14s.localdomain ([2001:1284:f013:2c24:c5d:c7c9:5f4:10d7])
        by smtp.gmail.com with ESMTPSA id o202sm2891228qke.51.2021.09.22.15.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 15:32:24 -0700 (PDT)
Received: by t14s.localdomain (Postfix, from userid 89)
        id ADCDA675C8; Wed, 22 Sep 2021 20:06:16 -0300 (-03)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id 2F1B4673B3; Wed, 22 Sep 2021 17:33:45 -0300 (-03)
Date:   Wed, 22 Sep 2021 17:33:45 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Felipe Magno de Almeida <felipe@sipanda.io>
Cc:     jhs@mojatatu.com, jiri@resnulli.us, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, boris.sukholitko@broadcom.com,
        vadym.kochan@plvision.eu, ilya.lifshits@broadcom.com,
        vladbu@nvidia.com, idosch@idosch.org, paulb@nvidia.com,
        dcaratti@redhat.com, amritha.nambiar@intel.com,
        sridhar.samudrala@intel.com, tom@sipanda.io,
        pctammela@mojatatu.com, eric.dumazet@gmail.com
Subject: Re: [PATCH RFC net-next 2/2] net/sched: Add flower2 packet
 classifier based on flower and PANDA parser
Message-ID: <YUuTKVdtAV73OjVu@t14s.localdomain>
References: <20210916200041.810-1-felipe@expertise.dev>
 <20210916200041.810-3-felipe@expertise.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916200041.810-3-felipe@expertise.dev>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 05:00:41PM -0300, Felipe Magno de Almeida wrote:
> +int fl2_panda_parse(struct sk_buff *skb, struct fl2_flow_key* frame)
> +{
> +	int err;
> +	struct panda_parser_big_metadata_one mdata;
> +	void *data;
> +	size_t pktlen;
> +
> +	memset(&mdata, 0, sizeof(mdata.panda_data));
> +	memcpy(&mdata.frame, frame, sizeof(struct fl2_flow_key));
> +
> +	err = skb_linearize(skb);

Oh ow. Hopefully this is just for the RFC?

> +	if (err < 0)
> +		return err;
> +
> +	BUG_ON(skb->data_len);
> +
> +	data = skb_mac_header(skb);
> +	pktlen = skb_mac_header_len(skb) + skb->len;
> +
> +	err = panda_parse(PANDA_PARSER_KMOD_NAME(panda_parser_big_ether), data,
> +			  pktlen, &mdata.panda_data, 0, 1);
> +
> +	if (err != PANDA_STOP_OKAY) {
> +                pr_err("Failed to parse packet! (%d)", err);
> +		return -1;
> +        }
> +
> +	memcpy(frame, &mdata.frame, sizeof(struct fl2_flow_key));
> +
> +	return 0;
> +}
> +
> +static int fl2_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> +		       struct tcf_result *res)
> +{
> +	struct cls_fl2_head *head = rcu_dereference_bh(tp->root);
> +	struct fl2_flow_key skb_key;
> +	struct fl2_flow_mask *mask;
> +	struct cls_fl2_filter *f;
> +
> +	list_for_each_entry_rcu(mask, &head->masks, list) {
> +		flow_dissector_init_keys(&skb_key.control, &skb_key.basic);
> +		fl2_clear_masked_range(&skb_key, mask);
> +
> +		skb_flow_dissect_meta(skb, &mask->dissector, &skb_key);
> +		/* skb_flow_dissect() does not set n_proto in case an unknown
> +		 * protocol, so do it rather here.
> +		 */
> +		skb_key.basic.n_proto = skb_protocol(skb, false);
> +
> +		if(skb->vlan_present) {
> +			skb_key.basic.n_proto = skb_protocol(skb, true);
> +			skb_key.vlan.vlan_id = skb_vlan_tag_get_id(skb);
> +			skb_key.vlan.vlan_priority = skb_vlan_tag_get_prio(skb);
> +			skb_key.vlan.vlan_tpid = skb->vlan_proto;
> +		}
> +		
> +		fl2_panda_parse(skb, &skb_key);
> +
> +		f = fl2_mask_lookup(mask, &skb_key);
> +		if (f && !tc_skip_sw(f->flags)) {
> +			*res = f->res;
> +			return tcf_exts_exec(skb, &f->exts, res);
> +		}
> +	}
> +	return -1;
> +}
