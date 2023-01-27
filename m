Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BA967ED7E
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbjA0S1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:27:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235132AbjA0S1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:27:22 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE6186E80
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 10:26:37 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id m2so15542201ejb.8
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 10:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9u3WxTrZmLjukWHU6qX/2Cs4pf22iX78kD+Zj5KZkzQ=;
        b=VF8MIZMRjh0VziF43nm0lS32BCjkiMEYYnlGOrA9KB1IaDI2D890AG1BexMSOT8FEx
         usLk20megIFG3LA3FCpCFT/uJLla+3HW57DnaUsiONm/+d8y2NTSuBnARs1Tuk1Wcgo2
         PunzaXRetSfd5mmHINpa8B0LcDvbjR/Pa0qZE1tDs+lJEEP6whuAWuVlyz4pghwZBSOu
         RIPmnCfyvKoYyH5lG2SciV4XhJkwHx5wkXopH8hxe/zkhzRgO/Fl5qiWzIRFRoh24wA0
         BCQFk2vq9MoHOlWcBZPb5Kc7Fd4B9r9ZDWZ7WC0VypRGMW0niCHzQg1nWFmR7tm9dtbO
         iySw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9u3WxTrZmLjukWHU6qX/2Cs4pf22iX78kD+Zj5KZkzQ=;
        b=oUy24qfvEBBcLKVunyjVDart4+mAdR3vGjcSonL9nbnBq28nklOwfQA2wCioQvEAFc
         V5M+3X00kP4PetJU3tF2rKQmRTLqZgqxBPKwMjQoVr4OHzPeG20ZTZJy+lkV0zfawQoz
         /wb3iEYQ0fJxeF1Jk21nizTrmxMeZrqlv4SyJEaAAfAjbZ3Q550g/Tjys1CM8bI2GbdC
         tzDc4fzoNMD3+SCYl5DWbmDiHEy0pHeQiRxdpYykZrBq+nRQE25sNZFByfMwZZnzUBIJ
         Kv2rZ2Cd3haa304ZP6VTuBJPpsKXaZBfYZcyqAEJ7dn4z0mLcKP0uaUMVaZBXYs2azcH
         e4uQ==
X-Gm-Message-State: AO0yUKXlyZN9/9n+rZmKpOWU1tQZgmGKi6F5sReIK61etHwrvlX6c5XM
        m3uxLyYnw0mjRFO9kpr2YCaZXg==
X-Google-Smtp-Source: AK7set8T4qHcBkhDPpK2x7Q/9T7DKNSi8u1e8emZyrNWvdgrzXgXiSlteJaw68UBjnRj3tatPfj8yg==
X-Received: by 2002:a17:907:6e20:b0:87a:7097:ebcf with SMTP id sd32-20020a1709076e2000b0087a7097ebcfmr5717272ejc.42.1674843995235;
        Fri, 27 Jan 2023 10:26:35 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id my20-20020a1709065a5400b00878465f059dsm2643848ejc.59.2023.01.27.10.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 10:26:34 -0800 (PST)
Date:   Fri, 27 Jan 2023 19:26:33 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        xiyou.wangcong@gmail.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, vladbu@nvidia.com, simon.horman@corigine.com,
        stefanc@marvell.com, seong.kim@amd.com, mattyk@nvidia.com,
        dan.daly@intel.com, john.andy.fingerhut@intel.com
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
Message-ID: <Y9QXWSaAxl7Is0yz@nanopsycho>
References: <20230124170346.316866-1-jhs@mojatatu.com>
 <20230126153022.23bea5f2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126153022.23bea5f2@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 27, 2023 at 12:30:22AM CET, kuba@kernel.org wrote:
>On Tue, 24 Jan 2023 12:03:46 -0500 Jamal Hadi Salim wrote:
>> There have been many discussions and meetings since about 2015 in regards to
>> P4 over TC and now that the market has chosen P4 as the datapath specification
>> lingua franca
>
>Which market?
>
>Barely anyone understands the existing TC offloads. We'd need strong,
>and practical reasons to merge this. Speaking with my "have suffered
>thru the TC offloads working for a vendor" hat on, not the "junior
>maintainer" hat.

You talk about offload, yet I don't see any offload code in this RFC.
It's pure sw implementation.

But speaking about offload, how exactly do you plan to offload this
Jamal? AFAIK there is some HW-specific compiler magic needed to generate
HW acceptable blob. How exactly do you plan to deliver it to the driver?
If HW offload offload is the motivation for this RFC work and we cannot
pass the TC in kernel objects to drivers, I fail to see why exactly do
you need the SW implementation...

