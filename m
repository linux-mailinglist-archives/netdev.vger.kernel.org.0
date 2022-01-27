Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7BA49DB40
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 08:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237145AbiA0HNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 02:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237127AbiA0HNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 02:13:30 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1F0C061714
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:13:30 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z14-20020a17090ab10e00b001b6175d4040so944243pjq.0
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 23:13:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0+FLy4VlPHD8ULzDF1ai7GodNZWoMmiEa9tD/vQAMgo=;
        b=kUJukYkWKaLeBv3RBQNHpbukc6mEKO22Ug8PZt5y6XGDm3QTik5y0h6wMpfMjTXuj/
         RhggIXTrd9hLXcSxFuiMoxDZJxKyA1qUxt0U4M/zkmOg+BpkUF0VcuQ8QTVSnktDnSmv
         S6wNH0HnumHM12TF5WVcVv8MCiEmgEF/9Hvib7mDKXDt5+sKbcRQ9IAhbG9SCXfk4Zka
         VrCIfRBTdkTpIocfGqR/xLe/TG6vKEl4CpceVcI9Ig8FIHhTMZXMjEXwB0QTQLj8QlLf
         /O5b/hHfcDH52Loe9dAguX15lzB074VQ0ptPVqeFyIY6J0W/33cCRy6iNwulYRw4PFqg
         /8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0+FLy4VlPHD8ULzDF1ai7GodNZWoMmiEa9tD/vQAMgo=;
        b=ub7R0hwBJPmXhrJ6mRbcWLQLi7PmG0je0am9BQD+xIzRMeW83GGQwNuROg8AxQns6s
         HqsTR3iTwPABpvraHAwGFREeAUh6dDuoY0xICQCI8Yp4I8Qc/1dbHeuAiIJzmrGkvdbl
         clKgJd4zegf06aUnI7mNOjTLzQPjO72eDJC9UT5C63F0r4LZ3D69pF7GiVwPEri2GiiR
         iDBcgGWq0K35fVhD0JU9wJ55ponffwrtiTBFIxkWSqXRwOlKpGTtzUQY/aa4evepQ26d
         M1lt9oWJo0XNJrL2TBlPgFBBQMekaTnWX5r0TAoHUHr500zcTwFMWcY3N/h0tnWmKKO+
         o0ZA==
X-Gm-Message-State: AOAM531TARSuI/VYfEzPEEHVLke8AXLS05l1tqnhXDyWKqY+pkHmliRZ
        saw6cMpN/I1JnJwNM3nBYZE=
X-Google-Smtp-Source: ABdhPJwiBE6pI50+98dytWFEgeXP9XtIfBp5BVmlaz464xGNttTySnziKLm0zywczmqEa3PB/m43vQ==
X-Received: by 2002:a17:90b:2251:: with SMTP id hk17mr2825803pjb.25.1643267609924;
        Wed, 26 Jan 2022 23:13:29 -0800 (PST)
Received: from Laptop-X1 ([8.218.113.75])
        by smtp.gmail.com with ESMTPSA id t15sm10475193pgc.49.2022.01.26.23.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 23:13:29 -0800 (PST)
Date:   Thu, 27 Jan 2022 15:13:24 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC net-next 0/5] bonding: add IPv6 NS/NA monitor support
Message-ID: <YfJGFHiiSBJdbxL3@Laptop-X1>
References: <20220126073521.1313870-1-liuhangbin@gmail.com>
 <66d6c646-d71d-91d3-993c-fc542bf77e0f@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <66d6c646-d71d-91d3-993c-fc542bf77e0f@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 26, 2022 at 01:47:45PM +0200, Nikolay Aleksandrov wrote:
> Hi,
> I'd imagine such option to work alongside ARP, i.e. to be able to have both
> ARP and ND targets at the same time. On Rx you can choose which one to check
> based on the protocol, at Tx the same. Then you can reuse and extend most of the
> current arp procedures to handle IPv6 as well. And most of all remove these ifs
> all around the code:
> +		if (bond_slave_is_up(slave)) {
> +			if (bond_do_ns_validate(bond))
> +				bond_ns_send_all(bond, slave);
> +			else
> +				bond_arp_send_all(bond, slave);
> +		}
> 
> and just have one procedure that handles both if there are any targets for that protocol.
> That will completely remove the need for bond_do_ns_validate() helper.

Thanks, I will have a try.
> 
> Also define BOND_MAX_ND_TARGETS as BOND_MAX_ARP_TARGETS just for the namesake.

Ah, yes.
> 
> Another cosmetic nit: adjust for reverse xmas tree ordering of local variables all over.

OK, I will.

Thanks
Hangbin
