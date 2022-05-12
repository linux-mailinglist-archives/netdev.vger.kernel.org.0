Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22376524807
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349245AbiELIjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240447AbiELIjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:39:44 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43AA126108;
        Thu, 12 May 2022 01:39:43 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q23so6214996wra.1;
        Thu, 12 May 2022 01:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PCs+Ktha+vtmFq4XrExb1Mfp7UobjBZfKORd/6xUEnQ=;
        b=iH0GrPY8XRZBVfl7obokvqEguSGfgHDNW8WAl7iOB+g/Tlurte7GKIvSy3OEiTVO04
         eeh/9EJnTUt6gzmU0bJjxim8YpzFs4XRKTC8P/aVgEsfaam05KCZbdiKxj29+g1xkBf2
         UswmbtAGRTFvqTtmGRyBTdOYcZ91J6QPLUDDL9SOMpFlBJobtcsSwimEIYKHDMDu7YNx
         1BVEe5l3GsRKpiGKl6dB3pC9DEHDcu+83r0s6ZCjgVOR2/pWwazCqY3XbkZXfdcQz8RU
         dWawCs8ihVRvFOIIN+xL2Nx6s/6O7CHzwkCSwJ30NXqCG6IpajUa2NASiP9w4dKNfVa3
         GKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PCs+Ktha+vtmFq4XrExb1Mfp7UobjBZfKORd/6xUEnQ=;
        b=t2sofQsL+h0qfX2aL995CLH3Ot3hXpQZk3cvTslM2r9TcedqVezSbqd9Opa0GKCkdq
         k/OSGvDRzc0nu5IMrp6cAPXkYtRoHxA/PCYqYygxQP4mzpl73nEoV1qwdgNrPYoJyxuq
         6mRu4sGJscedyZkmtVQ0JjHg00YMukJynGi6Q06noiGDr35QP4IFLFbCsxwO67d4SLZD
         XAg4WrHgoc5fVTscpIE8FihNR/BCUJEbxLTykqxaLz+Jcl2VvjIaRuMIWsBltomqFpcJ
         /jHt0iCMEw3Gnzlve4GKCUYY0KpjZCWh1Z9noTLvKgSLbRRZ6MtZasQgPJyhi4ItXner
         krNQ==
X-Gm-Message-State: AOAM530a9+X1cI9LMeaux4/FZW7nld8IfbhLLCp7EtshR473yvr+L+R4
        Yg7ZdiF2EXTSKa68xp8Hzu8=
X-Google-Smtp-Source: ABdhPJy4QFCs5Y2zJviQsqFOIlBsNYoUoAruuqg+WA6gkEtBygBCD5Bsi3bVQffDIbA1Z2Vm9UAlEw==
X-Received: by 2002:adf:f748:0:b0:20c:86d5:c343 with SMTP id z8-20020adff748000000b0020c86d5c343mr26423046wrp.477.1652344781737;
        Thu, 12 May 2022 01:39:41 -0700 (PDT)
Received: from [192.168.1.8] ([197.57.250.210])
        by smtp.gmail.com with ESMTPSA id c1-20020a5d4cc1000000b0020c5253d8ccsm3584868wrt.24.2022.05.12.01.39.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 01:39:41 -0700 (PDT)
Message-ID: <191b395a-996b-597e-4ee9-06722ac3c776@gmail.com>
Date:   Thu, 12 May 2022 10:39:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH net-next v6 2/2] net: vxlan: Add extack support to
 vxlan_fdb_delete
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, outreachy@lists.linux.dev,
        roopa@nvidia.com, jdenham@redhat.com, sbrivio@redhat.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, pabeni@redhat.com, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        shshaikh@marvell.com, manishc@marvell.com, razor@blackwall.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, GR-Linux-NIC-Dev@marvell.com,
        bridge@lists.linux-foundation.org
References: <cover.1651762829.git.eng.alaamohamedsoliman.am@gmail.com>
 <ac4b6c650b6519cc56baa32ef20415460a5aa8ee.1651762830.git.eng.alaamohamedsoliman.am@gmail.com>
 <20220509154603.4a7b4243@kernel.org>
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
In-Reply-To: <20220509154603.4a7b4243@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On ١٠‏/٥‏/٢٠٢٢ ٠٠:٤٦, Jakub Kicinski wrote:
> On Thu,  5 May 2022 17:09:58 +0200 Alaa Mohamed wrote:
>> +			NL_SET_ERR_MSG(extack,
>> +						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
> This continuation line still does not align with the opening bracket.
> Look here if your email client makes it hard to see:
>
> https://lore.kernel.org/all/ac4b6c650b6519cc56baa32ef20415460a5aa8ee.1651762830.git.eng.alaamohamedsoliman.am@gmail.com/
>
> Same story in patch 1:
>
>>   static int ocelot_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
>>   			       struct net_device *dev,
>> -			       const unsigned char *addr, u16 vid)
>> +			       const unsigned char *addr, u16 vid,
>> +				   struct netlink_ext_ack *extack)
> and here:
>
>>   static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
>>   			    struct net_device *dev,
>> -			    const unsigned char *addr, u16 vid)
>> +			    const unsigned char *addr, u16 vid,
>> +				struct netlink_ext_ack *extack)


I will fix it, thanks.

