Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905AA2E788B
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 13:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgL3MbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 07:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgL3MbK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Dec 2020 07:31:10 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F5ECC06179B
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:30:30 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id 19so13703430qkm.8
        for <netdev@vger.kernel.org>; Wed, 30 Dec 2020 04:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YQcFI5pwFnCR/lxsJDtFdVGybJ7BlJDdpeZ+VPboYXA=;
        b=NwqQ5d7PzMXlE+JWzXrVpJuGwutrbgC8Sj9QXhPkNVyVdDGztI9Byr/M4HTu8GKHDY
         EHYnHAlu/8x7YMf/rRguMSNazy0Rwq7UJ5UsIS9DqLlNYS0atwcOlVIx7QPw2mxZTZMF
         sw41pJn5D9t7YVvAL6rUpzE2ytqLWas+38xxe937HRi/uegIPaujOwXcvPLVmcqip6t1
         H0gEBKJlEblDRCOZiVwJabXqFlISc1iCWnD2YML5/Ua3WkGGrWlW/CcpyiWzpteeY2Hv
         l+/PfQLV+24DLZlj/KU3IfncK6xtjobv8AqkBLHOHowRZmhxJqKnHQlDkxymcgoICJxT
         rk9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YQcFI5pwFnCR/lxsJDtFdVGybJ7BlJDdpeZ+VPboYXA=;
        b=kWQ3GgmX5Q2FaXMUKwRJGULixxyXI3oyyLGqsJbIW0tdQhRQkkAMqpNYai0KqnBsqA
         cfz/v6GZdYrMRktu3dmBo6pK64WMcZkKUJ9+WxfGM7V8rYA9X8fH7a1MEAL10zxjoa6J
         ymyMxjwwFLEBpuAONrRTg64/3OIF1XSkWq0a4iR9yjNPOMmqa9wRgq5+UW1u1VKfdtPu
         LmtzQI301ZTPgW/r9AaSJNbMqpY0qPcOyGtHwraxg0JMQymomEQ+75voo22g0NIGzMs1
         X871Cny408U6TBI+BqGYa9vv1dnnE3+nlYR0ESFChmhX8O74rZf2U5agwKculmK3hE7o
         lgzg==
X-Gm-Message-State: AOAM530hT0zdbi0wjNSmjbUeRTxGz2eOuEblBfE6blpVH2LhHB8oVQBr
        bWA3sTHe90+1imgdOwxk+VI=
X-Google-Smtp-Source: ABdhPJxsAQrfXiVGxK7g3vS/PmvvI+xQBVDpATeIUtumoaMOuQnH2ddh7cqRBSM9xQdOuu7HLG5NJw==
X-Received: by 2002:a37:4889:: with SMTP id v131mr37613631qka.410.1609331429763;
        Wed, 30 Dec 2020 04:30:29 -0800 (PST)
Received: from hoboy.vegasvil.org (c-76-110-219-245.hsd1.fl.comcast.net. [76.110.219.245])
        by smtp.gmail.com with ESMTPSA id j29sm26688893qtv.11.2020.12.30.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Dec 2020 04:30:29 -0800 (PST)
Date:   Wed, 30 Dec 2020 04:30:26 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH rfc 2/3] virtio-net: support receive timestamp
Message-ID: <20201230123026.GA2034@hoboy.vegasvil.org>
References: <20201228162233.2032571-1-willemdebruijn.kernel@gmail.com>
 <20201228162233.2032571-3-willemdebruijn.kernel@gmail.com>
 <20201228145953.08673c8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSe630QvTRM-0fnz=B+QRfii=sbsb-Qp5tTc2zbMgxcQyw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 28, 2020 at 07:57:20PM -0500, Willem de Bruijn wrote:
> There is a well understood method for synchronizing guest and host
> clock in KVM using ptp_kvm. For virtual environments without NIC
> hardware offload, the when host timestamps in software, this suffices.
> 
> Syncing host with NIC is assumed if the host advertises the feature
> and implements using real hardware timestamps.

Sounds reasonable.

Thanks,
Richard
