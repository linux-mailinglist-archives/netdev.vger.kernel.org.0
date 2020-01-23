Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BD6146243
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 08:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgAWHGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 02:06:31 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36664 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgAWHGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 02:06:31 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so1332484wma.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 23:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=me39h0e7RB2s4i0nHahBUBYY28tAFXlvIVAdInCcjaI=;
        b=hM1h+8kukC7ulNEKhOeRhiQo0tMtO6WZAfP9INLybqn+xp2tSefbTnNpHfgSk1PyCW
         V54N0O187Q4Yxp2Bq32kTJsVagToBSt8xlNZiQPtXwBukX0gEK88rFu34yq4p3RrYJqe
         uFk9NGjAdvSbiowLdO3DffwEKioL3NXWqkjeqywmIzjdDMTSg1h0uK3/L7twUVMXhdJs
         lkLEYz5UDahQbn7AtTZABVnoLsUp5e4P0DbIVMnygrWcFKQJfON66DzQLnH+H4+wHEET
         Znh7B3RFy1GRVDXV5ZC5jw8IiCHyT22lnn5afBwTxJmp1F7QT7tFXTM1vhRT8++S23WK
         tmUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=me39h0e7RB2s4i0nHahBUBYY28tAFXlvIVAdInCcjaI=;
        b=HyeFF5TApq59OQIuuWwSwN9rDXdft+VtHgM0mbkLhe0F0oBbRHFdZmtRSJTOXyVoNe
         mWHbcRc0YG4sM3SsMo8fKuwOIKd6eY5okFVqSGY3fQttWvPZPrd1JUPj+nyYs1RKmmJv
         QNzllDb05LiNPFj5cetpHVY5LmOtMpcM+96JEnM/RgM59DZFE0ozhSzhkKjrjFjjdD7h
         NpHFI9r/KCoSKuXII/RpAzBK2Pg8eKEbmJUZ0uW+Vigl+EDhLlmLsvhNM2voTEjCEOW7
         oW+4UvAFX11M/u6hoGJMMPdRH9SxlkbRYktdOh20qY/mkEyF5poNnJr738jpY+u7Crlp
         ce1w==
X-Gm-Message-State: APjAAAUr+5fhCkyqoUN+Eb6oZ9y47YCxUt1TZv19cYISKbGsOYA7d+RF
        /2yWBEPleTS+eMjrB3XvucIs8Q==
X-Google-Smtp-Source: APXvYqwVlprY5lSX2thV+X19MvzH3jKgoNJnfXWrr+MO4DhNQ3yfHrjlENsXDT6+EyuMC682BU3sZQ==
X-Received: by 2002:a1c:4b0a:: with SMTP id y10mr2390703wma.78.1579763189702;
        Wed, 22 Jan 2020 23:06:29 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id f1sm1876130wru.6.2020.01.22.23.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 23:06:28 -0800 (PST)
Date:   Thu, 23 Jan 2020 08:06:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>
Subject: Re: [PATCH net-next v2 01/13] net: sched: support skb chain ext in
 tc classification path
Message-ID: <20200123070627.GB2207@nanopsycho.orion>
References: <1579701178-24624-1-git-send-email-paulb@mellanox.com>
 <1579701178-24624-2-git-send-email-paulb@mellanox.com>
 <20200122072916.23fc3416@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122072916.23fc3416@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 22, 2020 at 04:29:16PM CET, kuba@kernel.org wrote:
>On Wed, 22 Jan 2020 15:52:46 +0200, Paul Blakey wrote:
>> +int tcf_classify_ingress(struct sk_buff *skb,
>> +			 const struct tcf_block *ingress_block,
>> +			 const struct tcf_proto *tp, struct tcf_result *res,
>> +			 bool compat_mode)
>> +{
>> +	const struct tcf_proto *orig_tp = tp;
>> +
>> +#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
>> +	{
>> +		struct tc_skb_ext *ext = skb_ext_find(skb, TC_SKB_EXT);
>> +
>> +		if (ext && ext->chain && ingress_block) {
>> +			struct tcf_chain *fchain;
>> +
>> +			fchain = tcf_chain_lookup_rcu(ingress_block,
>> +						      ext->chain);
>> +			if (!fchain)
>> +				return TC_ACT_UNSPEC;
>> +
>> +			tp = rcu_dereference_bh(fchain->filter_chain);
>> +		}
>
>Doesn't this skb ext have to be somehow "consumed" by the first lookup?
>What if the skb finds its way to an ingress of another device?

You are right. Looks like it would be better to return TC_ACT_SHOT here.


>
>> +	}
>> +#endif
>> +
>> +	return tcf_classify(skb, tp, orig_tp, res, compat_mode);
>> +}
>> +EXPORT_SYMBOL(tcf_classify_ingress);
