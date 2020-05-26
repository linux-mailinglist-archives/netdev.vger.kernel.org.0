Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 480531E2E22
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 21:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403939AbgEZT1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 15:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391847AbgEZT1J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 15:27:09 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE46C03E96D
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:27:09 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id dh1so9993170qvb.13
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 12:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=85qoG62MPkq5O3EDIXGq3mbxpleLqQdGm28FvoRZ4/Q=;
        b=eh6xOwKTlrP2hswl2bnsJPIOIDYPK6RaD/dRAeEfghnQOmwjZXNldbmTo/SrxMNHVl
         ApCfZPMH0TAsc0w5Ru4CGx0N8ZWmm9ughSRewuKcmFxIjN+de+5aCWgiyqelQuULXN4G
         SP5dxT24cuOZKC/6GVJnRBAmkvYRsk5HvkXTkTc9kNxbMZzlreDQXcI8POe0F5QQyrm1
         em1CP2ft7HElAIqvlkKAnTbeXJ4WyntuNnByiNJlSa4vGFFKQ8RRiGZgBGZBW6QNRdRz
         bjYutky0w6S9u8K9jSamH1/nEQlCB/PUCRjd+VaGp3yY6PUTrLY7MuvG1iNtRbUupR9v
         HiSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=85qoG62MPkq5O3EDIXGq3mbxpleLqQdGm28FvoRZ4/Q=;
        b=Dp/1zncVGQpCzXEVqelisDRSyx7a9JDcUcQmWPeY5QlfnpfwxcDhpOOwYQSMPEWdJh
         u/jq90RFoJq9S0l7JpTQYFBd077UfFkTIkcs8axo58qNNj703CpJpgS+W1RcZJtlqJ4y
         l0ufjVI2u5wF8984O1iH6zfpp793yME1ubrS4uujBGpPT61gq8eGyjeNMko4Idw1OOgu
         yXrRvX60QCHDTc3WOdXIaoLzTeqXZ+C/wPuD+V5clFoVVTGVDaR6Aq/92N77+/6nWet1
         dSbHxP2thnofKGtIk9UI2qE6DbMWXCrEfxVgnSgrudZqHAriHy5sSMygz54OfnpXfpCT
         vK1Q==
X-Gm-Message-State: AOAM5301W+9T/clIwAOgPuJlLwxElHWqPS2PyekJQzblD7o3Ry1npeMn
        rliAfshZ3i77scITFMY/+eU=
X-Google-Smtp-Source: ABdhPJyFQAwHVTbGsK73cWZJynx5KmVShsQowL19zyKJ76TRSNbQV6ycb3MKUj5txcRXkAJTlJuoWg==
X-Received: by 2002:a0c:eacb:: with SMTP id y11mr21467128qvp.141.1590521228483;
        Tue, 26 May 2020 12:27:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id c197sm448724qkg.133.2020.05.26.12.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 12:27:07 -0700 (PDT)
Subject: Re: [net-next 07/10] net/mlx5e: Add support for hw encapsulation of
 MPLS over UDP
To:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
References: <20200522235148.28987-1-saeedm@mellanox.com>
 <20200522235148.28987-8-saeedm@mellanox.com>
 <20200526121920.7f5836e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <97ec57bc-c46d-f9ca-037a-a9e07ad0fc08@gmail.com>
Date:   Tue, 26 May 2020 13:27:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200526121920.7f5836e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/20 1:19 PM, Jakub Kicinski wrote:
> On Fri, 22 May 2020 16:51:45 -0700 Saeed Mahameed wrote:
>> +static inline __be32 mpls_label_id_field(__be32 label, u8 tos, u8 ttl)
>> +{
>> +	u32 res;
>> +
>> +	/* mpls label is 32 bits long and construction as follows:
>> +	 * 20 bits label
>> +	 * 3 bits tos
>> +	 * 1 bit bottom of stack. Since we support only one label, this bit is
>> +	 *       always set.
>> +	 * 8 bits TTL
>> +	 */
>> +	res = be32_to_cpu(label) << 12 | 1 << 8 | (tos & 7) <<  9 | ttl;
>> +	return cpu_to_be32(res);
>> +}
> 
> No static inlines in C source, please. Besides this belongs in the mpls
> header, it's a generic helper.
> 

net/mpls/internal.h:

static inline struct mpls_shim_hdr mpls_entry_encode(u32 label, unsigned
ttl, unsigned tc, bool bos)
{
        struct mpls_shim_hdr result;
        result.label_stack_entry =
                cpu_to_be32((label << MPLS_LS_LABEL_SHIFT) |
                            (tc << MPLS_LS_TC_SHIFT) |
                            (bos ? (1 << MPLS_LS_S_SHIFT) : 0) |
                            (ttl << MPLS_LS_TTL_SHIFT));
        return result;
}

perhaps that can be moved to include/net/mpls.h
