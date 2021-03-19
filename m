Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A15DC342046
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCSOzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 10:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbhCSOzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 10:55:04 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4B7C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 07:55:04 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so8764247otn.10
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 07:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xebw3SGt/6+YlGF4faoohcZq28uMgQZbtx517F7en+s=;
        b=tiJXbmsHTjLydfkNc6feAeC2eUzCX7Wf2ToZqEr/BAiQuSDJ0OKT6xExUItNBKsGYB
         4vdssFEXMOiTHBW6kVrxB/jd9+K7z1n3fClaZymO4klMdBoLJxfCnNJI2lclkzYPWsUB
         WCyckNayJGSUnB1mgReQH2y3RJ7opnSuBuDgrP0VWlQBYDmXbEZ9GqAhuSF5ZLITtVjj
         owaqBISZchj5Rlv6l24TmX3TdpbZbiSr31ald82F1AaFaIB5FbEBhgct70mHeg8SKryl
         JMYrgsu4OXT046mjEM8MlQp/1JkkljBGdjQ+8F8djN7WE3bbOpzZhW8uLyemDMreIdO+
         neaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xebw3SGt/6+YlGF4faoohcZq28uMgQZbtx517F7en+s=;
        b=CFKYR6S0exiy0a7Yp315of3CIaBbWjR6QJJlNBZq55PJPAnRalpNCqO61qKL9PEC9K
         oYLUuVGkB31bTs3qr7vJ1HzZqmwuap5Rh1dkkaIc7agF3/LOu9CY9cIQ+1QPc7DJBjVp
         LT4Z/K3Jbisd0Z/7YRaOXJba+DGDWqnjOn7YJMqtDuR7QozCvBGUHGY3EQv6h2iVveQF
         32cVUU8yHUyv1wxjdpVYrFqR6NFd5uyhdMqX6svzWCPXkEhwdJOonUQLaUK6DGIRudTd
         qcIODea9CUcyGcuLg5rbewiLfmy6u6x4VoHdJdcJFcZJkJXjUwSTQzEWvJbtjPMPuIdt
         cS+g==
X-Gm-Message-State: AOAM533re8WA7fNm2fRauPQMZFSGGI4+tM/D67+0ScQ+Uomhnj6VsJVh
        TRqMO+A83zPmwQewKceALaI=
X-Google-Smtp-Source: ABdhPJz1WbNK5M7nQVim76i5IDtSTxCqyc5GW/W5E++fuu2mcPGCzDEs1uOObpKRf5EIxqodw7TYBg==
X-Received: by 2002:a05:6830:148c:: with SMTP id s12mr1470137otq.251.1616165704131;
        Fri, 19 Mar 2021 07:55:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e449:7854:b17:d432])
        by smtp.googlemail.com with ESMTPSA id t22sm1255709otl.49.2021.03.19.07.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 07:55:03 -0700 (PDT)
Subject: Re: [PATCH v3] icmp: support rfc5837
To:     ishaangandhi <ishaangandhi@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, willemb@google.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
Date:   Fri, 19 Mar 2021 08:55:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210317221959.4410-1-ishaangandhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 4:19 PM, ishaangandhi wrote:
> +void icmp_identify_arrival_interface(struct sk_buff *skb, struct net *net, int room,
> +				     char *icmph, int ip_version)
> +{
> +	unsigned int ext_len, orig_len, word_aligned_orig_len, offset, extra_space_needed,
> +		     if_index, mtu = 0, name_len = 0, name_subobj_len = 0;
> +	struct interface_ipv4_addr_sub_obj ip4_addr_subobj = {.addr = 0};
> +	struct interface_ipv6_addr_sub_obj ip6_addr_subobj;
> +	struct icmp_extobj_hdr *iio_hdr;
> +	struct inet6_ifaddr ip6_ifaddr;
> +	struct inet6_dev *dev6 = NULL;
> +	struct icmp_ext_hdr *ext_hdr;
> +	char *name = NULL, ctype;
> +	struct net_device *dev;
> +	void *subobj_offset;
> +
> +	skb_linearize(skb);
> +	if_index = inet_iif(skb);

inet_iif is an IPv4 helper; it should not be used for v6 skb's.

