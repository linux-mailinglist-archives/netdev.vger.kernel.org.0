Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF126BB506
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjCONqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjCONpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:45:52 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA27F89F2F
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:45:32 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso1274781wmo.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678887922;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j0QzcHopQ3Y6avbmbzU9MqbT+eCtuJg1Hz5UkTwk8s0=;
        b=TDDsmtrfHgT/g+pWM9n8061n/qMZzfTHH/8gyxQA/4iatgAqfQj6PDsU+pZO+Y21aj
         NqEqHoaPintTAlmC3/hrVvuiNL5aQ9YHSYn4sv31aOB3RVqkb3+VGt0G16OMBdMxEE9O
         N7ZJhLwguXqc6dZZT4dCvCjfIhkMqu1dp9P5lEi2ghjiwULdR1k0H1PlQtokYnrfhff2
         i94tX7+OyxsC+nrbRegtkVC4RW86JVLd9jYCG5TF63ppgaO62UQNgZXITNym5pk67fiM
         0GHhYM34j6cQMzbFKm1rgk469nwf/j8IlmKJqhbcU4fkgVtu3UPol9c/jt/RbiBy7WGo
         6Tuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678887922;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0QzcHopQ3Y6avbmbzU9MqbT+eCtuJg1Hz5UkTwk8s0=;
        b=18QfA6Th1+82HLB46OHBoxOWdxt1Plh1dbc8qcdQ0Ej7F+HIzevx9Nfqvh9yqlQGYc
         KLn/qcchvA6NLI/KOkRauXCEscrTkhnLlVyCVlB6upKHKs+EngeOa5vtzYn7K/mvRgiR
         JKX93soFUNg6iHqdvmn5PYhDA7Ho0UszbywCnr4s6TdgazpX2b3g43h09+t97IURTkiy
         kciXbphDl5JUdfzkO7RKrTo6RAg47VxJnkrp9MoeyJDaEZtN7H6jby1CHTeCHDdThQaO
         MP+wAqQV+jerbt0HlCav3wkP1i5Us+OAyc5kOypePTNFcaUcPctXetcUDhUEusClaY9J
         LsIA==
X-Gm-Message-State: AO0yUKWgFr2kyXzq+WdmlMnNZ8xz6aku5TwIVfTg49XiRiyNnb1MtE4j
        k3NY2UfBJfuyqj27C7uvkQD0x00rctA=
X-Google-Smtp-Source: AK7set+ZflLzHxxY9HlGZpsUhb/m3R6Y1E6GHlurx09M8iNT0ft3cOW6uXFaxKqb8bhk6ovd9la4Gg==
X-Received: by 2002:a05:600c:4506:b0:3ed:253c:621b with SMTP id t6-20020a05600c450600b003ed253c621bmr10910529wmo.21.1678887922350;
        Wed, 15 Mar 2023 06:45:22 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id o13-20020a5d4a8d000000b002c5534db60bsm4690015wrq.71.2023.03.15.06.45.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 06:45:21 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] sfc: add notion of match on enc keys to MAE
 machinery
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com
References: <cover.1678815095.git.ecree.xilinx@gmail.com>
 <cc70de55f816fe885fcb73003a9822961d1c5dfd.1678815095.git.ecree.xilinx@gmail.com>
 <ZBFjVV7ZfOz9u50M@localhost.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <82fd806a-7e69-1922-807d-85b08a10efbe@gmail.com>
Date:   Wed, 15 Mar 2023 13:45:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ZBFjVV7ZfOz9u50M@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2023 06:19, Michal Swiatkowski wrote:
> On Tue, Mar 14, 2023 at 05:35:21PM +0000, edward.cree@amd.com wrote:
>> +	/* Matches on outer fields are done in a separate hardware table,
>> +	 * the Outer Rule table.  Thus the Action Rule merely does an
>> +	 * exact match on Outer Rule ID if any outer field matches are
>> +	 * present.  The exception is the VNI/VSID (enc_keyid), which is
>> +	 * available to the Action Rule match iff the Outer Rule matched
> if I think :)

Nope, I did mean iff: https://en.wiktionary.org/wiki/iff
Just my reflexes as an ex-mathmo kicking in again.

>> +#define CHECK(_mcdi)	({						       \
>> +	rc = efx_mae_match_check_cap_typ(supported_fields[MAE_FIELD_ ## _mcdi],\
>> +					 MASK_ONES);			       \
>> +	if (rc)								       \
>> +		NL_SET_ERR_MSG_FMT_MOD(extack,				       \
>> +				       "No support for field %s", #_mcdi);     \
>> +	rc;								       \
>> +})
> Is there any reasone why macro is used instead of function? It is a
> little hard to read becasue it is modyfing rc value.

It makes its use more compact, as we can chain several calls with ||,
 and the short-circuiting means the first one to fail will set rc.
Perhaps less valuable here than in the efx_mae_match_check_caps()
 version, which has much longer ||-chains, but I thought it better to
 be consistent.

>> +	/* enc-keys are handled indirectly, through encap_match ID */
>> +	if (match->encap) {
>> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID,
>> +				      match->encap->fw_id);
>> +		MCDI_STRUCT_SET_DWORD(match_crit, MAE_FIELD_MASK_VALUE_PAIRS_V2_OUTER_RULE_ID_MASK,
>> +				      (u32)-1);
> U32_MAX can't be used here?

Yeah, it can, will change.  Thanks.

>> +	} else {
>> +		/* No enc-keys should appear in a rule without an encap_match */
>> +		if (WARN_ON_ONCE(match->mask.enc_src_ip) ||
>> +		    WARN_ON_ONCE(match->mask.enc_dst_ip) ||
>> +		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_src_ip6)) ||
>> +		    WARN_ON_ONCE(!ipv6_addr_any(&match->mask.enc_dst_ip6)) ||
>> +		    WARN_ON_ONCE(match->mask.enc_ip_tos) ||
>> +		    WARN_ON_ONCE(match->mask.enc_ip_ttl) ||
>> +		    WARN_ON_ONCE(match->mask.enc_sport) ||
>> +		    WARN_ON_ONCE(match->mask.enc_dport) ||
>> +		    WARN_ON_ONCE(match->mask.enc_keyid))
>> +			return -EOPNOTSUPP;
> Can be written as else if {}

So it can.  Will change.

> Also, You define a similar function: efx_tc_match_is_encap(), I think it
> can be used here.

This way we get individualised warnings indicating which field is
 erroneously used, WARN_ON_ONCE(efx_tc_match_is_encap()) wouldn't
 give us that.

>> +struct efx_tc_encap_match {
>> +	__be32 src_ip, dst_ip;
>> +	struct in6_addr src_ip6, dst_ip6;
>> +	__be16 udp_dport;
> What about source port? It isn't supported?

The hardware can support it, but for simplicity, the initial driver
 implementation only allows one mask (set of keys), to make it easy
 to prevent two rules overlapping.  If there are optional keys or
 custom masks, then it's possible for two rules to both match the
 same packet, which causes undefined behaviour in some versions of
 the hardware.  We picked this key set as it appears to be what's
 used by a typical OvS deployment.
We do have some unsubmitted code that relaxes the driver limitation
 to allow an optional masked match on enc_ip_tos as long as the
 driver can prove there's no overlap with other rules; it should be
 possible to extend this to also allow an optional source port
 match.  I hope to follow up with this in a future patch series.
