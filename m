Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE54B30E16D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 18:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhBCRtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 12:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbhBCRta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 12:49:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7582C061573;
        Wed,  3 Feb 2021 09:48:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id e9so283195plh.3;
        Wed, 03 Feb 2021 09:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m1LyiYHdemJUR2u45HV2aTv5ozbheynSZ5Ve7rAeRxs=;
        b=bDtC0yXAAFvXTUqWs+8cxETzTaciPeRTBDoQNHRMoMVI1a7Rbql3moyHQrsrF973Br
         Si2yR+C9ZXwltmU3gim8Ppm/SvamRt9Ij5WiDC0l6JO+/6xaR+nnu3EzxNK7dXLmx1NF
         thZfSrHBQZ9g9NkGsFiYkvR/TUqB5UDtV6xsAm9sla24I4KNOC0nyIDYjyhQ1OWZz8Mj
         xrtkJC66BSBy7EkFrrWJZ+oEF/IKKro9K3bn7thCTVST+PTf+UnpdUTiz2jMmgcz2Jef
         xfvhwfNqoJp8AvedmRrG66uyrTj6pBJYh9oh3J1j+bqX+c2IJ9wDZVNG7jXFCLXyq+/e
         3usQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m1LyiYHdemJUR2u45HV2aTv5ozbheynSZ5Ve7rAeRxs=;
        b=dNCpA0lUzw+9a7h+XDxZa54UWQiGYICNgc5dUD+tPn+kY3sheOL7AwpLCErgAKI62+
         y9fSj1htq0jSh5fULwwBbPo8H7FXLQZ/yfy4hMUEjSDWvV5M4Crzpl5Et/Nzo1IdJO/4
         Eo3dLXMjhUaiB5AX/WaclZxNzxWkq5WyicghZR+TqKTVkr5wtkLA5X4xYZIV0fGt+Op7
         N6lxtVBSwo1qX1UvxiophrsCfou3Jx6szXEswfOOjs9nXs9pHzuW8yFb7b6T42nsVkfP
         1+yXH65vLajR65PD5N8/1QOMEfAVV9FULmHU4Nt/4Xtz0kz37JipdWFhSbR8lppwHXJ1
         JNVg==
X-Gm-Message-State: AOAM530zINUH6gv1tcWVxU89MlVEQVExXmq5JQKq8O001BIrt1KIhhW6
        Mn/osuPkqzCofJ3Yd+WneXZwI/IWRTM=
X-Google-Smtp-Source: ABdhPJyZTiduwwhhycoFBuQqIKKIUY9a3XkNeEBYGPBsBRSt+BjRiebeKf2U+vBEa+efMq+YDwbJGw==
X-Received: by 2002:a17:902:ea91:b029:e1:8695:c199 with SMTP id x17-20020a170902ea91b02900e18695c199mr4190913plb.6.1612374529389;
        Wed, 03 Feb 2021 09:48:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:75f7])
        by smtp.gmail.com with ESMTPSA id n3sm3149052pfq.19.2021.02.03.09.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 09:48:48 -0800 (PST)
Date:   Wed, 3 Feb 2021 09:48:46 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch bpf-next 00/19] sock_map: add non-TCP and cross-protocol
 support
Message-ID: <20210203174846.gvhyv3hlrfnep7xe@ast-mbp.dhcp.thefacebook.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 02, 2021 at 08:16:17PM -0800, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Currently sockmap only fully supports TCP, UDP is partially supported
> as it is only allowed to add into sockmap. This patch extends sockmap
> with: 1) full UDP support; 2) full AF_UNIX dgram support; 3) cross
> protocol support. Our goal is to allow socket splice between AF_UNIX
> dgram and UDP.

Please expand on the use case. The 'splice between af_unix and udp'
doesn't tell me much. The selftest doesn't help to understand the scope either.
