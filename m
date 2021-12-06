Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85AA46A667
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 20:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349338AbhLFUB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 15:01:29 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:48910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240525AbhLFUBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 15:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638820662;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WfkAqkTthdE/op9cQ8jt/dtR102yfTodO14RZHKBLZg=;
        b=OU/q4ZVwWFjbovMXBZ1crAdip9PEZeSVQpsb6ffRpsLkRXL+ZtjLTY4aHWttLil4ki3to9
        vCDdkgtjqL3Y1PJDifuSqzTSK/QYX7RsDoTib3nmTAG9X3+ile1RLOsqElpyx24za5wj17
        KyiXqagDk0mkiLnPgHHFRwAIgM1hDcE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-HXeQHulBMQO1vxi68n8SLA-1; Mon, 06 Dec 2021 14:57:41 -0500
X-MC-Unique: HXeQHulBMQO1vxi68n8SLA-1
Received: by mail-wm1-f70.google.com with SMTP id n16-20020a05600c3b9000b003331973fdbbso402287wms.0
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 11:57:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WfkAqkTthdE/op9cQ8jt/dtR102yfTodO14RZHKBLZg=;
        b=I2w6TkimoZi0v81GViPo4KI7HVYPGdJRqKXk7NdmDrkF2NJh5LZamKDIHABdMgoHIN
         5lVRCmzY3Xfs+QlwtLiymQon02gdTCVdqAKkd+GafwrVwj5/EgaWG7YW6VHphzMvLQNC
         M8vGoIKEIFtgW8F1hGqYeO70E9qpSF1o25MAVVTljfmDIHsTdahunrMK/H6TqCvzEKQe
         jV7wMZIu/+/mH6hQNg16A7bwD4lw3CD9gODBj0kSVN236c6NYBp8uQf8tHurupZ2Fukr
         IVv+ZPOWbwMeoIZFtT+DMaxiwdNODOJIXsj00+IIbeH8nPKXq7WmtPZWeQhO1EucVX/T
         tmGQ==
X-Gm-Message-State: AOAM533m81UmEWwRsC4bFoIxYCOOPuB+ogHe0zQTHvV7uHuOpa4XM8wR
        sQ4aOtJdHyExagvySart7AJPPxGi57WDemz2fLPxTKBTWlsnctzQ+beN5Xh2Yt6eGJUGAf75hSi
        wAL8IfwUSB66U/98d
X-Received: by 2002:a7b:c084:: with SMTP id r4mr829416wmh.107.1638820660594;
        Mon, 06 Dec 2021 11:57:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpGIw3zUaJMNPOHAb6JE+bPsPtADhFGvjSjg4OQQYmfe3GW8tCssoK0vsXjR8lm2sO0CYUyg==
X-Received: by 2002:a7b:c084:: with SMTP id r4mr829397wmh.107.1638820660449;
        Mon, 06 Dec 2021 11:57:40 -0800 (PST)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id m7sm320374wml.38.2021.12.06.11.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 11:57:39 -0800 (PST)
Date:   Mon, 6 Dec 2021 20:57:38 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net-next 0/4] inet: Separate DSCP from ECN bits using new
 dscp_t type
Message-ID: <20211206195738.GA7266@pc-4.home>
References: <cover.1638814614.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638814614.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 07:22:02PM +0100, Guillaume Nault wrote:
> Following my talk at LPC 2021 [1], here's a patch series whose
> objective is to start fixing the problems with how DSCP and ECN bits
> are handled in the kernel.

This is of course an RFC patch series, not meant for merging. Sorry for
the missing RFC tag in the subject (used the wrong script :/).

