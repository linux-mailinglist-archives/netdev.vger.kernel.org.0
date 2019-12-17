Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB62123029
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 16:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfLQPXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 10:23:20 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38164 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbfLQPXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 10:23:20 -0500
Received: by mail-wm1-f65.google.com with SMTP id u2so3613329wmc.3;
        Tue, 17 Dec 2019 07:23:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=j8BDIpO9Zy1hRZoBINSyR5TXnQqjD5E22aWmsf8ruxo=;
        b=UGTXGKzYVc92j9svo2QPONDpjxKYdC+YMbRjWlp6OQ+pbSTxgMQ6Hb2XoibEcy/KNV
         YUn++t4ETC2w5ufGVLe0FgyCycb2BW4FVucz1tz/qlRAgb/U5W8jJXnToWSArUsifzp8
         WN5SOk0CMvBXVOKkR7lWzasZhCXXwWz7l+9FpZhuwlyopUsTFFEpCcvxfzhK1xNJ0HDp
         smaEiJH4lVW9bCSWK1Fh9+Ipdxmoda+F23lGj/i652rhAMaW+AneVr4jwuviJZwwH7zG
         PqaMK4UoofRY1BLjreTX/053ttHcaWBbi+YEA2Fe+LC+lYzeLg/ZFV0Zut3bfBod6R4y
         t1aw==
X-Gm-Message-State: APjAAAUU94TS7NWQQq5LrYMLROdaPjJnrdp+6fnSCLwCk6NJh3HdpUkq
        gwoq9Gav0dAG0jh43g8Sho8=
X-Google-Smtp-Source: APXvYqxykdupmaaJlCGhZTu9d3ZjUfBJpeEMVH/5yMAA143BPmfWgEIabGlr18MOEXLHNQaeKr3mGA==
X-Received: by 2002:a7b:c051:: with SMTP id u17mr6042189wmc.174.1576596197992;
        Tue, 17 Dec 2019 07:23:17 -0800 (PST)
Received: from debian (38.163.200.146.dyn.plus.net. [146.200.163.38])
        by smtp.gmail.com with ESMTPSA id w13sm25989787wru.38.2019.12.17.07.23.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 07:23:17 -0800 (PST)
Date:   Tue, 17 Dec 2019 15:23:15 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paul Durrant <pdurrant@amazon.com>
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 2/3] xen-netback: switch state to InitWait at
 the end of netback_probe()...
Message-ID: <20191217152315.gxsi4idfxnmloe6u@debian>
References: <20191217133218.27085-1-pdurrant@amazon.com>
 <20191217133218.27085-3-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191217133218.27085-3-pdurrant@amazon.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 01:32:17PM +0000, Paul Durrant wrote:
> ...as the comment above the function states.
> 
> The switch to Initialising at the start of the function is somewhat bogus
> as the toolstack will have set that initial state anyway. To behave
> correctly, a backend should switch to InitWait once it has set up all
> xenstore values that may be required by a initialising frontend. This
> patch calls backend_switch_state() to make the transition at the
> appropriate point.
> 
> NOTE: backend_switch_state() ignores errors from xenbus_switch_state()
>       and so this patch removes an error path from netback_probe(). This
>       means a failure to change state at this stage (in the absence of
>       other failures) will leave the device instantiated. This is highly
>       unlikley to happen as a failure to change state would indicate a
>       failure to write to xenstore, and that will trigger other error
>       paths. Also, a 'stuck' device can still be cleaned up using 'unbind'
>       in any case.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Acked-by: Wei Liu <wei.liu@kernel.org>
