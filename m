Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907714E2E2D
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 17:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351266AbiCUQiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 12:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351367AbiCUQiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 12:38:07 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04C15E178
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:36:41 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id s8so15870379pfk.12
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 09:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=1E++cROcggRL7wOwZoxtNN9D4sOVj12YdZTCyLaYMP8=;
        b=ZAgNFlyAmoNHsCfDq4vqf5Xria8P7ahZywRWsAXdMY7dK3CFKSTtYQRkyh3wr+Q1uH
         6Tmg7bHajE3WE33NjFpbfIKoUqLYvJ7x+AyDCYIBIRIj/OnTWyKGNzgplDrh/FwHdjUW
         ZIcHXnTIn2y4Cjb24fmKFOewkVi1VlurpF6lijnTbZhdg/fupewbjXg6kdRNWIP43zmu
         dVcCcjWJWwzk/Tdhe7ZCwZEeGXMVnQPPBpWSG8g0sc0900cUJFWhMLSulLajXjEKmGUO
         KXMnuu65wc/phKHfKqTDj3wSzkeb5Cd4NqvfJCwAWL5l7GAYnJf18Z+vOhnM57vBVUPs
         B58A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=1E++cROcggRL7wOwZoxtNN9D4sOVj12YdZTCyLaYMP8=;
        b=zPOvaILNFzkh6/pa1W9Q6oWofRgHQw+/6voXMTfinz4ntujhAUUhZKLq8bzSXL/o+G
         HCXJdvxyorselPd7bedxA7MngjSkHIOHnr7KQMjjWNBeG5vmMoBnJCGLn87Z+rfZXSPq
         Zs1QvYVOym8kPtatyIZ2Vf+qPYqLFB+Io8LuW0IzscdQIzo8Ce19VEmKhQ83u3lSxakq
         eMXwAD2Gf1Wrb5i4xg5z2DsxG0xZV4h7MpSj20ih8VM80oH4vnaosu+gzcWWKQo+fD3N
         B13LGbH7vm1josFu9ypsZYXmsjgCiUmZa6YxsG9C+O090qMk4IK0Mu9tDSSglyvy6JNe
         MOsw==
X-Gm-Message-State: AOAM5327lanBOp6w/d8cNqTIBGfdpTcPKy//vzu1hJ4j2FDp7CAnPibh
        or5bKQv8cX2D3GpYuJkNn7DSHOtvWR+ghg==
X-Google-Smtp-Source: ABdhPJzExSEcDNNFGqn4vmtdhj6m3pSEUSVqTeJHoWEBXhF9N0L1VOgyrJoqDh0GPpMFpS3eRV4aag==
X-Received: by 2002:a05:6a00:c93:b0:4f7:c76:921f with SMTP id a19-20020a056a000c9300b004f70c76921fmr24353859pfv.73.1647880601065;
        Mon, 21 Mar 2022 09:36:41 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id lk7-20020a17090b33c700b001c686a5fc9bsm10938pjb.33.2022.03.21.09.36.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 09:36:40 -0700 (PDT)
Message-ID: <bce06d99-28a3-8e13-2cc2-ddc15f375f3e@gmail.com>
Date:   Tue, 22 Mar 2022 01:36:37 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v2 2/3] net: atlantic: Implement xdp data plane
Content-Language: en-US
To:     Igor Russkikh <irusskikh@marvell.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
References: <20220319140443.6645-1-ap420073@gmail.com>
 <20220319140443.6645-3-ap420073@gmail.com>
 <5067f1b9-2257-226c-4f58-4079d407a161@marvell.com>
From:   Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <5067f1b9-2257-226c-4f58-4079d407a161@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/21/22 23:18, Igor Russkikh wrote:
 > Hi Taehee,
 >

Hi Igor,

Thank you so much for your review!

 > Thanks for taking care of that!
 > Just for your information - I've started xdp draft sometime ago,
 > but never had a time to complete it.
 > If interested, you can check it here:
 > 
https://github.com/Aquantia/AQtion/commit/165cc46cb3fa68eca3110d846db1744a0feee916
 >

Thanks a lot for this information :)

 > Couple of comments on your implementation follows.
 >
 > On 3/19/2022 3:04 PM, Taehee Yoo wrote:
 >> It supports XDP_PASS, XDP_DROP and multi buffer.
 >>
 >>  From now on aq_nic_map_skb() supports xdp_frame to send packet.
 >> So, TX path of both skb and xdp_frame can use aq_nic_map_skb().
 >> aq_nic_xmit() is used to send packet with skb and internally it
 >> calls aq_nic_map_skb(). aq_nic_xmit_xdpf() is used to send packet with
 >> xdp_frame and internally it calls aq_nic_map_skb().
 >
 >>   unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff 
*skb,
 >> -			    struct aq_ring_s *ring)
 >> +			    struct xdp_frame *xdpf, struct aq_ring_s
 >> *ring)
 >>   {
 >
 > Its not a huge problem, but here you are using one function 
(aq_nic_map_skb) with two
 > completely separate paths: either skb != NULL or xdpf != NULL.
 > This makes the function abit cumbersome and error prone.
 >
 >> +	if (xdpf) {
 >> +		sinfo = xdp_get_shared_info_from_frame(xdpf);
 >> +		total_len = xdpf->len;
 >> +		dx_buff->len = total_len;
 >> +		data_ptr = xdpf->data;
 >> +		if (xdp_frame_has_frags(xdpf)) {
 >> +			nr_frags = sinfo->nr_frags;
 >> +			total_len += sinfo->xdp_frags_size;
 >> +		}
 >> +		goto start_xdp;
 >
 > May be instead of doing this jump - just introduce a separate function
 > like `aq_map_xdp` specially for xdp case.
 >

I agree with it, I will separate it.

 >> +int aq_ring_rx_clean(struct aq_ring_s *self,
 >> +		     struct napi_struct *napi,
 >> +		     int *work_done,
 >> +		     int budget)
 >> +{
 >> +	if (static_branch_unlikely(&aq_xdp_locking_key))
 >> +		return __aq_ring_xdp_clean(self, napi, work_done, budget);
 >> +	else
 >> +		return __aq_ring_rx_clean(self, napi, work_done, budget);
 >> +}
 >
 > Is that really required to split into `xdp_clean` and `rx_clean` ?
 > They are very similar, may be try to unify?
 >

Yes, these two functions are similar.
But there is 2 reason.
1. flip strategy issue.
In order to use flip strategy, page reference count is 
used(page_ref_{inc | dec}).
The flip strategy can not be used when rx frame size is over 2K but 3K 
rx frame size is used if XDP is enabled.
So, if XDP is enabled, the flip strategy is always impossible therefore 
page_ref_inc() is unnecessary and expensive.
__aq_ring_xdp_clean() doesn't call page_ref_inc().

2. page_offset and page_order issue
When xdp is enabled, 0-order must be used and over 256 page_offset 
should be used.
But xdp is not enabled, multi-order can be used and 0 page_offset is used.
Because of different required values, I made separated functions.
Unifying them is I think possible, but logic would be more complex.

 > Regards,
 >    Igor

Thank you so much!

Taehee
