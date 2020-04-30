Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101301C0300
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726580AbgD3Qqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726309AbgD3Qqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 12:46:53 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05E0C035494;
        Thu, 30 Apr 2020 09:46:53 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id di6so3327249qvb.10;
        Thu, 30 Apr 2020 09:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Knn2ggUc17IHYXiTAXE/FUGKOLLexAqmCT7AElneZgY=;
        b=rQq7H6v2V3koy12H4McM2FmuEflGIKjFaYM/JhDn5EXpLUsYu1rUwTlXLQRWC+rXRm
         A2nWxzHL0P1txufo4mZ+9KEaeHscFmpkRFhZeC7+v5oxUGarhW8Hvcd6kGJSh+49a0hh
         hFB3zjqLPoDgXs2q/Dq8cF9+OTb61FCHfPHrcX3zbZ/a0Bs0XC2KrXzZPN8sC+486I5K
         oOKmKCqen2VjNyWUjfXIulB9lEpAv6sMKhXGBP8M1byQ6ddhj0jnyX81IUDZXreJtDim
         ta8UUW5cYrqll2pYbU8UTQE9PfI8mtarNtxPUQIYzPtvjn0wuzuNQ558wysX2x76s5Q+
         qKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Knn2ggUc17IHYXiTAXE/FUGKOLLexAqmCT7AElneZgY=;
        b=rT9apzGRUaWLKWB1iXfmHzIOmLCUya+ldFkY0a5J7zR8XUfpiDzLKyvbCyZKWbAP3C
         Vk1B1m0Suksho4heFkCqU7ZK7PwIvI4pjWQ34xqmNVkGjmaEq3qkp8KZemyCiAYBUHwI
         A8nMALRD5Na2NBj9vZ+APkqmFnnYFbn+O/xDa4KVCUCKVIOdb46DHiKasHsCk91IXgfg
         YQHrY46W/Lhk/VPsQJzOIqEKAUYGOCNh5sUql0ZSQtOw9pVMLKEpHY+Xn9HVK9NNdMWV
         xuUSEPQpHCyg3L9wW1YlSrJZAdcs/xOflJPZmxLD6NLrD254/0zBOF9kERvUQs/l3ehY
         mOZg==
X-Gm-Message-State: AGi0PuYqPurtElvV04rt1aOBL7UGZ7+XyzI6+FgKJ72LHSq/T1Bv7A0r
        Md0SLcvAVErjp0wT6Z0kha9EgGzuCV4=
X-Google-Smtp-Source: APiQypKh6PAiSvPGAaBxlrnC7B3xhMTlshp4LV/F1JdH8jGjPjjaDR3QhytvY2ITC4vcPlMSFvS6HA==
X-Received: by 2002:a05:6214:1462:: with SMTP id c2mr3885692qvy.202.1588265212361;
        Thu, 30 Apr 2020 09:46:52 -0700 (PDT)
Received: from localhost.localdomain ([138.204.25.205])
        by smtp.gmail.com with ESMTPSA id x18sm388211qkn.107.2020.04.30.09.46.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 09:46:51 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 2BB0EC4BC6; Thu, 30 Apr 2020 13:46:49 -0300 (-03)
Date:   Thu, 30 Apr 2020 13:46:49 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH 27/37] docs: networking: convert sctp.txt to ReST
Message-ID: <20200430164649.GB2470@localhost.localdomain>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
 <5bbbf00c3aba45253e9d6ba0efeaf34bf2a8450f.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5bbbf00c3aba45253e9d6ba0efeaf34bf2a8450f.1588261997.git.mchehab+huawei@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 06:04:22PM +0200, Mauro Carvalho Chehab wrote:
> - add SPDX header;
> - add a document title;
> - adjust identation, whitespaces and blank lines where needed;
> - add to networking/index.rst.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

> ---
>  Documentation/networking/index.rst            |  1 +
>  .../networking/{sctp.txt => sctp.rst}         | 37 +++++++++++--------
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 24 insertions(+), 16 deletions(-)
>  rename Documentation/networking/{sctp.txt => sctp.rst} (64%)
> 
> diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
> index cd307b9601fa..1761eb715061 100644
> --- a/Documentation/networking/index.rst
> +++ b/Documentation/networking/index.rst
> @@ -100,6 +100,7 @@ Contents:
>     rds
>     regulatory
>     rxrpc
> +   sctp
>  
>  .. only::  subproject and html
>  
> diff --git a/Documentation/networking/sctp.txt b/Documentation/networking/sctp.rst
> similarity index 64%
> rename from Documentation/networking/sctp.txt
> rename to Documentation/networking/sctp.rst
> index 97b810ca9082..9f4d9c8a925b 100644
> --- a/Documentation/networking/sctp.txt
> +++ b/Documentation/networking/sctp.rst
> @@ -1,35 +1,42 @@
> -Linux Kernel SCTP 
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=================
> +Linux Kernel SCTP
> +=================
>  
>  This is the current BETA release of the Linux Kernel SCTP reference
> -implementation.  
> +implementation.
>  
>  SCTP (Stream Control Transmission Protocol) is a IP based, message oriented,
>  reliable transport protocol, with congestion control, support for
>  transparent multi-homing, and multiple ordered streams of messages.
>  RFC2960 defines the core protocol.  The IETF SIGTRAN working group originally
> -developed the SCTP protocol and later handed the protocol over to the 
> -Transport Area (TSVWG) working group for the continued evolvement of SCTP as a 
> -general purpose transport.  
> +developed the SCTP protocol and later handed the protocol over to the
> +Transport Area (TSVWG) working group for the continued evolvement of SCTP as a
> +general purpose transport.
>  
> -See the IETF website (http://www.ietf.org) for further documents on SCTP. 
> -See http://www.ietf.org/rfc/rfc2960.txt 
> +See the IETF website (http://www.ietf.org) for further documents on SCTP.
> +See http://www.ietf.org/rfc/rfc2960.txt
>  
>  The initial project goal is to create an Linux kernel reference implementation
> -of SCTP that is RFC 2960 compliant and provides an programming interface 
> -referred to as the  UDP-style API of the Sockets Extensions for SCTP, as 
> -proposed in IETF Internet-Drafts.    
> +of SCTP that is RFC 2960 compliant and provides an programming interface
> +referred to as the  UDP-style API of the Sockets Extensions for SCTP, as
> +proposed in IETF Internet-Drafts.
>  
> -Caveats:  
> +Caveats
> +=======
>  
> --lksctp can be built as statically or as a module.  However, be aware that 
> -module removal of lksctp is not yet a safe activity.   
> +- lksctp can be built as statically or as a module.  However, be aware that
> +  module removal of lksctp is not yet a safe activity.
>  
> --There is tentative support for IPv6, but most work has gone towards 
> -implementation and testing lksctp on IPv4.   
> +- There is tentative support for IPv6, but most work has gone towards
> +  implementation and testing lksctp on IPv4.
>  
>  
>  For more information, please visit the lksctp project website:
> +
>     http://www.sf.net/projects/lksctp
>  
>  Or contact the lksctp developers through the mailing list:
> +
>     <linux-sctp@vger.kernel.org>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 93e1b253ae51..64789b29c085 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15044,7 +15044,7 @@ M:	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>  L:	linux-sctp@vger.kernel.org
>  S:	Maintained
>  W:	http://lksctp.sourceforge.net
> -F:	Documentation/networking/sctp.txt
> +F:	Documentation/networking/sctp.rst
>  F:	include/linux/sctp.h
>  F:	include/net/sctp/
>  F:	include/uapi/linux/sctp.h
> -- 
> 2.25.4
> 
